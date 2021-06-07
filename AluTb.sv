//Author: Edgar Strugar - ees42
//Filename: AluTb
//Description: ArithmeticLogicUnit testbench

//delays use 1ns steps, and the shortest delay is 1ps
`timescale 1ns / 1ps

import InstructionSetPkg::*;

// This module implements a set of tests that 
// partially verify the ALU operation.
module AluTb();

	eOperation Operation;
	
//group the flags	
	sFlags    InFlags;
	sFlags    OutFlags;
	
//set up the inputs	
	logic signed [ImmediateWidth-1:0] InImm = '0;
	logic	signed [DataWidth-1:0] InSrc  = '0;
	logic signed [DataWidth-1:0] InDest = '0;

//set up the outputs	
	logic signed [DataWidth-1:0] OutDest;

//Instantiate and connect the variables of the   
//ArithmeticLogicUnit module with the testbench inputs and outputs
	ArithmeticLogicUnit uut (.*);

//To test the ALU, a selection of extreme cases (max and min values) and
//potentially problematic scenarios (negatives,etc) were aplied to the operations


	initial //executes once
	
	begin
		#10; //short wait to observe primary inputs
		InFlags = sFlags'(0); //all flags set to 0
		
	//testing MOVE
		$display("Start of MOVE tests");
		Operation = MOVE; //test operation called
		
		InSrc  = 16'h0000; //0 (all 0s)
		#1 if (OutDest != 16'h0000) $display("Error in MOVE operation at time %t",$time); //=0 (all 0s)

		#10 InSrc = 16'hFFFF; //-1 (all 1s) 
	   #1 if (OutDest != 16'hFFFF) $display("Error in MOVE operation at time %t",$time); //=-1 (all 1s)
		
		#10 InSrc = 16'h7AD9; //31449		
	   #1 if (OutDest != 16'h7AD9) $display("Error in MOVE operation at time %t",$time); //=31449
		
		#50;
		
	//testing NAND operation
		$display("Start of NAND tests");
		Operation = NAND; //test operation called
		
		InDest = 16'h0000;  //Reset InDest
		InSrc  = 16'ha5a5;  //-23131 
	   #1 if (OutDest != 16'hFFFF) $display("Error in NAND operation at time %t",$time); //=-1 (all 1s)
		
		#10 InDest = 16'h9999; //2457
	   #1 if (OutDest != 16'h7E7E) $display("Error in NAND operation at time %t",$time); //=32382
		
		#10 InDest = 16'hFFFF; //-1 (all 1s)
	   #1 if (OutDest != 16'h5a5a) $display("Error in NAND operation at time %t",$time); //=23130
		
		#10 InDest = 16'h1234; //4660
	   #1 if (OutDest != 16'hFFDB) $display("Error in NAND operation at time %t",$time); //=-37
		
		#10 InDest = 16'ha5a5; //-23131 
		InSrc = 16'h0000; //0 (all 0s)    
	   #1 if (OutDest != 16'hFFFF) $display("Error in NAND operation at time %t",$time); //=-1 (all 1s)
		
		#10 InSrc = 16'h9999; //2457
	   #1 if (OutDest != 16'h7E7E) $display("Error in NAND operation at time %t",$time); //=32382
		
		#10 InSrc = 16'hFFFF; //-1 (all 1s)
	   #1 if (OutDest != 16'h5a5a) $display("Error in NAND operation at time %t",$time); //=23130
		
		#10 InSrc = 16'h1234; //4660 
	   #1 if (OutDest != 16'hFFDB) $display("Error in NAND operation at time %t",$time); //=-37
		
		#50;

	//testing NOR operation
		$display("Start of NOR tests");
		Operation = NOR; //test operation called
		
		InDest = 16'h0000; //Reset InDest
		InSrc  = 16'ha5a5; //-23131    
	   #1 if (OutDest != 16'h5a5a) $display("Error in NOR operation at time %t",$time); //=23130
		
		#10 InDest = 16'h9999; //2457
	   #1 if (OutDest != 16'h4242) $display("Error in NOR operation at time %t",$time); //=16962
		
		#10 InDest = 16'hFFFF; //-1 (all 1s)
	   #1 if (OutDest != 16'h0000) $display("Error in NOR operation at time %t",$time); //=0 (all 0s)
		
		#50;
		
	//testing ROL operation
		$display("Start of ROL tests");
		Operation = ROL; //test operation called
		
		InDest = 16'h0000; //Reset InDest
		InFlags.Carry = 1; //carry flag high
		InSrc  = 16'h0000; //0 (all 0s)
		#1 if (OutDest != 16'h0001) $display("Error in ROL operation at time %t",$time); //=1 (all 1s)
		
		#10 InSrc = 16'hFFFF; //-1  (all 1s) 
	   #1 if (OutDest != 16'hFFFF) $display("Error in ROL operation at time %t",$time); //=-1 (all 1s)
		
		#10 InSrc = 16'h5555; //21845 (alternating 1s and 0s)	
	   #1 if (OutDest != 16'hAAAB) $display("Error in ROL operation at time %t",$time); //=-21845
		
		#50;
		
	//testing ROR operation
		$display("Start of ROR tests");
		Operation = ROR; //test operation called
		
		InDest = 16'h0000; //Reset InDest
		InSrc  = 16'h0000; //0 (all 0s)
		InFlags.Carry = 1; //set carry flag high
		#1 if (OutDest != 16'h8000) $display("Error in ROR operation at time %t",$time); //=-32768 (1 followed by 0s)
		
		#10 InSrc = 16'hFFFF; //-1 (all 1s)   
	   #1 if (OutDest != 16'hFFFF) $display("Error in ROR operation at time %t",$time); //=-1 (all 1s)
		
		#10 InSrc = 16'h5555; //21845 (alternating 1s and 0s)
	   #1 if (OutDest != 16'hAAAA) $display("Error in ROR operation at time %t",$time); //=-21845
			
		#50;
		
		InFlags.Carry = '0;	//revert carry flag to low for ADC testing
	
	//testing LIL operation
		$display("Start of LIL tests");
		Operation = LIL; //test operation called
		
		InDest = 16'h0000; //Reset InDest
		InImm = 16'h0000; //0 (all 0s)
		
	//since the ImmediateWidth is 6, it is the 6th bit that is extended for OutDest
		
		#1 if (OutDest != 16'h0000) $display("Error in LIL operation at time %t",$time); //=0 (all 0s)
		
		#10 InImm = 16'h0026; //38
	   #1 if (OutDest != 16'hFFE6) $display("Error in LIL operation at time %t",$time); //=-26
		
		#10 InImm = 16'h001F; //31 		
	   #1 if (OutDest != 16'h001F) $display("Error in LIL operation at time %t",$time); //=31
		
		#50;
		
	//testing LIU operation
		$display("Start of LIU tests");
		Operation = LIU; //test operation called
		
		InDest = 16'h0000; //Reset InDest
		InImm = 6'h3F; //63 (all 1s for 6-bit number)         
	   #1 if (OutDest != 16'hF800) $display("Error in LIU operation at time %t",$time); //=-2048
		
		#10 InImm = 6'h0F; //15      
	   #1 if (OutDest != 16'h03C0) $display("Error in LIU operation at time %t",$time); //=960
		
		#10 InDest = 16'hAAAA; //-21845		
	   #1 if (OutDest != 16'h03EA) $display("Error in LIU operation at time %t",$time); //=1002
		
		#10 InImm = 6'h3F; //63 (all 1s for 6-bit number)        
	   #1 if (OutDest != 16'hFAAA) $display("Error in LIU operation at time %t",$time); //-1366
		
		#50;

	//testing ADC operation
		$display("Start of ADC tests");
		Operation = ADC; //test operation called
	
		InDest = 16'h0000; //Reset InDest
		InSrc = 16'ha5a5; //-23131
	   #1 
		if (OutDest != 16'ha5a5) $display("Error in ADC operation at time %t",$time); //=-23131
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InFlags.Carry = '1; //carry flag set high
	   #1 
		if (OutDest != 16'ha5a6) $display("Error in ADC operation at time %t",$time); //=-23130
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in ADC operation at time %t",$time);

		#10 InDest = 16'h5a5a; //23130
	   #1 
		if (OutDest != 16'h0000) $display("Error in ADC operation at time %t",$time); //0 (all 0s)
	   if (OutFlags != sFlags'(11)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InDest = 16'h8000; //=-32768 (1 followed by 0s)
		InFlags.Carry = '0; //carry flag reset
		InSrc = 16'hffff; //-1 (all 1s)
	   #1 
		if (OutDest != 16'h7fff) $display("Error in ADC operation at time %t",$time); //=32767
	   if (OutFlags != sFlags'(17)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InDest = 16'h7fff; //32767
		InSrc = 16'h0001; //1
	   #1 
		if (OutDest != 16'h8000) $display("Error in ADC operation at time %t",$time); //=-32768
	   if (OutFlags != sFlags'(20)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#50;
		
	//testing SUB operation
		$display("Start of SUB tests");
		Operation = SUB; //test operation called
		
		InDest = 16'h0000; //Reset InDest
		InSrc  = 16'h0000; //0 (all 0s)
		InFlags.Carry = '0; //set carry flag low
		#1 if (OutDest != 16'h0000) $display("Error in SUB operation at time %t",$time); //=0 (all 0s)
		
		#10 InSrc = 16'h00A4; //164
		InFlags.Carry = '1; //carry flag set high
	   #1 if (OutDest != 16'hFF5B) $display("Error in SUB operation at time %t",$time); //=-165
		
		#10 InSrc = 16'h00A4; //164
		InFlags.Carry = '0; //carry flag set low
	   #1 if (OutDest != 16'hFF5C) $display("Error in SUB operation at time %t",$time); //=-164
		
		#10 InDest = 16'hFFFF; //=-1
		#10 InSrc = 16'hFF5B; //-165	
	   #1 if (OutDest != 16'h00A4) $display("Error in SUB operation at time %t",$time); //=164
		
		#50;

	//The same values were used for the DIV and MOD tests since they will have agreeing results.
	//testing DIV operation
		$display("Start of DIV tests");
		Operation = DIV; //test operation called	
		
		#10 InDest = 16'h0190; //400
		InSrc  = 16'h0014; //20
		#1 if (OutDest != 16'h0014) $display("Error in DIV operation at time %t",$time);//=20
		
		#10 InSrc = 16'h0003; //3
	   #1 if (OutDest != 16'h0085) $display("Error in DIV operation at time %t",$time);//=133
		
		#10 InSrc = 16'hFF83; //-114
	   #1 if (OutDest != 16'hFFFD) $display("Error in DIV operation at time %t",$time);//=-3
		
		#10 InDest = 16'hFF83; //-114
		 InSrc = 16'hFF83;  //-114		
	   #1 if (OutDest != 16'h0001) $display("Error in DIV operation at time %t",$time);//=1
		
		#50;
		
	//testing MOD operation
		$display("Start of MOD tests");
		Operation = MOD; //test operation called
		
		#10 InDest = 16'h0190; //400
		InSrc  = 16'h0014; //20
		#1 if (OutDest != 16'h000) $display("Error in MOD operation at time %t",$time);//=0 (all 0s)
		
		#10 InSrc = 16'h0003; //3
	   #1 if (OutDest != 16'h0001) $display("Error in MOD operation at time %t",$time);//=1
		
		#10 InSrc = 16'hFF8E; //-114	
	   #1 if (OutDest != 16'h003A) $display("Error in MOD operation at time %t",$time);//=58
		
		#10 InDest = 16'hFF8E; //-114
		 InSrc = 16'hFF8E; //114
	   #1 if (OutDest != 16'h0000) $display("Error in MOD operation at time %t",$time);//=0 (all 0s)
		
		#50;
	
	//The same values were used for the MUL and MUH tests since they will have agreeing results.
	//MUL is the lower half of 
	//testing MUL operation
		$display("Start of MUL tests");
		Operation = MUL; //test operation called
		
		InDest = 16'h040F; //1039
		InSrc  = 16'h040F; //1039
		#1 if (OutDest != 16'h78E1) $display("Error in MUL operation at time %t",$time); //=(lower half of 1079521)
		
		#10 InSrc = 16'hFFFF; //-1 (all 1s)      
	   #1 if (OutDest != 16'hFBF1) $display("Error in MUL operation at time %t",$time);//=-1039
		
		#10 InDest = 16'hF412; //-3054
		InSrc = 16'hF412; //-3054 		
	   #1 if (OutDest != 16'h5144) $display("Error in MUL operation at time %t",$time); //(lower half of 9326916)
		
		#10 InSrc = 16'h0000;  //0 (all 0s)
	   #1 if (OutDest != 16'h0000) $display("Error in MUL operation at time %t",$time);//=0 (all 0s)
		
		#50;
		
	//testing MUH operation
		$display("Start of MUH tests");
		Operation = MUH; //test operation called
		
		InDest = 16'h040F; //1039
		InSrc  = 16'h040F; //1039
		#1 if (OutDest != 16'h0010) $display("Error in MUH operation at time %t",$time);//(upper half of 1079521)
		
		#10 InSrc = 16'hFFFF; //-1 (all 1s)      
	   #1 if (OutDest != 16'hFFFF) $display("Error in MUH operation at time %t",$time);//=-1 (all 1s)
																														
		#10 InDest = 16'hF412;//-3054
		InSrc = 16'hF412;  	//-3054
	   #1 if (OutDest != 16'h008E) $display("Error in MUH operation at time %t",$time);//(upper half of 9326916)
		
		#10 InSrc = 16'h0000; //0 (all 0s)	
	   #1 if (OutDest != 16'h0000) $display("Error in MUH operation at time %t",$time);//=0 (all 0s)
		
		#50;
		
		
		$display("End of tests");
		
	end
endmodule
