interface intf_object(input bit clk);

    logic rx;
    logic tx;
    
    clocking cb @(posedge clk);
        input rx;
        output tx;
    endclocking
    
    modport DUT(clocking cb);

endinterface


module test(intf_object.DUT intf);

    typedef enum {IDLE, START, DATA, PAR, STOP} uart_states;
  
    logic data_arr[8:0];
    int data_counter;
    logic start_baud;
    logic parity_baud;
    logic stop_baud[1:0];
    
    
    uart_states state;
    
    uart dut (.rx(intf.cb.rx), .tx(intf.cb.tx));
    logic send_bit;
    
    always @ (intf.cb) begin
        
        case (state)
            IDLE : begin
                    send_bit = 1;
                    intf.cb.rx <= 1;
                    data_counter = 0;
                    state = START;
                end
                
            START : begin
                    intf.cb.rx <= 0;
                    state = DATA;
                end
                
            DATA : begin
                    intf.cb.rx <= send_bit;
                    send_bit = ~send_bit;
                    
                    data_counter = data_counter + 1;
                    if (data_counter == 8) begin
                        data_counter = 0;
                        state = STOP;
                    end
            
                end
                
            STOP : begin
                    intf.cb.rx <= 1;
                    data_counter = data_counter + 1;
                    if (data_counter == 2) begin
                        data_counter = 0;
                        state = IDLE;
                    end
                end
        endcase
    end


endmodule : test

module testbench();


    bit clk;
    
    always #10 clk = ~clk;
    
    intf_object intf(clk);
    test my_test(intf.DUT);
	
	
endmodule : testbench

