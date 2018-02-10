`timescale 1ns / 1ps
// EEM16 - Logic Design
// Design Assignment #2 - Problem #2.2
// dassign2_2.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided
//
// The modules you will have to design are at the end of the file
// Do not change the module or port names of these stubs

// Include constants file defining THRESHOLD, CMDs, STATEs

`include "constants2_2.vh"

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

// 4-1 Mux.  Width set via parameter.
// Includes propagation delay t_PD = 3
module mux4(a, b, c, d, sel, y);
    parameter width = 1;
    input [width-1:0] a, b, c, d;
    input [1:0] sel;
    output [width-1:0] y;
    reg [width-1:0] y;

    always @(*) begin
        case (sel)
            2'b00:    y <= #3 a;
            2'b01:    y <= #3 b;
            2'b10:    y <= #3 c;
            default:  y <= #3 d;
        endcase
    end
endmodule

// ****************
// Blocks to design
// ****************

module personalOneAdder(inCounter, outCounter);
  
  input [7:0] inCounter;
  output [7:0] outCounter;
  assign outCounter = inCounter + 1; 
endmodule

module comp(input1, outputLong); 
  input [7:0] input1;
  output outputLong;
  assign outputLong = input1 > `THRESHOLD;
endmodule
// Evaluates incoming pulses/gaps 
// Use any combination of declarative or structural verilog
// IMPORTANT: Do not change module or port names
module pulse_width(clk, in, pwidth, long, type, new);
    parameter width = 8;
    input clk, in;
    output [width-1:0] pwidth;
    output long, type, new;

    // your code here
    // do not use any delays!
  
  	wire newIn, newIn2; 
  wire [7:0] counter; 
  wire [7:0] counter2;
  //attach the input to a D-REG 
  //XOR That value with the old value
  dreg #(1) dregInput1(clk, in, newIn);
  wire xOR = in != newIn;
  mux2 #(8) counterMux(counter2, 8'b0, xOR, counter);
  wire [7:0] midCounter; 
  personalOneAdder addOne(counter, midCounter);
  dreg #(8) adderDREG(clk, midCounter, counter2); 
  assign new = xOR; 
  assign type = newIn; 
  assign pwidth = counter2;
  comp endComp(pwidth, long); 
  

endmodule

module assignZeros(in1, in2, in3, in4, out1, out2, out3, out4);
  input [7:0] in1, in2, in3, in4;
  output [7:0] out1, out2, out3, out4; 
  
  assign out1 = in1;
  assign out2 = in2; 
  assign out3 = in3; 
  assign out4 = in4; 
endmodule
  

// Four valued shift-register
// Use any combination of declarative or structural verilog
//    or procedural verilog, provided it obeys rules for combinational logic
// IMPORTANT: Do not change module or port names
module shift4(clk, in, cmd, out3, out2, out1, out0);
    parameter width = 1;
    input clk;
    input [width-1:0] in;
    input [`CMD_WIDTH-1:0] cmd;
    output [width-1:0] out3, out2, out1, out0;

    // your code here
    // do not use any delays!
  reg [width-1:0] inReg1, inReg2, inReg3, inReg0; 
  dreg oneDreg(clk, inReg0, out0);
  dreg twoDreg(clk, inReg1, out1);
  dreg threeDreg(clk, inReg2, out2);
  dreg fourDreg(clk, inReg3, out3); 
  always @(*) begin
    case (cmd)
      `CMD_LOAD : begin
        assign inReg0 = in;
        assign inReg1 = inReg0;
        assign inReg2 = inReg1; 
        assign inReg3 = inReg2; 
      end 
      `CMD_CLEAR : begin
        assign inReg0 = 8'b0; 
        assign inReg1 = 8'b0; 
        assign inReg2 = 8'b0;
        assign inReg3 = 8'b0; 
      end
      default :  ; 
        
    endcase 
        end
      
            
    
    
endmodule

// Control FSM for shift register
// Use any combination of declarative or structural verilog
//    or procedural verilog, provided it obeys rules for combinational logic
// IMPORTANT: Do not change module or port names
module control_fsm(clk, long, type, cmd, done);
    input clk, long, type;
    output [`CMD_WIDTH-1:0] cmd;
    output done;

    // your code here
    // do not use any delays!

endmodule

// Input de-serializer
// Use structural verilog only
// IMPORTANT: Do not change module or port names
module deserializer(clk, in, out3, out2, out1, out0, done);
    parameter width = 8;
    input clk, in;
    output [width-1:0] out3, out2, out1, out0;
    output done;

    // your code here
    // do not use any delays!

endmodule
