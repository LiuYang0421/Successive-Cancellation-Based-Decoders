`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/22 20:49:41
// Design Name: 
// Module Name: Register_Controller
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


module Register_Controller(
    clk,
    rst_n,
    data_valid,
    decoder_busy,
    decoder_done,
    channel_register_data,
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
          data_valid,
          decoder_busy,
          decoder_done;
    input[((2**n)*Q)-1:0] channel_register_data;
    input channel_register_rd_en;
    input[(2**(n-p-1))-1:0] channel_register_address;
    output reg[((2**(p+1))*Q)-1:0] dout;
    output reg channel_register_ready;
    
    //Control of channel_register_ready
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            channel_register_ready <= 0;
        end
        
        else if(data_valid)
        begin
            channel_register_ready <= 1;
        end
        
        else if(decoder_done)
        begin
            channel_register_ready <= 0;
        end
        
        else
        begin
            channel_register_ready <= channel_register_ready;
        end
    end
    
    //Control of dout(Output selected 2P LLRs)
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            dout <= 0;
        end
        
        else if(decoder_busy && channel_register_rd_en)
        begin
            dout <= channel_register_data[channel_register_address*(2**(p+1))*Q+:(2**(p+1))*Q];
        end
        
        else
        begin
            dout <= 0;
        end
    end
endmodule

