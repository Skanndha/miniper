module FIFO (
    input wire clk,                   // Clock signal
    input wire reset,                 // Reset signal
    input wire write_enable,          // Write enable for FIFO
    input wire read_enable,           // Read enable for FIFO
    input wire [47:0] data_in,       // 256-bit input data
    output reg [47:0] data_out,      // 256-bit output data
    output reg full,                  // FIFO full flag
    output reg empty                  // FIFO empty flag
);

    reg [47:0] buffer [3:0];         // FIFO buffer with depth of 4
    reg [1:0] write_ptr = 0;          // Write pointer
    reg [1:0] read_ptr = 0;           // Read pointer
    integer count = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            write_ptr <= 0;
            read_ptr <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (write_enable && !full) begin
                buffer[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1;
                count <= count + 1;
            end
            
            if (read_enable && !empty) begin
                data_out <= buffer[read_ptr];
                read_ptr <= read_ptr + 1;
                count <= count - 1;
            end

            full <= (count == 4);
            empty <= (count == 0);
        end
    end
endmodule
