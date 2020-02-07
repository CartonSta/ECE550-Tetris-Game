/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 
	 //ctrl
	 wire [31:0] op_decode;
	 wire [1:0] ctrl_ALUop;
	 wire ctrl_Rdt, ctrl_ALUinB, ctrl_bne, ctrl_blt, ctrl_jr, ctrl_j, ctrl_Rwd;
	 wire ctrl_jal, ctrl_x, ctrl_bex, ctrl_setx;
	 decoder5to32 dec_1(q_imem[31:27],op_decode[31:0]);
	 or or_1(ctrl_Rdt,op_decode[7],op_decode[2],op_decode[6],op_decode[4],op_decode[22]);
	 or or_2(ctrl_ALUinB,op_decode[5],op_decode[7],op_decode[8]);
	 assign ctrl_bne = op_decode[2];
	 assign ctrl_blt = op_decode[6];
	 assign ctrl_jr = op_decode[4];
	 or or_0(ctrl_j,op_decode[1],op_decode[3]);
	 assign ctrl_Rwd = op_decode[8];
	 or or_3(ctrl_ALUop[0],op_decode[5],op_decode[7],op_decode[8]);
	 or or_4(ctrl_ALUop[1],op_decode[2],op_decode[6],op_decode[22]);
	 assign ctrl_jal = op_decode[3];
	 or or_6(ctrl_x,op_decode[22],op_decode[21]);
	 assign ctrl_bex = op_decode[22];
	 assign ctrl_setx = op_decode[21];
	
	 //dmem
	 wire [31:0] data_writeReg_1;
	 assign wren = op_decode[7];
	 assign data[31:0] = data_readRegB[31:0];
	 assign address_dmem[11:0] = data_result[11:0];
	 mux32 mux32_2(data_result[31:0],q_dmem[31:0],ctrl_Rwd,data_writeReg_1[31:0]);
	 
	 //alu
	 wire [31:0] immediate, data_readRegB_new;
	 assign immediate[31:17] = q_imem[16] == 1 ? 15'h7FFF : 15'h0000;
	 assign immediate[16:0] = q_imem[16:0];
	 mux32 mux32_1(data_readRegB[31:0],immediate[31:0],ctrl_ALUinB,data_readRegB_new[31:0]);
	 wire [4:0] ALUop;
	 mux5_4to1 mux5_01(q_imem[6:2],5'd0000,5'd0001,5'd0000,ctrl_ALUop[1:0],ALUop[4:0]);
	 wire [31:0] data_result;
    wire isNotEqual, isLessThan, overflow;
	 alu alu_1(data_readRegA[31:0],data_readRegB_new[31:0],ALUop[4:0],q_imem[11:7],
	 data_result[31:0],isNotEqual,isLessThan,overflow);
	
 	 //imem
	 wire [31:0] pc, pc_0, pc_1, pc_2, pc_3, pc_4, pc_5;
	 wire bne, blt, isNotLessThan;
	 alu alu_2(pc_0[31:0],32'h00000001,5'b00000,5'b00000,pc_1[31:0]);
	 alu alu_3(pc_1[31:0],immediate[31:0],5'b00000,5'b00000,pc_2[31:0]);
	 and and_1(bne,ctrl_bne,isNotEqual);
	 mux32 mux32_3(pc_1[31:0],pc_2[31:0],bne,pc_3[31:0]);
	 not not_1(isNotLessThan,isLessThan);
	 and and_2(blt,ctrl_blt,isNotLessThan,isNotEqual);
	 mux32 mux32_4(pc_3[31:0],pc_2[31:0],blt,pc_4[31:0]);
	 mux32 mux32_5(pc_4[31:0],data_readRegB[31:0],ctrl_jr,pc_5[31:0]);
	 wire ctrl_JII, temp_j;
	 wire [31:0] data_sx;
	 assign data_sx[26:0] = q_imem[26:0];
	 assign data_sx[31:27] = 5'b00000;
	 and and_3(temp_j,isNotEqual,ctrl_bex);
	 or or_(ctrl_JII,temp_j,ctrl_j);
	 mux32 mux32_6(pc_5[31:0],data_sx[31:0],ctrl_JII,pc[31:0]);
	 pc_counter pc_counter1(clock,reset,pc[31:0],pc_0[31:0]);
	 assign address_imem[11:0] = pc_0[11:0];
	
	 //regfile
	 wire [31:0] data_writeReg_2;
	 mux32 mux32_7(data_writeReg_1[31:0],data_sx[31:0],ctrl_setx,data_writeReg_2[31:0]);
	 mux32 mux32_8(data_writeReg_2[31:0],pc_1[31:0],ctrl_jal,data_writeReg[31:0]);
	 or or_5(ctrl_writeEnable,op_decode[0],op_decode[5],op_decode[8],
	 op_decode[3],op_decode[21]);
	 mux5 mux5_2(q_imem[21:17],5'b00000,ctrl_bex,ctrl_readRegA[4:0]);
	 wire [4:0] ctrl_tempReg;
	 mux5 mux5_3(q_imem[26:22],5'b11110,ctrl_x,ctrl_tempReg[4:0]);
	 mux5 mux5_1(q_imem[16:12],ctrl_tempReg[4:0],ctrl_Rdt,ctrl_readRegB[4:0]);
	 mux5 mux5_4(ctrl_tempReg[4:0],5'b11111,ctrl_jal,ctrl_writeReg[4:0]);

endmodule
