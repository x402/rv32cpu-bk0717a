module Core(
    input clk,
    input rst_n,

    output [31:0] pc,
    input [31:0] instr,

    output [31:2] addr_to_mem,
    output [3:0] be,
    output mem_wen,
    output [31:0] data_to_mem,
    input [31:0] data_from_mem
);

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
    wire [3:0] rw_type;
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
        .rst_n                   ( rst_n    ),
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
        .rst_n                   ( rst_n       ),
        .rs1                     ( rs1         ),
        .rs2                     ( rs2         ),
        .rd                      ( rd          ),
        .reg_wen                 ( reg_wen     ),
        .data_in                 ( data2reg    ),

        .data_out1               ( rs1_data   ),
        .data_out2               ( rs2_data   )
    );
endmodule