function mpass14( obj, i, j, mdir )

% mpass14  Pass a message from a 1-cluster to a 4-cluster
%
% usage:  obj.mpass14( i, j, mdir )
%   - ( i, j ) are the coordinates of the sending 1-cluster in the cluster graph
%   - mdir is the direction of message passing
%       1 = northwest, 2 = southwest, 3 = southeast, 4 = northeast

% find energies of illuminance assignments
delta = obj.node1(i,j).psi;    % start with local energy, and
for kk = setdiff( 1:4, mdir )  % add in energy according to messages from neighbours,
                               % but skip the neighbour we're now passing a message to
    delta = delta + obj.node1(i,j).delta{kk};
end

% adjust so that lowest finite energy is zero
delta = delta - min( delta( isfinite(delta) ) );

% make a matrix that indicates opposite directions
% e.g., direction 1 is northwest (see help text above), and
%       direction odir(1) = 3 is southeast.
odir = [ 3 4 1 2 ];

% create message by pivoting data to required dimension
% - up to this point delta is an n x 1 matrix
% - here we turn it into a four-dimensional matrix that varies only
%   along dimension odir(mdir)
delta = pivot( delta, odir(mdir) );

% find target 4-cluster:  its coordinates in the cluster graph are ( ni, nj )
dij1 = [ -1 -1 ; 0 -1 ; 0 0 ; -1 0 ];
ni = i + dij1(mdir,1);
nj = j + dij1(mdir,2);

% send message
obj.node4(ni,nj).delta{odir(mdir)} = delta;

end


function matp = pivot( mat, dim )

% PIVOT  Reshape a matrix into a 1D vector along a given axis
% 
% usage:  matp = pivot( mat, dim )
%   e.g., MIRr.pivot( rand(10,1), 4 ) returns a random matrix with size [ 1 1 1 10 ]

shape = ones( [ 1 max(dim,2) ] );
shape( dim ) = numel( mat );
matp = reshape( mat, shape );

end
