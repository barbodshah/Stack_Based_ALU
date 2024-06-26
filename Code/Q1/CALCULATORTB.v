module CALCULATORTB;
    parameter LEN_INPUT = 50;
    reg [8*LEN_INPUT-1:0] expression;
    reg clk, rst;
    wire signed [31:0] output_value;

    CALCULATOR #(LEN_INPUT) calculator (
        .expression(expression),
        .clk(clk),
        .rst(rst),
        .output_value(output_value)
    );

    initial begin
        rst = 0; #10;
        rst = 1; #10;  
        rst = 0; #10;

        expression = "3+5";
        $display("input: %s", expression);      
        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        expression = "2*-3";
        $display("input: %s", expression);      
        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        expression = "-4+6";  // without ()
        $display("input: %s", expression);      
        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        expression = "1+2*3+4*5+6";
        $display("input: %s", expression);      
        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        expression = "8*-2+3*4+5";
        $display("input: %s", expression);      
        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        expression = "(3+5)*2";
        $display("input: %s", expression);      
        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        expression = "(1+(2*3))*(4+(5*6))";
        $display("input: %s", expression);      
        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        expression = "((((1+2)*3)+4)*5)+6";
        $display("input: %s", expression);      
        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        expression = "2*3+(10+4+3)*(-20)+(6+5)";
        $display("input: %s", expression);      
        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        $stop;
    end
endmodule



