/* Atari on an FPGA
	Masters of Engineering Project
	Cornell University, 2007
	Daniel Beer
	MySystem.v
	Top level system for synthesis and programming on a DE2 board.
*/

module MySystem(
				//////////////////// Clock Input ////////////////////
				CLOCK_27, // 27 MHz
				CLOCK_50, // 50 MHz
				//////////////////// SRAM Interface ////////////////
				SRAM_DQ, // SRAM Data bus 16 Bits
				SRAM_ADDR, // SRAM Address bus 18 Bits
				SRAM_UB_N, // SRAM High?byte Data Mask
				SRAM_LB_N, // SRAM Low?byte Data Mask
				SRAM_WE_N, // SRAM Write Enable
				SRAM_CE_N, // SRAM Chip Enable
				SRAM_OE_N, // SRAM Output Enable
				//////////////////// VGA ////////////////////////////
				VGA_CLK, // VGA Clock
				VGA_HS, // VGA H_SYNC
				VGA_VS, // VGA V_SYNC
				VGA_BLANK, // VGA BLANK
				VGA_SYNC, // VGA SYNC
				VGA_R, // VGA Red[9:0]
				VGA_G, // VGA Green[9:0]
				VGA_B, // VGA Blue[9:0]
				TD_RESET, // 27 Mhz Enable
				KEY, // Push Buttons
				LEDG, // Green LEDs
				LEDR, // Red LEDs
				SW, // Switches
				HEX0, HEX1, HEX2, HEX3, HEX4, // 7?Segment displays
				HEX5, HEX6, HEX);
	//////////////////////// Clock Input ////////////////////////
	input CLOCK_27; // 27 MHz
	input CLOCK_50; // 50 MHz
	//////////////////////// SRAM Interface ////////////////////////
	inout [15:0] SRAM_DQ; // SRAM Data bus 16 Bits
	output [17:0] SRAM_ADDR; // SRAM Address bus 18 Bits
	output SRAM_UB_N; // SRAM High?byte Data Mask
	output SRAM_LB_N; // SRAM Low?byte Data Mask
	output SRAM_WE_N; // SRAM Write Enable
	output SRAM_CE_N; // SRAM Chip Enable
	output SRAM_OE_N; // SRAM Output Enable
	//////////////////////// VGA ////////////////////////////
	output VGA_CLK; // VGA Clock
	output VGA_HS; // VGA H_SYNC
	output VGA_VS; // VGA V_SYNC
	output VGA_BLANK; // VGA BLANK
	output VGA_SYNC; // VGA SYNC
	output [9:0] VGA_R; // VGA Red[9:0]
	output [9:0] VGA_G; // VGA Green[9:0]
	output [9:0] VGA_B; // VGA Blue[9:0]
	output TD_RESET;
	input [3:0] KEY; // Pushbutton[3:0]
//	output [8:0] LEDG;
	output [17:0] LEDR;
	input [17:0] SW;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 /*, HEX6, HEX7*/;
	// Turn off all LEDs
	assign HEX0 = 7`h7F;
	assign HEX1 = 7`h7F;
	assign HEX2 = 7`h7F;
	assign HEX3 = 7`h7F;
	assign HEX4 = 7`h7F;
	assign HEX5 = 7`h7F;
