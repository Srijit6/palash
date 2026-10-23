module rca_4bit_tb();
    reg [3:0] A_tb, B_tb;
    reg Cin_tb;
    wire [3:0] Sum_tb;
    wire Cout_tb;

    ripple_carry_adder_4bit uut (
        .A(A_tb),
        .B(B_tb),
        .Cin(Cin_tb),
        .Sum(Sum_tb),
        .Cout(Cout_tb)
    );

    initial begin
        $monitor("Time=%0t | A=%b B=%b Cin=%b | Sum=%b Cout=%b", 
                 $time, A_tb, B_tb, Cin_tb, Sum_tb, Cout_tb);
        
        A_tb = 4'b0010; B_tb = 4'b0100; Cin_tb = 1'b0; #10;
        A_tb = 4'b1111; B_tb = 4'b0001; Cin_tb = 1'b0; #10;
        A_tb = 4'b0110; B_tb = 4'b0011; Cin_tb = 1'b1; #10;
        A_tb = 4'b1111; B_tb = 4'b1111; Cin_tb = 1'b1; #10;
        $finish;
    end
endmodule
