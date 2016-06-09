`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:59:04 12/27/2014
// Design Name:   async_rst_sync_recover
// Module Name:   E:/DigitalProgram/Again_100_Floors/syn_rst_tb.v
// Project Name:  Again_100_Floors
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: async_rst_sync_recover
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module syn_rst_tb;

	// Inputs
	reg clk_50m;
	reg rst_in;

	// Outputs
	wire rst;
always #1 clk_50m=~clk_50m;
	// Instantiate the Unit Under Test (UUT)
	async_rst_sync_recover uut (
		.clk_50m(clk_50m), 
		.rst_in(rst_in), 
		.rst(rst)
	);

	initial begin
		// Initialize Inputs
		clk_50m = 0;
		rst_in = 1;
	#23 rst_in=~rst_in;
	#24 rst_in=~rst_in;
	#25 rst_in=~rst_in;
	#26 rst_in=~rst_in;
	#27 rst_in=~rst_in;
	#28 rst_in=~rst_in;
	#29 rst_in=~rst_in;
	#30 rst_in=~rst_in;
	// Wait 100 ns for global reset to finis
        
		// Add stimulus here

	end
      
endmodule

