`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/26 22:10:27
// Design Name: 
// Module Name: Partial_Sums_Distribute_Network
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


module Partial_Sums_Distribute_Network(
    S,
    distribute_vector,
    partial_sums_output
    );
    
    parameter n = 3;
    parameter p = 1;
    
    input[(2**n)-1:0] S;
    input[(2**n)-1:0] distribute_vector;
    output[(2**p)-1:0] partial_sums_output;
    
    genvar i,j;
    generate
        for(i=0;i<(2**p);i=i+1)
        begin
            assign partial_sums_output[i] = | (S & (distribute_vector<<i));
        end
    endgenerate
endmodule
