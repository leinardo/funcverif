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
class driver2;

//Creando la interfaz virtual para el manejo de memoria
virtual interface_sdrc mem_vif;

scoreboard score;
estimulo1 estim1;
estimulo2 estim2;
estimulo3 estim3;

covergroup driver_group @ (posedge mem_vif.wb_clk);
		Direcciones : coverpoint  `DRIV_IF.wb_addr [11:0] {
			bins addr_cero    = {12'h000,12'h199};
    		bins addr_uno     = {12'h19A,12'h333};
 	   		bins addr_dos     = {12'h334,12'h4CD};
 	   		bins addr_tres    = {12'h4CE,12'h667};
    		bins addr_cuatro  = {12'H668,12'h801};
 	   		bins addr_cinco   = {12'h802,12'h99B};
			bins addr_seis    = {12'h99C,12'hB35};
    		bins addr_siete   = {12'hB36,12'hCCF};
 	   		bins addr_ocho    = {12'hCD0,12'hE69};
			bins addr_nueve   = {12'hE6A,12'hFFF};
		}
		
	endgroup // driver_group
    

//constructor
function new(virtual interface_sdrc mem_vif,scoreboard score, estimulo1 estim1, estimulo2 estim2, estimulo3 estim3);
    //get the interface from test
    this.mem_vif = mem_vif;
    this.score = score;
    this.estim1 = estim1;
    this.estim2 = estim2;
    this.estim3 = estim3;
    this.driver_group = new ();
endfunction : new


//funciones y tareas
task reset;
    $display("--------- [DRIVER] Reset Started ---------");
	// Applying reset
	`DRIV_IF.wb_stb		<= 0;
	`DRIV_IF.wb_cyc		<= 0;
	`DRIV_IF.wb_we		<= 0;
	`DRIV_IF.wb_sel		<= 4'h0;
	`DRIV_IF.wb_addr	<= 0;
   	`DRIV_IF.wb_dati	<= 0;
	mem_vif.wb_rst <= 1;
	#100 mem_vif.wb_rst <= 0;
	
   	#10000
   	mem_vif.wb_rst 	<= 1;   
   	#1000
    $display("--------- [DRIVER] Reset Ended ---------");
endtask

task burst_write(int Sel_Estimulo, bit [31:0] parametro1, parametro2);
	reg [31:0] Address;
	reg [7:0] bl;
	int i;

	begin
		if(Sel_Estimulo == 0) begin
			Address = parametro1;
			bl = parametro2[1:0];
			$display("++++++++++++++______ Address: %x  Bl: %x  ",Address,bl);


		end
		if (Sel_Estimulo == 1) begin
			estim1 = new();
			estim1.parametro1 = parametro1;
			estim1.parametro2 = parametro2;
			estim1.randomize();
			Address = estim1.Addr_write;
			bl = estim1.bl;
			$display("*++++*++*+**+*+*+*+______ Address: %x  Bl: %x  ",Address,bl);

		end
		if (Sel_Estimulo == 2)begin
			estim2.randomize();
			Address = estim2.Addr_write;
			bl = 4096 - Address[11:0];
			$display("BBBB-Valor bl: %x",bl);
			$display("AAAAAAAAAAAAA______ Address: %x  Bl: %x  ",Address,bl);


		end
		if(Sel_Estimulo == 3) begin
			estim3 = new();
			//estim3.row = parametro1 [11:0];
			//estim3.bank = parametro2 [1:0];
			estim3.randomize();
			Address = {parametro1[11:0],parametro2[1:0], estim3.colum, estim3.cfg_col};
			bl = estim3.bl;
			$display("============______ Address: %x  Bl: %x  ",Address,bl);


		end
			

		score.bl_fifo.push_back(bl);
		score.address_fifo.push_back(Address);
	   @ (negedge mem_vif.DRIVER.wb_clk);
		//$display("Write Address: %x, Burst Size: %d",Address,bl);

		for(i=0; i < bl; i++) begin
	    	`DRIV_IF.wb_stb        <= 1;
	    	`DRIV_IF.wb_cyc        <= 1;
			`DRIV_IF.wb_sel        <= 4'b1111;
	    	`DRIV_IF.wb_addr       <= Address[31:2]+i;
	    	`DRIV_IF.wb_dati       <= $random & 32'hFFFFFFFF;
	    	`DRIV_IF.wb_we         <= 1;
			
	     	do begin
	        	@ (posedge mem_vif.DRIVER.wb_clk);
	      	end while(`DRIV_IF.wb_ack == 1'b0);
	        	@ (negedge mem_vif.DRIVER.wb_clk);
	   		@(posedge mem_vif.DRIVER.wb_clk);
	   		score.data_fifo.push_back(`DRIV_IF.wb_dati);
			//$display("Dato que se va a guardar en la cola: %x",`DRIV_IF.wb_dati);
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

endclass : driver2
