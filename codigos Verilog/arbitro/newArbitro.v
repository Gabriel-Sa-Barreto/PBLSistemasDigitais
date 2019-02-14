module newArbitro
(
	input	     clk, 
	input   [31:0]in, 
	input      reset,
	output wire   tx,
	output wire   tx_Done
);

	// Declare state register
	reg		[2:0]state;

	// Declare states
	parameter IDLE           = 3'b000;
	parameter REQUEST        = 3'b001;
	parameter ANSWER_TIME    = 3'b010;
	parameter TIMEOUT        = 3'b011;
	parameter CHECKSUM       = 3'b100;
	parameter SEND_BACK      = 3'b101;
	parameter TRYALARM       = 3'b110;

	wire       w_Tx_Done;
	wire        doneTime;           //informa se os 10 segundos do tempo de resposta foi finalizado
	wire [7:0] w_Rx_Byte;
	wire           rx_DV;

	reg [7:0] sensor;
	reg       r_Tx_DV;              //informa se pode transmitir algo via TX 
	
	reg active;                     //ativa a contagem de 10 segundos
	reg [7:0]receivedValue;         //recebe byte do RX
	assign tx_Done = w_Tx_Done;

	// Determine the next state synchronously, based on the
	// current state and the input
	always @ (posedge clk or posedge reset) begin
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE: 
				begin
					//$display("idle");
					if (in)
						begin
							sensor  <= in[7:0];
							WRITE_TX();
							//r_Tx_DV <= 1'b1;
							state   <= REQUEST;
						end
					else
						begin
							state <= IDLE;
						end
				end
				REQUEST:
				begin
					//$display("request");
					if (w_Tx_Done)
					begin
						state <= ANSWER_TIME;
					end
					else
					begin
						state <= REQUEST;
					end
				end
				ANSWER_TIME:
				begin
					/*Espera 10 segundos, caso nenhuma resposta tenha chegado via RX, próximo estado será TIMEOUT*/
					$display("//////////////////////////");
					$display("AT");
					if(doneTime) 
						begin
							state  <= TIMEOUT;
						end
					else
						begin
							if(rx_DV) //verifica se o RX recebeu algum pacote
								begin
									receivedValue <= w_Rx_Byte;
									state         <= CHECKSUM;
								end
						end
				end
				TIMEOUT:
				begin
					$display("timeout");
					if (in)
					begin
						state <= IDLE;
					end
				end

				CHECKSUM:
				begin
					$display("CHECKSUM");
					state <= IDLE;
				end
			endcase
	end

	// Determine the output based only on the current state
	// and the input (do not wait for a clock edge).
	always @ (state or in)
	begin
			case (state)
				IDLE:
					if (in)
					begin
						//out = 2'b00;
					end
					else
					begin
						//out = 2'b10;
					end
				REQUEST:
					if (in)
					begin
						//out = 2'b01;
					end
					else
					begin
						//out = 2'b00;
					end
				ANSWER_TIME:
					begin
						sensor <= 0;
						r_Tx_DV <= 1'b0;
						active   <= 1'b1; //mantém a contagem
						if (doneTime)
							begin
								active   <= 1'b0; //desativa a contagem
							end
						else
							begin
								//out = 2'b01;
							end
					end
				TIMEOUT:
					if (in)
					begin
						//out = 2'b11;
					end
					else
					begin
						//out = 2'b00;
					end
				CHECKSUM:
					begin

					end
			endcase
	end


task WRITE_TX;
	begin
		// Tell UART to send a command (exercise Tx)
	    @(posedge clk);
	    @(posedge clk);
	    r_Tx_DV <= 1'b1;
	    $display("sensor value = %b " , sensor);
	    @(posedge clk);
	    r_Tx_DV <= 1'b0;
	    @(posedge w_Tx_Done);
	    $display("Tx_Done = %b " , w_Tx_Done);
	end
endtask //END WRITE_TX

uart_tx uart_tx_inst
(
	.i_Clock(clk) ,					   // input  i_Clock_sig
	.i_Tx_DV(r_Tx_DV) ,					   // input  i_Tx_DV_sig
	.i_Tx_Byte(sensor) ,			// input [7:0] i_Tx_Byte_sig
	.o_Tx_Active() ,							// output  o_Tx_Active_sig
	.o_Tx_Serial(tx) ,							// output  o_Tx_Serial_sig
	.o_Tx_Done(w_Tx_Done) 				   // output  o_Tx_Done_sig
);

uart_rx uart_rx_inst
(
  .i_Clock(clk),
  .i_Rx_Serial(tx),
  .o_Rx_DV(rx_DV),
  .o_Rx_Byte(w_Rx_Byte)
);

digital_clock digital_clock_inst
(
	.clk(clk) ,								// input  clk_sig
	.active(active) ,							// input  active_sig
	.done(doneTime) 							// output  done_sig
);

endmodule
