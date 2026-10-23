`timescale 1ns/1ps

module tb_mac_pipelined;
    reg clk;
    reg rst_n;
    reg en;
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] out;

    // Instantiate the Unit Under Test (UUT)
    mac_pipelined uut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .a(a),
        .b(b),
        .out(out)
    );

    // Generate a 4.0ns Clock (250 MHz)
    always #2.0 clk = ~clk;

    initial begin
        // Dump waves for SimVision
        $dumpfile("mac_waves.vcd");
        $dumpvars(0, tb_mac_pipelined);

        // Initialize Inputs
        clk = 0; rst_n = 0; en = 0; a = 0; b = 0;

        // Apply Reset
        #5.0 rst_n = 1;
        
        // Feed pipeline data
        @(posedge clk) begin en = 1; a = 8'd5;  b = 8'd4;  end // 5 * 4 = 20
        @(posedge clk) begin en = 1; a = 8'd10; b = 8'd2;  end // 10 * 2 = 20 (Acc = 40)
        @(posedge clk) begin en = 1; a = 8'd3;  b = 8'd3;  end // 3 * 3 = 9   (Acc = 49)
        @(posedge clk) begin en = 1; a = 8'd0;  b = 8'd0;  end

        // Wait for pipeline to flush out results
        #15.0 en = 0;
        #20.0 $finish;
    end
endmodule
