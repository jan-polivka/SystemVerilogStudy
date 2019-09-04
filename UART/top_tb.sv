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

  
    logic data_arr[8:0];
    int data_counter;
    logic start_baud;
    logic parity_baud;
    logic stop_baud[1:0];
    
    uart dut (.rx(intf.cb.rx), .tx(intf.cb.tx));
    logic send_bit;
	initial begin // sequential block
        send_bit = 1;
        intf.cb.rx <= 1;
        data_counter = 0;
	end
    always @ (intf.cb) begin
        //intf.cb.rx <= ~send_bit;
        //intf.cb.rx <= 0;
        send_bit <= ~send_bit;
        if (start_baud == 1) begin
            intf.cb.rx <= send_bit;
            send_bit = ~send_bit;
            
            data_counter = data_counter + 1;
            if (data_counter == 8) begin
                start_baud = 0;
                data_counter = 9;
                intf.cb.rx <= 1;
            end
            //start_baud = 0;
        end
        
        else if (data_counter == 9) begin
            parity_baud = 1;
        end
        
        else begin
            start_baud = 1;
            intf.cb.rx <= 0;
        end
    end


endmodule : test

module testbench(); // Testbench has no inputs, outputs


    bit clk;
    
    always #10 clk = ~clk;
    
    intf_object intf(clk);
    test my_test(intf.DUT);
	
	
endmodule : testbench

