typedef enum logic [1:0] {
   GREEN,
   YELLOW,
   RED,
   LEFT
} traffic_light;

enum logic [2:0] {
    NS_GREEN, 
    NS_YELLOW, 
    EW_LEFT, 
    EW_YELLOW, 
    EW_GREEN, 
    NS_LEFT
}state, next_state;

module traffic_fsm (
    input wire clk,
    input wire rst_n,
    output traffic_light west, east, north, south, left
);

          
parameter GREEN_TIME = 40, 
          YELLOW_TIME = 5, 
          LEFT_TIME = 20;

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
                    next_state = EW_YELLOW;
            EW_YELLOW: 
                if (counter == YELLOW_TIME) 
                    next_state = NS_LEFT;
            NS_LEFT: 
                if (counter == LEFT_TIME) 
                    next_state = NS_YELLOW;
            NS_YELLOW: 
                if (counter == YELLOW_TIME) 
                    next_state = NS_GREEN;
            default: 
                next_state = NS_GREEN;            
    endcase
end

always_ff @(posedge clk or negedge rst_n)
begin   
    counter <= 0; 
    case(next_state)
            NS_GREEN: 
                begin 
                counter <= counter +1;
                north <= GREEN;
                south <= GREEN;
                end
            NS_YELLOW: 
                begin
                counter <= counter +1;
                north <= YELLOW;
                south <= YELLOW;
                end
            EW_LEFT: 
                begin
                counter <= counter +1;
                east <= LEFT;
                west <= LEFT;
                end
            EW_YELLOW: 
                begin
                counter <= counter +1;
                east <= YELLOW;
                west <= YELLOW;
                end
            EW_GREEN: 
                begin
                counter <= counter +1;
                east <= GREEN;
                west <= GREEN; 
                end
            EW_YELLOW: 
                begin 
                counter <= counter +1;
                east <= YELLOW;
                west <= YELLOW;
                end
            NS_LEFT: 
                begin
                counter <= counter +1;
                north <= LEFT;
                south <= LEFT;
                end
            NS_YELLOW: 
                begin
                counter <= counter +1;
                north <= YELLOW;
                south <= YELLOW;
             end  
    endcase 
end    
     
endmodule
