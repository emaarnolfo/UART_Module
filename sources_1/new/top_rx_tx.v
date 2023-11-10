module top_rx_tx (
    //INPUTS
    input clk,
    input reset,
    input i_rx,
    input tx_signal,

    //OUTPUTS
    output o_tx,
    output o_tx_done,
    output o_rx_done,
    output [7:0] resultado
);

    wire [7:0] data_byte;
    wire rx_done;
    assign resultado = data_byte;
    assign o_rx_done = rx_done;

// Instantiate br_generator module
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
        .o_data_byte(data_byte)
    );
    
    parameter [7:0] data_to_tx = 8'b11111111;

    uart_tx #(
        .DATA_WIDTH(8),
        .SB_TICKS(16)
    ) uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .i_tx_signal(tx_signal),
        .i_ticks(tick),
        .i_data_byte(data_to_tx),
        .o_tx_done(o_tx_done),
        .o_tx(o_tx)
    );

endmodule
