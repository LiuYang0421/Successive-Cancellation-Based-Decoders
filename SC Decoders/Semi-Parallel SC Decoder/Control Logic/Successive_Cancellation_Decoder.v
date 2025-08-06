`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/23 00:26:17
// Design Name: 
// Module Name: Bit_Index_Accumulator
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


module Bit_Index_Accumulator(
    clk,
    rst_n,
    en,
    stage_index,
    bit_index,
    bit_index_r0,
    bit_index_r1
    );
    
    parameter n = 3;
    
    input                                       clk,
                                                rst_n,
                                                en;
    input               [$clog2(n)-1:0]         stage_index;
    output reg          [n-1:0]                 bit_index,
                                                bit_index_r0,
                                                bit_index_r1;
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            bit_index <= 0;
        end
        
        else if((en == 1) && (stage_index == 0))
        begin
            bit_index <= bit_index + 1;
        end
        
        else
        begin
            bit_index <= bit_index;
        end
    end
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            bit_index_r0 <= 0;
            bit_index_r1 <= 0;
        end
        
        else
        begin
            bit_index_r0 <= bit_index;
            bit_index_r1 <= bit_index_r0;
        end
    end
endmodule
