`timescale 1ns / 1ps

module tb_intel_4004;
    reg clk;
    reg reset;
    wire [3:0] d_bus;

    reg [7:0] rom [0:4095]; 
    reg [3:0] rom_data_out;
    reg       rom_drive_bus;
    
    integer i;
    integer rand_val;
    
    reg [2:0] cycle_counter;
    reg [11:0] captured_address;

    intel_4004_top uut (
        .clk(clk), 
        .reset(reset), 
        .d_bus(d_bus)
    );

    // Bidirectional bus driver
    assign d_bus = rom_drive_bus ? rom_data_out : 4'bz;

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        // 1. Clear memory
        for (i = 0; i < 4096; i = i + 1) begin
            rom[i] = 8'h00; 
        end
        
        // 2. Inject sequential coverage stimuli (NOP, ADD, SUB only)
        for (i = 0; i < 50; i = i + 1) begin
            rand_val = {$random} % 3; 
            case (rand_val)
                0: rom[i] = 8'h00; // NOP
                1: rom[i] = 8'h80; // ADD
                2: rom[i] = 8'h90; // SUB
            endcase
        end
        
        rom_drive_bus = 0;
        cycle_counter = 0;
        captured_address = 0;

        reset = 1;
        #25; 
        reset = 0;
    end

    // --- 1. Sequential Address Capture ---
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 0;
            captured_address <= 12'b0;
        end else begin
            case (cycle_counter)
                0: captured_address[3:0] <= d_bus; 
                1: captured_address[7:4] <= d_bus; 
                2: captured_address[11:8] <= d_bus; 
            endcase
            
            // 3-bit register naturally rolls over 7 to 0
            cycle_counter <= cycle_counter + 1;
        end
    end

    // --- 2. Combinatorial ROM Emulator (Zero Delay) ---
    always @(*) begin
        rom_drive_bus = 0;
        rom_data_out = 4'b0000;
        
        // Drive exact data during M1 and M2 phases
        if (cycle_counter == 3) begin
            rom_drive_bus = 1;
            rom_data_out = rom[captured_address][7:4];
        end else if (cycle_counter == 4) begin
            rom_drive_bus = 1;
            rom_data_out = rom[captured_address][3:0];
        end
    end

    // --- 3. Coverage Termination Validation ---
    always @(posedge clk) begin
        if (uut.datapath_inst.active_pc == 12'd50) begin
            $display("========================================");
            $display("SUCCESS: 50 Sequential Operations Completed.");
            $display("ADD and SUB logic heavily exercised.");
            $display("Terminating simulation for Coverage Report.");
            $display("========================================");
            $finish;
        end
    end
    
    // Watchdog Timer
    initial begin
        #10000; 
        $display("ERROR: Watchdog Timer triggered.");
        $finish;
    end
endmodule
