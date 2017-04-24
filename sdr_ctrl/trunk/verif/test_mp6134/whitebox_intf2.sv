//////////////////////////////////////////////////////////////////////////////////
// Company:				ITCR
// Engineers:			Sergio Arriola
//						Reinaldo Castro
//						Jaime Mora
//						Javier Pérez 
// 						
// Create Date:			23/03/2017 
// Design Name: 		Test Bench Enviroment SDRAM Controler 
// Module Name:			WhiteBox Interface
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
//////////////////////////////////////////////////////////////////////////////////
`define TOP_PATH sdrc_tb.UUV

`define s_precharge (!ras && !cs && we && cas)
`define s_autorefresh (!ras && !cas && !cs && we)
`define s_NOP (ras && !cs && we && cas)
`define latencia (!ras && !cas && !cs && !we)





interface whitebox_intf;

// Variables	
	logic clock;
	logic reset;
	logic strobe;
	logic cycle;
	logic ackowledge;

	logic ras; 
	logic cas; 
	logic cs; 
	logic we;
	logic sdram_init_done;

	assign clock		= `TOP_PATH.wb_clk_i;
	assign reset		= `TOP_PATH.wb_rst_i;
	assign strobe		= `TOP_PATH.wb_stb_i;
	assign cycle		= `TOP_PATH.wb_cyc_i;
	assign ackowledge	= `TOP_PATH.wb_ack_o;
	assign address		= `TOP_PATH.wb_addr_i;
	assign data		= `TOP_PATH.wb_dat_o;
	assign selector 	= `TOP_PATH.wb_sel_i;
	assign we_w	 	= `TOP_PATH.wb_we_i;

	assign ras 			= `TOP_PATH.sdr_ras_n;
	assign cas 			= `TOP_PATH.sdr_cas_n;
	assign cs 			= `TOP_PATH.sdr_cs_n;
	assign we 			= `TOP_PATH.sdr_we_n;
	assign sdram_init_done		= `TOP_PATH.sdr_init_done;

	covergroup wishbone_group @ (posedge clock);
		s_precharge_point : coverpoint `s_precharge {
			bins s_p_no_acerto = {0};
			bins s_p_acerto    = {1};
		}
		s_autorefresh_point : coverpoint `s_autorefresh{
			bins s_a_no_acerto = {0};
			bins s_a_acerto    = {1}; 

		}
		s_NOP_point : coverpoint `s_NOP {
			bins s_N_no_acerto = {0};
			bins s_N_acerto    = {1};
		}
		latencia_point : coverpoint `latencia{
			bins l_no_acerto = {0};
			bins l_acerto    = {1}; 

		}
	endgroup // wishbone_group

// Aserciones para la inicialización de la SDRAM
	wishbone_group wish_g = new ();

	property sdram_autorefresh;
		@(posedge clock) `s_autorefresh |-> not ## [1:6] `s_autorefresh;
	endproperty

	a_autorefresh: assert property (sdram_autorefresh) else $error("%m: Violation too early autorefresh.");
	c_autorefresh: cover  property (sdram_autorefresh) $display("%m: Autorefresh Pass");

	property sdram_precharge;
		@(posedge clock) `s_precharge |-> not ## [1:2] `s_precharge;
	endproperty

	a_precharge: assert property (sdram_precharge) else $error("%m: Violation precharge fail.");
	c_precharge: cover  property (sdram_precharge) $display("%m: Precharge Pass");

	property sdram_init;
		@(posedge clock) $fell (sdram_init_done) |-> ## 10000  (~sdram_init_done && `s_NOP);
	endproperty

	a_init: assert property (sdram_init) else $error("%m: Violation inicialization time.");
	c_init: cover  property (sdram_init) $display("%m: SDRAM INIT Pass");

	/*property sdram_NOP;
		@(posedge clock) $fell (sdram_init_done) |-> ## 10000 `s_NOP;
	endproperty

	a_NOP: assert property (sdram_NOP) else $error("%m: Violation at NOP command time.");
	c_NOP: cover  property (sdram_NOP) $display("%m: SRAM NOP Pass");*/

// Aserciones para las reglas del protocolo wishbone