/*
	assign HEX6 = 7`h7F;
	assign HEX7 = 7`h7F;
	assign LEDG = 0;
*/
	assign LEDR = 0;
	// Turn on the 27 Mhz clock
	assign TD_RESET = 1`b1;
	// Atari System
	wire ATARI_CLOCKPIXEL, ATARI_CLOCKBUS;
	wire [7:0] ATARI_COLOROUT;
	wire ATARI_ROM_CS;
	wire [11:0] ATARI_ROM_Addr;
	wire [7:0] ATARI_ROM_Dout;
	wire ATARI_HSYNC, ATARI_HBLANK, ATARI_VSYNC, ATARI_VBLANK;
	wire ATARI_SW_COLOR, ATARI_SW_SELECT, ATARI_SW_START;
	wire [1:0] ATARI_SW_DIFF;
	wire [4:0] ATARI_JOY_A_in, ATARI_JOY_B_in;
	wire RES_n;

	Atari2600(  .CLOCKPIXEL(ATARI_CLOCKPIXEL), .CLOCKBUS(ATARI_CLOCKBUS),
					.COLOROUT(ATARI_COLOROUT), .ROM_CS(ATARI_ROM_CS),
					.ROM_Addr(ATARI_ROM_Addr), .ROM_Dout(ATARI_ROM_Dout),
					.HSYNC(ATARI_HSYNC), .HBLANK(ATARI_HBLANK), .VSYNC(ATARI_VSYNC),
					.VBLANK(ATARI_VBLANK), .RES_n(RES_n), .SW_COLOR(ATARI_SW_COLOR),
					.SW_DIFF(ATARI_SW_DIFF), .SW_SELECT(ATARI_SW_SELECT),
					.SW_START(ATARI_SW_START), .JOY_A_in(ATARI_JOY_A_in),
					.JOY_B_in(ATARI_JOY_B_in));

	// Cartridge module
	Catridge2k
	#(.romFile("cartridge.hex"))
	(.address(ATARI_ROM_Addr[10:0]),
	.clken(ATARI_ROM_CS),
	.clock(ATARI_CLOCKBUS),
	.q(ATARI_ROM_Dout));

	// Uncomment this block to use 4k cartridges
	/*
	Catridge4k
	#(.romFile("cartridge.hex"))
	(.address(ATARI_ROM_Addr),
	.clken(ATARI_ROM_CS),
	.clock(ATARI_CLOCKBUS),
	.q(ATARI_ROM_Dout));
	*/

	// Clock generation modules
	wire ATARI_CLOCKPIXEL16, ATARI_CLOCKBUS16;
	wire DLY_RST;

	AtariClockGenerator (
								.areset(~DLY_RST),
								.inclk0(CLOCK_50),
								.c0(ATARI_CLOCKPIXEL16),
								.c1(ATARI_CLOCKBUS16));

	ClockDiv16( .inclk(ATARI_CLOCKPIXEL16),
					.outclk(ATARI_CLOCKPIXEL),
					.reset_n(RES_n));
	ClockDiv16( .inclk(ATARI_CLOCKBUS16),
					.outclk(ATARI_CLOCKBUS),
					.reset_n(RES_n));

	// Peripherals
	assign RES_n = DLY_RST;
	assign ATARI_SW_COLOR = SW[0];
	assign ATARI_SW_SELECT = KEY[0];
	assign ATARI_SW_START = KEY[1];
	assign ATARI_SW_DIFF = SW[2:1];
	assign ATARI_JOY_A_in = ~SW[7:3];
	assign ATARI_JOY_B_in = ~SW[12:8];

	// NTSC to VGA converter
	// Circular pixel buffers to temporarily store pixel data when the
	// VGA controller has control of the SRAM
	reg [7:0] pixelColor[511:0];
	reg [8:0] pixelX[511:0], pixelY[511:0];
	reg [8:0] curWriteIndex, curReadIndex;
	// NTSC Emulator
	reg [7:0] ATARI_Video_PixelX;
	reg [8:0] ATARI_Video_PixelY;
	reg R_ATARI_HBLANK;
	reg [7:0] R_ATARI_COLOROUT;

	always @(negedge ATARI_CLOCKPIXEL)
	begin
		// Registered signals
		R_ATARI_HBLANK <= ATARI_HBLANK;
		R_ATARI_COLOROUT <= ATARI_COLOROUT;

		if (~RES_n)
		begin
			ATARI_Video_PixelX <= 8'd0;
			ATARI_Video_PixelY <= 9'd0;
			curWriteIndex <= 9'd0;
		end
		else begin
			// Use the end of the horizontal blanking signal to find the end of the
			// scanline.
			if (ATARI_HBLANK)
			begin
				ATARI_Video_PixelX <= 8'd0;
				// At the end of a scanline, move down one scanline
				if (~R_ATARI_HBLANK & ~ATARI_VBLANK)
					ATARI_Video_PixelY <= ATARI_Video_PixelY + 9'd1;
			end
			// If we are not blanking, go to the next pixel in the scanline.
			else
				ATARI_Video_PixelX <= ATARI_Video_PixelX + 8'd1;
			// Use the vertical blanking signal to find the end of the frame.
			if (ATARI_VBLANK)
				ATARI_Video_PixelY <= 9'd0;
			// Write the pixel location and color to the circular buffer
			pixelColor[curWriteIndex] <= R_ATARI_COLOROUT;
			pixelX[curWriteIndex] <= {1'b0, ATARI_Video_PixelX};
			pixelY[curWriteIndex] <= ATARI_Video_PixelY;
			curWriteIndex <= curWriteIndex + 9'd1;
		end
	end

	// VGA Controller
	wire VGA_CTRL_CLK;
	wire AUD_CTRL_CLK;
	wire [9:0] mVGA_R;
	wire [9:0] mVGA_G;
	wire [9:0] mVGA_B;
	wire [19:0] mVGA_ADDR;
	wire [9:0] Coord_X, Coord_Y;

	Reset_Delay r0 (.iCLK(CLOCK_50), .oRESET(DLY_RST), .iRESET(KEY[3]));
	VGA_Audio_PLL p1 (.areset(~DLY_RST), .inclk0(CLOCK_27), .c0(VGA_CTRL_CLK), .c1(AUD_CTRL_CLK),.c2(VGA_CLK) );
	VGA_Controller u1 ( // Host Side
						.iCursor_RGB_EN(4'b0111),
						.oAddress(mVGA_ADDR),
						.oCoord_X(Coord_X),
						.oCoord_Y(Coord_Y),
						.iRed(mVGA_R),
						.iGreen(mVGA_G),
						.iBlue(mVGA_B),
						// VGA Side
						.oVGA_R(VGA_R),
						.oVGA_G(VGA_G),
						.oVGA_B(VGA_B),
						.oVGA_H_SYNC(VGA_HS),
						.oVGA_V_SYNC(VGA_VS),
						.oVGA_SYNC(VGA_SYNC),
						.oVGA_BLANK(VGA_BLANK),
						// Control Signal
						.iCLK(VGA_CTRL_CLK),
						.iRST_N(DLY_RST) );

	// SRAM registers and controls
	reg [17:0] addr_reg; // Memory address register for SRAM
	reg [15:0] data_reg; // Memory data register for SRAM
	reg we; // Write enable for SRAM

	assign SRAM_ADDR = addr_reg;
	assign SRAM_DQ = (we)? 16'hzzzz : data_reg ;
	assign SRAM_UB_N = 0; // hi byte select enabled
	assign SRAM_LB_N = 0; // lo byte select enabled
	assign SRAM_CE_N = 0; // chip is enabled
	assign SRAM_WE_N = we; // write when ZERO
	assign SRAM_OE_N = 0; //output enable is overidden by WE

	// Connect the color table to the SRAM
	wire CT_clk;
	wire [3:0] CT_lum;
	wire [3:0] CT_hue;
	wire [1:0] CT_mode;
	wire [23:0] CT_outColor;
	TIAColorTable(.clk(CT_clk), .lum(CT_lum), .hue(CT_hue), .mode(CT_mode), .outColor(CT_outColor));

	assign CT_clk = ~VGA_CTRL_CLK;
	assign CT_lum = SRAM_DQ[3:0];
	assign CT_hue = SRAM_DQ[7:4];
	assign CT_mode = 2'b00;

	// Show the color table output on the VGA
	assign mVGA_R = {CT_outColor[23:16], {2{CT_outColor[23:16]!=2'b0}}} ;
	assign mVGA_G = {CT_outColor[15:8], {2{CT_outColor[15:8]!=2'b0}}} ;
	assign mVGA_B = {CT_outColor[7:0], {2{CT_outColor[7:0]!=2'b0}}} ;

	// State machine to synchronize accesses to the SRAM
	wire syncing;
	assign syncing = (~VGA_VS | ~VGA_HS);

	always @(posedge VGA_CTRL_CLK)
	begin
		if (~RES_n)
		begin
			// Clear the screen
			addr_reg <= {Coord_X[9:2],Coord_Y[9:1]} ;
			we <= 1'b0;
			data_reg <= 16'h0000;
			curReadIndex <= 9'd0;
		end
		// If we are syncing, read pixels from the circular buffer and write them to
		// the SRAM
		else if (syncing)
		begin
			addr_reg <= {pixelX[curReadIndex],pixelY[curReadIndex]};
			we <= 1'b0;
			data_reg <= {8'b0,pixelColor[curReadIndex]};
			curReadIndex <= curReadIndex + 9'd1;
		end
		// When the VGA controller needs the SRAM, retreive pixels from SRAM
		else
		begin
			addr_reg <= {Coord_X[9:2],Coord_Y[9:1]} ;
			we <= 1'b1;
		end
	end
endmodule