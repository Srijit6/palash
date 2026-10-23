//--------------------------------------
// Controller
//--------------------------------------
module controller(
input clk,
input rst,
input start,
output reg load,
output reg execute,
output reg done
);
parameter IDLE=2'd0,
          LOAD=2'd1,
          EXECUTE=2'd2,
          DONE=2'd3;
reg [1:0] state,next_state;
always @(posedge clk or posedge rst)
begin
if(rst) state<=IDLE;
else state<=next_state;
end
always @(*) begin
case(state)
IDLE: if(start) next_state=LOAD; else next_state=IDLE;
LOAD: next_state=EXECUTE;
EXECUTE: next_state=DONE;
DONE: if(!start) next_state=IDLE; else next_state=DONE;
default: next_state=IDLE;
endcase
end
always @(*) begin
load=0; execute=0; done=0;
case(state)
LOAD: load=1;
EXECUTE: execute=1;
DONE: done=1;
endcase
end
endmodule
