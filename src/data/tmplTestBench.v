`timescale 1ns/1ps
`define vcs     // 1: dump fsdb    / 0: not dump fsdb
`define	ptpx


module tb_main;

	// Inputs
	reg reset_p;
	reg clk_48Mhz;
	reg [7:0] plain_byte_in;
	reg plain_byte_valid;
	reg plain_finish;
	reg empty;

	// Outputs
	wire [7:0] cipher_byte_out;
	wire cipher_byte_valid;
	wire trig;

	// Instantiate the Unit Under Test (UUT)
	aes_top uut (
		.reset_p(reset_p), 
		.clk_48Mhz(clk_48Mhz), 
		.plain_byte_in(plain_byte_in), 
		.plain_byte_valid(plain_byte_valid), 
		.plain_finish(plain_finish), 
		.empty(empty), 
		.cipher_byte_out(cipher_byte_out), 
		.cipher_byte_valid(cipher_byte_valid), 
		.trig(trig)
	);

    reg [127:0] tarkey;
        
	task init_sim;
		begin 
			reset_p = 0;
			clk_48Mhz = 0;
			plain_byte_in = 0;
			plain_byte_valid = 0;
			plain_finish = 0;
			empty = 1;
			tarkey = 128'h0123_4567_89ab_cdef_1234_5678_9abc_def0;
		end
	endtask
	
	
	parameter clk_half_period = 20;
	parameter clk_period=2 * clk_half_period;
	
	
	always begin:clk_generate
		#clk_half_period;
		clk_48Mhz = ~clk_48Mhz;
		end
	
		
	task rst_trig;
		begin 
		reset_p = 0;
		#(2 * clk_half_period);
		reset_p = 1;
		#(2 * clk_period);
		reset_p = 0;
		end
	endtask
	
	integer i;
	integer stimufile;
	parameter stimunum = 201;
	reg [255:0] block;

	initial //annotate_sdf
	begin 
		$sdf_annotate("./data/aes_top.sdf",aes_top,,"aes_top.log","MAXIMUM");
	end

	initial 
	begin: main
		$display (" simulation start ");
		$display (" ................ ");
		stimufile = $fopen("StimuliFile.txt", "a");
		init_sim();
		rst_trig();
		for (i=0; i<stimunum; i=i+1)
			begin
			
			block = { tarkey, $urandom, $urandom, $urandom, $urandom };
			$fwrite(stimufile, "%h\n", block); 

			#(2 * clk_period);
			plain_byte_in = block[255:248];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[255:248];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[247:240];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[247:240];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[239:232];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[239:232];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[231:224];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[231:224];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[223:216];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[223:216];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[215:208];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[215:208];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[207:200];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[207:200];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[199:192];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[199:192];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[191:184];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[191:184];
			plain_byte_valid=0;
			
			
			#(2 * clk_period);
			plain_byte_in = block[183:176];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[183:176];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[175:168];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[175:168];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[167:160];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[167:160];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[159:152];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[159:152];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[151:144];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[151:144];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[143:136];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[143:136];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[135:128];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[135:128];
			plain_byte_valid=0;			
			
			#(2 * clk_period);
			plain_byte_in = block[127:120];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[127:120];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[119:112];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[119:112];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[111:104];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[111:104];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[103:96];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[103:96];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[95:88];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[95:88];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[87:80];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[87:80];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[79:72];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[79:72];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[71:64];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[71:64];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[63:56];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[63:56];
			plain_byte_valid=0;
			
			
			#(2 * clk_period);
			plain_byte_in = block[55:48];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[55:48];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[47:40];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[47:40];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[39:32];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[39:32];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[31:24];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[31:24];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[23:16];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[23:16];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[15:8];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[15:8];
			plain_byte_valid=0;
			
			#(2 * clk_period);
			plain_byte_in = block[7:0];
			plain_byte_valid=1;
			#(1 * clk_period);
			plain_byte_in = block[7:0];
			plain_byte_valid=0;
			
			
			#(2 * clk_period);
			plain_finish = 1;
			#(1 * clk_period);
			
			#(2 * clk_period);
			plain_finish = 0;
			
			#(71*clk_period);

			end
			
		
        $display("*** AES simulation done. ***");
        $fclose(stimufile);
        $finish;
	end
	


	//---------------------------------------------------------------
	// INITIAL --- dump Vars for debug
	//--------------------------------------------------------------
	initial
	begin 
 		`ifdef vcs
		$vcdpluson(0,tb_main);
		$vcdplusautoflushon;
		`endif
	end


	integer j;
	parameter start_timepoint = 7060;
	parameter timeperiod = 3440;
	parameter inter_timepoint = 3440;

	initial
	begin: ptpx
		#start_timepoint;
		$display("VCD Record Start");
    	$display("................");
    	`ifdef ptpx
		$dumpfile("SwitchFile.vcd");
		$dumpvars(0,tb_main.uut);
		`endif
    	for (j=0; j<stimunum; j=j+1)
		begin
		$display("Current Loop: %d", i);
	    	$dumpon;
	    	#timeperiod;
	    	$dumpoff;
	    	#inter_timepoint;
		end
	end	
 
endmodule