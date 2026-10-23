`timescale 1ns/1ps

module tb_toggle_less;

reg clk,d;
wire q;

toggle_cov dut(
.clk(clk),
.d(d),
.q(q)
);

always #5 clk=~clk;

initial begin
    clk=0;
    d=1;
    #20;
    $finish;
end

endmodule
