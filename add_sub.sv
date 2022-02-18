module add_sub
(
		input logic [7:0] A, B,
		input logic  fn, M,
		output logic [8:0] S );
		
		//fn = 1 subtract/ fn = 0 add
		//sign extend fn
		//logic [7:0] funct;
		//assign funct = {8{fn}};
		
		//XOR everybit of B with fn
		logic [7:0] tempB, B0;
		assign tempB = B ^ {8{fn}};
		
		//if we are suppose to do nothing set B = 0
		
		//sign extend A and B
		logic [8:0] seA;
		logic [8:0] seB;
		
		assign seA = {A[7], A[7:0]};
		
		assign seB = {tempB[7], tempB[7:0]};
		
		
		//add A and B, making cin = fn 
		logic cout;
		//nine_bit_adder NBA0 ( .A(seA[8:0]), .B(seB[8:0]), .cin(fn), .S(S[8:0]), .cout(cout) );
	
		assign B0 = 8'b000_0000;
		
		logic [8:0] S0, S1;
		
		nine_bit_adder NBA0 ( .A(seA[8:0]), .B({1'b0, B0}), .cin(fn), .S(S0), .cout() );
			
		nine_bit_adder NBA1 ( .A(seA[8:0]), .B(seB[8:0]), .cin(fn), .S(S1), .cout() );
		
		//this logic doesnt work because B passed in is always SW so B[0] = 0 always
		//assign S = B[0] ? S1: S0;	
		assign S = M ? S1: S0;
		
	  //s[8] = the xbit 
     
endmodule



module full_adder (input logic x,y,z, output logic s,c);
	
	//this just sets and returns the values of s and c 
	always_comb begin 
		s = x^y^z;
		c = (x&y) | (y&z) | (x&z);
	end
	
endmodule



module nine_bit_adder (input logic [8:0] A,B, 
								input logic cin,
								output logic [8:0] S,
								output logic cout);

	//these are the internal carry bits 			
	logic c1, c2, c3, c4, c5, c6, c7, c8, c9;
	
	//now we use the full adder to add each of the bits separately and then pass in the cout from each to the next (to cascade)
	full_adder F0(.x(A[0]), .y(B[0]), .z(cin), .s(S[0]), .c(c1) );
	full_adder F1(.x(A[1]), .y(B[1]), .z(c1), .s(S[1]), .c(c2) );
	full_adder F2(.x(A[2]), .y(B[2]), .z(c2), .s(S[2]), .c(c3) );
	full_adder F3(.x(A[3]), .y(B[3]), .z(c3), .s(S[3]), .c(c4) );
	
	full_adder F4(.x(A[4]), .y(B[4]), .z(c4), .s(S[4]), .c(c5) );
	full_adder F5(.x(A[5]), .y(B[5]), .z(c5), .s(S[5]), .c(c6) );
	full_adder F6(.x(A[6]), .y(B[6]), .z(c6), .s(S[6]), .c(c7) );
	full_adder F7(.x(A[7]), .y(B[7]), .z(c7), .s(S[7]), .c(c8) );
	
	full_adder F8(.x(A[8]), .y(B[8]), .z(c8), .s(S[8]), .c(cout) );

endmodule

				
			
