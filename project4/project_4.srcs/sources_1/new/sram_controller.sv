module sram_controller(
    input wire clk,
    input wire rst_n,
    output logic [15:0] addr,
    output logic ce_n,
    output logic oe_n,
    output logic we_n,
    output logic tri_sel
);

logic  [7:0] data;


enum logic [2:0] {
    RESET, READY, WRITE, READ, DONE
}state, next_state;

logic [7:0] data;
logic [2:0] wr_idx;
logic [2:0] re_idx;
logic [7:0] data_out;
assign data = tri_sel ? data_out : 8'bz;     // tri_sel�� high�̸� data�� data_out�� �ְ� low�� data�� 8'bz��� ���� ���Ǵ����� �־� ����� �ȵǰ� �Ѵ�?.

// ���� ��� 
mmcm_50m mmcm (
    .reset(1'b0)
   ,.clk_in1(clk)
   ,.clk_out1(mclk)
   ,.locked()
);


/* ���� �Ƴ������� */
ila_sram_ctrl ila(
    .clk      (mclk)
   ,.probe0    (rst_n)
   ,.probe1    (oe_n)
   ,.probe2    (ce_n)
   ,.probe3    (we_n)
   ,.probe4    (addr)
   ,.probe5    (data)
   ,.probe6    (tri_sel)
   ,.probe7    (state)
   ,.probe8    (next_state)
);


/* ���� ����� */
vio_0 vio(
    .clk    (mclk)
   ,.probe_out0 (rst_n)
);


//FSM

always_ff @(posedge clk or negedge rst_n)
    if(!rst_n) state <= RESET;
    else state <= next_state;
    
    
always_comb begin
    next_state = state;
    
    case(state)
    RESET: next_state = READY;
    
    READY: begin
           if(( tri_sel = 1) && (wr_idx < 10)) 
                next_state = WRITE;
           else if(( tri_sel = 0) && (re_idx < 10))
                next_state = READY;
           end  
    WRITE: begin
           if(wr_idx <= 10)
           tri_sel = 0; 
           next_state = READY;
           end
    READ:  begin 
           if(re_idx <= 10);
           next_state = READY;
           tri_sel =1;
           end 
    DONE: next_state = state;
    
    default: state = RESET;
    
    endcase
end
       
always_ff @(posedge clk or negedge rst_n) begin
    oe_n <= 1;
    ce_n <= 1;
    we_n <= 1;
    tri_sel = 0;
    wr_idx 	<= 0;
	re_idx 	<= 0;
    
    case(next_state)                
    WRITE: begin
           ce_n <= 0;
           we_n <= 0;
           addr <= wr_idx;
           wr_idx <= wr_idx + 1;
           data_out <= wr_idx;
           end
    READ:  begin
           oe_n <= 0; 
           re_idx <= re_idx + 1;
           addr <= re_idx;
           data_out <= addr;
           end
    DONE: begin
		  ce_n <= 1;
		  oe_n <= 1;
		  we_n <= 1;
		  tri_sel <= 0;
    endcase
end
endmodule 
 
 