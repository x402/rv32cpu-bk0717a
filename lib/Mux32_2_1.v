module Mux32_2_1(
    input [31:0] a,
    input [31:0] b,
    input sel,
    output [31:0] y
);
    MuxKey #(2, 1, 32) u_mux(y, sel,{
        1'b0, a,
        1'b1, b
    });
endmodule