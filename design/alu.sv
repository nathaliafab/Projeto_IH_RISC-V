`timescale 1ns / 1ps

module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult
        );
    
	logic sign_bit;
	assign sign_bit = SrcA[31];

        always_comb
        begin
            case(Operation)
            4'b0000:        // AND
                    ALUResult = SrcA & SrcB;
	    4'b0001:        // OR
		    ALUResult = SrcA | SrcB;
            4'b0010:        // ADD
                    ALUResult = SrcA + SrcB;
	    4'b0011:        // SUB
		    ALUResult = SrcA - SrcB;
	    4'b0100:        // XOR
                    ALUResult = SrcA ^ SrcB;
            4'b0101:        // SLT
                    ALUResult = (SrcA < SrcB) ? 1 : 0;
	    4'b0110:        // LUI
		    ALUResult = SrcB;
	    4'b0111:        // SRLI
	            ALUResult = SrcA >> SrcB;
	    4'b1000:        // BEQ
                    ALUResult = (SrcA == SrcB) ? 1 : 0;
            4'b1001:        // SLLI
	            ALUResult = SrcA << SrcB;
	    4'b1010:        //SRAI
		    ALUResult = $signed(SrcA) >>> SrcB[4:0];
	    4'b0100:	    //NotEqual
		    ALUResult = (SrcA != SrcB) ? 1 : 0;
            4'b1100:	    //BLT
		    ALUResult = (SrcA < SrcB) ? 1 : 0;
	    4'b1101: 	    //JAL & JALR
		    ALUResult = 1;
            4'b1111:	    //BGE
		    ALUResult = ((SrcA > SrcB)||(SrcA == SrcB)) ? 1 : 0;
	    default:
                    ALUResult = 0;
            endcase
        end
endmodule

