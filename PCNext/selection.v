module PC_SRC_SELECTION (
    input             rst,
    input             jump,
    input             branch,
    input             required_value,
    input             flag,
    output reg [1: 0] pc_src_sel
);
    wire branch_taken = branch & (flag == required_value);

    always @(*) begin
        if (rst)                pc_src_sel = 2'b11;
        else if (jump)          pc_src_sel = 2'b10;
        else if (branch_taken)  pc_src_sel = 2'b01;
        else                    pc_src_sel = 2'b00;
    end
endmodule
