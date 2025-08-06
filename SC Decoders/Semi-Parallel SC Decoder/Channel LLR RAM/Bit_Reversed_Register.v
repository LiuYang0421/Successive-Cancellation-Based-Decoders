`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/21 22:49:43
// Design Name: 
// Module Name: Bit_Reversed_Register
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


module Bit_Reversed_Register(
    clk,
    rst_n,
    data_valid,
    decoder_busy,
    decoder_done,
    din,
    channel_register_rd_en,
    channel_register_address,
    dout,
    channel_register_ready
    );
    
    parameter n = 3;
    parameter p = 1;
    parameter Q = 6;
    
    input clk,
          rst_n,
          decoder_busy,
          decoder_done,
          data_valid;
    input[((2**n)*Q)-1:0] din;
    input channel_register_rd_en;
    input[(2**(n-p-1))-1:0] channel_register_address;
    output[((2**(p+1))*Q)-1:0] dout;
    output channel_register_ready;    
    
    wire[((2**n)*Q)-1:0] channel_register_data;
    
    Bit_Reversed_Mapping #(
        .n(n),
        .Q(Q)
        )
        Bit_Reversed_Mapping(
        .clk(clk),
        .rst_n(rst_n),
        .data_valid(data_valid),
        .decoder_busy(decoder_busy),
        .din(din),
        .channel_register_data(channel_register_data)
    );
    
    Register_Controller #(
        .n(n),
        .p(p),
        .Q(Q)
        )
        Register_Controller(
        .clk(clk),
        .rst_n(rst_n),
        .data_valid(data_valid),
        .decoder_busy(decoder_busy),
        .decoder_done(decoder_done),
        .channel_register_data(channel_register_data),
        .channel_register_rd_en(channel_register_rd_en),
        .channel_register_address(channel_register_address),
        .dout(dout),
        .channel_register_ready(channel_register_ready)
    );
endmodule   
