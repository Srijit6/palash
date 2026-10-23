//----------------------------------------------------
// Expression Coverage Example
//----------------------------------------------------

module expression_cov(
input a,
input b,
input c,
output y
);

assign y = (a | b) & c;

endmodule
