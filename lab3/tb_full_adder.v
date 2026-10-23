

module tb_full_adder_low_cov;

    reg a, b, cin;
    wire sum, cout;

    full_adder uut (
        .a(a), .b(b), .cin(cin),
        .sum(sum), .cout(cout)
    );

    initial begin
        // 1. Initial State
        {a, b, cin} = 3'b000; #10; 
        
        // 2. Only toggle cin
        {a, b, cin} = 3'b001; #10;
        
        // 3. Toggle cin back to 0
        {a, b, cin} = 3'b000; #10;
        
        $finish;
    end

endmodule
