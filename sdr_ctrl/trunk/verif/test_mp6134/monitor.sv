//////////////////////////////////////////////////////////////////////////////////
// Company:				ITCR
// Engineers:			Sergio Arriola
//						Reinaldo Castro
//						Jaime Mora
//						Javier Pérez 
// 						
// Create Date:			03/03/2017 
// Design Name: 		Test Bench Enviroment SDRAM Controler 
// Module Name:			monitor
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

`define MON_IF mem_vif.MONITOR.monitor_cb

class monitor(); //extends  /* base class*/ (

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

task burst_read();
	int i;
	reg [31:0] 	Address;
	reg [7:0]  	bl;
	reg [31:0]  exp_data;
	reg [31:0] 	ErrCnt;
	begin
		Address = mem_afifo.pop_front(); 
		bl      = mem_bfifo.pop_front();
	   @ (negedge `MON_IF.wb_clk);
		
		for(i=0; i < bl; i++) begin
	    	`MON_IF.wb_stb		= 1;
	    	`MON_IF.wb_cyc		= 1;
			`MON_IF.wb_we		= 0;
	    	`MON_IF.wb_addr		= Address[31:2]+i;
	    	exp_data        	= dfifo.pop_front(); // Exptected Read Data

	     	do begin
	        	@ (posedge`MON_IF.wb_clk);
	      	end while(`MON_IF.wb_ack == 1'b0);
	      	if(wb_dato !== exp_data) begin
		             $display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",i,`MON_IF.wb_addr,`MON_IF.wb_dato,exp_data);
		             ErrCnt = ErrCnt+1;
		         end else begin
		             $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",i,`MON_IF.wb_addr,`MON_IF.wb_dato);
			end 
			@ (negedge `MON_IF.sdram_clk);
	   
	   	end
		`MON_IF.wb_stb	 = 0;
		`MON_IF.wb_cyc	 = 0;
		`MON_IF.wb_we	 = 'hx;
		`MON_IF.wb_addr = 'hx;
	end
endtask

  //
task main();
	begin
		forever
		burst_read();
	end
endtask
endclass : monitor