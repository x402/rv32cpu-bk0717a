module AM(
    input   [31:0]  data_w,
    output  [31:0]  data_r,
    input   [31:0]  addr,
    input   [3:0]   rw_type,        //{u, w, h, b}
    output  [31:2]  addr_to_mem,
    output  [3:0]   be,             //brank enable
    output  [31:0]  data_to_mem,
    input   [31:0]  data_from_mem
); 

    wire u, w, h, b;
    assign u = rw_type[3];
    assign w = rw_type[2];
    assign h = rw_type[1];
    assign b = rw_type[0];

    wire [1:0] a;
    assign a = addr[1:0];
    assign addr_to_mem = addr[31:2];
    assign be[0] = ~a[1] & ~a[0] & (b | h | w);
    assign be[1] = ~a[1] & a[0] & b | ~a[1] & ~a[0] & (h | w);
    assign be[2] = a[1] & ~a[0] & (b | h) | ~a[1] & ~a[0] & w;
    assign be[3] = a[1] & a[0] & b | a[1] & ~a[0] & h | ~a[1] & ~a[0] & w;

    //write (store)
    wire [31:0] data_w_b;
    wire [31:0] data_w_h;
    assign data_w_b = {4{data_w[7:0]}};
    assign data_w_h = {2{data_w[15:0]}};
    assign data_to_mem =    w == 1  ? data_w    :
                            h == 1  ? data_w_h  :
                            b == 1  ? data_w_b  :
                                      {32{1'b0}};

    //read (load)
    wire [7:0] data_r_b;
    wire [15:0] data_r_h;
    assign data_r_b =   {8{be[0]}} & data_from_mem[7:0]     |
                        {8{be[1]}} & data_from_mem[15:8]    |
                        {8{be[2]}} & data_from_mem[23:16]   |
                        {8{be[3]}} & data_from_mem[31:24];

    assign data_r_h =   {16{be[0]}} & data_from_mem[15:0]   |
                        {16{be[2]}} & data_from_mem[31:16];

    wire h_ext;
    wire b_ext;
    assign h_ext = data_r_h[15];
    assign b_ext = data_r_b[7];
    assign data_r[31:16] =  w == 1      ? data_from_mem[31:16]:
                            u == 1      ? {16{1'b0}}    :
                            h == 1      ? {16{h_ext}}   :
                            b == 1      ? {16{b_ext}}   :
                                          {16{1'b0}};

    assign data_r[15:8] =   w == 1      ? data_from_mem[15:8]:
                            h == 1      ? data_r_h[15:8]:
                            u == 1      ? {8{1'b0}}     :
                            b == 1      ? {8{b_ext}}    :
                                          {8{1'b0}};

    assign data_r[7:0] =    w == 1      ? data_from_mem[7:0]:
                            h == 1      ? data_r_h[7:0] :
                            b == 1      ? data_r_b      :
                                          {8{1'b0}};
endmodule