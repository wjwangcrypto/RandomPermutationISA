//串口接收模块
module uart_rx
#(
	parameter 			BPS		= 'd115200		,	//发送波特率
	parameter 			CLK_FRE	= 'd5000000		//输入时钟频率
)	
(	
//系统接口
	input 				sys_clk			,			//系统时钟
	input 				sys_rst_n		,			//系统复位
//UART接收线	
	input 				uart_rxd		,			//接收数据线
//用户接口	
	output reg 			uart_rx_done	,			//数据接收完成标志，当其为高电平时，代表接收数据有效
	output reg [7:0]	uart_rx_data				//接收到的数据，在uart_rx_done为高电平时有效
);
 
//根据波特率计算传输每个bit需要多个系统时钟
localparam	BPS_CNT = CLK_FRE / BPS;	
 
//reg define
reg 			uart_rx_d0		;					//寄存1拍
reg 			uart_rx_d1		;					//寄存2拍
reg [15:0]		clk_cnt			;					//计数器，用于计数发送一个bit数据所需要的时钟数
reg [3:0]  		bit_cnt			;					//bit计数器，标志当前发送了多少个bit
reg 			rx_en			;					//接收标志信号，拉高代表接收过程正在进行
reg [7:0]		uart_rx_data_reg;					//接收数据寄存
//wire define				
wire 			neg_uart_rxd	;					//接收数据线的下降沿
 
//捕获数据线的下降沿，用来标志数据传输开始
assign	neg_uart_rxd = uart_rx_d1 & (~uart_rx_d0);
 
//将数据线打两拍，作用1：同步不同时钟域信号，防止亚稳态；作用2：用以捕获下降沿
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		uart_rx_d0 <= 1'b0;
		uart_rx_d1 <= 1'b0;
	end
	else begin
		uart_rx_d0 <= uart_rxd;
		uart_rx_d1 <= uart_rx_d0;
	end		
end
//捕获到数据下降沿（起始位0）后，拉高传输开始标志位，并在第9个数据（终止位）的传输过程正中（数据比较稳定）再将传输开始标志位拉低，标志传输结束
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		rx_en <= 1'b0;
	else begin 
		if(neg_uart_rxd )								
			rx_en <= 1'b1;
		//接收完第9个数据（终止位）将传输开始标志位拉低，标志传输结束
		//假如不在停止位的中间结束接收过程--当第二次接收的起始位紧跟第一次接收的停止位，那么就会造成第一次接收无法结束，状态寄存器无法复位
		else if((bit_cnt == 4'd9) && (clk_cnt == BPS_CNT >> 1'b1))
			rx_en <= 1'b0;
		else 
			rx_en <= rx_en;			
	end
end
//时钟每计数一个BPS_CNT（传输一位数据所需要的时钟个数），即将数据计数器加1，并清零时钟计数器
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		bit_cnt <= 4'd0;
		clk_cnt <= 16'd0;
	end
	else if(rx_en)begin					            			//在接收状态
		if(clk_cnt < BPS_CNT - 1'b1)begin           			//一个bit数据没有接收完
			clk_cnt <= clk_cnt + 1'b1;              			//时钟计数器+1
			bit_cnt <= bit_cnt;                     			//bit计数器不变
		end                                         			
		else begin                                  			//一个bit数据接收完了	
			clk_cnt <= 16'd0;                       			//清空时钟计数器，重新开始计时
			bit_cnt <= bit_cnt + 1'b1;              			//bit计数器+1，表示接收完了一个bit的数据
		end                                         			
	end                                             			
		else begin                                  			//不在接收状态
			bit_cnt <= 4'd0;                        			//清零
			clk_cnt <= 16'd0;                       			//清零
		end		
end
//在每个数据的传输过程正中（数据比较稳定）将数据线上的数据赋值给数据寄存器
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		uart_rx_data_reg <= 8'd0;                            	//复位无接收数据
	else if(rx_en)                                           	//处于接收状态
		if(clk_cnt == BPS_CNT >> 1'b1) begin                 	//传输过程正中（数据比较稳定）
			case(bit_cnt)			                         	//根据位数决定接收的内容是什么
				4'd1:uart_rx_data_reg[0] <= uart_rxd;        	//LSB
				4'd2:uart_rx_data_reg[1] <= uart_rxd;        	//
				4'd3:uart_rx_data_reg[2] <= uart_rxd;        	//
				4'd4:uart_rx_data_reg[3] <= uart_rxd;        	//
				4'd5:uart_rx_data_reg[4] <= uart_rxd;        	//
				4'd6:uart_rx_data_reg[5] <= uart_rxd;        	//
				4'd7:uart_rx_data_reg[6] <= uart_rxd;        	//
				4'd8:uart_rx_data_reg[7] <= uart_rxd;        	//MSB
				default:;                                    	//0和9分别是起始位和终止位，不需要接收
			endcase                                          	
		end                                                  	
		else                                                 	//数据不一定稳定就不接收
			uart_rx_data_reg <= uart_rx_data_reg;            
	else
		uart_rx_data_reg <= 8'd0;								//不处于接收状态
end	
//当数据传输到终止位时，拉高传输完成标志位，并将数据输出
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		uart_rx_done <= 1'b0;
		uart_rx_data <= 8'd0;
	end	
	//结束接收后，将接收到的数据输出
	else if(bit_cnt == 4'd9 && (clk_cnt == BPS_CNT >> 1'd1))begin	
		uart_rx_done <= 1'b1;									//仅仅拉高一个时钟周期
		uart_rx_data <= uart_rx_data_reg;					
	end							
	else begin					
		uart_rx_done <= 1'b0;									//仅仅拉高一个时钟周期
		uart_rx_data <= uart_rx_data;
	end
end
endmodule 