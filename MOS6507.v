/* Atari on an FPGA
Masters of Engineering Project
Cornell University, 2007
Daniel Beer
MOS6507.v
Wrapper for a 6502 CPU module that emulates the MOS 6507.
*/
module MOS6507 (A, // 13 bit address bus output
					Din, // 8 bit data in bus
					Dout, // 8 bit data out bus
					R_W_n, // Active low read/write output
					CLK_n, // Negated clock signal
					RDY, // Active high ready line
					RES_n); // Active low reset line

	output [12:0] A;
	input [7:0] Din;
	output [7:0] Dout;
	output R_W_n;
	input CLK_n;
	input RDY;
	input RES_n;

// module chip_6502 (
//     input           clk,    // FPGA clock
//     input           phi,    // 6502 clock
//     input           res,
//     input           so,
//     input           rdy,
//     input           nmi,
//     input           irq,
//     input     [7:0] dbi,
//     output    [7:0] dbo,
//     output          rw,
//     output          sync,
//     output   [15:0] ab);

	// chip_6502 c6502(
	// 	.clk(T65_CLK), // ~CLK_n),
	// 	.phi,
	// 	.res(~RES_n),
	// 	.so(1'b0),
	// 	.rdy(RDY),
	// 	.nmi(1'b0), // WHAT? shouldn't NMI be connected?
	// 	.irq(1'b0),
	// 	.dbi(Din),
	// 	.dbo(Dout),
	// 	.rw(~R_W_n),
	// 	.sync(),
	// 	.ab(T65_A)
	// );

// module cpu( clk, reset, AB, DI, DO, WE, IRQ, NMI, RDY );
// 	input clk;              // CPU clock
// 	input reset;            // reset signal
// 	output reg [15:0] AB;   // address bus
// 	input [7:0] DI;         // data in, read bus
// 	output [7:0] DO;        // data out, write bus
// 	output WE;              // write enable
// 	input IRQ;              // interrupt request
// 	input NMI;              // non-maskable interrupt request
// 	input RDY;              // Ready signal. Pauses CPU when RDY=0

	wire [15:0] T65_A;
	wire T65_CLK;
	wire T65_WE;
	cpu cpu_6502(
		.clk(T65_CLK),
		.reset(~RES_n),
		.AB(T65_A),
		.DI(Din),
		.DO(Dout),
		.WE(T65_WE),
		.IRQ(1'b0),
		.NMI(1'b0), // WHAT? shouldn't NMI be connected?
		.RDY(RDY)
	);
	assign A = T65_A[12:0];
	assign T65_CLK = ~CLK_n;
	assign T65_WE = ~R_W_n;

	// // Instatiate a 6502 and selectively connect used lines
	// wire [23:0] T65_A;
	// wire T65_CLK;
	// T65 t0(.Mode(2'b0), .Res_n(RES_n), .Clk(T65_CLK), .Rdy(RDY), .Abort_n(1'b1), .IRQ_n(1'b1),
	// 	.NMI_n(1'b1), .SO_n(1'b1), .R_W_n(R_W_n), .A(T65_A), .DI(Din), .DO(Dout),
	// 	.Sync(), .EF(), .MF(), .XF(), .ML_n(), .VP_n(), .VDA(), .VPA());
	// assign A = T65_A[12:0];
	// assign T65_CLK = ~CLK_n;

endmodule
