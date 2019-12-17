function [call] = Heston_schoutens(S0,K,T,r,q,v0,kappa,theta,sigma,rho)
% The version found in the paper of Cui et al. (2017). 
%
%
% integrand1 = @(u) real( (exp(-1i.*u.*log(K./S0))./(1i.*u)) .* Schoutens_cf(u-1i,S0,T,r,q,v0,kappa,theta,sigma,rho) );
% 
% integrand2 = @(u) real( (exp(-1i.*u.*log(K./S0))./(1i.*u)) .* Schoutens_cf(u,S0,T,r,q,v0,kappa,theta,sigma,rho) );
% 
% 
% integral1 = S0 .* integral(integrand1,0,100,'ArrayValued',true);
% integral2 = K .* integral(integrand2,0,100,'ArrayValued',true);
% 
% 
% temp2 = (exp(-r.*T)./pi) .* (integral1 - integral2);
% 
% call = 0.5.* (S0.*exp(-q.*T)- K .*exp(-r.*T)) + temp2;
%--------------------------------------------------------------------------
%
%
%
%Carr madan approach as described in Schoutens et al. (2006):

a = 0.75;


density = @(u) (exp(-r.*T).*Schoutens_cf(u-(a+1).*1i,S0,T,r,q,v0,kappa,theta,sigma,rho))...
    ./(a.^2+a-u.^2+1i.*(2.*a+1).*u);


integrand = @(u) real(exp(-1i.*u.*log(K)).*density(u));

call = (exp(-a.*log(K))./pi) .* integral(integrand,0,inf,'ArrayValued',true); 


end

