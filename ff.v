module dff(output q,input d,clk);
    wire d,clk;
    reg q;
    initial
	q<=0;
    always@(negedge clk)
	q<=d;
endmodule
module dffnew(q,d,clk);
    input d, clk;
    output reg q;
    always @(posedge clk)
	q <= d;
endmodule

/*module dff(output q,input d,clk);
    wire d,clk;
    reg q;	
    always@(negedge clk)
	if(d==1'b0 || d==1'b1)begin
            q<=d;
        end else begin
            q<=0;
    end
endmodule
*/
