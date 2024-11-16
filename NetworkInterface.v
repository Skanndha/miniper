module NetworkInterface (
    input wire [15:0] sram_data_in,   // 16-bit input data from SRAM
    input wire clk,                   // Main clock signal
    input wire reset,                 // Reset signal
    input wire clk_div_8_to_NI,       // Synchronization clock
    output wire [15:0] data_out,      // Output data from De-packetizer
    output wire packet_end            // End of packet signal
);

    wire [47:0] flit_out;
    wire [47:0] fifo_data_out;
    wire [7:0] src_addr, dest_addr;
    wire write_enable, read_enable, fifo_full, fifo_empty;

    FIFO fifo (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .data_in(flit_out),
        .data_out(fifo_data_out),
        .full(fifo_full),
        .empty(fifo_empty)
    );

    Packetizer pktzr (
        .sram_data_in(sram_data_in),
        .HF(HF),
        .BF(BF),
        .TF(TF),
        .clk(clk),
        .reset(reset),
        .flit_out(flit_out),
        .write_enable(write_enable)
    );

    AddressCalculator addr_calc (
        .HF(fifo_data_out),
        .clk(clk),
        .reset(reset),
        .src_addr(src_addr),
        .dest_addr(dest_addr)
    );

    DePacketizer dpktzr (
        .HF(fifo_data_out),
        .BF(fifo_data_out),
        .TF(fifo_data_out),
        .clk(clk),
        .reset(reset),
        .data_out(data_out),
        .packet_end(packet_end)
    );

    ControlModule ctrl (
        .clk(clk),
        .reset(reset),
        .clk_div_8_to_NI(clk_div_8_to_NI),
        .mode(read_enable)
    );
endmodule
