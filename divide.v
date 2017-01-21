`timescale 1 ns/ 10 ps
module divi(opera1,opera2,clock,start,result,valid,reset,muordi);
input [31:0] opera1;
input [63:0] opera2;
input clock;
input start;
wire start;
input reset;
input muordi;
wire reset;
wire clock;
wire carry;
output [63:0] result;
wire [31:0] temp;
reg [63:0] result;
reg [31:0] x;
reg [63:0] y;
reg [4:0] st,n_st;
reg [31:0]count;
reg [31:0]remainder;
reg [31:0]quotient;
reg ope;
reg[31:0] p,q;
reg [63:0] r,s;
output valid;
reg valid;
parameter s0 = 5'b0000;
parameter s1 = 5'b0001;
parameter s2 = 5'b0010;
parameter s3 = 5'b0011;
parameter s4 = 5'b0100;
parameter s5 = 5'b0101;
parameter s6 = 5'b0110;
parameter s7 = 5'b0111;
parameter s8 = 5'b1000;
parameter s9 = 5'b1001;
parameter s10 = 5'b1010;
parameter s11 = 5'b1011;
parameter s12 = 5'b1100;
parameter s13 = 5'b1101;
parameter s14 = 5'b1110;
parameter s15 = 5'b1111;
parameter s16 = 5'b10000;
parameter s17 = 5'b10001;
parameter s18 = 5'b10010;
parameter s19 = 5'b10011;
parameter s20 = 5'b10100;
parameter s21 = 5'b10101;
parameter s22 = 5'b10110;
parameter s23 = 5'b10111;
always @(posedge clock or posedge reset)
begin
if(reset == 1)
begin
y[63:0] <= 64'h0000000000000000;
x[31:0] <= 32'h00000000;
result[63:0]<= 64'h0000000000000000;
valid <= 0;
count <= 32'hFFFFFFFF;
ope<=0;
p[31:0]<=0;
q[31:0]<=0;
r[63:0]<=0;
s[63:0]<=0;
n_st<=s23;
end
else begin
if(start) begin
n_st<=s0;
end
if(muordi==1)
begin
case(n_st)
s0: begin
p <= opera1;
r <= opera2;
ope <= 1;
result <= 0;
count <= 32'hFFFFFFFF;
valid <= 0;
n_st <= s1;
end
s1: begin
if(opera1[31] == 0 && opera2[63] == 0)
begin
q[31:0] <= p[31:0];
n_st <= s2;
end
else if(opera1[31] == 1 || opera2[63] == 1)
begin
n_st <= s12;
end
end
s2:begin
if(ope == 1)begin
x[31:0] <= ~q[31:0];
y[63:32] <= 32'b01;
n_st<= s3;
end
else begin
n_st <= s4;
end
end
s3:begin
p[31:0] <= temp[31:0];
n_st <= s4;
end
s4:begin
if(ope == 1)begin
x[31:0] <= p[31:0];
y[63:32] <= r[63:32];
n_st <= s5;
end
else begin
x[31:0] <= q[31:0];
y[63:32] <= r[63:32];
n_st <= s5;
end
end
s5: begin
if(count!=0)begin
if(ope == 1)begin
r[63:32] <= temp[31:0];
n_st <= s6;
end
else begin
r[63:32] <= temp[31:0];
n_st <= s6;
end
end
else begin
if(ope==1)begin
s6:begin
if(r[63]== 0) begin
r <= r << 1;
n_st <= s7;
end
else begin
r <= r << 1;
ope <=0;
count <= count >> 1;
n_st <= s4;
end
end
s7: begin
r[0]<=1;
ope <= 1;
count <= count>>1;
n_st <= s4;
end
s8:begin
if(r[63]==1)begin
x[31:0] <= r[63:32];
y[63:32] <= q[31:0];
n_st <= s9;
end
else begin
n_st <= s11;
end
end
s9:begin
r[63:32] <= temp[31:0];
r[31:0] <= r[31:0]<<1;
n_st <= s10;
end
s10:begin
quotient <= r[31:0];
remainder <= r[63:32];
n_st <= s16;
end
s11:begin
r[31:0] <= r[31:0]<<1;
r[0] <= 1;
n_st <= s10;
end
s12:if(opera1[31]==1'b1)
begin
x[31:0] <= ~p[31:0];
q[31:0] <= p[31:0];
n_st <= s13;
end
s13:
if(opera2[63]==1'b1) begin
x[31:0] <= ~r[31:0];
y[63:32] <= 32'b01;
n_st <= s15;
end
else begin
n_st <= s2;
end
s14:begin
q[31:0] <= temp[31:0];
n_st <= s13;
end
s15:begin
r[31:0] <= temp[31:0];
if(carry==1)begin
n_st <= s18;
end
else begin
n_st <= s19;
end
end
s16: begin
if(opera1[31]!=opera2[63])begin
if(opera1[31]==1 || opera1[31]==0 && opera2[63]==0)begin
x[31:0] <= ~quotient;
y[63:32] <= 32'b01;
n_st <= s17;
end
else if(opera2[63]==1)begin
x[31:0] <= ~quotient;
y[63:32] <= 32'b01;
n_st <= s21;
end
end
else begin
valid <= 1;
result <= {r[63:32],quotient};
end
end
s18:begin
x[31:0] <= ~r[63:32];
y[63:32] <= 32'b01;
n_st <= s20;
end
initial begin
muordi=1;
reset=1;
#19 reset = 0;
start=1;
end
initial begin
$monitor("valid = %h,opera1 = %h,opera2 = %h,result = %h",valid,opera1,opera2,result);
//opera1=32'hA0A0A0A0; opera2=64'hCDCDCDCD55555555;
//opera1=-32'd1500; opera2=64'd130456;
//opera1=32'hABABABAB; opera2=64'hBACCABBAC2342345;
//opera1=32'h00456829; opera2=64'h0047804400983450;
opera1=32'h66666666; opera2=64'h32323232BABABABA;
#200000 $finish;
end
initial begin
$dumpfile("bestofluck.vcd");
$dumpvars(0);
end
endmodule
