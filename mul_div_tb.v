`timescale 1 ns/ 10 ps
module test();
reg clock;
reg [31:0] opera1;
reg [63:0] opera2;
reg cin;
reg muordi;
reg reset;
reg start;
wire [63:0] result;
wire valid;
mulordiv a (opera1,opera2,clock,start,result,valid,reset,muordi);
initial begin
muordi=0;
//muordi = 1;
clock = 1;
forever clock = #8 ~clock;
end
initial begin
reset=1;
#19 reset = 0;
start=1;
// reset=0;
//#15 start=1;
// reset=0;
//start=1;
#15 start=0;
end
initial begin
#1 cin=0;
$monitor("valid = %h,opera1 = %h,opera2 = %h,result = %h",valid,opera1,opera2,result);
opera1=32'h00000003; opera2=64'h0000000000000009;
#20000 $finish;
end
initial begin
$dumpfile("bestofluck.vcd");
$dumpvars(0);
end
endmodule
