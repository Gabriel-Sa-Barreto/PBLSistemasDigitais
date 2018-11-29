	component nios is
		port (
			clk_clk                                  : in  std_logic                    := 'X';             -- clk
			lcd_0_conduit_end_1_readdata             : out std_logic_vector(7 downto 0);                    -- readdata
			lcd_0_conduit_end_2_writeresponsevalid_n : out std_logic;                                       -- writeresponsevalid_n
			lcd_0_conduit_end_3_writeresponsevalid_n : out std_logic;                                       -- writeresponsevalid_n
			lcd_0_conduit_end_4_writeresponsevalid_n : out std_logic;                                       -- writeresponsevalid_n
			leds_external_connection_export          : out std_logic_vector(3 downto 0);                    -- export
			pushbutton_external_connection_export    : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			uart_0_external_connection_rxd           : in  std_logic                    := 'X';             -- rxd
			uart_0_external_connection_txd           : out std_logic                                        -- txd
		);
	end component nios;

	u0 : component nios
		port map (
			clk_clk                                  => CONNECTED_TO_clk_clk,                                  --                            clk.clk
			lcd_0_conduit_end_1_readdata             => CONNECTED_TO_lcd_0_conduit_end_1_readdata,             --            lcd_0_conduit_end_1.readdata
			lcd_0_conduit_end_2_writeresponsevalid_n => CONNECTED_TO_lcd_0_conduit_end_2_writeresponsevalid_n, --            lcd_0_conduit_end_2.writeresponsevalid_n
			lcd_0_conduit_end_3_writeresponsevalid_n => CONNECTED_TO_lcd_0_conduit_end_3_writeresponsevalid_n, --            lcd_0_conduit_end_3.writeresponsevalid_n
			lcd_0_conduit_end_4_writeresponsevalid_n => CONNECTED_TO_lcd_0_conduit_end_4_writeresponsevalid_n, --            lcd_0_conduit_end_4.writeresponsevalid_n
			leds_external_connection_export          => CONNECTED_TO_leds_external_connection_export,          --       leds_external_connection.export
			pushbutton_external_connection_export    => CONNECTED_TO_pushbutton_external_connection_export,    -- pushbutton_external_connection.export
			uart_0_external_connection_rxd           => CONNECTED_TO_uart_0_external_connection_rxd,           --     uart_0_external_connection.rxd
			uart_0_external_connection_txd           => CONNECTED_TO_uart_0_external_connection_txd            --                               .txd
		);

