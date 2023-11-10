`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2023 20:05:16
// Design Name: 
// Module Name: uart
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


module uart #(
    parameter DATA_WIDTH = 8,
                SB_TICKS = 16,
                freq     = 100_000_000,
               baud_rate = 19200,
                       N = 10 
)(
    input clk,
    input reset,

    // UART TX signals
    input i_tx_signal,
    input [DATA_WIDTH - 1:0] i_data_byte,
    output o_tx_done,
    output tx,

    // UART RX signals
    input i_rx,
    output o_rx_done,
    output [DATA_WIDTH - 1:0] o_data_byte
);

    wire tick;

    // Instantiate baud_rate_generator
    br_generator #(
        .freq(freq),
        .baud_rate(baud_rate),
        .N(N)
    ) br_inst (
        .clk(clk),
        .reset(reset),
        .tick(tick)
    );

    // Instantiate UART TX
    uart_tx #(
        .DATA_WIDTH(DATA_WIDTH),
        .SB_TICKS(SB_TICKS)
    ) uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .i_tx_signal(i_tx_signal),
        .i_ticks(tick),
        .i_data_byte(i_data_byte),
        .o_tx_done(o_tx_done),
        .tx(tx)
    );

    // Instantiate UART RX
    uart_rx #(
        .DATA_WIDTH(DATA_WIDTH),
        .SB_TICKS(SB_TICKS)
    ) uart_rx_inst (
        .clk(clk),
        .reset(reset),
        .i_ticks(tick),
        .i_rx(i_rx),
        .o_rx_done(o_rx_done),
        .o_data_byte(o_data_byte)
    );

endmodule

