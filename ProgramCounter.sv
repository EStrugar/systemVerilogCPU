//Author: Edgar Strugar-ees42
//Filename: ProgramCounter
//Description: code for 16 bit program counter, allowing for a 9 bit offset and loading 16 bit values 

module ProgramCounter(

	 input logic Clock, 
    input logic Reset, 
	 input logic LoadEnable, 
	 input logic [15:0] LoadValue, 
	 input logic OffsetEnable, 
	 input logic signed [8:0] Offset, 
	 output logic signed [15:0] CounterValue
);
	
//LoadEnable determines if the LoadValue needs to be stored into CounterValue
//LoadValue is the 16 bit value that is loaded into CounterValue when LoadEnable is high
//OffsetEnable determines if the Offset needs to be stored into CounterValue
//Offset is the signed 9 bit value that is added to CounterValue when OffsetEnable is high
//CounterValue is the signed 16 bit output, and is the value of the Program Counter 

//the offset being signed means that only one if statement is used for OffsetEnable, rather than two for an unsigned offset

	logic x = 0; //during the first clock cycle this internal value will asign output to zero

always_ff @ (posedge Clock) //completes instruction on the positive edge of the clock

    begin
		  if (Reset || x==0) //checks if either Reset is active high, or it is the first clock cycle
		  
				 CounterValue <= 16'd0;	//resets CounterValue to 0 
					 
		  else if (LoadEnable) //checks if LoadEnable is active high
		  
				 CounterValue <= LoadValue; //CounterValue is set to LoadValue (if LoadEnable is active)
					 
        else if (OffsetEnable) //checks if OffsetEnable is active high
		  
				 CounterValue  <= CounterValue + Offset; //The offset is added to CounterValue (if OffsetEnable is active)
					 
		  else
             CounterValue++; //if none of the conditions are met, CounterValue is incremented
					 
x = 1; //internal value set as 1 to show clock cycle					 
					 
    end
endmodule
