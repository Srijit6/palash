
//input ports
add mapped point clk clk -type PI PI
add mapped point rst_n rst_n -type PI PI
add mapped point A[3] A[3] -type PI PI
add mapped point A[2] A[2] -type PI PI
add mapped point A[1] A[1] -type PI PI
add mapped point A[0] A[0] -type PI PI
add mapped point B[3] B[3] -type PI PI
add mapped point B[2] B[2] -type PI PI
add mapped point B[1] B[1] -type PI PI
add mapped point B[0] B[0] -type PI PI
add mapped point opcode[2] opcode[2] -type PI PI
add mapped point opcode[1] opcode[1] -type PI PI
add mapped point opcode[0] opcode[0] -type PI PI

//output ports
add mapped point Result[3] Result[3] -type PO PO
add mapped point Result[2] Result[2] -type PO PO
add mapped point Result[1] Result[1] -type PO PO
add mapped point Result[0] Result[0] -type PO PO
add mapped point Cout Cout -type PO PO
add mapped point Zero Zero -type PO PO

//inout ports




//Sequential Pins
add mapped point Zero/q Zero_reg/Q -type DFF DFF
add mapped point Cout/q Cout_reg/Q -type DFF DFF
add mapped point Result[3]/q Result_reg[3]/Q -type DFF DFF
add mapped point Result[2]/q Result_reg[2]/Q -type DFF DFF
add mapped point Result[1]/q Result_reg[1]/Q -type DFF DFF
add mapped point Result[0]/q Result_reg[0]/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
