module DePacketizer (
    input wire [47:0] flitoutde,  // Input is now 48 bits
    input wire clk,               // Main clock signal
    input wire reset,             // Reset signal
    output reg [15:0] data_out,   // Reconstructed output data
    output reg packet_end         // Packet end signal
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
            packet_end <= 1'b0;
        end else begin
            data_out <= flitoutde[31:16];
            if((flitoutde[47:32] == 16'hFFFF))
                packet_end <= 1'b1;  
        end
    end
endmodule
