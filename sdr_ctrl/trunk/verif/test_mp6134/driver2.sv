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
estimulo4 estim4;
estimulo5 estim5;
reg [31:0] Address;

covergroup column_group @ (posedge mem_vif.wb_clk);
		seleccion_column_1 : coverpoint (Address[9:2] <= 31) {
			bins column_1    = {1};

		}
		seleccion_column_2 : coverpoint (Address[9:2] > 31 && Address[9:2] < 64) {
			bins column_2    = {1};

		}
		seleccion_column_3 : coverpoint (Address[9:2] > 63 && Address[9:2] < 96) {
			bins column_3    = {1};

		}
		seleccion_column_4 : coverpoint (Address[9:2] > 95 && Address[9:2] < 128) {
			bins column_4    = {1};

		}
		seleccion_column_5 : coverpoint (Address[9:2] > 127 && Address[9:2] < 160) {
			bins column_5    = {1};

		}
		seleccion_column_6 : coverpoint (Address[9:2] > 159 && Address[9:2] < 192) {
			bins column_6    = {1};

		}
		seleccion_column_7 : coverpoint (Address[9:2] > 191 && Address[9:2] < 224) {
			bins column_7    = {1};

		}
		seleccion_column_8 : coverpoint (Address[9:2] > 223 && Address[9:2] < 256) {
			bins column_8    = {1};

		}		
	endgroup // row_group

covergroup bank_group @ (posedge mem_vif.wb_clk);
		seleccion_banco_1 : coverpoint (Address[11:10] == 2'b00) {
			bins bank_uno    = {1};
		}
		seleccion_banco_2 : coverpoint (Address[11:10] == 2'b01) {
			bins bank_dos    = {1};
		}
		seleccion_banco_3 : coverpoint (Address[11:10] == 2'b10) {
			bins bank_tres    = {1};
		}
		seleccion_banco_4 : coverpoint (Address[11:10] == 2'b11) {
			bins bank_cuatro    = {1};
		}

		
	endgroup // bank_group
    

//constructor
function new(virtual interface_sdrc mem_vif,scoreboard score, estimulo1 estim1, estimulo2 estim2, estimulo3 estim3, estimulo4 estim4, estimulo5 estim5);
    //get the interface from test
    this.mem_vif = mem_vif;
    this.score   = score;
    this.estim1  = estim1;
    this.estim2  = estim2;
    this.estim3  = estim3;
    this.estim4  = estim4;
    this.estim5  = estim5;
    this.bank_group = new ();
    this.column_group = new ();
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
	
	reg [7:0] bl;
	int i;
	reg [7:0] result_estim5_column;

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
		if(Sel_Estimulo == 4) begin
			estim4 = new();
			//estim3.row = parametro1 [11:0];
			//estim3.bank = parametro2 [1:0];
			estim4.randomize();
			Address = {estim4.row,parametro2[1:0], estim4.colum, estim4.cfg_col};
			bl = estim4.bl;
			$display("BBBBBBBBBBBBB______ Address: %x  Bl: %x  ",Address,bl);


		end

		if(Sel_Estimulo == 5) begin
			estim5 = new();
			//estim3.row = parametro1 [11:0];
			//estim3.bank = parametro2 [1:0];
			estim5.randomize();
			if (parametro2 == 1)
			result_estim5_column = estim5.colum1;
			if (parametro2 == 2)
			result_estim5_column = estim5.colum2;
			if (parametro2 == 3)
			result_estim5_column = estim5.colum3;
			if (parametro2 == 4)
			result_estim5_column = estim5.colum4;
			if (parametro2 == 5)
			result_estim5_column = estim5.colum5;
			if (parametro2 == 6)
			result_estim5_column = estim5.colum6;
			if (parametro2 == 7)
			result_estim5_column = estim5.colum7;
			if (parametro2 == 8)
			result_estim5_column = estim5.colum8;


			Address = {estim5.row,estim5.bank, result_estim5_column , estim5.cfg_col};
			bl = estim5.bl;
			$display("CCCCCCCCCCCCC______ Address: %x  Bl: %x  ",Address,bl);


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
