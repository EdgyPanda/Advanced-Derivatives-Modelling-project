function [cf] = Schoutens_cf(u,S0,T,r,q,v0,kappa,theta,sigma,rho)
% Heston Characteristic function described in Schoutens et al. (2006).
%
%
%

%F = S0 .*exp(r-q).*T;

epsilon = kappa - sigma.*rho.*1i.*u;

d = sqrt((-epsilon).^2 - sigma.^2.*(-u.^2-1i.*u));

g2 = (epsilon-d)./(epsilon+d);

term1 = 1i.*u.*(log(S0)+(r-q).*T);

innerterm2 = (1-g2.*exp(-d.*T))./(1-g2);

term2 = ((kappa.*theta)./(sigma.^2)) .* ((epsilon-d).*T - 2.* log(innerterm2));

term3 = (v0./sigma.^2) .* (epsilon-d) .* ((1-exp(-d.*T))./(1-g2.*exp(-d.*T)));

cf = exp(term1+term2+term3);

end

