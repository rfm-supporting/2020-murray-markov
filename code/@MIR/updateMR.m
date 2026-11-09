function updateMR( obj )

% updateMR  Calculate illuminance (M) and reflectance (R) estimates based on
%           local potentials and current messages from neighbours
% 
% usage:  obj.updateMR
% 
%   after calling this function the estimated reflectance map is available
%   in matrix obj.imRhat and the estimated illuminance map is available
%   in matrix obj.imMhat.

% update beliefs
obj.updatebeta;

% initialize illuminance map
obj.imMhat = NaN( obj.dim );

% step through 1-clusters
for i = 1:obj.dim(1)
    for j = 1:obj.dim(2)
        
        % find state with lowest energy
        [ E, k ] = min( obj.node1(i,j).beta(:) );
        if isinf( E )
            warning('no solution at element (%d,%d)',i,j);
        end
        
        % record solution
        obj.imMhat(i,j) = obj.mstates( k );
        
    end
end

% calculate implied reflectance map
obj.imRhat = pi * obj.imL ./ obj.imMhat;

end
