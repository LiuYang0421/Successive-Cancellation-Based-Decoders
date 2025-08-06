`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/06 22:13:58
// Design Name: 
// Module Name: Matrix_Generator
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


module Matrix_Generator(
    clk,
    en,
    rst,
    G
    );
    
    parameter n = 2;
    
    input clk;
    input en;
    input rst;
    output[(2**n)-1:0] G;
    
    reg[(2**n)-1:0] G;
    initial begin
        G = 1;
    end
    
    always@(posedge clk)
    begin
        if(rst)
        begin
            G = 1;
        end
        
        else if(en)
        begin
            G[(2**n)-1:1] <= G[(2**n)-2:0]^G[(2**n)-1:1];  
        end
        
        else
        begin
            G <= G;
        end
    end
endmodule
