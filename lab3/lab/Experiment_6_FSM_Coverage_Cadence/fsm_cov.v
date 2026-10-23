//----------------------------------------------------
// FSM Coverage Example
//----------------------------------------------------

module fsm_cov(
input clk,
input rst,
input x,
output reg y
);

parameter S0=2'd0,S1=2'd1,S2=2'd2;

reg [1:0] state,next;

always @(posedge clk) begin
    if(rst)
        state <= S0;
    else
        state <= next;
end

always @(*) begin
    case(state)
        S0: if(x) next=S1; else next=S0;
        S1: if(x) next=S2; else next=S0;
        S2: next=S0;
        default: next=S0;
    endcase
end

always @(*)
    y = (state==S2);

endmodule
