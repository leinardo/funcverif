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
//`include "scoreboard.sv"

class monitor; //extends  /* base class*/ (

	scoreboard score;
	reg [31:0] 	ErrCnt;
	reg 	readings ;
	//Creando la interfaz virtual para el manejo de memoria
	virtual interface_sdrc mem_vif;

//constructor
function new(virtual interface_sdrc mem_vif,scoreboard score);//,mailbox score_address, score_data, score_bl);
    //get the interface from test
    this.mem_vif = mem_vif;
    this.score = score;
    readings = 0;
    ErrCnt = 32'd0;
endfunction : new

//funciones y tareas
task burst_read();
	int i;
	reg [31:0] 	Address;
	reg [7:0]  	bl;
	reg [31:0]  exp_data;

	begin
		$display("*********************************************MONITOR*************************************************");
		$display("*********************************************MONITOR*************************************************");
		$display("*********************************************MONITOR*************************************************");
		Address = score.address_fifo.pop_front(); 
		$display("Address:  %x", Address);
		bl = score.bl_fifo.pop_front();
		$display("bl:  %x", bl);
	   @ (negedge mem_vif.MONITOR.wb_clk);
		
		for(i=0; i < bl; i++) begin
			readings = 1;
	    	`MON_IF.wb_stb		<= 1;
	    	`MON_IF.wb_cyc		<= 1;
			`MON_IF.wb_we		<= 0;
	    	`MON_IF.wb_addr		<= Address[31:2]+i;
	    	
	    	exp_data = score.data_fifo.pop_front(); // Exptected Read Data
	    	$display("exp_data:  %x", exp_data);
	     	do begin
	        	@ (posedge mem_vif.MONITOR.wb_clk);
	      	end while(`MON_IF.wb_ack == 1'b0);
	      	if(`MON_IF.wb_dato !== exp_data) begin
		             $display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",i,`MON_IF.wb_addr,`MON_IF.wb_dato,exp_data);
		             ErrCnt = ErrCnt+1;
		         end else begin
		             $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",i,`MON_IF.wb_addr,`MON_IF.wb_dato);
			end 
			@ (negedge mem_vif.MONITOR.sdram_clk);
	   
	   	end
		`MON_IF.wb_stb	 <= 0;
		`MON_IF.wb_cyc	 <= 0;
		`MON_IF.wb_we	 <= 'hx;
		`MON_IF.wb_addr <= 'hx;
	end
endtask

task error_report();
	$display("###############################");
	if(ErrCnt == 0 && readings == 1)
	    $display("STATUS: SDRAM Write/Read TEST PASSED");
	else
	    $display("ERROR:  SDRAM Write/Read TEST FAILED");
	$display("###############################");
endtask : error_report

endclass : monitor