
`timescale 1ns/1ps

module traffic_light_tb;

    reg clk = 0;
    reg reset = 1;

    wire red, yellow, green;

    // Connect the design to the testbench
    traffic_light dut (
        .clk(clk),
        .reset(reset),
        .red(red),
        .yellow(yellow),
        .green(green)
    );

    // Generate clock: 10 ns period
    always #5 clk = ~clk;

    // Display and verify the light sequence
    task check_light;
        input [2:0] expected;
        begin
            if ({red, yellow, green} !== expected) begin
                $display("FAIL at time %0t: RYG=%b",
                         $time, {red, yellow, green});
                $finish;
            end else begin
                $display("PASS at time %0t: RYG=%b",
                         $time, {red, yellow, green});
            end
        end
    endtask

    initial begin
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, traffic_light_tb);

        // Hold reset
        repeat (2) @(posedge clk);
        #1;
        check_light(3'b001); // Green

        reset = 0;

        // Green remains on
        repeat (2) @(posedge clk);
        #1;
        check_light(3'b001);

        // Yellow
        @(posedge clk);
        #1;
        check_light(3'b010);

        @(posedge clk);
        #1;
        check_light(3'b010);

        // Red
        @(posedge clk);
        #1;
        check_light(3'b100);

        repeat (2) @(posedge clk);
        #1;
        check_light(3'b100);

        // Cycle returns to green
        @(posedge clk);
        #1;
        check_light(3'b001);

        $display("All sequence checks passed.");
        $finish;
    end

endmodule
