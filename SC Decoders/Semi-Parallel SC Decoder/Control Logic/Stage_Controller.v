`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/20 00:58:31
// Design Name: 
// Module Name: Stage_Controller
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


module Stage_Controller(
    clk,
    rst_n,
    en,
    bit_index,    
    stage_index,
    exe_index
    );
    
    parameter n = 3;
    parameter p = 1;
    
    input                                       clk,
                                                rst_n,
                                                en;
    input               [n-1:0]                 bit_index;
    output reg          [$clog2(n)-1:0]         stage_index;
    output reg          [n-p-1:0]               exe_index; 
    
    wire                [n-1:0]                 ffs_data_in;
    wire                [$clog2(n)-1:0]         stage_reset_value; //Reset value of stage(FFS function)
    wire                [n-p-1:0]               exe_reset_value; //Reset value of Execute times after decoding a new bit
    
    (*keep="true"*)reg  [n-1:0]                 bit_index_r0,
                                                bit_index_r1;
                                                
    assign ffs_data_in = bit_index + 1;
    
    FFS #(.n(n)
        )
        FFS(
        .Data_in(ffs_data_in),
        .Position_out(stage_reset_value)
    );
    
    assign exe_reset_value = (stage_reset_value > p) ? (1<<(stage_reset_value - p)) : 1;
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n) //System reset
        begin
            stage_index <= n - 1;
            exe_index <= 2**(n-p-1);
        end
        
        else if((bit_index_r0 == ((2**n)-1)) || (bit_index_r1 == ((2**n)-1)))
        begin
            stage_index <= n - 1;
            exe_index <= 2**(n-p-1);
        end
        
        else if((en == 1) && (stage_index == 0)) //Reset after decoding a new bit
        begin
            stage_index <= stage_reset_value;
            exe_index <= exe_reset_value;
        end
        
        else if((en == 1) && (exe_index == 1)) //Reduce once last stage is executed
        begin
            stage_index <= stage_index - 1;
            exe_index <= (stage_index > p) ? (1<<(stage_index - p - 1)) : 1;
        end
        
        else if(en == 1)
        begin
            stage_index <= stage_index;
            exe_index <= exe_index - 1;
        end
        
        else
        begin
            stage_index <= stage_index;
            exe_index <= exe_index;
        end
    end
    
    //Control of registers of stage and exe_index
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
