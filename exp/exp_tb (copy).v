`timescale 1ns / 1ps

module exp_tb;
    reg [7:0] a, b, c, d;
    wire [9:0] y;

    // Instantiate the Unit Under Test (UUT)
    exp uut (
        .a(a), 
        .b(b), 
        .c(c), 
        .d(d), 
        .y(y)
    );

    initial begin
        $display("Time |   a   +   b   +   c   +   d   | y (Decimal) | y (Binary)");
        $display("-------------------------------------------------------------------");
        
        // Test Case 1: Standard addition
        a = 8'd10; b = 8'd20; c = 8'd30; d = 8'd40; #10; 
        $display("%4t | %3d + %3d + %3d + %3d | %4d        | %10b", $time, a, b, c, d, y, y);
        
        // Test Case 2: Maximum possible addition to test the 10th bit (1020)
        a = 8'd255; b = 8'd255; c = 8'd255; d = 8'd255; #10; 
        $display("%4t | %3d + %3d + %3d + %3d | %4d        | %10b", $time, a, b, c, d, y, y);

        // Test Case 3: Mid-range addition
        a = 8'd128; b = 8'd128; c = 8'd128; d = 8'd128; #10; 
        $display("%4t | %3d + %3d + %3d + %3d | %4d        | %10b", $time, a, b, c, d, y, y);
        
        #10 $finish;
    end
endmodule
