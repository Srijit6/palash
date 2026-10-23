//--------------------------------------
// Datapath
//--------------------------------------
module datapath(
input clk,
input rst,
input load,
input execute,
input op,
input [3:0] A,
input [3:0] B,
output reg [4:0] Y
);
reg [3:0] regA;
reg [3:0] regB;
always @(posedge clk or posedge rst) begin
if(rst) begin
    regA<=0;
    regB<=0;
    Y<=0;
end else begin
    if(load) begin
        regA<=A;
        regB<=B;
    end
    if(execute) begin
        if(op)
            Y<=regA-regB;
        else
            Y<=regA+regB;
    end
end
end
endmodule
