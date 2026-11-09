function wk = scaleit( ~, w, k )

% scaleit  Multiply a matrix by a constant, but set any matrix entries
%          where the product is Inf * 0 to zero (instead of NaN)
% 
% usage:  wk = obj.scaleit( w, k )
%   - w is a matrix
%   - k is a constant

f = abs( k ) > 1e-6;     % instead of k==0, to avoid finite-precision weirdness
wk = zeros( size( k ) );
wk( f ) = w * k( f );

end
