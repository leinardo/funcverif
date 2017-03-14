//////////////////////////////////////////////////////////////////////////////////
// Company:				ITCR
// Engineers:			Sergio Arriola
//						Reinaldo Castro
//						Jaime Mora
//						Javier Pérez 
// 						
// Create Date:			03/03/2017 
// Design Name: 		Test Bench Enviroment SDRAM Controler 
// Module Name:			driver
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

`define DRIV_IF mem_vif.DRIVER.driver_cb
//`include "scoreboard.sv"
class driver; //extends  /* base class*/ (
//scoreboard score;
//score = new;
mailbox score_address;
mailbox score_data;
mailbox score_bl;
//Creando la interfaz virtual para el manejo de memoria
virtual interface_sdrc mem_vif;

	//constructor
function new(virtual interface_sdrc mem_vif,mailbox score_address, score_data, score_bl);
    //get the interface from test
    this.mem_vif = mem_vif;
    this.score_address = score_address;
    this.score_data = score_data;
    this.score_bl = score_bl;
    //score = new;
endfunction : new

//funciones y tareas
task reset;
    //wait(mem_vif.reset);
    $display("--------- [DRIVER] Reset Started ---------");
	// Applying reset
	//`DRIV_IF.wb_rst			<=0;
	//`DRIV_IF.sdram_resetn	<=0;
	#100 mem_vif.wb_rst <= 1;
	#100 mem_vif.wb_rst <= 0;
/*	`DRIV_IF.wb_stb		<= 0;
	`DRIV_IF.wb_cyc		<= 0;clea
	`DRIV_IF.wb_we		<= 0;
	`DRIV_IF.wb_sel		<= 0;
	`DRIV_IF.wb_addr	<= 0;
   	`DRIV_IF.wb_dati	<= 0;*/
   	#1000
   	mem_vif.wb_rst 	<= 1;        
    //wait(!mem_vif.reset);
    $display("--------- [DRIVER] Reset Ended ---------");
endtask

	/*	//Tarea para reset
		#100
		// Applying reset
		RESETN    = 1'h0;
		#10000;
		// Releasing reset
		RESETN    = 1'h1;
	endtask :reset*/

task burst_write(input [31:0] Address, input [7:0] bl);
	int i;
	reg add_mlbx;
	reg bl_mlbx;
	reg data_mlbx;
	begin
		add_mlbx = Address;
		bl_mlbx = bl;
		score_address.put(add_mlbx);
		score_bl.put(bl_mlbx);
	   @ (negedge mem_vif.DRIVER.wb_clk);
		$display("Write Address: %x, Burst Size: %d",Address,bl);

		for(i=0; i < bl; i++) begin
	    	`DRIV_IF.wb_stb        <= 1;
	    	`DRIV_IF.wb_cyc        <= 1;
			`DRIV_IF.wb_we         <= 1;
			`DRIV_IF.wb_sel        <= 4'b1111;
	    	`DRIV_IF.wb_addr       <= Address[31:2]+i;
	    	`DRIV_IF.wb_dati       <= $random & 32'hFFFFFFFF;
	    	data_mlbx = `DRIV_IF.wb_dati;
	      	score_data.put(data_mlbx);

	     	do begin
	        	@ (posedge mem_vif.DRIVER.wb_clk);
	      	end while(`DRIV_IF.wb_ack == 1'b0);
	        	@ (negedge mem_vif.DRIVER.wb_clk);
	   
	       $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,`DRIV_IF.wb_addr,`DRIV_IF.wb_dati);
	   	end
		`DRIV_IF.wb_stb	 <= 0;
		`DRIV_IF.wb_cyc	 <= 0;
		`DRIV_IF.wb_we	 <= 'hx;
		`DRIV_IF.wb_sel	 <= 'hx;
		`DRIV_IF.wb_addr <= 'hx;
		`DRIV_IF.wb_dati <= 'hx;
	end
endtask

  //
//endtask
endclass : driver