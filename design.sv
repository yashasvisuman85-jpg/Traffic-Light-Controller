
`timescale 1ns/1ps
module traffic_light (
    input wire clk,
    input wire reset,
    output reg red,
    output reg yellow,
    output reg green
);

    localparam GREEN  = 2'b00;
    localparam YELLOW = 2'b01;
    localparam RED    = 2'b10;

    reg [1:0] state;
    integer count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= GREEN;
            count <= 0;
        end else begin
            case (state)
                GREEN: begin
                    if (count == 2) begin
                        state <= YELLOW;
                        count <= 0;
                    end else count <= count + 1;
                end

                YELLOW: begin
                    if (count == 1) begin
                        state <= RED;
                        count <= 0;
                    end else count <= count + 1;
                end

                RED: begin
                    if (count == 2) begin
                        state <= GREEN;
                        count <= 0;
                    end else count <= count + 1;
                end

                default: begin
                    state <= GREEN;
                    count <= 0;
                end
            endcase
        end
    end

    always @(*) begin
        red = 0;
        yellow = 0;
        green = 0;

        case (state)
            GREEN:  green = 1;
            YELLOW: yellow = 1;
            RED:    red = 1;
            default: green = 1;
        endcase
    end

endmodule