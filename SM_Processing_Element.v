module SM_Processing_Element(
    LLR_A_VAL,  //Input of value part of LLR A
    LLR_A_SIGN, //Input of sign Part of LLR B
    LLR_B_VAL,  //Input of value part of LLR A
    LLR_B_SIGN, //Input of sign part of LLR B
    PARTIAL_SUM,//Input of Partial Sum
    F_VAL,      //Output of value part of function f
    F_SIGN,     //Output of sign part of function f
    G_VAL,      //Output of value part of function g
    G_SIGN      //Output of sign part of function g
);

    parameter Q=8;
    
    input[Q-2:0]    LLR_A_VAL,
                    LLR_B_VAL;
    input           LLR_A_SIGN,
                    LLR_B_SIGN,
                    PARTIAL_SUM;

    output[Q-2:0]   F_VAL,
                    G_VAL;
    output          F_SIGN,
                    G_SIGN;
                    
    wire            COMP_RESULT,    //Comparator result of absolute value of LLR A and LLR B
                    XOR1_RESULT,    //XOR result of LLR_A_SIGN and LLR_B_SIGN
                    XOR2_RESULT,    //XOR result of LLR_A_SIGN and PARTIAL_SUM
                    XOR3_RESULT,    //XOR result of XOR1_RESULT and PARTIAL_SUM
                    MUX1_RESULT;    //MUX controlled by COMP_RESULT. 0:LLR_B_SIGN 1:XOR2_RESULT
    wire[Q-2:0]     ADD1_RESULT,    //Result of LLR_A_VAL + LLR_B_VAL
                    SUB1_RESULT,    //Result of |LLR_A_VAL - LLR_B_VAL|
                    MUX2_RESULT,    //Result of Max value of LLR_A_VAL and LLR_B_VAL
                    MUX3_RESULT,    //Result of Min value of LLR_A_VAL and LLR_B_VAL
                    MUX4_RESULT;    //Select the output of G_VAL
                    
    assign XOR1_RESULT = LLR_A_SIGN + LLR_B_SIGN;
    assign XOR2_RESULT = LLR_A_SIGN + PARTIAL_SUM;
    assign XOR3_RESULT = XOR1_RESULT + PARTIAL_SUM;
    assign COMP_RESULT = (LLR_A_VAL >= LLR_B_VAL) ? 1 : 0;
    assign MUX1_RESULT = COMP_RESULT ? XOR2_RESULT : LLR_B_SIGN;
    assign MUX2_RESULT = COMP_RESULT ? LLR_A_VAL : LLR_B_VAL;
    assign MUX3_RESULT = COMP_RESULT ? LLR_B_VAL : LLR_A_VAL;
    assign ADD1_RESULT = MUX2_RESULT + MUX3_RESULT;
    assign SUB1_RESULT = MUX2_RESULT - MUX3_RESULT;
    assign MUX4_RESULT = XOR3_RESULT ? SUB1_RESULT : ADD1_RESULT;
    
    assign F_VAL = MUX3_RESULT;
    assign F_SIGN = XOR1_RESULT;
    assign G_VAL = MUX4_RESULT;
    assign G_SIGN = MUX1_RESULT;
endmodule