`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2023 01:16:26
// Design Name: 
// Module Name: top_tx
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


module top_tx (
    input clk,
    input reset,
    input i_tx_signal,              // Pulsador para dar la orden de trnasmision
    output uart_tx_done,        // conexion de led para avisar que se termino de transmitir el dato
    output tx
);

    reg [7:0] constant_data = 8'b10101010; // Este será el número constante que se enviará
    wire tick;

    // Módulo BR Generator
    br_generator #(
        .freq(100_000_000), // 100 MHz por defecto si no se especifica
        .baud_rate(19_200), // 19.2 kBaud por defecto si no se especifica
        .N(10)
    ) br_gen_inst (
        .clk(clk),
        .reset(reset),
        .tick(tick)
    );

    // Módulo UART TX
    uart_tx #(
        .DATA_WIDTH(8),
        .SB_TICKS(16)
    ) uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .i_tx_signal(i_tx_signal),
        .i_ticks(tick),
        .i_data_byte(constant_data),
        .o_tx_done(uart_tx_done),
        .tx(tx)
    );
    

endmodule

