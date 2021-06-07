//Author: Edgar Strugar - ees42
//Filename: RegisterFile
//Description: coding for register file

module RegisterFile
(
	input Clock,
	
	//write port A
	input WriteEnable, 
	input	[5:0] AddressA, 
	input	[15:0] WriteData, 
	
	//read port A
	output [15:0] ReadDataA,

	//read port B
	input	[5:0] AddressB, 
	output [15:0] ReadDataB 
);

//WriteEnable determines if WriteData needs to be used
//WriteData is a 16 bit value that is stored in the register indicated by AddressA when WriteEnable is active
//AddressA is a 6 bit register that is written or read for port A
//ReadDataA is an asynchronous 16 bit output that displays the value of the register pointed to by AddressA
//AddressB is a 6 bit register that is written or read for port B
//ReadDataB is an asynchronous 16 bit output that displays the value of the register pointed to by AddressB

logic [15:0] Registers [64]; //Register file has 64 registers, each 16 bits long

always_ff @ (posedge Clock) //completes instruction on the positive edge of the clock
	begin
		if (WriteEnable) //checks if WriteEnable is active high
			begin
				Registers[AddressA]<=WriteData; //Registers indicated by AddressA write the value from WriteData
			end
	end
	
//assign indicates combinatorial logic, and is used here for asynchronous operations
assign ReadDataA=Registers[AddressA]; //displays the register value indicated by AddressA
assign ReadDataB=Registers[AddressB]; //displays the register value indicated by AddressB

endmodule
