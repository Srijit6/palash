// =============================================================
// Module      : rca_4bit
// Description : 4-bit Ripple Carry Adder
//               Structural modeling - instantiates 4 full_adder
//               cells and chains the carry ripple.
// =============================================================
module rca_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] Sum,
    output wire       Cout
);

    wire c1, c2, c3;   // internal ripple-carry nets

    full_adder FA0 (.a(A[0]), .b(B[0]), .cin(Cin), .sum(Sum[0]), .cout(c1));
    full_adder FA1 (.a(A[1]), .b(B[1]), .cin(c1),  .sum(Sum[1]), .cout(c2));
    full_adder FA2 (.a(A[2]), .b(B[2]), .cin(c2),  .sum(Sum[2]), .cout(c3));
    full_adder FA3 (.a(A[3]), .b(B[3]), .cin(c3),  .sum(Sum[3]), .cout(Cout));

endmodule
