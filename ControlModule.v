module ControlModule (
    input wire clk,                   // Main clock signal
    input wire reset,                 // Reset signal
    input wire clk_div_8_to_NI,       // Synchronization clock
    output reg mode                   // Mode signaling within NI
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mode <= 1'b0;
        end else if (clk_div_8_to_NI) begin
            mode <= ~mode;
        end
    end
endmodule
