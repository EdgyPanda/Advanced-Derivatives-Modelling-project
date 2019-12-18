function y = cf_cgmy(u,T,C,G,M,Y)
% CGMY -- LEWIS:
    
m = -C*gamma(-Y)*((M-1)^Y-M^Y+(G+1)^Y-G^Y); %mg correction term. 

%1i*u*m*T+
temp =1i*u*m*T+C*T*gamma(-Y)*((M-1i*u).^Y-M^Y+(G+1i*u).^Y-G^Y);

y = exp(temp);

end



