// 打一拍
module gen_pipe_dff #(
    parameter aaa = 32)(

    input wire clk,
    input wire rst,
    input wire hold_en,

    input wire[aaa-1:0] dff,
    input wire[aaa-1:0] din,
    output wire[aaa-1:0] qout

    );

    reg[aaa-1:0] temp;

    always @ (posedge clk) begin
        if (!rst | hold_en) begin
            temp <= dff;   ////将异步复位信号先用Clk同步一下
        end else begin
            temp <= din;
        end
    end

    assign qout = temp;

endmodule

