function y = cf_cgmyMADAN(u,r,q,S,T,C,G,M,Y)
% CGMY -- MADAN:
    
m = -C*gamma(-Y)*((M-1)^Y-M^Y+(G+1)^Y-G^Y); %mg correction term. 

%1i*u*m*T+
temp =1i*u*(log(S)+(r-q+m).*T)+C*T*gamma(-Y)*((M-1i*u).^Y-M^Y+(G+1i*u).^Y-G^Y);

y = exp(temp);

end