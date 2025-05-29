`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2023 06:09:47 PM
// Design Name: 
// Module Name: cordic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cordic #(parameter wi=16, wf=16 ) (input CLK, RST, EN, start, input signed [wi+wf-1:0] angin, output [31:0] out);
 

reg signed [21:0] matin [0:10];
initial begin
$readmemb("C:/Users/rgankidi4464/Desktop/memfile/cordic.txt",matin);
end
// matin concistes of matlab generated values where first value is scaling factor k and tan-invers values of 2's power(-i)
// used in following desigen
// these generated values are of came size which is 22 bits

wire signed [21:0] ang1;
assign ang1 = angin[ wf+11-1:wf-11 ] - {matin[1][20:0],{1'b0}}; //angle input - 90deg where matin[1]=45 (left shifting matin[1] is 90)
// input angle = 90 + ang1
wire signed [21:0] ang2;
assign ang2 = ang1 - {matin[1][20:0],{1'b0}};//angle input - 180deg
// input angle = 180 + ang2
wire signed [21:0] ang3;
assign ang3 = ang2 - {matin[1][20:0],{1'b0}};//angle input - 270deg 
// input angle = 360 + ang3
wire signed [21:0] angv2;
assign angv2 = (ang3[21])? ang2 : ang3;

wire signed [21:0] angv1;
assign angv1 = (ang2[21])? ang1 : angv2;

wire signed [21:0] ang;
assign ang = (ang1[21])? angin[ wf+11-1:wf-11 ] : angv1;//based on signed bit of substracted angles above chosing angle in range of 0 to 90

reg signed [21:0] x; //(2,20)
reg signed [21:0] y; //(2,20)
 

wire signed [21:0] vx; 
assign vx = (start)? matin[0] : x;

wire signed [21:0] vy;
assign vy = (start)? {22{1'b0}} : y;

reg [3:0] count;// in this design we use only 10 cycles

always @ (posedge CLK) begin
    if (RST) begin
        count <= 0;
    end
    else begin
        if (EN|start) begin
            count <= count + 1;
        end
        else begin
            count <= count;
        end
    end
end 

wire signed [21:0] sx;
shiftcase #(.wl(22)) s1 (vx, count ,sx );

wire signed [21:0] sy;
shiftcase #(.wl(22)) s2 (vy, count ,sy );


reg signed [21:0] angreg;
wire signed [21:0] vang;
wire d;
assign d = vang[21];// sign of remaning angle or (error in angle) to avode comparator (rotation direction)

reg signed [21:0] mang;// 10 cycles
always @*
case (count)
    4'b0000 : mang = matin[1];
    4'b0001 : mang = matin[2];
    4'b0010 : mang = matin[3];
    4'b0011 : mang = matin[4];
    4'b0100 : mang = matin[5];
    4'b0101 : mang = matin[6];
    4'b0110 : mang = matin[7];
    4'b0111 : mang = matin[8];
    4'b1000 : mang = matin[9];
    4'b1001 : mang = matin[10];
    //4'b1010 : mang = ;
    default : mang = 0;

endcase

wire signed [21:0] mang1;
assign mang1 = (d)? mang : -mang ;// chosing to add or substract the angle

assign vang = (start)? ang : angreg;

wire signed [21:0] sang;
assign sang = vang + mang1;// sang always gets near to zero in eatch cycle 

always @ (posedge CLK) begin
    if (RST) begin
        angreg <= 0;
    end
    else begin
        if (EN|start) begin
            angreg <= sang;
        end
        else begin
            angreg <= angreg;
        end
    end
end 

wire signed [21:0] vx2;
assign vx2 = (d)? sy : -sy;// chosing to add or substract 

wire signed [21:0] vy2;
assign vy2 = (d)? -sx : sx;// chosing to add or substract 

wire signed [21:0] sumx;
assign sumx = vx + vx2; //sang always gets near to zero

wire signed [21:0] sumy;
assign sumy = vy + vy2;

always @ (posedge CLK) begin
    if (RST) begin
        x <= 0;
        y <= 0;
    end
    else begin
        if (EN|start) begin
            x <= sumx;
            y <= sumy;
        end
        else begin
            x <= x;
            y <= y;
        end
    end
end

reg signed [21:0] ox;//cos value
reg signed [21:0] oy;//sin value

always @*
case ({ang1[21],ang2[21],ang3[21]})//based on signed bits of substracted angles ang1,ang2,ang3 above chosing x and y values  
3'b111:begin  ox = x; oy=y; end
3'b011:begin  ox = -y; oy=x; end
3'b001:begin  ox = -x; oy=-y; end
3'b000:begin  ox = y; oy=-x; end

endcase


// out consistes of 6bits of sign bit in ox and (ox) cos(wi=2,wf=8,wl=10) and 6bits of sign bit in oy and (oy) sin (wi=2,wf=8,wl=10)
assign out = {{6{ox[21]}}, ox[21:12], {6{oy[21]}}, oy[21:12]} ;



endmodule





module shiftcase#(parameter wl = 22) (input signed [wl-1:0] in,input [3:0] count ,output reg signed [wl-1:0] out); 
//reg signed [wl-1:0] out;

always @(count, in)
case (count)
    4'b0000 : out = in;
    4'b0001 : out = {{1{in[wl-1]}},in[wl-1:1]};
    4'b0010 : out = {{2{in[wl-1]}},in[wl-1:2]};
    4'b0011 : out = {{3{in[wl-1]}},in[wl-1:3]};
    4'b0100 : out = {{4{in[wl-1]}},in[wl-1:4]};
    4'b0101 : out = {{5{in[wl-1]}},in[wl-1:5]};
    4'b0110 : out = {{6{in[wl-1]}},in[wl-1:6]};
    4'b0111 : out = {{7{in[wl-1]}},in[wl-1:7]};
    4'b1000 : out = {{8{in[wl-1]}},in[wl-1:8]};
    4'b1001 : out = {{9{in[wl-1]}},in[wl-1:9]};
    //4'b1010 : out = in >>> 10;
    default : out = 0;

endcase

endmodule













