module DePacketizer_tb;

reg clk;
reg reset;
reg [47:0] flitoutde;

wire [15:0] data_out;
wire packet_end;

DePacketizer dut(.clk(clk), .reset(reset), .flitoutde(flitoutde), .data_out(data_out), .packet_end(packet_end));

initial
   begin
	   clk = 0;
	end
	
always #5 clk = ~clk;

initial
   begin
	  reset = 1;
	  #10;
	  reset = 0;
	  #10;
	  flitoutde = 48'h1234_ABCD_FFFF;
	  #20;
	  flitoutde = 48'h3232_6767_FFFF;
	  #1000;
	  $finish;
	end
	
endmodule


