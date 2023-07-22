module full_adder (
	input a, b, cin,
	output s, cout
);
	assign s = a ^ b ^ cin;
	assign cout = (a & b) | (cin & (a ^ b));
endmodule




module carry_ripple_adder (
	input	[7:0] a, b, 
	input   cin,
	output 	[7:0] s, 
	output  cout
);


generate
	wire [8:0] carry;

	assign carry[0] = cin;
	assign cout = carry[8];

	for (genvar i = 0; i < 8; i++) begin
		full_adder fa_inst(
			 .a 	(a[i])
			,.b 	(b[i])
			,.cin 	(carry[i])
			,.s 	(s[i])
			,.cout 	(carry[i+1])
		);
	end	
endgenerate

	

endmodule
