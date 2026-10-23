module mac_pipelined (
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] out
);
    // Pipeline Registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] mult_reg;
    reg [15:0] acc_reg;

    // Stage 1: Input Registering (Good for input delay timing constraints)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'd0;
            b_reg <= 8'd0;
        end else if (en) begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Stage 2: Multiplier (Deep logic - will be your critical setup path)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mult_reg <= 16'd0;
        end else if (en) begin
            mult_reg <= a_reg * b_reg;
        end
    end

    // Stage 3: Accumulator & Output Register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_reg <= 16'd0;
            out     <= 16'd0;
        end else if (en) begin
            acc_reg <= acc_reg + mult_reg;
            out     <= acc_reg + mult_reg;
        end
    end
endmodule
