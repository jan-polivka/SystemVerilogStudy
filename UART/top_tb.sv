interface intf_object(input bit clk);

    logic rx;
    logic tx;
    
    clocking cb @(posedge clk);
        input rx;
        output tx;
    endclocking
    
    modport DUT(clocking cb);

endinterface

class trans_class;

    logic data_arr[8];
    
    function new();
        data_arr = '{1,0,1,1,0,1,1,0};
    endfunction
    
    function logic get_val(int index);    
        return data_arr[index];;
    endfunction

endclass


module test(intf_object.DUT intf);

    typedef enum {IDLE, START, DATA, PAR, STOP} uart_states;
    
    trans_class trans;
    int data_counter;
    
    logic trans_val;
    
    
    uart_states state;
    
    uart dut (.rx(intf.cb.rx), .tx(intf.cb.tx));
    
    initial begin
        trans = new();    
    end
    
    always @ (intf.cb) begin
        
        case (state)
            IDLE : begin
                    intf.cb.rx <= 1;
                    data_counter = 0;
                    @ (intf.cb);
                    state = START;
                end
                
            START : begin
                    intf.cb.rx <= 0;
                    state = DATA;
                end
                
            DATA : begin
                    intf.cb.rx <= trans.get_val(data_counter);
                    
                    data_counter = data_counter + 1;
                    if (data_counter == 8) begin
                        data_counter = 0;
                        state = STOP;
                    end
            
                end
                
            STOP : begin
                    intf.cb.rx <= 1;
                    data_counter = data_counter + 1;
                    if (data_counter == 1) begin
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

