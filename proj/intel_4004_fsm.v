`timescale 1ns / 1ps
module intel_4004_fsm (
    input wire clk,
    input wire reset,
    input wire [7:0] ir_in,
    output reg [3:0] alu_op,
    output reg acc_ld,
    output reg pc_inc,
    output reg ir_ld,
    output reg [2:0] cycle_state
);
    parameter NOP = 8'h00;
    parameter JUN = 8'h40;
    parameter ADD = 8'h80;
    parameter SUB = 8'h90;

    parameter A1=0, A2=1, A3=2, M1=3, M2=4, X1=5, X2=6, X3=7;

    reg [2:0] current_state, next_state;
    reg is_jumping;

    // --- 1. Sequential State Tracker ---
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A1;
            cycle_state <= A1;
            is_jumping <= 0;
        end else begin
            current_state <= next_state;
            cycle_state <= next_state;
            
            // Jump Flag Management
            if (current_state == X1 && ir_in == JUN) 
                is_jumping <= 1;
            else if (current_state == X3) 
                is_jumping <= 0;
        end
    end

    // --- 2. Combinatorial Output Decoder ---
    always @(*) begin
        // Default idle states
        alu_op = 4'b1111; 
        acc_ld = 0;
        pc_inc = 0;
        ir_ld = 0;
        next_state = current_state;

        case (current_state)
            A1: next_state = A2;
            A2: next_state = A3;
            A3: next_state = M1;
            M1: begin
                ir_ld = 1;
                next_state = M2;
            end
            M2: begin
                ir_ld = 1;
                next_state = X1;
            end
            X1: begin
                if (!is_jumping) begin
                    case (ir_in)
                        ADD: begin alu_op = 4'b0000; acc_ld = 1; end
                        SUB: begin alu_op = 4'b0001; acc_ld = 1; end
                    endcase
                    pc_inc = 1; // Proceed to next instruction
                end
                next_state = X2;
            end
            X2: next_state = X3;
            X3: next_state = A1;
        endcase
    end
endmodule
