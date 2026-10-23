`timescale 1ns / 1ps
module intel_4004_datapath (
    input wire clk,
    input wire reset,
    inout wire [3:0] d_bus,
    output reg [7:0] ir_out,
    input wire [3:0] alu_op,
    input wire acc_ld,
    input wire pc_inc,
    input wire ir_ld,
    input wire [2:0] cycle_state
);
    reg [11:0] active_pc;
    reg [3:0] acc_reg;
    reg [3:0] temp_reg;
    reg [3:0] alu_result;
    
    reg [3:0] d_bus_out;
    reg drive_bus;

    // Tri-state buffer for bidirectional bus
    assign d_bus = drive_bus ? d_bus_out : 4'bz;

    // --- Combinatorial ALU ---
    always @(*) begin
        case (alu_op)
            4'b0000: alu_result = acc_reg + temp_reg; // ADD
            4'b0001: alu_result = acc_reg - temp_reg; // SUB
            default: alu_result = 4'b0000;
        endcase
    end

    // --- Combinatorial Bus Driver (Instantly follows state) ---
    always @(*) begin
        drive_bus = 0;
        d_bus_out = 4'b0000;
        
        if (cycle_state == 0) begin // A1
            drive_bus = 1; d_bus_out = active_pc[3:0];
        end else if (cycle_state == 1) begin // A2
            drive_bus = 1; d_bus_out = active_pc[7:4];
        end else if (cycle_state == 2) begin // A3
            drive_bus = 1; d_bus_out = active_pc[11:8];
        end
    end

    // --- Sequential Registers ---
    always @(posedge clk) begin
        if (reset) begin
            active_pc <= 12'b0;
            acc_reg <= 4'b0;
            temp_reg <= 4'b0011; // Hardcoded to 3 to verify math
            ir_out <= 8'b0;
        end else begin
            if (pc_inc) active_pc <= active_pc + 1;
            if (acc_ld) acc_reg <= alu_result;
            
            // Rebuild the 8-bit instruction across M1 and M2
            if (ir_ld && cycle_state == 3) ir_out[7:4] <= d_bus; 
            if (ir_ld && cycle_state == 4) ir_out[3:0] <= d_bus; 
        end
    end
endmodule
