module topc (
    input clk,
	input rst,
    input start,
    input rstflagz,
    input [31:0]r_data,

    output reg txen,
    output reg [7:0] txpcdata
    
);
    
    reg [31:0] data;
    reg busyone;
    reg busy;
    reg starttx;
    reg [13:0]clkcount;
    reg [1:0] bitcount;
    reg [3:0]txflag;
    reg flag;
    always@(posedge clk ) begin
		if(!rst) begin          //若复位端有效，则将写地址置零
            flag<=0;
            data<=0;
            busyone<=0;
            busy<=0;
            bitcount<=0;
            clkcount<=0;
            txflag<=0;
            starttx<=0;
            txen<=0;
            txpcdata<=0;
        end 
        else begin
            if(rstflagz ==1 && flag !==1)begin
                busyone<=0;
            end
            if(start === 1 && busyone===0 )begin
                busy <=1;
            end
            if(flag===1)begin
                data<=r_data;
                busy<=0;
                starttx <=1;
                flag <=0;
                busyone<=1;

            end else if(busy ==1) begin
                
                flag<=1;
            end
            


            if(starttx === 1)begin
               
                if(bitcount ===0)begin
                    
                    if (clkcount != 14'b11000010010000) begin ///13'b1000001001000
                        clkcount<=clkcount+1;
                    end
                    if(clkcount == 0)begin
                        txen <=1;
                        
                    end else begin
                        txen <=0;
                    end
                    if(clkcount == 14'b11000010010000)begin
                        bitcount<= bitcount+1;
                        clkcount<=0;
                        
                    end
                    case (txflag)
                        'd0: begin
                            txpcdata<=0;
                        end
                        'd1: begin
                            txpcdata<=0;
                        end
                        'd2: begin
                            txpcdata<=0;
                        end
                        'd3: begin
                            txpcdata<=0;
                        end
                       
                        default:   ;
                    endcase
                end 
                if(bitcount ===1) begin
              
                    if (clkcount != 14'b11000010010000) begin ///13'b1000001001000
                        clkcount<=clkcount+1;
                    end
                    if(clkcount == 0)begin
                        txen <=1;
                        
                    end else begin
                        txen <=0;
                    end
                    if(clkcount == 14'b11000010010000)begin
                        bitcount<= bitcount+1;
                        clkcount<=0;
                   
                    end
                    case (txflag)
                        'd0: begin
                            txpcdata<=0;
                        end
                        'd1: begin
                            txpcdata<=0;
                        end
                        'd2: begin
                            txpcdata<=0;
                        end
                        'd3: begin
                            txpcdata<=0;
                        end
                       
                        default:   ;
                    endcase
                end 
                if(bitcount ===2) begin
                   
                    if (clkcount != 14'b11000010010000) begin ///13'b1000001001000
                        clkcount<=clkcount+1;
                    end
                    if(clkcount == 0)begin
                        txen <=1;
                        
                    end else begin
                        txen <=0;
                    end
                    if(clkcount == 14'b11000010010000)begin
                        bitcount<= bitcount+1;
                        clkcount<=0;
                   
                    end
                    case (txflag)
                        'd0: begin
                            txpcdata<=0;
                        end
                        'd1: begin
                            txpcdata<=0;
                        end
                        'd2: begin
                            txpcdata<=0;
                        end
                        'd3: begin
                            txpcdata<=0;
                        end
                        
                        default:   ;
                    endcase
                end 
                if(bitcount ===3) begin
                    txen <=1;
                    
                    if(clkcount == 0)begin
                        txen <=1;
                        
                    end else begin
                        txen <=0;
                    end
                    case (txflag)
                        'd0: begin
                            txpcdata<=data[7:0];
                        end
                        'd1: begin
                            txpcdata<=data[15:8];
                        end
                        'd2: begin
                            txpcdata<=data[23:16];
                        end
                        'd3: begin
                            txpcdata<=data[31:24];
                        end
                        
                        default:   ;
                    endcase
                    if (clkcount != 14'b11000010010000) begin
                        clkcount<=clkcount+1;
                    end
                    if(clkcount == 14'b11000010010000)begin
                        clkcount<=0;
                        bitcount<= 0;
                    
                        if(txflag === 3)begin
                            txflag<=0;
                            starttx<=0;
                      
                        end else begin
                            txflag <= txflag+1;
                        end
                        
                    end
                    
                end
                
            end

            


        end

    end
    
endmodule