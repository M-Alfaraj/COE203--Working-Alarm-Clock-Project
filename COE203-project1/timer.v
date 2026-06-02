`timescale 1ns / 1ps

module AlarmClock(input clk, input reset, input load, input snooze, input [13:0] load_data, input setTimer, input CE, input S, output [7:0] seg, an, output reg AlarmLED);

//4 bit D variable to represent the numbers for the clock, 27 bit counter for the time, 4 bit hours_limit for the hours mod10
wire [3:0] D7, D6, D5, D4, D3, D2, D1, D0;
wire [26:0] counter;
wire [3:0] hours_Limit;

//wires to hold the bcd set value for the raw hours and minutes ones, and tens values
wire [3:0] userMinOnes = load_data[3:0];
wire [3:0] userMinTens = load_data[7:4];
wire [3:0] userHoursOnes = load_data[11:8]; 
wire [3:0] userHoursTens = {2'b00,load_data[13:12]};

//Condition to check if the user set values don't exceed the limit of the clock. For example minutes ones cannot exceed 9
//If the value exceeds the max value, it will apply the max value
wire [3:0] minOnes = (userMinOnes > 4'd9) ? 4'd9 : userMinOnes;
wire [3:0] minTens = (userMinTens > 4'd5) ? 4'd5 : userMinTens;
wire [3:0] hoursOnes = (hoursTens == 4'd2) ? (userHoursOnes > 4'd3 ? 4'd3 : userHoursOnes) : (userHoursOnes > 4'd9 ? 4'd9 : userHoursOnes);
wire [3:0] hoursTens = (userHoursTens > 4'd2) ? 4'd2 : userHoursTens;

//registers to hold the alarm time and setting hours tens to 9 to prevent it from being on when the circuit is programmed
reg [3:0] alarmMinOnes, alarmMinTens, alarmHoursOnes, alarmHoursTens = 9;
reg setTimerClicked = 0;
assign Y = S ? Clk1Khz : Clk1hz;
assign hours_Limit = (D5 == 2) ? 4'd3 : 4'd9;

//block to deal with buttons when pressed.
always @(posedge clk or posedge reset)
	begin
		if(reset)
			begin
				setTimerClicked <= 0;
			end
		//code for when setting an alarm at a certain time.
		else if(setTimer)
			begin
				//sets the alarm based on the switches turned on.
				alarmMinOnes <= minOnes;
				alarmMinTens <= minTens;
				alarmHoursOnes <= hoursOnes;
				alarmHoursTens <= hoursTens;
				setTimerClicked <= 1;
			end
		//code to postpond the alarm when the snooze is click while the alarm is on.
		else if(snooze && AlarmLED)
			begin
				//if the ones of the minute is less than 10 when adding 5
				if (alarmMinOnes + 5 < 10) 
					begin
						//add 5 minutes to the alarm time
						alarmMinOnes <= alarmMinOnes + 5;
					end 
				else 
					begin
						//else make sure it doesn't go over 9 and change the hours of the minute
						alarmMinOnes <= alarmMinOnes + 5 - 10;
						//check if it goes over 6
						if (alarmMinTens < 5) 
							begin
								//if not, add 1 minute to the hours
								alarmMinTens <= alarmMinTens + 1;
							end 
						else 
							begin
								//else turn the minutes to 0 and check the hours
								alarmMinTens <= 0;
								//if the hours are 23
								if (alarmHoursTens == 2 && alarmHoursOnes == 3) 
								begin
									//change both of them to 0
									alarmHoursTens <= 0;
									alarmHoursOnes <= 0;
								end 
								// check if the hours are both not 2 and if the alarm hour ones is under 9
								else if (alarmHoursOnes < 9 && !(alarmHoursTens == 2 && alarmHoursOnes == 2)) 
								begin
									//add 1 to the hours ones
									alarmHoursOnes <= alarmHoursOnes + 1;
								end 
								else 
									begin
										//if the hours ones are 9 and and the hours tens are not 2.
										alarmHoursOnes <= 0;
										alarmHoursTens <= alarmHoursTens + 1;
									end
							end
					end
			end
	end
	

//when the clock reaches the values of the alarm variables, it will turn on for a minute and will stay on until the value if the minutes/hours change
wire checkAlarm = (D5 == alarmHoursTens) && (D4 == alarmHoursOnes) && (D3 == alarmMinTens) && (D2 == alarmMinOnes); 

//block to check if the time is the same as the alarm set.
//if so, turn on the alarm until the next minute which means it stays on for one minute
always @(posedge clk or posedge reset)
	begin
		if(reset || !checkAlarm)
			begin
				AlarmLED <= 0;
			end
		else if(checkAlarm)
			begin
				AlarmLED <= 1;
			end
	end 

//the clocks modules to allow the clock to work and increment othe module when the first has reached its maximum value
mod10 m10_l (clk, reset, load, 4'd0, Y, D0, CEO1);
mod6 m6_1 (clk, reset, load, 4'd0, CEO1, D1, CEO2);
mod10 m10_2 (clk, reset, load, minOnes, CEO2, D2, CEO3);
mod6 m6_2 (clk, reset, load, minTens, CEO3, D3, CEO4);
hoursMod10 hoursm10_1 (clk, reset, load, hoursOnes, CEO4, hours_Limit, D4, CEO5);
mod3 m3 (clk, reset, load, hoursTens, CEO5, D5, CEO);

//7-segement display to show the numbers in the fga board
DISP7SEG ssd (clk, D0, D1, D2, D3, D4, D5, D6, D7, text_mode, slow, med, fast, error, seg, an);

//onehz and 1khz method for the clock to add to the counter normally or to add faster for testing purposes
onehz (clk, reset, CE, counter, Clk1hz);
oneKhz (clk, reset, CE, counter, Clk1Khz);
endmodule
