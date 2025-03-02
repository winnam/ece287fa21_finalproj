module lcd(
	input CLOCK,
	input ASYNC_RST,
	output reg LCD_RS,
	output LCD_RW,
	output LCD_EN,
	output reg [7:0] LCD_DATA
);
	parameter	INIT_STATE	=	0;	// Initialization state
	parameter	LOAD_STATE	=	1;	// Loading instruction state
	parameter	PUSH_STATE	=	2;	// Pushing instruction state
	parameter	IDLE_STATE	=	3;	// Standby state

	reg [5:0] index;
	reg [2:0] state;

	always @(posedge CLOCK, negedge ASYNC_RST) begin
		if (!ASYNC_RST) begin
			index <= 0;
			state <= INIT_STATE;
		end
		else begin
			case (state)
				INIT_STATE: begin
					index <= 0;
					state <= LOAD_STATE;
				end
				LOAD_STATE: begin
					state <= (index > 36 ? IDLE_STATE : PUSH_STATE);
				end
				PUSH_STATE: begin
					index <= index + 1;
					state <= LOAD_STATE;
				end
				IDLE_STATE : begin
					state <= IDLE_STATE;
				end
				default: begin
					index <= 0;
					state <= INIT_STATE;
				end
			endcase
		end
	end

	assign LCD_EN = (state == PUSH_STATE);
	assign LCD_RW = 0;
	
	always @(*) begin
		case (index)
				  0: {LCD_RS, LCD_DATA} = {1'b0, 8'b0011_1000};		// Function set: 8-bit operation, 2-line display, 5x8 dot character font
				  1: {LCD_RS, LCD_DATA} = {1'b0, 8'b0000_0110};		// Entry mode set: Move cursor to the right every time a character is written
				  2: {LCD_RS, LCD_DATA} = {1'b0, 8'b0000_0001};		// Clear display
												
				  3: {LCD_RS, LCD_DATA} = {1'b1,  "K"};
				  4: {LCD_RS, LCD_DATA} = {1'b1,  "p"};
				  5: {LCD_RS, LCD_DATA} = {1'b1,  " "};
				  6: {LCD_RS, LCD_DATA} = {1'b1,  " "};
				  7: {LCD_RS, LCD_DATA} = {1'b1,  "K"};
				  8: {LCD_RS, LCD_DATA} = {1'b1,  "i"};
				  9: {LCD_RS, LCD_DATA} = {1'b1,  " "};
				 10: {LCD_RS, LCD_DATA} = {1'b1,  " "};
				 11: {LCD_RS, LCD_DATA} = {1'b1,  "K"};
				 12: {LCD_RS, LCD_DATA} = {1'b1,  "d"};
				 13: {LCD_RS, LCD_DATA} = {1'b1,  " "};
				 14: {LCD_RS, LCD_DATA} = {1'b1,  " "};
				 15: {LCD_RS, LCD_DATA} = {1'b1,  "C"};
				 16: {LCD_RS, LCD_DATA} = {1'b1,  "O"};
				 17: {LCD_RS, LCD_DATA} = {1'b1,  "M"};
				 18: {LCD_RS, LCD_DATA} = {1'b1,  "M"};
			 
				 19: {LCD_RS, LCD_DATA} = {1'b0, 8'b1100_0000};		// Set DDRAM address: Move cursor to the beginning of second line
			 	
				 20: {LCD_RS, LCD_DATA} = {1'b1,  "X"};
				 21: {LCD_RS, LCD_DATA} = {1'b1,  "X"};
				 22: {LCD_RS, LCD_DATA} = {1'b1,  "X"};
				 23: {LCD_RS, LCD_DATA} = {1'b1,  " "};
				 24: {LCD_RS, LCD_DATA} = {1'b1,  "X"};
				 25: {LCD_RS, LCD_DATA} = {1'b1,  "X"};
				 26: {LCD_RS, LCD_DATA} = {1'b1,  "X"};
				 27: {LCD_RS, LCD_DATA} = {1'b1,  " "};
				 28: {LCD_RS, LCD_DATA} = {1'b1,  "X"};
				 29: {LCD_RS, LCD_DATA} = {1'b1,  "X"};
				 30: {LCD_RS, LCD_DATA} = {1'b1,  "X"};
				 31: {LCD_RS, LCD_DATA} = {1'b1,  " "};
				 32: {LCD_RS, LCD_DATA} = {1'b1,  "S"};
				 33: {LCD_RS, LCD_DATA} = {1'b1,  "E"};
				 34: {LCD_RS, LCD_DATA} = {1'b1,  "N"};
				 35: {LCD_RS, LCD_DATA} = {1'b1,  "S"};

			default: {LCD_RS, LCD_DATA} = {1'b0, 8'b1000_0000};		// Set DDRAM address: Move cursor to the beginning of first line
		endcase 
	end
endmodule 