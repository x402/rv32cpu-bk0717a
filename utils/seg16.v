module Seg16(
    input clk,
    input rst,
    input [15:0] data_A,
    input [15:0] data_B,
    input [15:0] data_C,
    input [15:0] data_D,
    output reg [15:0] seg_sel_n,
    output reg [7:0] seg
);

    localparam  SEG_NUM0 = 8'hc0,
                SEG_NUM1 = 8'hf9,
                SEG_NUM2 = 8'ha4,
                SEG_NUM3 = 8'hb0,
                SEG_NUM4 = 8'h99,
                SEG_NUM5 = 8'h92,
                SEG_NUM6 = 8'h82,
                SEG_NUM7 = 8'hf8,
                SEG_NUM8 = 8'h80,
                SEG_NUM9 = 8'h90,
                SEG_NUMA = 8'h88,
                SEG_NUMB = 8'h83,
                SEG_NUMC = 8'hc6,
                SEG_NUMD = 8'ha1,
                SEG_NUME = 8'h86,
                SEG_NUMF = 8'h8e;

    reg [3:0] count;
    reg [15:0] count_10000;
    reg [3:0] data_out;

    //分频
    always @(posedge clk) begin
        if(rst) begin
            count <= 2'h0;
            count_10000 <= 16'd0;
        end
        else begin
            if(count_10000 == 16'd9999) begin
                count_10000 <= 16'd0;
                count <= count + 2'h1;
            end
            else
                count_10000 <= count_10000 + 16'd1;
        end
    end

    always @(*) begin
        case(count)
            4'h0 : begin
                seg_sel_n = ~16'b0001;
                data_out = data_A[3:0];
            end
            4'h1 : begin
                seg_sel_n = ~16'b0010;
                data_out = data_A[7:4];
            end
            4'h2 : begin
                seg_sel_n = ~16'b0100;
                data_out = data_A[11:8];
            end
            4'h3 : begin
                seg_sel_n = ~16'b1000;
                data_out = data_A[15:12];
            end
            4'h4 : begin
                seg_sel_n = ~16'b0001_0000;
                data_out = data_B[3:0];
            end
            4'h5 : begin
                seg_sel_n = ~16'b0010_0000;
                data_out = data_B[7:4];
            end
            4'h6 : begin
                seg_sel_n = ~16'b0100_0000;
                data_out = data_B[11:8];
            end
            4'h7 : begin
                seg_sel_n = ~16'b1000_0000;
                data_out = data_B[15:12];
            end
            4'h8 : begin
                seg_sel_n = ~16'b0001_0000_0000;
                data_out = data_C[3:0];
            end
            4'h9 : begin
                seg_sel_n = ~16'b0010_0000_0000;
                data_out = data_C[7:4];
            end
            4'ha : begin
                seg_sel_n = ~16'b0100_0000_0000;
                data_out = data_C[11:8];
            end
            4'hb : begin
                seg_sel_n = ~16'b1000_0000_0000;
                data_out = data_C[15:12];
            end
            4'hc : begin
                seg_sel_n = ~16'b0001_0000_0000_0000;
                data_out = data_D[3:0];
            end
            4'hd : begin
                seg_sel_n = ~16'b0010_0000_0000_0000;
                data_out = data_D[7:4];
            end
            4'he : begin
                seg_sel_n = ~16'b0100_0000_0000_0000;
                data_out = data_D[11:8];
            end
            4'hf : begin
                seg_sel_n = ~16'b1000_0000_0000_0000;
                data_out = data_D[15:12];
            end
        endcase

        case(data_out)
            4'h0 : seg = SEG_NUM0;
            4'h1 : seg = SEG_NUM1;
            4'h2 : seg = SEG_NUM2;
            4'h3 : seg = SEG_NUM3;
            4'h4 : seg = SEG_NUM4;
            4'h5 : seg = SEG_NUM5;
            4'h6 : seg = SEG_NUM6;
            4'h7 : seg = SEG_NUM7;
            4'h8 : seg = SEG_NUM8;
            4'h9 : seg = SEG_NUM9;
            4'ha : seg = SEG_NUMA;
            4'hb : seg = SEG_NUMB;
            4'hc : seg = SEG_NUMC;
            4'hd : seg = SEG_NUMD;
            4'he : seg = SEG_NUME;
            4'hf : seg = SEG_NUMF;
        endcase
    end

endmodule
