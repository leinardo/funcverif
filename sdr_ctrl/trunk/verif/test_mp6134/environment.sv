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
`include "monitor.sv"
`include "scoreboard.sv"
`include "driver.sv"

class environment;
	monitor mon;
	driver driv;
	scoreboard score;

		//Creando la interfaz virtual para el manejo de memoria
	virtual mem_intf mem_vif;
	virtual mem_intf mem_afifo;
	virtual mem_intf mem_bifo;
	virtual mem_intf mem_dfifo;

	//constructor
	function new(virtual mem_intf mem_vif, virtual mem_intf mem_afifo, virtual mem_intf mem_bfifo, virtual mem_intf mem_dfifo);
	    //get the interface from test
	    this.mem_vif = mem_vif;
	    this.mem_afifo = mem_afifo;
	    this.mem_bfifo = mem_bfifo;
		this.mem_dfifo = mem_dfifo;
		mon = new(mem_vif,mem_afifo,mem_bfifo,mem_dfifo);
		driv = new(mem_vif,mem_afifo,mem_bfifo,mem_dfifo);
		score = new(mem_afifo,mem_bfifo,mem_dfifo);
	endfunction : new

	task reinicio();
		driv.reset();
	endtask : reinicio

	task escritura(Address, bl);
		driv.burst_write(Address, bl);
	endtask : escritura

	task lectura();
		mon.burst_read();
	endtask : lectura

endclass