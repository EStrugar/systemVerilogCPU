// VGA controller


module VgaController
(
	input	logic 			Clock,
	input	logic			Reset,
	output	logic			blank_n,
	output	logic			sync_n,
	output	logic			hSync_n,
	output	logic 			vSync_n,
	output	logic	[11:0]	nextX,
	output	logic	[11:0]	nextY
);

	logic [11:0] hCount;
	logic [11:0] vCount;
	
// add your code below this comment

//hCount is the counter for the horizontal axis
//vCount is the counter for the vertical axis
//nextX takes the value of hCount to create the visible area for the horizontal axis
//nextY takes the value of vCount to create the visible area for the vertical axis
//blank_n is high to map the visible area, and low for blanking time
//hSync_n is low to map the sync pulse region for the horizontal axis
//vSync_n is low to map the sync pulse region for the vertical axis
//Sync_n synchronizes the hSync_n and vSync_n regions


always_ff @ (posedge Clock) //triggered by the positive edge of the clock

//if reset is high the count returns to 0 for x and y
	if(Reset) //no value required as 'Reset' is either high or low
		begin
			hCount='0; 
			vCount='0;
		end
	else
		begin
		if (hCount > 1039) //once the count surpasses the total width (1040), it loops back to the start
			begin	
				hCount = '0;
			if (vCount > 665) //once the count surpasses the total height(666), it loops back to the start
				vCount = '0;
			else
				vCount++; //increments vCount
			end
		else
			hCount++; //increments hCount
	
//it is nested to ensure vCount will only restart if hCount has finished a line

//assign is synthesized as combinatorial logic. '?' is a ternary operator for the conditional expressions
//syntax for conditional expression using assign: 'assign output = condition ? if true : if false'
//always_comb could also be used but this is much more succinct, reducing lines used and removing unnecessary if statements.

assign nextX = (hCount<800) ? hCount:0;

assign nextY = (vCount<600) ? vCount:0;

assign blank_n = (hCount >= 800 || vCount >= 600) ? 0:1; //set blank_n for non-visible area (>= frontporch)

assign hSync_n = ((hCount >= 856) && (hCount < 976)) ? 0:1;//sync pulse region set for horizontal timing

assign vSync_n = ((vCount>=637) && (vCount<643)) ? 0:1;//sync pulse region set for vertical timing

assign sync_n = hSync_n || vSync_n ? 0:1; //set sync_n for synch-pulse region

endmodule
