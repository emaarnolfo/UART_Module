`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2023 20:05:16
// Design Name: 
// Module Name: uart_rx
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


module uart_rx #(
    parameter   DATA_WIDTH = 8,
                SB_TICKS   = 16
)
(
    input                   clk,
    input                   reset,
    input                   i_ticks,
    input                   i_rx,
    output                  o_rx_done,
    output [DATA_WIDTH-1:0] o_data_byte
);

    // State machine States
    localparam [3:0]    IDLE_STATE  = 4'b0001,
                        START_STATE = 4'b0010,
                        DATA_STATE  = 4'b0010,
                        STOP_STATE  = 4'b1000;

    // Registers
    reg [3:0]               state, next_state;
    reg [3:0]               tick_reg, tick_next;
    reg [2:0]               nbits_reg, nbits_next;
    reg [DATA_WIDTH-1:0]    data_reg, data_next;
    reg                     rx_done;

    // Register logic
    always @(posedge clk ) begin
        if (reset) begin
            state <= IDLE_STATE;
            tick_reg <= 0;
            nbits_reg <= 0;
            data_reg <= 0;            
        end
        else begin
            state <= next_state;
            tick_reg <= tick_next;
            nbits_reg <= nbits_next;
            data_reg <= data_next;
        end  
    end

    always @(*) begin
        case (state)
            IDLE_STATE: begin
                if(~i_rx) begin
                    next_state = START_STATE;
                    tick_next = 0;
                end
            end
            
            START_STATE: begin
                if (i_ticks) begin
                    if(tick_reg == 7) begin
                        next_state = START_STATE;
                        tick_next = 0;
                        nbits_next = 0;
                    end
                    else
                        tick_next = tick_reg + 1;
                end
            end

            DATA_STATE: begin
                if (i_ticks) begin
                    if (tick_reg == 15) begin
                        tick_next = 0;
                        data_next = {i_rx, data_reg[DATA_WIDTH-1:1]};
                        if (nbits_reg == (DATA_WIDTH-1))
                            next_state = STOP_STATE;
                        else 
                            nbits_next = nbits_reg + 1;
                    end
                    else
                        tick_next = tick_reg + 1;
                    
                end
            end
            
            STOP_STATE: begin
                if (i_ticks) begin
                    if (tick_reg == (SB_TICKS-1)) begin
                        next_state = IDLE_STATE;
                        rx_done = 1'b1;                        
                    end 
                    else
                        tick_next = tick_reg + 1;                        
                end
            end
        endcase 
    end

    assign o_data_byte = data_reg;
    assign o_rx_done = rx_done;

endmodule
