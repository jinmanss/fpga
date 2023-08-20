module fifo(
    input logic full,
    input logic empty,
    input logic [7:0] din,
    output logic [7:0] dout,
    input logic rd_clk,
    input logic wr_clk
);

logic rst;
logic wr_en;
logic rd_en;
logic fifo_ready;  
logic fifo_data_in;
logic fifo_data_out;


uart_rx uart_rx_inst(
    .data(din)
);

fifo_generator_0 fifo (
    .full(full)
    ,.empty(empty)
    ,.din(din)
    ,.dout(dout)
    ,.rd_en(rd_en)
    ,.wr_en(wr_en)
    ,.wr_clk(wr_clk)
    ,.rd_clk(rd_clk)
    ,.rst(rst)
); 

always_ff @(posedge wr_clk) begin
    if(~rst && full != 1) begin
        wr_en <= 0; 
    end else begin
        if(fifo_ready) begin
        wr_en <= 1;
        end
    end
end

always_ff @(posedge rd_clk) begin 
    if(~rst && empty != 1) begin 
        rd_en <= 0;
    end else begin
        rd_en <= 1;
    end
end


endmodule
