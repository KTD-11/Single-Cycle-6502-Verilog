module p6502 (
  input wire clk,
  input wire rst
);


wire isZeroPage;

wire ALU_PortBSel;
wire [1: 0] ALU_PortASel;

wire registerFileWriteEnable;
wire [1: 0] Reg_addrSignal;

wire [1: 0] instructionLength;
wire [1: 0] PCSrcSignal;
wire [1: 0] effectiveAddress_LoadSignal;
wire [2: 0] Br_condSignal;
wire [3: 0] ALU_ControlsSignal;

wire [23: 0] memA;
wire [7 : 0] memB;
wire [15 : 0] memC;

wire memWriteEnable;
wire memReadEnable;
wire [7: 0] ALUDataBUS;

wire nFlagEn;
wire vFlagEn;
wire zFlagEn;
wire cFlagEn;

wire nFlagIn;
wire vFlagIn;
wire zFlagIn;
wire cFlagIn;

wire nFlagOut;
wire vFlagOut;
wire zFlagOut;
wire cFlagOut;

wire cFlagClear;
wire cFlagSet;

wire [7:0] A;
wire [7:0] X;
wire [7:0] Y;

wire [15: 0] PC;

wire [15: 0] effectiveAddressOut;

wire [7: 0] effectiveAddressMuxOut;

wire [7: 0] ALU_PortA;
wire [7: 0] ALU_PortB;

control_unit CONTROL_UNIT_INSTANCE(
    .opcode(memA[23: 16]),
    .ZP(isZeroPage),
    .PortB_Sel(ALU_PortBSel),
    .Reg_wr(registerFileWriteEnable),
    .mem_r_en(memReadEnable),
    .mem_w_en(memWriteEnable),
    .N(nFlagEn),
    .Z(zFlagEn),
    .V(vFlagEn),
    .C(cFlagEn),
    .setC(cFlagSet),
    .clrC(cFlagClear),
    .Len(instructionLength),
    .PCSrc(PCSrcSignal),
    .EA_Load(effectiveAddress_LoadSignal),
    .PortA_Sel(ALU_PortASel),
    .Reg_addr(Reg_addrSignal),
    .Br_cond(Br_condSignal),
    .ALU_Controls(ALU_ControlsSignal)
);


memory MEMORY_INSTANCE(
    .clk(clk),
    .wEn_B(memWriteEnable),
    .rEn_B(memReadEnable),
    .dIn_B(ALUDataBUS),
    .addr_B(effectiveAddressOut),
    .addr_A(PC),
    .out_A(memA),
    .out_B(memB),
    .out_C(memC)
);

register_file REG_FILE_INSTANCE(
  .clk(clk),
  .rst(rst),
  .reg_wr(registerFileWriteEnable),
  .reg_addr(Reg_addrSignal),
  .data_in(ALUDataBUS),
  .a_out(A),
  .x_out(X),
  .y_out(Y)
);

flag_register FLAG_REG_INSTANCE(
    .clk(clk),
    .rst(rst),
    .n_en(nFlagEn),
    .v_en(vFlagEn),
    .z_en(zFlagEn),
    .c_en(cFlagEn),
    .setC(cFlagSet),
    .clrC(cFlagClear),
    .n_in(nFlagIn),
    .v_in(vFlagIn),
    .z_in(zFlagIn),
    .c_in(cFlagIn),
    .n_out(nFlagOut),
    .v_out(vFlagOut),
    .z_out(zFlagOut),
    .c_out(cFlagOut)
);


program_counter PC_INSTANCE(
    .clk(clk),
    .rst(rst),
    .PCSrc(PCSrcSignal),
    .Br_cond(Br_condSignal),
    .N(nFlagOut),
    .V(vFlagOut),
    .C(cFlagOut),
    .Z(zFlagOut),
    .lengthBytes(instructionLength),
    .byte1(memA[15: 8]),
    .byte2(memA[7: 0]),
    .offset(memA[15: 8]),
    .reset_vector(memC),
    .pc(PC)
);


MUX4X1 MUX4X1_EA(
  .S(effectiveAddress_LoadSignal),
  .A(X),
  .B(Y),
  .C(8'b0),
  .D(8'b0),
  .Y(effectiveAddressMuxOut)
);


effectiveAddress EA_INSTANCE(
    .init_address({memA[7: 0], memA[15: 8]}),
    .offset(effectiveAddressMuxOut),
    .zero_page(isZeroPage),
    .effective_address(effectiveAddressOut)
);


MUX4X1 MUX4X1_PORT_A(
  .S(ALU_PortASel),
  .A(A),
  .B(X),
  .C(Y),
  .D(memB),
  .Y(ALU_PortA)
);


MUX2X1 MUX2X1_PORT_B(
  .S(ALU_PortBSel),
  .A(memB),
  .B(memA[15: 8]),
  .Y(ALU_PortB)
);

ALU ALU_INSTANCE(
  .A(ALU_PortA),
  .B(ALU_PortB),

  .ALU_Controls(ALU_ControlsSignal),
  .C_in(cFlagOut),
  .V_in(vFlagOut),

  .C_out(cFlagIn),
  .V_out(vFlagIn),
  .N_out(nFlagIn),
  .Z_out(zFlagIn),

  .ALU_Output(ALUDataBUS)
);

endmodule
