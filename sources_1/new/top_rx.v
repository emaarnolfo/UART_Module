`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2023 01:10:47
// Design Name: 
// Module Name: top_rx
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

// Top que se encarga de recibir una señal y mapearla en los leds

module top_rx(
    input clk,
    input reset,
    input i_rx,
    output [7:0] resultado,
    output reg      rx_done
);

    wire ticks;

    // Instantiate BR Generator
    br_generator #(
        .freq(100_000_000), // 100 MHz por defecto si no se especifica
        .baud_rate(19_200), // 19.2 kBaud por defecto si no se especifica
        .N(10)
    ) br_gen_inst (
        .clk(clk),
        .reset(reset),
        .tick(ticks)
    );

    // Instantiate UART Receiver
    uart_rx #(
        .DATA_WIDTH(8),
        .SB_TICKS(16)
    ) uart_rx_inst (
        .clk(clk),
        .reset(reset),
        .i_ticks(ticks),
        .i_rx(i_rx),
        .o_rx_done(rx_done),
        .o_data_byte(resultado)
    );

endmodule
