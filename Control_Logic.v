`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/19 21:15:39
// Design Name: 
// Module Name: Control_Logic
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


module Control_Logic(
    clk,
    rst_n,
    en,
    channel_register_ready,
    decoder_busy,
    decoder_done,
    wr_en,
    wr_addr,
    ram_rea,
    ram_rd_addra,
    ram_reb,
    ram_rd_addrb,
    channel_register_rd_en,
    channel_register_addr,
    psn_en,
    psn_rst,
    distribute_vector,
    reg_ram_data_select,
    function_select,
    bit_index_r1,
    data_valid    
    );
    
    parameter n = 3;
    parameter p = 1;
    
    localparam BUSY = 1;
    localparam IDLE = 0;
        
    //Address width define
    localparam MAX_ADDR = 2*p+2**(n-p+1)-3;
        
    input clk,
          rst_n,
          en,
          channel_register_ready;
    output wr_en,
           ram_rea,
           ram_reb;
    output[$clog2(2**(n-p)-2+p)-1:0]    wr_addr;
    output[$clog2(2**(n-p)-2+p)-1:0]    ram_rd_addra,
                                        ram_rd_addrb;
    output channel_register_rd_en;                                
    output[(2**(n-p-1))-1:0] channel_register_addr;
    output psn_en,
           psn_rst;
    output[(2**n)-1:0] distribute_vector;
    output decoder_busy,
           decoder_done;
    output reg_ram_data_select;
    output function_select;
    output[n-1:0] bit_index_r1;
    output data_valid;
    
    wire decoder_en = channel_register_ready && en;
    wire[n-1:0] bit_index, //Decoded bit index of decoder for Read Port Control
                bit_index_r0; 
    wire[$clog2(n)-1:0] stage_index; //Stage of decoder for Read Port Control
    wire[n-p-1:0] exe_index; //Reamining Execute times of current stage in decoder for Read Port Control
           
    //Working status of decoder
    State_Controller #(
        .n(n),
        .p(p)
        )
        State_Controller(
        .clk(clk),
        .rst_n(rst_n),
        .en(decoder_en),
        .stage_index(stage_index),
        .bit_index(bit_index),
        .decoder_busy(decoder_busy),
        .decoder_done(decoder_done),
        .data_valid(data_valid)
    );
    
    //Manage the stage of decoder
    Stage_Controller #(
        .n(n),
        .p(p)
        )
        Stage_Controller(
        .clk(clk),
        .rst_n(rst_n),
        .en(decoder_en),
        .bit_index(bit_index),
        .stage_index(stage_index),
        .exe_index(exe_index)
    );    
    
    //Manage the decoded bit index of decoder
    Bit_Index_Accumulator #(
        .n(n)
        )
        Bit_Index_Accumulator(
        .clk(clk),
        .rst_n(rst_n),
        .en(decoder_en),
        .stage_index(stage_index),
        .bit_index(bit_index),
        .bit_index_r0(bit_index_r0),
        .bit_index_r1(bit_index_r1)
    );

    //Control the write port of BRAM
    Write_Port_Controller #(
        .n(n),
        .p(p)
        )
        Write_Port_Controller(
        .clk(clk),
        .en(decoder_en),
        .rst_n(rst_n),
        .decoder_busy(decoder_busy),
        .stage_index(stage_index),
        .exe_index(exe_index),
        .wr_en(wr_en),
        .wr_addr(wr_addr)
    );
    
    //Control the read port of BRAM and bit-reversed buffer
    Read_Port_Controller #(
        .n(n),
        .p(p)
        )
        Read_Port_Controller(
        .clk(clk),
        .rst_n(rst_n),
        .en(decoder_en),
        .stage_index(stage_index),
        .exe_index(exe_index),
        .ram_rea(ram_rea),
        .ram_rd_addra(ram_rd_addra),
        .ram_reb(ram_reb),
        .ram_rd_addrb(ram_rd_addrb),
        .channel_register_rd_en(channel_register_rd_en),
        .channel_register_addr(channel_register_addr)
    );
    
    //Control of the Partial Sums Updated Network
    Partial_Sums_Distributor #(
        .n(n),
        .p(p)
        )
        Partial_Sums_Distributor(
        .clk(clk),
        .rst_n(rst_n),
        .en(decoder_en),
        .decoder_busy(decoder_busy),
        .bit_index(bit_index),
        .stage_index(stage_index),
        .exe_index(exe_index),
        .psn_rst(psn_rst),
        .psn_en(psn_en),
        .distribute_vector(distribute_vector)
    );
    
    //Control of all MUXs
    MUX_Controller #(
        .n(n),
        .p(p)
        )
        MUX_Controller(
        .clk(clk),
        .rst_n(rst_n),
        .bit_index(bit_index),
        .stage_index(stage_index),
        .reg_ram_data_select(reg_ram_data_select),
        .function_select(function_select)
    );   
endmodule
