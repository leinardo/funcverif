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

//`define SCOR_IF mem_vif.MONITOR.monitor_cb

class scoreboard; 

	//-------------------------------
	// data/address/burst length FIFO
	//-------------------------------
	
	int dfifo[$]; // data fifo
	int afifo[$]; // address  fifo
	int bfifo[$]; // Burst Length fifo

	virtual mem_intf mem_afifo;
	virtual mem_intf mem_bifo;
	virtual mem_intf mem_dfifo;

	function new(virtual mem_intf mem_afifo, virtual mem_intf mem_bfifo, virtual mem_intf mem_dfifo);
    //get the interface from test
    this.mem_afifo = afifo;
    this.mem_bfifo = bfifo;
    this.mem_dfifo = dfifo;
	endfunction : new

	task main ();
		mem_intf.mem_aifo = afifo
		mem_intf.mem_bifo = bfifo
		mem_intf.mem_difo = dfifo
	endtask : main


endclass : scoreboard