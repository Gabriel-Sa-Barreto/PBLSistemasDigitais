module arbitro (
	input clock;
	input reset;
	input clock_en;
	input  wire [31:0] dataA;
	input  reg         rx;
	output reg         tx;	
);

parameter IDLE         = 4'b0000;
parameter REQUEST      = 4'b0001;
parameter ANSWER_TIME  = 4'b0010;
parameter TIMEOUT      = 4'b0011;
parameter CHECKSUM     = 4'b0100;
parameter SEND_BACK    = 4'b0101;
parameter TRYALARM     = 4'b0110;
parameter ALARM        = 4'b0111;
parameter CLEAN_BUFFER = 4'b1000;

parameter c_CLOCK_PERIOD_NS = 100;
parameter c_CLKS_PER_BIT    = 87; //parâmetro do tx para o clock por bit
reg wire  r_Tx_DV = 0;            //informa se pode transmitir algo via TX 
wire w_Tx_Done;                   //informa que a transmissão foi concluída
wire [15:0] w_Rx_Byte;
wire rx_DV;

reg r_Rx_Serial = 1;
reg r_Clock = 0;
reg [2:0] state;
reg [2:0] next_state      = 0;
reg [7:0] requestSensor;          //número de requisição do sensor desejado
reg [7:0] checkSum = 8'b00110111; //realiza teste XOR de igualdade para verificação de dados recebidos corretamente
reg [15:0]recivedValue;
reg [7:0] comparePack;

always
    #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;


always @ (clock)
	begin
		if(reset){
			state <= IDLE;
		}else{
			state <= next_state;
		}
	end

always @ (state,dataA)
	begin
		case(state)
			IDLE:
				/*Se dataA tiver algum valor, então muda para o estado Timer para envio de uma requisição*/
				if(dataA){
					begin
						requestSensor  <= dataA[7:0]; //sensor requisitado
						       r_Tx_DV <= 1'b1;
						next_state     <= REQUEST;
					end
				}else
					begin
						next_state <= IDLE;
					end

			REQUEST: /*Espera fim da requisição*/
				//espera a finalização pelo w_Tx_Done e após isso dá um time de resposta
				if(w_Tx_Done){
					begin
						requestSensor <= 0;
								r_Tx_DV <= 1'b0;
						next_state    <= ANSWER_TIME;
					end
				}else{
					begin
						next_state    <= REQUEST
					end				
				}
				
			ANSWER_TIME:
				/*Espera 10 segundos, caso nenhuma resposta tenha chegado via RX, próximo estado será TIMEOUT*/
			
			TIMEOUT:
			   next_state <= IDLE;
		
			CHECKSUM:
				comparePack = checkSum ^ receivedValue[7:0]
				if( comparePack == receiveValue[15:8]){
					begin
						//retorna o resultado para o software em C
					end
				}else{
					next_state <= TRYALARM;
				}
			
			
			SEND_BACK:

			TRYALARM:
				/*Espera um tempo pra saber se recebe mais algo pacote, se receber é um alarme, senão, foi choque de dados*/
			
			
			ALARM:

			CLEAN_BUFFER:
		endcase
	end


uart_tx uart_tx_inst
(
	.CLKS_PER_BIT(c_CLKS_PER_BIT) ,	   // input  CLKS_PER_BIT_sig
	.i_Clock(r_Clock) ,					   // input  i_Clock_sig
	.i_Tx_DV(r_Tx_DV) ,					   // input  i_Tx_DV_sig
	.i_Tx_Byte(requestSensor) ,			// input [7:0] i_Tx_Byte_sig
	.o_Tx_Active() ,							// output  o_Tx_Active_sig
	.o_Tx_Serial() ,							// output  o_Tx_Serial_sig
	.o_Tx_Done(w_Tx_Done) 				   // output  o_Tx_Done_sig
);

uart_rx uart_rx_inst
(
	.CLKS_PER_BIT(c_CLKS_PER_BIT) ,		// input  CLKS_PER_BIT_sig
	.i_Clock(r_Clock) ,						// input  i_Clock_sig
	.i_Rx_Serial(r_Rx_Serial) ,			// input  i_Rx_Serial_sig
	.o_Rx_DV(rx_DV) ,							// output  o_Rx_DV_sig
	.o_Rx_Byte(w_Rx_Byte) 					// output [7:0] o_Rx_Byte_sig
);






endmodule