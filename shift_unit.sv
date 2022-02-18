module shift_unit (input  logic Clk, Reset_A, Reset_B, Shift_In, LoadA, LoadB , LoadX, Shift_En,
				  input  logic regX,
              input  logic [7:0]  regA, regB,
              output logic Shift_Out, Data_OutX,
              output logic [7:0]  Data_OutA, Data_OutB);
		//have to add logic for the X register
		//x register just holds As most significant bit in order to shift in the correct bit to preserve the sign
		
		
		logic x;
		logic s1, s2;
		
		//we do nothing with data out for x register
		reg_1 registerX (.Clk(Clk), .Reset(Reset_A), .Shift_In(Shift_In), .Load(LoadX), 
								.Shift_En(1'b0), .register(regX), .Shift_Out(s1), .Data_Out(Data_OutX));
		
		//here we want to connect the out bit of shifted A to in bit of shifted B
		
		reg_8 registerA (.Clk(Clk), .Reset(Reset_A), .Shift_In(Data_OutX), .Load(LoadA), 
								.Shift_En(Shift_En), .register(regA), .Shift_Out(s2), .Data_Out(Data_OutA));
								
		reg_8 registerB (.Clk(Clk), .Reset(1'b0), .Shift_In(s2), .Load(LoadB), 
								.Shift_En(Shift_En), .register(regB), .Shift_Out(Shift_Out), .Data_Out(Data_OutB));

								
endmodule


module reg_8 (input  logic Clk, Reset, Shift_In, Load, Shift_En,
              input  logic [7:0]  register,
              output logic Shift_Out,
              output logic [7:0]  Data_Out);

	always_comb begin
	
		Shift_Out = Data_Out[0];
		
	end
	
	always_ff @ (posedge Clk) begin
	 
		if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			 Data_Out <= 8'h00;
			  
		else if (Load)
			 Data_Out <= register;
			  
		else if (Shift_En) begin
		 
			  //concatenate shifted in data to the previous left-most 3 bits
			  //note this works because we are in always_ff procedure block
			 Data_Out <= { Shift_In, Data_Out[7:1] }; 
			  
	   end
		 
   end

endmodule


module reg_1 ( input  logic Clk, Reset, Shift_In, Load, Shift_En,
              input  logic register,
              output logic Shift_Out,
              output logic Data_Out );

				  
	always_comb begin
	
		Shift_Out = Data_Out;
		
	end
	
	always_ff @ (posedge Clk) begin
	 
		if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			 Data_Out <= 0;
			  
		else if (Load)
			 Data_Out <= register;
			  
		else if (Shift_En) begin
		 
			  //concatenate shifted in data to the previous left-most 3 bits
			  //note this works because we are in always_ff procedure block
			 Data_Out <= Shift_In; 
			  
	   end
		 
   end

endmodule
