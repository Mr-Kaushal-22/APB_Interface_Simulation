`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 12.02.2024 11:50:34
// Design Name: 
// Module Name: APB_Top
//////////////////////////////////////////////////////////////////////////////////


module APB_Top(
    input [8:0] apb_write_paddr,    // input from system bus to target the the slave and address of data write location
    input [8:0] apb_read_paddr,     // input from system bus to target the the slave and address of data read location
    input [7:0] apb_write_data,     // Write data input from system bus
    input presetn, pclk, read, write, transfer,  // Control signals from the system bus
    output [7:0] apb_read_data_out, // Read data from the APB slave to the system bus
    output pslverr                  // Error response for the system bus
    );
    
    wire [7:0] pwdata, prdata, prdata0, prdata1;
    wire [8:0] paddr;
    wire pready, pready0, pready1;
    wire penable, pwrite;
    wire psel0, psel1;
    
    assign pready = paddr[8] ? pready1 : pready0;
    
    assign prdata = read ? (paddr[8] ? prdata1 : prdata0 ) : 8'bx;
    
     
     
     APB_Bridge master(
        .apb_write_paddr(apb_write_paddr),
        .apb_read_paddr(apb_read_paddr), 
        .apb_write_data(apb_write_data),  
        .prdata(prdata),  
        .presetn(presetn), 
        .pclk(pclk), 
        .read(read), 
        .write(write), 
        .transfer(transfer),  
        .pready(pready),
        .psel0(psel0), 
        .psel1(psel1),   
        .penable(penable),          
        .paddr(paddr),       
        .pwrite(pwrite),          
        .pwdata(pwdata),     
        .apb_read_data_out(apb_read_data_out), 
        .pslverr(pslverr)
        );
        
    APB_Slave slave_0(
        .pclk(pclk), 
        .presetn(presetn),
        .penable(penable),
        .psel(psel0), 
        .pwrite(pwrite),
        .paddr(paddr),      
        .pwdata(pwdata),
        .prdata(prdata0),
        .pready(pready0)
        );
    
    APB_Slave slave_1(
        .pclk(pclk), 
        .presetn(presetn),
        .penable(penable),
        .psel(psel1), 
        .pwrite(pwrite),
        .paddr(paddr),      
        .pwdata(pwdata),
        .prdata(prdata1),
        .pready(pready1)
        );
            
endmodule
