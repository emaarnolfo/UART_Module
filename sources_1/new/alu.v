`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2023 01:33:32
// Design Name: 
// Module Name: ALU
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


module alu 
#(
    parameter BUS_REG = 8,
    parameter BUS_OP  = 6
)
(
    input  wire [BUS_REG - 1:0]  i_valA,        // Registro de entrada A de 16 bits
    input  wire [BUS_REG - 1:0]  i_valB,        // Registro de entrada B de 16 bits
    input  wire [BUS_OP  - 1:0]  i_opcode,        // Registro de control de 5 bits
    output wire [BUS_REG - 1:0]  o_result     // Salida del resultado de 16 bits
);

    reg [BUS_REG - 1:0] result; // Registro para almacenar el resultado de 16 bits  
    // Lógica de la ALU basada en el registro de control
    always @(*) begin
        case (i_opcode)
            6'b100_000: result = i_valA + i_valB;       // ADD bit a bit
            6'b100_010: result = i_valA - i_valB;       // SUB bit a bit
            6'b100_100: result = i_valA & i_valB;       // AND bit a bit
            6'b100_101: result = i_valA | i_valB;       // OR bit a bit
            6'b100_110: result = i_valA ^ i_valB;       // XOR bit a bit
            6'b000_011: result = $signed(i_valA) >>> i_valB;     // SRA de i_regA hacia la derecha en n bits
            6'b000_010: result = i_valA >> i_valB;      // Ejemplo: SRL
            6'b100_111: result = ~(i_valA | i_valB);    // NOR entre i_regA e i_regB
            // Agrega más casos según tus operaciones personalizadas
            default: result = 16'b0; // Valor predeterminado
        endcase
    end
    
    assign o_result = result; // Conecta la salida al resultado|

endmodule

