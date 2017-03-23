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
Parameter TOP_PATH = sdrc_tb.t1
interface whitebox_intf;

// Variables	
	logic clock;
	logic reset;
	logic strobe;
	logic cycle;
	logic ackowledge;

	assign clock		= `TOP_PATH.wb_clk_i;
	assign reset		= `TOP_PATH.wb_rst_i;
	assign strobe		= `TOP_PATH.wb_stb_i;
	assign cycle		= `TOP_PATH.wb_cyc_i;
	assign ackowledge	= `TOP_PATH.wb_ack_o;


// Aserciones para la inicialización de la SDRAM


// Aserciones para las reglas del protocolo wishbone

// 3.00: Todas las señales deben inicializarce (adquirir valor igual a cero) luego que el reset sea asertado.
	property reiniciar;
		@(posedge clock) reset |-> ##[1] (cycle == 0 & strobe == 0);
	endproperty

	aResetP: assert property (reiniciar) else $error("%m: Violation of Wishbone Rule_3.00: cyc and stb not reestablished when rst is.")

// 3.05: La señal de reset debe permanecer en alto por lo menos por un ciclo completo de reloj
	property tim_reset;
		@(posedge clock) reset |-> ##[1:$] (reset == 1);
	endproperty

	aTimeResetP : assert property (tim_reset) else $error("%m Violation of Wishbone Rule_3.05: rst didn't asserted for at leasr one complete clk cicle");

// 3.10: Todas las señales deben de ser capaz de reaccionar al reset en cualquier momento
	
	aRstReactP: assert (~strobe |-> ( ackowledge == 0 )) else $error("%m Violation of Wishbone Rule_3.10: ack did't react to the rst");;

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

