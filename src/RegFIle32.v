`include "constant.v"

module RegFile32(
    input clk,
    input rst_n,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] data_in,
    output [31:0] data_out1,
    output [31:0] data_out2
);

    reg [31:0] d [31:0];
    wire [31:0] q [31:0];
    
    always @(*) d[rd] = data_in;
    assign q[0] = `zero_word;
    assign data_out1 = q[rs1];
    assign data_out2 = q[rs2];

    genvar i;
    generate
        for(i = 1; i < 32; i = i + 1) begin: reg_gen
            Reg #(32, 0) u_reg(clk, rst_n, 1'b1, d[i], q[i]);
        end
    endgenerate
endmodule