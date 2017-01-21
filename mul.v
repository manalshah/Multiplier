`timescale 1 ns/ 10 ps
module mux (result,valid,reset,start,clock,opera1,opera2,muordi);
input clock;
input [31:0] opera1;
input [63:0] opera2;
input reset;
wire reset;
input start;
input muordi;
output valid;
reg valid;
wire [31:0] temp;
output result;
reg [63:0] result;
reg [31:0] x ;
reg [63:0] y;
reg cin;
wire clock;
wire carry;
wire [31:0]opera1;
wire [63:0]opera2;
reg flag0 ;
reg flag1;
reg flag2;
reg flag3;
reg [31:0] q;
reg [31:0] r;
reg [5:0]count;
reg flag6;
always@(posedge clock or posedge reset)
begin
if (reset==1)
begin
flag1 <= 1;
flag2 <= 1;
flag3 <= 1;
cin<=0;
result<=64'b0;
x[31:0]<=32'b0;
y[63:0]<=64'b0;
r[31:0]<=0;
count<=0;
flag0 <= 1;
valid<=0;
end
else
begin
if(start==1)begin
flag6<=1;
end
if (muordi == 0)
begin
if(flag6)begin
if (opera1[31] == 0 && opera2[31] == 0)
begin
if (count==0)
begin
x[31:0]<=opera1[31:0];
y[63:0]<=opera2[63:0];
count<=count+1;
valid<=0;
end
else if (count<33)
begin
if (y[0]==0)
begin
y<=y>>1;
count<=count+1;
end
else
begin
y[63:0]<={1'b0,temp[31:0],y[31:1]};
count<=count+1;
end
end
else
begin
result[63:0]<=y[63:0];
valid<=1;
end
end
else if (opera1[31]==1 && opera2[31]==0)
begin
if (count==0)
begin
if (flag0 == 1)
begin
x[31:0] <= ~opera1[31:0];
y[63:32] <= 32'b1;
flag0 <= 0;
end
else
begin
x[31:0] <= temp[31:0];
y[63:0] <= opera2 [63:0];
count <= count+1;
valid<=0;
end
end
else if (count<33 && count>0)
begin
if (y[0]==0)
begin
y<=y>>1;
count<=count+1;
end
else
begin
y[63:0]<={1'b0,temp[31:0],y[31:1]};
count<=count+1;
end
end
else
begin
if (flag1 == 1)
begin
q[31:0] <= ~y[31:0];
r[31:0] <= ~y[63:32];
flag1<=0;
end
else
begin
if (flag2==1)
begin
x[31:0] <= 1;
y[63:32] <= q[31:0];
flag2<=0;
end
else
begin
if (flag3==1)
begin
y[31:0]<=temp[31:0];
cin <= carry;
x[31:0]<=0;
y[63:32] <= r[31:0];
flag3<=0;
valid<=1;
end
else
begin
result[63:0] <= {temp[31:0],y[31:0]};
end
end
end
end
end
else if (opera1[31]==0 && opera2[31]==1)
begin
if (count == 0)
begin
if (flag0 == 1)
begin
y[63:32]<=~opera2[31:0];
x[31:0]<=1;
flag0 <= 0;
end
else
begin
y[63:0] <= {32'd0,temp [31:0]};
x[31:0]<=opera1[31:0];
count <= count+1;
valid<=0;
end
end
else if (count<33 && count>0)
begin
if (y[0]==0)
begin
y<=y>>1;
count<=count+1;
end
else
begin
y[63:0]<={1'b0,temp[31:0],y[31:1]};
count<=count+1;
end
end
else
begin
if (flag1 == 1)
begin
q[31:0] <= ~y[31:0];
r[31:0] <= ~y[63:32];
flag1<=0;
end
else
begin
if (flag2==1)
begin
x[31:0] <= 1;
y[63:32] <= q[31:0];
flag2<=0;
end
else
begin
if (flag3==1)
begin
y[31:0]<=temp[31:0];
cin <= carry;
x[31:0]<=0;
y[63:32] <= r[31:0];
flag3<=0;
valid<=1;
end
else
begin
result[63:0] <= {temp[31:0],y[31:0]};
end
end
end
end
end
else if (opera1[31]==1 && opera2[31]==1)
begin
if (count == 0)
begin
if (flag0 == 1)
begin
x[31:0] <= ~opera1[31:0];
y[63:32] <= 32'b1;
flag0 <= 0;
end
else
begin
if(flag1==1)
begin
q[31:0] <= temp [31:0];
y[63:32] <= ~opera2[31:0];
x[31:0] <= 32'b0;
flag1<=0;
end
else
begin
y[63:0] <= {32'd0,temp[31:0]};
x[31:0] <= q[31:0];
count <= count+1;
valid<=0;
end
end
end
else if (count<33)
begin
if (y[0]==0)
begin
y<=y>>1;
count<=count+1;
end
else
begin
y[63:0]<={1'b0,temp[31:0],y[31:1]};
count<=count+1;
end
end
else
begin
result[63:0]<=y[63:0];
valid<=1;
end
end
else
begin
x[31:0]<=opera1[31:0];
y[63:0]<=opera2[63:0];
end
end
end
end
end
alu FR1 (.sum(temp[31:0]),.cout(carry),.a(x[31:0]),.b(y[63:32]),.cin(1'b0));
endmodule
// 32-bit Adder
module alu (sum,cout,a,b,cin);
input [31:0] a,b;
input cin;
output [31:0] sum;
output cout;
rip_16 RR1 (.sum(sum[15:0]),.carry(c1),.a(a[15:0]),.b(b[15:0]),.cin(cin));
rip_16 RR2 (.sum(sum[31:16]),.carry(cout),.a(a[31:16]),.b(b[31:16]),.cin(c1));
endmodule
//16-bit Adder
module rip_16 (sum,carry,a,b,cin);
input [15:0] a,b;
input cin;
output [15:0] sum;
output carry;
rip_4 R1 (.sum(sum[3:0]),.carry(c1),.a(a[3:0]),.b(b[3:0]),.cin(cin));
rip_4 R2 (.sum(sum[7:4]),.carry(c2),.a(a[7:4]),.b(b[7:4]),.cin(c1));
rip_4 R3 (.sum(sum[11:8]),.carry(c3),.a(a[11:8]),.b(b[11:8]),.cin(c2));
rip_4 R4 (.sum(sum[15:12]),.carry(carry),.a(a[15:12]),.b(b[15:12]),.cin(c3));
endmodule
// 4-bit Adder
module rip_4 (sum,carry,a,b,cin);
input [3:0] a, b;
input cin;
output [3:0] sum;
output carry;
fu_add F1 (.sum(sum[0]),.carry(c1),.a(a[0]),.b(b[0]),.cin(cin));
fu_add F2 (.sum(sum[1]),.carry(c2),.a(a[1]),.b(b[1]),.cin(c1));
fu_add F3 (.sum(sum[2]),.carry(c3),.a(a[2]),.b(b[2]),.cin(c2));
fu_add F4 (.sum(sum[3]),.carry(carry),.a(a[3]),.b(b[3]),.cin(c3));
endmodule
module fu_add (sum,carry,a,b,cin);
input a,b,cin;
output sum,carry;
wire a,b,cin,c1,c2;
hf_add H1 (.sum(sum1),.carry(c1),.a(a),.b(b));
hf_add H2 (.sum(sum), .carry(c2), .a(sum1), .b(cin));
assign carry = c1|c2;
endmodule
// Half Adder
module hf_add (sum,carry,a,b);
input a,b;
output sum,carry;
wire a,b;
assign sum = a ^ b;
assign carry = a & b;
endmodule
Multiplier Testbench:-
`timescale 1 ns/ 10 ps
module test();
reg clock;
reg [31:0] opera1;
reg [63:0] opera2;
reg muordi;
//reg cin;
reg reset;
reg start;
wire [63:0] result;
wire valid;
mux a1 (result,valid,reset,start,clock,opera1,opera2,muordi);
initial begin
clock = 1;
forever clock = #5.5 ~clock;
end
initial begin
muordi=0;
reset=1;
#10 start=1;
#18 reset=0;
#11 start= 0;
end
initial begin
//#1 cin=0;
$monitor("valid = %h,opera1 = %h,opera2 = %h,result = %h",valid,opera1,opera2,result);
//opera1=32'h0FFE4523; opera2 =64'h000000000598125D;
//opera1=32'hB0C0D0A0 ; opera2=64'h000000005F757654;
//opera1=32'h000000AA; opera2=64'h0000000000540060;
opera1=32'h089645AA; opera2=64'h00000000BFCDFF43;
#20000 $finish;
end
initial begin
$dumpfile("bestofluck.vcd");
$dumpvars(0);
end
endmodule

