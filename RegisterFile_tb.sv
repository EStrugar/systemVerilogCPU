//Author: Edgar Strugar - ees42
//Filename: RegisterFile_tb
//Description: register file testbench 

//delays use 1ns steps, and the shortest delay is 1ps
`timescale 1ns / 1ps

module registerfile_tb();

logic Clock = 0; //clock starts at 0

default clocking @ (posedge Clock); //completes instruction on the positive edge of the clock
endclocking;

always #10 Clock++; //Clock alternates every 10ns 

//module has 5 inputs (Clock,AddressA,AddressB,WriteData,WriteEnable) and 1 output
//Set up the inputs
	reg Clock;
	reg [5:0] AddressA, AddressB;
	reg [15:0] WriteData;
	reg WriteEnable;

//Set up the outputs
	wire [15:0] ReadDataA, ReadDataB;

registerfile uut(.*); //Instantiate and connect the variables of the  
							 //registerfile module with the testbench inputs and outputs

initial 
		begin
	
	//initilaise values for all variables (WriteEnable,WriteData,AddressA,AddressB)
			WriteEnable=0;
			AddressA=6'd0;
			WriteData=16'd0;
			AddressB=6'd0;
			
	//Test #1
	#10 //delay by 10 ns
	
	$display("Start of Test #1");
			WriteEnable = 1; //WriteEnbale set high, meaning a value can 
								  //be written to the register indicated by AddressA
			AddressA = 6'b000001; //AddressA set to 1
			WriteData = 16'h3D3A; //15674 written to Registers[1] (Registers[A])
			ReadDataA = WriteData; //ReadDataA displays 15674
			
	#10
			
			//all values reset (WriteEnable,WriteData,AddressA,AddressB)
			WriteEnable=0;
			AddressA=6'd0;
			AddressB=6'd0;
			WriteData=16'd0;
			ReadDataA = WriteData; 
			
	//Test #2
	#10
	
	$display("Start of Test #2");	
			WriteEnable = 1; //WriteEnbale set high, meaning a value can 
								  //be written to the register indicated by AddressA	
			AddressA = 6'b000110; //AddressA set to 6
			WriteData = 16'000A; //10 written to Registers[6] (Registers[A])
			ReadDataA = WriteData; //ReadDataA displays 10
			
	#10
			
			//all values reset (WriteEnable,WriteData,AddressA,AddressB)
			WriteEnable=0;
			AddressA=6'd0;
			AddressB=6'd0;
			WriteData=16'd0;
	
			$display("End of testing");
			
		end		
endmodule
