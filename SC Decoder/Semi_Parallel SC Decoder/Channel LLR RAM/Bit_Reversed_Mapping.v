`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/22 18:04:20
// Design Name: 
// Module Name: Bit_Reversed_Mapping
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


module Bit_Reversed_Mapping(
    clk,
    rst_n,
    data_valid,
    decoder_busy,
    din,
    channel_register_data
    );
    
    parameter n = 3;
    parameter Q = 6;
    
    input clk,
          rst_n,
          data_valid,
          decoder_busy;
    input[((2**n)*Q)-1:0] din;
    output[((2**n)*Q)-1:0] channel_register_data;
    
    reg[Q-1:0] channel_register[(2**n)-1:0];
    reg[n-1:0] address_mapping[(2**n)-1:0];
    
    //Address Mapping
    integer i,j;
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            for(i=0;i<(2**n);i=i+1)
            begin
                for(j=0;j<n;j=j+1)
                begin
                    address_mapping[i][n-j-1] <= i[j];
                end
            end
        end
        
        else
        begin
            for(i=0;i<(2**n);i=i+1)
            begin
                for(j=0;j<n;j=j+1)
                begin
                    address_mapping[i][n-j-1] <= i[j];
                end
            end
        end
    end
    
    //Data Mapping
    integer k;
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            for(k=0;k<(2**n);k=k+1)
            begin:channel_register_reset
                channel_register[k] <= 0;
            end
        end
           
        else if(data_valid && (!decoder_busy))
        begin
            for(k=0;k<(2**n);k=k+1)
            begin:write_operation
                channel_register[address_mapping[k]] <= din[k*Q+:Q];
            end
        end
        
        else
        begin
            for(k=0;k<(2**n);k=k+1)
            begin
                channel_register[k] <= channel_register[k];
            end
        end       
    end
    
    //Output port of channel_register
    genvar l;
    generate
        for(l=0;l<(2**n);l=l+1)
        begin
            assign channel_register_data[l*Q+:Q] = channel_register[l];
        end
    endgenerate
endmodule
