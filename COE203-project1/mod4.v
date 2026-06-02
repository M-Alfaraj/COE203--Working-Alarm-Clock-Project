`timescale 1ns / 1ps

module mod4(input clk, input reset, input CE, output reg [3:0] counter, output CEO);
    always @(posedge clk or posedge reset) 
	 begin
        if (reset)
            counter <= 0;
        else if (CE) begin
            if (counter == 3)
                counter <= 0;  // self-reset at 3
            else
                counter <= counter + 1;
        end
    end

    assign CEO = (counter == 3) && CE;

endmodule
