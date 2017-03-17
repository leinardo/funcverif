//////////////////////////////////////////////////////////////////////////////////
// Company:				ITCR
// Engineers:			Sergio Arriola
//						Reinaldo Castro
//						Jaime Mora
//						Javier Pérez 
// 						
// Create Date:			17/03/2017 
// Design Name: 		Test Bench Enviroment SDRAM Controler 
// Module Name:			clk
// Project Name: 		SDRAM Controler
// Target Devices:		None
// Tool versions:		VCS K-2015.09-SP2-3
// Description: 		
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
/////////////////////////////////////////////////////////////////////////////////
module clk(output sys_clk, sdram_clk);
	parameter P_SYS  = 10;     //    200MHz
	parameter P_SDR  = 20;     //    100MHz

	reg   sdram_clk;
	reg   sys_clk;
	
	initial sys_clk = 0;
	initial sdram_clk = 0;

	always #(P_SYS/2) sys_clk = !sys_clk;
	always #(P_SDR/2) sdram_clk = !sdram_clk;
endmodule // clk
