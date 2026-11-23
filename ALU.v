module ALU (
  input  wire [7: 0] A,
  input  wire [7: 0] B,

  input  wire [3: 0] ALU_Controls,
  input  wire        C_in,
  input  wire        V_in,

  output reg         C_out,
  output             V_out,
  output             N_out,
  output             Z_out,

  output reg  [7: 0] ALU_Output
);

assign Z_out = ~(ALU_Output[0] | ALU_Output[1] | ALU_Output[2] | ALU_Output[3] | ALU_Output[4] | ALU_Output[5] | ALU_Output[6] | ALU_Output[7]);
assign N_out = ALU_Output[7];
wire B_sign = (ALU_Controls == 4'b0001) ? ~B[7] : B[7];
assign V_out = (ALU_Controls == 4'b0000 || ALU_Controls == 4'b0001) ? (~(A[7] ^ B_sign) & (A[7] ^ ALU_Output[7])) : V_in;

always @(*) begin
  case(ALU_Controls)
    4'b0000: {C_out, ALU_Output} = A + B + C_in;

    4'b0001: begin 
      {C_out, ALU_Output} = A - B - ~C_in;
      C_out = !C_out;
    end

    4'b0010: {C_out, ALU_Output} = A + 1;
    4'b0011: {C_out, ALU_Output} = A - 1;

    4'b0100: begin
      {C_out, ALU_Output} = A - B;
      C_out = !C_out;
    end

    4'b0101: {C_out, ALU_Output} = A & B;
    4'b0110: {C_out, ALU_Output} = A | B;
    4'b0111: {C_out, ALU_Output} = A ^ B;
    4'b1000: {C_out, ALU_Output} = {A[7: 0],  1'b0};
    4'b1001: {ALU_Output, C_out} = {1'b0, A[7:  0]};
    4'b1010: {C_out, ALU_Output} = {A[7: 0], C_in};
    4'b1011: {ALU_Output, C_out} = {C_in, A[7: 0]};
    4'b1100: {C_out, ALU_Output} = A;
    4'b1101: {C_out, ALU_Output} = B;
    default: {C_out, ALU_Output} = 9'b0;
  endcase
end

endmodule

