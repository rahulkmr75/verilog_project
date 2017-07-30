//a two to one multiplexer module.
module  mux2to1(output z,input s,input x,y);
    wire s_,o1,o2;
    reg z;
    always @ (s or x or y)begin
	z<=(s)?x:y;
    end
endmodule

//a d flip flop module.
module dff(output q,input d,clk);
    wire d,clk;
    reg q;
    initial begin
	q<=0;
    end
    /*always@(negedge clk)
	q<=d;*/
    //this  is just to avoid the floating value 
    //condition in the begining
    always@(posedge clk)
        if(d==1'b0 || d==1'b1)begin
	    q<=d;
	end else begin
	    q<=0;
    end
endmodule

/*  layer1 consisting of 8 2to1 mux with an,bn.. as inputs
    and an_1,bn_1...as the selection signals and o1,o2...
    as the output signals.*/
module layer1(output o1,o2,o3,o4,o5,o6,o7,o8,
	     input an,bn,cn,dn,en,fn,gn,hn,
		an_1,bn_1,cn_1,dn_1,en_1,fn_1,gn_1,hn_1);
	mux2to1 m1(o1,an_1,an,en);
        mux2to1 m2(o2,bn_1,an,en);
        mux2to1 m3(o3,cn_1,bn,fn);
	mux2to1 m4(o4,dn_1,bn,fn);
        mux2to1 m5(o5,en_1,cn,gn);
        mux2to1 m6(o6,fn_1,cn,gn);
        mux2to1 m7(o7,gn_1,dn,hn);
        mux2to1 m8(o8,hn_1,dn,hn);
endmodule

/*  layer 2 consists of 4  2to1 mux with a delayed version
    of the hardware output as the selection signals.*/
module layer2(output t1,t2,t3,t4,
	    input a_4,
		o1,o2,o3,o4,o5,o6,o7,o8);
	mux2to1 m1(t1,a_4,o1,o2);
	mux2to1 m2(t2,a_4,o3,o4);
	mux2to1 m3(t3,a_4,o5,o6);
	mux2to1 m4(t4,a_4,o7,o8);
endmodule

/*  layer3 has 2 mux; t's are the output signal
    and a delayed version of the hardware output
    is used.*/
module layer3(output u1,u2,
	    input a_3,
		t1,t2,t3,t4);
	mux2to1 m1(u1,a_3,t1,t2);
	mux2to1 m2(u2,a_3,t3,t4);
endmodule

/*  layer4 similar to previous layers
    but with just one mux.*/
module layer4(output v,
	    input a_2,
		u1,u2);
	mux2to1 m1(v,a_2,u1,u2);
endmodule

/*  module for delaying the inpur signals
    according to the clock.*/
module  previnputs(output an_1,bn_1,cn_1,dn_1,en_1,fn_1,gn_1,hn_1,
		input clk,
		 an,bn,cn,dn,en,fn,gn,hn);
    reg an_1,bn_1,cn_1,dn_1,en_1,fn_1,gn_1,hn_1;
    wire clk,an,bn,cn,dn,en,fn,gn,hn;
    /*initial begin
	an_1<=0;
	bn_1<=0;
	cn_1<=0;
	dn_1<=0;
	en_1<=0;
	fn_1<=0;
	gn_1<=0;
	hn_1<=0;
    end*/
    //condition in the begining
    always@(posedge clk)begin
	an_1<=an;
	bn_1<=bn;
	cn_1<=cn;
	dn_1<=dn;
	en_1<=en;
	fn_1<=fn;
	gn_1<=gn;
	hn_1<=hn;
    end
endmodule

/*  various moudules for regvals and to 
    make a collective instance of the various layers
    and registers.*/
module regvals(output An_4,An_3,An_2,
		input An,clk);
	wire An_1;
	dff d1(An_1,An,clk);
	dff d2(An_2,An_1,clk);
	dff d3(An_3,An_2,clk);
	dff d4(An_4,An_3,clk);
endmodule

module hardware(inout An_2,
		input clk,
		     an,bn,cn,dn,en,fn,gn,hn);
	wire  o1,o2,o3,o4,o5,o6,o7,o8,
	    t1,t2,t3,t4,
	    u1,u2;

	inout An,An_3,An_4,
	    an_1,bn_1,cn_1,dn_1,en_1,fn_1,gn_1,hn_1;
	
	previnputs pvi(an_1,bn_1,cn_1,dn_1,en_1,fn_1,gn_1,hn_1,
		    clk,
		    an,bn,cn,dn,en,fn,gn,hn);

	regvals rv(An_4,An_3,An_2,
		An,clk);

	layer1 l1(o1,o2,o3,o4,o5,o6,o7,o8,
		    an,bn,cn,dn,en,fn,gn,hn,
	        an_1,bn_1,cn_1,dn_1,en_1,fn_1,gn_1,hn_1);

	layer2 l2(t1,t2,t3,t4,
		    An_4,
		    o1,o2,o3,o4,o5,o6,o7,o8);

	layer3 l3(u1,u2,
		    An_3,
		    t1,t2,t3,t4);
	 layer4 l4(An,An_2,u1,u2);
endmodule
module hardware2(output v,input [3:0]A, input
	 an_1,bn_1,cn_1,dn_1,en_1,fn_1,gn_1,hn_1,
		     an,bn,cn,dn,en,fn,gn,hn);
	wire o1,o2,o3,o4,o5,o6,o7,o8,
	    t1,t2,t3,t4,
	    u1,u2,
	    v;

	layer1 l1(o1,o2,o3,o4,o5,o6,o7,o8,
		    an,bn,cn,dn,en,fn,gn,hn,
	        an_1,bn_1,cn_1,dn_1,en_1,fn_1,gn_1,hn_1);

	layer2 l2(t1,t2,t3,t4,
		    A[3],
		    o1,o2,o3,o4,o5,o6,o7,o8);

	layer3 l3(u1,u2,
		    A[2],
		    t1,t2,t3,t4);
	layer4 l4(v,A[0],u1,u2);
endmodule
module regvals2 (output [3:0]A,input v,clk);
    dff d1(A[3],A[2],clk);
    dff d2(A[2],A[1],clk);
    dff d3(A[1],A[0],clk);
    dff d4(A[0],v,clk);
endmodule
    
