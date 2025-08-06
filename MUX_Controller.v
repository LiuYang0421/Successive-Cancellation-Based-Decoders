`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/10 19:48:42
// Design Name: 
// Module Name: MUX_Controller
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


module MUX_Controller(
    clk,
    rst_n,
    bit_index,
    stage_index,
    reg_ram_data_select,
    function_select
    );
    
    parameter n = 3;
    parameter p = 1;
    
    input                                       clk;
    input                                       rst_n;
    input               [n-1:0]                 bit_index;
    input               [$clog2(n)-1:0]         stage_index;
    output                                      reg_ram_data_select;
    output                                      function_select;
    
    (*keep="true"*)reg  [n-1:0]                 bit_index_r0,
                                                bit_index_r1;
    (*keep="true"*)reg  [$clog2(n)-1:0]         stage_index_r0,
                                                stage_index_r1;                                            
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            bit_index_r0 <= 0;
            bit_index_r1 <= 0;
            stage_index_r0 <= n - 1;
            stage_index_r1 <= n - 1;
        end
        
        else
        begin
            bit_index_r0 <= bit_index;
            bit_index_r1 <= bit_index_r0;
            stage_index_r0 <= stage_index;
            stage_index_r1 <= stage_index_r0;
        end
    end
    
    //Select Channel LLRs or Calculated LLRs. 1:Channel LLRs 0:Calculated LLRs
    assign reg_ram_data_select = (stage_index_r1 == n-1) ? 1 : 0;
    
    //Select calculated LLRs result from PEs. 1:g function 0:f function
    assign function_select = bit_index_r1[stage_index_r1];
endmodule
