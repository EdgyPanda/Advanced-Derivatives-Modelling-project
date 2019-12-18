function [call] = CGMY_Madan(S0,K,T,r,q,C,G,M,Y)

a = 0.75;

density = @(u) (exp(-r.*T).*cf_cgmyMADAN(u-(a+1).*1i,r,q,S0,T,C,G,M,Y))...
    ./(a.^2+a-u.^2+1i.*(2.*a+1).*u);


integrand = @(u) real(exp(-1i.*u.*log(K)).*density(u));

call = (exp(-a.*log(K))./pi) .* integral(integrand,0,inf,'ArrayValued',true); 


end
