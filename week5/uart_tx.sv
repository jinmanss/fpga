module uart_tx(
    input clk,
    input rst_n,
    output logic tx,
    input logic [7:0] data,
    input logic fifo_empty,
    output logic rd_en
);
fifo fifo_inst(
    .dout (data)
    ,.empty(fifo_empty)
);

enum logic [2:0] {
   READY,
   START,
   DATA,
   STOP
} state, next_state;

logic [12:0] cnt;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= READY;
    else state <= next_state;
end

always_comb begin
    next_state = state;
    case (state)
        READY:
            if (!fifo_empty) next_state = START;
        START:
            next_state = DATA;
        DATA:
            if (cnt == 7) next_state = STOP;
            else next_state = DATA;
        STOP:
            if (fifo_empty) next_state = READY;
            else next_state = START;
    endcase
end

always_ff @(posedge clk) begin
    case (state)
        READY:
            begin
                tx <= 1;
                rd_en <= 0;
            end
        START:
            begin
                tx <= 0;
                cnt <= 0;
                rd_en <= 1;
            end
        DATA:
            begin
                tx <= data[cnt];
                 cnt <=  cnt + 1;
            end
        STOP:
            tx <= 1;
    endcase
end

endmodule
















