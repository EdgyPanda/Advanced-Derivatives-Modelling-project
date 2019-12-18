function [L] = integratedvar_laplacetransform2(u,T,v0,kappa,theta,sigma)
% The second formulation provided in Pisani (2015)
%
%
%
%
gamma = sqrt(kappa.^2 + (2.*sigma^2.*u)./T);

c = (kappa - gamma)./((-2.*u)./T);

d = (kappa + gamma)./((2.*u)./T);

b = (1-exp(gamma.*T))./(c+d.*exp(gamma.*T));

a = - (2.*kappa.*theta)./(sigma.^2) .* log((c+d.*exp(gamma.*T)./(c+d)))+ (kappa.*theta.*T)./c;


L = exp( a + b .* v0);


end

