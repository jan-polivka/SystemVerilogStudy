module uart(
                            input logic rx,
                            output logic tx
                                            );
    
    typedef enum {IDLE, START, DATA, PAR, STOP} uart_states;
    uart_states state;
    
    logic data_arr[8:0];
    int data_counter = 0;
    logic start_baud = 0;
    logic parity_baud;
    logic stop_baud[1:0];
    logic curr_rx;
    
    //initial begin
    always @ (rx) begin
        
        case (state)
        
            IDLE : begin
                    if (rx == 0) begin
                        state = DATA;
                    end 
                end
            DATA : begin
                    assign tx = rx; 
                    data_counter = data_counter + 1;
            
                    if (data_counter == 16) begin
                        data_counter = 0;
                        state = STOP;
                    end  
                end
                
            STOP : begin
                    data_counter = data_counter + 1;
                    if (data_counter == 4) begin
                        data_counter = 0;
                        state = IDLE;
                    end 
                end
        
        endcase
        
    end
endmodule

