module gray_decoder(
	input [7:0] gray,     // 입력으로 8비트 그레이코드를 선언
	output reg [7:0] bin  // 출력으로 8비트 바이너리코드를 선언
);


always_comb begin             
	for (int i = 7; i >= 0; i--) begin
		if (i == 7)
			bin[i] = gray[i];
		else
			bin[i] = bin[i+1] ^ gray[i];
	end
end


endmodule
