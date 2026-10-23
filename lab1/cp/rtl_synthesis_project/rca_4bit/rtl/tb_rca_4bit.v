// =============================================================
// Testbench : tb_rca_4bit
// Purpose   : Quick functional sanity check (optional - run in
//             any Verilog simulator before synthesis).
// =============================================================
`timescale 1ns/1ps

module tb_rca_4bit;

    reg  [3:0] A, B;
    reg        Cin;
    wire [3:0] Sum;
    wire       Cout;

    rca_4bit DUT (.A(A), .B(B), .Cin(Cin), .Sum(Sum), .Cout(Cout));

    initial begin
        $display(" A    B   Cin | Sum  Cout");
        A = 4'h0; B = 4'h0; Cin = 0; #10; print_result;
        A = 4'h3; B = 4'h5; Cin = 0; #10; print_result;
        A = 4'hF; B = 4'h1; Cin = 0; #10; print_result;
        A = 4'hF; B = 4'hF; Cin = 1; #10; print_result;
        A = 4'hA; B = 4'h5; Cin = 1; #10; print_result;
        $finish;
    end

    task print_result;
        begin
            $display("%b %b  %b   | %b   %b", A, B, Cin, Sum, Cout);
        end
    endtask

endmodule
