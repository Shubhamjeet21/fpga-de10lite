FPGA Design for Embedded Systems: Capstone Module 1

Combinational logic exercises on the Terasic DE10-Lite, working up from a single seven-segment decoder to a two-digit BCD adder. Each part is a self-contained Quartus project.

Board: Terasic DE10-Lite (MAX 10, 10M50DAF484C7G) Tools: Quartus Prime Lite 16.1, ModelSim-Altera Starter Edition 10.5b Language: VHDL, instantiated into the Terasic DE10_LITE_Golden_Top.v template

Parts I through IV are written with simple concurrent assignment statements only, with no IF-ELSE, CASE, or arithmetic operators, so the logic is hand-derived rather than inferred by the compiler. Part V repeats Part IV behaviourally to compare the two approaches.

Part I: BCD to 7-Segment Decoder

Combinational BCD-to-seven-segment decoder. SW7-4 and SW3-0 display as decimal digits on HEX1 and HEX0. Each segment is a hand-derived Boolean expression from a Karnaugh map, with inputs 1010 to 1111 treated as don't-cares.

Minimized equations
a = C3 + C1 + C2·C0 + C2'·C0'
b = C2' + C1·C0 + C1'·C0'
c = C2 + C1' + C0
d = C3 + C2'·C0' + C2'·C1 + C1·C0' + C2·C1'·C0
e = C2'·C0' + C1·C0'
f = C3 + C2·C1' + C2·C0' + C1'·C0'
g = C3 + C2·C1' + C2'·C1 + C1·C0'

Displays are active low, so each expression is inverted at the pin.

Results
Metric	Value
Logic elements	14 / 49,760 (~0.03%)
Registers	0
Fmax	Not applicable, purely combinational
Part II: Binary to Decimal (BCD) Display

Converts a four-bit binary value V = SW3-0 into its two-digit decimal equivalent d1d0 on HEX1 and HEX0. A comparator detects V > 9 and drives a 4-bit 2-to-1 multiplexer that selects either V directly or a corrected value from circuit A, which subtracts ten for inputs 1010 through 1111.

Minimized equations
z  = TODO
A3 = TODO
A2 = TODO
A1 = TODO
A0 = TODO

Functional simulation in ModelSim verifies the comparator, multiplexer, and circuit A. Forcing V = 0000 gives z = 0 with the multiplexer passing V through. Forcing V = 1111 gives z = 1 with A = 0101, displaying 15. The saved transcript is C4M1P2/C4M1P2.

Results
Metric	Value
Logic elements	TODO / 49,760
Registers	0
Fmax	Not applicable, purely combinational
Part III: Four-Bit Ripple Carry Adder

A one-bit full adder entity is instantiated four times, with each stage's carry-out wired to the next stage's carry-in. The carry-out expression follows the multiplexer form shown in the project guide rather than the more common (a·b) + (ci·(a XOR b)). Both synthesise identically here.

p  = a XOR b
s  = p XOR ci
co = p·ci + p'·b

I/O mapping: A = SW7-4, B = SW3-0, carry-in = SW8, sum = LEDR3-0, carry-out = LEDR4.

Results
Metric	Value
Logic elements	9 / 49,760 (<1%)
Registers	0
Fmax	Not applicable, purely combinational

Roughly two logic elements per adder stage. With no clocked path in the design, the speed limit is propagation delay through the carry chain rather than a clock frequency. TimeQuest correctly reports no clocks defined and no setup or hold paths, which is expected rather than a fault.

Part IV: BCD Adder

In progress.

Adds two BCD digits X and Y plus a carry-in, displaying the two-digit sum S1S0 on HEX1 and HEX0. Reuses the Part III adder for X + Y and the Part II converter for the decimal conversion, with output correction for sums in the range 15 < X+Y <= 19. LEDR9 flags an invalid input where X or Y exceeds nine.

Part V: BCD Adder Revisited

In progress.

The same BCD adder described behaviourally with IF-ELSE and the > and + operators, letting the synthesiser choose the structure. The point of the exercise is the resource comparison against the hand-derived Part IV implementation.

Building

Each part is an independent Quartus project. Open the .qpf, compile with Ctrl+L, and program output_files/<revision>.sof via Tools -> Programmer with the USB-Blaster selected under Hardware Setup.

Pin assignments come from the DE10-Lite board template and are stored in each project's .qsf. The VHDL entity is instantiated inside DE10_LITE_Golden_Top.v, which must be set as the top-level entity. The pin assignments live there, so a design compiled with the VHDL entity as top level will build cleanly but do nothing on the board.

Note that Quartus names output files after the project revision, not the top-level entity, so a project copied from an earlier part will write its .sof under the old name until the revision is renamed.
