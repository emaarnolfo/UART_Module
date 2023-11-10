`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2023 20:08:12
// Design Name: 
// Module Name: tb_uart_rx
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

module tb_uart_rx;

    parameter freq = 100_000_000;
    parameter baud_rate = 19200;
    parameter N = 10;
    
    // Definición de los parámetros del módulo UART
    parameter DATA_WIDTH = 8;
    parameter STOP_WIDTH = 1;
    
    // Definición de las señales necesarias para la simulación
    reg clk;
    reg reset;
    reg i_rx;

    wire [DATA_WIDTH-1:0] rx_data;
    wire rx_done;
    wire tick;

    localparam demora = 52160;
    localparam byte_to_rx = 8'b11010110;
    
    integer data_index = 0;
    integer stop_index = 0;
    
    
    br_generator #(freq, baud_rate, N) uut (
        .clk(clk), 
        .reset(reset), 
        .tick(tick)
    );
    
    uart_rx uart_inst (
        .clk(clk),
        .reset(reset),
        .i_ticks(tick),
        .i_rx(i_rx),
        .o_rx_done(o_rx_done),
        .o_data_byte(o_data_byte)
    );
    
   

    initial begin

        clk = 0;
        reset = 1'b1;
        i_rx = 1'b1;

        #20
        reset = 1'b0;
        
        #demora
        i_rx = 1'b0;

        #demora        
       ////DATA
        for(data_index = 0; data_index < DATA_WIDTH; data_index = data_index +1)
        begin
            i_rx = byte_to_rx[data_index];
            $display("data %d", byte_to_rx[data_index]);
            $display("i_rx: %d", i_rx);
            #demora;
        end
        
        ////STOP
        for(stop_index = 0; stop_index < STOP_WIDTH; stop_index = stop_index +1)
        begin
            i_rx = 1'b1; ////STOP
            $display("stop ");
            $display("i_rx: %d", i_rx);
            #demora;
        end
        #demora
        
        // Verificar que los datos recibidos por el módulo receptor sean los esperados
        if (o_data_byte !== byte_to_rx) begin
            $display("Error: los datos recibidos no son los esperados");
        end else begin
            $display("Datos recibidos correctamente");
        end
        
        // Finalizar la simulación
        $finish;
    end
    
endmodule
