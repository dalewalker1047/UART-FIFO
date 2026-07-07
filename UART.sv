/*
Author: Dale Walker
Date: 6/29/2026
Project: UART + FIFO

Description: Leveraging System Verilog to design a configurable UART module capable of transmitting and receiving serial 
data while using FIFOs to decouple the UART

Skills showcased: FSM, Sychronous FIFO design, Clock division and baud rate gen, hardware modules, testing

Includes Documentation
*/

//UART transmitter
//UArt Receiver
//Baud Rate Generator
//FIFO
//Top Level
//TB

//possible parameters 
//DATA_WIDTH
//FIFO_DEPTH
//CLOCK_FREQ
//BAUD_RATE

module UART(	//top level module
	input rx,       		// Data input
	input logic clk,		// Clock signal
	input logic	tx,		//
	inout logic dvsr,		//
	output reg tx_full,	//
	output reg rx_empty);//    

endmodule

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

module receiver(
	input logic clk, reset, rx, s_tick,
	output logic rx_done,
	output logic [7:0] dout
);
	typedef enum  {idle, start, data, stop} state_type;
	state_type state_reg, state_next;
	logic [3:0] s_reg, s_next;
	logic [2:0] n_reg, n_next;
	logic [7:0] b_reg, b_next;
	
	
	always_ff @ (posedge clk, posedge reset)
		if (reset) begin
			state_reg <= idle;
			s_reg <= 0;
			n_reg <= 0;
			b_reg <= 0;
		end
		else begin
			state_reg <= state_next;
			s_reg <= s_next;
			n_reg <= n_next;
			b_reg <= b_next;
		end
	always_comb
	begin
		state_next = state_reg;
		rx_done = 1'b0;
		s_next <= s_reg;
		n_next <= n_reg;
		b_next <= b_reg;
		case (state_reg)
			idle:
				if(~rx) begin
					state_next = start;
					s_next = 0;
				end
			start:
				if(s_tick)
					if (s_reg==7) begin
						state_next = data;
						s_next = 0;
						n_next = 0;
					end
					else
						s_next = s_reg + 1;
			data:
				if(s_tick)
					if(s_reg==15) begin
						s_next = 0;
						b_next = {rx, b_reg[7:1]};
						if (n_reg==7)
							state_next = stop;
						else 
							n_next = n_reg +1;
					end
					else
						s_next = s_reg + 1;
			stop:
				if(s_tick) 
					if (s_reg==15) begin
						state_next = idle;
						rx_done = 1'b1;
					end
					else
						s_next = s_reg + 1;
		endcase
	end
	assign dout= b_reg;
endmodule

module transmitter(
	input logic clk, reset, tx_start, s_tick,
	input logic [7:0] din,
	output logic tx_done,
	output logic tx
);
	
	typedef enum {idle, start, data, stop} state_type;

	state_type state_reg, state_next;
	logic [3:0] s_reg, s_next;
	logic [2:0] n_reg, n_next;
	logic [7:0] b_reg, b_next;
	logic tx_reg, tx_next;
	
	always_ff @(posedge clk, posedge reset)
		if(reset) begin
			state_reg <= idle;
			s_reg <= 0;
			n_reg <= 0;
			b_reg <= 0;
			tx_reg <= 1'b1;
		end
		else begin
			state_reg <= state_next;
			s_reg <= s_next;
			n_reg <= n_next;
			b_reg <= b_next;
			tx_reg <= tx_next;
		end
		
	always_comb
		begin
		state_next = state_reg;
		tx_done = 1'b0;
		s_next <= s_reg;
		n_next <= n_reg;
		b_next <= b_reg;
		tx_next = tx_reg;
		case (state_reg)
			idle: begin
				tx_next = 1'b1;
				if (tx_start) begin
					state_next = start;
					s_next = 0;
					b_next = din;
				end
			end
			start: begin
				tx_next = 1'b0;
				if (s_tick)
					if (s_reg==15) begin
						state_next = data;
						s_next = 0;
						n_next = 0;
					end
					else
						s_next = s_reg + 1;
				end
			data: begin
				tx_next = b_reg[0];
				if (s_tick)
					if(s_reg==15) begin
						s_next = 0;
						b_next = b_reg >> 1;
						if (n_reg==(8-1))
							state_next = stop;
						else
							n_next = n_reg + 1;
					end
					else
						s_next = s_reg + 1;
				end 
			stop: begin
				tx_next = 1'b1;
				if(s_tick)
					if(s_reg==(16-1)) begin
						state_next = idle;
						tx_done = 1'b1;
					end
					else
						s_next = s_reg + 1;
			end
		endcase
	end
	assign tx = tx_reg;
endmodule

module fifo();

endmodule
	
