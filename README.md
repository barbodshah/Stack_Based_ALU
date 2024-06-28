# Stack Based ALU

## Overview
This project implements a stack-based Arithmetic Logic Unit (ALU) in Verilog that supports basic arithmetic operations such as addition and multiplication. The project also includes a calculator module capable of evaluating infix mathematical expressions, including those with parentheses and both positive and negative numbers.

## Table of Contents
- [Tools](#tools)
- [Implementation Details](#implementation-details)
- [How to run](#how-to-rum)
- [Authors](#authors)

## Tools
- Modelsim

## Implementation Details
This projects is implemented using the verilog HDL and simulated using Modelsim.
It consists of 2 main modules: STACK_BASED_ALU and CALCULATOR.
The STACK_BASED_ALU is a module capable of the following instructions:
1. Addition: adding the 2 upmost elements of the stack and put it in output
2. Multiplication: multplying the 2 upmost elements of the stack and put it in output
3. Push: push a number onto the stack
4. Pop: pop the fist element of the stack and put it in output

The next module is the CALCULATOR module. It takes an infix mathematical expression consisting of paranthesis, addition, multiplication, positive and negative integers 
as input. Then using the [Shunting Yard Algorithm](https://en.wikipedia.org/wiki/Shunting_yard_algorithm#:~:text=In%20computer%20science%2C%20the%20shunting,abstract%20syntax%20tree%20(AST).)
,it converts the infix expression to a postfix expression which we can feed into our STACK_BASED_ALU module and calculate the result.

There are 2 additional verilog files which are the testbenches for each main modules written to make sure the modules work as expected.
Further details about the implementation can be found in the pdf file available in the Document folder of the repo.

## How to run
To run the project, First you need the modelsim tool which can be dowloaded [here](https://www.intel.com/content/www/us/en/software-kit/750368/modelsim-intel-fpgas-standard-edition-software-version-18-1.html). After importing the project files (located in the Code folder of the repo) you can run the project using the simulate button in the top left corner of the application.

## Authors
- Barbod Shahrabadi - 401106125
