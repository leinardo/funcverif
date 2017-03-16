//////////////////////////////////////////////////////////////////////////////////
// Company:				ITCR
// Engineers:			Sergio Arriola
//						Reinaldo Castro
//						Jaime Mora
//						Javier Pérez 
// 						
// Create Date:			03/03/2017 
// Design Name: 		Test Bench Enviroment SDRAM Controler 
// Module Name:			scoreboard
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

class scoreboard; 

//-------------------------------
// data/address/burst length FIFO
//-------------------------------
/*
static int dfifo[$]; // data fifo
static int afifo[$]; // address  fifo
static int bfifo[$]; // Burst Length fifo
*/
int address_fifo[$];
int data_fifo[$];
int bl_fifo[$];
/*
function new();
	address_fifo = 0;
	data_fifo = 0;
	bl_fifo = 0;
endfunction : new
*/
endclass