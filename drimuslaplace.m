function [laplace] = drimuslaplace(lambda,T,v0,kappa,theta,sigma)
%The formulation in the paper of Drimus (2012)


gamma = sqrt( (kappa).^2 + sigma.^2.*(2.*(lambda./T)));

upperb = (2.*(lambda./T)).*(exp(gamma.*T)-1);
lowerb = (gamma+kappa).*(exp(gamma.*T)-1)+2.*gamma;

b = upperb./lowerb;

a = - kappa.*theta.*b.*T; % .*T

laplace = exp(a-b.*v0);

end

