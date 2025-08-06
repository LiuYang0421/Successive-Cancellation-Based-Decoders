`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/07 00:07:27
// Design Name: 
// Module Name: Decider
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


module Decider(
    LLR_SIGN,
    frozen_bit_indication,
    decoded_bit
    );
    
    input LLR_SIGN;
    input frozen_bit_indication;
    output decoded_bit;
    
    assign decoded_bit = LLR_SIGN && frozen_bit_indication;
endmodule
