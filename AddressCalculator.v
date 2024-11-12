module AddressCalculator (
    input wire [255:0] HF,            // 256-bit Head Flit
    input wire clk,                   // Main clock signal
    input wire reset,                 // Reset signal
    output reg [7:0] src_addr,        // Source address output
    output reg [7:0] dest_addr        // Destination address output
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            src_addr <= 8'b0;
            dest_addr <= 8'b0;
        end else begin
            src_addr <= HF[247:240];
            dest_addr <= HF[239:232];
        end
    end
endmodule
