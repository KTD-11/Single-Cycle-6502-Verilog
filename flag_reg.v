
module flag_register (
    input wire clk,
    input wire rst,

    input wire n_en,
    input wire v_en,
    input wire z_en,
    input wire c_en,

    input wire setC,
    input wire clrC,

    input wire n_in,
    input wire v_in,
    input wire z_in,
    input wire c_in,

    output reg n_out,
    output reg v_out,
    output reg z_out,
    output reg c_out
);

always @(posedge clk or posedge rst) begin
  if (rst) begin
    n_out <= 0;
    v_out <= 0;
    z_out <= 0;
    c_out <= 0;
  end

  else begin
    if (n_en)
        n_out <= n_in;

    if (v_en)
        v_out <= v_in;

    if (z_en)
        z_out <= z_in;

    if (clrC)
        c_out <= 0;

    else if (setC)
        c_out <= 1;

    else if (c_en)
        c_out <= c_in;
  end
end

endmodule
