`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/20 00:45:45
// Design Name: 
// Module Name: Write_Port_Controller
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


module Write_Port_Controller(
    clk,
    en,
    rst_n,
    decoder_busy,   
    stage_index,
    exe_index,
    wr_en,
    wr_addr
    );
    
    parameter n = 3;
    parameter p = 1;
    
    localparam ADDR_WIDTH = $clog2(2**(n-p)-2+p);
    
    input                                       clk,
                                                en,
                                                rst_n,
                                                decoder_busy;
    input               [$clog2(n)-1:0]         stage_index;
    input               [n-p-1:0]               exe_index; 
    output reg                                  wr_en;
    output reg          [ADDR_WIDTH-1:0]        wr_addr;
    
    (*keep="true"*)reg  [$clog2(n)-1:0]         stage_index_r0;
    (*keep="true"*)reg  [n-p-1:0]               exe_index_r0;
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            stage_index_r0 <= n - 1;
            exe_index_r0 <= 2**(n-p-1);
        end
        
        else
        begin
            stage_index_r0 <= stage_index;
            exe_index_r0 <= exe_index;
        end
    end
    
    //Control of wr_en
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            wr_en <= 0;
        end
        
        else if((decoder_busy == 1) && (stage_index_r0 != 0) && (en == 1))
        begin
            wr_en <= 1;
        end
        
        else
        begin
            wr_en <= 0;
        end
    end
    
    //Control of wr_addr
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            wr_addr <= 0;
        end
        
        else if((decoder_busy == 1) && (stage_index_r0 != 0) && (en == 1))
        begin
            if(stage_index_r0 >= p)
            begin
                wr_addr <= (1<<(n-p))-(1<<(stage_index_r0-p))-exe_index_r0;
            end
            
            else
            begin
                wr_addr <= (1<<(n-p))-2+(p-stage_index_r0);
            end
        end
        
        else
        begin
            wr_addr <= 0;
        end
    end
endmodule
