module WriteBack(
    input [31:0] pc,
    input [31:0] imm,
    input [31:0] alu_result,
    input [31:0] data_r,

    input [5:0] b_ins,      //be, bne, bge, blt, bgeu, bltu
    input [3:0] flags,      //zf, cf, of, sf

    input [1:0] j_ins,      //jal, jalr

    input [1:0] u_ins,      //lui, auipc

    input ren,              //read enable

    output [31:0] pc_new,
    output [31:0] data2reg
);

    wire be, bne, bge, blt, bgeu, bltu;
    assign {be, bne, bge, blt, bgeu, bltu} = b_ins;

    wire zf, cf, of, sf;
    assign {zf, cf, of, sf} = flags;

    wire jal, jalr;
    assign {jal, jalr} = j_ins;

    wire lui, auipc;
    assign {lui, auipc} = u_ins;

    //pc
    wire pcplus_4;
    Adder32 u_add_pc_4(pc, 32'h4, 1'b0, pcplus_4, , );

    wire pcplus_imm;
    Adder32 u_add_pc_imm(pc, imm, 1'b0, pcplus_imm, , );

    wire branch;
    wire pc_b;
    assign branch = jal |
                    (be & zf) |
                    (bne & ~zf) |
                    (bge & (of ^ sf)) |
                    (blt & ~(of ^ sf)) |
                    (bgeu & cf) |
                    (bltu & ~cf);

    Mux32_2_1 u_mux_b(pcplus_4, pcplus_imm, branch, pc_b);

    wire pc_jalr;
    assign pc_jalr = {alu_result[31:1], 1'b0};
    Mux32_2_1 u_mux_new(pc_b, pc_jalr, jalr, pc_new);

    //regfile
    wire alu_mem;
    Mux32_2_1 u_mux_alu_mem(alu_result, data_r, ren, alu_mem);

    wire not_u_t;
    Mux32_2_1 u_mux_not_u_t(alu_mem, pcplus_4, |j_ins, not_u_t);

    wire is_u_t;
    Mux32_2_1 u_mux_is_u_t(pcplus_imm, imm, lui, is_u_t);

    Mux32_2_1 u_mux_data2reg(not_u_t, is_u_t, |u_ins, data2reg);

endmodule