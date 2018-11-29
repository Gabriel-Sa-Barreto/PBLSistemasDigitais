
module nios (
	clk_clk,
	lcd_0_conduit_end_1_readdata,
	lcd_0_conduit_end_2_writeresponsevalid_n,
	lcd_0_conduit_end_3_writeresponsevalid_n,
	lcd_0_conduit_end_4_writeresponsevalid_n,
	leds_external_connection_export,
	pushbutton_external_connection_export,
	uart_0_external_connection_rxd,
	uart_0_external_connection_txd);	

	input		clk_clk;
	output	[7:0]	lcd_0_conduit_end_1_readdata;
	output		lcd_0_conduit_end_2_writeresponsevalid_n;
	output		lcd_0_conduit_end_3_writeresponsevalid_n;
	output		lcd_0_conduit_end_4_writeresponsevalid_n;
	output	[3:0]	leds_external_connection_export;
	input	[3:0]	pushbutton_external_connection_export;
	input		uart_0_external_connection_rxd;
	output		uart_0_external_connection_txd;
endmodule
