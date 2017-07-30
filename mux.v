module  mux2to1(output z,input s,input x0,x1);
    wire s_,o1,o2;
    not(s_,s);
    and(o1,s_,x0);
    and(o2,s,x1);
    or(z,o1,o2);
endmodule
