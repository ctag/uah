// Structural Representation of Subtractor/Adder Module
// presented in Part I of Laboratory Experiment
// B. Earl Wells -- University of Alabama Huntsville, 2015
// This version places all component modules in a single file
// Note: it is also possible to include each of the component
// modules in separate files and set up the profile such that
// it references each of these files.

// It is good practice in Quartus to give the project the same
// name as the top-level module (or eight_bit_sub_add in this
// case)

// Top level module
// eight-bit subtractor/adder
module eight_bit_sub_add(D_S,B_COUT,A,B,B_CIN,SUB_ADD);
    output [7:0] D_S;
    output B_COUT;
    input [7:0] A,B;
    input B_CIN,SUB_ADD;
    wire n0;

    four_bit_sub_add C0(D_S[3:0],n0,A[3:0],B[3:0],B_CIN,SUB_ADD);
    four_bit_sub_add C1(D_S[7:4],B_COUT,A[7:4],B[7:4],n0,SUB_ADD);
endmodule

// four-bit subtractor/adder
module four_bit_sub_add(d_s,b_cout,a,b,b_cin,sub_add);
   output [3:0] d_s;
   output b_cout;
   input  [3:0] a,b;
   input b_cin,sub_add;
   wire n0,n1,n2;
	
   fullsubadd C0(d_s[0],n0,a[0],b[0],b_cin,sub_add);
   fullsubadd C1(d_s[1],n1,a[1],b[1],n0,sub_add);
   fullsubadd C2(d_s[2],n2,a[2],b[2],n1,sub_add);	
   fullsubadd C3(d_s[3],b_cout,a[3],b[3],n2,sub_add);
endmodule	
	
// full subtractor/adder
module fullsubadd(dif_sum,b_cout,x,y,b_cin,sub_add);
   output dif_sum,b_cout;
   input x,y,b_cin,sub_add;
   wire n0,n1,n2,n3,n4;
	
   not    C0(n0,x);
   mux2_1 C1(n1,x,n0,sub_add);
   and    C2(n2,y,n1);
   and    C3(n3,y,b_cin);
   and    C4(n4,n1,b_cin);
   or     C5(b_cout,n2,n3,n4);
   xor    C6(dif_sum,x,y,b_cin);
endmodule

// 2 to 1 multiplexer	
module mux2_1(o,i0,i1,sel);
   output o;
   input i0,i1,sel;
   wire n0,n1,n2;
	
   not G0(n0,sel);
   and G1(n1,i0,n0);
   and G2(n2,i1,sel);
   or G3(o,n1,n2);	
endmodule