// 3.00: Todas las señales deben inicializarce (adquirir valor igual a cero) luego que el reset sea asertado.
	property reiniciar;
		@(posedge clock) reset |-> ## 1 (cycle == 0 & strobe == 0);
	endproperty

	aResetP: assert property (reiniciar) else $error("%m: Violation of Wishbone Rule_3.00: cyc and stb not reestablished when rst is.");
	cResetP: cover  property (reiniciar) $display("%m: Reiniciar Pass");

// 3.05: La señal de reset debe permanecer en alto por lo menos por un ciclo completo de reloj
	property tim_reset;
		@(posedge clock) reset |-> ##[1:$] (reset == 1);
	endproperty

	aTimeResetP : assert property (tim_reset) else $error("%m Violation of Wishbone Rule_3.05: rst didn't asserted for at leasr one complete clk cicle");
	cTimeResetP: cover  property (tim_reset) $display("%m: Time Reset Pass");

// 3.10: Todas las señales deben de ser capaz de reaccionar al reset en cualquier momento
	property reset_react;
		@(posedge clock) ~strobe |-> ( ackowledge == 0 );
	endproperty
	
	aRstReactP: assert property (reset_react) else $error("%m Violation of Wishbone Rule_3.10: ack didn't react to the rst");
	cRstReactP: cover  property (reset_react) $display("%m: Reset Pass");

// 3.20: El reset sincronico responde si RST_O es acertado en el siguiente clock
	property sync_reset;
		@(posedge clock) reset |=> (!cycle && !strobe);
	endproperty
	
	aRstBus: assert property (sync_reset) else $error("%m Violation of Wishbone Rule_3.20: bus not initialize upon reset");
	cRstBus: cover  property (sync_reset) $display("%m: Sync reset Pass");

// Verify cycle with rsp

	property cyc_when_rsp;
		@(posedge clock) ackowledge |-> (cycle && strobe);
	endproperty
	
	aCycRsP: assert property (cyc_when_rsp) else $error("%m Error in Cyc_RsP");
	cCycRsP: cover  property (cyc_when_rsp) $display("%m: Cycle with Rsp Pass");

// 3.25: La señal CYC debe asertarce siempre que STB sea asertada.
	property cyc_stb;
		@(posedge clock) strobe |-> cycle;
	endproperty

	aCSP: assert property (cyc_stb) else $error("%m: Violation of Wishbone Rule_3.25: cyc not asserted when stb is.");
	cCSP: cover  property (cyc_stb) $display("%m: Asser CYC and STB Pass");

// 3.35: La señal ACK no debe responder a menos que CYC and STB hayan sido asertadas
	property ack_cyc_stb;
		@(posedge clock)  ackowledge |-> (cycle & strobe);
	endproperty

	aACSP: assert property (ack_cyc_stb) else $error("%m: Violation of Wishbone Rule_3.35: slave responding outside cycle.");
	cACSP: cover  property (ack_cyc_stb) $display("%m: ACK.CYC amd STB Pass");

// 3.45 

// Asercion para la programabilidad de la latencia del CAS
	
	property laten_cas;
		@(posedge clock) `latencia |-> ## 1 (`TOP_PATH.cfg_sdr_cas == `TOP_PATH.u_sdrc_core.u_xfr_ctl.mgmt_addr[6:4]);
	endproperty

	aLATCAS: assert property (laten_cas) else $error("%m: CAS latency has not been programmed!.");
	cLATCAS: cover  property (laten_cas) $display("%m: Programmable CAS pass");

// Asercion para validar el autorefresh


// Asercion para validar que las señales del master cyc_o y stb_o no sean X o Z (Revisar)

//	property cyc_std_notxz;
//		@(posedge clock) $isunknown({cycle, strobe}) == 0;
//	endproperty

//	aCYC_STD_NOTXZ: assert property (cyc_std_notxz) else $error("%m: Cycle or Strobe is not defined");

// Asercion para validar que las señales de otros masters no sean X o Z (Revisar)

//	property master_notxz;
//		@(posedge clock) strobe |-> $isunknown({address,data,selector,we_w}) == 0;
//	endproperty

//	aMASTER_NOTXZ: assert property (master_notxz) else $error("%m: Master signals is not defined");




endinterface

