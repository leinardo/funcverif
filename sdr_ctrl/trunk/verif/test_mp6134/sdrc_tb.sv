//////////////////////////////////////////////////////////////////////////////////
// Company:				ITCR
// Engineers:			Sergio Arriola
//						Reinaldo Castro
//						Jaime Mora
//						Javier Pérez 
// 						
// Create Date:			03/03/2017 
// Design Name: 		Test Bench Enviroment SDRAM Controler 
// Module Name:			sdrc_tb
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

`include "interface_sdrc.sv"
//`include "test.sv"

module sdrc_tb;

parameter P_SYS  = 10;     //    200MHz
parameter P_SDR  = 20;     //    100MHz

reg		RESETN;
reg		sdram_clk;
reg		sys_clk;

initial sys_clk = 0;
initial sdram_clk = 0;

always #(P_SYS/2) sys_clk = !sys_clk;
always #(P_SDR/2) sdram_clk = !sdram_clk;

//clock generation
//  always #5 clk = ~clk;
  
//reset Generation
/*	initial begin
    reset = 1;
    #5 reset =0;
  end*/

interface_sdrc intf(10, 00, RESETN, sys_clk, sdram_clk, RESETN);

//Instancia de la prueba

`include "test.sv"

test t1(intf);

// Instancia de la unidad bajo prueba

sdrc_top UUV (
		.cfg_sdr_width(intf.cfg_sdr_width),
        .cfg_colbits(intf.cfg_colbits),
        // WB bus
        .wb_rst_i(intf.wb_rst),
        .wb_clk_i(intf.wb_clk),
        .wb_stb_i(intf.wb_stb),
        .wb_ack_o(intf.wb_ack),
        .wb_addr_i(intf.wb_addr),
        .wb_we_i(intf.wb_we),
        .wb_dat_i(intf.wb_dati),
        .wb_sel_i(intf.wb_sel),
        .wb_dat_o(intf.wb_dato),
        .wb_cyc_i(intf.wb_cyc),
        .wb_cti_i(intf.wb_cti), 
		// Interface to SDRAMs
        .sdram_clk(intf.sdram_clk),
        .sdram_resetn(intf.sdram_resetn),
        .sdr_cs_n(intf.sdr_cs_n),
        .sdr_cke(intf.sdr_cke),
        .sdr_ras_n(intf.sdr_ras_n),
        .sdr_cas_n(intf.sdr_cas_n),
        .sdr_we_n(intf.sdr_we_n),
        .sdr_dqm(intf.sdr_dqm),
        .sdr_ba(intf.sdr_ba),
        .sdr_addr(intf.sdr_addr),
        .sdr_dq(intf.sdr_dq),
        );

// Instancia de la memoria 

mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
          .Dq(intf.sdr_dq), 
          .Addr(intf.sdr_addr), 
          .Ba(intf.sdr_ba), 
          .Clk(intf.sdram_clk), 
          .Cke(intf.sdr_cke), 
          .Cs_n(intf.sdr_cs_n), 
          .Ras_n(intf.sdr_ras_n), 
          .Cas_n(intf.sdr_cas_n), 
          .We_n(intf.sdr_we_n), 
          .Dqm(intf.sdr_dqm)
     );
endmodule // sdrc_tb