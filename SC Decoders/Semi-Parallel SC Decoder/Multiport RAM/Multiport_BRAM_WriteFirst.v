`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/07 19:14:43
// Design Name: 
// Module Name: Multiport_BRAM_WriteFirst
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


module Multiport_BRAM_WriteFirst(
    clk,
    rst_n,
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
    input                           rst_n;
    input                           we;
    input       [ADDR_WIDTH-1:0]    wr_addr;
    input       [DATA_WIDTH-1:0]    din;
    input                           rea;
    output      [DATA_WIDTH-1:0]    douta;
    input       [ADDR_WIDTH-1:0]    rd_addra;
    input                           reb;
    output      [DATA_WIDTH-1:0]    doutb;
    input       [ADDR_WIDTH-1:0]    rd_addrb;
    
    wire        [DATA_WIDTH-1:0]    douta_ram;
    wire        [DATA_WIDTH-1:0]    doutb_ram;
    
    wire                            rea_ram;
    wire                            reb_ram;
    
    reg         [DATA_WIDTH-1:0]    din_r0;
    reg         [ADDR_WIDTH-1:0]    wr_addr_r0;
    
    reg         [ADDR_WIDTH-1:0]    rd_addra_r0;
    reg         [ADDR_WIDTH-1:0]    rd_addrb_r0;
    
    reg                             we_r0;
    reg                             rea_r0;
    reg                             reb_r0;
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            din_r0 <= 0;
            wr_addr_r0 <= 0;
            
            rd_addra_r0 <= 0;
            rd_addrb_r0 <= 0;
            
            we_r0 <= 0;
            rea_r0 <= 0;
            reb_r0 <= 0;
        end
        
        else
        begin
            din_r0 <= din;
            wr_addr_r0 <= wr_addr;
            
            rd_addra_r0 <= rd_addra;
            rd_addrb_r0 <= rd_addrb;
            
            we_r0 <= we;
            rea_r0 <= rea;
            reb_r0 <= reb;
        end
    end
    
    assign douta = ((wr_addr_r0 == rd_addra_r0) && we_r0 && rea_r0) ? din_r0 : douta_ram;
    assign doutb = ((wr_addr_r0 == rd_addrb_r0) && we_r0 && reb_r0) ? din_r0 : doutb_ram;
    
    assign rea_ram = ((wr_addr == rd_addra) && we) ? 1'b0 : rea;
    assign reb_ram = ((wr_addr == rd_addrb) && we) ? 1'b0 : reb;
    
    Multiport_BRAM #(
        .n(n),
        .p(p),
        .Q(Q)
        )
        Multiport_BRAM1(
        .clk(clk),
        .we(we),
        .wr_addr(wr_addr),
        .din(din),
        .rea(rea_ram),
        .douta(douta_ram),
        .rd_addra(rd_addra),
        .reb(reb_ram),
        .doutb(doutb_ram),
        .rd_addrb(rd_addrb)
        );
endmodule
