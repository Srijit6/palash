

module tb_sop_pos;

    reg [3:0] in;
    wire y_sop, y_pos;

    sop_pos_4bit uut (
        .in(in),
        .y_sop(y_sop), .y_pos(y_pos)
    );

    initial begin
        // 1. Initial State
        in = 4'b0000; #10;
        
        // 2. Toggle only in[3] (Bit A)
        in = 4'b1000; #10; 
        
        // 3. Toggle in[3] back to 0
        in = 4'b0000; #10;
        
        $finish;
    end

endmodule
