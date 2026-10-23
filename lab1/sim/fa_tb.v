
module fa_tb();
reg a_tb,b_tb,cin_tb;
wire sum_tb, cout_tb;
fa uut(.sum(sum_tb),.cout(cout_tb),.a(a_tb),.b(b_tb),.cin(cin_tb));
initial begin
$monitor("%0t ns a=%0b b=%0b c=%0b sum=%0b cout=%0b",$time,a_tb,b_tb,cin_tb,sum_tb,cout_tb);
a_tb=1'b0;b_tb=1'b0;cin_tb=1'b0;#10;
a_tb=1'b1;b_tb=1'b0;cin_tb=1'b0;#10;
a_tb=1'b0;b_tb=1'b1;cin_tb=1'b0;#10;
a_tb=1'b0;b_tb=1'b0;cin_tb=1'b1;#10;
$finish;
end 
endmodule
