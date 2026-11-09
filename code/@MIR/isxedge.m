function b = isxedge( obj, i, j, hv )

% isxedge  Determine whether a luminance edge belongs to an X junction
% 
% usage:  b = obj.isxedge( i, j, hv )
%   - ( i, j ) are the indices of an element of the luminance matrix obj.imL
%   - if hv==1 then the function tests the right (vertical) edge of element ( i, j )
%   - if hv==2 then the function tests the bottom (horizontal) edge of element ( i, j )

% initialize return value
b = false;

% test right (vertical) edge
if hv==1
    
    % if element (i,j) is in the last column, then the right edge is at
    % the image boundary, and cannot belong to an x junction
    if j==obj.dim(2)
        return
    end
    
    % if element (i,j) is not in the first row, then see if the right edge
    % is the bottom edge in an x junction
    if i > 1
        b = b | obj.isxjunc( obj.imL((i-1):i,j:(j+1)) );
    end
    
    % if element (i,j) is not in the bottom row, then see if the right edge
    % is the top edge in an x junction
    if i < obj.dim(1)
        b = b | obj.isxjunc( obj.imL(i:(i+1),j:(j+1)) );
    end
    
% test bottom (horizontal) edge
else
    
    % if element (i,j) is in the bottom row, then the bottom edge is at
    % the image boundary, and cannot belong to an x junction
    if i==obj.dim(1)
        return
    end
    
    % if element (i,j) is not in the first column, then see whether the
    % bottom edge is the rightmost edge in an x junction
    if j > 1
        b = b | obj.isxjunc( obj.imL(i:(i+1),(j-1):j) );
    end

    % if element (i,j) is not in the last column, then see whether the
    % bottom edge is the leftmost edge in an x junction
    if j < obj.dim(2)
        b = b | obj.isxjunc( obj.imL(i:(i+1),j:(j+1)) );
    end
    
end

end
