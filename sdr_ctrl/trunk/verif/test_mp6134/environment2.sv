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

`include "environment.sv"
`include "estimulo1.sv"
`include "estimulo2.sv"
`include "estimulo3.sv"
`include "estimulo4.sv"
`include "estimulo5.sv"
`include "driver2.sv"


class environment2 extends environment;
	estimulo1 est1;
	estimulo2 est2;
	estimulo3 est3;
	estimulo4 est4;
	estimulo5 est5;
	driver2 driv2;

	//Creando la interfaz virtual para el manejo de memoria
	//constructor
	function new(virtual interface_sdrc mem_vif);
	    //get the interface from test
	    super.new(mem_vif);
	    est1 = new();
	    est2 = new();
	    est3 = new();
	    est4 = new();
	    est5 = new();
	    driv2 = new(mem_vif, score1, est1, est2, est3, est4, est5);
	endfunction : new

endclass : environment2