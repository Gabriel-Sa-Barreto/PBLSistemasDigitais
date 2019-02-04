module arbitro (
	input clock;
	input reset;
	input clock_en;
	input  wire [31:0] dataA;
	input  reg         rx;
	output reg         tx;	
);

parameter IDLE         = 3'b000;
parameter TIMER        = 3'b001;
parameter TIMEOUT      = 3'b010;
parameter CHECKSUM     = 3'b011;
parameter SEND_BACK    = 3'b100;
parameter TRYALARM     = 3'b101;
parameter ALARM        = 3'b110;
parameter CLEAN_BUFFER = 3'b111;

reg [2:0] state;
reg [2:0] next_stage      = 0;
reg [7:0] requestSensor;

always @ (clock)
begin
	if(reset){
		state <= IDLE;
	}else{
		state <= next_stage;
	}
end

always @ (stage,dataA)
begin
	IDLE:
		/*Se dataA tiver algum valor, então muda para o estado Timer para envio de uma requisição*/
		if(dataA){
			request  <= dataA[7:0]; //sensor requisitado
			stage    <= TIMER;
		}

	TIMER:

	TIMEOUT:

	CHECKSUM:

	SEND_BACK:

	TRYALARM:

	ALARM:

	CLEAN_BUFFER:
end

endmodule