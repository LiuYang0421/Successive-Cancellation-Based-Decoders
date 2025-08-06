`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/02 22:54:38
// Design Name: 
// Module Name: Frozen_Bit_Buffer
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


module Frozen_Bit_Register(
    clk,
    rst_n,
    bit_index,
    data_valid,
    frozen_bit_indication
    );
    
    parameter n = 3;
    parameter frozen_bit = 255;
    
    input clk,
          rst_n;
    input[n-1:0] bit_index;
    input data_valid;
    output frozen_bit_indication;
    
    (*rom_style = "block" *) reg[(2**n)-1:0] frozen_bit_register;
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            frozen_bit_register <= frozen_bit;
        end
        
        else
        begin
            frozen_bit_register <= frozen_bit;
        end
    end
    
    //Default frozen bit value is 0
    assign frozen_bit_indication = (data_valid && !frozen_bit_register[bit_index]) ? 0 : 1;
endmodule
