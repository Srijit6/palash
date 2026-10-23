module exp (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    input  wire [7:0] d,
    output wire [9:0] y
);

    // Summing four 8-bit inputs with a 10-bit output to prevent overflow
    assign y = a + b + c + d;

endmodule
