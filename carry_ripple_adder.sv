module full_adder (			             // 전가산기 모듈 생성
	input a, b, cin,                             // 인풋으로 a,b,carry in 을 선언
	output s, cout				     // 아웃풋으로 sum, carrry out을 선
);
	assign s = a ^ b ^ cin;                      // assign을 통해서 
	assign cout = (a & b) | (cin & (a ^ b));    
endmodule                                            // 전가산기 모듈 끝내는 구문
 



module carry_ripple_adder (                         // 캐리리플가산기 모듈 생성
	input	[7:0] a, b,                          // 인풋으로 8비트의 a,b와 carry in 을 선언, 아웃풋으로 8비트의 sum과 carry out을 선언
	input   cin, 
	output 	[7:0] s, 
	output  cout
);


generate                                           // 반복문을 생성하는 구
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
