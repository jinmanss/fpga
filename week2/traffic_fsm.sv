typedef enum logic [1:0] {
   GREEN,
   YELLOW,
   RED,
   LEFT
} traffic_light;

module traffic_fsm (
    input wire clk,
    input wire rst_n,
    output traffic_light west, east, north, south, left
);

enum logic [2:0] {
    NS_GREEN, 
    NS_YELLOW,
    NS_YELLOW2, 
    EW_LEFT, 
    EW_YELLOW,
    EW_YELLOW2, 
    EW_GREEN, 
    NS_LEFT
}state, next_state;   
      
localparam GREEN_TIME = 40; 
localparam YELLOW_TIME = 5;
localparam LEFT_TIME = 20;

int counter;

always_ff @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) state <= NS_GREEN;
    else        state <= next_state;
end

always_comb begin
    next_state = state;  
    case (state)
            NS_GREEN: 
                if (counter == GREEN_TIME) 
                    next_state = NS_YELLOW;
            NS_YELLOW: 
                if (counter == YELLOW_TIME) 
                    next_state = EW_LEFT;
            EW_LEFT: 
                if (counter == LEFT_TIME) 
                    next_state = EW_YELLOW;
            EW_YELLOW: 
                if (counter == YELLOW_TIME) 
                    next_state = EW_GREEN;
            EW_GREEN: 
                if (counter == GREEN_TIME) 
                    next_state = EW_YELLOW2;
            EW_YELLOW2: 
                if (counter == YELLOW_TIME) 
                    next_state = NS_LEFT;
            NS_LEFT: 
                if (counter == LEFT_TIME) 
                    next_state = NS_YELLOW2;
            NS_YELLOW2: 
                if (counter == YELLOW_TIME) 
                    next_state = NS_GREEN;
            default: 
                next_state = NS_GREEN;            
    endcase
end

always_ff @(posedge clk or negedge rst_n)
begin   
    north <= RED;
    south <= RED;
    east  <= RED;
    west  <= RED;
    
    if(state  != next_state) begin
        counter <= 0;
    end
    else begin    
        counter <= counter + 1;
    end
    
    case(next_state)
            NS_GREEN: 
                begin 
                north <= GREEN;
                south <= GREEN;
                end
            NS_YELLOW: 
                begin
                north <= YELLOW;
                south <= YELLOW;
                end
            EW_LEFT: 
                begin
                east <= LEFT;
                west <= LEFT;
                end
            EW_YELLOW: 
                begin
                east <= YELLOW;
                west <= YELLOW;
                end
            EW_GREEN: 
                begin
                east <= GREEN;
                west <= GREEN; 
                end
            EW_YELLOW2: 
                begin 
                east <= YELLOW;
                west <= YELLOW;
                end
            NS_LEFT: 
                begin
                north <= LEFT;
                south <= LEFT;
                end
            NS_YELLOW2: 
                begin
                north <= YELLOW;
                south <= YELLOW;
             end  
    endcase 
end    
     
endmodule
