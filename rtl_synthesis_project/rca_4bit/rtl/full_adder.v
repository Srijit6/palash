// =============================================================
// Module      : full_adder
// Description : 1-bit Full Adder built with primitive gates
//               (structural / gate-level modeling)
// =============================================================
module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);

    wire w1, w2, w3;

    xor (w1, a, b);        // a XOR b
    xor (sum, w1, cin);    // (a XOR b) XOR cin

    and (w2, a, b);        // a AND b
    and (w3, w1, cin);     // (a XOR b) AND cin
    or  (cout, w2, w3);    // carry out

endmodule
