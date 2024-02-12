`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Create Date: 12.02.2024 09:24:56
// Design Name: 
// Module Name: APB_Bridge
//////////////////////////////////////////////////////////////////////////////////


module APB_Bridge(
    input [8:0] apb_write_paddr,    // input from system bus to target the the slave and address of data write location
    input [8:0] apb_read_paddr,     // input from system bus to target the the slave and address of data read location
    input [7:0] apb_write_data,     // Write data input from system bus
    input [7:0] prdata,             // Read data input from the APB slave
    input presetn, pclk, read, write, transfer,  // Control signals from the system bus
    input pready,                   // Ready signal from the selected APB SLave
    
    output psel0, psel1,            // Select signal to select the APB slave 
    output reg penable,             // Strobe signal for slave to perform transfer
    output reg [8:0] paddr,         // Address for the APB slave where read and write transfer is going to happen
    output reg pwrite,              // Write and Read signal for APB slave
    output reg [7:0] pwdata,        // Write data to APB slave
    output reg [7:0] apb_read_data_out, // Read data from the APB slave to the system bus
    output pslverr                  // Error response for the system bus
    );
    
    reg [1:0] present_state, next_state;
    
    reg invalid_setup_error;
    reg setup_error, invalid_read_paddr, invalid_write_paddr, invalid_write_data;
    
    // FSM states
    parameter idle = 2'b00;
    parameter setup = 2'b01;
    parameter access = 2'b10;
    
    // To update the FSM states
    always @(posedge pclk)
    begin
        if(!presetn)
            present_state <= idle;
        else
            present_state <= next_state;
    end
    
    // Next state logic
    always @(present_state, transfer, pready)
    begin
        pwrite = write;
        
        case (present_state)
            idle:   begin   // ideal state
                        penable = 0;
                        if(!transfer)
                            next_state = idle;
                        else
                            next_state = setup; 
                    end
                    
            setup:  begin // Setup state in which assigning the read/write address and write data to APB bus
                        penable = 0;
                        if(read == 1'b1 && write == 1'b0)
                        begin
                            paddr = apb_read_paddr;
                            next_state = access;
                        end
                        else if(read == 1'b0 && write == 1'b1)
                        begin
                            paddr = apb_write_paddr;
                            pwdata = apb_write_data;
                            next_state = access;
                        end
                    end
                    
            access: begin // Access state to strobe the APB slave operations
                        if(psel0 || psel1)
                            penable = 1'b1;
                            
                        if(transfer & !pslverr) 
                        begin
                            if(pready) // If the selected slave is ready
                            begin
                                if(read == 1'b0 && write == 1'b1)
                                    next_state = setup;
                                else if(read == 1'b1 && write == 1'b0)
                                begin
                                    next_state = setup;
                                    apb_read_data_out = prdata; // Sampling the read data from APB Slave to system bus output
                                end
                            end
                            else
                                next_state = access;
                        end
                        else
                        begin
                            next_state = idle;
                            apb_read_data_out = 8'bx;
                        end
                    end
        endcase
    end
    
    
    // Logic to select the APB Slave (Decoding from the address of the system bus)
    assign {psel0, psel1} = ((present_state != idle) ? (paddr[8] ? {1'b0,1'b1} : {1'b1,1'b0}) : 2'b00);
    
    
    // PSLAVE Error logic 
    always @(*)
    begin
        invalid_setup_error = setup_error || invalid_read_paddr || invalid_write_paddr || invalid_write_data; // Combining all the errors in one error
        if(!presetn)
        begin
            setup_error = 0;
            invalid_read_paddr = 0;
            invalid_write_paddr = 0;
            invalid_write_data = 0;
        end
        else if(present_state == idle && next_state == access) // Invalid state transaction
        begin
            setup_error = 1;
        end
        else if((apb_write_data == 8'dx) && (read == 1'b0) && (write == 1'b1) && (present_state == setup || present_state == access)) // Write data is not provided by system bus
        begin
            invalid_write_data = 1;
        end
        else if((apb_read_paddr == 9'dx) && (read == 1'b1) && (write == 1'b0) && (present_state == setup || present_state == access)) // Read address is not provided by the system bus
        begin
            invalid_read_paddr = 1;
        end
        else if((apb_write_paddr == 9'dx) && (read == 1'b0) && (write == 1'b1) && (present_state == setup || present_state == access)) // write address is not provided by the system bus
        begin
            invalid_write_paddr = 1;
        end
        else
        begin
            invalid_write_paddr = 0;
            invalid_write_data = 0;
            invalid_read_paddr = 0;
        end    
    end
    
    assign pslverr = invalid_setup_error; // Error output to system bus
    
    
endmodule
