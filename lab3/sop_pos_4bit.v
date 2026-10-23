module sop_pos_4bit (
    input  wire [3:0] in, // in[3]=A, in[2]=B, in[1]=C, in[0]=D
    output wire y_sop,
    output wire y_pos
);

    // Sum of Products: (A AND B) OR (C AND D)
    assign y_sop = (in[3] & in[2]) | (in[1] & in[0]);
    
    // Product of Sums: (A OR B) AND (C OR D)
    assign y_pos = (in[3] | in[2]) & (in[1] | in[0]);

endmodule
