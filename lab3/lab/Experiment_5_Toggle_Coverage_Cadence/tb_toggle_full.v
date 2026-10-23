`timescale 1ns/1ps

module tb_toggle_full;

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

    d=0;
    #10;

    d=1;
    #10;

    d=0;
    #10;

    $finish;
end

endmodule
