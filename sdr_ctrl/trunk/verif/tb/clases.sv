class environment;

	//propiedades

	//constructor
	function new();
		//
	endfunction

	//funciones y tareas

endclass : environment



class driver;

	//propiedades

	//constructor
	function new();
		//
	endfunction

	//funciones y tareas
	task reset;
		//Tarea para reset
		#100
		// Applying reset
		RESETN    = 1'h0;
		#10000;
		// Releasing reset
		RESETN    = 1'h1;
	endtask :reset

	task burst_write;
		input [31:0] Address;
		input [7:0]  bl;
		int i;
		begin
		  afifo.push_back(Address);
		  bfifo.push_back(bl);

		   @ (negedge sys_clk);
		   $display("Write Address: %x, Burst Size: %d",Address,bl);

		   for(i=0; i < bl; i++) begin
		      wb_stb_i        = 1;
		      wb_cyc_i        = 1;
		      wb_we_i         = 1;
		      wb_sel_i        = 4'b1111;
		      wb_addr_i       = Address[31:2]+i;
		      wb_dat_i        = $random & 32'hFFFFFFFF;
		      dfifo.push_back(wb_dat_i);

		      do begin
		          @ (posedge sys_clk);
		      end while(wb_ack_o == 1'b0);
		          @ (negedge sys_clk);
		   
		       $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,wb_addr_i,wb_dat_i);
		   end
		   wb_stb_i        = 0;
		   wb_cyc_i        = 0;
		   wb_we_i         = 'hx;
		   wb_sel_i        = 'hx;
		   wb_addr_i       = 'hx;
		   wb_dat_i        = 'hx;
		end
	endtask


endclass : driver



class monitor;

	//propiedades

	//constructor
	function new();
		//
	endfunction

	//funciones y tareas
	task burst_read;
		reg [31:0] Address;
		reg [7:0]  bl;

		int i,j;
		reg [31:0]   exp_data;
		begin
		  
		   Address = afifo.pop_front(); 
		   bl      = bfifo.pop_front(); 
		   @ (negedge sys_clk);

		      for(j=0; j < bl; j++) begin
		         wb_stb_i        = 1;
		         wb_cyc_i        = 1;
		         wb_we_i         = 0;
		         wb_addr_i       = Address[31:2]+j;

		         exp_data        = dfifo.pop_front(); // Exptected Read Data
		         do begin
		             @ (posedge sys_clk);
		         end while(wb_ack_o == 1'b0);
		         if(wb_dat_o !== exp_data) begin
		             $display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j,wb_addr_i,wb_dat_o,exp_data);
		             ErrCnt = ErrCnt+1;
		         end else begin
		             $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j,wb_addr_i,wb_dat_o);
		         end 
		         @ (negedge sdram_clk);
		      end
		   wb_stb_i        = 0;
		   wb_cyc_i        = 0;
		   wb_we_i         = 'hx;
		   wb_addr_i       = 'hx;
		end
	endtask

endclass : monitor



class scoreboard;

	//propiedades

	//constructor
	function new();
		//
	endfunction

	//funciones y tareas

endclass : scoreboard