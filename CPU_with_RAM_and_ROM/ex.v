`include "defines.v"

module ex(

    input wire rst,
    // from id
    input wire[`InstBus] inst_i,            
    input wire[`InstAddrBus] inst_addr_i,  
    input wire reg_we_i,                    
    input wire[`RegAddrBus] reg_waddr_i,    
    input wire[`RegBus] reg1_rdata_i,      

    input wire[`RegBus] reg2_rdata_i,   
    
    input wire csr_we_i,                    
    input wire[`MemAddrBus] csr_waddr_i,   
    input wire[`RegBus] csr_rdata_i,        
    input wire int_assert_i,                // zhongduanfasheng
    input wire[`InstAddrBus] int_addr_i,    // 中断跳转地址
    input wire[`MemAddrBus] op1_i,
    input wire[`MemAddrBus] op2_i,

    input wire[`MemAddrBus] immop1_i,
    input wire[`MemAddrBus] immop2_i,
    input wire[`MemAddrBus] op1_jump_i,
    input wire[`MemAddrBus] op2_jump_i,

    input wire[`MemBus] mem_rdata_i,        // 内存输入数据


    input wire div_ready_i,                 // 除法运算完成标志
    input wire[`RegBus] div_result_i,       // 除法运算结果
    input wire div_busy_i,                  // 除法运算忙标志
    input wire[`RegAddrBus] div_reg_waddr_i,// 除法运算结束后 要写的寄存器地址

    //ran
    input wire ran_busy_i,                  // ran运算忙标志
    
    input wire  outtosh,
    input wire  outtoimmsh,
    input wire  outtord,
    input wire  [7:0]wsh_i,
    input wire  [`RegAddrBus]wshaddr_i,
    


    // to mem
    output reg[`MemBus] mem_wdata_o,        
    output reg[`MemAddrBus] mem_raddr_o,    
    output reg[`MemAddrBus] mem_waddr_o,    
    output wire mem_we_o,                   // 是否要写内存
    output wire mem_req_o,                  // 请求访问内存标志

    // to regs
    output wire[`RegBus] reg_wdata_o,      
    output wire reg_we_o,                   // 是否要写通用寄存器
    output wire[`RegAddrBus] reg_waddr_o,   

    // to csr reg
    output reg[`RegBus] csr_wdata_o,        
    output wire csr_we_o,                   // 是否要写CSR寄存器
    output wire[`MemAddrBus] csr_waddr_o,   

    // to div
    output wire div_start_o,                // 开始除法运算标志
    output reg[`RegBus] div_dividend_o,     // 被除数
    output reg[`RegBus] div_divisor_o,      // 除数
    output reg[2:0] div_op_o,               // 具体是哪一条除法指令
    output reg[`RegAddrBus] div_reg_waddr_o,// 除法运算结束后要写的寄存器地址


    //to ran
    output reg[`RegAddrBus] tord_reg_waddr_o,
    output wire ran_start_o,               //开始ran标志
    output wire sh_start_o,  //movtosh开始
    output wire immsh_start_o, 
    output wire init_start_o,//initind
    output wire tord_start_o,//initind
    output wire inc_start_o,
    output reg [2:0] ranceng, 
    output reg [15:0] randseed, 
    output reg [4:0] shufflereg, 
    output reg [15:0] immnumber,
    output reg [15:0] shnumber,

    // to ctrl
    output wire hold_flag_o,                // 是否暂停标志
    output wire jump_flag_o,                // 是否跳转标志
    output wire[`InstAddrBus] jump_addr_o   // 跳转目的地址

    );

    wire[1:0] mem_raddr_lasttwo;
    wire[1:0] mem_waddr_lasttwo;
    wire[`DoubleRegBus] mul_temp;
    wire[`DoubleRegBus] mul_temp_invert;
    wire[31:0] yiweisr;
    wire[31:0] sri_shift;
    wire[31:0] yiweisr_mask;
    wire[31:0] sri_shift_mask;
    wire[31:0] op1_jump_add_op2_jump;
    wire op12gesigned;
    wire op12geunsigned;
    wire op12equal;
    reg[`RegBus] mul_op1;
    reg[`RegBus] mul_op2;
    wire[6:0] opcode;
    wire[2:0] funct3bit;
    wire[6:0] funct7;
    wire[4:0] rd;
    wire[4:0] uimmnumber;
    reg[`RegBus] reg_wdata;
    reg reg_we;

    reg[`RegAddrBus] tord_waddr;
    reg[`RegBus] tord_wdata;

    reg tord_we;


    reg[`RegAddrBus] reg_waddr;
    reg[`RegBus] div_wdata;
    reg div_we;
    reg[`RegAddrBus] div_waddr;

    reg div_hold_flag;


    reg ran_hold_flag;
    reg tord_hold_flag;
    reg ransh_hold_flag;
    reg ranimmsh_hold_flag;
    reg init_hold_flag;
    reg inc_hold_flag;


    

    reg div_jump_flag;
    reg tosh_jump_flag;
    reg immtosh_jump_flag;
    reg ran_jump_flag;
    reg tord_jump_flag;
    reg init_jump_flag;
    reg inc_jump_flag;
    reg[`InstAddrBus] div_jumpaddress;
    reg[`InstAddrBus] tosh_jumpaddress;
    reg[`InstAddrBus] immtosh_jumpaddress;
    reg[`InstAddrBus] ran_jumpaddress;
    reg[`InstAddrBus] tord_jumpaddress;
    reg [`InstAddrBus] init_jumpaddress;
    reg [`InstAddrBus] inc_jumpaddress;
    
    reg hold_flag;
    reg jump_flag;
    reg[`InstAddrBus] jumpaddress;
    reg mem_we;
    reg mem_req;
    reg div_start;

    reg ran_start;
    reg sh_start;
    reg immsh_start;
    reg init_start;
    reg tord_start;
    reg inc_start;



    wire[4:0] rs1 = inst_i[19:15];
    wire[4:0] rs2 = inst_i[24:20];

    assign opcode = inst_i[6:0];
    assign funct3bit = inst_i[14:12];
    assign funct7 = inst_i[31:25];
    assign rd = inst_i[11:7];
    assign uimmnumber = inst_i[19:15];

    assign yiweisr = reg1_rdata_i >> reg2_rdata_i[4:0];
    assign sri_shift = reg1_rdata_i >> inst_i[24:20];
    assign yiweisr_mask = 32'hffffffff >> reg2_rdata_i[4:0];
    assign sri_shift_mask = 32'hffffffff >> inst_i[24:20];

    assign op1_jump_add_op2_jump = op1_jump_i + op2_jump_i;

    // 有符号数比较
    assign op12gesigned = $signed(op1_i) >= $signed(op2_i);
    // 无符号数比较
    assign op12geunsigned = op1_i >= op2_i;
    assign op12equal = (op1_i == op2_i);

    assign mul_temp = mul_op1 * mul_op2;
    assign mul_temp_invert = ~mul_temp + 1;

    assign mem_raddr_lasttwo = (reg1_rdata_i + {{20{inst_i[31]}}, inst_i[31:20]}) & 2'b11;
    assign mem_waddr_lasttwo = (reg1_rdata_i + {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]}) & 2'b11;

    assign div_start_o = (int_assert_i == `INT_ASSERT)? `DivStop: div_start;

    assign ran_start_o = ran_start;
    assign sh_start_o = sh_start;
    assign immsh_start_o = immsh_start;
    assign tord_start_o = tord_start;
    assign init_start_o = init_start;
    assign inc_start_o= inc_start;

    assign reg_wdata_o = reg_wdata | div_wdata |tord_wdata;
    // 响应中断时不写通用寄存器
    assign reg_we_o = (int_assert_i == `INT_ASSERT)? `WriteDisable: (reg_we || div_we ||tord_we);
    assign reg_waddr_o = reg_waddr | div_waddr|tord_waddr;

    // 响应中断时不写内存
    assign mem_we_o = (int_assert_i == `INT_ASSERT)? `WriteDisable: mem_we;

    // 响应中断时不向总线请求访问内存
    assign mem_req_o = (int_assert_i == `INT_ASSERT)? `RIB_NREQ: mem_req;

    assign hold_flag_o = hold_flag || div_hold_flag || ran_hold_flag||tord_hold_flag||ransh_hold_flag||ranimmsh_hold_flag||init_hold_flag||inc_hold_flag;
    assign jump_flag_o =jump_flag || div_jump_flag ||tosh_jump_flag||immtosh_jump_flag||ran_jump_flag||tord_jump_flag||init_jump_flag||inc_jump_flag|| (int_assert_i == `INT_ASSERT)? `JumpEnable: `JumpDisable;
    assign jump_addr_o = (int_assert_i == 1'b1)? int_addr_i: (jumpaddress | div_jumpaddress|tosh_jumpaddress|immtosh_jumpaddress|ran_jumpaddress|tord_jumpaddress|init_jumpaddress|inc_jumpaddress);

    // 响应中断时不写CSR寄存器
    assign csr_we_o = (int_assert_i == 1'b1)? `WriteDisable: csr_we_i;
    assign csr_waddr_o = csr_waddr_i;


    always @ (*) begin
        if ((opcode == `INST_TYPE_R_M) && (funct7 == 7'b0000001)) begin
            case (funct3bit)
                `INST_MUL, `INST_MULHU: begin
                    mul_op1 = reg1_rdata_i;
                    mul_op2 = reg2_rdata_i;
                end
                `INST_MULHSU: begin
                    mul_op1 = (reg1_rdata_i[31] == 1'b1)? (~reg1_rdata_i + 1): reg1_rdata_i;
                    mul_op2 = reg2_rdata_i;
                end
                `INST_MULH: begin
                    mul_op1 = (reg1_rdata_i[31] == 1'b1)? (~reg1_rdata_i + 1): reg1_rdata_i;
                    mul_op2 = (reg2_rdata_i[31] == 1'b1)? (~reg2_rdata_i + 1): reg2_rdata_i;
                end
                default: begin
                    mul_op1 = reg1_rdata_i;
                    mul_op2 = reg2_rdata_i;
                end
            endcase
        end else begin
            mul_op1 = reg1_rdata_i;
            mul_op2 = reg2_rdata_i;
        end
    end
    // 处理除法指令
    always @ (*) begin
        div_dividend_o = reg1_rdata_i;
        div_divisor_o = reg2_rdata_i;
        div_op_o = funct3bit;
        div_reg_waddr_o = reg_waddr_i;
        if ((opcode == `INST_TYPE_R_M) && (funct7 == 7'b0000001)) begin
            div_we = `WriteDisable;
            div_wdata = `ZeroWord;
            div_waddr = `ZeroWord;
            case (funct3bit)
                `INST_DIV, `INST_DIVU, `INST_REM, `INST_REMU: begin
                    div_start = `DivStart;
                    div_jump_flag = `JumpEnable;
                    div_hold_flag = `HoldEnable;
                    div_jumpaddress = op1_jump_add_op2_jump;
                end
                default: begin
                    div_start = `DivStop;
                    div_jump_flag = `JumpDisable;
                    div_hold_flag = `HoldDisable;
                    div_jumpaddress = `ZeroWord;
                end
            endcase
        end else begin
            div_jump_flag = `JumpDisable;
            div_jumpaddress = `ZeroWord;
            if (div_busy_i == `True) begin
                div_start = `DivStart;
                div_we = `WriteDisable;
                div_wdata = `ZeroWord;
                div_waddr = `ZeroWord;
                div_hold_flag = `HoldEnable;
            end else begin
                div_start = `DivStop;
                div_hold_flag = `HoldDisable;
                if (div_ready_i == 1'b1) begin
                    div_wdata = div_result_i;
                    div_waddr = div_reg_waddr_i;
                    div_we = `WriteEnable;
                end else begin
                    div_we = `WriteDisable;
                    div_wdata = `ZeroWord;
                    div_waddr = `ZeroWord;
                end
            end
        end
    end
   
 
    //immtosh  //movtosh
    always @ (*) begin
        //permute
        if (opcode == `MOVPERMUTE && funct3bit == `PERMUTEFUN3 )  begin
            ranceng = reg1_rdata_i;
            randseed = reg2_rdata_i[15:0];
            ran_start = 1'b1;
            ran_hold_flag = `HoldEnable;
            ran_jump_flag = `JumpEnable;
            ran_jumpaddress = op1_jump_add_op2_jump;
        end else begin
            if (ran_busy_i == `True) begin
                ran_start = 1'b1;
                ran_hold_flag = `HoldEnable;
                ran_jump_flag =`JumpDisable;
                ran_jumpaddress = `ZeroWord;
            end else begin
                ran_jump_flag =`JumpDisable;
                ran_jumpaddress = `ZeroWord;
                ran_start = 1'b0;
                ran_hold_flag = `HoldDisable;
            end
        end

        if (opcode == `MOVPERMUTE && funct3bit == `IMMTOSHFUN3 )  begin
            shufflereg = immop1_i;//哪一个shuffle reg
            immnumber = immop2_i;
            immsh_start = 1'b1;
            ranimmsh_hold_flag = `HoldEnable;
            immtosh_jump_flag = `JumpEnable;
            immtosh_jumpaddress = op1_jump_add_op2_jump;
        end else if (opcode == `MOVPERMUTE && funct3bit == `MOVTOSHFUN3) begin
            shufflereg = reg1_rdata_i;//哪一个shuffle reg
            shnumber = reg2_rdata_i;
            sh_start = 1'b1;
            ransh_hold_flag = `HoldEnable;
            tosh_jump_flag = `JumpEnable;
            tosh_jumpaddress = op1_jump_add_op2_jump;
        end else begin
            immtosh_jump_flag =`JumpDisable;
            immtosh_jumpaddress = `ZeroWord;
            tosh_jump_flag =`JumpDisable;
            tosh_jumpaddress = `ZeroWord;
            if (outtoimmsh == 1) begin
                ranimmsh_hold_flag = `HoldDisable;
                immsh_start = 1'b0;

                
            end
            if (outtosh == 1) begin
                ransh_hold_flag = `HoldDisable;
                sh_start = 1'b0;
                
            end
        end
    end

    //initind  incind
    always @ (*) begin
        if (opcode == `MOVPERMUTE && funct3bit == `INITINDFUN3 )  begin
            init_start = 1'b1;
 
            init_hold_flag = `HoldDisable;
            init_jump_flag = `JumpDisable;
            init_jumpaddress = `ZeroWord;
        end else if (opcode == `MOVPERMUTE && funct3bit == `INCINDFUN3) begin
            inc_start = 1'b1;

            inc_hold_flag = `HoldDisable;
            inc_jump_flag = `JumpDisable;
            inc_jumpaddress = `ZeroWord;
        end else begin
            init_jump_flag =`JumpDisable;
            init_jumpaddress = `ZeroWord;
            inc_jump_flag =`JumpDisable;
            inc_jumpaddress = `ZeroWord;
            init_hold_flag = `HoldDisable;
            init_start = 1'b0;
         
            inc_hold_flag = `HoldDisable;

            inc_start = 1'b0;

        end
    end


  
    always @ (*) begin
        
        
        if (opcode == `MOVPERMUTE && funct3bit == `MOVTORDINDFUN3 )  begin
            tord_reg_waddr_o = reg_waddr_i;
            tord_we = `WriteDisable;
            tord_wdata = `ZeroWord;
            tord_waddr = `ZeroWord;
            tord_start = 1'b1;
            tord_hold_flag = `HoldEnable;
            tord_jump_flag = `JumpEnable;
            tord_jumpaddress = op1_jump_add_op2_jump;

        end else begin
            if (outtord == 1) begin
                tord_start = 1'b0;

                tord_jump_flag =`JumpDisable;
                tord_jumpaddress = `ZeroWord;
                tord_hold_flag = `HoldDisable;
                tord_wdata = wsh_i;
                tord_waddr = wshaddr_i;
                tord_we = `WriteEnable;
                
            end else begin
                tord_jump_flag =`JumpDisable;
                tord_jumpaddress = `ZeroWord;
                tord_hold_flag = `HoldDisable;
      
                tord_we = `WriteDisable;
                tord_wdata = `ZeroWord;
                tord_waddr = `ZeroWord;
            end
            
        end
    end
   
    always @ (*) begin
        reg_we = reg_we_i;
        reg_waddr = reg_waddr_i;
        mem_req = `RIB_NREQ;
        csr_wdata_o = `ZeroWord;

        case (opcode)
            
            `INST_TYPE_I: begin
                case (funct3bit)
                    `ADDI: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata =op1_i + op2_i;
                    end
                    `SLTI: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = {32{(~op12gesigned)}} & 32'h1;
                    end
                    `SLTIU: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = {32{(~op12geunsigned)}} & 32'h1;
                    end
                    `XORI: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = op1_i ^ op2_i;
                    end
                    `ORI: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = op1_i | op2_i;
                    end
                    `ANDI: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = op1_i & op2_i;
                    end
                    `SLLI: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = reg1_rdata_i << inst_i[24:20];
                    end
                    `SRI: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        if (inst_i[30] == 1'b1) begin
                            reg_wdata = (sri_shift & sri_shift_mask) | ({32{reg1_rdata_i[31]}} & (~sri_shift_mask));
                        end else begin
                            reg_wdata = reg1_rdata_i >> inst_i[24:20];
                        end
                    end
                    default: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = `ZeroWord;
                    end
                endcase
            end


            `INST_TYPE_R_M: begin
                if ((funct7 == 7'b0000000) || (funct7 == 7'b0100000)) begin
                    case (funct3bit)
                        `INST_ADD_SUB: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            if (inst_i[30] == 1'b0) begin
                                reg_wdata = op1_i + op2_i;
                            end else begin
                                reg_wdata = op1_i - op2_i;
                            end
                        end
                        `INST_SLL: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = op1_i << op2_i[4:0];
                        end
                        `INST_SLT: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = {32{(~op12gesigned)}} & 32'h1;
                        end
                        `INST_SLTU: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = {32{(~op12geunsigned)}} & 32'h1;
                        end
                        `INST_XOR: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = op1_i ^ op2_i;
                        end
                        `INST_SR: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            if (inst_i[30] == 1'b1) begin
                                reg_wdata = (yiweisr & yiweisr_mask) | ({32{reg1_rdata_i[31]}} & (~yiweisr_mask));
                            end else begin
                                reg_wdata = reg1_rdata_i >> reg2_rdata_i[4:0];
                            end
                        end
                        `INST_OR: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = op1_i | op2_i;
                        end
                        `INST_AND: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = op1_i & op2_i;
                        end
                        default: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = `ZeroWord;
                        end
                    endcase
                end else if (funct7 == 7'b0000001) begin
                    case (funct3bit)
                        `INST_MUL: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = mul_temp[31:0];
                        end
                        `INST_MULHU: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = mul_temp[63:32];
                        end
                        `INST_MULH: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            case ({reg1_rdata_i[31], reg2_rdata_i[31]})
                                2'b00: begin
                                    reg_wdata = mul_temp[63:32];
                                end
                                2'b11: begin
                                    reg_wdata = mul_temp[63:32];
                                end
                                2'b10: begin
                                    reg_wdata = mul_temp_invert[63:32];
                                end
                                default: begin
                                    reg_wdata = mul_temp_invert[63:32];
                                end
                            endcase
                        end
                        `INST_MULHSU: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            if (reg1_rdata_i[31] == 1'b1) begin
                                reg_wdata = mul_temp_invert[63:32];
                            end else begin
                                reg_wdata = mul_temp[63:32];
                            end
                        end
                        default: begin
                            jump_flag = `JumpDisable;
                            hold_flag = `HoldDisable;
                            jumpaddress = `ZeroWord;
                            mem_wdata_o = `ZeroWord;
                            mem_raddr_o = `ZeroWord;
                            mem_waddr_o = `ZeroWord;
                            mem_we = `WriteDisable;
                            reg_wdata = `ZeroWord;
                        end
                    endcase
                end else begin
                    jump_flag = `JumpDisable;
                    hold_flag = `HoldDisable;
                    jumpaddress = `ZeroWord;
                    mem_wdata_o = `ZeroWord;
                    mem_raddr_o = `ZeroWord;
                    mem_waddr_o = `ZeroWord;
                    mem_we = `WriteDisable;
                    reg_wdata = `ZeroWord;
                end
            end
            `INST_TYPE_L: begin
                case (funct3bit)
                    `INST_LB: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        mem_req = `RIB_REQ;
                        mem_raddr_o = op1_i + op2_i;
                        case (mem_raddr_lasttwo)
                            2'b00: begin
                                reg_wdata = {{24{mem_rdata_i[7]}}, mem_rdata_i[7:0]};
                            end
                            2'b01: begin
                                reg_wdata = {{24{mem_rdata_i[15]}}, mem_rdata_i[15:8]};
                            end
                            2'b10: begin
                                reg_wdata = {{24{mem_rdata_i[23]}}, mem_rdata_i[23:16]};
                            end
                            default: begin
                                reg_wdata = {{24{mem_rdata_i[31]}}, mem_rdata_i[31:24]};
                            end
                        endcase
                    end
                    `INST_LH: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        mem_req = `RIB_REQ;
                        mem_raddr_o = op1_i + op2_i;
                        if (mem_raddr_lasttwo == 2'b0) begin
                            reg_wdata = {{16{mem_rdata_i[15]}}, mem_rdata_i[15:0]};
                        end else begin
                            reg_wdata = {{16{mem_rdata_i[31]}}, mem_rdata_i[31:16]};
                        end
                    end
                    `INST_LW: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        mem_req = `RIB_REQ;
                        mem_raddr_o = op1_i + op2_i;
                        reg_wdata = mem_rdata_i;
                    end
                    `INST_LBU: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        mem_req = `RIB_REQ;
                        mem_raddr_o = op1_i + op2_i;
                        case (mem_raddr_lasttwo)
                            2'b00: begin
                                reg_wdata = {24'h0, mem_rdata_i[7:0]};
                            end
                            2'b01: begin
                                reg_wdata = {24'h0, mem_rdata_i[15:8]};
                            end
                            2'b10: begin
                                reg_wdata = {24'h0, mem_rdata_i[23:16]};
                            end
                            default: begin
                                reg_wdata = {24'h0, mem_rdata_i[31:24]};
                            end
                        endcase
                    end
                    `INST_LHU: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        mem_req = `RIB_REQ;
                        mem_raddr_o = op1_i + op2_i;
                        if (mem_raddr_lasttwo == 2'b0) begin
                            reg_wdata = {16'h0, mem_rdata_i[15:0]};
                        end else begin
                            reg_wdata = {16'h0, mem_rdata_i[31:16]};
                        end
                    end
                    default: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = `ZeroWord;
                    end
                endcase
            end
            `INST_TYPE_S: begin
                case (funct3bit)
                    `INST_SB: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        reg_wdata = `ZeroWord;
                        mem_we = `WriteEnable;
                        mem_req = `RIB_REQ;
                        mem_waddr_o = op1_i + op2_i;
                        mem_raddr_o = op1_i + op2_i;
                        case (mem_waddr_lasttwo)
                            2'b00: begin
                                mem_wdata_o = {mem_rdata_i[31:8], reg2_rdata_i[7:0]};
                            end
                            2'b01: begin
                                mem_wdata_o = {mem_rdata_i[31:16], reg2_rdata_i[7:0], mem_rdata_i[7:0]};
                            end
                            2'b10: begin
                                mem_wdata_o = {mem_rdata_i[31:24], reg2_rdata_i[7:0], mem_rdata_i[15:0]};
                            end
                            default: begin
                                mem_wdata_o = {reg2_rdata_i[7:0], mem_rdata_i[23:0]};
                            end
                        endcase
                    end
                    `INST_SH: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        reg_wdata = `ZeroWord;
                        mem_we = `WriteEnable;
                        mem_req = `RIB_REQ;
                        mem_waddr_o = op1_i + op2_i;
                        mem_raddr_o = op1_i + op2_i;
                        if (mem_waddr_lasttwo == 2'b00) begin
                            mem_wdata_o = {mem_rdata_i[31:16], reg2_rdata_i[15:0]};
                        end else begin
                            mem_wdata_o = {reg2_rdata_i[15:0], mem_rdata_i[15:0]};
                        end
                    end
                    `INST_SW: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        reg_wdata = `ZeroWord;
                        mem_we = `WriteEnable;
                        mem_req = `RIB_REQ;
                        mem_waddr_o = op1_i + op2_i;
                        mem_raddr_o = op1_i + op2_i;
                        mem_wdata_o = reg2_rdata_i;
                    end
                    default: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = `ZeroWord;
                    end
                endcase
            end
            `INST_TYPE_B: begin
                case (funct3bit)
                    `INST_BEQ: begin
                        hold_flag = `HoldDisable;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = `ZeroWord;
                        jump_flag = op12equal & `JumpEnable;
                        jumpaddress = {32{op12equal}} & op1_jump_add_op2_jump;
                    end
                    `INST_BNE: begin
                        hold_flag = `HoldDisable;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = `ZeroWord;
                        jump_flag = (~op12equal) & `JumpEnable;
                        jumpaddress = {32{(~op12equal)}} & op1_jump_add_op2_jump;
                    end
                    `INST_BLT: begin
                        hold_flag = `HoldDisable;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = `ZeroWord;
                        jump_flag = (~op12gesigned) & `JumpEnable;
                        jumpaddress = {32{(~op12gesigned)}} & op1_jump_add_op2_jump;
                    end
                    `INST_BGE: begin
                        hold_flag = `HoldDisable;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = `ZeroWord;
                        jump_flag = (op12gesigned) & `JumpEnable;
                        jumpaddress = {32{(op12gesigned)}} & op1_jump_add_op2_jump;
                    end
                    `INST_BLTU: begin
                        hold_flag = `HoldDisable;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = `ZeroWord;
                        jump_flag = (~op12geunsigned) & `JumpEnable;
                        jumpaddress = {32{(~op12geunsigned)}} & op1_jump_add_op2_jump;
                    end
                    `INST_BGEU: begin
                        hold_flag = `HoldDisable;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = `ZeroWord;
                        jump_flag = (op12geunsigned) & `JumpEnable;
                        jumpaddress = {32{(op12geunsigned)}} & op1_jump_add_op2_jump;
                    end
                    default: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = `ZeroWord;
                    end
                endcase
            end
            
           
            `INST_JAL, `INST_JALR: begin
                hold_flag = `HoldDisable;
                mem_wdata_o = `ZeroWord;
                mem_raddr_o = `ZeroWord;
                mem_waddr_o = `ZeroWord;
                mem_we = `WriteDisable;
                jump_flag = `JumpEnable;
                jumpaddress = op1_jump_add_op2_jump;
                reg_wdata = op1_i + op2_i;
            end
            `INST_LUI, `INST_AUIPC: begin
                hold_flag = `HoldDisable;
                mem_wdata_o = `ZeroWord;
                mem_raddr_o = `ZeroWord;
                mem_waddr_o = `ZeroWord;
                mem_we = `WriteDisable;
                jumpaddress = `ZeroWord;
                jump_flag = `JumpDisable;
                reg_wdata = op1_i + op2_i;
            end
            `INST_NOP_OP: begin
                jump_flag = `JumpDisable;
                hold_flag = `HoldDisable;
                jumpaddress = `ZeroWord;
                mem_wdata_o = `ZeroWord;
                mem_raddr_o = `ZeroWord;
                mem_waddr_o = `ZeroWord;
                mem_we = `WriteDisable;
                reg_wdata = `ZeroWord;
            end
            `INST_FENCE: begin
                hold_flag = `HoldDisable;
                mem_wdata_o = `ZeroWord;
                mem_raddr_o = `ZeroWord;
                mem_waddr_o = `ZeroWord;
                mem_we = `WriteDisable;
                reg_wdata = `ZeroWord;
                jump_flag = `JumpEnable;
                jumpaddress = op1_jump_add_op2_jump;
            end
            `INST_CSR: begin
                jump_flag = `JumpDisable;
                hold_flag = `HoldDisable;
                jumpaddress = `ZeroWord;
                mem_wdata_o = `ZeroWord;
                mem_raddr_o = `ZeroWord;
                mem_waddr_o = `ZeroWord;
                mem_we = `WriteDisable;
                case (funct3bit)
                    `INST_CSRRW: begin
                        csr_wdata_o = reg1_rdata_i;
                        reg_wdata = csr_rdata_i;
                    end
                    `INST_CSRRS: begin
                        csr_wdata_o = reg1_rdata_i | csr_rdata_i;
                        reg_wdata = csr_rdata_i;
                    end
                    `INST_CSRRC: begin
                        csr_wdata_o = csr_rdata_i & (~reg1_rdata_i);
                        reg_wdata = csr_rdata_i;
                    end
                    `INST_CSRRWI: begin
                        csr_wdata_o = {27'h0, uimmnumber};
                        reg_wdata = csr_rdata_i;
                    end
                    `INST_CSRRSI: begin
                        csr_wdata_o = {27'h0, uimmnumber} | csr_rdata_i;
                        reg_wdata = csr_rdata_i;
                    end
                    `INST_CSRRCI: begin
                        csr_wdata_o = (~{27'h0, uimmnumber}) & csr_rdata_i;
                        reg_wdata = csr_rdata_i;
                    end
                    default: begin
                        jump_flag = `JumpDisable;
                        hold_flag = `HoldDisable;
                        jumpaddress = `ZeroWord;
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = `ZeroWord;
                    end
                endcase
            end
            default: begin
                jump_flag = `JumpDisable;
                hold_flag = `HoldDisable;
                jumpaddress = `ZeroWord;
                mem_wdata_o = `ZeroWord;
                mem_raddr_o = `ZeroWord;
                mem_waddr_o = `ZeroWord;
                mem_we = `WriteDisable;
                reg_wdata = `ZeroWord;
            end
        endcase
    end

endmodule
