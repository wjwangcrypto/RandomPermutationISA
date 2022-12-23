`timescale 1 ns / 1 ps

`include "defines.v"
module riscv_tb;

    reg clk;
    reg rst;


    always #5 clk = ~clk;     // 48MHz


    wire[`RegBus] x26 = u_riscv_top.u_riscv.u_regs.regs[26];
    wire[`RegBus] x27 = u_riscv_top.u_riscv.u_regs.regs[27];
    reg uart_rx_pin;
    
    initial begin
        clk = 0;
        rst = 0;
        #20
        rst = 1;
        aaaa32(32'd238);//238
        aaaa32(32'd74);
        aaaa32(32'd95);
        aaaa32(32'd215);
        aaaa32(32'd68);
        aaaa32(32'd222);
        aaaa32(32'd28);
        aaaa32(32'd187);

        aaaa32(32'd42);
        aaaa32(32'd77);
        aaaa32(32'd95);
        aaaa32(32'd174);
        aaaa32(32'd197);
        aaaa32(32'd173);
        aaaa32(32'd110);
        aaaa32(32'd203);

        aaaa32(32'd31);
        aaaa32(32'd186);
        aaaa32(32'd185);
        aaaa32(32'd133);
        aaaa32(32'd97);
        aaaa32(32'd66);
        aaaa32(32'd236);
        aaaa32(32'd8);

        aaaa32(32'd224);
        aaaa32(32'd124);
        aaaa32(32'd254);
        aaaa32(32'd124);
        aaaa32(32'd178);
        aaaa32(32'd111);
        aaaa32(32'd137);
        aaaa32(32'd97);

        aaaa32(32'd173);
        aaaa32(32'd145);
        aaaa32(32'd58);
        aaaa32(32'd86);
        aaaa32(32'd12);
        aaaa32(32'd42);
        aaaa32(32'd238);
        aaaa32(32'd135);

        aaaa32(32'd39);
        aaaa32(32'd129);
        aaaa32(32'd172);
        aaaa32(32'd214);


        aaaa32(32'd3027);
   


    






        
        $display("test running...");
        
         #2000;
        
        wait(x26 == 32'b1)   // wait sim end, when x26 == 1
        #100
        if (x27 == 32'b1) begin
            $display("~~~~~~~~~~~~~~~~~~~ TEST_PASS ~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~");
            $display("~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~");
            $display("~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~");
            $display("~~~~~~~~~ #####   ######       #       #~~~~~~~~~");
            $display("~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~");
            $display("~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            $display($time);
        end else begin
            $display("~~~~~~~~~~~~~~~~~~~ TEST_FAIL ~~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        end

        
        #8000000

        
        aaaa32(32'd238);//238
        aaaa32(32'd74);
        aaaa32(32'd95);
        aaaa32(32'd215);
        aaaa32(32'd68);
        aaaa32(32'd222);
        aaaa32(32'd28);
        aaaa32(32'd187);

        aaaa32(32'd42);
        aaaa32(32'd77);
        aaaa32(32'd95);
        aaaa32(32'd174);
        aaaa32(32'd197);
        aaaa32(32'd173);
        aaaa32(32'd110);
        aaaa32(32'd203);

        aaaa32(32'd31);
        aaaa32(32'd186);
        aaaa32(32'd185);
        aaaa32(32'd133);
        aaaa32(32'd97);
        aaaa32(32'd66);
        aaaa32(32'd236);
        aaaa32(32'd8);

        aaaa32(32'd224);
        aaaa32(32'd124);
        aaaa32(32'd254);
        aaaa32(32'd124);
        aaaa32(32'd178);
        aaaa32(32'd111);
        aaaa32(32'd137);
        aaaa32(32'd97);

        aaaa32(32'd173);
        aaaa32(32'd145);
        aaaa32(32'd58);
        aaaa32(32'd86);
        aaaa32(32'd12);
        aaaa32(32'd42);
        aaaa32(32'd238);
        aaaa32(32'd135);

        aaaa32(32'd39);
        aaaa32(32'd129);
        aaaa32(32'd172);
        aaaa32(32'd214);


        aaaa32(32'd3027);
        #8000000
        $finish;
        
    end
        
    task aaaa;
        input [7:0]data;
        begin
            uart_rx_pin = 1;
            #20;
            uart_rx_pin = 0;

            #8680;
            uart_rx_pin = data[0];
            #8680;
            uart_rx_pin = data[1];


            #8680;
            uart_rx_pin = data[2];
            #8680;
            uart_rx_pin = data[3];

            #8680;
            uart_rx_pin = data[4];
            #8680;
            uart_rx_pin =data[5];
            #8680;
            uart_rx_pin =data[6];
            #8680;
            uart_rx_pin =data[7];
            #8680;
            uart_rx_pin =1;
            #8680;
        end
        
    endtask

    task aaaa32;
        input [31:0]data;
        begin
            
            uart_rx_pin = 1;
            #8680;
            
            #20;
            uart_rx_pin = 0;

            #8680;
            uart_rx_pin = data[24];
            #8680;
            uart_rx_pin = data[25];
            #8680;
            uart_rx_pin = data[26];
            #8680;
            uart_rx_pin = data[27];
            #8680;
            uart_rx_pin = data[28];
            #8680;
            uart_rx_pin =data[29];
            #8680;
            uart_rx_pin =data[30];
            #8680;
            uart_rx_pin =data[31];
            #8680;
            uart_rx_pin =1;
            #8680;

            #20;
            uart_rx_pin = 0;
            #8680;
            uart_rx_pin =data[16];
            #8680;
            uart_rx_pin =data[17];
            #8680;
            uart_rx_pin =data[18];
            #8680;
            uart_rx_pin =data[19];
            #8680;
            uart_rx_pin =data[20];
            #8680;
            uart_rx_pin =data[21];
            #8680;
            uart_rx_pin =data[22];
            #8680;
            uart_rx_pin =data[23];
            #8680;
            uart_rx_pin =1;
            #8680;
            #20;
            uart_rx_pin = 0;
            #8680;

            uart_rx_pin =data[8];
            #8680;
            uart_rx_pin =data[9];
            #8680;
            uart_rx_pin =data[10];
            #8680;
            uart_rx_pin =data[11];
            #8680;
            uart_rx_pin =data[12];
            #8680;
            uart_rx_pin =data[13];
            #8680;
            uart_rx_pin =data[14];
            #8680;
            uart_rx_pin =data[15];
            #8680;
            uart_rx_pin =1;
            #8680;
            #20;
            uart_rx_pin = 0;
            #8680;
            uart_rx_pin = data[0];
            #8680;
            uart_rx_pin = data[1];
            #8680;
            uart_rx_pin = data[2];
            #8680;
            uart_rx_pin = data[3];
            #8680;
            uart_rx_pin = data[4];
            #8680;
            uart_rx_pin =data[5];
            #8680;
            uart_rx_pin =data[6];
            #8680;
            uart_rx_pin =data[7];
            #8680;
            uart_rx_pin =1;
            #8680;
        end
        
    endtask

    // sim timeout
    initial begin
        #400000000
        $display("Time Out.");
        $finish;
    end
    initial begin
        $readmemh ("inst.data", u_riscv_top.u_rom._rom);
    end
    initial begin
        $dumpfile("riscv_tb.vcd");
        $dumpvars(0, riscv_tb);
    end
    wire chufa;
    riscv_top u_riscv_top(
        .clkyuanshi(clk),
        .rstyuanshi(rst),
        .uart_debug_pin(0),
        .uart_rx_pin(uart_rx_pin)

    );

endmodule
