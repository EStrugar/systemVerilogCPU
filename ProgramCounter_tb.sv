//Author: Edgar Strugar - ees42
//Filename: ProgramCounter_tb
//Description: program counter testbench

//delays use 1ns steps, and the shortest delay is 1ps
`timescale 1ns / 1ps

module ProgramCounter_tb();

logic Clock = 0; //Clock starts at 0

default clocking @ (posedge Clock); //completes instruction on the positive edge of the clock
endclocking;

always #10 Clock++; //Clock alternates every 10ns 

//module has 5 inputs (Reset,LoadEnable,LoadValue,OffsetEnable,Offset)
//and 1 output (CounterValue)
//set up the inputs
	logic Reset,LoadEnable,OffsetEnable;
	logic [15:0] LoadValue;
	logic signed [8:0] Offset;
	
//set up the output
	logic [15:0] CounterValue;
	
//Instantiates the design and connect the inputs/outputs of  
 //the module with the testbench variables
ProgramCounter uut(.*);
		
initial //initial block executes only once
		begin
		
//initilaise values for all variables (Reset,LoadEnable,LoadValue,
//Offset,OffsetEnable and CounterValue)
			Reset = '0;
			LoadEnable = '0;
			LoadValue = 16'd0;
			Offset = 9'd0;
			OffsetEnable = '0;
			CounterValue = 16'd0;
			
	//Test the Reset operates correctly
			##10 //delay of 10 clock cycles
			
			Reset = 1;
			
			##10
			
			Reset = 0; 
			
	//Test the LoadValue operates correctly
			##10 // delay of 10 clock cycles
			
			LoadValue = 16'd8; //LoadValue given value of 8
			
			##5
			
			LoadEnable = 1; //LoadEnable set high
			
			##5
			//Reset counting
			LoadEnable = 0;
			LoadValue = 16'd0;
			Reset = 1;
			
			##5
			Reset = 0;
			
	//Testing the OffsetValue operates correcctly
			//Test addition first
			##10
			
			Offset = 9'b000000101; //Adding 5
			
			##5
			
			OffsetEnable = 1; //set OffsetEnable high to enable the use of the Offset		
			
			//Testing subtraction
			##10
			
			Offset = 9'b111111111; //Subtracting 1
			
			##5
			
			OffsetEnable = 1;	//set OffsetEnable high to enable the use of the Offset		
			
			##5
			OffsetEnable = 0;
		
			
		end
endmodule
	