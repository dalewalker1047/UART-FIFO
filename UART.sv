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

module UART(
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
	output logic tick);
	
endmodule

module receiver(
	input logic clk, reset, rx, s_tick,
	output logic rx_done,
	output logic [7:0] dout);
	
endmodule

module transmitter(
	input logic clk, reset, tx_start, s_tick,
	input logic [7:0] din,
	output logic tx_done,
	output logic tx);
	
endmodule

module fifo();

endmodule
	
