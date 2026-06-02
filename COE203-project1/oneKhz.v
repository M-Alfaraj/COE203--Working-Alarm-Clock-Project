`timescale 1ns / 1ps
module oneKhz(input clk, reset, CE, output reg [26:0] counter, output CEO);
	always @(posedge clk)
		if (reset || CEO)
			counter <= 0;
		else if (CE)
			counter <= counter + 1;
	
	// if both condition are true, CEO will turn on.	
	assign CEO = (counter == 99999) && CE;
endmodule
