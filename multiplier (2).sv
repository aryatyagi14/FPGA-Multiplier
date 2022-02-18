//this will be our toplevel
module multiplier (
	input logic Clk, Reset_Load_Clear, Run, //RLC and Run are the buttons
	input logic [7:0] SW,
	output logic Xval,
	output logic [7:0] Aval, Bval,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3 );
	
	logic [7:0] A0, B0, S0; //these are used for the adding and internal logic
	logic [8:0] ASout; //output of sum
	
	logic [7:0] A1, B1; //outputs of shift register
	
	logic Add, Sub, Shift_En, Clear_XA, Clear_Load, M, Add_X0, X0, X1, LoadB; //x0 is current value, x1 is the shift in value 
	

	logic fn; //tells add_sub method to either add or subtract,
	
		
	always_comb begin 
		Aval = A1;
		Bval = B1;
		A0 = ASout[7:0];
		X0 = ASout[8];
		
		//if(~Clear_XA) 
		//	X0 = Add_X0;
		//else 
		//	X0 = 1'b0;
		fn = 0;
		
		//fn never chnages from 0 
		if(Add) 
			fn = 0;
			
		else if (Sub)
			fn = 1;
			
	end
	
//begin module instantiations
//create the 2 8-bit registers, register_unit will call shift_reg_8 to determine whether or not to shift
	shift_unit shift_unit0 (
		.Clk(Clk),
		.Reset_A(Clear_XA),
		.Reset_B(Clear_Load),
		.Shift_In(ASout[8]),
		.LoadA(Add | Sub),
		.LoadB(LoadB),
		.LoadX(Add | Sub), 
		.Shift_En(Shift_En),
		.regX(X0),
		.regA(ASout[7:0]),
		.regB(SW),
		.Shift_Out(),
		.Data_OutX(X1),
		.Data_OutA(A1),
		.Data_OutB(B1));

	control_unit control_unit0 (
		.Clk(Clk),
		.Reset(Reset_Load_Clear),
		.Run(Run),
		.M(B1[0]),
		.Add(Add),
		.Sub(Sub),
		.Shift_En(Shift_En),
		.Clear_XA(Clear_XA),
		.Clear_Load(Clear_Load),
		.LoadB(LoadB)	);
	
	//calls the adder function and performs necessary computation
	add_sub adder_subtracter0 (
		.A(A1),
		.B(SW),
		.fn(fn),
		.M(B1[0]),
		.S(ASout) );
	
	HexDriver Ahex0 (.In0(A1[3:0]), .Out0(HEX2));
	HexDriver Ahex1 (.In0(A1[7:4]), .Out0(HEX3));
	HexDriver Bhex0 (.In0(B1[3:0]), .Out0(HEX0));
	HexDriver Bhex1 (.In0(B1[7:4]), .Out0(HEX1));



endmodule

			
