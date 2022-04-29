`include "constant.v"

module RegFile32(
    input clk,
    input rst_n,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input reg_wen,
    input [31:0] data_in,
    output [31:0] data_out1,
    output [31:0] data_out2
);

    reg wen [31:1];
    wire [31:0] q [31:0];

    always @(*) begin
        interger [4:0] i;
        for(i = 1; i < 32; i = i + 1) begin
            if(rd == i) wen[i] = reg_wen;
            else    wen[i] = 0;
        end
    end
    
    assign q[0] = `zero_word;
    assign data_out1 = q[rs1];
    assign data_out2 = q[rs2];

    genvar i;
    generate
        for(i = 1; i < 32; i = i + 1) begin: reg_gen
            Reg #(32, 0) u_reg(clk, rst_n, wen[i], data_in, q[i]);
        end
    endgenerate
endmodule