module seq_detector_101 (
    input  wire clk,
    input  wire rst_n,
    input  wire din,
    output reg  dout
);

    parameter IDLE = 2'b00;
    parameter S1   = 2'b01;
    parameter S10  = 2'b10;

    reg [1:0] current_state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        dout       = 1'b0;

        case (current_state)
            IDLE: begin
                if (din) next_state = S1;
                else     next_state = IDLE;
            end
            S1: begin
                if (din) next_state = S1;
                else     next_state = S10;
            end
            S10: begin
                if (din) begin
                    next_state = S1;
                    dout       = 1'b1;
                end
                else next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
