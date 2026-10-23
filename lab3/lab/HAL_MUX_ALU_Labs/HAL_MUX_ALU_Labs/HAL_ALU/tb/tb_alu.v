`timescale 1ns/1ps
module tb_alu;
reg [3:0] a,b; reg [1:0] op; wire [3:0] y;
alu_bad dut(.a(a),.b(b),.op(op),.y(y));
initial begin
a=5;b=2;op=0;#10;op=1;#10;op=2;#10;$finish;
end
endmodule
