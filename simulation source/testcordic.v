`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2023 02:16:04 PM
// Design Name: 
// Module Name: testcordic
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


module testcordic();
localparam wi=16, wf=16;
reg signed [31:0] matin [0:36];
reg CLK, RST, EN, start;
reg signed [wi+wf-1:0] ang;
					//wire signed [21:0] angv;
					//wire signed [21:0] angv1;
					//wire signed [21:0] angv2;
					//wire signed [21:0] angv3;
					//wire [31:0] out;
					//wire [3:0] count;
					//wire signed [21:0] ox; 
					//wire signed [21:0] oy; 
					//wire signed [21:0] x; 
					//wire signed [21:0] y; 
					//wire signed [21:0] vx; 
					//wire signed [21:0] vy; 
					//wire signed [21:0] sx;
					//wire signed [21:0] sy;
					//wire signed [21:0] sumx;
					//wire signed [21:0] sumy; 
					//wire signed [21:0] vx2; 
					//wire signed [21:0] vy2;

cordic #(16, 16 ) uut (CLK, RST, EN, start, ang, out);

					//assign angv = uut.ang;
					//assign angv1 = uut.ang1;
					//assign angv2 = uut.ang2;
					//assign angv3 = uut.ang3;
					//assign count = uut.count;
					//assign ox = uut.ox;
					//assign oy = uut.oy;
					//assign x = uut.x;
					//assign y = uut.y;
					//assign vx = uut.vx;
					//assign vy = uut.vy;
					//assign sx = uut.sx;
					//assign sy = uut.sy;
					//assign sumx = uut.sumx;
					//assign sumy = uut.sumy;
					//assign vx2 = uut.vx2;
					//assign vy2 = uut.vy2;

initial CLK = 0;
always #5 CLK=~CLK;

integer i;
integer fileID;

initial begin

RST =1;
EN =0;
start=0;
ang =32'b00000000010001100000000000000000;//input
#10;
start=1;
RST =0;
#10;
start=0;
EN =1;
#5;
$readmemb("C:/Users/rgankidi4464/Desktop/memfile/corditest.txt",matin);
fileID = $fopen("C:/Users/rgankidi4464/Desktop/memfile/cordicwrite.txt", "w");
EN =1;
#5;
#90;
$finish;
for (i=0; i<37; i=i+1) begin
        
        RST =1;
        EN =0;
        start=0;
        ang <= matin[i];//input
        #10;
        start=1;
        RST =0;
        #10;
        start=0;
        EN =1;
        #5;
        EN =1;
        #5;
        #90;// Wait for some simulation time
        $fwrite(fileID,"%h\n",out);
        #2;
end
$fclose(fileID);


#90;
 $finish;

end 


endmodule
