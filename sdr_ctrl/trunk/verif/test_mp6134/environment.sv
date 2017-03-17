//////////////////////////////////////////////////////////////////////////////////
// Company:				ITCR
// Engineers:			Sergio Arriola
//						Reinaldo Castro
//						Jaime Mora
//						Javier Pérez 
// 						
// Create Date:    		03/03/2017 
// Design Name: 		Enviroment SDRAM Controler 
// Module Name:			Environment 
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

`include "scoreboard.sv"
`include "driver.sv"
`include "monitor.sv"

class environment;
	monitor mon;
	driver driv;
	scoreboard score1;

	//Creando la interfaz virtual para el manejo de memoria
	virtual interface_sdrc mem_vif;

	//constructor
function new(virtual interface_sdrc mem_vif);
    //get the interface from test
    this.mem_vif = mem_vif;
    score1 = new();
    driv = new(mem_vif, score1);
    mon = new(mem_vif, score1);
	
    //score = new;
endfunction : new

/*	//static scoreboard score;
	scoreboard score;
	
	//Creando la interfaz virtual para el manejo de memoria
	virtual interface_sdrc mem_vif;

	//constructor
	function new(virtual interface_sdrc mem_vif);
	    //get the interface from test
	    this.mem_vif = mem_vif;
	    mon = new(mem_vif, score2monitor);
		driv = new(mem_vif, drive2score);
		drive2score = new();
		score2monitor = new();
		score = new(drive2score,score2monitor);
		//score.run();
	endfunction : new*/
    

endclass : environment