`include "../lib/constant.v"

module RegFile32(
    input clk,
    input rst,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input reg_wen,
    input [31:0] data_in,
    output [31:0] data_out1,
    output [31:0] data_out2
);

    reg wen [31:1];
    (*KEEP="TRUE"*)wire [31:0] q [31:0];
    integer i;

    always @(*) begin
        for(i = 1; i < 32; i = i + 1) begin
            if(rd == i) wen[i] = reg_wen;
            else    wen[i] = 0;
        end
    end
    
    assign q[0] = `zero_word;
    assign data_out1 = q[rs1];
    assign data_out2 = q[rs2];

    genvar j;
    generate
        for(j = 1; j < 32; j = j + 1) begin: reg_gen
            Reg #(32, 0) u_reg(clk, rst, wen[j], data_in, q[j]);
        end
    endgenerate
endmodule