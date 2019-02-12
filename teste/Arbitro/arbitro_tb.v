// This testbench will exercise the file arbitro.v.
`timescale 1ns/1ns
 
`include "uart_tx.v"
`include "uart_rx.v"
`include "arbitro.v"
`include "digital_clock.v"
 
module arbitro_tb ();

//entradas do árbitro
reg clock;
reg [31:0] dataA;
reg [7:0]rx_Serial;
reg [7:0]tx_Serial; 
//saídas
wire tx;
wire done;
wire [31:0] result;
wire        tx_DV;


reg txDV;
parameter c_BIT_PERIOD      = 8600;

//Task para teste de requisição 
  task REQUEST_BYTE;
    input [7:0] i_Data;
    integer i;
    begin
      //enviar requisição
      dataA[7:0] = i_Data;
      //$display("DataA = %b", dataA);
      //Recebe requisição
      for (i=0; i<8; i=i+1)
        begin
          $display("txDV = %b " , txDV);
          if(txDV)
          	begin
          		tx_Serial[i] = tx;
          		//#(c_BIT_PERIOD);
          	end
        end
       //testa o valor do TX transmitido
       if (tx_Serial == 8'd1)
        begin
          $display("Test Passed - Correct Byte");
        end
      else
        begin
          $display("Test Failed - Incorrect Byte");
        end
     end
  endtask // END REQUEST_BYTE

// Main Testing:
  initial
    begin       
    	$display("Opened Test");  
  		REQUEST_BYTE(8'd1); //requisição para o sensor 1
    end

always @ (posedge clock)
begin
	txDV <= tx_DV;
end

arbitro arbitro_inst
(
	.clock(clock) ,	                // input  clock_sig
	.reset(reset_sig) ,	            // input  reset_sig
	.clock_en() ,	                // input  clock_en_sig
	.rx_Serial(rx_Serial),
	.dataA(dataA) ,	                // input [31:0] dataA_sig
	.tx(tx) ,	                    // output  tx_sig
	.tx_DV(tx_DV),
	.done(done) ,	                // output  done_sig
	.result(result) 	            // output [31:0] result_sig
);
	

endmodule