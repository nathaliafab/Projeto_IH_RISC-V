`timescale 1ns / 1ps

module ForwardingUnit (
    input logic [4:0] RS1,
    input logic [4:0] RS2,
    input logic [4:0] EX_MEM_rd,
    input logic [4:0] MEM_WB_rd,
    input logic EX_MEM_RegWrite,
    input logic MEM_WB_RegWrite,
    output logic [1:0] Forward_A,
    output logic [1:0] Forward_B
);

  assign Forward_A = ((EX_MEM_RegWrite) && (EX_MEM_rd != 0) && (EX_MEM_rd == RS1)) ? 2'b10 :
                       ((MEM_WB_RegWrite) && (MEM_WB_rd != 0) && (MEM_WB_rd == RS1)) ? 2'b01 : 2'b00;

  assign Forward_B = ((EX_MEM_RegWrite) && (EX_MEM_rd != 0) && (EX_MEM_rd == RS2)) ? 2'b10 :
                       ((MEM_WB_RegWrite) && (MEM_WB_rd != 0) && (MEM_WB_rd == RS2)) ? 2'b01 : 2'b00;

endmodule
