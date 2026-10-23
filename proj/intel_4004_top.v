`timescale 1ns / 1ps
module intel_4004_top (
    input wire clk,
    input wire reset,
    inout wire [3:0] d_bus
);
    wire [7:0] ir_wire;
    wire [3:0] alu_op;
    wire acc_ld;
    wire pc_inc;
    wire ir_ld;
    wire [2:0] cycle_state;

    intel_4004_fsm control_inst (
        .clk(clk),
        .reset(reset),
        .ir_in(ir_wire),
        .alu_op(alu_op),
        .acc_ld(acc_ld),
        .pc_inc(pc_inc),
        .ir_ld(ir_ld),
        .cycle_state(cycle_state)
    );

    intel_4004_datapath datapath_inst (
        .clk(clk),
        .reset(reset),
        .d_bus(d_bus),
        .ir_out(ir_wire),
        .alu_op(alu_op),
        .acc_ld(acc_ld),
        .pc_inc(pc_inc),
        .ir_ld(ir_ld),
        .cycle_state(cycle_state)
    );
endmodule
