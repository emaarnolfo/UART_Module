`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2023 20:05:16
// Design Name: 
// Module Name: interface
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


module interface(
    input clk,
    input reset,
    input [7:0] i_tx_data,
    input [7:0] i_alu_result,
    output [7:0] o_datoA,
    output [7:0] o_datoB,
    output [7:0] o_opcode,
    output [7:0] o_result
    );
endmodule
