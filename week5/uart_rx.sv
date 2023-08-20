module uart_rx(
    input clk,   
    input rst_n,    
    output logic rx,
    output logic [7:0] data
);

localparam STR_LEN = 6;
localparam CLK_TICKS_1SEC = 100;

logic [3:0] idx_bit;
logic [3:0] idx_byte;  
logic [13:0] cnt_wait; 
logic [STR_LEN*8-1:0] test_str = "TEST\n";

enum logic [2:0] {
   WAIT_1SEC,
   GET_NEXT_CHAR,
   SEND_START,
   SEND_DATA,
   SEND_STOP
} state, next_state;

always_ff @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) state <= WAIT_1SEC;
    else        state <= next_state;
end

always_comb begin
   next_state = state;
   case(state) 
      WAIT_1SEC:     
         if (cnt_wait == CLK_TICKS_1SEC)
            next_state = GET_NEXT_CHAR;      
      GET_NEXT_CHAR:     
             if (idx_byte == 0) 
                next_state = WAIT_1SEC;
             else 
                next_state = SEND_START;
      SEND_START:
         next_state = SEND_DATA;
      SEND_DATA:
         if (idx_bit == 8) 
            next_state = SEND_STOP;
      SEND_STOP:
         next_state = GET_NEXT_CHAR;
   endcase
end

always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        data <= 0;
        idx_bit <= 0;
        idx_byte <= STR_LEN;
        cnt_wait <= 0;
        rx <= 1;
    end  
    else begin  
    
    case(next_state) 
        
        WAIT_1SEC: 
            begin
                cnt_wait <= cnt_wait + 1;
                idx_byte <= STR_LEN;
                rx <=1;   
            end
        GET_NEXT_CHAR:
            begin
                data <= test_str[(idx_byte*8-1) -: 8];
                cnt_wait <= 0;
                idx_bit <= 0;
            end     
        SEND_START:
            begin
                rx <= 0;
            end
        SEND_DATA:
            begin    
                rx <= data[idx_bit]; 
                idx_bit <= idx_bit + 1;
            end
        SEND_STOP:
            begin 
                rx <= 1;
                idx_byte <= idx_byte -1;
            end         
        endcase 
    end
end
endmodule     