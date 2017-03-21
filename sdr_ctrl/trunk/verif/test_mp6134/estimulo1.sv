//////////////////////////////////////////////////////////////////////////////////
// Company:				ITCR
// Engineers:			Sergio Arriola
//						Reinaldo Castro
//						Jaime Mora
//						Javier Pérez 
// 						
// Create Date:    		18/03/2017 
// Design Name: 		Enviroment SDRAM Controler 
// Module Name:			<estimulo1 
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
//////////////////////////////////////////////////////////////////////////////////

class estimulo1;

	rand bit [31:0] Addr_write;
	rand bit [7:0] bl;
	int parametro1;
	int parametro2;

	constraint c_estimulo1 {


		Addr_write >= parametro1;// 32'h0004_0000;
		Addr_write <= parametro2;// 32'h0007_0000;

		bl > 8'h4;
		bl < 8'h7;
	}
	

endclass : estimulo1