module Reg #(WIDTH = 1, RESET_VAL = 0) (
    input clk,
    input rst,
    input wen,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (rst) q <= RESET_VAL;
        else if (wen) q <= d;
    end
endmodule