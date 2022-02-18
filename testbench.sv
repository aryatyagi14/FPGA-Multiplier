module testbench();

timeunit 10ns;

timeprecision 1ns;

logic Clk, Reset_Load_Clear, Run;
logic [7:0] SW;
logic Xval;
logic [7:0] Aval, Bval;
logic [6:0] HEX0, HEX1, HEX2, HEX3;
	
multiplier test_multiplier (.*);

logic shift;
assign shift = test_multiplier.Shift_En;

logic [4:0] state;
assign state = test_multiplier.control_unit0.Curr_State;
	

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

	
initial begin: TEST_VECTORS

Reset_Load_Clear = 1;
Run = 1;
SW = 8'b0000_0011;

//switching SW switches B aas well
#2 Reset_Load_Clear = 0;

#2 Reset_Load_Clear = 1;

#4
SW = 8'b1111_1111;

#2
Run = 0;

#2
	Run = 1;
end

endmodule 