`timescale 1ns / 1ps

module NetworkInterface_tb;

    // Testbench signals
    reg [15:0] sram_data_in;      // Input data from SRAM
    reg clk;                      // Clock signal
    reg reset;                    // Reset signal
    reg clk_div_8_to_NI;          // Synchronization clock
    wire [15:0] data_out;         // Output data from De-packetizer
    wire packet_end;              // End of packet signal
    
    // Instantiate the NetworkInterface module
    NetworkInterface DUT (
        .sram_data_in(sram_data_in),
        .clk(clk),
        .reset(reset),
        .clk_div_8_to_NI(clk_div_8_to_NI),
        .data_out(data_out),
        .packet_end(packet_end)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 100 MHz clock (10 ns period)
    end

    initial begin
        clk_div_8_to_NI = 0;
        forever #40 clk_div_8_to_NI = ~clk_div_8_to_NI;   // Divided clock (80 ns period)
    end

    // Stimulus generation
    initial begin
        // Reset all signals
        reset = 1;
        sram_data_in = 16'h0000;
        #20;
        
        reset = 0;              // Release reset
        #10;
        
        // Test Packetizer with various inputs
        sram_data_in = 16'hAAAA; // Set SRAM input
        #10;

        sram_data_in = 16'hBBBB; // Update SRAM input
        #10;
        
        sram_data_in = 16'hCCCC; // Update SRAM input again
        #10;
        
        // Let the packetizer and FIFO interact
        sram_data_in = 16'hDDDD;
        #50;

        // Trigger reset to observe behavior
        reset = 1;
        #20;
        reset = 0;

        // Test with different data patterns
        sram_data_in = 16'h1111;
        #10;
        
        sram_data_in = 16'h2222;
        #10;

        // Check final packet end signal
        #100;

        // End simulation
        $finish;
    end

    // Monitoring outputs
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars();
    end

endmodule
