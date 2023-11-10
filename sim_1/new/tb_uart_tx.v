`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2023 21:03:14
// Design Name: 
// Module Name: tb_uart_tx
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


module tb_uart_tx;
    //Parametros
    parameter freq = 100_000_000;
    parameter baud_rate = 19200;
    parameter N = 10;
    parameter DATA_WIDTH = 8;
    parameter STOP_WIDTH = 16;
    
    //INPUTS
    reg         clk;    
    reg         reset;
    reg         i_tx_signal;
    reg [DATA_WIDTH-1:0]      i_data_byte = 8'b00101111;
    
    //OUTPUTS
    wire        tick;
    wire        o_tx_done;
    wire        o_tx;
    
    localparam      period = 10;
    localparam      demora = 52083;
    
    reg [DATA_WIDTH-1:0] byte_from_tx = 8'b0;
    integer data_index = 0;
    integer stop_index = 0;
    
    br_generator #(freq, baud_rate, N) uut (
        .clk(clk), 
        .reset(reset), 
        .tick(tick)
    );
    
    uart_tx tb_tx (
        .clk(clk),
        .reset(reset),
        .i_tx_signal(i_tx_signal),
        .i_ticks(tick),
        .i_data_byte(i_data_byte),
        .o_tx_done(o_tx_done),
        .o_tx(o_tx)
    );
        
    initial
    begin
        clk = 1'b0;
        i_tx_signal = 1'b0;
        reset = 1'b1;
        
        #20
        reset = 1'b0;
        #demora
        
        i_tx_signal = 1'b1;   // Bit de START
        #demora
        $display("idle");
        
        if(o_tx == 0)
            begin
            #demora
            $display("start bit detectado a tiempo");
            end
            
        #period
        ////DATA
        for(data_index = 0; data_index < DATA_WIDTH; data_index = data_index +1)
        begin
            //i_data_byte <= byte_to_tx[data_index];
            byte_from_tx[data_index] = o_tx;
            $display("data %d", o_tx);
            #demora;
        end
        
         ////STOP
        for(stop_index = 0; stop_index < STOP_WIDTH; stop_index = stop_index +1)
        begin
            i_tx_signal= 1'b0; ////STOP
            $display("stop ");
            #demora;
        end
        #demora

        $display("data recibido %b \n", o_tx);
    
        if((i_data_byte == byte_from_tx))
          $display("correct");
        else
          $display("failed");
        $finish;
    end
    always #(period/2) clk = ~clk;
    
endmodule