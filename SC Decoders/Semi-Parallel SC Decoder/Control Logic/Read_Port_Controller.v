`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/24 19:57:00
// Design Name: 
// Module Name: Read_Port_Controller
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


module Read_Port_Controller(
    clk,
    rst_n,
    en,
    stage_index,
    exe_index,
    ram_rea,
    ram_rd_addra,
    ram_reb,
    ram_rd_addrb,
    channel_register_rd_en,
    channel_register_addr
    );
    
    parameter n = 3;
    parameter p = 1;
    
    localparam ADDR_WIDTH = $clog2(2**(n-p)-2+p);
    
    input                                   clk,
                                            rst_n,
                                            en;
    input           [$clog2(n)-1:0]         stage_index;
    input           [n-p-1:0]               exe_index; 
    output reg                              ram_rea;
    output reg      [ADDR_WIDTH-1:0]        ram_rd_addra;
    output reg                              ram_reb;
    output reg      [ADDR_WIDTH-1:0]        ram_rd_addrb;
    output reg                              channel_register_rd_en;
    output reg      [(2**(n-p-1))-1:0]      channel_register_addr;
    
    //Control of channel_register
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            channel_register_rd_en <= 0;
            channel_register_addr <= 0;
        end
        
        else if((stage_index == n-1) && (en == 1))
        begin
            channel_register_rd_en <= 1;
            channel_register_addr <= (2**(n-p-1)) - exe_index;
        end
        
        else
        begin
            channel_register_rd_en <= 0;
            channel_register_addr <= 0;
        end
    end
    
    //Control of BRAM PortA
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            ram_rea <= 0;
            ram_rd_addra <= 0;
        end
        
        else if((stage_index != n-1) && (en == 1))
        begin
            if(stage_index >= p)
            begin
                ram_rea <= 1;
                ram_rd_addra <= (1<<(n-p))-(1<<(stage_index-p+1))-(2*exe_index);
            end
            
            else
            begin
                ram_rea <= 1;
                ram_rd_addra <= (1<<(n-p))-3+(p-stage_index);
            end
        end
    end
    
    //Control of BRAM PortB
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            ram_reb <= 0;
            ram_rd_addrb <= 0;
        end
        
        else if((stage_index != n-1) && (en == 1))
        begin
            if(stage_index >= p)
            begin
                ram_reb <= 1;
                ram_rd_addrb <= (1<<(n-p))-(1<<(stage_index-p+1))-(2*exe_index)+1;
            end
            
            else
            begin
                ram_reb <= 0;
                ram_rd_addrb <= 0;
            end
        end
    end
endmodule
