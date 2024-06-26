module CALCULATOR #(parameter LEN_INPUT = 10) (
    input wire [8*LEN_INPUT-1:0] expression,
    input wire rst,
    input wire clk,
    output reg [31:0] output_value
);
    parameter n = 8;

    reg [8*LEN_INPUT:0] postfix;

    reg [7:0] stackInput;
    reg [2:0] stackOp;
    wire [7:0] stackOutput;
    wire [4:0] sp; //Check if the stack is empty or not

    reg CLK;

    reg signed [31:0] calculator_input;
    wire [31:0] calculator_output;
    reg [2:0] calculatorOp;

    integer i;
    integer j;
    integer index;

    reg valid;
    reg isNeg;

    //only used for pushing and popping
    STACK_BASED_ALU #(n) stack (
        .input_data(stackInput[n-1:0]),
        .clk(CLK),
        .rst(rst),
        .opcode(stackOp),
        .output_data(stackOutput[n-1:0]),
        .sp(sp)
    );

    STACK_BASED_ALU calculator (
        .input_data(calculator_input[31:0]),
        .output_data(calculator_output[31:0]),
        .opcode(calculatorOp),
        .clk(CLK),
        .rst(rst)
    );
    
    always @(posedge clk or posedge rst) begin
        postfix = 0;
        CLK = 0;

        if(rst == 0) begin
            index = 1;
            for (i = LEN_INPUT; i > 0; i = i - 1)
            begin
                is_valid_character(expression[8*i-1 -: 8], valid);
                if (valid) begin
                    append_to_postfix(expression[8*i-1 -: 8], postfix, index);
                end
                else begin
                    case (expression[8*i-1 -: 8]) 
                        "*": begin
                            append_to_postfix(" ", postfix, index);

                            for (j = 1 - (|sp) + 1; j < 1; j = j + 1) begin
                                stackOp = 3'b111; #1; CLK = 1; #1; CLK = 0;
                                
                                if (stackOutput[7:0] == "(" || stackOutput[7:0] == "+") begin
                                    stackOp = 3'b110; stackInput[7:0] = stackOutput[7:0]; #1; CLK = 1;  #1; CLK = 0;
                                end else if (stackOutput[7:0] == "*") begin
                                    append_to_postfix(stackOutput[7:0], postfix, index);
                                    j = 0 - (|sp);
                                end
                            end
                            stackOp = 3'b110; stackInput[7:0] = "*"; #1; CLK = 1; #1; CLK = 0;
                        end

                        "+": begin
                            append_to_postfix(" ", postfix, index);

                            for (j = 1 - (|sp); j < 1; j = j + 1) begin
                                stackOp = 3'b111; #1; CLK = 1; #1; CLK = 0;

                                if (stackOutput[7:0] == "(") begin
                                    stackOp = 3'b110; stackInput[7:0] = stackOutput[7:0]; #1; CLK = 1; #1; CLK = 0;
                                end else if (stackOutput[7:0] == "*" || stackOutput[7:0] == "+") begin
                                    append_to_postfix(stackOutput[7:0], postfix, index);
                                    j = 0 - (|sp);
                                end
                            end
                            stackOp = 3'b110; stackInput[7:0] = "+"; #1; CLK = 1; #1; CLK = 0;
                        end

                        ")": begin
                            append_to_postfix(" ", postfix, index);

                            for (j = 0; j < 1; j = j + 1) begin
                                stackOp = 3'b111; #1; CLK = 1; #1; CLK = 0;

                                if (stackOutput[7:0] != "(") begin
                                    append_to_postfix(stackOutput[7:0], postfix, index);
                                    j = j - 1;
                                end
                            end
                        end

                        "(": begin
                            stackOp = 3'b110; stackInput[7:0] = "("; #1; CLK = 1; #1; CLK = 0;
                        end

                        default: begin
                        end

                    endcase
                end
            end
            append_to_postfix(" ", postfix, index);

            //pop all stack elements
            for (j = 1 - (|sp); j < 1; j = j + 1) begin
                stackOp = 3'b111; #1; CLK = 1; #1; CLK = 0;
                append_to_postfix(stackOutput[7:0], postfix, index);
                j = 0 - (|sp);
            end

            $display("postfix expression: %s", postfix);

            calculator_input = 0;

            for (i = 1; i <= 4*LEN_INPUT + 1; i = i + 1) begin
                is_valid_character(postfix[8*i-1 -: 8], valid);

                if (valid) begin
                    isNeg = postfix[8*i-1 -: 8] == "-";
                    if(isNeg) 
                        i = i + 1;

                    for (j = 0; j < 1; j = j + 1) begin
                        calculator_input = calculator_input * 10 + (postfix[8*i-1 -: 8] - "0");
                        i = i + 1;
                        if (postfix[8*i-1 -: 8] == " ") begin
                            j=0;
                        end
                        else begin j=-1; end
                    end 
                    i = i - 1;

                    if(isNeg)
                        calculator_input = -calculator_input;

                    calculatorOp = 3'b110; #1; CLK = 1; #1;CLK = 0;
                    calculator_input = 0;
                end
                else if (postfix[8*i-1 -: 8] != " " && postfix[8*i-1 -: 8] != 0) begin
                    if(postfix[8*i-1 -:8] == "*")
                        calculatorOp = 3'b101;
                    else
                        calculatorOp = 3'b100;

                    //do operation
                    #1; CLK = 1; #1; CLK = 0; 

                    calculator_input = calculator_output;

                    //pop operands
                    calculatorOp = 3'b111;  #1; CLK = 1; #1; CLK = 0; calculatorOp = 3'b111;  #1; CLK = 1; #1; CLK = 0; 
                    
                    //push last result
                    calculatorOp = 3'b110; #1; CLK = 1; #1; CLK = 0;
                    calculator_input = 0;
                end
            end 
            calculatorOp = 3'b111; #1; CLK = 1; #1; CLK = 0;
            output_value = calculator_output;
        end
    end

    task is_valid_character(input [7:0] char, output reg result);
    begin
        if ((char >= "0" && char <= "9") || char == "-") begin
            result = 1;
        end else begin
            result = 0;
        end
    end
    endtask

    task append_to_postfix(input [7:0] char, inout reg [32*LEN_INPUT+7:0] postfix, inout integer index);
    begin
        postfix[8*index-1 -: 8] = char;
        index = index + 1;
    end
    endtask

endmodule


