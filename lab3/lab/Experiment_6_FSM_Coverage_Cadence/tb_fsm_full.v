
module tb_fsm_full;

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

    // S0->S1
    x=1;
    #10;

    // S1->S2
    x=1;
    #10;

    // S2->S0
    x=0;
    #10;

    // S0 stay
    x=0;
    #10;

    $finish;
end

endmodule
