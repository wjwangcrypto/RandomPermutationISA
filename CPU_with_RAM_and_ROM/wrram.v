module wrram(
    input clk,
	input rst,
    input Rx_done,
    input debug_en_i,
    input [7:0]rx_Data,
    output reg req_o,
	output reg  wrramdone,
    output reg  rstflag,
    output reg  zflag,
	output reg [31:0] w_addr,
    output reg [31:0] w_data
	
	
);
    //assign req_o = (rst == 1'b1 && debug_en_i == 1'b1)? 1'b1: 1'b0;
    reg [3:0]count;
    reg [31:0]data;
    reg [5:0]flag;
    reg [13:0] clkcount;
    always@(posedge clk or negedge rst) begin
		if(!rst) begin          //???λ?????????д??????
            w_addr <= 31'h10000000;
            w_data <= 31'd0;
            wrramdone<= 0;
            count <=1;
            flag <=0;
            req_o<=1;
            rstflag<=0;
            clkcount<=0;
            zflag<=1;
        end
		else if (debug_en_i === 1'b1) begin
            if (flag === 6'b101101) begin
                req_o<=0;
                rstflag<=1;
                if (clkcount != 14'b01000000000000) begin
                    clkcount<=clkcount+1;
                end
                
                if (clkcount === 14'b01000000000000) begin
                    rstflag<=0;
                    zflag<=0;
                end
                //if (((clkcount === 19'b1000000000000000000)&&(Rx_done===1))||(endflag===1)) begin
                if (((clkcount === 14'b01000000000000)&&(Rx_done===1))) begin
                    flag<=0;
                    w_addr <=31'h10000000; 
                    clkcount<=0;
                    req_o <=1;
                end
            end
            if(Rx_done)  begin   //????????????д???????һ??
                zflag<=1;
                if (count ==1) begin

                    w_data <= {rx_Data,w_data[23:0]};

                    
                    count<=count+1;
                    req_o <=1;
                    rstflag<=0; 
                end
                if (count ==2) begin

                    w_data <= {w_data[31:24],rx_Data,w_data[15:0]};

                    count<=count+1;
                    req_o <=1;
                    rstflag<=0;
        
                end
                if (count ==3) begin

                    w_data <= {w_data[31:16],rx_Data,w_data[7:0]};
  
                    
                    count<=count+1;
                    req_o <=1;
                    rstflag<=0;
                end
                if (count ==4) begin

                    w_data <= {w_data[31:8],rx_Data};
                    wrramdone <=1;
  
                    
                    if (flag === 0) begin
                        w_addr <=w_addr;
                    end else begin
                        w_addr <=w_addr+4;
                    end
                    flag <=flag+1;
                    count<=1;  
                    req_o <=1;
                    rstflag<=0;
               
                end
			    else begin
                
                end 
            
                
            end
		    else begin
                w_addr <= w_addr;    //???????д???????
                wrramdone <=0;
            
            end
        end
    end


    
endmodule