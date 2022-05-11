`include "../lib/constant.v"

module PC32(
    input clk,
    input rst,
    input pc_wen,
    input pc_new,
    output pc
);

    Reg #(32, 0) u_pc_reg(clk, rst, pc_wen, pc_new, pc);

endmodule