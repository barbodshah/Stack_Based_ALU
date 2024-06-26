module STACK_BASED_ALU #(parameter n = 32, parameter STACK_SIZE = 32, parameter POINTER_SIZE = 5) (
    input clk,
    input rst,
    input [2:0] opcode,
    input signed [n-1:0] input_data,
    output reg signed [n-1:0] output_data,
    output reg overflow,
    output reg [POINTER_SIZE-1:0] sp
);
    reg signed [n-1:0] first_operand, second_operand;
    reg signed [2*n-1:0] full_product;
    reg signed [n-1:0] stack [0:STACK_SIZE-1];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp = 0;
            output_data = 0;
            overflow = 0;
        end 
        else begin
            if(opcode == 3'b100) begin
                if (sp >= 2) begin
                    first_operand = stack[sp-1];
                    second_operand = stack[sp-2];

                    output_data = first_operand + second_operand;
                    overflow = (~first_operand[n-1] & ~second_operand[n-1] & output_data[n-1]) | (first_operand[n-1] & second_operand[n-1] & ~output_data[n-1]);
                end 
                else
                    overflow <= 0;
            end
            else if(opcode == 3'b101) begin
                if (sp >= 2) begin
                    first_operand = stack[sp-1];
                    second_operand = stack[sp-2];

                    full_product = first_operand * second_operand;
                    output_data = full_product[n-1:0];
                    overflow = $signed(full_product != output_data);
                end 
                else
                    overflow <= 0;
            end
            else if(opcode == 3'b110) begin
                if (sp < STACK_SIZE) begin
                    stack[sp] <= input_data;
                    sp <= sp + 1;
                end
            end
            else if(opcode == 3'b111) begin
                if (sp > 0) begin
                    output_data <= stack[sp-1]; 
                    stack[sp-1] = 0;
                    sp <= sp - 1;
                end
            end
            else begin
                output_data <= output_data;
                overflow <= overflow;
            end
        end
    end
endmodule

