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

    wire pc_new;
/*+-------------------------------------+
  |         PC                          |
  +-------------------------------------+*/
    //wire pc;
    //wire [31:0] instr;
/*+-------------------------------------+
  |         ID                          |
  +-------------------------------------+*/
    wire [4:0] rs1, rs2, rd;
    wire [31:0] imm;
    wire [2:0] alu_ctrl;
    wire num2_sel;
    wire [3:0] rw_type;
    wire mem_wen, mem_ren;
    wire [5:0] b_ins;
    wire [1:0] j_ins, u_ins;
    wire reg_wen;
endmodule