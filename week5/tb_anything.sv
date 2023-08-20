`timescale 1ns / 1ps

module tb_anything(
);

logic din, dout, wr_clk, rd_clk, full,empty;

logic clk;
logic rst;

fifo dut_fifo(
    .din(din),
    .dout(dout)
	,.full(full)
	,.empty(empty)
	
);

initial begin
	clk 	= 0;
	rst 	= 1;
	wr_clk = 0;
	rd_clk = 0;
	din = 0;
	dout = 0;
	

    
	#50
	rst 	= 0;

	#20
	rst 	= 1;
end

always begin
	#5
	rd_clk = ~rd_clk;
end


always begin
	#5
	wr_clk = ~wr_clk;
end



endmodule