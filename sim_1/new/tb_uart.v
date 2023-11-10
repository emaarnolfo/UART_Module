`timescale 1ns / 1ps


module tb_uart;

    // Parámetros
    parameter DATA_WIDTH = 8;
    parameter SB_TICKS = 16;
    parameter freq = 100_000_000;
    parameter baud_rate = 19200;
    parameter N = 10;

    // Señales de entrada y salida para el testbench
    reg clk;
    reg reset;
    reg i_rx;
    reg [DATA_WIDTH-1:0] test_data;

    // Señales de salida del UART_RX para el testbench
    wire o_rx_done;
    wire [DATA_WIDTH-1:0] o_data_byte_rx;

    // Señales de entrada del UART_TX para el testbench
    reg i_tx_signal_tx;
    reg [DATA_WIDTH-1:0] i_data_byte_tx;
    wire o_tx_done;
    wire tx;
    
    wire tick;
    
     br_generator #(freq, baud_rate, N) uut (
        .clk(clk), 
        .reset(reset), 
        .tick(tick)
    );
    
    // Instancia del módulo UART_RX
    uart_rx #(
        .DATA_WIDTH(DATA_WIDTH),
        .SB_TICKS(SB_TICKS)
    ) uart_rx_inst (
        .clk(clk),
        .reset(reset),
        .i_ticks(tick),
        .i_rx(i_rx),
        .o_rx_done(o_rx_done),
        .o_data_byte(o_data_byte_rx)
    );

    // Instancia del módulo UART_TX
    uart_tx #(
        .DATA_WIDTH(DATA_WIDTH),
        .SB_TICKS(SB_TICKS)
    ) uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .i_tx_signal(o_rx_done),
        .i_ticks(tick),
        .i_data_byte(o_data_byte_rx),
        .o_tx_done(o_tx_done),
        .tx(tx)
    );

    // Generación de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100[MHz]
    end

    // Secuencia de prueba
    initial begin
        // Inicializar
        reset = 1;
        i_rx = 0;
        test_data = 8'b11011010;

        // Desactivar reset después de un tiempo
        #50 reset = 0;

        // Enviar el dato simulado a través de i_rx
        #100 i_rx = 1;

        // Esperar a que la transmisión se complete
        #500;

        // Mostrar resultados
        $display("Rx Done: %b", o_rx_done);
        $display("Received Data: %b", o_data_byte_rx);

        // Asignar la salida de UART_RX como entrada a UART_TX
//        i_tx_signal_tx = o_rx_done;
//        i_data_byte_tx = o_data_byte_rx;

        // Esperar a que la transmisión de UART_TX se complete
        #500;

        // Mostrar resultados
        $display("Tx Done: %b", o_tx_done);
    end

endmodule


