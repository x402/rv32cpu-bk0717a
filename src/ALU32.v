module ALU32(
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    input [31:0] imm,
    input imm_sel,
    input [2:0] alu_ctrl,
    output [31:0] result,
    output [3:0] flags      //zf,cf,of,sf
);

    wire zf, cf, of, sf;
    wire c32, c31;
    
    assign zf = ~(|result);
    assign cf = c32;
    assign of = c32 ^ c31;
    assign sf = result[31];
    assign flags = {zf, cf, of, sf};

    wire [31:0] num2;   //rs2 or imm
    Mux32_2_1 u_mux_num2(rs2_data, imm, imm_sel, num2);

//================add/sub================
    wire [31:0] num2_xor;  //pos or neg
    wire c0;    //is sub
    wire [31:0] add_result;

    assign c0 = (alu_ctrl == 3'd1) ? 1'b1 : 1'b0;
    assign num2_xor = num2 ^ {32{c0}};

    Adder32 u_add32(rs1_data, num2_xor, c0, add_result, c32, c31);
//=======================================

//================logic================
    wire [31:0] and_result;
    wire [31:0] or_result;
    wire [31:0] xor_result;

    assign and_result = rs1_data & num2;
    assign or_result = rs1_data | num2;
    assign xor_result = rs1_data ^ num2;
//=====================================

//================shifter================
    //toulan, zhi yi yiwei
    wire [31:0] sll_result;
    wire [31:0] srl_result;
    wire [31:0] sra_result;

    assign sll_result = {rs1_data[30:0], 1'b0};
    assign srl_result = {1'b0, rs1_data[31:1]};
    assign sra_result = {rs1_data[31], rs1_data[31:1]};
//=======================================

    //result select
    Mux32_8_1 u_mux_result(
        add_result,
        add_result,
        and_result,
        or_result,
        xor_result,
        sll_result,
        srl_result,
        sra_result,
        alu_ctrl,
        result
    );
endmodule