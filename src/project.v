/*
 * Copyright (c) 2024 Uri Shaked
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_LMcCubbin_Digital_ALU(
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,   // Dedicated outputs
  input  wire [7:0] uio_in,   // IOs: Input path
  output wire [7:0] uio_out,  // IOs: Output path
  output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
  input  wire       ena,      // always 1 when the design is powered, so you can ignore it
  input  wire       clk,      // clock
  input  wire       rst_n     // reset_n - low to reset
);

    logic [2:0] result;
    logic       carry;
    logic       zero;
    logic       overflow;
    logic       parity;
    logic       sign;
    logic [3:0] temp;

    always_comb begin
        // Default outputs
        result   = 3'b000;
        carry    = 1'b0;
        overflow = 1'b0;
        temp     = 4'b0000;

        unique case (ui_in[7:6])
            2'b00: begin
                // ADD: A + B
                temp   = {1'b0, ui_in[2:0]} + {1'b0, ui_in[5:3]};
                result = temp[2:0];
                carry  = temp[3];

                // Signed overflow for 3-bit addition
                overflow = (~(ui_in[2] ^ ui_in[5])) & (ui_in[2] ^ result[2]);
            end

            2'b01: begin
                // SUBTRACT: A - B
                temp   = {1'b0, ui_in[2:0]} - {1'b0, ui_in[5:3]};
                result = temp[2:0];
                carry  = temp[3];

                // Signed overflow for 3-bit subtraction
                overflow = (ui_in[2] ^ ui_in[5]) & (ui_in[2] ^ result[2]);
            end

            2'b10: begin
                // AND
                result   = ui_in[2:0] & ui_in[5:3];
                carry    = 1'b0;
                overflow = 1'b0;
            end

            2'b11: begin
                // XOR
                result   = ui_in[2:0] ^ ui_in[5:3];
                carry    = 1'b0;
                overflow = 1'b0;
            end

            default: begin
                result   = 3'b000;
                carry    = 1'b0;
                overflow = 1'b0;
            end
        endcase

        sign   = result[2];
        zero   = (result == 3'b000);
        parity = ^result;
    end

    assign uo_out[2:0] = result;
    assign uo_out[3]   = carry;
    assign uo_out[4]   = zero;
    assign uo_out[5]   = overflow;
    assign uo_out[6]   = parity;
    assign uo_out[7]   = sign;

    // Unused bidirectional IOs
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // Unused inputs to avoid warnings
    wire _unused = &{ena, clk, rst_n, uio_in};

endmodule
