`timescale 1ns / 1ps

module NetworkInterface_tb;

    // Inputs
    reg [15:0] sram_data_in;
    reg clk;
    reg reset;
    reg clk_div_8_to_NI;

    // Outputs
    wire [15:0] data_out;
    wire packet_end;

    // Instantiate the Network Interface module
    NetworkInterface uut (
        .sram_data_in(sram_data_in),
        .clk(clk),
        .reset(reset),
        .clk_div_8_to_NI(clk_div_8_to_NI),
        .data_out(data_out),
        .packet_end(packet_end)
    );

    // Clock generation (main clock)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Clock divider simulation for clk_div_8_to_NI
    initial begin
        clk_div_8_to_NI = 0;
        forever #40 clk_div_8_to_NI = ~clk_div_8_to_NI; // Slower clock
    end

    // Stimulus process
    initial begin
        // Initialize inputs
        sram_data_in = 16'b0;
        reset = 1;

        // Apply reset
        #20;
        reset = 0;
        
        // Start providing data to SRAM input
        #10;
        sram_data_in = 16'hA5A5; // Arbitrary test data
        #10;
        sram_data_in = 16'h5A5A;
        #10;
        sram_data_in = 16'h1234;
        #10;
        sram_data_in = 16'h5678;

        // Wait for packet processing
        #100;
        sram_data_in = 16'hFFFF; // Tail marker example data

        // Monitor outputs
        #200;
        
        // Further testing with different data patterns
        sram_data_in = 16'h4321;
        #10;
        sram_data_in = 16'h8765;
        #10;
        sram_data_in = 16'hABCD;
        #10;
        sram_data_in = 16'hEF01;

        // Wait for the processing to complete
        #300;

        // End the simulation
        $finish;
    end

    // Monitor the output signals
    initial begin
        $monitor("Time=%0t | Data Out=%h | Packet End=%b", $time, data_out, packet_end);
    end

endmodule
