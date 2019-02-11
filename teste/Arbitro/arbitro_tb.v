// This testbench will exercise the file arbitro.v.
`timescale 1ns/10ps
 
`include "uart_tx.v"
`include "uart_rx.v"
 
module arbitro_tb ();

//entradas do árbitro
reg clock;
reg [31:0] dataA;

//saídas
wire  tx;
wire done;
wire [31:0] result;


arbitro arbitro_inst
(
	.clock(clock) ,	                // input  clock_sig
	.reset(reset_sig) ,	            // input  reset_sig
	.clock_en() ,	                // input  clock_en_sig
	.dataA(dataA) ,	                // input [31:0] dataA_sig
	.tx(tx) ,	                    // output  tx_sig
	.done(done) ,	                // output  done_sig
	.result(result) 	            // output [31:0] result_sig
);