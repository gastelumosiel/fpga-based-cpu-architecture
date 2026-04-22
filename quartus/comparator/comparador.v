// Comparador

module comparador (
input x1,x2,x3,x4,y1,y2,y3,y4,

output z1,z2,z3);

wire a1;
wire b1;
wire a1_sig;
wire b1_sig;

wire a2;
wire b2;
wire a2_sig;
wire b2_sig;

wire a3;
wire b3;
wire a3_sig;
wire b3_sig;

wire a4;
wire b4;
wire a4_sig;
wire b4_sig;

// Asignacion de ecuaciones

// Celda 1

assign a1 = 0;
assign b1 = 0;

assign a1_sig = (~x1 & y1 & ~b1) | a1;
assign b1_sig = (x1 & ~y1 & ~a1) | b1;

// Celda 2

assign a2 = a1_sig;
assign b2 = b1_sig;

assign a2_sig = (~x2 & y2 & ~b2) | a2;
assign b2_sig = (x2 & ~y2 & ~a2) | b2;

// Celda 3

assign a3 = a2_sig;
assign b3 = b2_sig;

assign a3_sig = (~x3 & y3 & ~b3) | a3;
assign b3_sig = (x3 & ~y3 & ~a3) | b3;

// Celda 4

assign a4 = a3_sig;
assign b4 = b3_sig;

assign a4_sig = (~x4 & y4 & ~b4) | a4;
assign b4_sig = (x4 & ~y4 & ~a4) | b4;

// Salidas

assign z1 = a4_sig; // x < y
assign z2 = ~a4_sig & ~b4_sig; // x = y
assign z3 = b4_sig; // x > y

endmodule