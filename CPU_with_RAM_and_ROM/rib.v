                              

`include "defines.v"


// RIB����ģ��
module rib(

    input wire clk,
    input wire rst,

    // master 0 interface
    input wire[`MemAddrBus] m0_addr_i,     // ���豸0����д��ַ
    input wire[`MemBus] m0_data_i,         // ���豸0д����
    output reg[`MemBus] m0_data_o,         // ���豸0��ȡ��������
    input wire m0_req_i,                   // ���豸0���������־
    input wire m0_we_i,                    // ���豸0д��־

    // master 1 interface
    input wire[`MemAddrBus] m1_addr_i,     
    input wire[`MemBus] m1_data_i,        
    output reg[`MemBus] m1_data_o,      
    input wire m1_req_i,                  
    input wire m1_we_i,                    

    // master 2 interface
    input wire[`MemAddrBus] m2_addr_i,     
    input wire[`MemBus] m2_data_i,       
    output reg[`MemBus] m2_data_o,        
    input wire m2_req_i,                   
    input wire m2_we_i,                    
    // master 3 interface
    input wire[`MemAddrBus] m3_addr_i,     
    input wire[`MemBus] m3_data_i,        
    output reg[`MemBus] m3_data_o,         
    input wire m3_req_i,                  
    input wire m3_we_i,         

    // master 4 interface��ztopc z��ram��
    input wire[`MemAddrBus] m4_addr_i,     
    input wire[`MemBus] m4_data_i,        
    output reg[`MemBus] m4_data_o,         
    input wire m4_req_i,                  
    input wire m4_we_i,            

    // slave 0 interface
    output reg[`MemAddrBus] s0_addr_o,     // ���豸0����д��ַ
    output reg[`MemBus] s0_data_o,         // ���豸0д����
    input wire[`MemBus] s0_data_i,         // ���豸0��ȡ��������
    output reg s0_we_o,                    // ���豸0д��־

    // slave 1 interface
    output reg[`MemAddrBus] s1_addr_o,     
    output reg[`MemBus] s1_data_o,       
    input wire[`MemBus] s1_data_i,       
    output reg s1_we_o,                 

    // slave 3 interface
    output reg[`MemAddrBus] s3_addr_o,     // ���豸3����д��ַ
    output reg[`MemBus] s3_data_o,         // ���豸3д����
    input wire[`MemBus] s3_data_i,         // ���豸3��ȡ��������
    output reg s3_we_o,                    // ���豸3д��־


    output reg hold_flag_o                 // ��ͣ��ˮ�߱�־

    );


    // ���ʵ�ַ�����4λ����Ҫ���ʵ�����һ�����豸
    parameter [3:0]slave_0 = 4'b0000;
    parameter [3:0]slave_1 = 4'b0001;
    parameter [3:0]slave_3 = 4'b0011;

    parameter [2:0]grant0 = 3'h0;
    parameter [2:0]grant1 = 3'h1;
    parameter [2:0]grant2 = 3'h2;
    parameter [2:0]grant3 = 3'h3;
    parameter [2:0]grant4 = 3'h4;

    wire[4:0] req;
    reg[2:0] grant;


    // ���豸�����ź�
    assign req = {m4_req_i,m3_req_i, m2_req_i, m1_req_i, m0_req_i};

    // �ٲ��߼�
    // �̶����ȼ��ٲû���
    // ���ȼ��ɸߵ��ͣ����豸3�����豸0�����豸2�����豸4��z��,���豸1
    always @ (*) begin
        if (req[3]) begin
            grant = grant3;
            hold_flag_o = `HoldEnable;
        end else if (req[0]) begin
            grant = grant0;
            hold_flag_o = `HoldEnable;
        end else if (req[2]) begin
            grant = grant2;
            hold_flag_o = `HoldEnable;
        end else if (req[4]) begin
            grant = grant4;
            hold_flag_o = `HoldEnable;
        end else begin
            grant = grant1;
            hold_flag_o = `HoldDisable;
        end
    end

    // �����ٲý����ѡ��(����)��Ӧ�Ĵ��豸
    always @ (*) begin
        m0_data_o = `ZeroWord;
        m1_data_o = `INST_NOP;
        m2_data_o = `ZeroWord;
        m3_data_o = `ZeroWord;
        m4_data_o = `ZeroWord;

        s0_addr_o = `ZeroWord;
        s1_addr_o = `ZeroWord;
        s3_addr_o = `ZeroWord;

        s0_data_o = `ZeroWord;
        s1_data_o = `ZeroWord;
        s3_data_o = `ZeroWord;

        s0_we_o = `WriteDisable;
        s1_we_o = `WriteDisable;
        s3_we_o = `WriteDisable;
        case (grant)
            grant0: begin
                case (m0_addr_i[31:28])
                    slave_0: begin
                        s0_we_o = m0_we_i;
                        s0_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s0_data_o = m0_data_i;
                        m0_data_o = s0_data_i;
                    end
                    slave_1: begin
                        s1_we_o = m0_we_i;
                        s1_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s1_data_o = m0_data_i;
                        m0_data_o = s1_data_i;
                    end
                    slave_3: begin
                        s3_we_o = m0_we_i;
                        s3_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s3_data_o = m0_data_i;
                        m0_data_o = s3_data_i;
                    end
                    default: begin

                    end
                endcase
            end
            grant1: begin
                case (m1_addr_i[31:28])
                    slave_0: begin
                        s0_we_o = m1_we_i;
                        s0_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
                        s0_data_o = m1_data_i;
                        m1_data_o = s0_data_i;
                    end
                    slave_1: begin
                        s1_we_o = m1_we_i;
                        s1_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
                        s1_data_o = m1_data_i;
                        m1_data_o = s1_data_i;
                    end
                    slave_3: begin
                        s3_we_o = m1_we_i;
                        s3_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
                        s3_data_o = m1_data_i;
                        m1_data_o = s3_data_i;
                    end
                    default: begin

                    end
                endcase
            end
            grant2: begin
                case (m2_addr_i[31:28])
                    slave_0: begin
                        s0_we_o = m2_we_i;
                        s0_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
                        s0_data_o = m2_data_i;
                        m2_data_o = s0_data_i;
                    end
                    slave_1: begin
                        s1_we_o = m2_we_i;
                        s1_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
                        s1_data_o = m2_data_i;
                        m2_data_o = s1_data_i;
                    end
                    slave_3: begin
                        s3_we_o = m2_we_i;
                        s3_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
                        s3_data_o = m2_data_i;
                        m2_data_o = s3_data_i;
                    end
                    
                    default: begin

                    end
                endcase
            end
            grant3: begin
                case (m3_addr_i[31:28])
                    slave_0: begin
                        s0_we_o = m3_we_i;
                        s0_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
                        s0_data_o = m3_data_i;
                        m3_data_o = s0_data_i;
                    end
                    slave_1: begin
                        s1_we_o = m3_we_i;
                        s1_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
                        s1_data_o = m3_data_i;
                        m3_data_o = s1_data_i;
                    end
                    slave_3: begin
                        s3_we_o = m3_we_i;
                        s3_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
                        s3_data_o = m3_data_i;
                        m3_data_o = s3_data_i;
                    end
                    default: begin

                    end
                endcase
            end

            grant4: begin
                case (m4_addr_i[31:28])
                    slave_0: begin
                        s0_we_o = m4_we_i;
                        s0_addr_o = {{4'h0}, {m4_addr_i[27:0]}};
                        s0_data_o = m4_data_i;
                        m4_data_o = s0_data_i;
                    end
                    slave_1: begin
                        s1_we_o = m4_we_i;
                        s1_addr_o = {{4'h0}, {m4_addr_i[27:0]}};
                        s1_data_o = m4_data_i;
                        m4_data_o = s1_data_i;
                    end
                    slave_3: begin
                        s3_we_o = m4_we_i;
                        s3_addr_o = {{4'h0}, {m4_addr_i[27:0]}};
                        s3_data_o = m4_data_i;
                        m4_data_o = s3_data_i;
                    end
                    
                    default: begin

                    end
                endcase
            end
            default: begin

            end
        endcase
    end

endmodule
