module JUMP_BLOCK (
    input  [7 : 0]  byte1,
    input  [7 : 0]  byte2,
    output [15: 0] jump_addr
);

    assign jump_addr = {byte2, byte1};
endmodule
