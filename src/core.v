module core(
    input clk_btn,
    input rst_n,

    output [31:0] pc,
    input [31:0] instr,

    output [31:0] addr_to_mem,
    output [3:0] be,
    output mem_wen,
    output [31:0] data_to_mem,
    input [31:0] data_from_mem
);
endmodule