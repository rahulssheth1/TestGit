/*// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps


//--------------------------------------------------------------------
//		Design Assign #2, Problem #2 Testbench.
//--------------------------------------------------------------------
module dassign2_0_tb();
 
  reg [7:0] a; 
  reg [7:0] b; 
  wire [15:0] pp; 
  reg [15:0] corr; 
  integer i; 
  reg clk;
  reg reset; 
  wire ready; 
  wire [15:0] pp2;
  partial_product pp1(a, b[0], pp); 
  multiply mult(clk, a, b, reset, pp2, ready); 
initial begin 
  $dumpfile("timing2_1.vcd");
    $dumpvars;
  
  for (i=0; i < 127; i=i+1) begin 
    a = $urandom;
    b = $urandom;
    corr = a * b[0]; 
    #5
    //$display( "a: %b, b: %b, %d: pp, %d: corr, ", a,b[0], pp, corr); 
    $display( "a: %d, b: %b, %d: pp2, %d: corr", a[7:0], b, pp2, corr); 
    
  end 
  $finish;
end 
endmodule
*/