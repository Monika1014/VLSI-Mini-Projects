module traffic_light_controller (
    input clk,
    input reset,
    output reg [1:0] main_light,
    output reg [1:0] side_light
);
    parameter RED=2'b00, GREEN=2'b01, YELLOW=2'b10;

    
    parameter S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;

    reg [1:0] state;
    reg [3:0] timer;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            timer <= 0;
        end
        else begin
            case(state)
                S0: begin // Main Green, Side Red (5 cycles)
                    if (timer < 5) timer <= timer + 1;
                    else begin
                        state <= S1;
                        timer <= 0;
                    end
                end

                S1: begin // Main Yellow, Side Red (2 cycles)
                    if (timer < 2) timer <= timer + 1;
                    else begin
                        state <= S2;
                        timer <= 0;
                    end
                end

                S2: begin // Main Red, Side Green (5 cycles)
                    if (timer < 5) timer <= timer + 1;
                    else begin
                        state <= S3;
                        timer <= 0;
                    end
                end

                S3: begin // Main Red, Side Yellow (2 cycles)
                    if (timer < 2) timer <= timer + 1;
                    else begin
                        state <= S0;
                        timer <= 0;
                    end
                end
            endcase
        end
    end
    always @(*) begin
        case(state)
            S0: begin main_light=GREEN; side_light=RED; end
            S1: begin main_light=YELLOW; side_light=RED; end
            S2: begin main_light=RED; side_light=GREEN; end
            S3: begin main_light=RED; side_light=YELLOW; end
            default: begin main_light=RED; side_light=RED; end
        endcase
    end

endmodule

-------------------------------------------------------------------------------------

`timescale 1ns/1ps
module traffic_light_tb;
    reg clk, reset;
    wire [1:0] main_light, side_light;

    traffic_light_controller uut (.clk(clk), .reset(reset),
                                  .main_light(main_light),
                                  .side_light(side_light));
    initial begin
        $dumpfile("traffic.vcd");
        $dumpvars(0, traffic_light_tb);
        clk = 0; reset = 1;
        #10 reset = 0;
        #200 $finish; // run simulation for 200ns
    end
    always #5 clk = ~clk;  // 10ns clock period
endmodule
