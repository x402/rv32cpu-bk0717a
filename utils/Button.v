module Button(
    input clk,
    input rst,
    input btn_input,
    output btn_posedge
);

    localparam FAC = 100_000_000 / 100; //100MHz -> 100Hz

    wire btn_reg;
    wire btn_sync;
    wire btn_clean;
    wire btn_clean_q;
    wire tick;
    wire [31:0] count;
    wire [31:0] count_next;

    assign tick = count == FAC-1;
    Mux32_2_1 u_mux(count + 1, 0, tick, count_next);
    Reg #(32, 0) u_reg_count(clk, rst, 1, count_next, count);

    Reg u_reg1(clk, rst, 1, btn_input, btn_reg);
    Reg u_reg2(clk, rst, 1, btn_reg, btn_sync);
    Reg u_reg3(clk, rst, tick, btn_sync, btn_clean);
    Reg u_reg4(clk, rst, 1, btn_clean, btn_clean_q);

    assign btn_posedge = btn_clean & ~btn_clean_q;

endmodule