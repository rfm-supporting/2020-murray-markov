function nll = rprior_nll( ~, r )

% rprior_nll  Negative log likelihood of reflectance prior
% 
% usage:  nll = obj.rprior_nll( r )
%   - r is reflectance
%   - nll is the negative log likelihood of reflectance r

% increasing logistic function
a1 = 0.04; b1 = 0.01;
y1 = 1./( 1 + exp( (a1-r)/b1 ) );

% decreasing logistic function
a2 = 0.85; b2 = 0.05;
y2 = 1./( 1 + exp( (r-a2)/b2 ) );

% merge, and scale to unit area
p = min( y1, y2 ) / ( a2 - a1 );

% return negative log likelihood
nll = -log10( p );

end
