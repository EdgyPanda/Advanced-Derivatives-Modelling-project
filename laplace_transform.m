function [laplace] = laplace_transform(lambda,T, C, G, M, Y)
%Function used to evaluate the QV option price for the CGMY process

ap = M;
an = G;

Bracket1 = 2.*lambda./Y + ap^2/(Y.*(1-Y));

Bracket2 = 2.*lambda./Y + an^2/(Y.*(1-Y));

fiftheq = 2.*lambda.*ap./(Y.*(1-Y));

seventheq = 2.*lambda.*an./(Y.*(1-Y));

nintheq = ap.^Y./(Y.*(1-Y));

eleventheq = an^Y./(Y.*(1-Y));

temp = Bracket1.* I(2-Y,ap,lambda) + Bracket2 .* I(2-Y,an,lambda)...
    +fiftheq.*I(3-Y,ap,lambda)+seventheq.*I(3-Y,an,lambda)...
    -nintheq.*gamma(2-Y) - eleventheq.*gamma(2-Y);

laplace = C.*T.*exp(-temp);

end

function U = hypergeomfunc(a,b,z)
  
temp =  hypergeom(a,b,z)./(gamma(1+a-b).*gamma(b));

temp2 = hypergeom(1+a-b,2-b,z)./(gamma(a).*gamma(2-b));

U = pi./sin(pi.*b) .* ( temp - z.^(1-b) .* temp2);
        
end

function H = hermitefunc(v,z)

H = 2.^(v./2) .* hypergeomfunc(-v./2, 0.5, z.^2./2);

end

function integraleval = I(v,a,lambda)

integraleval = (2.*lambda).^(-v./2).*gamma(v).*hermitefunc(-v, a./(sqrt(2.*lambda)));

end