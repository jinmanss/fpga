`timescale 1ns / 1ps

module uart_tb();

logic clk;
logic rst_n;

initial begin
	clk 	= 0;
	rst_n 	= 1;

	#20
	rst_n 	= 0;

	#20
	rst_n 	= 1;
end

// Å¬·°
always begin
	#5
	clk = ~clk;
end

uart_tx dut_uart(
    .clk (clk)
    ,.rst_n (rst_n)
    ,.tx (tx)    
);

endmodule