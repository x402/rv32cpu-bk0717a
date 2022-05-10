module BK0717A(
    input clk,
    input rst_n,
    input clk0,
    input rst0_n,

    output [15:0] seg_sel_n,
    output [7:0] seg
);

    // wire clk_btn;
    // key_elimin u_key_clk0 (
    //     .clk                     ( clk       ),
    //     .rst_n                   ( rst_n     ),
    //     .key_in                  ( clk0     ),

    //     .key_out                 ( clk_btn   )
    // );

    wire [31:0] pc, instr;
    wire [31:0] addr_to_mem, data_to_mem, data_from_mem;
    wire [3:0] be;
    wire mem_wen;

    rom_ip u_rom_ip(
        .clka                       ( clk           ),
        .addra                      ( pc            ),
        .douta                      ( instr         )
    );

    Core  u_Core (
        .clk                     ( clk0         ),//clk_btn
        .rst_n                   ( rst0_n          ),
        .instr                   ( instr           ),
        .data_from_mem           ( data_from_mem   ),

        .pc                      ( pc              ),
        .addr_to_mem             ( addr_to_mem     ),
        .be                      ( be              ),
        .mem_wen                 ( mem_wen         ),
        .data_to_mem             ( data_to_mem     )
    );

    ram_ip u_ram_ip0(
        .clka                   ( clk0           ),//clk_btn
        .ena                    ( be[0]             ),
        .wea                    ( mem_wen           ),
        .addra                  ( addr_to_mem[7:2]  ),
        .dina                   ( data_to_mem[7:0]  ),
        .douta                  ( data_from_mem[7:0])
    );
    ram_ip u_ram_ip1(
        .clka                   ( clk0           ),//clk_btn
        .ena                    ( be[1]             ),
        .wea                    ( mem_wen           ),
        .addra                  ( addr_to_mem[7:2]  ),
        .dina                   ( data_to_mem[15:8]  ),
        .douta                  ( data_from_mem[15:8])
    );
    ram_ip u_ram_ip2(
        .clka                   ( clk0           ),//clk_btn
        .ena                    ( be[2]             ),
        .wea                    ( mem_wen           ),
        .addra                  ( addr_to_mem[7:2]  ),
        .dina                   ( data_to_mem[23:16]  ),
        .douta                  ( data_from_mem[23:16])
    );
    ram_ip u_ram_ip3(
        .clka                   ( clk0           ),//clk_btn
        .ena                    ( be[3]             ),
        .wea                    ( mem_wen           ),
        .addra                  ( addr_to_mem[7:2]  ),
        .dina                   ( data_to_mem[31:24]  ),
        .douta                  ( data_from_mem[31:24])
    );


    seg16 u_seg16 (
        .clk                     ( clk         ),
        .rst_n                   ( rst_n       ),
        .data_A                  ( instr[15:0] ),
        .data_B                  ( instr[31:16]),
        .data_C                  ( pc[15:0]    ),
        .data_D                  ( pc[31:16]   ),

        .seg_sel_n               ( seg_sel_n   ),
        .seg                     ( seg         )
    );

endmodule