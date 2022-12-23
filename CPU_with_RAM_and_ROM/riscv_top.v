`include "defines.v"

// riscv soc顶层模块
module riscv_top(

    input wire clkyuanshi,
    input wire rstyuanshi,
    
    input wire uart_debug_pin, // 串口下载使能引脚  1 rom写 0ram写
    input wire uart_rx_pin,  // UART接收引脚
    output uart_TXD,
    output reg chufa,

	
    output reg succ         // 测试是否成功信号
    
   

    );
    
    wire clk;
   
    wire rst;

    







    
    reg [3:0]            cnt ;
    always @(posedge clkyuanshi or negedge rstyuanshi) begin
        if (!rstyuanshi) begin
            cnt    <= 'b0 ;
        end
        else if (cnt == 4'd9) begin//cnt == (DIV_CLK/2)-1
            cnt    <= 'b0 ;
        end
        else begin
            cnt    <= cnt + 1'b1 ;
        end
    end

    //??????
    reg                  clk_div10_r ;
    always @(posedge clkyuanshi or negedge rstyuanshi) begin
        if (!rstyuanshi) begin
            clk_div10_r <= 1'b0 ;
        end
        else if (cnt == 4'd9 ) begin
            clk_div10_r <= ~clk_div10_r ;
        end
    end
    assign clk = clk_div10_r ;

    reg d1;
    reg d2;
    reg d3;
    reg d4;
    reg d5;
    reg d6;
    reg d7;
    reg d8;
    reg d9;
    reg d10;
    reg d11;

    always @ (posedge clkyuanshi) begin
        if (!rstyuanshi) begin
            d1 <= 1'b0 ;
            d2 <= 1'b0 ;
            d3 <= 1'b0 ;
            d4 <= 1'b0 ;
            d5 <= 1'b0 ;
            d6 <= 1'b0 ;
            d7 <= 1'b0 ;
            d8 <= 1'b0 ;
            d9 <= 1'b0 ;
            d10 <= 1'b0 ;
            d11 <= 1'b0 ;
            
        end
        d1 <= rstyuanshi;
        d2 <= d1;
        d3 <= d2;
        d4 <= d3;
        d5 <= d4;
        d6 <= d5 ;
        d7 <= d6;
        d8 <= d7 ;
        d9 <= d8 ;
        d10 <=d9 ;
        d11 <= d10 ;
    end
    assign rst = d11;



    wire[`MemAddrBus] m0_addr_i;
    wire[`MemBus] m0_data_i;
    wire[`MemBus] m0_data_o;
    wire m0_req_i;
    wire m0_we_i;


    wire[`MemAddrBus] m1_addr_i;
    wire[`MemBus] m1_data_i;
    wire[`MemBus] m1_data_o;
    wire m1_req_i;
    wire m1_we_i;


    wire[`MemAddrBus] m2_addr_i;
    wire[`MemBus] m2_data_i;
    wire[`MemBus] m2_data_o;
    wire m2_req_i;
    wire m2_we_i;

 
    wire[`MemAddrBus] m3_addr_i;
    wire[`MemBus] m3_data_i;
    wire[`MemBus] m3_data_o;
    wire m3_req_i;
    wire m3_we_i;

    wire[`MemAddrBus] m4_addr_i;
    wire[`MemBus] m4_data_i;
    wire[`MemBus] m4_data_o;
    wire m4_req_i;
    wire m4_we_i;

    wire[`MemAddrBus] s0_addr_o;
    wire[`MemBus] s0_data_o;
    wire[`MemBus] s0_data_i;
    wire s0_we_o;

    wire[`MemAddrBus] s1_addr_o;
    wire[`MemBus] s1_data_o;
    wire[`MemBus] s1_data_i;
    wire s1_we_o;

    // slave 3 interface
    wire[`MemAddrBus] s3_addr_o;
    wire[`MemBus] s3_data_o;
    wire[`MemBus] s3_data_i;
    wire s3_we_o;

    // rib
    wire rib_hold_flag_o;

    //wire define				
    wire	[7:0]	rx_Data;								//接收到的一个BYTE数据
    wire			Rx_done;									//接收有效信号，可用作发送的使能信号
    wire[`INT_BUS] int_flag;


    assign int_flag = 8'h0;

   
    
    wire rstflag;	
    wire zflag;
    reg startzpc;
     /*
    reg [3:0]aa;
    always @(posedge clk) begin
        if (rst === `RstEnable) begin
            aa<=0;
        end else if(rstflag === 1'b1 ) begin
            aa <= 4'b1111;  // 
        end

        if(rstflag === 0 ) begin
            aa <=0;  // 
        end
    end
    
   
    always @ (posedge clk) begin
		
    
		if (rst === `RstEnable) begin
            succ = 1'b1;
            chufa=0;
		
        end else if(m3_data_i === 32'h10001197) begin
            succ =0;  //
        end 

        if(rstflag === 0 ) begin
            chufa =0;  // 
        end
        if(m1_data_o === 32'h10001197 && aa == 0 &&  rstflag == 1'b1) begin
            chufa =1;  // 
        end 

        if(zflag === 1) begin
            startzpc <=0;
        end else if(zflag === 0 )begin
            startzpc <=1;
        end
    end
      */

    always @ (posedge clk ) begin
        if (rst === `RstEnable) begin
            succ = 1'b1;
            chufa=0;
		
        end else if(m3_data_i === 32'h10001197) begin
            succ =0;  //
        end 

        if(rstflag === 0 ) begin
            chufa =0;  // 
        end
          
  
        if(rstflag == 1'b1) begin
            chufa =1;  // 
        end   


        if(zflag === 1) begin
            startzpc <=0;
        end else if(zflag === 0 )begin
            startzpc <=1;
        end
    end

    riscv u_riscv(
        .clk(clk),
        .rst(rst),
        .rstflag(rstflag),
        .rib_ex_addr_o(m0_addr_i),
        .rib_ex_data_i(m0_data_o),
        .rib_ex_data_o(m0_data_i),
        .rib_ex_req_o(m0_req_i),
        .rib_ex_we_o(m0_we_i),
        .rib_pc_addr_o(m1_addr_i),
        .rib_pc_data_i(m1_data_o),
        .rib_hold_flag_i(rib_hold_flag_o),
        .int_i(int_flag)
    );


    


    rom u_rom(
        .clk(clk),
        .rst(rst),
        .we_i(s0_we_o),
        .addr_i(s0_addr_o),
        .data_i(s0_data_o),//向从设备0写数据s0_data_o
        .data_o(s0_data_i)//s0_data_i? 从设?0读取到的数据
    );

    ram u_ram(
        .clk(clk),
        .rst(rst),
        .we_i(s1_we_o),
        .addr_i(s1_addr_o),
        .data_i(s1_data_o),
        .data_o(s1_data_i)
    );
    uart_rx uartrx(
        .sys_clk		(clk),
		.sys_rst_n	(rst),
		.uart_rxd	(uart_rx_pin),
		.uart_rx_data	(rx_Data),
		.uart_rx_done    (Rx_done)

    );

/*
    wire [7:0]rxshuju;
    wire done;
    uart_rx rx(
        .sys_clk		(clk),
		.sys_rst_n	(rst),
		.uart_rxd	(uart_TXD),
		.uart_rx_data	(rxshuju),
		.uart_rx_done    (done)

    );
    

    uart_tx uart_tx(
		.sys_clk		(clk),
		.sys_rst_n	(rst),
		.uart_tx_data	(rx_Data),
		.uart_tx_en	(Rx_done),
		.uart_txd	(uart_TXD)
	);

    wire [7:0] dataRX;
    wire DONERX;
    uart_rx RXTEST(
        .sys_clk		(clk),
		.sys_rst_n	(rst),
		.uart_rxd	(uart_TXD),
		.uart_rx_data	(dataRX),
		.uart_rx_done    (DONERX)

    );
    
   */

    wire txen;
    wire [7:0] txpcdata;
    uart_tx txtopc(
		.sys_clk		(clk),
		.sys_rst_n	(rst),
		.uart_tx_data	(txpcdata),
		.uart_tx_en	(txen),
		.uart_txd	(uart_TXD)
	);
    
  
    ztopc ztopc(
		.clk		(clk),
		.rst	(rst),
        .start(startzpc),
       // .start(endsucc),
        .rstflagz(rstflag),
		.r_data(m4_data_o),
        .req_o(m4_req_i),
        .zwe(m4_we_i),
        .r_addr(m4_addr_i),
        .txen(txen),
        .txpcdata(txpcdata)
	);
   
    
    /*
    topc topc(
		.clk		(clk),
		.rst	(rst),
        .start(startzpc),
        .rstflagz(rstflag),
       // .start(endsucc),

	
        .txen(txen),
        .txpcdata(txpcdata)
	);
    */
    wrrom u_wrrom
    (
        .clk(clk),
        .rst(rst),
        .debug_en_i(uart_debug_pin),
        .Rx_done(Rx_done),
        .rx_Data(rx_Data),
        .req_o(m3_req_i),
        .wrromdone(m3_we_i),
        .w_addr(m3_addr_i),
        .w_data(m3_data_i)

    );
    wrram u_wrram
    (
        .clk(clk),
        .rst(rst),
        .debug_en_i(~uart_debug_pin),
        .Rx_done(Rx_done),
        .rx_Data(rx_Data),
        .req_o(m2_req_i),
        .rstflag(rstflag),
        .zflag(zflag),
        .wrramdone(m2_we_i),
        .w_addr(m2_addr_i),
        .w_data(m2_data_i)

    );

    

  

    rib u_rib(
        .clk(clk),
        .rst(rst),

//ex
        .m0_addr_i(m0_addr_i),
        .m0_data_i(m0_data_i),
        .m0_data_o(m0_data_o),
        .m0_req_i(m0_req_i),
        .m0_we_i(m0_we_i),

//取指
        .m1_addr_i(m1_addr_i),
        .m1_data_i(`ZeroWord),
        .m1_data_o(m1_data_o),
        .m1_req_i(`RIB_REQ),
        .m1_we_i(`WriteDisable),

   
        .m2_addr_i(m2_addr_i),
        .m2_data_i(m2_data_i),
        .m2_data_o(m2_data_o),
        .m2_req_i(m2_req_i),
        .m2_we_i(m2_we_i),

      
        .m3_addr_i(m3_addr_i),
        .m3_data_i(m3_data_i),
        .m3_data_o(m3_data_o),
        .m3_req_i(m3_req_i),
        .m3_we_i(m3_we_i),

        .m4_addr_i(m4_addr_i),
        .m4_data_i(m4_data_i),
        .m4_data_o(m4_data_o),
        .m4_req_i(m4_req_i),
        .m4_we_i(m4_we_i),

 
        .s0_addr_o(s0_addr_o),
        .s0_data_o(s0_data_o),
        .s0_data_i(s0_data_i),
        .s0_we_o(s0_we_o),

        .s1_addr_o(s1_addr_o),
        .s1_data_o(s1_data_o),
        .s1_data_i(s1_data_i),
        .s1_we_o(s1_we_o),

        .s3_addr_o(s3_addr_o),
        .s3_data_o(s3_data_o),
        .s3_data_i(s3_data_i),
        .s3_we_o(s3_we_o),

        .hold_flag_o(rib_hold_flag_o)
    );


endmodule
