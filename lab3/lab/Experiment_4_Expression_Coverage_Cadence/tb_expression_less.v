`timescale 1ns/1ps

module tb_expression_less;

reg a,b,c;
wire y;

expression_cov dut(
.a(a),
.b(b),
.c(c),
.y(y)
);

initial begin
    a=1; b=0; c=1;
    #10;
    $finish;
end

endmodule
