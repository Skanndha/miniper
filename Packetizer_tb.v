module Packetizer_tb;

reg clk;
reg reset;
reg [15:0] HF;
reg [15:0] BF;
reg [15:0] TF;

wire [47:0] flit_out;
wire wr_en;

Packetizer dut(.clk(clk), .reset(reset), .HF(HF), .BF(BF), .TF(TF), .flit_out(flit_out), .write_enable(wr_en));

initial
  begin
    clk = 0;
    reset=1;
  $dumpfile("dump.vcd");
  $dumpvars();
  
  end

always #5 clk = ~clk;

task inputs(input [15:0] h, b, t)
  begin
    HF = h;
    BF = b;
    TF = t;
 end
endtask

initial
  begin
    #10
    reset=0;
    #10;
    inputs(16'd69, 16'd44, 16'd36);
   #10;
  inputs(16'd11, 16'd12, 16'd13);
#10;
  inputs(16'd44, 16'd77, 16'd88);
#50 $finish;
end


endmodule
  
