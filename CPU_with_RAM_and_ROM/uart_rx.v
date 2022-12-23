//���ڽ���ģ��
module uart_rx
#(
	parameter 			BPS		= 'd115200		,	//���Ͳ�����
	parameter 			CLK_FRE	= 'd5000000		//����ʱ��Ƶ��
)	
(	
//ϵͳ�ӿ�
	input 				sys_clk			,			//ϵͳʱ��
	input 				sys_rst_n		,			//ϵͳ��λ
//UART������	
	input 				uart_rxd		,			//����������
//�û��ӿ�	
	output reg 			uart_rx_done	,			//���ݽ�����ɱ�־������Ϊ�ߵ�ƽʱ���������������Ч
	output reg [7:0]	uart_rx_data				//���յ������ݣ���uart_rx_doneΪ�ߵ�ƽʱ��Ч
);
 
//���ݲ����ʼ��㴫��ÿ��bit��Ҫ���ϵͳʱ��
localparam	BPS_CNT = CLK_FRE / BPS;	
 
//reg define
reg 			uart_rx_d0		;					//�Ĵ�1��
reg 			uart_rx_d1		;					//�Ĵ�2��
reg [15:0]		clk_cnt			;					//�����������ڼ�������һ��bit��������Ҫ��ʱ����
reg [3:0]  		bit_cnt			;					//bit����������־��ǰ�����˶��ٸ�bit
reg 			rx_en			;					//���ձ�־�źţ����ߴ�����չ������ڽ���
reg [7:0]		uart_rx_data_reg;					//�������ݼĴ�
//wire define				
wire 			neg_uart_rxd	;					//���������ߵ��½���
 
//���������ߵ��½��أ�������־���ݴ��俪ʼ
assign	neg_uart_rxd = uart_rx_d1 & (~uart_rx_d0);
 
//�������ߴ����ģ�����1��ͬ����ͬʱ�����źţ���ֹ����̬������2�����Բ����½���
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
//���������½��أ���ʼλ0�������ߴ��俪ʼ��־λ�����ڵ�9�����ݣ���ֹλ���Ĵ���������У����ݱȽ��ȶ����ٽ����俪ʼ��־λ���ͣ���־�������
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		rx_en <= 1'b0;
	else begin 
		if(neg_uart_rxd )								
			rx_en <= 1'b1;
		//�������9�����ݣ���ֹλ�������俪ʼ��־λ���ͣ���־�������
		//���粻��ֹͣλ���м�������չ���--���ڶ��ν��յ���ʼλ������һ�ν��յ�ֹͣλ����ô�ͻ���ɵ�һ�ν����޷�������״̬�Ĵ����޷���λ
		else if((bit_cnt == 4'd9) && (clk_cnt == BPS_CNT >> 1'b1))
			rx_en <= 1'b0;
		else 
			rx_en <= rx_en;			
	end
end
//ʱ��ÿ����һ��BPS_CNT������һλ��������Ҫ��ʱ�Ӹ��������������ݼ�������1��������ʱ�Ӽ�����
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		bit_cnt <= 4'd0;
		clk_cnt <= 16'd0;
	end
	else if(rx_en)begin					            			//�ڽ���״̬
		if(clk_cnt < BPS_CNT - 1'b1)begin           			//һ��bit����û�н�����
			clk_cnt <= clk_cnt + 1'b1;              			//ʱ�Ӽ�����+1
			bit_cnt <= bit_cnt;                     			//bit����������
		end                                         			
		else begin                                  			//һ��bit���ݽ�������	
			clk_cnt <= 16'd0;                       			//���ʱ�Ӽ����������¿�ʼ��ʱ
			bit_cnt <= bit_cnt + 1'b1;              			//bit������+1����ʾ��������һ��bit������
		end                                         			
	end                                             			
		else begin                                  			//���ڽ���״̬
			bit_cnt <= 4'd0;                        			//����
			clk_cnt <= 16'd0;                       			//����
		end		
end
//��ÿ�����ݵĴ���������У����ݱȽ��ȶ������������ϵ����ݸ�ֵ�����ݼĴ���
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		uart_rx_data_reg <= 8'd0;                            	//��λ�޽�������
	else if(rx_en)                                           	//���ڽ���״̬
		if(clk_cnt == BPS_CNT >> 1'b1) begin                 	//����������У����ݱȽ��ȶ���
			case(bit_cnt)			                         	//����λ���������յ�������ʲô
				4'd1:uart_rx_data_reg[0] <= uart_rxd;        	//LSB
				4'd2:uart_rx_data_reg[1] <= uart_rxd;        	//
				4'd3:uart_rx_data_reg[2] <= uart_rxd;        	//
				4'd4:uart_rx_data_reg[3] <= uart_rxd;        	//
				4'd5:uart_rx_data_reg[4] <= uart_rxd;        	//
				4'd6:uart_rx_data_reg[5] <= uart_rxd;        	//
				4'd7:uart_rx_data_reg[6] <= uart_rxd;        	//
				4'd8:uart_rx_data_reg[7] <= uart_rxd;        	//MSB
				default:;                                    	//0��9�ֱ�����ʼλ����ֹλ������Ҫ����
			endcase                                          	
		end                                                  	
		else                                                 	//���ݲ�һ���ȶ��Ͳ�����
			uart_rx_data_reg <= uart_rx_data_reg;            
	else
		uart_rx_data_reg <= 8'd0;								//�����ڽ���״̬
end	
//�����ݴ��䵽��ֹλʱ�����ߴ�����ɱ�־λ�������������
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		uart_rx_done <= 1'b0;
		uart_rx_data <= 8'd0;
	end	
	//�������պ󣬽����յ����������
	else if(bit_cnt == 4'd9 && (clk_cnt == BPS_CNT >> 1'd1))begin	
		uart_rx_done <= 1'b1;									//��������һ��ʱ������
		uart_rx_data <= uart_rx_data_reg;					
	end							
	else begin					
		uart_rx_done <= 1'b0;									//��������һ��ʱ������
		uart_rx_data <= uart_rx_data;
	end
end
endmodule 