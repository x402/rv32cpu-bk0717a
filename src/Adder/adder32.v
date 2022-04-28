module Adder32(
    input [31:0] A,
    input [31:0] B,
    input C0,
    output [31:0] S,
    output C32,
    output C31//
);

    wire C4, C8, C12, C16, C20, C24, C28;

    Adder4 u_add4_0(A[3:0],     B[3:0], C0,     S[3:0], C4, );
    Adder4 u_add4_1(A[7:4],     B[7:4], C4,     S[7:4], C8, );
    Adder4 u_add4_2(A[11:8],    B[11:8], C8,    S[11:8], C12, );
    Adder4 u_add4_3(A[15:12],   B[15:12], C12,  S[15:12], C16, );
    Adder4 u_add4_4(A[19:16],   B[19:16], C16,  S[19:16], C20);
    Adder4 u_add4_5(A[23:20],   B[23:20], C20,  S[23:20], C24, );
    Adder4 u_add4_6(A[27:24],   B[27:24], C24,  S[27:24], C28, );
    Adder4 u_add4_7(A[31:28],   B[31:28], C28,  S[31:28], C32, C31);

endmodule