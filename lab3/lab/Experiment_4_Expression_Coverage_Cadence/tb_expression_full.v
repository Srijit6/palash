`timescale 1ns/1ps

module tb_expression_full;

reg a,b,c;
wire y;

expression_cov dut(
.a(a),
.b(b),
.c(c),
.y(y)
);

initial begin
    // Expression = 1
    a=1; b=0; c=1;
    #10;

    // Expression = 0
    a=0; b=0; c=1;
    #10;

    // Expression = 0
    a=1; b=0; c=0;
    #10;

    $finish;
end

endmodule
