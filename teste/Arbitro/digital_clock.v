// Code your design here

module digital_clock(

input clk,
input active,
output done

);

localparam N = 26;
reg [N-1:0] slow_clk = 0;
reg [7:0] countsec = 0;
reg fim;   
wire enable;

always @ (posedge clk)
	begin 
		if(active)
			begin
				if (slow_clk == 26'd49) 
					slow_clk <= 8'b0;
				else  
					slow_clk <= slow_clk + 8'b1;
			end
	end
  

assign enable = (slow_clk == 26'd49);
assign done   = fim;

always @ (posedge clk)
	begin
		if(active)
			begin
				if (enable == 1'b1)
					begin
						if (countsec == 8'b00001010) //10 segundos
							begin
								countsec <= 8'b0;
									$display("segundos");
									$display("//////////////////////////");
									 fim  <= 1'b1;
							end
						else  
							begin
								countsec <= countsec + 8'b1;
									  fim <= 1'b0; 
							end
					end
			end
	end
  
endmodule