`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2024 12:17:55
// Design Name: 
// Module Name: APB_Testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module APB_Testbench();
    reg [8:0] apb_write_paddr;
    reg [8:0] apb_read_paddr; 
    reg [7:0] apb_write_data;
    reg presetn, pclk, read, write, transfer;
    wire [7:0] apb_read_data_out;
    wire pslverr;
    
    APB_Top top_1(apb_write_paddr, apb_read_paddr, apb_write_data, presetn, pclk, read, write, transfer, apb_read_data_out, pslverr);
    
    initial
    begin
        apb_write_paddr = 9'bx;
        apb_read_paddr = 9'bx;
        apb_write_data = 8'bx;
        presetn = 1;
        pclk = 0;
        read = 0;
        write = 0;
        transfer = 0;
    end
    
    always #5 pclk = ~pclk;
    
    initial
    begin
        #10 presetn = 0;
        #10 presetn = 1;
        #10 transfer = 1;
            write = 1;
            apb_write_paddr = 9'h01a;
            apb_write_data = 8'hab;
        
        #20 transfer = 0;
            write = 0;
            apb_write_paddr = 9'hx;
            apb_write_data = 8'hx;
            
        #30 transfer = 1;
            read = 1;
            apb_read_paddr = 9'h01a;
        
        #20 transfer = 0;
            read = 0;
            apb_read_paddr = 9'hx;
            
        #30 transfer = 1;
            write = 1;
            apb_write_paddr = 9'h12b;
            apb_write_data = 8'h12;
        
        #20 transfer = 0;
            write = 0;
            apb_write_paddr = 9'hx;
            apb_write_data = 8'hx;
            
        #30 transfer = 1;
            read = 1;
            apb_read_paddr = 9'h12b;
        
        #20 transfer = 0;
            read = 0;
            apb_read_paddr = 9'hx;
        
    end
    
    
    
    initial #300 $finish;
   
endmodule
