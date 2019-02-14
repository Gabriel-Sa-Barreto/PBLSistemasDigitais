// This testbench will exercise the file arbitro.v.
`timescale 1ns/1ns
 
`include "uart_tx.v"
`include "uart_rx.v"
`include "arbitro.v"
`include "digital_clock.v"
 
module arbitro_tb ();

reg clock;
reg reset;
wire tx;
wire tx_Done;
reg [31:0]in;

initial begin
	SEND_TX();
end

task SEND_TX;
begin
	$display("Teste 1=============");
		reset = 1;
		in = 32'd1;
		$display("in: %d", in);
		#(10);
		reset = 0;
		@(posedge tx_Done);
	$display("=============");
	$display("Teste 2=============");
		reset = 1;
		#(10);
		in = 32'd2;
		$display("in: %d", in);
		reset = 0;
		@(posedge tx_Done);
	$display("=============");
	$display("Teste 3=============");
		reset = 1;
		#(10);
		in = 32'dx;
		$display("in: %d", in);
	$display("=============");
end
endtask

newArbitro newArbitro_inst_tx
(
  .clk(clock),
  .in(in),
  .reset(reset),
  .tx(tx),
  .tx_Done(tx_Done)
);

endmodule