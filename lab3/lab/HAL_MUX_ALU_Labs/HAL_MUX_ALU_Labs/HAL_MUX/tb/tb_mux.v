`timescale 1ns/1ps
module tb_mux;
reg [3:0] a,b; reg sel; wire [3:0] y;
mux_bad dut(.a(a),.b(b),.sel(sel),.y(y));
initial begin
a=3;b=8;sel=0;#10;sel=1;#10;a=5;#10;b=12;#10;sel=0;#10;$finish;
end
endmodule
