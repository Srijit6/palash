// =============================================================
// Testbench : tb_alu_4bit_seq
// Purpose   : Quick functional sanity check (optional - run in
//             any Verilog simulator before synthesis).
// =============================================================
`timescale 1ns/1ps

module tb_alu_4bit_seq;

    reg        clk, rst_n;
    reg  [3:0] A, B;
    reg  [2:0] opcode;
    wire [3:0] Result;
    wire       Cout, Zero;

    alu_4bit_seq DUT (
        .clk(clk), .rst_n(rst_n),
        .A(A), .B(B), .opcode(opcode),
        .Result(Result), .Cout(Cout), .Zero(Zero)
    );

    always #5 clk = ~clk;   // 10 ns clock period

    initial begin
        clk = 0; rst_n = 0; A = 0; B = 0; opcode = 0;
        #12 rst_n = 1;

        A = 4'h3; B = 4'h4; opcode = 3'b000; #10; // ADD
        A = 4'h9; B = 4'h2; opcode = 3'b001; #10; // SUB
        A = 4'hC; B = 4'hA; opcode = 3'b010; #10; // AND
        A = 4'hC; B = 4'hA; opcode = 3'b011; #10; // OR
        A = 4'hC; B = 4'hA; opcode = 3'b100; #10; // XOR
        A = 4'h5; B = 4'h0; opcode = 3'b101; #10; // NOT
        A = 4'h5; B = 4'h0; opcode = 3'b110; #10; // SHL
        A = 4'h5; B = 4'h0; opcode = 3'b111; #10; // SHR

        $finish;
    end

    initial begin
        $monitor("t=%0t opcode=%b A=%h B=%h -> Result=%h Cout=%b Zero=%b",
                  $time, opcode, A, B, Result, Cout, Zero);
    end

endmodule
