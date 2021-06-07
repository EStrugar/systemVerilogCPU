//Author: Edgar Strugar-ees42
//Filename: ArithmeticLogicUnit
//Description: creating an ALU with all desired operations

// ArithmeticLogicUnit
// This is a basic implementation of the essential operations needed
// in the ALU. Adding futher instructions to this file will increase 
// your marks.

// Load information about the instruction set. 
import InstructionSetPkg::*;

// Define the connections into and out of the ALU.
module ArithmeticLogicUnit
(
	// The Operation variable is an example of an enumerated type and
	// is defined in InstructionSetPkg.
	input eOperation Operation,
	
	// The InFlags and OutFlags variables are examples of structures
	// which have been defined in InstructionSetPkg. They group together
	// all the single bit flags described by the Instruction set.
	input  sFlags    InFlags,
	output sFlags    OutFlags,
	
	// All the input and output busses have widths determined by the 
	// parameters defined in InstructionSetPkg.
	input  signed [ImmediateWidth-1:0] InImm,
	
	// InSrc and InDest are the values in the source and destination
	// registers at the start of the instruction.
	input  signed [DataWidth-1:0] InSrc,
	input  signed [DataWidth-1:0]	InDest,
	

	// OutDest is the result of the ALU operation that is written 
	// into the destination register at the end of the operation.
	output logic signed [DataWidth-1:0] OutDest
);

	// This block allows each OpCode to be defined. Any opcode not
	// defined outputs a zero. The names of the operation are defined 
	// in the InstructionSetPkg. 
	always_comb
	begin
	
		// By default the flags are unchanged. Individual operations
		// can override this to change any relevant flags.
		OutFlags  = InFlags;
		
		// The basic implementation of the ALU only has the NAND and
		// ROL operations as examples of how to set ALU outputs 
		// based on the operation and the register / flag inputs.
		case(Operation)		
		
			ROL:    {OutFlags.Carry,OutDest} = {InSrc,InFlags.Carry}; 

			NAND:   OutDest = ~(InSrc & InDest); 

			LIU:
				begin
					if (InImm[ImmediateWidth - 1] ==  1)
						OutDest = {InImm[ImmediateWidth - 2:0], InDest[ImmediateHighStart - 1:0]};
					else if  (InImm[ImmediateWidth - 1] ==  0)	
						OutDest = $signed({InImm[ImmediateWidth - 2:0], InDest[ImmediateMidStart - 1:0]});
					else
						OutDest = InDest;	
				end


			// ***** ONLY CHANGES BELOW THIS LINE ARE ASSESSED *****
			// Put your instruction implementations here.
			
			
		MOVE: 
			OutDest = InSrc; //This operation, named 'MOVE', copies the source register to the destination register
			
		NOR: 
			OutDest = ~(InSrc | InDest); //This operation, named 'NOR', sets the destination register 
													 //to the bitwise logical NOR of  the input registers
			
		ROR: 
			{OutDest,OutFlags.Carry} = {InFlags.Carry,InSrc}; //This operation, named 'ROR', shifts the value of the
																				 //source register by one bit to the right and stores the
																				 //value in the destination register. The most significant
																  				 //bit of the output is stored by the carry flag
																					 
		LIL: 
			OutDest = ($signed(InImm)); //This operation, named 'LIL', sets the value of the destination register
													//to a sign extended copy of the immediate value.
			
		ADC: //This operation, named 'ADC', sets the value of the destination register as the sum of the 
			  //values of the source register, destination register and the carry flag.
		begin
			{OutFlags.Carry,OutDest} = (InDest + InSrc + InFlags.Carry);	
				
			OutFlags.Parity = ~(^OutDest); //parity flag is given by the XNOR of the output value for the destination register
			OutFlags.Negative = OutDest[DataWidth-1]; //negative flag stores the value of the most significant bit, since a MSB
																   //of 1 means the value is negative as the inputs and outputs are signed
			OutFlags.Overflow = (~InDest[DataWidth-1] & ~InSrc[DataWidth-1] & OutDest[DataWidth-1]) | (InDest[DataWidth-1] & InSrc[DataWidth-1] & ~OutDest[DataWidth-1]);
																   //overflow flag set based on the MSB of the ALU inputs and outputs		
				if 
				(OutDest == '0)
				OutFlags.Zero = '1; //zero flag is set high if the operation returns a value of 0			
		end
	
		SUB: //This operation, named 'SUB', stores the subtraction of the source register and the carry flag from the
		     //destination register.  
		begin 
			{OutFlags.Carry,OutDest} = InDest - (InSrc + InFlags.Carry);
				
			OutFlags.Parity = ~(^OutDest); //see line 97
			OutFlags.Negative = OutDest[DataWidth-1]; //see lines 98-99
			OutFlags.Overflow = (~InDest[DataWidth-1] + InSrc[DataWidth-1] + OutDest[DataWidth-1]) | (InDest[DataWidth-1] + ~InSrc[DataWidth-1] + ~OutDest[DataWidth-1]);
																   //see line 101
				if 
				(OutDest == '0)
				OutFlags.Zero = '1; //see line 104
		end
					
		DIV: //This operation, named 'DIV', sets the value of the destination register as the signed integer
	        //division of the destination register by the source register
		begin
			 OutDest = InDest/InSrc;
				 
			 OutFlags.Parity = ~(^OutDest); //see line 97
			 OutFlags.Negative = OutDest[DataWidth-1]; //see lines 98-99
				if 
				(OutDest == '0)
				OutFlags.Zero = '1; //see line 104
		end
		
		MOD: //This operation, named 'MOD', sets the value of the destination register as the signed integer
	        //modulus of the destination register by the source register
	  	begin
			 OutDest = InDest%InSrc;
		 
			 OutFlags.Parity = ~(^OutDest); //see line 97
			 OutFlags.Negative = OutDest[DataWidth-1]; //see lines 98-99
				if 
				(OutDest == '0)
				OutFlags.Zero = '1; //see line 104
		end
			
		MUL: //This operation, named 'MUL', stores the lower half of the product of the destination and source
			  //registers. Since InDest and InSrc are both 16 bits, the result will be 32 bits long, so the
			  //lower half can be stored easily as it is the same length as OutDest
		begin
			 OutDest = InDest*InSrc [DataWidth-1:0];
			 
			 OutFlags.Parity = ~(^OutDest); //see line 97
			 OutFlags.Negative = OutDest[DataWidth-1]; //see lines 98-99
				if 
			   (OutDest == '0)
			  	OutFlags.Zero = '1; //see line 104
		end
			
		MUH: //This operation, named 'MUH', stores the upper half of the product of the destination and source
			  //registers. It takes the 16 most significant bits as that is the data waidth for OutDest, and since
			  //both InDest and InSrc are 16 bits, this means that MUH stores the upper-half of the multiplication
		begin
			 {OutDest,OutDest} = $signed(InDest)*$signed(InSrc);
			 
			  OutFlags.Parity = ~(^OutDest); //see line 97
		     OutFlags.Negative = OutDest[DataWidth-1]; //see lines 98-99
				if 
				(OutDest == '0)
				OutFlags.Zero = '1; //see line 104
		end	
			
			// ***** ONLY CHANGES ABOVE THIS LINE ARE ASSESSED	*****		
			
			default:	OutDest = '0;
			
		endcase;
	end

endmodule
