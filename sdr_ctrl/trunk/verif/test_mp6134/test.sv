//////////////////////////////////////////////////////////////////////////////////
// Company:				ITCR
// Engineers:			Sergio Arriola
//						Reinaldo Castro
//						Jaime Mora
//						Javier Pérez 
// 						
// Create Date:    		03/03/2017 
// Design Name: 		Enviroment SDRAM Controler 
// Module Name:			Environment 
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

`include "environment.sv"
program test(interface_sdrc intf);
	//genvar env;
	environment env;
	int k;
	reg [31:0] StartAddr;
	int fifo_a[$], fifo_b[$], fifo_d[$];
	initial begin
    //creating environment
    env = new(intf, fifo_a, fifo_b, fifo_d);
    env.reinicio();
    #1000;
	$display("-------------------------------------- ");
	$display(" Case-1: Single Write/Read Case        ");
	$display("-------------------------------------- ");

	env.escritura(32'h4_0000,8'h4);  
	#1000;
	env.lectura();  

	// Repeat one more time to analysis the 
	// SDRAM state change for same col/row address
	$display("-------------------------------------- ");
	$display(" Case-2: Repeat same transfer once again ");
	$display("----------------------------------------");
	env.escritura(32'h4_0000,8'h4);  
	env.lectura();  
	env.escritura(32'h0040_0000,8'h5);  
	env.lectura();  
	$display("----------------------------------------");
	$display(" Case-3 Create a Page Cross Over        ");
	$display("----------------------------------------");
	env.escritura(32'h0000_0FF0,8'h8);  
	env.escritura(32'h0001_0FF4,8'hF);  
	env.escritura(32'h0002_0FF8,8'hF);  
	env.escritura(32'h0003_0FFC,8'hF);  
	env.escritura(32'h0004_0FE0,8'hF);  
	env.escritura(32'h0005_0FE4,8'hF);  
	env.escritura(32'h0006_0FE8,8'hF);  
	env.escritura(32'h0007_0FEC,8'hF);  
	env.escritura(32'h0008_0FD0,8'hF);  
	env.escritura(32'h0009_0FD4,8'hF);  
	env.escritura(32'h000A_0FD8,8'hF);  
	env.escritura(32'h000B_0FDC,8'hF);  
	env.escritura(32'h000C_0FC0,8'hF);  
	env.escritura(32'h000D_0FC4,8'hF);  
	env.escritura(32'h000E_0FC8,8'hF);  
	env.escritura(32'h000F_0FCC,8'hF);  
	env.escritura(32'h0010_0FB0,8'hF);  
	env.escritura(32'h0011_0FB4,8'hF);  
	env.escritura(32'h0012_0FB8,8'hF);  
	env.escritura(32'h0013_0FBC,8'hF);  
	env.escritura(32'h0014_0FA0,8'hF);  
	env.escritura(32'h0015_0FA4,8'hF);  
	env.escritura(32'h0016_0FA8,8'hF);  
	env.escritura(32'h0017_0FAC,8'hF);  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  

	$display("----------------------------------------");
	$display(" Case:4 4 Write & 4 Read                ");
	$display("----------------------------------------");
	env.escritura(32'h4_0000,8'h4);  
	env.escritura(32'h5_0000,8'h5);  
	env.escritura(32'h6_0000,8'h6);  
	env.escritura(32'h7_0000,8'h7);  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  

	$display("---------------------------------------");
	$display(" Case:5 24 Write & 24 Read With Different Bank and Row ");
	$display("---------------------------------------");
	//----------------------------------------
	// Address Decodeing:
	//  with cfg_col bit configured as: 00
	//    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
	//
	env.escritura({12'h000,2'b00,8'h00,2'b00},8'h4);   // Row: 0 Bank : 0
	env.escritura({12'h000,2'b01,8'h00,2'b00},8'h5);   // Row: 0 Bank : 1
	env.escritura({12'h000,2'b10,8'h00,2'b00},8'h6);   // Row: 0 Bank : 2
	env.escritura({12'h000,2'b11,8'h00,2'b00},8'h7);   // Row: 0 Bank : 3
	env.escritura({12'h001,2'b00,8'h00,2'b00},8'h4);   // Row: 1 Bank : 0
	env.escritura({12'h001,2'b01,8'h00,2'b00},8'h5);   // Row: 1 Bank : 1
	env.escritura({12'h001,2'b10,8'h00,2'b00},8'h6);   // Row: 1 Bank : 2
	env.escritura({12'h001,2'b11,8'h00,2'b00},8'h7);   // Row: 1 Bank : 3
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.escritura({12'h002,2'b00,8'h00,2'b00},8'h4);   // Row: 2 Bank : 0
	env.escritura({12'h002,2'b01,8'h00,2'b00},8'h5);   // Row: 2 Bank : 1
	env.escritura({12'h002,2'b10,8'h00,2'b00},8'h6);   // Row: 2 Bank : 2
	env.escritura({12'h002,2'b11,8'h00,2'b00},8'h7);   // Row: 2 Bank : 3
	env.escritura({12'h003,2'b00,8'h00,2'b00},8'h4);   // Row: 3 Bank : 0
	env.escritura({12'h003,2'b01,8'h00,2'b00},8'h5);   // Row: 3 Bank : 1
	env.escritura({12'h003,2'b10,8'h00,2'b00},8'h6);   // Row: 3 Bank : 2
	env.escritura({12'h003,2'b11,8'h00,2'b00},8'h7);   // Row: 3 Bank : 3

	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.escritura({12'h002,2'b00,8'h00,2'b00},8'h4);   // Row: 2 Bank : 0
	env.escritura({12'h002,2'b01,8'h01,2'b00},8'h5);   // Row: 2 Bank : 1
	env.escritura({12'h002,2'b10,8'h02,2'b00},8'h6);   // Row: 2 Bank : 2
	env.escritura({12'h002,2'b11,8'h03,2'b00},8'h7);   // Row: 2 Bank : 3
	env.escritura({12'h003,2'b00,8'h04,2'b00},8'h4);   // Row: 3 Bank : 0
	env.escritura({12'h003,2'b01,8'h05,2'b00},8'h5);   // Row: 3 Bank : 1
	env.escritura({12'h003,2'b10,8'h06,2'b00},8'h6);   // Row: 3 Bank : 2
	env.escritura({12'h003,2'b11,8'h07,2'b00},8'h7);   // Row: 3 Bank : 3

	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	env.lectura();  
	$display("---------------------------------------------------");
	$display(" Case: 6 Random 2 write and 2 read random");
	$display("---------------------------------------------------");
	for(k=0; k < 20; k++) begin
	    StartAddr = $random & 32'h003FFFFF;
	    env.escritura(StartAddr,($random & 8'h0f)+1);  
		#100;

	    StartAddr = $random & 32'h003FFFFF;
	    env.escritura(StartAddr,($random & 8'h0f)+1);  
		#100;
	    env.lectura();  
		#100;
	    env.lectura();  
		#100;
	    end

		#10000;

	    $display("###############################");
	    if(env.monitor.ErrCnt == 0)
	        $display("STATUS: SDRAM Write/Read TEST PASSED");
	    else
	        $display("ERROR:  SDRAM Write/Read TEST FAILED");
	        $display("###############################");

	    $finish;
	end

endprogram