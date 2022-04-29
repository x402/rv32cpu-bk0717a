module Decoder(
    input [31:0] instr,

    //regfile
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,

    //alu
    output [31:0] imm,
    output [2:0] alu_ctrl,
    output num2_sel,        //1:imm

    //access mem
    output [3:0] rw_type,         //u, w, h, b
    output mem_wen,
    output mem_ren,

    //write back
    output [5:0] b_ins,      //be, bne, bge, blt, bgeu, bltu
    output [1:0] j_ins,      //jal, jalr
    output [1:0] u_ins,      //lui, auipc
    output reg_wen
);

    wire [6:0] funct7;      //7 31:25
    //wire [4:0] rs2;       //5 24:20
    //wire [4:0] rs1;       //5 19:15
    wire [2:0] funct3;      //3 14:12
    //wire [4:0] rd;        //5 11:7
    wire [6:0] opcode;      //7  6:0
    wire [6:0] funct7_n;
    wire [2:0] funct3_n;
    wire [6:0] opcode_n;

    assign {funct7, rs2, rs1, funct3, rd, opcode} = instr;
    assign funct7_n = ~funct7;
    assign funct3_n = ~funct3;
    assign opcode_n = ~opcode;

//================ctrl_gen================
    wire r_type, i_type, s_type, b_type, u_type, j_type;
    wire u, w, h, b;
    wire beq, bne, bge, blt, bgeu, bltu;
    wire jal, jalr;
    wire lui, auipc;
    assign rw_type = {u, w, h, b};
    assign b_ins = {beq, bne, bge, blt, bgeu, bltu};
    assign j_ins = {jal, jalr};
    assign u_ins = {lui, auipc};
    
    //opcode[1:0] must be 2'b11
    wire effect;
    assign effect = &opcode[1:0];

    //u type
    assign lui = effect && (opcode[6:2] == 5'b01101) ? 1'b1 : 1'b0;
    assign auipc = effect && (opcode[6:2] == 5'b00101) ? 1'b1 : 1'b0;
    assign u_type = lui | auipc;
    //jal, jalr
    assign jal = effect && (opcode[6:2] == 5'b11011) ? 1'b1 : 1'b0;
    assign jalr = effect && (opcode[6:2] == 5'b11001) ? 1'b1 : 1'b0;
    assign j_type = jal;

    //not top4 xxx_00_xx
    wire t4_n;
    assign t4_n = &opcode_n[3:2];

    //b type 110_00_11
    assign b_type = effect & t4_n & opcode[6] & opcode[5] & opcode_n[4];//110
    assign beq = b_type & (&funct3_n);                          //000
    assign bne = b_type & funct3_n[2] & funct3_n[1] & funct3[0];//001
    assign blt = b_type & funct3[2] & funct3_n[1] & funct3_n[0];//100
    assign bge = b_type & funct3[2] & funct3_n[1] & funct3[0];  //101
    assign bltu = b_type & funct3[2] & funct3[1] & funct3_n[0]; //110
    assign bgeu = b_type & funct3[2] & funct3[1] & funct3[0];   //111

    //s type 010_00_11 (store)
    wire sb, sh, sw;
    assign s_type = effect & t4_n & opcode_n[6] & opcode[5] & opcode_n[4];//010
    assign mem_wen = s_type;
    assign sb = s_type & (&funct3_n);                           //000
    assign sh = s_type & funct3_n[2] & funct3_n[1] & funct3[0]; //001
    assign sw = s_type & funct3_n[2] & funct3[1] & funct3_n[0]; //010

    //r type 011_00_11
    wire add, sub, xorr, orr, andr;
    assign r_type = effect & t4_n & opcode_n[6] & opcode[5] & opcode[4];//011
    assign add = r_type & (&funct3_n) & funct7_n[5];            //000 0
    assign sub = r_type & (&funct3_n) & funct7[5];              //000 1
    assign xorr = r_type & funct3[2] & funct3_n[1] & funct3_n[0];//100
    assign orr = r_type & funct3[2] & funct3[1] & funct3_n[0];   //110
    assign andr = r_type & (&funct3);                            //111

    //i type 00x_00_11
    wire _i_type;
    wire i_load;
    wire i_calc;
    wire lb, lh, lw;
    wire lbu, lhu;
    wire addi, xori, ori, andi;
    wire slli; 
    assign _i_type = effect & t4_n & (&opcode[6:5]);//00x
    assign i_type = _i_type | jalr;
    assign i_load = _i_type & opcode_n[4];
    assign i_calc = _i_type & opcode[4];
    assign mem_ren = i_load;

    assign lb = i_load & (&funct3_n);                           //000
    assign lh = i_load & funct3_n[2] & funct3_n[1] & funct3[0]; //001
    assign lw = i_load & funct3_n[2] & funct3[1] & funct3_n[0]; //010
    assign lbu = i_load & funct3[2] & funct3_n[1] & funct3_n[0];//100
    assign lhu = i_load & funct3[2] & funct3_n[1] & funct3[0];  //101

    assign u = lbu | lhu;
    assign b = sb | lb | lbu;
    assign h = sh | lh | lhu;
    assign w = sw | lw;

    assign addi = i_calc & (&funct3_n);                         //000
    assign xori = i_calc & funct3[2] & funct3_n[1] & funct3_n[0];//100
    assign ori = i_calc & funct3[2] & funct3[1] & funct3_n[0];  //110
    assign andi = i_calc & (&funct3);                           //111
    assign slli = i_calc & funct3_n[2] & funct3_n[1] & funct3[0] & (&funct7_n);//001 0

    //reg_write
    assign reg_wen = ~(b_type | s_type);

//================imm_gen================
    wire [31:0] i_imm;
    wire [31:0] s_imm;
    wire [31:0] b_imm;
    wire [31:0] u_imm;
    wire [31:0] j_imm;
    assign i_imm = { {20{instr[31]}}, instr[31:20]                                                          };
    assign s_imm = { {20{instr[31]}}, instr[31:25],                                 instr[11:7]             };
    assign b_imm = { {20{instr[31]}},                   instr[7],   instr[30:25],   instr[11:8],    1'b0    };
    assign u_imm = { instr[31:12],                      12'b0                                               };
    assign j_imm = { {12{instr[31]}},   instr[19:12],   instr[20],  instr[30:25],   instr[24:21],   1'b0    };

    assign imm =    {32{i_type}} & i_imm |
                    {32{s_type}} & s_imm |
                    {32{b_type}} & b_imm |
                    {32{u_type}} & u_imm |
                    {32{j_type}} & j_imm;

//================alu_ctrl================
    assign num2_sel = ~(b_type | r_type);
    assign alu_ctrl =   (add | addi)    ? 3'd0 : 
                        (sub)           ? 3'd1 :
                        (andr | andi)   ? 3'd2 :
                        (orr | ori)     ? 3'd3 :
                        (xorr | xori)    ? 3'd4 :
                        (slli)          ? 3'd5 :
                                          3'd0;

endmodule