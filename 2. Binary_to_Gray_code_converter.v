module binary_to_gray
#(
    parameter WIDTH = 4
)
(
    input  wire [WIDTH-1:0] binary,
    output wire [WIDTH-1:0] gray
);
    assign gray = binary ^ (binary >> 1);
endmodule

-----------------------------------------------------------

`timescale 1ns/1ps

module tb_binary_to_gray;

    parameter WIDTH = 4;
    localparam TOTAL = (1 << WIDTH);

    reg  [WIDTH-1:0] tb_binary;
    wire [WIDTH-1:0] tb_gray;

    // Instantiate DUT
    binary_to_gray #(.WIDTH(WIDTH)) dut (
        .binary(tb_binary),
        .gray(tb_gray)
    );

        function [WIDTH-1:0] expected_gray;
        input [WIDTH-1:0] b;
        begin
            expected_gray = b ^ (b >> 1);
        end
    endfunction

    integer i;
    integer errors = 0;

    initial begin
        
        $dumpfile("binary_to_gray.vcd");
        $dumpvars(0, tb_binary_to_gray);

        $display("Starting binary->Gray testbench (WIDTH=%0d)", WIDTH);
        $display("Binary    Gray    ExpGray   PASS/FAIL");

        for (i = 0; i < TOTAL; i = i + 1) begin
            tb_binary = i[WIDTH-1:0];
            #1; 
            if (tb_gray !== expected_gray(tb_binary)) begin
                $display("%b   %b   %b   FAIL", tb_binary, tb_gray, expected_gray(tb_binary));
                errors = errors + 1;
            end else begin
                $display("%b   %b   %b   PASS", tb_binary, tb_gray, expected_gray(tb_binary));
            end
            #4; 
        end

        if (errors == 0) begin
            $display("All tests passed! (%0d vectors)", TOTAL);
        end else begin
            $display("TEST FAILED: %0d mismatches", errors);
        end

        #5;
        $finish;
    end

endmodule
