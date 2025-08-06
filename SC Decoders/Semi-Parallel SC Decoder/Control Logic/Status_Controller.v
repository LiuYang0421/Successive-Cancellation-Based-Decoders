`timescale 1ns / 1ps

module State_Controller(
    clk,
    rst_n,
    en,
    stage_index,
    bit_index,
    decoder_busy,
    decoder_done,
    data_valid
    );
    
    parameter n = 3;
    parameter p = 1;  
    
    input                                       clk,
                                                rst_n,
                                                en;
    input               [$clog2(n)-1:0]         stage_index;
    input               [n-1:0]                 bit_index;
    output reg                                  decoder_busy,
                                                decoder_done;
    output                                      data_valid;

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
                                                                                      
    //Status Control
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n) //Default status is IDLE
        begin
            decoder_busy <= 0;
        end
        
        else if((stage_index_r1 == 0) && (bit_index_r1 == (2**n)-1)) //After the last bit was decoded, go back to IDLE status
        begin
            decoder_busy <= 0;
        end
        
        else if(decoder_done)
        begin
            decoder_busy <= 0;
        end
        
        else if(en) //When Bit_Reversed_Buffer is ready, the decoder can start decoding
        begin
            decoder_busy <= 1;
        end
               
        else
        begin
            decoder_busy <= decoder_busy;
        end
    end
    
    //Signal that can output the status of decoder(decoder_busy and decoder_done)
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            decoder_done <= 0;
        end
        
        else if((stage_index_r1 == 0) && (bit_index_r1 == (2**n)-1)) //After the last bit was decoded, the decoding process is done,the signal will last one clock cycle
        begin
            decoder_done <= 1;
        end
        
        else //The signal of decoder_done will only last one clock cycle
        begin
            decoder_done <= 0;
        end
    end
    
    //Valid Data Flag
    assign data_valid = (stage_index_r1 == 0) ? 1 : 0;
endmodule
