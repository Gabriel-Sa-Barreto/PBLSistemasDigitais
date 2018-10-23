module lcd(
	
	input [31:0] dataa, // Dados de instrução ou ação
	input [31:0] datab, // Dados para escrever no LCDs
	input clk,
	input clk_en,
          
	output     rw,
	output reg rs,
	output reg en,
	output reg [7:0] display // Saída de dados para o LCD
);
	
	assign rw    = 1'b0;         // Atribuindo o pino rw, sempre escrita
	reg    state = 1'b0;
	always @(posedge clk)
		 if(clk_en) begin
			 en    <= 1'b0;
			 state <= 1'b1; 
		 end else if(state) begin
			 en    <= 1'b1;
			 rs    <= dataa[0];
			 display[7:0] <= datab[7:0];
			 state <= 1'b0;
		 end
endmodule 