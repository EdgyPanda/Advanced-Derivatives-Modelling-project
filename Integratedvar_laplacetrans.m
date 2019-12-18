function [L] = Integratedvar_laplacetrans(u,T,v0,kappa,theta,sigma)
% The first formulation provided in Pisani (2015)
%
%
%
%

%annualized:
gamma = sqrt(kappa.^2+(2.*sigma.^2.*u)./T);

c = (kappa+gamma) ./ ((-2.*u)./T);

d = (kappa - gamma)./((2.*u)./T); 

a = - (2.*kappa.*theta)./sigma.^2.*log((c+d.*exp(-gamma.*T))./(c+d))+(kappa.*theta.*T)./c;

b = (1-exp(-gamma.*T))./(c+d.*exp(-gamma.*T));

L = exp(a + v0 .* b);


%Non-annualized:
% gamma = sqrt(kappa.^2+(2.*sigma.^2.*u));
% 
% c = (kappa+gamma) ./ ((-2.*u));
% 
% d = (kappa - gamma)./((2.*u)); 
% 
% a = - (2.*kappa.*theta)./sigma.^2.*log((c+d.*exp(-gamma.*T))./(c+d))+(kappa.*theta.*T)./c;
% 
% b = (1-exp(-gamma.*T))./(c+d.*exp(-gamma.*T));
% 
% L = exp(a + v0 .* b);

end

