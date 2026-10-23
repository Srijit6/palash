//----------------------------------------------------
// Toggle Coverage Example
//----------------------------------------------------

module toggle_cov(
input clk,
input d,
output reg q
);

always @(posedge clk)
    q <= d;

endmodule
