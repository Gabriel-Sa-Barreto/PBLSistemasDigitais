// This testbench will exercise the file arbitro.v.
`timescale 1ns/1ns
 
`include "uart_tx.v"
`include "uart_rx.v"
`include "arbitro.v"
`include "digital_clock.v"
 
module arbitro_tb ();

/*entradas do árbitro
reg clock;
reg [31:0] dataA;
reg rx_Serial;
reg [7:0]tx_Serial; 

//saídas
wire tx;
wire done;
wire [31:0] result;
wire        tx_DV;

reg txDV;

initial begin 
    clock = 0; 
    dataA <= 32'd1;
  end

always # 10 clock = ~clock;


always @ (posedge clock)
begin
	txDV <= tx_DV;
  $display("txDV = %b " , txDV);
  $display("tx   = %b " , tx);
end

arbitro arbitro_inst
(
	.clock(clock) ,	          // input  clock_sig
	.reset() ,	              // input  reset_sig
	.clock_en() ,	            // input  clock_en_sig
	.rx_Serial(rx_Serial),
	.dataA(dataA) ,	          // input [31:0] dataA_sig
	.tx(tx) ,	                // output  tx_sig
	.tx_DV(tx_DV),
	.done(done) ,	            // output  done_sig
	.result(result) 	        // output [31:0] result_sig
);*/

reg clock;
reg reset;
wire tx;
reg in;
always # 10 clock = ~clock;
initial begin
	reset = 1;
	in = 8'd1;
	#(10);
	reset = 0;
end

always @ (posedge clock)
begin
	//$display("tx: %b", tx);
end

newArbitro newArbitro_inst_tx
(
  .clk(clock),
  .in(in),
  .reset(reset),
  .tx(tx)
);

endmodule