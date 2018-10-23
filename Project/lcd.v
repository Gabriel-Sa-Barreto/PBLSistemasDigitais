module lcd(
	input [31:0] entrada ,
	output [11:0] saida
);
	assign saida = entrada[11:0];
endmodule	