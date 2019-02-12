`timescale 1ns/1ns
module arbitro (
	input clock,
	input reset,
	input clock_en,
	input  wire rx_Serial,
	input  wire [31:0] dataA,
	output wire          tx,
	output wire        tx_DV,
	output done,
	output [31:0]result
);

parameter IDLE           = 3'b000;
parameter REQUEST        = 3'b001;
parameter ANSWER_TIME    = 3'b010;
parameter TIMEOUT        = 3'b011;
parameter CHECKSUM       = 3'b100;
parameter SEND_BACK      = 3'b101;
parameter TRYALARM       = 4'b110;
//parameter ALARM        = 4'b0111;
//parameter CLEAN_BUFFER = 4'b1000;

parameter c_CLOCK_PERIOD_NS = 10;
reg       r_Tx_DV = 0;              //informa se pode transmitir algo via TX 

wire w_Tx_Done;                     //informa que a transmissão foi concluída
wire [15:0] w_Rx_Byte;
wire rx_DV;
wire doneTime;                      //informa se os 10 segundos do tempo de resposta foi finalizado

reg active;                         //ativa a contagem de 10 segundos
reg r_Clock = 0;
reg [2:0] state;
reg [2:0] next_state      = 0;
reg [7:0] requestSensor;            //número de requisição do sensor desejado
reg [7:0] checkSum = 8'b00110111;   //realiza teste XOR de igualdade para verificação de dados recebidos corretamente
reg [15:0]receivedValue;
reg [7:0] comparePack;
reg [7:0] value;                   //Usado para passar o valor para o result
reg valueSent;                     //diz que o valor em RX já foi recebido

assign result[7:0] = value;
assign        done = valueSent;
assign tx_DV       = r_Tx_DV;
always
    #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;

initial begin
	state = IDLE;
end

always @ (posedge clock)
	begin
		if(reset)
			state <= IDLE;
		else
			state <= next_state;
	end

always @ (posedge state, posedge dataA)
	begin
		case(state)
				IDLE:
					begin
						valueSent = 0;
						/*Se dataA tiver algum valor, então muda para o estado Timer para envio de uma requisição*/
						if(dataA)
							begin
								requestSensor  <= dataA[7:0]; //sensor requisitado
										 r_Tx_DV <= 1'b1;
								next_state     <= REQUEST;
							end
						else
							begin
								next_state <= IDLE;
							end
					end
					
				REQUEST:
					begin
						//espera a finalização pelo w_Tx_Done e após isso dá um time de resposta
						$display("Sensor: %b", requestSensor);
						if(w_Tx_Done)
							begin
								requestSensor <= 0;
										r_Tx_DV <= 1'b0;
										 active <= 1'b1; //ativa a contagem
								next_state    <= ANSWER_TIME;
							end
						else
							begin
								next_state    <= REQUEST;
							end	
					end			
					
				ANSWER_TIME:
					/*Espera 10 segundos, caso nenhuma resposta tenha chegado via RX, próximo estado será TIMEOUT*/
					begin
						if(doneTime)
							begin
									 active   <= 1'b0; //desativa a contagem
								next_state   <= TIMEOUT;
							end
						else
							begin
								if(rx_DV) //verifica se o RX recebeu algum pacote
									begin
										receivedValue <= w_Rx_Byte;
										next_state   <= CHECKSUM;
									end
							end
					end
				
				TIMEOUT: 
					begin
						next_state <= IDLE;
					end
			
				CHECKSUM:
					begin
						comparePack = checkSum ^ receivedValue[7:0];
						if( comparePack == receivedValue[15:8])
							begin
								//retorna o resultado para o software em C
								next_state <= SEND_BACK;
							end
						else
							begin
									 active <= 1'b1; //ativa a contagem
								next_state <= TRYALARM;
							end
					end			
			
				SEND_BACK:
					begin
						//Retorna o valor desejado
						valueSent <= 1;
						    value <= receivedValue[7:0];
					end
				TRYALARM:
					/*Espera um tempo pra saber se recebe mais algo pacote, se receber é um alarme, senão, foi choque de dados*/
					begin
						if(doneTime)
							begin
									    active   <= 1'b0; //desativa a contagem
									next_state   <= IDLE;
							end
						else
							begin
								if(rx_DV) //verifica se o RX recebeu algum pacote
									begin
										receivedValue <= w_Rx_Byte;
										next_state   <= CHECKSUM;
									end
							end
					end
		endcase
	end


uart_tx uart_tx_inst
(
	.i_Clock(r_Clock) ,					   // input  i_Clock_sig
	.i_Tx_DV(r_Tx_DV) ,					   // input  i_Tx_DV_sig
	.i_Tx_Byte(requestSensor) ,			// input [7:0] i_Tx_Byte_sig
	.o_Tx_Active() ,							// output  o_Tx_Active_sig
	.o_Tx_Serial(tx) ,							// output  o_Tx_Serial_sig
	.o_Tx_Done(w_Tx_Done) 				   // output  o_Tx_Done_sig
);

uart_rx uart_rx_inst
(
	.i_Clock(r_Clock) ,						// input  i_Clock_sig
	.i_Rx_Serial(rx_Serial) ,			// input  i_Rx_Serial_sig
	.o_Rx_DV(rx_DV) ,							// output  o_Rx_DV_sig
	.o_Rx_Byte(w_Rx_Byte) 					// output [7:0] o_Rx_Byte_sig
);


digital_clock digital_clock_inst
(
	.clk(clock) ,								// input  clk_sig
	.active(active) ,							// input  active_sig
	.done(doneTime) 							// output  done_sig
);





endmodule