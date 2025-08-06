`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/06 17:19:01
// Design Name: 
// Module Name: Partial_Sum_Network
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


module Partial_Sum_Network(
    clk,
    en,
    rst,
    u,
    S
    );
    
    parameter n = 2;
    
    input clk;
    input en;
    input rst;
    input u;
    output reg[(2**n)-1:0] S;
    
    wire[(2**n)-1:0] G;
    wire[(2**n)-1:0] uG;
    
    Matrix_Generator #(
        .n(n)
        )
        Matrix_Generator1(
        .clk(clk),
        .en(en),
        .rst(rst),
        .G(G)
        );
        
    generate
    genvar i;
        for(i=0;i<(2**n);i=i+1)
        begin
            assign uG[i] = u && G[i];
        end
    endgenerate
    
    generate
    genvar j;
        for(j=0;j<(2**n);j=j+1)
        begin
            always@(posedge clk)
            begin
                if(rst)
                begin
                    S[j] <= 0;  
                end
                
                else if(en)
                begin
                    S[j] <= S[j] ^ uG[j];                                 
                end
                
                else
                begin
                    S <= S;
                end
            end
        end
    endgenerate
endmodule
