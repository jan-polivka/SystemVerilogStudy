module uart(
                            input logic rx,
                            output logic tx
                                            );
    logic data_arr[8:0];
    int data_counter = 0;
    logic start_baud = 0;
    logic parity_baud;
    logic stop_baud[1:0];
    logic curr_rx;
    
    //initial begin
    always @ (rx) begin
        //assign tx = rx;
        //assign curr_rx = rx;
        if (start_baud == 1) begin
            assign tx = rx; 
            data_counter = data_counter + 1;
            
            if (data_counter == 16) begin
                start_baud = 0;
                data_counter = 0;
            end
            //assign start_baud = 0;
        end
        else begin
            if (rx == 0) begin
                start_baud = 1;
            end
        end
    end
endmodule

