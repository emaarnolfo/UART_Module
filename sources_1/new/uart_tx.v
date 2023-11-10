`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2023 20:05:16
// Design Name: 
// Module Name: uart_tx
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


module uart_tx #(
    parameter   DATA_WIDTH = 8,
                SB_TICKS   = 16
)
(
    input wire                   clk,
    input wire                   reset,
    input wire                   i_tx_signal,    // begin data transmission
    input wire                   i_ticks,        // from baud rate generator
    input wire [DATA_WIDTH-1:0]  i_data_byte,    // data word from interface
    output reg                   o_tx_done,      //end of transmission
    output wire                  o_tx
    );

    // State machine States
    localparam [3:0]    IDLE_STATE  = 4'b0001;
    localparam [3:0]    START_STATE = 4'b0010;
    localparam [3:0]    DATA_STATE  = 4'b0100;
    localparam [3:0]    STOP_STATE  = 4'b1000;

    // Registers
    reg [3:0]               state;
    reg [3:0]               next_state;

    reg [3:0]               tick_reg;
    reg [3:0]               tick_next;
    
    reg [2:0]               nbits_reg;
    reg [2:0]               nbits_next;
    
    reg [DATA_WIDTH-1:0]    data_reg;
    reg [DATA_WIDTH-1:0]    data_next;

    reg                     tx_reg;
    reg                     tx_next;


    // Register logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE_STATE;
            tick_reg <= 0;
            nbits_reg <= 0;
            data_reg <= 0;
            tx_reg <= 1'b1;
        end
        else begin
            state <= next_state;
            tick_reg <= tick_next;
            nbits_reg <= nbits_next;
            data_reg <= data_next;
            tx_reg <= tx_next;
        end   
    end

    // State machine logic
    always @(*) begin
        next_state = state;
        o_tx_done = 1'b0;
        tick_next = tick_reg;
        nbits_reg = nbits_next;
        data_next = data_reg;
        tx_next = tx_reg;

        case (state)
            IDLE_STATE: begin
                tx_next = 1'b1;
                if(i_tx_signal) begin
                    next_state = START_STATE;
                    tick_next = 0;
                    //o_tx_done = 1'b0;
                    data_next = i_data_byte;
                end             
            end

            START_STATE: begin
                tx_next = 1'b0;
                if(i_ticks)begin
                    if (tick_reg == 15) begin
                        next_state = DATA_STATE;
                        tick_next = 0;
                        nbits_next = 0;
                    end
                    else
                        tick_next = tick_reg + 1;
                end
            end

            DATA_STATE: begin
                tx_next = data_reg[0];
                if (i_ticks) begin
                    if (tick_reg == 15) begin
                        tick_next = 0;
                        data_next = data_reg >> 1;
                        if(nbits_reg == (DATA_WIDTH-1))
                            next_state = STOP_STATE;
                        else
                            nbits_next = nbits_reg + 1;
                    end
                    else
                        tick_next = tick_reg + 1;  
                end
            end

            STOP_STATE: begin
                tx_next = 1'b1;
                if(i_ticks) begin
                    if(tick_reg == (SB_TICKS-1)) begin
                        next_state = IDLE_STATE;
                        o_tx_done = 1'b1;
                    end
                    else 
                        tick_next = tick_reg + 1;
                end
            end
        endcase
    end

    // Output Logic
    assign o_tx = tx_reg;

endmodule
