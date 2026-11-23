module memory (
    input  wire           clk,

    input  wire           wEn_B,
    input  wire           rEn_B,
    input  wire [7  : 0]  dIn_B,

    input  wire [15 : 0]  addr_B,
    input  wire [15 : 0]  addr_A,

    output reg  [23 : 0]  out_A,
    output reg  [7  : 0]  out_B,
    output      [15  : 0]  out_C
);

reg [7:0] mem [0:16'hffff];

assign out_C = {mem[16'hfffD], mem[16'hfffc]}; // {$FFFD, $FFFC}

always @(posedge clk) begin
  if (wEn_B)
      mem[addr_B] <= dIn_B;
end

always @(*) begin
  if (rEn_B)
      out_B = mem[addr_B];
  else
      out_B = 8'h00;
end

always @(*) begin
    out_A = {mem[addr_A], mem[addr_A + 1], mem[addr_A + 2]};
end

endmodule
