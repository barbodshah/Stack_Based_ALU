module STACKALUTB;
    reg [2:0] opcode;
    reg clk, rst;
    
    wire [4:0] sp1;
    wire [4:0] sp2;
    wire [4:0] sp3;
    wire [4:0] sp4;

    reg signed [3:0] input_data1;
    wire signed [3:0] output_data1;
    wire overflow1;


    reg signed [7:0] input_data2;
    wire signed [7:0] output_data2;
    wire overflow2;


    reg signed [15:0] input_data3;
    wire signed [15:0] output_data3;
    wire overflow3;


    reg signed [31:0] input_data4;
    wire signed [31:0] output_data4;
    wire overflow4;


    STACK_BASED_ALU #(4) sba1 (
        .input_data(input_data1),
        .output_data(output_data1),
        .opcode(opcode),
        .overflow(overflow1),
        .clk(clk),
        .rst(rst),
        .sp(sp1)
    );

    STACK_BASED_ALU #(8) sba2 (
        .input_data(input_data2),
        .output_data(output_data2),
        .opcode(opcode),
        .overflow(overflow2),
        .clk(clk),
        .rst(rst),
        .sp(sp2)
    );

    STACK_BASED_ALU #(16) sba3 (
        .input_data(input_data3),
        .output_data(output_data3),
        .opcode(opcode),
        .overflow(overflow3),
        .clk(clk),
        .rst(rst),
        .sp(sp3)
    );

    STACK_BASED_ALU #(32) sba4 (
        .input_data(input_data4),
        .output_data(output_data4),
        .opcode(opcode),
        .overflow(overflow4),
        .clk(clk),
        .rst(rst),
        .sp(sp4)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; #10;
        rst = 0; #10;

        input_data1 = 7;input_data2 = 7;input_data3 = 7;input_data4 = 7; opcode = 3'b110; #10
        input_data1 = 4;input_data2 = 4;input_data3 = 4;input_data4 = 4; opcode = 3'b110; #10
        opcode = 3'b100; #10
        $display("7 + 4: output 4-bit %d, overflow 4-bit %d", output_data1, overflow1);
        $display("7 + 4: output 8-bit %d, overflow 8-bit %d", output_data2, overflow2);
        $display("7 + 4: output 16-bit %d, overflow 16-bit %d", output_data3, overflow3);
        $display("7 + 4: output 32-bit %d, overflow 32-bit %d", output_data4, overflow4);

        input_data2 = 64;input_data3 = 64;input_data4 = 64; opcode = 3'b110; #10
        input_data2 = 3;input_data3 = 3;input_data4 = 3; opcode = 3'b110; #10
        opcode = 3'b101; #10
        $display("64 * 3: output 8-bit %d, overflow 8-bit %d", output_data2, overflow2);
        $display("64 * 3: output 16-bit %d, overflow 16-bit %d", output_data3, overflow3);
        $display("64 * 3: output 32-bit %d, overflow 32-bit %d", output_data4, overflow4);

        input_data3 = 32767;input_data4 = 32767; opcode = 3'b110; #10
        input_data3 = 1;input_data4 = 1; opcode = 3'b110; #10
        opcode = 3'b100; #10
        $display("32767 + 1: output 16-bit %d, overflow 16-bit %d", output_data3, overflow3);
        $display("32767 + 1: output 32-bit %d, overflow 32-bit %d", output_data4, overflow4);

        input_data4 = 1000000000; opcode = 3'b110; #10
        input_data4 = 5; opcode = 3'b110; #10
        opcode = 3'b101; #10
        $display("1000000000 * 5: output 32-bit %d, overflow 32-bit %d", output_data4, overflow4);

        input_data4 = 10654; opcode = 3'b110; #10
        input_data4 = 25434; opcode = 3'b110; #10
        opcode = 3'b101; #10
        $display("10654 * 25434: output 32-bit %d, overflow 32-bit %d", output_data4, overflow4);

        input_data4 = 22; opcode = 3'b110; #10
        input_data4 = 36; opcode = 3'b110; #10
        opcode = 3'b100; #10
        $display("22 + 36: output 32-bit %d, overflow 32-bit %d", output_data4, overflow4);

        input_data4 = 8; opcode = 3'b110; #10
        input_data4 = 4; opcode = 3'b110; #10
        opcode = 3'b101; #10
        $display("8 * 4: output 32-bit %d, overflow 32-bit %d", output_data4, overflow4);

        input_data4 = 32749; opcode = 3'b110; #10
        input_data4 = 125900; opcode = 3'b110; #10
        opcode = 3'b100; #10
        $display("32749 + 125900: output 32-bit %d, overflow 32-bit %d", output_data4, overflow4);

        input_data4 = 56714; opcode = 3'b110; #10
        input_data4 = 1234892; opcode = 3'b110; #10
        opcode = 3'b101; #10
        $display("56714 * 1234892: output 32-bit %d, overflow 32-bit %d", output_data4, overflow4);
        $stop;
    end
endmodule


