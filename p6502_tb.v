module p6502_tb;

reg clk;
reg rst;

p6502 p6502_DUT(.clk(clk), .rst(rst));

always #5 clk = ~clk;

initial begin

	$readmemh("program.txt", p6502_DUT.MEMORY_INSTANCE.mem);
	
	clk = 0;
	rst = 1;

	#12

	rst = 0;
	
  $display("SORTED ARRAY ($0200-$0207): %h %h %h %h %h %h %h %h",
    p6502_DUT.MEMORY_INSTANCE.mem[16'h0200],
    p6502_DUT.MEMORY_INSTANCE.mem[16'h0201],
    p6502_DUT.MEMORY_INSTANCE.mem[16'h0202],
    p6502_DUT.MEMORY_INSTANCE.mem[16'h0203],
    p6502_DUT.MEMORY_INSTANCE.mem[16'h0204],
    p6502_DUT.MEMORY_INSTANCE.mem[16'h0205],
    p6502_DUT.MEMORY_INSTANCE.mem[16'h0206],
    p6502_DUT.MEMORY_INSTANCE.mem[16'h0207]
  );

	#1000;

  $stop;
end

endmodule
