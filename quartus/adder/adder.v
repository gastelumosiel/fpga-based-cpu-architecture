// Programa de sumador (full adder)

// Modulo adder ------------------
module adder (
input a1, b1, a0, b0, // Declaracion variables

output s0,s1,s2); // s1 = salida
					// s2 = carry out

					
wire Cin;

assign s0 = a0 ^ b0; // Salida halfadder
assign Cin = a0 & b0; // Carry

assign s1= a1 ^ b1 ^ Cin; // Salida fulladder
assign s2 = (a1 & Cin) | (b1 & Cin) | (a1 & b1); // Carry fulladder

endmodule



