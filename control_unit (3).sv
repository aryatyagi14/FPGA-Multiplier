module control_unit (
	input logic Clk, Reset, Run, M,
	output logic Add, Sub, Shift_En, Clear_XA, Clear_Load, LoadB );
	
	//A0-A7 add states, S0-S7 are the shift states
	enum logic [4:0] {Execute, A0, A1, A2, A3, A4, A5, A6, A7, S0, S1, S2, S3, S4, S5, S6, S7, Halt, ClearA_LoadB, Wait} Curr_State, Next_State;
	
	always_ff @ (posedge Clk) begin
		if(Reset) begin
			Curr_State <= Next_State;
			end
		else begin // if (~Reset)
			//Curr_State <= Execute;
			Curr_State <= ClearA_LoadB;
			end
		
	end
		
		
//this always comb just sets what state we need to be in based on the curr_state
	always_comb begin
		Next_State =  Curr_State;
		
		case (Curr_State)
			Execute: if (~Run) begin
							Next_State = A0;
						end
						else 
							Next_State = Execute;
			//this allows us to go from each adding state to shifting over and over again
			A0: Next_State = S0;
			S0: Next_State = A1;
			
			A1: Next_State = S1;
			S1: Next_State = A2;
			
			A2: Next_State = S2;
			S2: Next_State = A3;
			
			A3: Next_State = S3;
			S3: Next_State = A4;
			
			A4: Next_State = S4;
			S4: Next_State = A5;
			
			A5: Next_State = S5;
			S5: Next_State = A6;
			
			A6: Next_State = S6;
			S6: Next_State = A7;
			
			A7: Next_State = S7;
			S7: Next_State = Halt;
			
			ClearA_LoadB: Next_State = Execute;
			
			Wait: if (~Run) begin 
						Next_State = Execute;
					end 
					else 
						Next_State = Wait;
			
			Halt: if (Run) begin
						Next_State = Wait;
					end
					else 
						Next_State = Halt;
		endcase

					Add = 1'b0;
					Sub = 1'b0;
					Shift_En = 1'b0;
					Clear_XA = 1'b0;
					LoadB = 1'b0;
					Clear_Load = 1'b0;
	 case (Curr_State) 
		
		Execute: begin 
		//in execute state we do want to clear XA
					Clear_XA = 1'b1;
					LoadB = 1'b0;
					Clear_Load = ~Reset; end
					
		S0, S1, S2, S3, S4, S5, S6, S7: begin
			Shift_En = 1'b1;
		end
					
		A0, A1, A2, A3, A4, A5, A6: begin
					Add = M;
			end
		A7: begin
					Sub = M;
			end
					
		Halt: begin
				end
					
		ClearA_LoadB : begin
					LoadB = 1'b1;
					end			
		endcase
		
	end
	
endmodule 
			