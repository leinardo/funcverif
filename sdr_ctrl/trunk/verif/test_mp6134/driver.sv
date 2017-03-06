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

class driver; //extends  /* base class*/ (

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
endfunction : new

//funciones y tareas
task reset;
    //wait(mem_vif.reset);
    $display("--------- [DRIVER] Reset Started ---------");
	// Applying reset
	//`DRIV_IF.wb_rst			<=0;
	//`DRIV_IF.sdram_resetn	<=0;
	#100
	`DRIV_IF.RESETN 	<= 0;
	`DRIV_IF.wb_stb		<= 0;
	`DRIV_IF.wb_cyc		<= 0;
	`DRIV_IF.wb_we		<= 0;
	`DRIV_IF.wb_sel		<= 0;
	`DRIV_IF.wb_addr	<= 0;
   	`DRIV_IF.wb_dati	<= 0;
   	#1000
   	`DRIV_IF.RESETN 	<= 1;        
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
	begin
		mem_afifo.push_back(Address);
		mem_bfifo.push_back(bl);
	   @ (negedge `DRIV_IF.wb_clk);
		$display("Write Address: %x, Burst Size: %d",Address,bl);

		for(i=0; i < bl; i++) begin
	    	`DRIV_IF.wb_stb        = 1;
	    	`DRIV_IF.wb_cyc        = 1;
			`DRIV_IF.wb_we         = 1;
			`DRIV_IF.wb_sel        = 4'b1111;
	    	`DRIV_IF.wb_addr       = Address[31:2]+i;
	    	`DRIV_IF.wb_dati        = $random & 32'hFFFFFFFF;
	      	mem_dfifo.push_back(`DRIV_IF.wb_dati);

	     	do begin
	        	@ (posedge`DRIV_IF.wb_clk);
	      	end while(`DRIV_IF.wb_ack == 1'b0);
	        	@ (negedge `DRIV_IF.wb_clk);
	   
	       $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,`DRIV_IF.wb_addr,`DRIV_IF.wb_dati);
	   	end
		`DRIV_IF.wb_stb	 = 0;
		`DRIV_IF.wb_cyc	 = 0;
		`DRIV_IF.wb_we	 = 'hx;
		`DRIV_IF.wb_sel	 = 'hx;
		`DRIV_IF.wb_addr = 'hx;
		`DRIV_IF.wb_dati = 'hx;
	end
endtask

  //
task main(input [31:0] Address, input [7:0] bl);
	forever begin
	  fork
	    //Thread-1: Ejecuta un reset
	    begin
	      reset();
	    end
	    //Thread-2: Llama a la terea burst write.
	    begin
	      forever
	        burst_write(Address, bl);
	    end
	  join_any
	  disable fork;
	end
endtask
endclass : driver