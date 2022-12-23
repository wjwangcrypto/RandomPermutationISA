//���ڷ���ģ��
module uart_tx
#(
	parameter 		BPS		= 'd115200		,	//���Ͳ�����
	parameter 		CLK_FRE	= 'd5000000		//����ʱ��Ƶ��
)
(
//ϵͳ�ӿ�
	input 			sys_clk			,			//ϵͳʱ��
	input 			sys_rst_n		,			//ϵͳ��λ���͵�ƽ��Ч
//�û��ӿ�	
	input	[7:0] 	uart_tx_data	,			//��Ҫͨ��UART���͵����ݣ���uart_tx_enΪ�ߵ�ƽʱ��Ч
	input			uart_tx_en		,			//����ʹ�ܣ�����Ϊ�ߵ�ƽʱ�������ʱ��Ҫ��������
//UART������		
	output reg 		uart_txd					//UART����������
);
 
//���ݲ����ʼ��㴫��ÿ��bit��Ҫ���ϵͳʱ��
localparam	BPS_CNT = CLK_FRE / BPS;
 
//reg define
reg 		uart_tx_en_d1	;					//����ʹ���źŴ�1��
reg			uart_tx_en_d0	;					//����ʹ���źŴ�2��
reg 		tx_en			;					//���ͱ�־�źţ����ߴ����͹������ڽ���
reg [7:0]  	uart_data_reg	;					//�Ĵ�Ҫ���͵�����
reg [15:0] 	clk_cnt			;					//�����������ڼ�������һ��bit��������Ҫ��ʱ����
reg [3:0]  	bit_cnt			;					//bit����������־��ǰ�����˶��ٸ�bit
//wire define			
wire 		pos_uart_tx_en	;					//ʹ�ܶ˵��������ź�
 
//��׽ʹ�ܶ˵��������ź�
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
 
//������ʹ���źŵ���ʱ,�Ĵ�����͵����ݣ������뷢�͹���
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		tx_en <=1'b0;
		uart_data_reg <=8'd0;
	end
	else if(pos_uart_tx_en)begin								//����ʹ����Ч
		uart_data_reg <= uart_tx_data;							//�Ĵ���Ҫ���͵�����
		tx_en <= 1'b1;											//���߷���ʹ�ܣ���־���뷢��״̬
	end	
	else if((bit_cnt == 4'd9) && (clk_cnt == BPS_CNT >> 1'b1))begin	//��������ȫ������	
		tx_en <= 1'b0;                                          //���ͷ���ʹ�ܣ���־�˳�����״̬
		uart_data_reg <= 8'd0;                                  //��ռĴ�����
	end
	else begin
		uart_data_reg <= uart_data_reg;
		tx_en <= tx_en;	
	end
end
//���뷢�͹��̺�����ʱ�Ӽ������뷢��bit������
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		clk_cnt <= 16'd0;
		bit_cnt <= 4'd0;
	end
	else if(tx_en) begin										//�ڷ���״̬
		if(clk_cnt < BPS_CNT - 1'd1)begin						//һ��bit����û�з�����
			clk_cnt <= clk_cnt + 1'b1;							//ʱ�Ӽ�����+1
			bit_cnt <= bit_cnt;									//bit����������
		end					
		else begin												//һ��bit���ݷ�������	
			clk_cnt <= 16'd0;									//���ʱ�Ӽ����������¿�ʼ��ʱ
			bit_cnt <= bit_cnt+1'b1;							//bit������+1����ʾ��������һ��bit������
		end					
	end					
	else begin													//���ڷ���״̬
		clk_cnt <= 16'd0;                   					//����
		bit_cnt <= 4'd0;                    					//����
	end
end
//���ݷ������ݼ���������uart���Ͷ˿ڸ�ֵ
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		uart_txd <= 1'b1;										//Ĭ��Ϊ��״̬
	else if(tx_en)                                  			//���ڷ���״̬
		case(bit_cnt)											//���ݷ��ʹӵ�λ����λ
			4'd0: uart_txd <= 1'b0;								//��ʼλ�����ͷ���������
			4'd1: uart_txd <= uart_data_reg[0];     			//LSB
			4'd2: uart_txd <= uart_data_reg[1];     			//
			4'd3: uart_txd <= uart_data_reg[2];     			//
			4'd4: uart_txd <= uart_data_reg[3];     			//
			4'd5: uart_txd <= uart_data_reg[4];     			//
			4'd6: uart_txd <= uart_data_reg[5];     			//
			4'd7: uart_txd <= uart_data_reg[6];     			//
			4'd8: uart_txd <= uart_data_reg[7];     			//MSB
			4'd9: uart_txd <= 1'b1;								//��ֹλ�����߷���������
			default:;			
		endcase			
	else 														//�����ڷ���״̬
		uart_txd <= 1'b1;										//Ĭ��Ϊ��״̬
end
 
endmodule 