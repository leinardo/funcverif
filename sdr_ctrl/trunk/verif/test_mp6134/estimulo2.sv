//////////////////////////////////////////////////////////////////////////////////
// Company:				ITCR
// Engineers:			Sergio Arriola
//						Reinaldo Castro
//						Jaime Mora
//						Javier Pérez 
// 						
// Create Date:    		18/03/2017 
// Design Name: 		Enviroment SDRAM Controler 
// Module Name:			estimulo2 
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

class estimulo2;

	rand bit [31:0] Addr_write;
	rand bit [7:0] bl;

	constraint c_estimulo2 {

		Addr_write [11:0] inside {[3841:4095]};
		Addr_write [31:12] inside {[0:368]}; // limite de los bits menos significativos, esto depende de la memoria

		//Addr_write >= 32'h0000_0FF0;
		//Addr_write <= 32'h0017_0FAC;

		//bl >= 8'hE;
		//bl <= 8'hF;
	}
	

endclass : estimulo2
