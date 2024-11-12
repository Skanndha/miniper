module Packetizer (
    input wire [15:0] sram_data_in,   // 16-bit input data from SRAM
    input wire [7:0] src_addr,        // Source address
    input wire [7:0] dest_addr,       // Destination address
    input wire clk,                   // Main clock signal
    input wire reset,                 // Reset signal
    output reg [255:0] flit_out,      // 256-bit output flit to FIFO
    output reg write_enable           // FIFO write enable signal
);

    reg [1:0] state = 0;              // State for flit selection (0: HF, 1: BF, 2: TF)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            flit_out <= 256'b0;
            write_enable <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    flit_out <= {8'b0, src_addr, dest_addr, 224'b0}; // Head Flit with addresses
                    write_enable <= 1;
                    state <= 1;
                end
                1: begin
                    flit_out <= {16{sram_data_in}}; // Repeating SRAM data across 256 bits
                    write_enable <= 1;
                    state <= 2;
                end
                2: begin
                    flit_out <= {240'b0, 16'hFFFF}; // Tail Flit with end marker
                    write_enable <= 1;
                    state <= 0;
                end
            endcase
        end
    end
endmodule
