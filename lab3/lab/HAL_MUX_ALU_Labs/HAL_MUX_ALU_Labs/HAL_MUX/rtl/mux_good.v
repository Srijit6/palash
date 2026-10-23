module mux_good(input [3:0] a,b,input sel,output reg [3:0] y);
always @(*) begin
 y=b;
 if(sel) y=a;
end
endmodule
