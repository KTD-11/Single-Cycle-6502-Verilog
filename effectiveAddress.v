module effectiveAddress (
    input  wire [15: 0]  init_address,
    input  wire [7:  0]  offset,
    input  wire          zero_page,
    output reg  [15: 0]  effective_address
);


always @(*) begin
  if (zero_page) effective_address = {8'b00000000, init_address[7:0] + offset};
  else effective_address = init_address + offset;
end

endmodule
