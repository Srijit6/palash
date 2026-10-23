

module tb_seq_detector_101;

    reg clk, rst_n, din;
    wire dout;

    seq_detector_101 uut (
        .clk(clk), .rst_n(rst_n), .din(din),
        .dout(dout)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0; din = 0;
        
        // Assert reset to enter IDLE
        #15; 
        rst_n = 1;

        // Sequence designed to traverse every single FSM arc:
        
        // 1. IDLE -> IDLE
        @(posedge clk) din = 0; 
        
        // 2. IDLE -> S1
        @(posedge clk) din = 1; 
        
        // 3. S1 -> S1
        @(posedge clk) din = 1; 
        
        // 4. S1 -> S10
        @(posedge clk) din = 0; 
        
        // 5. S10 -> IDLE
        @(posedge clk) din = 0; 
        
        // Navigate back to S10 to test the final arc
        @(posedge clk) din = 1; // IDLE -> S1
        @(posedge clk) din = 0; // S1 -> S10
        
        // 6. S10 -> S1 (Detects '101' - Overlapping)
        @(posedge clk) din = 1; 

        // Wait a couple of clocks to observe final output
        #20;
        $finish;
    end

endmodule
