function [laplace] = Laplacetransform_varoptions(lambda,r,T, C, G, M, Y)

meanQV = C*T*gamma(2-Y)*(1/M^(2-Y) + 1/G^(2-Y));

%exp(-r*T) .*
laplace = exp(-r*T) .*(feval(@laplace_transform, lambda,T, C, G, M, Y)-1)./lambda.^2 + meanQV./lambda;

end

