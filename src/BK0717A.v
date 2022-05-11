module BK0717A(
    input clk,
    input rst,
    input btn,

    output [15:0] seg_sel_n,
    output [7:0] seg
);

    wire  btn_posedge;

    Button  u_Button (
        .clk                     ( clk           ),
        .rst                     ( rst           ),
        .btn_input               ( btn           ),

        .btn_posedge             ( btn_posedge   )
    );
//==========================================================

    wire [31:0] pc, instr;
    wire [31:0] addr_to_mem, data_to_mem, data_from_mem;
    wire [3:0] be;
    //wire mem_wen;

    rom_ip u_rom_ip(
        .clka                       ( clk           ),
        .addra                      ( pc            ),
        .douta                      ( instr         )
    );

    // Core  u_Core (
    //     .clk                     ( clk             ),
    //     .rst                     ( rst             ),
    //     .instr                   ( instr           ),
    //     .data_from_mem           ( data_from_mem   ),

    //     .pc                      ( pc              ),
    //     .addr_to_mem             ( addr_to_mem     ),
    //     .be                      ( be              ),
    //     .mem_wen                 ( mem_wen         ),
    //     .data_to_mem             ( data_to_mem     )
    // );

    wire pc_new;
/*+-------------------------------------+
  |                 PC                  |
  +-------------------------------------+*/
    //wire pc;
    //wire [31:0] instr;
/*+-------------------------------------+
  |                 ID                  |
  +-------------------------------------+*/
    wire [4:0] rs1, rs2, rd;
    wire [31:0] imm;
    wire [2:0] alu_ctrl;
    wire num2_sel;
    wire [3:0] rw_type;
    wire mem_wen, mem_ren;
    wire [5:0] b_ins;
    wire [1:0] j_ins, u_ins;
    wire reg_wen;

    wire [31:0] rs1_data, rs2_data;
/*+-------------------------------------+
  |                 EX                  |
  +-------------------------------------+*/
    wire [31:0] alu_result;
    wire [3:0] flags;

    wire [31:0] data_w;
    //wire [3:0] rw_type;
    //wire [31:0] addr      //alu_result -> addr
/*+-------------------------------------+
  |                 AM                  |
  +-------------------------------------+*/
    //wire [31:2] addr_to_mem;
    //wire [3:0] be;
    //wire [31:0] data_to_mem, data_from_mem;
    wire [31:0] data_r;
/*+-------------------------------------+
  |                 WB                  |
  +-------------------------------------+*/
    wire [31:0] data2reg;
    //wire [4:0] rs1, rs2, rd;
    //wire reg_wen;
/*+-------------------------------------+
  |               RegFile               |
  +-------------------------------------+*/
    //wire [31:0] rs1_data, rs2_data;


//================instance================
    PC32  u_PC32 (
        .clk                     ( clk      ),
        .rst                     ( rst      ),
        .pc_wen                  (btn_posedge),
        .pc_new                  ( pc_new   ),

        .pc                      ( pc       )
    );

    Decoder  u_Decoder (
        .instr                   ( instr      ),

        .rs1                     ( rs1        ),
        .rs2                     ( rs2        ),
        .rd                      ( rd         ),
        .imm                     ( imm        ),
        .alu_ctrl                ( alu_ctrl   ),
        .num2_sel                ( num2_sel   ),
        .rw_type                 ( rw_type    ),
        .mem_wen                 ( mem_wen    ),
        .mem_ren                 ( mem_ren    ),
        .b_ins                   ( b_ins      ),
        .j_ins                   ( j_ins      ),
        .u_ins                   ( u_ins      ),
        .reg_wen                 ( reg_wen    )
    );

    ALU32  u_ALU32 (
        .rs1_data                ( rs1_data   ),
        .rs2_data                ( rs2_data   ),
        .imm                     ( imm        ),
        .num2_sel                ( num2_sel   ),
        .alu_ctrl                ( alu_ctrl   ),

        .result                  ( alu_result ),
        .flags                   ( flags      )
    );

    AccessMem  u_AccessMem (
        .data_w                  ( data_w          ),
        .addr                    ( alu_result      ),
        .rw_type                 ( rw_type         ),
        .data_from_mem           ( data_from_mem   ),

        .data_r                  ( data_r          ),
        .addr_to_mem             ( addr_to_mem     ),
        .be                      ( be              ),
        .data_to_mem             ( data_to_mem     )
    );

    WriteBack  u_WriteBack (
        .pc                      ( pc           ),
        .imm                     ( imm          ),
        .alu_result              ( alu_result   ),
        .data_r                  ( data_r       ),
        .b_ins                   ( b_ins        ),
        .flags                   ( flags        ),
        .j_ins                   ( j_ins        ),
        .u_ins                   ( u_ins        ),
        .mem_ren                 ( mem_ren      ),

        .pc_new                  ( pc_new       ),
        .data2reg                ( data2reg     )
    );

    RegFile32  u_RegFile32 (
        .clk                     ( clk         ),
        .rst                     ( rst         ),
        .rs1                     ( rs1         ),
        .rs2                     ( rs2         ),
        .rd                      ( rd          ),
        .reg_wen                 ( reg_wen     ),
        .data_in                 ( data2reg    ),

        .data_out1               ( rs1_data   ),
        .data_out2               ( rs2_data   )
    );
//======================================================

    ram_ip u_ram_ip0(
        .clka                   ( clk               ),
        .ena                    ( be[0]             ),
        .wea                    (mem_wen&btn_posedge),
        .addra                  ( addr_to_mem[7:2]  ),
        .dina                   ( data_to_mem[7:0]  ),
        .douta                  ( data_from_mem[7:0])
    );
    ram_ip u_ram_ip1(
        .clka                   ( clk               ),
        .ena                    ( be[1]             ),
        .wea                    ( mem_wen&btn_posedge           ),
        .addra                  ( addr_to_mem[7:2]  ),
        .dina                   ( data_to_mem[15:8]  ),
        .douta                  ( data_from_mem[15:8])
    );
    ram_ip u_ram_ip2(
        .clka                   ( clk               ),
        .ena                    ( be[2]             ),
        .wea                    ( mem_wen&btn_posedge           ),
        .addra                  ( addr_to_mem[7:2]  ),
        .dina                   ( data_to_mem[23:16]  ),
        .douta                  ( data_from_mem[23:16])
    );
    ram_ip u_ram_ip3(
        .clka                   ( clk               ),
        .ena                    ( be[3]             ),
        .wea                    ( mem_wen&btn_posedge           ),
        .addra                  ( addr_to_mem[7:2]  ),
        .dina                   ( data_to_mem[31:24]  ),
        .douta                  ( data_from_mem[31:24])
    );


    Seg16 u_seg16 (
        .clk                     ( clk         ),
        .rst                     ( rst         ),
        .data_A                  ( instr[15:0] ),
        .data_B                  ( instr[31:16]),
        .data_C                  ( pc[15:0]    ),
        .data_D                  ( pc[31:16]   ),

        .seg_sel_n               ( seg_sel_n   ),
        .seg                     ( seg         )
    );

endmodule