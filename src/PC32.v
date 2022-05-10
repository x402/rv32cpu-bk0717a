`include "../lib/constant.v"

module PC32(
    input clk,
    input rst_n,
    input pc_new,
    output pc
);

    Reg #(32, 0) u_pc_reg(clk, rst_n, pc_new, pc, 1'b1);

endmodule