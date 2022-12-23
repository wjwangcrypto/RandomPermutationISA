`include "defines.v"


// 中断管理
module clint(

    input wire clk,
    input wire rst,

    // from core
    input wire[`INT_BUS] int_flag_i,         // 中断输入信号

    // from id
    input wire[`InstBus] inst_i,             // 指令内容
    input wire[`InstAddrBus] inst_addr_i,    // 指令地址

    // from ex
    input wire jump_flag_i,
    input wire[`InstAddrBus] jump_addr_i,
    input wire div_started_i,

    // from ctrl
    input wire[`Hold_Flag_Bus] hold_flag_i,  // 流水线暂停标志

    // from csr_reg
    input wire[`RegBus] data_i,              // CSR寄存器输入数据

    input wire[`RegBus] csr_mtvec,           // mtvec寄存器
    input wire[`RegBus] csr_mepc,            // mepc寄存器
    input wire[`RegBus] csr_mstatus,         // mstatus寄存器

    input wire global_int_en_i,              // 全局中断使能标志

    // to ctrl
    output wire hold_flag_o,                 // 流水线暂停标志

    // to csr_reg
    output reg we_o,                         // 写CSR寄存器标志
    output reg[`MemAddrBus] waddr_o,         // 写CSR寄存器地址
    output reg[`MemAddrBus] raddr_o,         // 读CSR寄存器地址
    output reg[`RegBus] data_o,              // 写CSR寄存器数据

    // to ex
    output reg[`InstAddrBus] int_addr_o,     // 中断入口地址
    output reg int_assert_o                  // 中断标志

    );


    // 中断状态
    localparam INTHALT_IDLE            = 4'b0001;
    localparam INT_SYNC     = 4'b0010;
    localparam INT_ASYNC    = 4'b0100;
    localparam INT_MRET            = 4'b1000;

    // 写CSR寄存器状态
    localparam IDLE            = 5'b00001;
    localparam MSTATUS         = 5'b00010;
    localparam MEPC            = 5'b00100;
    localparam MSTATUSMRET    = 5'b01000;
    localparam MCAUSE          = 5'b10000;

    reg[3:0] int_state;//中断状态
    reg[4:0] csr_state;
    reg[`InstAddrBus] inst_addr;
    reg[31:0] cause;

 
    assign hold_flag_o = ((int_state != INTHALT_IDLE) | (csr_state != IDLE))? `HoldEnable: `HoldDisable;
    // 中断仲裁
    always @ (*) begin
        if (rst == `RstEnable) begin
            int_state = INTHALT_IDLE;
        end else begin
            if (inst_i == `INST_ECALL || inst_i == `INST_EBREAK) begin//判断当前指令是否是ECALL或者EBREAK指令，如果是则设置中断状态为INT_SYNC，表示有同步中断要处理（ecall环境调用异常,rbreak断点异常）。
                // 如果执行阶段的指令为除法指令，则先不处理同步中断，等除法指令执行完再处理
                if (div_started_i == `DivStop) begin
                    int_state = INT_SYNC;
                end else begin
                    int_state = INTHALT_IDLE;
                end
            end else if (int_flag_i != `INT_NONE && global_int_en_i == `True) begin
                int_state = INT_ASYNC;//异步中断
            end else if (inst_i == `INST_MRET) begin//判断指令是否是中断返回指令
                int_state = INT_MRET;
            end else begin
                int_state = INTHALT_IDLE;
            end
        end
    end

    // 写CSR寄存器状态切换
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            csr_state <= IDLE;
            cause <= `ZeroWord;
            inst_addr <= `ZeroWord;
        end else begin
            case (csr_state)
                IDLE: begin
                    // 同步中断
                    if (int_state == INT_SYNC) begin
                        csr_state <= MEPC;
                        // 在中断处理函数里会将中断返回地址加4
                        if (jump_flag_i == `JumpEnable) begin
                            inst_addr <= jump_addr_i - 4'h4;
                        end else begin
                            inst_addr <= inst_addr_i;
                        end
                        case (inst_i)
                            `INST_ECALL: begin
                                cause <= 32'd11;
                            end
                            `INST_EBREAK: begin
                                cause <= 32'd3;
                            end
                            default: begin
                                cause <= 32'd10;         //根据不同的指令类型，设置不同的中断码(Exception Code)，这样异常服务程序就可以知道当前中断发生的原因了。见书222页
                            end
                        endcase
                    // 异步中断
                    end else if (int_state == INT_ASYNC) begin
                        // 外设定时器中断
                        cause <= 32'h80000004;
                        csr_state <= MEPC;
                        if (jump_flag_i == `JumpEnable) begin
                            inst_addr <= jump_addr_i;
                        // 异步中断可以中断除法指令的执行，中断处理完再重新执行除法指令
                        end else if (div_started_i == `DivStart) begin
                            inst_addr <= inst_addr_i - 4'h4;
                        end else begin
                            inst_addr <= inst_addr_i;
                        end
                    // 中断返回
                    end else if (int_state == INT_MRET) begin
                        csr_state <= MSTATUSMRET;
                    end
                end
                MEPC: begin
                    csr_state <= MSTATUS;
                end
                MSTATUS: begin
                    csr_state <= MCAUSE;
                end
                MCAUSE: begin
                    csr_state <= IDLE;
                end
                MSTATUSMRET: begin
                    csr_state <= IDLE;
                end
                default: begin
                    csr_state <= IDLE;
                end
            endcase
        end
    end

    // 发出中断信号前，先写几个CSR寄存器
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            we_o <= `WriteDisable;
            waddr_o <= `ZeroWord;
            data_o <= `ZeroWord;
        end else begin
            case (csr_state)
                // 将mepc寄存器的值设为当前指令地址
                MEPC: begin
                    we_o <= `WriteEnable;
                    waddr_o <= {20'h0, `CSR_MEPC};
                    data_o <= inst_addr;
                end
                // 写中断产生的原因
                MCAUSE: begin
                    we_o <= `WriteEnable;
                    waddr_o <= {20'h0, `CSR_MCAUSE};
                    data_o <= cause;
                end
                // 关闭全局中断
                MSTATUS: begin
                    we_o <= `WriteEnable;
                    waddr_o <= {20'h0, `CSR_MSTATUS};
                    data_o <= {csr_mstatus[31:4], 1'b0, csr_mstatus[2:0]};//mstatus的第3位为mie域表示全局中断使能，mie为1时打开所有中断，mie为0时关闭所有的中断
                end
                // 中断返回
                MSTATUSMRET: begin
                    we_o <= `WriteEnable;
                    waddr_o <= {20'h0, `CSR_MSTATUS};
                    data_o <= {csr_mstatus[31:4], csr_mstatus[7], csr_mstatus[2:0]};//第7位为mipe域保存进入异常之前的mie域的值
                end
                default: begin
                    we_o <= `WriteDisable;
                    waddr_o <= `ZeroWord;
                    data_o <= `ZeroWord;
                end
            endcase
        end
    end

    // 发出中断信号给ex模块
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            int_assert_o <= `INT_DEASSERT;
            int_addr_o <= `ZeroWord;
        end else begin
            case (csr_state)
                // 写完mstatus寄存器后发出中断进入信号，中断入口地址就是mtvec寄存器的值。
                MCAUSE: begin
                    int_assert_o <= `INT_ASSERT;
                    int_addr_o <= csr_mtvec;//mtvec异常入口基地址寄存器
                end
                // 发出中断返回信号
                MSTATUSMRET: begin
                    int_assert_o <= `INT_ASSERT;
                    int_addr_o <= csr_mepc;
                end
                default: begin
                    int_assert_o <= `INT_DEASSERT;
                    int_addr_o <= `ZeroWord;
                end
            endcase
        end
    end

endmodule