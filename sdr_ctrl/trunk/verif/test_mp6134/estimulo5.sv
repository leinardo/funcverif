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

class estimulo5;
	
	rand bit [11:0] row;
	rand bit [1:0]  bank;
	rand bit [7:0]  colum1;
	rand bit [7:0]  colum2;
	rand bit [7:0]  colum3;
	rand bit [7:0]  colum4;
	rand bit [7:0]  colum5;
	rand bit [7:0]  colum6;
	rand bit [7:0]  colum7;
	rand bit [7:0]  colum8;
	rand bit [1:0]  cfg_col;
	rand bit [7:0] bl;
	
	constraint c_estimulo5 {
		row >= 12'h000;
		row <= 12'h00B;
		bank <= 2'b11;
		bank >= 2'b00;
		colum1 >= 8'h00;
		colum1 <= 8'h1F;

		colum2 >= 8'h20;
		colum2 <= 8'h3F;

		colum3 >= 8'h40;
		colum3 <= 8'h5F;

		colum4 >= 8'h60;
		colum4 <= 8'h7F;

		colum5 >= 8'h80;
		colum5 <= 8'h9F;

		colum6 >= 8'hA0;
		colum6 <= 8'hBF;

		colum7 >= 8'hC0;
		colum7 <= 8'hDF;

		colum8 >= 8'hE0;
		colum8 <= 8'hFF;

		cfg_col <= 2'b00;
		cfg_col >= 2'b00;

		bl > 8'h00;
		bl <= 8'hff;
	}
	

endclass : estimulo5