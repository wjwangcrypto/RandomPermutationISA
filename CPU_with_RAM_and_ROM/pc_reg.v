
`include "defines.v"

module pc_reg(

    input wire clk,
    input wire rst,
    input wire rstflag,
    input wire jump_flag_i,                
    input wire[`InstAddrBus] jump_addr_i,   
    input wire[`Hold_Flag_Bus] hold_flag_i, 

    output reg[`InstAddrBus] pc_o           // PC指针

    );


    always @ (posedge clk) begin
        // 复位
        if (rst == `RstEnable ) begin
            pc_o <= `CpuResetAddr;
   
        end else if (rstflag == 0) begin
            pc_o <= 0;

        end else if (jump_flag_i == `JumpEnable) begin
            pc_o <= jump_addr_i;
       
        end else if (hold_flag_i >= `Hold_Pc ) begin
            pc_o <= pc_o;

        end else begin
            pc_o <= pc_o + 4'h4;
        end
    end

endmodule
