`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2023 20:05:16
// Design Name: 
// Module Name: baud_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module br_generator #(              // 19200 baud
        parameter   freq        = 100000000,     // number of counter bits
                    baud_rate   = 19200,     // counter limit value
                    N           = 10
    )
    (
        input clk,       // basys 3 clock
        input reset,            // reset
        output tick             // sample tick
    );
       
    // Counter Register
    reg [N-1:0] counter;        // counter value
    wire [N-1:0] next;          // next counter value

    parameter modulo = freq / (baud_rate * 16);
    
    // Register Logic
    always @(posedge clk)
        if(reset)
            counter <= 0;
        else
            counter <= next;
            
    // Next Counter Value Logic
    assign next = (counter == (modulo-1)) ? 0 : counter + 1;
    
    // Output Logic
    assign tick = (counter == (modulo-1)) ? 1'b1 : 1'b0;
endmodule
