`timescale 1ns / 1ps

module test_br_generator;

    // Parameters
    parameter freq = 100_000_000; // 100 MHz
    parameter baud_rate = 19200;
    parameter N = 10;

    // Signals
    reg clk;
    reg reset;

    wire o_tick;
    wire [N-1:0] counter;

    // Instantiate the Unit Under Test (UUT)
    br_generator #(freq, baud_rate, N) uut (
        .clk(clk), 
        .reset(reset), 
        .tick(o_tick)
    );
    
    always begin
        #5 clk = ~clk; // clk 100[MHz]
    end

        initial
    begin         
            clk = 1'b0;
            reset = 1;
		    #20
		    reset = 0;
		    #10000;  
     end
     
    

endmodule