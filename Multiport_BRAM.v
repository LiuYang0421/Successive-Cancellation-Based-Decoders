`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/06 18:35:48
// Design Name: 
// Module Name: Multiport_BRAM
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


module Multiport_BRAM(
    clk,
    we,
    wr_addr,
    din,
    rea,
    douta,
    rd_addra,
    reb,
    doutb,
    rd_addrb
    );
    
    parameter n = 5;
    parameter p = 1;
    parameter Q = 6;
    
    localparam DATA_WIDTH = (2**p)*Q;
    localparam ADDR_WIDTH = $clog2(2**(n-p)-2+p);
    localparam DEPTH = 2**(n-p)-2+p;
    
    input                           clk;
    input                           we;
    input       [ADDR_WIDTH-1:0]    wr_addr;
    input       [DATA_WIDTH-1:0]    din;
    input                           rea;
    output reg  [DATA_WIDTH-1:0]    douta;
    input       [ADDR_WIDTH-1:0]    rd_addra;
    input                           reb;
    output reg  [DATA_WIDTH-1:0]    doutb;
    input       [ADDR_WIDTH-1:0]    rd_addrb;
    
    (*ram_style="block"*)reg [DATA_WIDTH-1:0] RAM [DEPTH-1:0];
    
    always@(posedge clk)
    begin
        if(rea)
        begin
            douta <= RAM[rd_addra];
        end
        
        else
        begin
            douta <= 0;
        end
    end
    
    always@(posedge clk)
    begin
        if(reb)
        begin
            doutb <= RAM[rd_addrb];
        end
        
        else
        begin
            doutb <= 0;
        end
    end
    
    always @(posedge clk)
    begin
        if(we)
            RAM[wr_addr] <= din;
    end
endmodule
