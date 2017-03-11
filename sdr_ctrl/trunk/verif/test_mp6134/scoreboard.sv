//////////////////////////////////////////////////////////////////////////////////
// Company:				ITCR
// Engineers:			Sergio Arriola
//						Reinaldo Castro
//						Jaime Mora
//						Javier Pérez 
// 						
// Create Date:			03/03/2017 
// Design Name: 		Test Bench Enviroment SDRAM Controler 
// Module Name:			scoreboard
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

class scoreboard; 

//-------------------------------
// data/address/burst length FIFO
//-------------------------------
/*
static int dfifo[$]; // data fifo
static int afifo[$]; // address  fifo
static int bfifo[$]; // Burst Length fifo
*/
int af;
int df;
int bf;

mailbox drive2score;
mailbox score2monitor;

function new(mailbox drive2score,mailbox score2monitor);
	this.drive2score = drive2score;
	this.score2monitor = score2monitor;
endfunction : new

task run;
	begin
	drive2score.get(af);
	drive2score.get(bf);
	drive2score.get(df);
	score2monitor.put(af);
	score2monitor.put(bf);
	score2monitor.put(df);
	end
endtask : run


endclass