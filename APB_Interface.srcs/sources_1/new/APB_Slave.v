`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 12.02.2024 11:04:53
// Design Name: 
// Module Name: APB_Slave 
//////////////////////////////////////////////////////////////////////////////////


module APB_Slave(
    input pclk, presetn,    // Clock and reset signal
    input penable,          // Strobe to perform operations
    input psel,             // To selects the slave
    input pwrite,           // Read/write control signal
    input [7:0] paddr,      // Address to read and write operation
    input [7:0] pwdata,     // Write data input
    output reg [7:0] prdata,// Read data output
    output reg pready       // Ready signal output to APB Bridge
    );
    
    reg [7:0] mem[63:0];
    
    
    always @(*)
    begin
        if(!presetn)
        begin
            pready = 0;
        end
        else
        begin
            if(psel && !penable && !pwrite)
                pready = 0;
            else if(psel && penable && !pwrite)
            begin
                pready = 1;
                prdata = mem[paddr];
            end
            else if(psel && !penable && pwrite)
                pready = 0;
            else if(psel && penable && pwrite)
            begin
                pready = 1;
                mem[paddr] = pwdata;
            end
            else 
                pready = 0;
        end
    end
    
endmodule
