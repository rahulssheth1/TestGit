`timescale 1ns / 1ps

// EEM16 - Logic Design
// Design Assignment #2 - Problem #2.1
// dassign2_1.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided
//
// The modules you will have to design are at the end of the file
// Do not change the module or port names of these stubs

// ***************
// Building blocks
// ***************

// D-register (flipflop).  Width set via parameter.
// Includes propagation delay t_PD = 3
module dreg(clk, d, q);
    parameter width = 1;
    input clk;
    input [width-1:0] d;
    output [width-1:0] q;
    reg [width-1:0] q;

    always @(posedge clk) begin
        q <= #3 d;
    end
endmodule

// 2-1 Mux.  Width set via parameter.
// Includes propagation delay t_PD = 3
module mux2(a, b, sel, y);
    parameter width = 1;
    input [width-1:0] a, b;
    input sel;
    output [width-1:0] y;

    assign #3 y = sel ? b : a;
endmodule

// Left-shifter
// No propagation delay, it's just wires really
module shl(a, y);
    parameter width = 1;
    input [width-1:0] a;
    output [width-1:0] y;

    assign y = {a[width-2:0], 1'b0};
endmodule

// Right-shifter
// more wires 
module shr(a, y);
    parameter width = 1;
    input [width-1:0] a;
    output [width-1:0] y;

    assign y = {1'b0, a[width-1:1]};
endmodule

// 16-bit adder (declarative Verilog)
// Includes propagation delay t_PD = 3n = 48
module adder16(a, b, sum);
    input [15:0] a, b;
    output [15:0] sum;
  
    assign #48 sum = a+b;
endmodule


// ****************
// Blocks to design
// ****************

// Lowest order partial product of two inputs 
// Use declarative verilog only
// IMPORTANT: Do not change module or port names
module partial_product (a, b, pp);

    // your code here
    // Include a propagation delay of #1
    // assign #1 pp = ... ;
  input [15:0] a; 
  input b;
  output [15:0] pp; 
  wire [15:0] bin; 
  assign bin = {16{b}}; 
  assign #1 pp = a & bin;  
   
  	
  	

endmodule

// Determine if multiplication is complete
// Use declarative verilog only
// IMPORTANT: Do not change module or port names
module is_done (a, b, done);
  input a; 
  input [7:0] b;
  output done;
  
    // your code here
     //Include a propagation delay of #4
     //assign #4 done = ... ;
  assign #4 done = !(b[7] | b[6] | b[5] | b[4] |b[3] | b[2] | b[1] | b[0]);
endmodule



// 8 bit unsigned multiply 
// Use structural verilog only
// IMPORTANT: Do not change module or port names
module multiply (clk, ain, bin, reset, prod, ready);
      input clk;
    input [7:0] ain, bin;
    input reset;
    output [15:0] prod;
    output ready;
  
  wire [15:0] ain1, ain2, a_DREG;
  wire [7:0] bin1, bin2, b_DREG; 
  wire [15:0] pp1;
  wire [15:0] prod2;
  //Mux out to 0's or the passed in value
  //dreg the mux outputs
  //left shift then 
  //partial product it all 
  //then mux the output with 0
  //then dreg that to product and use is_done
  mux2 #(16) shifter1 (ain1, ain, reset, ain2);
  mux2 #(8) shifter2 (bin1, bin, reset, bin2);
  
  dreg #(16) a_dreg (clk, ain2, a_DREG);
  dreg #(8) b_dreg (clk, bin2, b_DREG);
  
  
  shr  #(8) rightShift(b_DREG, bin1);
  shl #(16) leftShift(a_DREG, ain1);
  
  
  
  partial_product mult1 (a_DREG, b_DREG, pp1);
  
  adder16 addIt(prod, pp1, prod2); 
  wire [15:0] outFromProdMux;
  mux2 #(16) prodMux(prod2, 16'b0, reset, outFromProdMux); 
  
  dreg #(16) product(clk, outFromProdMux, prod); 
  
  is_done done1(a_DREG, b_DREG, ready); 
  
  

  
endmodule

  
  	
 
      


// Clock generation.  Period set via parameter:
//   clock changes every half_period ticks
//   full clock period = 2*half_period
// Replace half_period parameter with desired value
module clock_gen(clk);
  	//Mux
    parameter half_period = 30.5; // REPLACE half_period HERE
    output clk;
	reg clk; 
  
    initial clk = 0;
	always #half_period clk = ~clk;
endmodule
