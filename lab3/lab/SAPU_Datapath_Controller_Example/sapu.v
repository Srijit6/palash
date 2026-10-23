//--------------------------------------
// Top Module
//--------------------------------------
module sapu(
input clk,
input rst,
input start,
input op,
input [3:0] A,
input [3:0] B,
output [4:0] Y,
output done
);
wire load;
wire execute;
controller CU(
.clk(clk),.rst(rst),.start(start),
.load(load),.execute(execute),.done(done)
);
datapath DP(
.clk(clk),.rst(rst),
.load(load),.execute(execute),
.op(op),.A(A),.B(B),.Y(Y)
);
endmodule
