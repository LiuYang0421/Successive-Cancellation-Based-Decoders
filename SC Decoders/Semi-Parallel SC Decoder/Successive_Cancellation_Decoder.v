`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/11 15:31:35
// Design Name: 
// Module Name: Successive_Cancellation_Decoder
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


module Successive_Cancellation_Decoder(
    clk,
    rst_n,
    en,
    channel_LLR_in,
    channel_LLR_valid,
    decoder_busy,
    decoder_done,
    decoded_code
    );
    
    parameter n = 5;
    parameter p = 2;
    parameter Q = 6;
    parameter frozen_bit = 0;
    
    input                               clk;
    input                               rst_n;
    input                               en;
    input[((2**n)*Q)-1:0]               channel_LLR_in;
    input                               channel_LLR_valid;
    output                              decoder_busy;
    output                              decoder_done;
    output[(2**n)-1:0]                  decoded_code;
    
    //connection of channel register
    wire[((2**(p+1))*Q)-1:0]            channel_register_dout;
    wire                                channel_register_ready;
    
    //connection of control logic
    wire                                BRAM_wr_en;
    wire                                BRAM_rea,
                                        BRAM_reb;
    wire[$clog2(2**(n-p)-2+p)-1:0]      BRAM_wr_addr;
    wire[$clog2(2**(n-p)-2+p)-1:0]      BRAM_rd_addra,
                                        BRAM_rd_addrb;
    wire                                channel_register_rd_en;                                    
    wire[(2**(n-p-1))-1:0]              channel_register_addr;
    wire                                psn_en;
    wire                                psn_rst;
    wire[(2**n)-1:0]                    distribute_vector;
    wire                                reg_ram_data_select;
    wire                                function_select;
    wire[n-1:0]                         bit_index_r1;
    wire                                data_valid;
    
    //connection of PEs
    wire[((2**p)*Q)-1:0]                f_function_output;
    wire[((2**p)*Q)-1:0]                g_function_output;      
    
    //connection of BRAM
    wire[((2**(p+1))*Q)-1:0]            LLR_from_RAM;
    
    //connection of decider
    wire                                decoded_bit;
    
    //connection of partial sums updated network
    wire[(2**n)-1:0]                    S;
    //connection of partial sums distribute network
    wire[(2**p)-1:0]                    partial_sums_output;
    
    //connection of frozen bit register
    wire                                frozen_bit_indication;
    
    //connection of MUXs
    wire[((2**(p+1))*Q)-1:0]            LLR_to_PE;
    wire[((2**p)*Q)-1:0]                LLR_from_PE;
    
    //connection of decoded bit register
    wire                                decoded_code_rd_en;
    
    Bit_Reversed_Register #(
        .n(n),
        .p(p),
        .Q(Q)
        )
        Bit_Reversed_Register(
        .clk(clk),
        .rst_n(rst_n),
        .data_valid(channel_LLR_valid),
        .decoder_busy(decoder_busy),
        .decoder_done(decoder_done),
        .din(channel_LLR_in),
        .channel_register_rd_en(channel_register_rd_en),
        .channel_register_address(channel_register_addr),
        .dout(channel_register_dout),
        .channel_register_ready(channel_register_ready)
    );    
    
    Multiport_BRAM_WriteFirst #(
        .n(n),
        .p(p),
        .Q(Q)
        )
        Multiport_BRAM_WriteFirst(
        .clk(clk),
        .rst_n(rst_n),
        .we(BRAM_wr_en),
        .wr_addr(BRAM_wr_addr),
        .din(LLR_from_PE),
        .rea(BRAM_rea),
        .douta(LLR_from_RAM[((2**(p))*Q)-1:0]),
        .rd_addra(BRAM_rd_addra),
        .reb(BRAM_reb),
        .doutb(LLR_from_RAM[((2**(p+1))*Q)-1:((2**(p))*Q)]),
        .rd_addrb(BRAM_rd_addrb)
    );
    
    Control_Logic #(
        .n(n),
        .p(p)
        )
        Control_Logic(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .channel_register_ready(channel_register_ready),
        .decoder_busy(decoder_busy),
        .decoder_done(decoder_done),
        .wr_en(BRAM_wr_en),
        .wr_addr(BRAM_wr_addr),
        .ram_rea(BRAM_rea),
        .ram_rd_addra(BRAM_rd_addra),
        .ram_reb(BRAM_reb),
        .ram_rd_addrb(BRAM_rd_addrb),
        .channel_register_rd_en(channel_register_rd_en),
        .channel_register_addr(channel_register_addr),
        .psn_en(psn_en),
        .psn_rst(psn_rst),
        .distribute_vector(distribute_vector),
        .reg_ram_data_select(reg_ram_data_select),
        .function_select(function_select),
        .bit_index_r1(bit_index_r1),
        .data_valid(data_valid)
    );
    
    Partial_Sum_Network #(
        .n(n)
        )
        Partial_Sum_Network(
        .clk(clk),
        .en(psn_en),
        .rst(psn_rst),
        .u(decoded_bit),
        .S(S)
    );
    
    Partial_Sums_Distribute_Network #(
        .n(n),
        .p(p)
        )
        Partial_Sums_Distribute_Network(
        .S(S),
        .distribute_vector(distribute_vector),
        .partial_sums_output(partial_sums_output)
    );
    
    genvar i;
    generate
        for(i=0;i<(2**p);i=i+1)
        begin
            SM_Processing_Element #(
                .Q(Q)
                )
                PE(
                .LLR_A_VAL(LLR_to_PE[(2*i+1)*Q-2:2*i*Q]),
                .LLR_A_SIGN(LLR_to_PE[(2*i+1)*Q-1]),
                .LLR_B_VAL(LLR_to_PE[2*(i+1)*Q-2:(2*i+1)*Q]),
                .LLR_B_SIGN(LLR_to_PE[2*(i+1)*Q-1]),
                .PARTIAL_SUM(partial_sums_output[i]),
                .F_VAL(f_function_output[(i+1)*Q-2:i*Q]),
                .F_SIGN(f_function_output[(i+1)*Q-1]),
                .G_VAL(g_function_output[(i+1)*Q-2:i*Q]),
                .G_SIGN(g_function_output[(i+1)*Q-1])
            );
        end
    endgenerate
    
    Decider #(
        )
        Decider(
        .LLR_SIGN(LLR_from_PE[Q-1]),
        .frozen_bit_indication(frozen_bit_indication),
        .decoded_bit(decoded_bit)
    );
    
    Frozen_Bit_Register #(
        .n(n),
        .frozen_bit(frozen_bit)
        )
        Frozen_Bit_Register(
        .clk(clk),
        .rst_n(rst_n),
        .bit_index(bit_index_r1),
        .data_valid(data_valid),
        .frozen_bit_indication(frozen_bit_indication)
    );
    
    assign decoded_code_rd_en = decoder_done;
    Decoded_Bit_Register #(
        .n(n)
        )
        Decoded_Bit_Register(
        .clk(clk),
        .rst_n(rst_n),
        .decoded_bit(decoded_bit),
        .bit_index(bit_index_r1),
        .data_valid(data_valid),
        .rd_en(decoded_code_rd_en),
        .decoded_code(decoded_code)
    );
    
    //MUXs array
    //MUX for selecting data from RAM/Channel register - 1:Channel LLRs 0:RAM
    assign LLR_to_PE = reg_ram_data_select ? channel_register_dout : LLR_from_RAM;
    //MUX for selecting data from f function/g function - 1:g function 0:f function
    assign LLR_from_PE = function_select ? g_function_output : f_function_output;
endmodule
