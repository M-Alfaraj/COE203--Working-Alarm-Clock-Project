# COE203--Working-Alarm-Clock-Project
This project implements an FPGA-based digital alarm clock with snooze functionality using Verilog HDL. The system displays real-time HH:MM:SS, supports user-defined time and alarm setting, and includes an alarm trigger with snooze extension. It demonstrates core digital design concepts such as finite state machines, clock division, and modular counter design.

## Group Members
1. Redha Alturaik – 202323010
2. Mohammed Alfaraj – 202323090

## Objectives
- Design and implement digital circuits using Verilog HDL
- Build a modular digital clock system
- Apply clock division techniques for accurate timing
- Use finite state machine (FSM) concepts for control logic
- Implement alarm and snooze functionality
- Interface with FPGA components (7-segment display, buttons, LEDs, buzzer)
- Apply button debouncing techniques
## System Features
### Digital Clock
- Counts from 00:00:00 to 23:59:59
- Automatic reset after full cycle
- Modular BCD counters for seconds, minutes, and hours
### Time Setting
- Load time using FPGA switches
- Supports safe input constraints (BCD validation)
- One-button load functionality
### Alarm System
- Set alarm time independently
- Trigger LED/buzzer when time matches alarm
- Stores alarm until changed
### Snooze Feature
- Extends alarm time by 5 minutes
- Maintains alarm state after snooze activation
### Clock Control
- Clock division modules:
- 1 Hz normal operation
- 1 kHz fast testing mode

## Design Methodology
1. Clock & Counter Design
- Modular counters:
- mod10 → seconds/minutes ones
- mod6 → tens of seconds/minutes
- mod3 → tens of hours
- hoursMod10 → hours ones with constraint logic

2. Time Logic
- Cascading counters with carry-out enable signals
- Reset and enable-based synchronous operation
- 24-hour format enforcement

3. Time Setting Logic
- Switch-based BCD input system
- Input validation to prevent invalid time (e.g., >23 hours)
- Load signal updates clock registers

4. Alarm Logic
- Stored alarm registers
- Comparator checks current time vs alarm time
- LED activation when match occurs

5. Snooze Logic
- Adds +5 minutes to current alarm time
- Handles overflow across minutes/hours correctly

## Known Issue
- Snooze feature may extend alarm by 10 minutes instead of 5 in some edge cases, likely due to carry propagation logic in minute handling.

## Testing & Results

The system was tested on FPGA hardware using multiple scenarios:

- Full 24-hour clock cycle validation
- Manual time setting via switches
- Alarm triggering accuracy
- Snooze activation behavior
- Fast clock testing using 1 kHz mode

All core functionalities operated correctly under normal conditions.

## Tools & Technologies
- Verilog HDL
- FPGA Development Board
- 7 Segment Display Interface
- Digital Logic Design Tools
- Clock Divider Modules

## Work Distribution
Member	Contribution:
- Redha Alturaik	50%
- Mohammed Alfaraj	50%

## Key Concepts Used
- Finite State Machines (FSM)
- BCD Counters
- Clock Division
- Modular Design
- Synchronous Digital Systems
- Hardware Debouncing

## Conclusion

This project successfully demonstrates a fully functional FPGA-based alarm clock system with snooze capability. It integrates multiple digital design concepts into a practical embedded system, reinforcing FPGA development skills and hardware-level thinking.
