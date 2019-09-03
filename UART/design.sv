module uart(
                            input logic rx,
                            output logic tx
                                            );
    logic data_arr[8:0];
    logic data_counter = 0;
    logic start_baud = 0;
    logic parity_baud;
    logic stop_baud[1:0];
    
    initial begin
        //assign tx = rx;    
        if (start_baud == 1) begin
            assign tx = rx; 
            data_counter = data_counter + 1;
            
            if (data_counter == 8) begin
                assign start_baud = 0;
                data_counter = 0;
            end
        end
        else begin
            //if (rx == 0) begin
                start_baud = 1;
            //end
        end
    end
endmodule

