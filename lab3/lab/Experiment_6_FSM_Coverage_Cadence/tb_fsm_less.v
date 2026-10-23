
module tb_fsm_less;

reg clk,rst,x;
wire y;

fsm_cov dut(.clk(clk),.rst(rst),.x(x),.y(y));

always #5 clk=~clk;

initial begin
    clk=0;
    rst=1;
    x=0;
    #10;
    rst=0;
    x=0;
    #20;
    $finish;
end

endmodule
