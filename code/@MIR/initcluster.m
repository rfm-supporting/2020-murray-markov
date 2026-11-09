function initcluster( obj )

% initcluster  Create data structure for cluster graph
% 
% usage:  obj.initcluster


% initialize clusters for 1-cliques

% create a column matrix of zeros, with the same number of entries as
% obj.mstates, the matrix of possible illuminance values
z1 = zeros( [ obj.nstate 1 ] );

% create a 1-cluster
n1.psi   = z1;                         % potential function
n1.delta = repmat( { z1 }, [ 1 4 ] );  % messages from four neighbours
n1.beta  = z1;                         % belief matrix

% create a grid (struct array) of 1-clusters
obj.node1 = repmat( n1, obj.dim );


% initialize clusters for 4-cliques

% create a four-dimensional matrix of zeros, where each dimension has
% size equal to the number of possible illuminance values
z4 = zeros( repmat( obj.nstate, [ 1 4 ] ) );

% create a 4-cluster
n4.psi   = z4;                         % potential function
n4.delta = repmat( { z4 }, [ 1 4 ] );  % messages from neighbours
n4.beta  = z4;                         % belief matrix

% create a grid (struct array) of 4-clusters
obj.node4 = repmat( n4, obj.dim-1 );


end
