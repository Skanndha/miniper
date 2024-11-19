module NetworkInterface (
    input wire [15:0] sram_data_in,   // 16-bit input data from SRAM
    input wire clk,                   // Main clock signal
    input wire reset,                 // Reset signal
    input wire clk_div_8_to_NI,       // Synchronization clock
    output wire [15:0] data_out,      // Output data from De-packetizer
    output wire packet_end            // End of packet signal
);

    wire [47:0] flit_out;
    wire [47:0] fifo_data_out;   // Corrected to 48 bits
    wire [7:0] src_addr, dest_addr;
    wire write_enable, read_enable, fifo_full, fifo_empty;

    // Define HF, BF, and TF signals
    wire [15:0] HF, BF, TF;

    // Instantiate FIFO
    FIFO fifo (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .data_in(flit_out),
        .data_out(fifo_data_out),   // 48-bit width matches
        .full(fifo_full),
        .empty(fifo_empty)
    );

    // Instantiate Packetizer
    Packetizer pktzr (
        .HF(HF),
        .BF(BF),
        .TF(TF),
        .clk(clk),
        .reset(reset),
        .flit_out(flit_out),
        .write_enable(write_enable)
    );

    // Instantiate DePacketizer
    DePacketizer dpktzr (
        .flitoutde(fifo_data_out),  // Corrected to 48 bits
        .clk(clk),
        .reset(reset),
        .data_out(data_out),        // Outputs 16-bit data
        .packet_end(packet_end)
    );

    // Instantiate ControlModule
    ControlModule ctrl (
        .clk(clk),
        .reset(reset),
        .clk_div_8_to_NI(clk_div_8_to_NI),
        .mode(read_enable)
    );
endmodule
