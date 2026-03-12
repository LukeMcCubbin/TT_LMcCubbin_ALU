`timescale 1ns/1ps

module testbench;

logic [7:0] ui_in;
logic [7:0] uo_out;

logic [7:0] uio_in;
logic [7:0] uio_out;
logic [7:0] uio_oe;

logic clk;
logic rst_n;
logic ena;

integer i,j,k;

tt_um_LMcCubbin_Digital_ALU dut (
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_in(uio_in),
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .ena(ena),
    .clk(clk),
    .rst_n(rst_n)
);

always #5 clk = ~clk;

initial begin

    clk = 0;
    rst_n = 1;
    ena = 1;
    uio_in = 0;

    $display("Testing ALU");

    for (k=0;k<4;k=k+1) begin
        for (i=0;i<8;i=i+1) begin
            for (j=0;j<8;j=j+1) begin

                ui_in[2:0] = i;
                ui_in[5:3] = j;
                ui_in[7:6] = k;

                #10;

                $display("OP=%b A=%b B=%b RESULT=%b",
                        ui_in[7:6],
                        ui_in[2:0],
                        ui_in[5:3],
                        uo_out[2:0]);

            end
        end
    end

    $finish;
end

endmodule