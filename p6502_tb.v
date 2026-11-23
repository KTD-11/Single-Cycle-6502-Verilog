module memory (
    input  wire        clk,
    input  wire        wEn_B,
    input  wire        rEn_B,
    input  wire [7:0]  dIn_B,
    input  wire [15:0] addr_B,
    input  wire [15:0] addr_A,
    output wire [23:0] out_A,
    output wire [7:0]  out_B,
    output wire [15:0] out_C
);

  reg [7:0] mem [0:65535];

  // Port A: 3-byte combinational instruction fetch {opcode, byte1, byte2}
  assign out_A = {mem[addr_A], mem[addr_A + 16'd1], mem[addr_A + 16'd2]};

  // Port B: Combinational read, synchronous write
  assign out_B = rEn_B ? mem[addr_B] : 8'h00;

  always @(posedge clk) begin
    if (wEn_B)
      mem[addr_B] <= dIn_B;
  end

  // Port C: 16-bit little-endian reset vector ($FFFC-$FFFD)
  assign out_C = {mem[16'hFFFD], mem[16'hFFFC]};

endmodule
