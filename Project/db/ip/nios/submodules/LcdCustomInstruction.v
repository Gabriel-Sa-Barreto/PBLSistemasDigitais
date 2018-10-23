module lcd( dataa, datab, result, display);

   input [31:0] dataa;//commmands
	input [31:0] datab;//datas of the display
	output [31:0] result;
	output [10:0] display;
   
	assign display [10:8] = dataa[2:0];
	assign display [7:0]  = datab [7:0];

	//wire [10:0] dataLcd = dataA[10:0];

	//wire [2:0] Rs_RW_E = dataLcd [10:8];
	//wire [7:0] data      = dataLcd [7:0];

	//assign result [10:8] = Rs_RW_E;
	//assign result [7:0]  = data;
endmodule 