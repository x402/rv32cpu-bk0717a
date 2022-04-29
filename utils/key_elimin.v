module key_elimin(
    input clk,          //100MHz
    input rst_n,
    input key_in,
    output reg key_out
);

    parameter   IDLE = 3'b001,
                BUFF = 3'b010,
                DOWN = 3'b100;

    reg [2:0] state;
    reg [20:0] count;
    reg en_cnt;
    reg cnt_full;

    //计数
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            en_cnt <= 0;
            cnt_full <= 0;
            count <= 0;
        end
        else begin
            if(en_cnt)
                if(count == 1_999_999) begin
                    en_cnt <= 0;
                    cnt_full <= 1;
                end
                else
                    count <= count + 1;
        end
    end

    //状态机
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            state <= IDLE;
            key_out <= 0;
        end
        else begin
            case(state)
                IDLE: begin
                    key_out <= 0;
                    if(key_in) begin
                        en_cnt <= 1;
                        cnt_full <= 0;
                        count <= 0;
                        state <= BUFF;
                    end
                end
                BUFF:
                    if(cnt_full)
                        if(key_in)
                            state <= DOWN;
                        else
                            state <= IDLE;
                DOWN: begin
                    key_out <= 1;
                    if(~key_in) begin
                        en_cnt <= 1;
                        cnt_full <= 0;
                        count <= 0;
                        state <= BUFF;
                    end
                end
            endcase
        end
    end
endmodule
