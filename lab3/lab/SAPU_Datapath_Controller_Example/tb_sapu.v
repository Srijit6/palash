`timescale 1ns/1ps
module tb_sapu;
reg clk,rst,start,op;
reg [3:0] A,B;
wire [4:0] Y;
wire done;
sapu dut(.clk(clk),.rst(rst),.start(start),.op(op),.A(A),.B(B),.Y(Y),.done(done));
always #5 clk=~clk;
initial begin
clk=0; rst=1; start=0; op=0; A=0; B=0;
#12 rst=0;
// Addition
A=4'd3; B=4'd2; op=0; start=1;
#40;
start=0;
#20;
// Subtraction
A=4'd8; B=4'd5; op=1; start=1;
#40;
start=0;
#30;
$finish;
end
endmodule
