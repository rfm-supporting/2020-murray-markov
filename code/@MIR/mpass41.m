function mpass41( obj, i, j, mdir )

% mpass41  Pass a message from a 4-cluster to a 1-cluster
%
% usage:  obj.mpass41( i, j, mdir )
%   - ( i, j ) are the coordinates of the sending 4-cluster in the cluster graph
%   - mdir is the direction of message passing
%       1 = northwest, 2 = southwest, 3 = southeast, 4 = northeast

% find energies of illuminance assignments
delta = obj.node4(i,j).psi;    % start with local energy, and
for kk = setdiff( 1:4, mdir )  % add in energy according to messages from neighbours,
                               % but skip the neighbour we're now passing a message to
    delta = delta + obj.node4(i,j).delta{kk};
end

% create message by min-marginalizing over directions other than mdir
delta = min( delta, [], setdiff( 1:4, mdir ) );
delta = delta(:);

% adjust message so that lowest finite energy is zero
delta = delta - min( delta( isfinite(delta) ) );

% find target 4-cluster:  its coordinates in the cluster graph are ( ni, nj )
dij4 = [ 0 0 ; 1 0 ; 1 1 ; 0 1 ];
ni = i + dij4(mdir,1);
nj = j + dij4(mdir,2);

% make a matrix that indicates opposite directions
% e.g., direction 1 is northwest (see help text above), and
%       direction odir(1) = 3 is southeast.
odir = [ 3 4 1 2 ];

% send message
obj.node1(ni,nj).delta{odir(mdir)} = delta;

end
