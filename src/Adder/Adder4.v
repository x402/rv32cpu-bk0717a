module Adder4(
    input [3:0] A,
    input [3:0] B,
    input C0,
    output [3:0] S,
    output C4,
    output C3//
);

    wire [3:0] P;
    wire [3:0] G;
    wire [3:0] Ci;

    assign Ci[0] = C0;
    assign Ci[1] = G[0] | (P[0] & Ci[0]);
    assign Ci[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Ci[0]);
    assign Ci[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Ci[0]);
    assign C4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Ci[0]);
    assign C3 = Ci[3];

    generate
        genvar i;
        for(i = 0; i < 4; i=i+1) begin: pgs
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
            assign S[i] = A[i] ^ B[i] ^ Ci[i];
        end
    endgenerate

endmodule
