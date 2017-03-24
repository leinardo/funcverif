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

	assign ras 			= `TOP_PATH.sdr_ras_n;
	assign cas 			= `TOP_PATH.sdr_cas_n;
	assign cs 			= `TOP_PATH.sdr_cs_n;
	assign we 			= `TOP_PATH.sdr_we_n;
	assign sdram_init_done			= `TOP_PATH.sdr_init_done;


// Aserciones para la inicialización de la SDRAM

	property sdram_autorefresh;
		@(posedge clock) `s_autorefresh |-> not ## [1:6] `s_autorefresh;
	endproperty

	a_autorefresh: assert property (sdram_autorefresh) else $error("%m: Violation too early autorefresh.");


	property sdram_precharge;
		@(posedge clock) `s_precharge |-> not ## [1:2] `s_precharge;
	endproperty

	a_precharge: assert property (sdram_precharge) else $error("%m: Violation precharge fail.");

	property sdram_init;
		@(posedge clock) $fell (sdram_init_done) |-> ## 10000  (~sdram_init_done);
	endproperty

	a_init: assert property (sdram_init) else $error("%m: Violation inicialization time.");

	property sdram_NOP;
		@(posedge clock) $fell (sdram_init_done) |-> ## 10000 `s_NOP;
	endproperty

	a_NOP: assert property (sdram_NOP) else $error("%m: Violation at NOP command time.");


// Aserciones para las reglas del protocolo wishbone

// 3.00: Todas las señales deben inicializarce (adquirir valor igual a cero) luego que el reset sea asertado.
	property reiniciar;
		@(posedge clock) reset |-> ## 1 (cycle == 0 & strobe == 0);
	endproperty

	aResetP: assert property (reiniciar) else $error("%m: Violation of Wishbone Rule_3.00: cyc and stb not reestablished when rst is.");

// 3.05: La señal de reset debe permanecer en alto por lo menos por un ciclo completo de reloj
	property tim_reset;
		@(posedge clock) reset |-> ##[1:$] (reset == 1);
	endproperty

	aTimeResetP : assert property (tim_reset) else $error("%m Violation of Wishbone Rule_3.05: rst didn't asserted for at leasr one complete clk cicle");

// 3.10: Todas las señales deben de ser capaz de reaccionar al reset en cualquier momento
	property reset_react;
		@(posedge clock) ~strobe |-> ( ackowledge == 0 );
	endproperty
	
	aRstReactP: assert property (reset_react) else $error("%m Violation of Wishbone Rule_3.10: ack didn't react to the rst");

// 3.25: La señal CYC debe asertarce siempre que STB sea asertada.
	property cyc_stb;
		@(posedge clock) strobe |-> cycle;
	endproperty

	aCSP: assert property (cyc_stb) else $error("%m: Violation of Wishbone Rule_3.25: cyc not asserted when stb is.");

// 3.35: La señal ACK no debe responder a menos que CYC and STB hayan sido asertadas
	property ack_cyc_stb;
		@(posedge clock)  ackowledge |-> (cycle & strobe);
	endproperty

	aACSP: assert property (ack_cyc_stb) else $error("%m: Violation of Wishbone Rule_3.35: slave responding outside cycle.");

endinterface

