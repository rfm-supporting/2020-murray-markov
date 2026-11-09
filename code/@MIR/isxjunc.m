function b = isxjunc( ~, k )

% isxjunc  Determine whether a 2 x 2 pattern is an X junction
% 
% usage:  b = obj.isxjunc( x )
%   - x is a 2 x 2 matrix
%   - b is true if every horizontal and vertical pair in x consists
%     of two unequal values, and false otherwise

b = k(1,1)~=k(2,1) & k(2,1)~=k(2,2) & k(2,2)~=k(1,2) & k(1,1)~=k(1,2);

end
