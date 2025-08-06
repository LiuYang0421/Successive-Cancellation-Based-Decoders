`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/06 15:06:59
// Design Name: 
// Module Name: Decoded_Bit_Register
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


module Decoded_Bit_Register(
    clk,
    rst_n,
    decoded_bit,
    bit_index,
    data_valid,
    rd_en,
    decoded_code
    );
    
    parameter n = 3;
    
    input clk;
    input rst_n;
    input decoded_bit;
    input[n-1:0] bit_index;
    input data_valid;
    input rd_en;
    output[(2**n)-1:0] decoded_code;
    
    reg[(2**n)-1:0] decoded_code_register;
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            decoded_code_register <= 0;
        end
        
        else if(data_valid)
        begin
            decoded_code_register[bit_index] <= decoded_bit;
        end
    end
    
    assign decoded_code = (rd_en) ? decoded_code_register : 0;
endmodule
