`timescale 1ns / 1ps

module onehz(input clk, reset, CE, output reg [26:0] counter, output CEO);
	always @(posedge clk)
		//if reset or ceo is 1, then reset tge ciybter
		if (reset || CEO)
			counter <= 0;
		//if CE is on then increment by 1 else don't increment
		else if (CE)
			counter <= counter + 1;

	// if both condition are true, CEO will turn on.
	assign CEO = (counter == 99999999) && CE;
endmodule
