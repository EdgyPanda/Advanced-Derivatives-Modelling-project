function [L] = Laplace_Hestonvar(u,r,T,v0,kappa,theta,sigma)

meanvariance = (v0.*exp(-kappa.*T)+theta.*(1-exp(-kappa.*T)))./T;%./T;
%exp(-r.*T).*


%Pisani (2015) first formulation

L = ((feval(@Integratedvar_laplacetrans,u,T,v0,kappa,theta,sigma)-1)./u.^2+ meanvariance./u);

L=exp(-r.*T).*L;

%Pisani (2015) second formulation.
% L = ((feval(@integratedvar_laplacetransform2,u,T,v0,kappa,theta,sigma)-1)./u.^2 ...
% + meanvariance./u); 
% L=exp(-r.*T).*L;

% drimus paper:

% L = ((feval(@drimuslaplace,u,T,v0,kappa,theta,sigma)-1)./u.^2 ...
% + meanvariance./u); 
% L=exp(-r.*T).*L;

% To be able to reproduce curvature of the drimus paper

%L = ((feval(@Integratedvar_laplacetrans,u,T,v0,kappa,theta,sigma)-1)./u.^2+ meanvariance./u);

end

