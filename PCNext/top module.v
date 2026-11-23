module program_counter (
    input  wire        clk,
    input  wire        rst,
    input  wire [1:0]  PCSrc,
    input  wire [2:0]  Br_cond,
    input  wire        N,
    input  wire        V,
    input  wire        C,
    input  wire        Z,
    input  wire [1:0]  lengthBytes,
    input  wire [7:0]  byte1,
    input  wire [7:0]  byte2,
    input  wire [7:0]  offset,
    input  wire [15:0] reset_vector,
    output wire [15:0] pc
);

  wire [15: 0] length;

  assign length = lengthBytes;

  wire [15:0] pc_plus_len;
  wire [15:0] branch_target;
  wire [15:0] jump_addr;
  wire [15:0] pc_next;
  wire [15:0] offset_ext = {{8{offset[7]}}, offset};

  reg selected_flag;

  always @(*) begin
    case (Br_cond[2:1])
      2'b00: selected_flag = N;
      2'b01: selected_flag = V;
      2'b10: selected_flag = C;
      2'b11: selected_flag = Z;
    endcase
  end

  wire branch_taken = (selected_flag == Br_cond[0]);

  wire [1:0] pc_mux_sel = rst ? 2'b11 : (PCSrc == 2'b01 && !branch_taken) ? 2'b00 : PCSrc;

  ADDER16 add1 (
      .a   (pc),
      .b   (length),
      .sum (pc_plus_len)
  );

  ADDER16 add2 (
      .a   (pc_plus_len),
      .b   (offset_ext),
      .sum (branch_target)
  );

  JUMP_BLOCK j1 (
      .byte1     (byte1),
      .byte2     (byte2),
      .jump_addr (jump_addr)
  );

  MUX4X1_16 mux (
      .A (pc_plus_len),
      .B (branch_target),
      .C (jump_addr),
      .D (reset_vector),
      .S  (pc_mux_sel),
      .Y  (pc_next)
  );

  PC_REG pc1 (
      .clk     (clk),
      .pc_next (pc_next),
      .pc      (pc)
  );

endmodule
