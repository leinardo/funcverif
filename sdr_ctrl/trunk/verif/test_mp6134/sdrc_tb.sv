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
`include "test.sv"
`include "interface_sdrc.sv"

module sdrc_tb;

parameter P_SYS  = 10;     //    200MHz
parameter P_SDR  = 20;     //    100MHz

reg   sdram_clk;
reg   sys_clk;

initial sys_clk = 0;
initial sdram_clk = 0;

always #(P_SYS/2) sys_clk = !sys_clk;
always #(P_SDR/2) sdram_clk = !sdram_clk;
interface_sdrc intf(10, 00, /*RESETN,*/ sys_clk, sdram_clk/*, RESETN*/);
//reg		RESETN;

wire	sdr_init_done;		// SDRAM Init Done 

wire  sdr_cs_n;
wire  sdr_cke;
wire  sdr_ras_n;
wire  sdr_cas_n;
wire  sdr_we_n;
wire  sdr_dqm;
wire  sdr_ba;
wire  [11:0] sdr_addr;
wire  [intf.SDR_DW-1:0] sdr_dq;



//clock generation
//  always #5 clk = ~clk;
  
//reset Generation
/*	initial begin
    reset = 1;
    #5 reset =0;
  end*/



//Instancia de la prueba

//`include "test.sv"

test t1(intf);

sdrc_top #(.SDR_DW(16),.SDR_BW(1)) UUV (
		.cfg_sdr_width(intf.cfg_sdr_width),
        .cfg_colbits(intf.cfg_colbits),
        // WB bus
        .wb_rst_i(!intf.wb_rst),
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
        //.sdram_resetn(intf.sdram_resetn),
        .sdram_resetn(intf.wb_rst),
        .sdr_cs_n(sdr_cs_n),
        .sdr_cke(sdr_cke),
        .sdr_ras_n(sdr_ras_n),
        .sdr_cas_n(sdr_cas_n),
        .sdr_we_n(sdr_we_n),
        .sdr_dqm(sdr_dqm),
        .sdr_ba(sdr_ba),
        .sdr_addr(sdr_addr),
        .sdr_dq(sdr_dq),
		/* Parameters */

        .sdr_init_done(sdr_init_done),
        .cfg_req_depth(2'h3),	        //how many req. buffer should hold
        .cfg_sdr_en(1'b1),
        .cfg_sdr_mode_reg(13'h033),
        .cfg_sdr_tras_d(4'h4),
        .cfg_sdr_trp_d(4'h2),
        .cfg_sdr_trcd_d(4'h2),
        .cfg_sdr_cas(3'h3),
        .cfg_sdr_trcar_d(4'h7),
        .cfg_sdr_twr_d(4'h1),
        .cfg_sdr_rfsh(12'h100), 		// reduced from 12'hC35
        .cfg_sdr_rfmax(3'h6)
        );

// Instancia de la memoria 

mt48lc8m8a2 #(.data_bits(16)) u_sdram8 (
          .Dq(sdr_dq), 
          .Addr(sdr_addr), 
          .Ba(sdr_ba), 
          .Clk(sdram_clk), 
          .Cke(sdr_cke), 
          .Cs_n(sdr_cs_n), 
          .Ras_n(sdr_ras_n), 
          .Cas_n(sdr_cas_n), 
          .We_n(sdr_we_n), 
          .Dqm(sdr_dqm)
     );
endmodule // sdrc_tb