
//input ports
add mapped point clk clk -type PI PI
add mapped point rst rst -type PI PI
add mapped point sample_valid sample_valid -type PI PI
add mapped point xin[7] xin[7] -type PI PI
add mapped point xin[6] xin[6] -type PI PI
add mapped point xin[5] xin[5] -type PI PI
add mapped point xin[4] xin[4] -type PI PI
add mapped point xin[3] xin[3] -type PI PI
add mapped point xin[2] xin[2] -type PI PI
add mapped point xin[1] xin[1] -type PI PI
add mapped point xin[0] xin[0] -type PI PI

//output ports
add mapped point sample_ready sample_ready -type PO PO
add mapped point yout_valid yout_valid -type PO PO
add mapped point yout[17] yout[17] -type PO PO
add mapped point yout[16] yout[16] -type PO PO
add mapped point yout[15] yout[15] -type PO PO
add mapped point yout[14] yout[14] -type PO PO
add mapped point yout[13] yout[13] -type PO PO
add mapped point yout[12] yout[12] -type PO PO
add mapped point yout[11] yout[11] -type PO PO
add mapped point yout[10] yout[10] -type PO PO
add mapped point yout[9] yout[9] -type PO PO
add mapped point yout[8] yout[8] -type PO PO
add mapped point yout[7] yout[7] -type PO PO
add mapped point yout[6] yout[6] -type PO PO
add mapped point yout[5] yout[5] -type PO PO
add mapped point yout[4] yout[4] -type PO PO
add mapped point yout[3] yout[3] -type PO PO
add mapped point yout[2] yout[2] -type PO PO
add mapped point yout[1] yout[1] -type PO PO
add mapped point yout[0] yout[0] -type PO PO

//inout ports




//Sequential Pins
add mapped point yout_valid/q yout_valid_reg/Q -type DFF DFF
add mapped point accumulator[0]/q accumulator_reg[0]/Q -type DFF DFF
add mapped point accumulator[1]/q accumulator_reg[1]/Q -type DFF DFF
add mapped point accumulator[2]/q accumulator_reg[2]/Q -type DFF DFF
add mapped point accumulator[3]/q accumulator_reg[3]/Q -type DFF DFF
add mapped point accumulator[4]/q accumulator_reg[4]/Q -type DFF DFF
add mapped point accumulator[5]/q accumulator_reg[5]/Q -type DFF DFF
add mapped point accumulator[6]/q accumulator_reg[6]/Q -type DFF DFF
add mapped point accumulator[7]/q accumulator_reg[7]/Q -type DFF DFF
add mapped point accumulator[8]/q accumulator_reg[8]/Q -type DFF DFF
add mapped point accumulator[9]/q accumulator_reg[9]/Q -type DFF DFF
add mapped point accumulator[10]/q accumulator_reg[10]/Q -type DFF DFF
add mapped point accumulator[11]/q accumulator_reg[11]/Q -type DFF DFF
add mapped point accumulator[12]/q accumulator_reg[12]/Q -type DFF DFF
add mapped point accumulator[13]/q accumulator_reg[13]/Q -type DFF DFF
add mapped point accumulator[14]/q accumulator_reg[14]/Q -type DFF DFF
add mapped point accumulator[15]/q accumulator_reg[15]/Q -type DFF DFF
add mapped point accumulator[16]/q accumulator_reg[16]/Q -type DFF DFF
add mapped point accumulator[17]/q accumulator_reg[17]/Q -type DFF DFF
add mapped point s0[0]/q s0_reg[0]/Q -type DFF DFF
add mapped point s0[1]/q s0_reg[1]/Q -type DFF DFF
add mapped point s0[2]/q s0_reg[2]/Q -type DFF DFF
add mapped point s0[3]/q s0_reg[3]/Q -type DFF DFF
add mapped point s0[4]/q s0_reg[4]/Q -type DFF DFF
add mapped point s0[5]/q s0_reg[5]/Q -type DFF DFF
add mapped point s0[6]/q s0_reg[6]/Q -type DFF DFF
add mapped point s0[7]/q s0_reg[7]/Q -type DFF DFF
add mapped point s1[0]/q s1_reg[0]/Q -type DFF DFF
add mapped point s1[1]/q s1_reg[1]/Q -type DFF DFF
add mapped point s1[2]/q s1_reg[2]/Q -type DFF DFF
add mapped point s1[3]/q s1_reg[3]/Q -type DFF DFF
add mapped point s1[4]/q s1_reg[4]/Q -type DFF DFF
add mapped point s1[5]/q s1_reg[5]/Q -type DFF DFF
add mapped point s1[6]/q s1_reg[6]/Q -type DFF DFF
add mapped point s1[7]/q s1_reg[7]/Q -type DFF DFF
add mapped point s2[0]/q s2_reg[0]/Q -type DFF DFF
add mapped point s2[1]/q s2_reg[1]/Q -type DFF DFF
add mapped point s2[2]/q s2_reg[2]/Q -type DFF DFF
add mapped point s2[3]/q s2_reg[3]/Q -type DFF DFF
add mapped point s2[4]/q s2_reg[4]/Q -type DFF DFF
add mapped point s2[5]/q s2_reg[5]/Q -type DFF DFF
add mapped point s2[6]/q s2_reg[6]/Q -type DFF DFF
add mapped point s2[7]/q s2_reg[7]/Q -type DFF DFF
add mapped point s3[0]/q s3_reg[0]/Q -type DFF DFF
add mapped point s3[1]/q s3_reg[1]/Q -type DFF DFF
add mapped point s3[2]/q s3_reg[2]/Q -type DFF DFF
add mapped point s3[3]/q s3_reg[3]/Q -type DFF DFF
add mapped point s3[4]/q s3_reg[4]/Q -type DFF DFF
add mapped point s3[5]/q s3_reg[5]/Q -type DFF DFF
add mapped point s3[6]/q s3_reg[6]/Q -type DFF DFF
add mapped point s3[7]/q s3_reg[7]/Q -type DFF DFF
add mapped point state[0]/q state_reg[0]/Q -type DFF DFF
add mapped point state[1]/q state_reg[1]/Q -type DFF DFF
add mapped point state[2]/q state_reg[2]/Q -type DFF DFF
add mapped point yout[0]/q yout_reg[0]/Q -type DFF DFF
add mapped point yout[1]/q yout_reg[1]/Q -type DFF DFF
add mapped point yout[2]/q yout_reg[2]/Q -type DFF DFF
add mapped point yout[3]/q yout_reg[3]/Q -type DFF DFF
add mapped point yout[4]/q yout_reg[4]/Q -type DFF DFF
add mapped point yout[5]/q yout_reg[5]/Q -type DFF DFF
add mapped point yout[6]/q yout_reg[6]/Q -type DFF DFF
add mapped point yout[7]/q yout_reg[7]/Q -type DFF DFF
add mapped point yout[8]/q yout_reg[8]/Q -type DFF DFF
add mapped point yout[9]/q yout_reg[9]/Q -type DFF DFF
add mapped point yout[10]/q yout_reg[10]/Q -type DFF DFF
add mapped point yout[11]/q yout_reg[11]/Q -type DFF DFF
add mapped point yout[12]/q yout_reg[12]/Q -type DFF DFF
add mapped point yout[13]/q yout_reg[13]/Q -type DFF DFF
add mapped point yout[14]/q yout_reg[14]/Q -type DFF DFF
add mapped point yout[15]/q yout_reg[15]/Q -type DFF DFF
add mapped point yout[16]/q yout_reg[16]/Q -type DFF DFF
add mapped point yout[17]/q yout_reg[17]/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
