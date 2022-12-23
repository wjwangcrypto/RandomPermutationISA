`include "defines.v"

module div(

    input wire clk,
    input wire rst,

    // from ex
    input wire[`RegBus] dividend_i,      // 被除数
    input wire[`RegBus] divisor_i,       // 除数
    input wire start_i,                  // 开始信号，运算期间这个信号需要一直保持有效
    input wire[2:0] op_i,                // 具体是哪一条指令
    input wire[`RegAddrBus] reg_waddr_i, // 运算结束后需要写的寄存器

    // to ex
    output reg[`RegBus] result_o,        // 除法结果，高32位是余数，低32位是商
    output reg ready_o,                  // 运算结束信号
    output reg busy_o,                  // 正在运算信号
    output reg[`RegAddrBus] reg_waddr_o  // 运算结束后需要写的寄存器

    );
    ////设被除数是m，除数是n，商保存在s中，被除数的位数是k
    //1.取出被除数的最高位m[k]，使用被除数的最高位减去除数n，如果结果大于等于0，则商的s[k]为1，反之为0
    //2.如果上一步得出的结果是0，表示当前的被减数小于除数，则取出被除数m[k-1]，与当前被减数组合为下一轮的被减数；
    //如果上一步得出的结果是1，表示当前的被减数大于除数，则利用第2步中减法的结果与被除数剩下的值的最高位m[k-1]组合为下一轮的被减数。k等于k-1。
    //3.新的被减数减去除数，如果结果大于等于0，则商的s[k]为1，否则s[k]为0，后面的步骤重复2-3，直到k等于1
    // 状态定义
    localparam STATE_IDLE  = 4'b0001;
    localparam STATE_START = 4'b0010;
    localparam STATE_CALC  = 4'b0100;
    localparam STATE_END   = 4'b1000;

    reg[`RegBus] dividendtemp;
    reg[`RegBus] divisortemp;
    reg[2:0] op_select;
    reg[3:0] state;
    reg[31:0] count;
    reg[`RegBus] result;
    reg[`RegBus] remain;
    reg[`RegBus] minuend;
    reg invert_result;

    wire op_div = (op_select == `INST_DIV);
    wire op_divu = (op_select == `INST_DIVU);
    wire op_rem = (op_select == `INST_REM);
    wire op_remu = (op_select == `INST_REMU);

    wire[31:0] dividend_invert = (-dividendtemp);
    wire[31:0] divisor_invert = (-divisortemp);
    wire minuend_ge_divisor = minuend >= divisortemp;
    wire[31:0] minuend_sub_res = minuend - divisortemp;
    wire[31:0] div_result_tmp = minuend_ge_divisor? ({result[30:0], 1'b1}): ({result[30:0], 1'b0});
    wire[31:0] minuend_tmp = minuend_ge_divisor? minuend_sub_res[30:0]: minuend[30:0];

    // 状态机实现
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            state <= STATE_IDLE;
            ready_o <= `DivResultNotReady;
            result_o <= `ZeroWord;
            result <= `ZeroWord;
            remain <= `ZeroWord;
            op_select <= 3'h0;
            reg_waddr_o <= `ZeroWord;
            dividendtemp <= `ZeroWord;
            divisortemp <= `ZeroWord;
            minuend <= `ZeroWord;
            invert_result <= 1'b0;
            busy_o <= `False;
            count <= `ZeroWord;
        end else begin
            case (state)
                STATE_IDLE: begin
                    if (start_i == `DivStart) begin
                        op_select <= op_i;
                        dividendtemp <= dividend_i;
                        divisortemp <= divisor_i;
                        reg_waddr_o <= reg_waddr_i;
                        state <= STATE_START;
                        busy_o <= `True;
                    end else begin
                        op_select <= 3'h0;
                        reg_waddr_o <= `ZeroWord;
                        dividendtemp <= `ZeroWord;
                        divisortemp <= `ZeroWord;
                        ready_o <= `DivResultNotReady;
                        result_o <= `ZeroWord;
                        busy_o <= `False;
                    end
                end

                STATE_START: begin
                    if (start_i == `DivStart) begin
                        // 除数为0
                        if (divisortemp == `ZeroWord) begin
                            if (op_div | op_divu) begin
                                result_o <= 32'hffffffff;
                            end else begin
                                result_o <= dividendtemp;
                            end
                            ready_o <= `DivResultReady;
                            state <= STATE_IDLE;
                            busy_o <= `False;
                        // 除数不为0
                        end else begin
                            busy_o <= `True;
                            count <= 32'h40000000;
                            state <= STATE_CALC;
                            result <= `ZeroWord;
                            remain <= `ZeroWord;

                            // DIV和REM这两条指令是有符号数运算指令
                            if (op_div | op_rem) begin
                                // 被除数求补码
                                if (dividendtemp[31] == 1'b1) begin
                                    dividendtemp <= dividend_invert;
                                    minuend <= dividend_invert[31];
                                end else begin
                                    minuend <= dividendtemp[31];
                                end
                                // 除数求补码
                                if (divisortemp[31] == 1'b1) begin
                                    divisortemp <= divisor_invert;
                                end
                            end else begin
                                minuend <= dividendtemp[31];
                            end

                            // 运算结束后是否要对结果取补码
                            if ((op_div && (dividendtemp[31] ^ divisortemp[31] == 1'b1))
                                || (op_rem && (dividendtemp[31] == 1'b1))) begin
                                invert_result <= 1'b1;
                            end else begin
                                invert_result <= 1'b0;
                            end
                        end
                    end else begin
                        state <= STATE_IDLE;
                        result_o <= `ZeroWord;
                        ready_o <= `DivResultNotReady;
                        busy_o <= `False;
                    end
                end

                STATE_CALC: begin
                    if (start_i == `DivStart) begin
                        dividendtemp <= {dividendtemp[30:0], 1'b0};
                        result <= div_result_tmp;
                        count <= {1'b0, count[31:1]};
                        if (|count) begin
                            minuend <= {minuend_tmp[30:0], dividendtemp[30]};
                        end else begin
                            state <= STATE_END;
                            if (minuend_ge_divisor) begin
                                remain <= minuend_sub_res;
                            end else begin
                                remain <= minuend;
                            end
                        end
                    end else begin
                        state <= STATE_IDLE;
                        result_o <= `ZeroWord;
                        ready_o <= `DivResultNotReady;
                        busy_o <= `False;
                    end
                end

                STATE_END: begin
                    if (start_i == `DivStart) begin
                        ready_o <= `DivResultReady;
                        state <= STATE_IDLE;
                        busy_o <= `False;
                        if (op_div | op_divu) begin
                            if (invert_result) begin
                                result_o <= (-result);
                            end else begin
                                result_o <= result;
                            end
                        end else begin
                            if (invert_result) begin
                                result_o <= (-remain);
                            end else begin
                                result_o <= remain;
                            end
                        end
                    end else begin
                        state <= STATE_IDLE;
                        result_o <= `ZeroWord;
                        ready_o <= `DivResultNotReady;
                        busy_o <= `False;
                    end
                end

            endcase
        end
    end

endmodule
