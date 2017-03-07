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

interface interface_sdrc (
  // Global Variables
  input logic [1:0] cfg_sdr_width,
  input logic [1:0] cfg_colbits,

  // WB bus
  input logic wb_rst,
  input logic wb_clk,
                    
                
  // Interface to SDRAMs
  input logic	sdram_clk,
  input logic	sdram_resetn);

	//-----------
	// Parameters
	//-----------
	parameter APP_AW   = 26;  // Application Address Width
	parameter APP_DW   = 32;  // Application Data Width 
	parameter APP_BW   = 4;   // Application Byte Width
	parameter APP_RW   = 9;   // Application Request Width
	parameter SDR_DW   = 16;  // SDR Data Width 
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


  //--------------------
	// Interface to SDRAMs
	//--------------------
	logic	              sdr_cke             ; // SDRAM CKE
	logic               sdr_cs_n            ; // SDRAM Chip Select
	logic	              sdr_ras_n           ; // SDRAM ras
	logic	              sdr_cas_n           ; // SDRAM cas
	logic	              sdr_we_n            ; // SDRAM write enable
	logic [SDR_BW-1:0]	sdr_dqm             ; // SDRAM Data Mask
	logic [1:0]			    sdr_ba              ; // SDRAM Bank Enable
	logic [12:0]		    sdr_addr            ; // SDRAM Address
	logic [SDR_DW-1:0]	sdr_dq              ; // SDRA Data Input/output
	
	//----------------
	// Clocking Blocks
	//----------------

	// Driver
	clocking driver_cb @(posedge wb_clk);
		default output #1;
		output	wb_stb;
		output	wb_cyc;
		output	wb_we;
		output	wb_sel;
		output	wb_addr;
   	output	wb_dati;
   endclocking

  // Monitor
  clocking monitor_cb @(posedge wb_clk or negedge sdram_clk);
  	default input #1 output #1;
    output	wb_stb;
    output	wb_cyc;
    output	wb_we;
    output	wb_addr;
    input 	wb_dato;
  endclocking

  // SDRAM Controler
  clocking sdrc_cb @(posedge sdram_clk);
  	default input #1 output #1;
      input	sdr_cs_n;
      input	sdr_cke;
      input	sdr_ras_n;
      input	sdr_cas_n;
      input	sdr_we_n;
      input	sdr_dqm;
      input	sdr_ba;
      input sdr_addr; 
      inout	sdr_dq; 
  	endclocking

   	//----------
   	// Modports
   	//----------

  // Driver modport
  modport DRIVER (clocking driver_cb, input wb_rst, input wb_clk);

  // Monitor modport
  modport MONITOR (clocking monitor_cb, input wb_rst, input wb_clk, input sdram_clk);

  // SDRAM Controller modport
  modport SDRC (clocking sdrc_cb, input sdram_resetn, input sdram_clk);


endinterface