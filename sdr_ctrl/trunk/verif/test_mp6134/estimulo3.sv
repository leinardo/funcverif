//////////////////////////////////////////////////////////////////////////////////
// Company:				ITCR
// Engineers:			Sergio Arriola
//						Reinaldo Castro
//						Jaime Mora
//						Javier Pérez 
// 						
// Create Date:    		18/03/2017 
// Design Name: 		Enviroment SDRAM Controler 
// Module Name:			estimulo3 
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

class estimulo3;
	
	//bit [11:0] row;
	//bit [1:0]  bank;
	rand bit [7:0]  colum;
	rand bit [1:0]  cfg_col;
	rand bit [7:0] bl;
	
	constraint c_estimulo3 {
		//row >= 12'h000;
		//row <= 12'h003;
		//bank <= 2'b11;
		//bank >= 2'b00;
		colum >= 8'h00;
		colum <= 8'h07;
		cfg_col <= 2'b00;
		cfg_col >= 2'b00;

		bl > 8'h00;
		bl <= 8'h0f;
	}
	

endclass : estimulo3