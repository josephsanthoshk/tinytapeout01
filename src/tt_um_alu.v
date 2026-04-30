module tt_um_alu (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire ena,
    input  wire clk,
    input  wire rst_n
);

wire [7:0] ui = ui_in;

reg [7:0] A;
reg [7:0] B;
reg [7:0] result;

reg zero;
reg carry;

assign uo_out = result;

// control signals
wire loadA   = uio_in[0];
wire loadB   = uio_in[1];
wire execute = uio_in[2];
wire [2:0] opcode = uio_in[5:3];

reg [8:0] temp;

always @(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        A <= 8'b0;
        B <= 8'b0;
        result <= 8'b0;
        zero <= 0;
        carry <= 0;
    end

    else if(ena) begin

        if(loadA)
            A <= ui;

        if(loadB)
            B <= ui;

        if(execute) begin

            case(opcode)

                3'b000: begin
                    temp <= A + B;
                    result <= A + B;
                    carry <= (A + B) > 8'hFF;
                end

                3'b001: begin
                    temp <= A - B;
                    result <= A - B;
                    carry <= temp[8];
                end

                3'b010: begin
                    result <= A & B;
                    carry <= 0;
                end

                3'b011: begin
                    result <= A | B;
                    carry <= 0;
                end

                3'b100: begin
                    result <= A ^ B;
                    carry <= 0;
                end

                3'b101: begin
                    result <= A << 1;
                    carry <= A[7];
                end

                3'b110: begin
                    result <= A >> 1;
                    carry <= A[0];
                end

                3'b111: begin
                    result <= (A == B) ? 8'hFF : 8'h00;
                    carry <= 0;
                end

            endcase

            zero <= (result == 8'b0);

        end

    end

end


assign uio_out[6] = zero;
assign uio_out[7] = carry;


assign uio_out[5:0] = 6'b000000;

assign uio_oe = 8'b11000000;

endmodule
