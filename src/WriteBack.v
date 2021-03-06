module WriteBack(
    input [31:0] pc,
    input [31:0] imm,
    input [31:0] alu_result,
    input [31:0] data_r,

    input [5:0] b_ins,      //beq, bne, bge, blt, bgeu, bltu
    input [3:0] flags,      //zf, cf, of, sf

    input [1:0] j_ins,      //jal, jalr

    input [1:0] u_ins,      //lui, auipc

    input mem_ren,              //mem read enable

    output [31:0] pc_new,
    output [31:0] data2reg
);

    wire beq, bne, bge, blt, bgeu, bltu;
    assign {beq, bne, bge, blt, bgeu, bltu} = b_ins;

    wire zf, cf, of, sf;
    assign {zf, cf, of, sf} = flags;

    wire jal, jalr;
    assign {jal, jalr} = j_ins;

    wire lui, auipc;
    assign {lui, auipc} = u_ins;

    //pc
    wire [31:0] pcplus_4;
    Adder32 u_add_pc_4(pc, 32'h4, 1'b0, pcplus_4, , );

    wire [31:0] pcplus_imm;
    Adder32 u_add_pc_imm(pc, imm, 1'b0, pcplus_imm, , );

    wire branch;
    wire [31:0] pc_b;
    assign branch = jal |
                    (beq & zf) |
                    (bne & ~zf) |
                    (bge & (of ^ sf)) |
                    (blt & ~(of ^ sf)) |
                    (bgeu & cf) |
                    (bltu & ~cf);

    Mux32_2_1 u_mux_b(pcplus_4, pcplus_imm, branch, pc_b);

    wire [31:0] pc_jalr;
    assign pc_jalr = {alu_result[31:1], 1'b0};
    Mux32_2_1 u_mux_new(pc_b, pc_jalr, jalr, pc_new);

    //regfile
    wire [31:0] alu_mem;
    Mux32_2_1 u_mux_alu_mem(alu_result, data_r, mem_ren, alu_mem);

    wire [31:0] not_u_t;
    Mux32_2_1 u_mux_not_u_t(alu_mem, pcplus_4, |j_ins, not_u_t);

    wire [31:0] is_u_t;
    Mux32_2_1 u_mux_is_u_t(pcplus_imm, imm, lui, is_u_t);

    Mux32_2_1 u_mux_data2reg(not_u_t, is_u_t, |u_ins, data2reg);

endmodule