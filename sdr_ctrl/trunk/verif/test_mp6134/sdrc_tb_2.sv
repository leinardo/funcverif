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
`include "clk.sv"
`include "whitebox_intf.sv"
module sdrc_tb;

parameter ram_32 = 2'b00;
parameter ram_16 = 2'b01;
parameter ram_8  = 2'b10;

wire   sdram_clk;
wire   sys_clk;

clk #(.P_SYS(10), .P_SDR(20)) clock(sys_clk, sdram_clk);

`ifdef SDR_32BIT
  interface_sdrc intf(ram_32, 2'b00, sys_clk, sdram_clk);
`elsif SDR_16BIT
  interface_sdrc intf(ram_16, 2'b00, sys_clk, sdram_clk);
`else  // 8 BIT SDRAM
  interface_sdrc intf(ram_8, 2'b00, sys_clk, sdram_clk);
`endif

whitebox_intf whiteb_intf();

wire	sdr_init_done;		// SDRAM Init Done 

wire  sdr_cs_n;
wire  sdr_cke;
wire  sdr_ras_n;
wire  sdr_cas_n;
wire  sdr_we_n;
wire  sdr_dqm;
wire  [1:0] sdr_ba;
wire  [12:0] sdr_addr;
wire  [intf.SDR_DW-1:0] dq;

wire #(2.0) sdram_clk_d   = sdram_clk;

//Instancia de la prueba

test t1(intf);

`ifdef SDR_32BIT
   sdrc_top #(.SDR_DW(32),.SDR_BW(4)) UUV(
`elsif SDR_16BIT 
   sdrc_top #(.SDR_DW(16),.SDR_BW(2)) UUV(
`else  // 8 BIT SDRAM
   sdrc_top #(.SDR_DW(8),.SDR_BW(1)) UUV(
`endif
    // System 
        .cfg_sdr_width  (intf.cfg_sdr_width),
        .cfg_colbits    (intf.cfg_colbits), // 8 Bit Column Address
  
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
        .sdram_clk(sdram_clk),
        .sdram_resetn(intf.wb_rst),
        .sdr_cs_n(sdr_cs_n),
        .sdr_cke(sdr_cke),
        .sdr_ras_n(sdr_ras_n),
        .sdr_cas_n(sdr_cas_n),
        .sdr_we_n(sdr_we_n),
        .sdr_dqm(sdr_dqm),
        .sdr_ba(sdr_ba),
        .sdr_addr(sdr_addr),
        .sdr_dq(dq),
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
`ifdef SDR_32BIT
  mt48lc2m32b2 u_sdram32 (
          .DQ31(dq[31]), .DQ30(dq[30]), .DQ29(dq[29]), .DQ28(dq[28]), .DQ27(dq[27]), .DQ26(dq[26]),
          .DQ25(dq[25]), .DQ24(dq[24]), .DQ23(dq[23]), .DQ22(dq[22]), .DQ21(dq[21]), .DQ20(dq[20]),
          .DQ19(dq[19]), .DQ18(dq[18]), .DQ17(dq[17]), .DQ16(dq[16]), .DQ15(dq[15]), .DQ14(dq[14]),
          .DQ14(dq[14]), .DQ13(dq[13]), .DQ12(dq[12]), .DQ11(dq[10]), .DQ10(dq[10]), .DQ9(dq[9]),
          .DQ8(dq[9]), .DQ7(dq[8]), .DQ6(dq[6]), .DQ5(dq[5]), .DQ4(dq[4]), .DQ3(dq[3]), .DQ2(dq[2]),
          .DQ1(dq[1]), .DQ0(dq[0]), 
          .A11(sdr_addr[11]), .A10(sdr_addr[10]), .A9(sdr_addr[9]), .A8(sdr_addr[8]), .A7(sdr_addr[7]),
          .A6(sdr_addr[6]), .A5(sdr_addr[5]), .A4(sdr_addr[4]), .A3(sdr_addr[3]), .A2(sdr_addr[2]),
          .A1(sdr_addr[1]), .A0(sdr_addr[0]),  
          .BA0(sdr_ba[0]), 
          .BA1(sdr_ba[1]),
          .CLK(sdram_clk_d), 
          .CKE(sdr_cke), 
          .Cs_n(sdr_cs_n), 
          .RASNeg(sdr_ras_n), 
          .CASNeg(sdr_cas_n), 
          .WENeg(sdr_we_n), 
          .DQM3(sdr_dqm[3]),
          .DQM2(sdr_dqm[2]),
          .DQM1(sdr_dqm[1]),
          .DQM0(sdr_dqm[0])
     );

`elsif SDR_16BIT

  IS42VM16400K u_sdram16 (
          .dq(dq), 
          .addr(sdr_addr[11:0]), 
          .ba(sdr_ba), 
          .clk(sdram_clk_d), 
          .cke(sdr_cke), 
          .csb(sdr_cs_n), 
          .rasb(sdr_ras_n), 
          .casb(sdr_cas_n), 
          .web(sdr_we_n), 
          .dqm(sdr_dqm)
    );
`else 
  mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
            .Dq(dq), 
            .Addr(sdr_addr[11:0]), 
            .Ba(sdr_ba), 
            .Clk(sdram_clk_d), 
            .Cke(sdr_cke), 
            .Cs_n(sdr_cs_n), 
            .Ras_n(sdr_ras_n), 
            .Cas_n(sdr_cas_n), 
            .We_n(sdr_we_n), 
            .Dqm(sdr_dqm)
       );

`endif
endmodule // sdrc_tb