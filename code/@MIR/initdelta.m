function initdelta( obj )

% initdelta  Set messages (deltas) to zero
% 
% usage:  obj.initdelta

% set message matrices (deltas) in 1-cliques to zero
z1 = zeros( [ obj.nstate 1 ] );  % make a column matrix of zeros
z1 = repmat( { z1 }, [ 1 4 ] );  % make a cell array with four copies (for the four directions of neighbours)
for i = 1:numel( obj.node1 )
    obj.node1(i).delta = z1;     % assign the cell array to each 1-node in the cluster graph
end

% set message matrices (deltas) in 4-cliques to zero
z4 = zeros( repmat( obj.nstate, [ 1 4 ] ) );  % make a four-dimensional array of zeros
z4 = repmat( { z4 }, [ 1 4 ] );               % make a cell array with four copies (for the four directions of neighbours)
for i = 1:numel( obj.node4 )
    obj.node4(i).delta = z4;                  % assign the cell array to each 4-node in the cluster graph
end

end
