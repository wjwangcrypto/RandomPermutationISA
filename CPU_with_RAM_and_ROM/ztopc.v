module ztopc (
    input clk,
	input rst,
    input start,
    input [31:0]r_data,
    input rstflagz,

    output reg req_o,
    output reg zwe,
    output reg [31:0] r_addr,
    output reg txen,
    output reg [7:0] txpcdata
    
);
    reg busy;
    reg [3:0]flag;
    reg [31:0] zero0;
    reg [31:0] one1;
    reg [31:0] zz2;
    reg [31:0] zz3;
    reg [31:0] zz4;
    reg [31:0] zz5;
    reg [31:0] zz6;
    reg [31:0] zz7;
    reg starttx;
    reg [13:0]clkcount;
    reg [1:0] bitcount;
    reg [3:0]txflag;
    reg busyone;
    always@(posedge clk ) begin
		if(!rst) begin          //若复位端有效，则将写地址置零
            r_addr <= 0;
            flag<=0;
            zwe<= 0;
            busy<=0;
            req_o<=0;
            bitcount<=0;
            clkcount<=0;
            txflag<=0;
            busyone<=0;
            starttx<=0;
            txen<=0;
        end 
        else begin
            if(rstflagz ==1 && flag !== 4'b1001)begin
                busyone<=0;
            end
            if(start === 1 && busyone===0 )begin
                busy <=1;
            end
            if(flag === 4'b1001)begin
                r_addr <= 0;
                flag<=0;
                zwe<= 0;
                busy<=0;
                req_o<=0;
                starttx <=1;
                busyone<=1;
            end else if(busy ==1) begin
                req_o <=1;
                zwe<=1;
                if(flag == 0)begin
                    r_addr <= 31'h10003f10;
                    
                end else begin
                    r_addr<=r_addr+4;
                end
                
                case (flag)
                    'd0: begin
                    end
                    'd1: begin
                        zero0 <=r_data;
                    end
                    'd2: begin
                        one1 <=r_data;
                    end
                    'd3: begin
                        zz2 <=r_data;
                    end
                    'd4: begin
                        zz3 <=r_data;
                    end
                    'd5: begin
                        zz4<=r_data;
                    end
                    'd6: begin
                        zz5 <=r_data;
                    end
                    'd7: begin
                        zz6<=r_data;
                    end
                    'd8: begin
                        zz7<=r_data;
                    end
                    default:   ;
                endcase
                flag <= flag+1;
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
                            txpcdata<=zero0[31:24];
                        end
                        'd1: begin
                            txpcdata<=one1[31:24];
                        end
                        'd2: begin
                            txpcdata<=zz2[31:24];
                        end
                        'd3: begin
                            txpcdata<=zz3[31:24];
                        end
                        'd4: begin
                            txpcdata<=zz4[31:24];
                        end
                        'd5: begin
                            txpcdata<=zz5[31:24];
                        end
                        'd6: begin
                            txpcdata<=zz6[31:24];
                        end
                        'd7: begin
                            txpcdata<=zz7[31:24];
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
                            txpcdata<=zero0[23:16];
                        end
                        'd1: begin
                            txpcdata<=one1[23:16];
                        end
                        'd2: begin
                            txpcdata<=zz2[23:16];
                        end
                        'd3: begin
                            txpcdata<=zz3[23:16];
                        end
                        'd4: begin
                            txpcdata<=zz4[23:16];
                        end
                        'd5: begin
                            txpcdata<=zz5[23:16];
                        end
                        'd6: begin
                            txpcdata<=zz6[23:16];
                        end
                        'd7: begin
                            txpcdata<=zz7[23:16];
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
                            txpcdata<=zero0[15:8];
                        end
                        'd1: begin
                            txpcdata<=one1[15:8];
                        end
                        'd2: begin
                            txpcdata<=zz2[15:8];
                        end
                        'd3: begin
                            txpcdata<=zz3[15:8];
                        end
                        'd4: begin
                            txpcdata<=zz4[15:8];
                        end
                        'd5: begin
                            txpcdata<=zz5[15:8];
                        end
                        'd6: begin
                            txpcdata<=zz6[15:8];
                        end
                        'd7: begin
                            txpcdata<=zz7[15:8];
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
                            txpcdata<=zero0[7:0];
                        end
                        'd1: begin
                            txpcdata<=one1[7:0];
                        end
                        'd2: begin
                            txpcdata<=zz2[7:0];
                        end
                        'd3: begin
                            txpcdata<=zz3[7:0];
                        end
                        'd4: begin
                            txpcdata<=zz4[7:0];
                        end
                        'd5: begin
                            txpcdata<=zz5[7:0];
                        end
                        'd6: begin
                            txpcdata<=zz6[7:0];
                        end
                        'd7: begin
                            txpcdata<=zz7[7:0];
                        end
                        default:   ;
                    endcase
                    if (clkcount != 14'b11000010010000) begin
                        clkcount<=clkcount+1;
                    end
                    if(clkcount == 14'b11000010010000)begin
                        clkcount<=0;
                        bitcount<= 0;
                    
                        if(txflag === 7)begin
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