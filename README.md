BCD to 7-Segment Decoder

Combinational BCD-to-seven-segment decoder in VHDL. SW7-4 and SW3-0 display as decimal digits on HEX1 and HEX0. Each segment is a hand-derived Boolean expression from a Karnaugh map, with inputs 1010–1111 treated as don't-cares.

Board: Terasic DE10-Lite (MAX 10, 10M50DAF484C7G) Tools: Quartus Prime Lite

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
14 logic elements of 49,760 (~0.03%)
0 registers - purely combinational, so Fmax does not apply
Build

Open C4M1P1.qpf, compile (Ctrl+L), and program output_files/C4M1P1.sof via Tools → Programmer. Pin assignments are in the .qsf; de10lite_pins.tcl regenerates them if needed.
