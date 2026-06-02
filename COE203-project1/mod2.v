`timescale 1ns / 1ps

module mod3(input clk, input reset, input load, input [3:0] load_data, input CE, output reg [1:0] counter, output CEO);
	//check what button has been clicked and if enable(CE) is on or not
	always @(posedge clk or posedge reset) begin
		  //set counter to 0 if reset is clicked
		  if (reset)
            counter <= 0;
		  //load the number based on the switches that are on 
        else if(load)
		      counter <= load_data;
		  //when CE is on it will start adding to the counter until 2 then it will go back to 0
		  else if (CE) begin
            if (counter == 2)
                counter <= 0; 
            else
                counter <= counter + 1;
        end
    end

	 //CEO that turns on when the maximum value has been reached	
    assign CEO = (counter == 2) && CE;
endmodule
