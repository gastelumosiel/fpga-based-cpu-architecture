
`timescale 1ns/1ns

module ALUTest (
    reset,clock,Command[1:0],
    States[1:0],inputA[3:0],inputB[3:0],z[8:0]);

    input reset;
    input clock;
    input [1:0] Command;
	 input [3:0] inputA;
	 input [3:0] inputB;
    tri0 reset;
    tri0 [1:0] Command;
    output [1:0] States;
	 output [8:0] z;
    reg [1:0] States;
    reg [6:0] fstate;
    reg [6:0] reg_fstate;
	 reg Add_Sub_Sel;
	 reg [1:0] Sel_Multi;
	 reg AddSub_Mul;
	 reg K_Mul;
	 reg M_Mul;
	 reg [3:0] mul_input;
	 reg [3:0] addsub_input;
    parameter Start=0,Add=1,Subtract=2,Mul=3,Shift=4,Add_Mul=5,End_Mul=6;
	 
	 always @(AddSub_Mul or inputB)
	 begin
		addsub_input[0] = ~AddSub_Mul & inputB[0];
		addsub_input[1] = ~AddSub_Mul & inputB[1];
		addsub_input[2] = ~AddSub_Mul & inputB[2];
		addsub_input[3] = ~AddSub_Mul & inputB[3];
		mul_input[0] = AddSub_Mul & inputB[0];
		mul_input[1] = AddSub_Mul & inputB[1];
		mul_input[2] = AddSub_Mul & inputB[2];
		mul_input[3] = AddSub_Mul & inputB[3];
	 end
	 
	always @(z[0])
	begin
		M_Mul = z[0];
	end
						  
	contador contador_instancia(.S0 (Sel_Multi[0]), .S1 (Sel_Multi[1]), .CLK (clock), .K (K_Mul));
	 
	 registro registro_instancia(.M0 (inputA[0]),
										  .M1 (inputA[1]),
										  .M2 (inputA[2]),
										  .M3 (inputA[3]),
										  .mul0 (addsub_input[0]),
										  .mul1 (addsub_input[1]),
										  .mul2 (addsub_input[2]),
										  .mul3 (addsub_input[3]),
										  .mul_input0 (mul_input[0]),
										  .mul_input1 (mul_input[1]),
										  .mul_input2 (mul_input[2]),
										  .mul_input3 (mul_input[3]),
										  .Control_AS (Add_Sub_Sel),
										  .Control_AS_M (AddSub_Mul),
										  .CLK (clock),
										  .S0 (Sel_Multi[0]),
										  .S1 (Sel_Multi[1]),
										  .x0 (z[0]),
										  .x1 (z[1]),
										  .x2 (z[2]),
										  .x3 (z[3]),
										  .x4 (z[4]),
										  .x5 (z[5]),
										  .x6 (z[6]),
										  .x7 (z[7]),
										  .x8 (z[8]) );
	 			  
    always @(posedge clock)
    begin
        if (clock) begin
            fstate <= reg_fstate;
        end
    end
	 					  
    always @(fstate or reset or Command or K_Mul or M_Mul)
    begin
        if (!reset) begin
            reg_fstate <= Start;
            States <= 2'b00;
				Sel_Multi <= 2'b00;
				AddSub_Mul <= 1'b0;
        end
        else begin
            States <= 2'b00;
				Sel_Multi <= 2'b00;
				AddSub_Mul <= 1'b0;
            case (fstate)
                Start: begin
                    if (Command[1:0] == 2'b00)
                        reg_fstate <= Add;
                    else if (Command[1:0] == 2'b01)
                        reg_fstate <= Subtract;
                    else if (Command[1:0] == 2'b11)
                        reg_fstate <= Start;
                    else if (Command[1:0] == 2'b10)
                        reg_fstate <= Mul;
                    // Inserting 'else' block to prevent latch inference
                    else
                        reg_fstate <= Start;

                    States <= 2'b11;
						  Sel_Multi <= 2'b11;
                end
                Add: begin
                    if (Command[1:0] == 2'b00)
                        reg_fstate <= Add;
                    else if (Command[1:0] == 2'b11)
                        reg_fstate <= Start;
                    // Inserting 'else' block to prevent latch inference
                    else
                        reg_fstate <= Add;

                    States <= 2'b00;
						  
						  Sel_Multi <= 2'b01;
						  
						  Add_Sub_Sel <= 1'b0;
						  
						  AddSub_Mul <= 1'b0;
                end
                Subtract: begin
                    if (Command[1:0] == 2'b01)
                        reg_fstate <= Subtract;
                    else if (Command[1:0] == 2'b11)
                        reg_fstate <= Start;
                    // Inserting 'else' block to prevent latch inference
                    else
                        reg_fstate <= Subtract;

                    States <= 2'b01;
						  
						  Sel_Multi <= 2'b01;
						  
						  Add_Sub_Sel <= 1'b1;
						  
						  AddSub_Mul <= 1'b0;
                end
                Mul: begin
                    if (((M_Mul == 1'b1) & (K_Mul == 1'b0)))
                        reg_fstate <= Add_Mul;
                    else if (((M_Mul == 1'b0) & (K_Mul == 1'b0)))
                        reg_fstate <= Shift;
                    // Inserting 'else' block to prevent latch inference
                    else
                        reg_fstate <= Mul;

                    States <= 2'b10;
						  
						  Sel_Multi <= 2'b00;
						  
						  AddSub_Mul <= 1'b1;
                end
					 Shift: begin
                    if ((K_Mul == 1'b1))
                        reg_fstate <= End_Mul;
                    // Inserting 'else' block to prevent latch inference
                    else
                        reg_fstate <= Mul;

                    States <= 2'b10;
						  Sel_Multi <= 2'b10;
                end
					 Add_Mul: begin
							reg_fstate <= Shift;
							Sel_Multi <= 2'b01;
							AddSub_Mul <=1'b1;
							Add_Sub_Sel <= 1'b0;
					 end
					 End_Mul: begin
							if (((Command[1:0] == 2'b11)))
								reg_fstate <= Start;
							else
							reg_fstate <= End_Mul;
							
							Sel_Multi <= 2'b11;
					 end
                default: begin
                    States <= 3'bxxx;
                    $display ("Reach undefined state");
                end
            endcase
        end
    end
	 
	 
										  
endmodule // ALUTest
