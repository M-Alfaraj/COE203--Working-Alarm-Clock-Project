`timescale 1ns / 1ps

module hoursMod10(input clk, input reset, input load, input [3:0] load_data, input CE, input [3:0] hoursLimit, output reg [3:0] counter, output CEO);
	//check what button has been clicked and if enable(CE) is on or not
    always @(posedge clk or posedge reset) begin
		//set counter to 0 if reset is clicked
        if (reset)
            counter <= 0;
			//load the number based on the switches that are on 
			//This module works differently from the other mon10, it has a hoursLimit variable that check if the hour tens are 2 or not first
			//then it determines if the max value is either 9 or 3
			else if(load)
		      counter <= load_data;
			//when CE is on it will start adding to the counter until 9 or 3 depending on the hoursLimit variable then it will go back to 0
			else if (CE) begin
            if (counter == hoursLimit)
                counter <= 0;  
            else
                counter <= counter + 1;
        end
    end
	 //CEO that turns on when the maximum value has been reached	
    assign CEO = (counter == hoursLimit) && CE;

endmodule


