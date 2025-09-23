module alu_4bit (
    input  [3:0] A,     
    input  [3:0] B,         
    input  [2:0] op,    
    output reg [3:0] result,
    output reg carry_out,
    output reg zero
);
    reg [4:0] temp; 
    always @(*) begin
        case (op)
            3'b000: begin 
                temp = A + B;
                result = temp[3:0];
                carry_out = temp[4];
            end
            3'b001: begin 
                temp = A - B;
                result = temp[3:0];
                carry_out = temp[4]; 
            end
            3'b010: begin 
                result = A & B;
                carry_out = 0;
            end
            3'b011: begin 
                result = A | B;
                carry_out = 0;
            end

            3'b100: begin 
                result = A ^ B;
                carry_out = 0;
            end
            default: begin
                result = 4'b0000;
                carry_out = 0;
            end
        endcase
        if (result == 4'b0000)
            zero = 1;
        else
            zero = 0;
    end
endmodule

-----------------------------------------------------------------
// testbench 

`timescale 1ns/1ps

module tb_alu_4bit;
    reg [3:0] A, B;
    reg [2:0] op;
    wire [3:0] result;
    wire carry_out, zero;
    alu_4bit uut (
        .A(A),
        .B(B),
        .op(op),
        .result(result),
        .carry_out(carry_out),
        .zero(zero)
    );
    initial begin
        $monitor("Time=%0t | A=%b | B=%b | op=%b | Result=%b | Carry=%b | Zero=%b",
                  $time, A, B, op, result, carry_out, zero);
        $dumpfile("alu.vcd");
        $dumpvars(0, tb_alu_4bit);
      
        A = 4'b0101; B = 4'b0011; op = 3'b000; #10;  // 5 + 3 = 8
        A = 4'b0110; B = 4'b0010; op = 3'b001; #10;  // 6 - 2 = 4
        A = 4'b1100; B = 4'b1010; op = 3'b010; #10;  // 1100 & 1010 = 1000
        A = 4'b1100; B = 4'b1010; op = 3'b011; #10;  // 1100 | 1010 = 1110
        A = 4'b1100; B = 4'b1010; op = 3'b100; #10;  // 1100 ^ 1010 = 0110
        A = 4'b0101; B = 4'b1011; op = 3'b001; #10;  // 5 - 11 = 1110 (result not zero)
        A = 4'b1000; B = 4'b1000; op = 3'b001; #10;  // 8 - 8 = 0000 (zero flag = 1)
        $finish;
    end
endmodule
