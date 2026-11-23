
module MUX2X1 (
  input              S,
  input      [7: 0] A,
  input      [7: 0] B,
  output reg [7: 0] Y
);

always @(*) begin
  Y = S ? B : A;
end

endmodule


