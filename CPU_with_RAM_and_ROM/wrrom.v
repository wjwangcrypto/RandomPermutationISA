module wrrom(
    input clk,
	input rst,
    input Rx_done,
    input debug_en_i,
    input [7:0]rx_Data,
    output wire req_o,
	output reg  wrromdone,
	output reg [31:0] w_addr,
    output reg [31:0] w_data
	
	
);
    assign req_o = (rst == 1'b1 && debug_en_i == 1'b1)? 1'b1: 1'b0;
    reg [3:0]count;
    reg [31:0]data;
    reg flag;
    always@(posedge clk or negedge rst) begin
		if(!rst) begin          //若复位端有效，则将写地址置零
            w_addr <= 31'd0;
            w_data <= 31'd0;
            wrromdone<= 0;
            count <=1;
            flag <=0;
        end
		else if (debug_en_i == 1'b1) begin
            if(Rx_done)  begin   //如果接收完成，则将写地址移到下一个
			    if (count ==1) begin
                    w_data <= {rx_Data,w_data[23:0]};
          
                end
                if (count ==2) begin
                    w_data <= {w_data[31:24],rx_Data,w_data[15:0]};
        
                end
                if (count ==3) begin
                    w_data <= {w_data[31:16],rx_Data,w_data[7:0]};
                   
                end
                if (count ==4) begin
                    w_data <= {w_data[31:8],rx_Data};
                    wrromdone <=1;
                    if (flag == 1) begin
                        w_addr <=w_addr+4; 
                    end
                    flag <=1;
                    count<=1;
                end else begin
                    count<=count+1;
                end
            end
		    else begin
                w_addr <= w_addr;    //其余情况，写地址不动
                wrromdone <=0;
            
            end
        end
    end


    
endmodule