/* 
    this is the stimulus code for various modules of hardware.v
    the first layer contains 8 2-1 mux, the second layer has 
    4 2-1 mux, the third one has 2 2-1 mux and the final layer 
    has 1 2-1 mux.
    the selection signal for first layer is previous values of
    the input, for the further layer it's the delayed value of
    the ouput
*/

`timescale 1ns / 1ps
module testbench;
    
    //various inputs 
    reg clk,an,bn,cn,dn,en,fn,gn,hn;

    //the delayed signal of the output v
    wire a_1,a_2,a_3,a_4;

    //the delayed signal of the inputs an,bn,cn....
    wire an_1,bn_1,cn_1,dn_1,en_1,fn_1,gn_1,hn_1,v;
    
    //d flip flops for delayed ouput signals
    dff d2(a_1,v,clk);
    dff d3(a_2,a_1,clk);
    dff d4(a_3,a_2,clk);
    dff d5(a_4,a_3,clk);

    //module for storing the previous values of the input
    previnputs pi(an_1,bn_1,cn_1,dn_1,en_1,fn_1,gn_1,hn_1,
		clk,
		an,bn,cn,dn,en,fn,gn,hn);
    
    //the 8 outputs from layer 1 
    /*wire o1,o2,o3,o4,o5,o6,o7,o8;
    layer1 l1(o1,o2,o3,o4,o5,o6,o7,o8,
	    an_1,bn_1,cn_1,dn_1,en_1,fn_1,gn_1,hn_1,
	    an,bn,cn,dn,en,fn,gn,hn);
    
    //the four outputs from layer 2
    /*wire t1,t2,t3,t4;
    layer2 l2(t1,t2,t3,t4,
	    a_4,
	    o1,o2,o3,o4,o5,o6,o7,o8);
    
    //the two output from the layer 3
    wire u1,u2;
    layer3 l3(u1,u2,
	    a_3,
	    t1,t2,t3,t4);

    //the final layer
    layer4 l4(v,a_2,u1,u2);*/

    initial begin
	//to check the waveforms
	$dumpfile("hardware.vcd");
	$dumpvars;
	
	//initializing various input vars
	clk=0;
	an=0;bn=0;cn=0;dn=0;en=0;fn=0;gn=0;hn=0;
    end
    
    //updating input vars
    always #4 clk<=!clk;
    always #5 an<=!an;
    always #10 bn<=!bn;
    always #20 cn<=!cn;
    always #40 dn<=!dn;
    always #80 en<=!en;
    always #160 fn<=!fn;
    always #320 gn<=!gn;
    always #640 hn<=!hn;

    initial begin
	$display("time\tan\tbn\tcn\tdn\ten\tfn\tgn\thn : \tv\n");	
	$monitor("%d\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b : \tb",$time,
	    an,bn,cn,dn,en,fn,gn,hn,v);
    end
    
    //finishing the test bench
    initial
    #1300 $finish;
 
endmodule
