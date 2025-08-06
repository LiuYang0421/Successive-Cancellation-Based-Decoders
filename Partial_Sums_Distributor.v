`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/26 16:13:02
// Design Name: 
// Module Name: Partial_Sums_Distributor
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


module Partial_Sums_Distributor(
    clk,
    rst_n,
    en,
    decoder_busy,
    bit_index,
    stage_index,
    exe_index,
    psn_rst,
    psn_en,
    distribute_vector
    );
    
    parameter n = 3;
    parameter p = 1;
    
    input                                   clk,
                                            rst_n,
                                            en,
                                            decoder_busy;
    input               [n-1:0]             bit_index;
    input               [$clog2(n)-1:0]     stage_index;
    input               [n-p-1:0]           exe_index;
    output reg                              psn_rst, //Reset signal to Partial Sums Network(synchronous)
                                            psn_en; //Enable signal to Partial Sums Network
    output reg          [(2**n)-1:0]        distribute_vector; //Control vector to MUXs which distribute Partial Sums to PEs
    
    (*keep="true"*)reg  [n-1:0]             bit_index_r0;
    (*keep="true"*)reg  [$clog2(n)-1:0]     stage_index_r0;
    (*keep="true"*)reg  [n-p-1:0]           exe_index_r0;

    reg                 [n-2:0]             partial_sums_used;
                                            
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            bit_index_r0 <= 0;
            stage_index_r0 <= n - 1;
            exe_index_r0 <= 2**(n-p-1);
        end
        
        else
        begin
            bit_index_r0 <= bit_index;
            stage_index_r0 <= stage_index;
            exe_index_r0 <= exe_index;
        end
    end
                    
    //Control of psn_rst
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            psn_rst <= 1;
        end
        
        else if((en == 1) && (decoder_busy == 0))
        begin
            psn_rst <= 1;
        end
        
        else
        begin
            psn_rst <= 0;
        end
    end
    
    //Control of psn_en
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            psn_en <= 0;
        end
        
        else if(stage_index_r0 == 0)
        begin
            psn_en <= 1;
        end
        
        else
        begin
            psn_en <= 0;
        end
    end
    
    //Control of distribute_vector
    //Pipeline
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            partial_sums_used <= 0;
        end
        
        else
        begin
            if(stage_index >= p)
            begin
                partial_sums_used <= (1<<p)*exe_index;
            end
            
            else
            begin
                partial_sums_used <= 1<<stage_index;
            end
        end
    end
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            distribute_vector <= 0;
        end
        
        else
        begin
            distribute_vector <= 1<<(bit_index_r0 - partial_sums_used);
        end
    end
endmodule
