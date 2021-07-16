`timescale 1ns / 100ps

module top_tb;

    reg clk = 1;
    wire red;
    wire green;
    wire blue;
    always #1 clk = !clk;

    top top_i (.SYSCLK(clk), .LED_RED(red), .LED_BLUE(blue), .LED_GREEN(green));
    defparam top_i.clkdiv = 5;

    initial begin
        $dumpvars(0,top_i);
    end

    always @(negedge clk) begin
        if (red & green & blue) begin
            #10 $finish;
        end
    end
endmodule
