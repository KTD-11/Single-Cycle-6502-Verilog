module PC_REG (
    input             clk,
    input      [15: 0] pc_next,
    output reg [15: 0] pc
);
    always @(posedge clk)
        pc <= pc_next;
endmodule
