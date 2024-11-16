module DePacketizer (
    // input wire [255:0] HF,            // 256-bit Head Flit input
    // input wire [255:0] BF,            // 256-bit Body Flit input
    // input wire [255:0] TF,            // 256-bit Tail Flit input
    input wire [47:0] flitoutde,
    input wire clk,                   // Main clock signal
    input wire reset,                 // Reset signal
    output reg [15:0] data_out,       // Reconstructed output data
    output reg packet_end             // Packet end signal
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
            packet_end <= 1'b0;
        end else begin
            data_out <= flitoutde[];
            packet_end <= (TF[15:0] == 16'hFFFF);
        end
    end
endmodule
