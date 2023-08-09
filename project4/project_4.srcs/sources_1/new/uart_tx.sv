`timescale 1ns / 1ps 

module uart_tx(
   input clk,       //100?¸·Î 
   
   output logic tx
);

localparam STR_LEN = 10;    //»ó¼ö·Î ÇÏ¸é ³ªÁß¿¡ Çò°¥¸± ¼ö ?Ö´Ù 
localparam BAUDRATE = 10000;  
localparam CLK_TICKS_1SEC = 100; 

logic [7:0] data;
logic [3:0] idx_bit;
logic [3:0] idx_byte;  
logic [13:0] cnt_wait; // ±â´Ù¸®±â ?§ÇØ¼­ »ç¿ëÇÏ´Â Ä«¿îÅÍ
logic [STR_LEN*8-1:0] test_str = "JIN YOUNG\n";

wire mclk;
logic clk_uart;
wire rst_n;

enum logic [2:0] {
   WAIT_1SEC,
   GET_NEXT_CHAR,
   SEND_START,
   SEND_DATA,
   SEND_STOP
}state, next_state;

always_ff @(posedge mclk) begin
    static int cnt;

    if (cnt >= 50) begin
        cnt <= 0;
        clk_uart <= ~clk_uart;
    end else begin
        cnt <= cnt + 1;
    end
end



/*********************************************
*                 ?��브모?��
**********************************************/

/* MMCM */
mmcm_50m mmcm (
     .reset(1'b0)
    ,.clk_in1(clk)
    ,.clk_out1(mclk)
);


/* FPGA ?���? 로직 분석�? */
ila_0 ila(
     .clk       (mclk)
    ,.probe0    (clk_uart)
    ,.probe1    (tx)
    ,.probe2    (data)
    ,.probe3    (mmcm_locked)
    ,.probe4    (idx_byte)
    ,.probe5    (idx_bit)
    ,.probe6    (state)
    ,.probe7    (next_state)
);


/* �??�� ?��출력 */
vio vio(
     .clk   (mclk)
    ,.probe_out0 (rst_n)
);

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
        tx <= 1;
    end  
    else begin  
    
    case(next_state) 
        
        WAIT_1SEC: 
            begin
                cnt_wait <= cnt_wait + 1;
                idx_byte <= STR_LEN;
                tx <=1;   
            end
        GET_NEXT_CHAR:
            begin
                data <= test_str[(idx_byte*8-1) -: 8];
                cnt_wait <= 0;
                idx_bit <= 0;
            end     
        SEND_START:
            begin
                tx <= 0;
            end
        SEND_DATA:
            begin    
                tx <= data[idx_bit]; 
                idx_bit <= idx_bit + 1;
            end
        SEND_STOP:
            begin 
                tx <= 1;
                idx_byte <= idx_byte -1;
            end         
        endcase 
    end
end
endmodule