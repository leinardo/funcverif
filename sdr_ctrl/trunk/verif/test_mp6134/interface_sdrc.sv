//////////////////////////////////////////////////////////////////////////////////
// Company:				  ITCR
// Engineers:			  Sergio Arriola
//						      Reinaldo Castro
//						      Jaime Mora
//						      Javier Pérez 
// 						
// Create Date:    	03/03/2017 
// Design Name: 		Testing Enviroment SDRAM Controler 
// Module Name:			Interface 
// Project Name: 		SDRAM Controler
// Target Devices:	None
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

interface interface_sdrc(input logic [1:0] cfg_sdr_width, cfg_colbits, input logic /*wb_rst,*/ wb_clk, sdram_clk/*, sdram_resetn*/);
  // Global Variables

	//-----------
	// Parameters
	//-----------
	parameter APP_AW   = 26;  // Application Address Width
	parameter APP_DW   = 32;  // Application Data Width 
	parameter APP_BW   = 4;   // Application Byte Width
	parameter APP_RW   = 9;   // Application Request Width
	`ifdef SDR_32BIT
	parameter SDR_DW   = 32;  // SDR Data Width 
	`elsif SDR_16BIT 
	parameter SDR_DW   = 16;  // SDR Data Width 
	`else
	parameter SDR_DW   = 8;  // SDR Data Width 
	`endif
	parameter SDR_BW   = 2;   // SDR Byte Width         
	parameter dw       = 32;  // data width


	//--------------------------------------
	// Declaring Signals Wish Bone Interface
	//--------------------------------------
  logic	              wb_stb;
  logic	              wb_ack;
  logic [APP_AW-1:0] 	wb_addr;
  logic	              wb_we;
  logic [dw-1:0] 		  wb_dati;
  logic [dw/8-1:0] 	  wb_sel;
  logic [dw-1:0] 		  wb_dato;
  logic	              wb_cyc;
  logic [2:0]			    wb_cti; 
  logic               wb_rst;

	//----------------
	// Clocking Blocks
	//----------------

	// Driver
	clocking driver_cb @(posedge wb_clk);
		default input #1 output #1;
		output	wb_stb;
		output 	wb_cyc;
		output 	wb_we;
		output 	wb_sel;
		inout 	wb_addr;
   	inout   wb_dati;
    input   wb_ack;
   endclocking

  // Monitor
  clocking monitor_cb @(posedge wb_clk or negedge sdram_clk);
  	default input #1 output #1;
    output	wb_stb;
    output 	wb_cyc;
    output 	wb_we;
    inout 	wb_addr; 
    inout 	wb_dato; //output
    input   wb_ack;
  endclocking

	//----------
  // Modports
  //----------

  // Driver modport
  modport DRIVER (clocking driver_cb, input wb_rst, input wb_clk);

  // Monitor modport
  modport MONITOR (clocking monitor_cb, input wb_rst, input wb_clk, input sdram_clk);


endinterface
