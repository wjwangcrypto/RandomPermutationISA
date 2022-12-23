//串口发送模块
module uart_tx
#(
	parameter 		BPS		= 'd115200		,	//发送波特率
	parameter 		CLK_FRE	= 'd5000000		//输入时钟频率
)
(
//系统接口
	input 			sys_clk			,			//系统时钟
	input 			sys_rst_n		,			//系统复位，低电平有效
//用户接口	
	input	[7:0] 	uart_tx_data	,			//需要通过UART发送的数据，在uart_tx_en为高电平时有效
	input			uart_tx_en		,			//发送使能，当其为高电平时，代表此时需要发送数据
//UART发送线		
	output reg 		uart_txd					//UART发送数据线
);
 
//根据波特率计算传输每个bit需要多个系统时钟
localparam	BPS_CNT = CLK_FRE / BPS;
 
//reg define
reg 		uart_tx_en_d1	;					//发送使能信号打1拍
reg			uart_tx_en_d0	;					//发送使能信号打2拍
reg 		tx_en			;					//发送标志信号，拉高代表发送过程正在进行
reg [7:0]  	uart_data_reg	;					//寄存要发送的数据
reg [15:0] 	clk_cnt			;					//计数器，用于计数发送一个bit数据所需要的时钟数
reg [3:0]  	bit_cnt			;					//bit计数器，标志当前发送了多少个bit
//wire define			
wire 		pos_uart_tx_en	;					//使能端的上升沿信号
 
//捕捉使能端的上升沿信号
assign pos_uart_tx_en = uart_tx_en_d0 && (~uart_tx_en_d1);
 
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		uart_tx_en_d0 <= 1'b0;
		uart_tx_en_d1 <= 1'b0;		
	end                  
	else begin           
		uart_tx_en_d0 <= uart_tx_en;
		uart_tx_en_d1 <= uart_tx_en_d0;
	end	
end
 
//当发送使能信号到达时,寄存待发送的数据，并进入发送过程
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		tx_en <=1'b0;
		uart_data_reg <=8'd0;
	end
	else if(pos_uart_tx_en)begin								//发送使能有效
		uart_data_reg <= uart_tx_data;							//寄存需要发送的数据
		tx_en <= 1'b1;											//拉高发送使能，标志进入发送状态
	end	
	else if((bit_cnt == 4'd9) && (clk_cnt == BPS_CNT >> 1'b1))begin	//发送完了全部数据	
		tx_en <= 1'b0;                                          //拉低发送使能，标志退出发送状态
		uart_data_reg <= 8'd0;                                  //清空寄存数据
	end
	else begin
		uart_data_reg <= uart_data_reg;
		tx_en <= tx_en;	
	end
end
//进入发送过程后，启动时钟计数器与发送bit计数器
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		clk_cnt <= 16'd0;
		bit_cnt <= 4'd0;
	end
	else if(tx_en) begin										//在发送状态
		if(clk_cnt < BPS_CNT - 1'd1)begin						//一个bit数据没有发送完
			clk_cnt <= clk_cnt + 1'b1;							//时钟计数器+1
			bit_cnt <= bit_cnt;									//bit计数器不变
		end					
		else begin												//一个bit数据发送完了	
			clk_cnt <= 16'd0;									//清空时钟计数器，重新开始计时
			bit_cnt <= bit_cnt+1'b1;							//bit计数器+1，表示发送完了一个bit的数据
		end					
	end					
	else begin													//不在发送状态
		clk_cnt <= 16'd0;                   					//清零
		bit_cnt <= 4'd0;                    					//清零
	end
end
//根据发送数据计数器来给uart发送端口赋值
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		uart_txd <= 1'b1;										//默认为高状态
	else if(tx_en)                                  			//处于发送状态
		case(bit_cnt)											//数据发送从低位到高位
			4'd0: uart_txd <= 1'b0;								//起始位，拉低发送数据线
			4'd1: uart_txd <= uart_data_reg[0];     			//LSB
			4'd2: uart_txd <= uart_data_reg[1];     			//
			4'd3: uart_txd <= uart_data_reg[2];     			//
			4'd4: uart_txd <= uart_data_reg[3];     			//
			4'd5: uart_txd <= uart_data_reg[4];     			//
			4'd6: uart_txd <= uart_data_reg[5];     			//
			4'd7: uart_txd <= uart_data_reg[6];     			//
			4'd8: uart_txd <= uart_data_reg[7];     			//MSB
			4'd9: uart_txd <= 1'b1;								//终止位，拉高发送数据线
			default:;			
		endcase			
	else 														//不处于发送状态
		uart_txd <= 1'b1;										//默认为高状态
end
 
endmodule 