module ran(

    input wire clk,
    input wire rst,
    input wire[15:0]randseed ,

    input wire ranstart_i,   
    input wire shstart_i, 
    input wire immshstart_i, 
    input wire init_start_i,


    input wire tord_start_i,
    input wire inc_start_i,
    // from ex
    input wire[2:0] ranceng,
    input wire[4:0] shufflereg,
    input wire[15:0] immnumber,
    input wire[15:0] shnumber,
    input wire[4:0] tord_reg_waddr_i,
    // to ex
    output reg outtosh,
    output reg outtoimmsh,
    output reg outtord,

    output reg[7:0] wsh_o,
    output reg[`RegAddrBus] wshaddr_o,

    output reg ranbusy_o                  // 正在运算信号
    );

    reg [`RegAddrBus] tord_reg_waddr;
    reg [7:0] a0,a1,a2,a3,a4,a5,a6,a7;
    reg [7:0] a8,a9,a10,a11,a12,a13,a14,a15;
    reg [7:0] a16,a17,a18,a19,a20,a21,a22,a23;//前0-7值第7位标志位，前3个x 后3个y
    reg [7:0] a24,a25,a26,a27,a28,a29,a30,a31;
    wire [31:0]aa;
    reg [15:0] shift_reg;
    reg start;
    reg [2:0] round;//已经改
    reg shend;
    reg immshend;
    reg tordend;
    reg init;
    reg inc;
    reg [2:0] ran_ceng;
    reg [5:0] index;
    reg flag;
    reg flagsh;
    reg flagtord;
    reg flagimm;

    assign    aa[0]=(a0[7]==0)?1:0;
    assign    aa[1]=(a1[7]==0)?1:0;
    assign    aa[2]=(a2[7]==0)?1:0;
    assign    aa[3]=(a3[7]==0)?1:0;
    assign    aa[4]=(a4[7]==0)?1:0;
    assign    aa[5]=(a5[7]==0)?1:0;
    assign    aa[6]=(a6[7]==0)?1:0;
    assign    aa[7]=(a7[7]==0)?1:0;
    assign    aa[8]=(a8[7]==0)?1:0;
    assign    aa[9]=(a9[7]==0)?1:0;
    assign    aa[10]=(a10[7]==0)?1:0;
    assign    aa[11]=(a11[7]==0)?1:0;
    assign    aa[12]=(a12[7]==0)?1:0;
    assign    aa[13]=(a13[7]==0)?1:0;
    assign    aa[14]=(a14[7]==0)?1:0;
    assign    aa[15]=(a15[7]==0)?1:0;
    assign    aa[16]=(a16[7]==0)?1:0;
    assign    aa[17]=(a17[7]==0)?1:0;
    assign    aa[18]=(a18[7]==0)?1:0;
    assign    aa[19]=(a19[7]==0)?1:0;
    assign    aa[20]=(a20[7]==0)?1:0;
    assign    aa[21]=(a21[7]==0)?1:0;
    assign    aa[22]=(a22[7]==0)?1:0;
    assign    aa[23]=(a23[7]==0)?1:0;
    assign    aa[24]=(a24[7]==0)?1:0;
    assign    aa[25]=(a25[7]==0)?1:0;
    assign    aa[26]=(a26[7]==0)?1:0;
    assign    aa[27]=(a27[7]==0)?1:0;
    assign    aa[28]=(a28[7]==0)?1:0;
    assign    aa[29]=(a29[7]==0)?1:0;
    assign    aa[30]=(a30[7]==0)?1:0;
    assign    aa[31]=(a31[7]==0)?1:0;

    always@(posedge clk ) begin//16阶段
        if(rst == 0) begin
            shift_reg <= 0;//
            a0 <= 0;
            a1 <= 0;
            a2 <= 0;
            a3 <= 0;
            a4 <= 0;
            a5 <= 0;
            a6 <= 0;
            a7 <= 0;
            a8 <= 0;
            a9 <= 0;
            a10 <= 0;
            a11 <= 0;
            a12 <= 0;
            a13 <= 0;
            a14 <= 0;
            a15 <= 0;
            a16 <= 0;
            a17 <= 0;
            a18 <= 0;
            a19 <= 0;
            a20 <= 0;
            a21 <= 0;
            a22 <= 0;
            a23 <= 0;
            a24 <= 0;
            a25 <= 0;
            a26 <= 0;
            a27 <= 0;
            a28 <= 0;
            a29 <= 0;
            a30 <= 0;
            a31 <= 0;

            wshaddr_o<=0;
            wsh_o<=0;
            outtoimmsh<=0;
            outtosh<=0;
            outtord<=0;
            tord_reg_waddr<=0;
            start <=1'b0;
            shend<=0;
            immshend<=0;
            tordend<=0;
            round <=3'b0;
            ranbusy_o <=0;
            ran_ceng<=0;
            index<=0;
            flag <=0;
            flagimm <=0;
            flagsh <=0;
            flagtord<=0;
        end else begin
            if (ranstart_i == 1'b1) begin
                if (start == 0&& round==3'b0) begin
                    ran_ceng <= ranceng;
                    shift_reg <= randseed[15:0];
                    start <= start+1;
                    ranbusy_o <= 1;
                end else if (start == 1) begin
                    shift_reg[0] <= shift_reg[15];
                    shift_reg[1] <= shift_reg[0];
                    shift_reg[2] <= shift_reg[1];
                    shift_reg[3] <= shift_reg[2];
                    shift_reg[4] <= shift_reg[3]^shift_reg[15];
                    shift_reg[5] <= shift_reg[4];
                    shift_reg[6] <= shift_reg[5];
                    shift_reg[7] <= shift_reg[6]; 
                    shift_reg[8] <= shift_reg[7];
                    shift_reg[9] <= shift_reg[8];
                    shift_reg[10] <= shift_reg[9];
                    shift_reg[11] <= shift_reg[10];
                    shift_reg[12] <= shift_reg[11];
                    shift_reg[13] <= shift_reg[12]^shift_reg[15];
                    shift_reg[14] <= shift_reg[13];
                    shift_reg[15] <= shift_reg[14]^shift_reg[15];
                    if (round<3'b110) begin
                        round <= round+1;
                    end
                end 
                if((start == 1)&&(round==3'b001)&&(ran_ceng>=1))begin
                    if (shift_reg[0] == 1) begin
                        a0 <= a1;
                        a1 <= a0;
                    end
                    if (shift_reg[1] == 1) begin
                        a2 <= a3;
                        a3 <= a2;
                    end
                    if (shift_reg[2] == 1) begin
                        a4 <= a5;
                        a5 <= a4;
                    end
                    if (shift_reg[3] == 1) begin
                        a6 <= a7;
                        a7 <= a6;
                    end
                    if (shift_reg[4] == 1) begin
                        a8 <= a9;
                        a9 <= a8;
                    end
                    if (shift_reg[5] == 1) begin
                        a10 <= a11;
                        a11 <= a10;
                    end
                    if (shift_reg[6] == 1) begin
                        a12 <= a13;
                        a13 <= a12;
                    end
                    if (shift_reg[7] == 1) begin
                        a14 <= a15;
                        a15 <= a14;
                    end
                    if (shift_reg[8] == 1) begin
                        a16 <= a17;
                        a17 <= a16;
                    end
                    if (shift_reg[9] == 1) begin
                        a18 <= a19;
                        a19 <= a18;
                    end
                    if (shift_reg[10] == 1) begin
                        a20 <= a21;
                        a21 <= a20;
                    end
                    if (shift_reg[11] == 1) begin
                        a22 <= a23;
                        a23 <= a22;
                    end
                    if (shift_reg[12] == 1) begin
                        a24 <= a25;
                        a25 <= a24;
                    end
                    if (shift_reg[13] == 1) begin
                        a26 <= a27;
                        a27 <= a26;
                    end
                    if (shift_reg[14] == 1) begin
                        a28 <= a29;
                        a29 <= a28;
                    end
                    if (shift_reg[15] == 1) begin
                        a30 <= a31;
                        a31 <= a30;
                    end

                end else if((start == 1)&& (round==3'b010)&&(ran_ceng>=2)) begin
                    if (shift_reg[0] == 1) begin
                        a0 <= a2;
                        a2 <= a0;
                    end
                    if (shift_reg[1] == 1) begin
                        a1 <= a3;
                        a3 <= a1;
                    end
                    if (shift_reg[2] == 1) begin
                        a4 <= a6;
                        a6 <= a4;
                    end
                    if (shift_reg[3] == 1) begin
                        a5 <= a7;
                        a7 <= a5;
                    end

                    if (shift_reg[4] == 1) begin
                        a8 <= a10;
                        a10 <= a8;
                    end
                    if (shift_reg[5] == 1) begin
                        a9 <= a11;
                        a11 <= a9;
                    end
                    if (shift_reg[6] == 1) begin
                        a12 <= a14;
                        a14 <= a12;
                    end
                    if (shift_reg[7] == 1) begin
                        a13 <= a15;
                        a15 <= a13;            //13,15
                    end

                    if (shift_reg[8] == 1) begin
                        a16 <= a18;
                        a18 <= a16;
                    end
                    if (shift_reg[9] == 1) begin
                        a17 <= a19;
                        a19 <= a17;
                    end
                    if (shift_reg[10] == 1) begin
                        a20 <= a22;
                        a22 <= a20;
                    end
                    if (shift_reg[11] == 1) begin
                        a21 <= a23;
                        a23 <= a21;
                    end

                    if (shift_reg[12] == 1) begin
                        a24 <= a26;
                        a26 <= a24;
                    end
                    if (shift_reg[13] == 1) begin
                        a25 <= a27;
                        a27 <= a25;
                    end
                    if (shift_reg[14] == 1) begin
                        a28 <= a30;
                        a30 <= a28;
                    end
                    if (shift_reg[15] == 1) begin
                        a29 <= a31;
                        a31 <= a29;
                    end
                   
                       
                    
                end else if ((start == 1)&& (round==3'b011)&&(ran_ceng>=3)) begin
                    if (shift_reg[0] == 1) begin
                        a0 <= a4;
                        a4 <= a0;
                    end
                    if (shift_reg[1] == 1) begin
                        a1 <= a5;
                        a5 <= a1;
                    end
                    if (shift_reg[2] == 1) begin
                        a2 <= a6;
                        a6 <= a2;
                    end
                    if (shift_reg[3] == 1) begin
                        a3 <= a7;
                        a7 <= a3;
                    end

                    if (shift_reg[4] == 1) begin
                        a8 <= a12;
                        a12 <= a8;
                    end
                    if (shift_reg[5] == 1) begin
                        a9 <= a13;
                        a13 <= a9;
                    end
                    if (shift_reg[6] == 1) begin
                        a10 <= a14;
                        a14 <= a10;
                    end
                    if (shift_reg[7] == 1) begin
                        a11 <= a15;
                        a15 <= a11;            
                    end

                    if (shift_reg[8] == 1) begin
                        a16 <= a20;
                        a20 <= a16;
                    end
                    if (shift_reg[9] == 1) begin
                        a17 <= a21;
                        a21 <= a17;
                    end
                    if (shift_reg[10] == 1) begin
                        a18 <= a22;
                        a22 <= a18;
                    end
                    if (shift_reg[11] == 1) begin
                        a19 <= a23;
                        a23 <= a19;
                    end

                    if (shift_reg[12] == 1) begin
                        a24 <= a28;
                        a28 <= a24;
                    end
                    if (shift_reg[13] == 1) begin
                        a25 <= a29;
                        a29 <= a25;
                    end
                    if (shift_reg[14] == 1) begin
                        a26 <= a30;
                        a30 <= a26;
                    end
                    if (shift_reg[15] == 1) begin
                        a27 <= a31;
                        a31 <= a27;
                    end
                    
                end else if ((start == 1)&& (round==3'b100)&&(ran_ceng>=4)) begin
                    if (shift_reg[0] == 1) begin
                        a0 <= a8;
                        a8 <= a0;
                    end
                    if (shift_reg[1] == 1) begin
                        a1 <= a9;
                        a9 <= a1;
                    end
                    if (shift_reg[2] == 1) begin
                        a2 <= a10;
                        a10 <= a2;
                    end
                    if (shift_reg[3] == 1) begin
                        a3 <= a11;
                        a11 <= a3;
                    end
                    if (shift_reg[4] == 1) begin
                        a4 <= a12;
                        a12 <= a4;
                    end
                    if (shift_reg[5] == 1) begin
                        a5 <= a13;
                        a13 <= a5;
                    end
                    if (shift_reg[6] == 1) begin
                        a6 <= a14;
                        a14 <= a6;
                    end
                    if (shift_reg[7] == 1) begin
                        a7 <= a15;
                        a15 <= a7;            
                    end

                    if (shift_reg[8] == 1) begin
                        a16 <= a24;
                        a24 <= a16;
                    end
                    if (shift_reg[9] == 1) begin
                        a17 <= a25;
                        a25 <= a17;
                    end
                    if (shift_reg[10] == 1) begin
                        a18 <= a26;
                        a26 <= a18;
                    end
                    if (shift_reg[11] == 1) begin
                        a19 <= a27;
                        a27 <= a19;
                    end
                    if (shift_reg[12] == 1) begin
                        a20 <= a28;
                        a28 <= a20;
                    end
                    if (shift_reg[13] == 1) begin
                        a21 <= a29;
                        a29 <= a21;
                    end
                    if (shift_reg[14] == 1) begin
                        a22 <= a30;
                        a30 <= a22;
                    end
                    if (shift_reg[15] == 1) begin
                        a23 <= a31;
                        a31 <= a23;
                    end
                    
                end else if ((start == 1)&& (round==3'b101)&&(ran_ceng>=5)) begin
                    if (shift_reg[0] == 1) begin
                        a0 <= a16;
                        a16 <= a0;
                    end
                    if (shift_reg[1] == 1) begin
                        a1 <= a17;
                        a17 <= a1;
                    end
                    if (shift_reg[2] == 1) begin
                        a2 <= a18;
                        a18 <= a2;
                    end
                    if (shift_reg[3] == 1) begin
                        a3 <= a19;
                        a19 <= a3;
                    end
                    if (shift_reg[4] == 1) begin
                        a4 <= a20;
                        a20 <= a4;
                    end
                    if (shift_reg[5] == 1) begin
                        a5 <= a21;
                        a21 <= a5;
                    end
                    if (shift_reg[6] == 1) begin
                        a6 <= a22;
                        a22 <= a6;
                    end
                    if (shift_reg[7] == 1) begin
                        a7 <= a23;
                        a23 <= a7;            
                    end

                    if (shift_reg[8] == 1) begin
                        a8 <= a24;
                        a24 <= a8;
                    end
                    if (shift_reg[9] == 1) begin
                        a9 <= a25;
                        a25 <= a9;
                    end
                    if (shift_reg[10] == 1) begin
                        a10 <= a26;
                        a26 <= a10;
                    end
                    if (shift_reg[11] == 1) begin
                        a11 <= a27;
                        a27 <= a11;
                    end
                    if (shift_reg[12] == 1) begin
                        a12 <= a28;
                        a28 <= a12;
                    end
                    if (shift_reg[13] == 1) begin
                        a13 <= a29;
                        a29 <= a13;
                    end
                    if (shift_reg[14] == 1) begin
                        a14 <= a30;
                        a30 <= a14;
                    end
                    if (shift_reg[15] == 1) begin
                        a15 <= a31;
                        a31 <= a15;
                    end
                    
                end else if ((start == 1) && (round==3'b110)) begin
                    ranbusy_o <= 1'b0;
                    start <= 0;
                    //a07<={a7,a6,a5,a4,a3,a2,a1,a0};
                    //a815<={a15,a14,a13,a12,a11,a10,a9,a8};
                    //a1623<={a23,a22,a21,a20,a19,a18,a17,a16};
                    //a2431<={a31,a30,a29,a28,a27,a26,a25,a24};
                    round <=0;
                    
                end 
            end
            
        end


        
        //immtosh
        if (immshstart_i == 1'b1) begin
            outtoimmsh <= 0;
            if (flagimm == 0) begin
                case (shufflereg)
                    'd0:a0 <= immnumber;
                    'd1:a1 <= immnumber;
                    'd2:a2 <= immnumber;
                    'd3:a3 <= immnumber;
                    'd4:a4 <= immnumber;
                    'd5:a5 <= immnumber;
                    'd6:a6 <= immnumber;
                    'd7:a7 <= immnumber;
                    'd8:a8 <= immnumber;
                    'd9:a9 <= immnumber;
                    'd10:a10 <= immnumber;
                    'd11:a11 <= immnumber;
                    'd12:a12 <= immnumber;
                    'd13:a13 <= immnumber;
                    'd14:a14 <= immnumber;
                    'd15:a15 <= immnumber;
                    'd16:a16 <= immnumber;
                    'd17:a17 <= immnumber;
                    'd18:a18 <= immnumber;
                    'd19:a19 <= immnumber;
                    'd20:a20 <= immnumber;
                    'd21:a21 <= immnumber;
                    'd22:a22 <= immnumber;
                    'd23:a23 <= immnumber;
                    'd24:a24 <= immnumber;
                    'd25:a25 <= immnumber;
                    'd26:a26 <= immnumber;
                    'd27:a27 <= immnumber;
                    'd28:a28 <= immnumber;
                    'd29:a29 <= immnumber;
                    'd30:a30 <= immnumber;
                    'd31:a31 <= immnumber;
                    default:          ;
                    
                endcase
            end
            
            immshend <=1;
            flagimm<=1;
            if (immshend == 1) begin
                outtoimmsh <= 1;
                immshend <=0;
                flagimm <=0;
                //a07<={a7,a6,a5,a4,a3,a2,a1,a0};
                //a815<={a15,a14,a13,a12,a11,a10,a9,a8};
                //a1623<={a23,a22,a21,a20,a19,a18,a17,a16};
                //a2431<={a31,a30,a29,a28,a27,a26,a25,a24};
            end 
        end
        //movtosh
        if (shstart_i == 1'b1) begin
            outtosh <= 0;
            if (flagsh ==0) begin
                case (shufflereg)
                    'd0:a0 <= shnumber;
                    'd1:a1 <= shnumber;
                    'd2:a2 <=shnumber;
                    'd3:a3 <= shnumber;
                    'd4:a4 <= shnumber;
                    'd5:a5 <= shnumber;
                    'd6:a6 <= shnumber;
                    'd7:a7 <= shnumber;
                    'd8:a8 <= shnumber;
                    'd9:a9 <= shnumber;
                    'd10:a10 <= shnumber;
                    'd11:a11 <= shnumber;
                    'd12:a12 <= shnumber;
                    'd13:a13 <= shnumber;
                    'd14:a14 <= shnumber;
                    'd15:a15 <= shnumber;
                    'd16:a16 <= shnumber;
                    'd17:a17 <= shnumber;
                    'd18:a18 <= shnumber;
                    'd19:a19 <= shnumber;
                    'd20:a20 <= shnumber;
                    'd21:a21 <= shnumber;
                    'd22:a22 <= shnumber;
                    'd23:a23 <= shnumber;
                    'd24:a24 <= shnumber;
                    'd25:a25 <= shnumber;
                    'd26:a26 <= shnumber;
                    'd27:a27 <= shnumber;
                    'd28:a28 <= shnumber;
                    'd29:a29 <= shnumber;
                    'd30:a30 <= shnumber;
                    'd31:a31 <= shnumber;
                    default:          ;
                    
                endcase
            end
            
            shend <=1;
            flagsh<=1;
            if (shend == 1) begin
                outtosh <= 1;
                shend <=0;
                flagsh <=0;
                //a07<={a7,a6,a5,a4,a3,a2,a1,a0};
                //a815<={a15,a14,a13,a12,a11,a10,a9,a8};
                //a1623<={a23,a22,a21,a20,a19,a18,a17,a16};
                //a2431<={a31,a30,a29,a28,a27,a26,a25,a24};
            end 
        end 

        if (tord_start_i == 1'b1) begin
            wshaddr_o<=tord_reg_waddr_i;
            
            case (index)
                'd0:wsh_o <= a0;  
                'd1:wsh_o <= a1;
                'd2:wsh_o <= a2;
                'd3:wsh_o <= a3;
                'd4:wsh_o <= a4;
                'd5:wsh_o <= a5;
                'd6:wsh_o <= a6;
                'd7:wsh_o <= a7;
                'd8:wsh_o <= a8;  
                'd9:wsh_o <= a9;
                'd10:wsh_o <= a10;
                'd11:wsh_o <= a11;
                'd12:wsh_o <= a12;
                'd13:wsh_o <= a13;
                'd14:wsh_o <= a14;
                'd15:wsh_o <= a15;
                'd16:wsh_o <= a16;  
                'd17:wsh_o <= a17;
                'd18:wsh_o <= a18;
                'd19:wsh_o <= a19;
                'd20:wsh_o <= a20;
                'd21:wsh_o <= a21;
                'd22:wsh_o <= a22;
                'd23:wsh_o <= a23;
                'd24:wsh_o <= a24;  
                'd25:wsh_o <= a25;
                'd26:wsh_o <= a26;
                'd27:wsh_o <= a27;
                'd28:wsh_o <= a28;
                'd29:wsh_o <= a29;
                'd30:wsh_o <= a30;
                'd31:wsh_o <= a31;
                'd32:wsh_o <= 128;
                default:wsh_o <= 128;
            endcase
        
         
            outtord <= 1;

             
        end else begin
            wsh_o<=128;
            wshaddr_o<=0;
            outtord <= 0;
        end
        /*
        
        */
        //init
        if (init_start_i == 1'b1) begin
            
            index<=aa[0]?0:aa[1]?1:aa[2]?2:aa[3]?3:aa[4]?4:aa[5]?5:aa[6]?6:aa[7]?7:aa[8]?8:aa[9]?9:aa[10]?10:aa[11]?11:aa[12]?12:aa[13]?13:aa[14]?14:aa[15]?15:aa[16]?16:aa[17]?17:aa[18]?18:aa[19]?19:aa[20]?20:aa[21]?21:aa[22]?22:aa[23]?23:aa[24]?24:aa[25]?25:aa[26]?26:aa[27]?27:aa[28]?28:aa[29]?29:aa[30]?30:aa[31]?31:32;
    
            //index<=0;
             
        end 
        if (inc_start_i == 1'b1) begin
            case (index)
                'd0: begin
                    case (1'b1)
                        aa[1]:index <= 1;
                        aa[2]:index <= 2;
                        aa[3]:index <= 3;
                        aa[4]:index <= 4;
                        aa[5]:index <= 5;
                        aa[6]:index <= 6;
                        aa[7]:index <= 7;
                        aa[8]:index <= 8;
                        aa[9]:index <= 9;
                        aa[10]:index <= 10;
                        aa[11]:index <= 11;
                        aa[12]:index <= 12;
                        aa[13]:index <= 13;
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                end
                'd1:begin
                    case (1'b1)
                        aa[2]:index <= 2;
                        aa[3]:index <= 3;
                        aa[4]:index <= 4;
                        aa[5]:index <= 5;
                        aa[6]:index <= 6;
                        aa[7]:index <= 7;
                        aa[8]:index <= 8;
                        aa[9]:index <= 9;
                        aa[10]:index <= 10;
                        aa[11]:index <= 11;
                        aa[12]:index <= 12;
                        aa[13]:index <= 13;
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd2:begin
                    case (1'b1)
                        aa[3]:index <= 3;
                        aa[4]:index <= 4;
                        aa[5]:index <= 5;
                        aa[6]:index <= 6;
                        aa[7]:index <= 7;
                        aa[8]:index <= 8;
                        aa[9]:index <= 9;
                        aa[10]:index <= 10;
                        aa[11]:index <= 11;
                        aa[12]:index <= 12;
                        aa[13]:index <= 13;
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd3:begin
                    case (1'b1)
                        aa[4]:index <= 4;
                        aa[5]:index <= 5;
                        aa[6]:index <= 6;
                        aa[7]:index <= 7;
                        aa[8]:index <= 8;
                        aa[9]:index <= 9;
                        aa[10]:index <= 10;
                        aa[11]:index <= 11;
                        aa[12]:index <= 12;
                        aa[13]:index <= 13;
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd4:begin
                    case (1'b1)
                        aa[5]:index <=5;
                        aa[6]:index <= 6;
                        aa[7]:index <= 7;
                        aa[8]:index <= 8;
                        aa[9]:index <= 9;
                        aa[10]:index <= 10;
                        aa[11]:index <= 11;
                        aa[12]:index <= 12;
                        aa[13]:index <= 13;
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd5:begin
                    case (1'b1)
                        aa[6]:index <= 6;
                        aa[7]:index <= 7;
                        aa[8]:index <= 8;
                        aa[9]:index <= 9;
                        aa[10]:index <= 10;
                        aa[11]:index <= 11;
                        aa[12]:index <= 12;
                        aa[13]:index <= 13;
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd6:begin
                    case (1'b1)
                        aa[7]:index <= 7;
                        aa[8]:index <= 8;
                        aa[9]:index <= 9;
                        aa[10]:index <= 10;
                        aa[11]:index <= 11;
                        aa[12]:index <= 12;
                        aa[13]:index <= 13;
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd7:begin
                    case (1'b1)
                        aa[8]:index <= 8;
                        aa[9]:index <= 9;
                        aa[10]:index <= 10;
                        aa[11]:index <= 11;
                        aa[12]:index <= 12;
                        aa[13]:index <= 13;
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd8:begin
                    case (1'b1)
                        aa[9]:index <= 9;
                        aa[10]:index <= 10;
                        aa[11]:index <= 11;
                        aa[12]:index <= 12;
                        aa[13]:index <= 13;
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd9:begin
                    case (1'b1)
                        aa[10]:index <= 10;
                        aa[11]:index <= 11;
                        aa[12]:index <= 12;
                        aa[13]:index <= 13;
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd10:begin
                    case (1'b1)

                        aa[11]:index <= 11;
                        aa[12]:index <= 12;
                        aa[13]:index <= 13;
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd11:begin
                    case (1'b1)
                        aa[12]:index <= 12;
                        aa[13]:index <= 13;
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd12:begin
                    case (1'b1)
                        aa[13]:index <= 13;
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd13:begin
                    case (1'b1)
                        aa[14]:index <= 14;
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd14:begin
                    case (1'b1)
                        aa[15]:index <= 15;
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd15:begin
                    case (1'b1)
                        aa[16]:index <= 16;
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd16:begin
                    case (1'b1)
                        aa[17]:index <= 17;
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd17:begin
                    case (1'b1)
                        aa[18]:index <= 18;
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd18:begin
                    case (1'b1)
                        aa[19]:index <= 19;
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd19:begin
                    case (1'b1)
                        aa[20]:index <= 20;
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd20:begin
                    case (1'b1)
                        aa[21]:index <= 21;
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd21:begin
                    case (1'b1)
                        aa[22]:index <= 22;
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd22:begin
                    case (1'b1)
                        aa[23]:index <= 23;
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd23:begin
                    case (1'b1)
                        aa[24]:index <= 24;
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd24:begin
                    case (1'b1)
                        aa[25]:index <= 25;
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd25:begin
                    case (1'b1)
                        aa[26]:index <= 26;
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                    
                end
                'd26:begin
                    case (1'b1)
                        aa[27]:index <= 27;
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                        
                end
                'd27:begin
                    case (1'b1)
                        aa[28]:index <= 28;
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase           
                end
                'd28:begin
                    case (1'b1)
                        aa[29]:index <= 29;
                        aa[30]:index <= 30;
                        aa[31]:index <= 31;  
                        default: index <=32;
                    endcase
                        
                end
                'd29:index<=(a30[7]==0)?30:(a31[7]==0)?31:32;
                'd30:index<=(a31[7]==0)?31:32;
                'd31:index<=32;
                default:    ;
            endcase

            /*
            if(index == 23 ||index == 25 ||index==28)begin
				index<=index+2;;
            end else if (index ==30) begin
                index<=32;
            end else if(index == 32) begin
                index<=32;
            end else begin
				index<=index+1;
			end
            */
        end 
    end
endmodule