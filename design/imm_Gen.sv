`timescale 1ns / 1ps

module imm_Gen (
    input  logic [31:0] inst_code,
    output logic [31:0] Imm_out
);


  always_comb
    case (inst_code[6:0])

      7'b0010011: /*ADDI*/
       if(inst_code[30] && inst_code[14]) // É SRAI
	Imm_out = {inst_code[24] ? 27'hFFFFF: 27'b0, inst_code[24:20]};
       else
        Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:20]};
	
      7'b0110111: /*LUI*/
      Imm_out = {inst_code[31:12], 12'b0};

      7'b0000011:  /*I-type load part*/
	Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:20]};

      7'b0100011:  /*S-type*/
      Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:25], inst_code[11:7]};

      7'b1101111:  /*JAL*/
	Imm_out = {
        inst_code[31] ? 12'h7FFFF : 12'b0,
        inst_code[20],
        inst_code[10:1],
        inst_code[11],
        inst_code[19:12]
      };

      7'b1100011:  /*B-type*/
      Imm_out = {
        inst_code[31] ? 19'h7FFFF : 19'b0,
        inst_code[31],
        inst_code[7],
        inst_code[30:25],
        inst_code[11:8],
        1'b0
      };

      default: Imm_out = {32'b0};

    endcase

endmodule
