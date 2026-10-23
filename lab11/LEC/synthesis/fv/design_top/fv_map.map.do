
//input ports
add mapped point clk clk -type PI PI
add mapped point rst_n rst_n -type PI PI
add mapped point sel sel -type PI PI
add mapped point a[7] a[7] -type PI PI
add mapped point a[6] a[6] -type PI PI
add mapped point a[5] a[5] -type PI PI
add mapped point a[4] a[4] -type PI PI
add mapped point a[3] a[3] -type PI PI
add mapped point a[2] a[2] -type PI PI
add mapped point a[1] a[1] -type PI PI
add mapped point a[0] a[0] -type PI PI
add mapped point b[7] b[7] -type PI PI
add mapped point b[6] b[6] -type PI PI
add mapped point b[5] b[5] -type PI PI
add mapped point b[4] b[4] -type PI PI
add mapped point b[3] b[3] -type PI PI
add mapped point b[2] b[2] -type PI PI
add mapped point b[1] b[1] -type PI PI
add mapped point b[0] b[0] -type PI PI
add mapped point c[7] c[7] -type PI PI
add mapped point c[6] c[6] -type PI PI
add mapped point c[5] c[5] -type PI PI
add mapped point c[4] c[4] -type PI PI
add mapped point c[3] c[3] -type PI PI
add mapped point c[2] c[2] -type PI PI
add mapped point c[1] c[1] -type PI PI
add mapped point c[0] c[0] -type PI PI

//output ports
add mapped point y[8] y[8] -type PO PO
add mapped point y[7] y[7] -type PO PO
add mapped point y[6] y[6] -type PO PO
add mapped point y[5] y[5] -type PO PO
add mapped point y[4] y[4] -type PO PO
add mapped point y[3] y[3] -type PO PO
add mapped point y[2] y[2] -type PO PO
add mapped point y[1] y[1] -type PO PO
add mapped point y[0] y[0] -type PO PO

//inout ports




//Sequential Pins
add mapped point y[7]/q y_reg[7]/Q -type DFF DFF
add mapped point y[6]/q y_reg[6]/Q -type DFF DFF
add mapped point y[8]/q y_reg[8]/Q -type DFF DFF
add mapped point y[5]/q y_reg[5]/Q -type DFF DFF
add mapped point y[4]/q y_reg[4]/Q -type DFF DFF
add mapped point y[3]/q y_reg[3]/Q -type DFF DFF
add mapped point y[2]/q y_reg[2]/Q -type DFF DFF
add mapped point y[1]/q y_reg[1]/Q -type DFF DFF
add mapped point y[0]/q y_reg[0]/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
