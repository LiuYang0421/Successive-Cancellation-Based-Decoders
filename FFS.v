`timescale 1ns / 1ps

module FFS(
    Data_in,
    Position_out
);
    parameter n = 10;

    input[n-1:0] Data_in;
    output reg[$clog2(n)-1:0] Position_out;
    
    wire[n-1:0] Data_OneHot;
    
    assign Data_OneHot = Data_in & (~(Data_in - 1)); //Only first 1 will be set to assign
    
    integer i;
    always@(*)
    begin:encoder
        for(i=0;i<n;i=i+1)
        begin
            if(Data_OneHot[i])
            begin
                Position_out = i;
                disable encoder;
            end
            
            else
            begin
                Position_out = n-1;
            end
        end
    end
endmodule