module alu_good #(
    // FIX for Images 1 & 2: Replaced hardcoded [3:0] and [1:0] with parameters to resolve the 4 STYVAL warnings.
    parameter DATA_WIDTH = 4,
    parameter OP_WIDTH = 2
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH-1:0] a,
    input wire [DATA_WIDTH-1:0] b,
    input wire [OP_WIDTH-1:0] op,
    output reg [DATA_WIDTH-1:0] y
);

// Parameters to eliminate STYVAL (Hardcoded literal) warnings
localparam [OP_WIDTH-1:0] OP_ADD = 2'b00;
localparam [OP_WIDTH-1:0] OP_SUB = 2'b01;
localparam [OP_WIDTH-1:0] OP_AND = 2'b10;

localparam [DATA_WIDTH-1:0] MASK = 4'b1111;
localparam [DATA_WIDTH-1:0] ZERO = 4'b0000;

always @(posedge clk or negedge rst_n) begin : alu_proc
    if (!rst_n) begin
        y <= ZERO;
    end else begin
        case (op)
            // FIX for Image 4 (Line 23): Moved comment to a new line to resolve MAXLEN warning (84 chars > 80 limit)
            // MASK avoids POIAS6 overflow warning
            OP_ADD: y <= (a + b) & MASK; 
            
            OP_SUB: y <= (a - b) & MASK;
            OP_AND: y <= a & b;
            
            // FIX for Image 4 (Line 26): Moved comment to a new line to resolve MAXLEN warning (86 chars > 80 limit)
            // Handles OP_OR (2'b11) to avoid CDEFCV
            default: y <= a | b;       
        endcase
    end
end
endmodule
