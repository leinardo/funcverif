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
`include "environment2.sv"
program test(interface_sdrc intf);
	//genvar env;
	environment2 env2;
	int k;
	reg [31:0] StartAddr;
	
	initial begin
    //creating environment
    env2 = new(intf);
    env2.driv2.reset();
    wait(UUV.sdr_init_done == 1);
    //var = 1;
    //#100000 var=0;

    #1000;
	$display("-------------------------------------- ");
	$display(" Case-1: Single Write/Read Case        ");
	$display("-------------------------------------- ");

	env2.driv2.burst_write(1,32'h0005_0000,32'h0005_0002);  
	#1000;
	env2.mon.burst_read();  

	// Repeat one more time to analysis the 
	// SDRAM state change for same col/row address
	$display("-------------------------------------- ");
	$display(" Case-2: Repeat same transfer once again ");
	$display("----------------------------------------");
	env2.driv2.burst_write(1,32'h0005_0000,32'h0005_0002);  
	env2.mon.burst_read();  
	env2.driv2.burst_write(1,32'h0005_0000,32'h0005_0002);  
	env2.mon.burst_read();  
	$display("----------------------------------------");
	$display(" Case-3 Create a Page Cross Over        ");
	$display("----------------------------------------");
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.driv2.burst_write(2,1,1);  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  

	$display("----------------------------------------");
	$display(" Case:4 4 Write & 4 Read                ");
	$display("----------------------------------------");
	env2.driv2.burst_write(0,32'h4_0200,8'h4);  
 	env2.driv2.burst_write(0,32'h5_0400,8'h5);  
 	env2.driv2.burst_write(0,32'h6_0500,8'h6);  
 	env2.driv2.burst_write(0,32'h7_0700,8'h7);
 	env2.driv2.burst_write(0,32'h4_0900,8'h4);  
 	env2.driv2.burst_write(0,32'h5_0A00,8'h5);  
 	env2.driv2.burst_write(0,32'h6_0B37,8'h6);  
 	env2.driv2.burst_write(0,32'h7_0E68,8'h7);
 	env2.driv2.burst_write(0,32'h6_0FF2,8'h6);  
 	env2.driv2.burst_write(0,32'h7_0100,8'h7);
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
 

	$display("---------------------------------------");
	$display(" Case:5 24 Write & 24 Read With Different Bank and Row ");
	$display("---------------------------------------");
	//----------------------------------------
	// Address Decodeing:
	//  with cfg_col bit configured as: 00
	//    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
	//
	env2.driv2.burst_write(3,12'h000,2'b00);   // Row: 0 Bank : 0
	env2.driv2.burst_write(3,12'h000,2'b01);   // Row: 0 Bank : 1
	env2.driv2.burst_write(3,12'h000,2'b10);   // Row: 0 Bank : 2
	env2.driv2.burst_write(3,12'h000,2'b11);   // Row: 0 Bank : 3
	env2.driv2.burst_write(3,12'h001,2'b00);   // Row: 1 Bank : 0
	env2.driv2.burst_write(3,12'h001,2'b01);   // Row: 1 Bank : 1
	env2.driv2.burst_write(3,12'h001,2'b10);   // Row: 1 Bank : 2
	env2.driv2.burst_write(3,12'h001,2'b11);   // Row: 1 Bank : 3
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.driv2.burst_write(3,12'h010,2'b00);   // Row: 2 Bank : 0
	env2.driv2.burst_write(3,12'h010,2'b01);   // Row: 2 Bank : 1
	env2.driv2.burst_write(3,12'h010,2'b10);   // Row: 2 Bank : 2
	env2.driv2.burst_write(3,12'h010,2'b11);   // Row: 2 Bank : 3
	env2.driv2.burst_write(3,12'h011,2'b00);   // Row: 3 Bank : 0
	env2.driv2.burst_write(3,12'h011,2'b01);   // Row: 3 Bank : 1
	env2.driv2.burst_write(3,12'h011,2'b10);   // Row: 3 Bank : 2
	env2.driv2.burst_write(3,12'h011,2'b11);   // Row: 3 Bank : 3

	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.driv2.burst_write(3,12'h001,2'b11);   // Row: 2 Bank : 0
	env2.driv2.burst_write(3,12'h001,2'b10);   // Row: 2 Bank : 1
	env2.driv2.burst_write(3,12'h001,2'b01);   // Row: 2 Bank : 2
	env2.driv2.burst_write(3,12'h001,2'b00);   // Row: 2 Bank : 3
	env2.driv2.burst_write(3,12'h000,2'b11);   // Row: 3 Bank : 0
	env2.driv2.burst_write(3,12'h000,2'b10);   // Row: 3 Bank : 1
	env2.driv2.burst_write(3,12'h000,2'b01);   // Row: 3 Bank : 2
	env2.driv2.burst_write(3,12'h000,2'b00);   // Row: 3 Bank : 3

	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read();  
	env2.mon.burst_read(); 
	
	$display("---------------------------------------------------");
	$display(" Case: 6 Bank");
	$display("---------------------------------------------------");
	for(k=0; k < 5; k++) begin
		env2.driv2.burst_write(4,1,2'b00);  
		env2.mon.burst_read();
		 #100;  
		env2.driv2.burst_write(4,1,2'b01);  
		env2.mon.burst_read();
		 #100; 
		env2.driv2.burst_write(4,1,2'b10);  
		env2.mon.burst_read();
		 #100;  
		env2.driv2.burst_write(4,1,2'b11);  
		env2.mon.burst_read(); 
	end 


	$display("---------------------------------------------------");
	$display(" Case: 7 column");
	$display("---------------------------------------------------");

	for(k=0; k < 5; k++) begin
		env2.driv2.burst_write(5,1,1);  
		env2.mon.burst_read();
		 #100;  
		 env2.driv2.burst_write(5,1,2);  
		env2.mon.burst_read();
		 #100; 
		 env2.driv2.burst_write(5,1,3);  
		env2.mon.burst_read();
		 #100; 
		 env2.driv2.burst_write(5,1,4);  
		env2.mon.burst_read();
		 #100; 
		 env2.driv2.burst_write(5,1,5);  
		env2.mon.burst_read();
		 #100; 
		 env2.driv2.burst_write(5,1,6);  
		env2.mon.burst_read();
		 #100; 
		 env2.driv2.burst_write(5,1,7);  
		env2.mon.burst_read();
		 #100; 
		 env2.driv2.burst_write(5,1,8);  
		env2.mon.burst_read();
		 #100; 
	end 
	
/*	`ifdef SDR_32BIT
	$display("---------------------------------------------------");
	$display(" Case: 8 CAS LATENCY");
	$display("---------------------------------------------------");
		
        sdrc_tb.variable=3'h2;
        env2.driv2.reset();
    	wait(UUV.sdr_init_done == 1);
    	repeat (20) begin 
	    	env2.driv2.burst_write(3,12'h000,2'b00);   // Row: 0 Bank : 0
			env2.driv2.burst_write(3,12'h000,2'b01);   // Row: 0 Bank : 1
			env2.driv2.burst_write(3,12'h000,2'b10);   // Row: 0 Bank : 2
			env2.driv2.burst_write(3,12'h000,2'b11);   // Row: 0 Bank : 3
			env2.driv2.burst_write(3,12'h001,2'b00);   // Row: 1 Bank : 0
			env2.driv2.burst_write(3,12'h001,2'b01);   // Row: 1 Bank : 1
			env2.driv2.burst_write(3,12'h001,2'b10);   // Row: 1 Bank : 2
			env2.driv2.burst_write(3,12'h001,2'b11);   // Row: 1 Bank : 3
			env2.mon.burst_read();  
			env2.mon.burst_read();  
			env2.mon.burst_read();  
			env2.mon.burst_read();  
			env2.mon.burst_read();  
			env2.mon.burst_read();  
			env2.mon.burst_read();  
			env2.mon.burst_read();
		end
	`endif*/
		

		#10000;
		env2.mon.error_report();

	    $finish;
	end
endprogram