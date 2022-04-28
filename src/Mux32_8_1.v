module Mux32_8_1(
    input [31:0] a0,
    input [31:0] a1,
    input [31:0] a2,
    input [31:0] a3,
    input [31:0] a4,
    input [31:0] a5,
    input [31:0] a6,
    input [31:0] a7,
    input [2:0] sel,
    output [31:0] y
);
    MuxKey #(8, 3, 32) u_mux(y, sel,{
        3'd0, a0,
        3'd1, a1,
        3'd2, a2,
        3'd3, a3,
        3'd4, a4,
        3'd5, a5,
        3'd6, a6,
        3'd7, a7
    });
endmodule