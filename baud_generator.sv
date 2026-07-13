module baud_generator(
	input logic clk, reset,
	input logic [10:0] dvsr,
	output logic tick
);
		
	logic [10:0] r_reg;
	logic [10:0] r_next;
		
	always_ff @ ( posedge clk, posedge reset)
		if(reset)
			r_reg <= 0;
		else
			r_reg <= r_next;
		
	assign r_next = (r_reg==dvsr) ? 0 : r_reg + 1;
	assign tick = (r_reg==1);
endmodule