module register_file (
  input  wire       clk,
  input  wire       rst,
  input  wire       reg_wr,
  input  wire [1:0] reg_addr,
  input  wire [7:0] data_in,
  output reg  [7:0] a_out,
  output reg  [7:0] x_out,
  output reg  [7:0] y_out
);

always @(posedge clk or posedge rst) begin
  if (rst) begin
    a_out <= 8'h00;
    x_out <= 8'h00;
    y_out <= 8'h00;
  end

  else if (reg_wr) begin
    case (reg_addr)
      2'b00:   a_out <= data_in;
      2'b01:   x_out <= data_in;
      2'b10:   y_out <= data_in;
      default: ;
    endcase
  end
end

endmodule
