`timescale 1ns / 1ps
module testbench;
    reg clk,d;
    wire q;
    dffnew d1  (q,d,clk);
    initial begin
	$dumpfile("ff.vcd");
	$dumpvars;
	clk=0;
	d=0;
    end
    always #5 d<=~d;
    always #4 clk<=~clk;
    initial  begin
	$display("time,\td,\tq"); 
	$monitor("%d,\t%b,\t%b",$time,d,q);  
    end
    initial 
    #100 $finish;
endmodule
