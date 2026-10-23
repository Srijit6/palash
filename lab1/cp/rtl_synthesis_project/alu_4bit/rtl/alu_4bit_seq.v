// =============================================================
// Module      : alu_4bit_seq
// Description : 4-bit Sequential ALU. Result, Carry-out and
//               Zero flag are registered (clocked) outputs so
//               the design has real sequential timing paths
//               (clk-to-Q, setup/hold) for Genus to analyze.
//
// Opcode map  :
//   000 - ADD     A + B
//   001 - SUB     A - B
//   010 - AND     A & B
//   011 - OR      A | B
//   100 - XOR     A ^ B
//   101 - NOT     ~A
//   110 - SHL     A << 1
//   111 - SHR     A >> 1
// =============================================================
module alu_4bit_seq (
    input  wire       clk,
    input  wire       rst_n,     // active-low async reset
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire [2:0] opcode,
    output reg  [3:0] Result,
    output reg        Cout,
    output reg        Zero
);

    localparam ADD    = 3'b000,
               SUB    = 3'b001,
               AND_OP = 3'b010,
               OR_OP  = 3'b011,
               XOR_OP = 3'b100,
               NOT_OP = 3'b101,
               SHL    = 3'b110,
               SHR    = 3'b111;

    reg [4:0] alu_temp;   // alu_temp[4]=carry/shifted-out bit, alu_temp[3:0]=result

    always @(*) begin
        // Default assignment: prevents inferred latches AND guarantees
        // alu_temp always has a full, statically-known 5-bit driver.
        alu_temp = 5'b00000;

        case (opcode)
            // Both operands explicitly zero-extended to 5 bits BEFORE the
            // operator runs, so the RHS is a static 5-bit expression and
            // never depends on implicit LHS-context sizing.
            ADD:     alu_temp = {1'b0, A} + {1'b0, B};
            SUB:     alu_temp = {1'b0, A} - {1'b0, B};
            AND_OP:  alu_temp = {1'b0, (A & B)};
            OR_OP:   alu_temp = {1'b0, (A | B)};
            XOR_OP:  alu_temp = {1'b0, (A ^ B)};
            NOT_OP:  alu_temp = {1'b0, (~A)};
            // alu_temp[4] captures the bit shifted out; alu_temp[3:0] is
            // the shifted result. Each concatenation is a fixed 5 bits.
            SHL:     alu_temp = {A[3], A[2:0], 1'b0};
            SHR:     alu_temp = {A[0], 1'b0, A[3:1]};
            default: alu_temp = 5'b00000;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Result <= 4'b0000;
            Cout   <= 1'b0;
            Zero   <= 1'b0;
        end else begin
            Result <= alu_temp[3:0];
            Cout   <= alu_temp[4];
            Zero   <= (alu_temp[3:0] == 4'b0000);
        end
    end

endmodule
