function mpass_line( obj )

% mpass_line  Do one complete message passing iteration using tree
%             reparameterization with horizontal and vertical subtrees
%
% usage:  obj.mpass_line

% make list of horizontal subtrees
% - treeh is a n x 3 matrix where each row indicates a horizontal subtree
% - let t = treeh(k,:) be a row of treeh
%   - always t(1)==1 to indicate that this is a horizontal subtree
%   - t(2) is the row number in the 1-clique cluster graph
%   - if t(3)==1 then the subtree starts at 1-clique with coordinates
%     ( t(2), 1 ), then has a connection to the 4-clique to the northeast,
%     then a connection to the 1-clique to the southeast, and continues
%     in this manner (northeast, southeast, northeast, southeast, etc.)
%     across the cluster graph
%   - if t(3)==2 then the subtree starts at 1-clique with coordinates
%     ( t(2), 1 ), then has a connection to the 4-clique to the southeast,
%     then a connection to the 1-clique to the northeast, and continues
%     in this manner (southeast, northeast, southeast, northeast, etc.)
%     across the cluster graph
treeh = [ ones([ obj.dim(1) 1 ]) (1:obj.dim(1))' repmat(2,[ obj.dim(1) 1 ]) ];
treeh(end,3) = 1;

% make list of vertical subtrees
% - treev is a n x 3 matrix where each row indicates a vertical subtree
% - let t = treev(k,:) be a row of treev
%   - always t(1)==2 to indicate that this is a vertical subtree
%   - t(2) is the column number in the 1-clique cluster graph
%   - if t(3)==1 then the subtree starts at 1-clique with coordinates
%     ( 1, t(2) ), then has a connection to the 4-clique to the southeast,
%     then a connection to the 1-clique to the southwest, and continues
%     in this manner (southeast, southwest, southeast, southwest, etc.)
%     down the cluster graph
%   - if t(3)==2 then the subtree starts at 1-clique with coordinates
%     ( 1, t(2) ), then has a connection to the 4-clique to the southwest,
%     then a connection to the 1-clique to the southeast, and continues
%     in this manner (southwest, southeast, southwest, southeast, etc.)
%     down the cluster graph
treev = [ repmat(2,[ obj.dim(2) 1 ]) (1:obj.dim(2))' repmat(2,[ obj.dim(2) 1 ]) ];
treev(end,3) = 1;

% combine row and column lists, and randomize order
tlist = [ treeh ; treev ];
tlist = tlist( randperm(size(tlist,1)), : );

% step through subtrees
for t = 1:size(tlist,1)
    
    hv = tlist(t,1);  % horizontal or vertical
    ij = tlist(t,2);  % row or column number
    md = tlist(t,3);  % mode
    
    % forward pass
    mlist = mlist_line( hv, ij, 1, md, obj.dim );  % make a list of forward message passing operations for this subtree
    obj.mpass_list( mlist );                       % do the message passing operations
    
    % backward pass
    mlist = mlist_line( hv, ij, 2, md, obj.dim );  % make a list of backward message passing operations for this subtree
    obj.mpass_list( mlist );                       % do the message passing operations
    
end

end


function m = mlist_line( hv, ij, fb, md, dim )

% mlist_line  Make a list of message passing operations for a horizontal or
%             vertical subtree in a single direction
% 
%  if hv==1, make a list for the horizontal subtree in row ij
%  if hv==2, make a list for the vertical subtree in column ij
% 
%  if fb==1, make a list for a forward pass (left-right or top-down)
%  if fb==2, make a list for a backward pass (right-left or bottom-up)
%
%  md encodes the 'mode' of the subtree; see explanation of t(3) in the
%      help text for mpass_line above
% 
%  dim = [ m n ] is the size of the m x n cluster graph grid

% the matrix created by this function will be passed to obj.mpass_list
% as a list of message passing operations.  see 'help mass_list' for
% a description of the type of matrix that that function expects.

% check location and mode
if ij==1 && md==1
    error('cannot have mode 1 for top row or leftmost column');
elseif ij==dim(hv) && md==2
    error('cannot have mode 2 for bottom row or rightmost column');
end

% if hv==2, then the request is for a vertical subtree on a cluster
% of dimensions dim = [ m n ].  we will do this by first making a list
% for a horizontal subtree of dimensions fliplr(dim) = [ n m ], and
% then adjusting the list below before returning it.
if hv==2
    dim = fliplr( dim );
end

% inline function that repeats x(:) vertically k times
rep1 = @( x, k ) repmat(x(:),[ k 1 ]);

% inline function that repeats x(1) vertically k times, then x(2)
% vertically k times, and so on, all in a column vector
rep2 = @( x, k ) reshape( repmat( x(:)', [ k 1 ] ), [ k*numel(x) 1 ] );

% make a list of alternating 1-cluster to 4-cluster and 4-cluster to
% 1-cluster message passing operations
m1 = [ rep1( [ 1 4 ], dim(2)-1 ) ; 1 ];         % first column is the type of sending node (1 or 4)
if md==1
    m2 = [ rep1([ ij ij-1 ],dim(2)-1) ; ij ];   % second column is the row number of the sending node
else
    m2 = repmat( ij, [ 2*dim(2)-1 1 ] );
end
m3 = [ rep2( 1:dim(2)-1, 2 ) ; dim(2) ];        % third column is the column number of the sending node
m = [ m1 m2 m3 ];

if fb==1
    % make a list of message passing operations left to right
    
    m = m(1:end-1,:);
    if md==1
        m4 = rep1( [ 4 3 ], dim(2)-1 );   % fourth column is the direction of the message
    else
        m4 = rep1( [ 3 4 ], dim(2)-1 );
    end
    m = [ m m4 ];
    
else
    % make a list of message passing operations right to left
    
    m = flipud(m);                         % if backward pass, then reverse order of message passing operations
    m = m(1:end-1,:);
    if md==1
        m4 = rep1( [ 1 2 ], dim(2)-1 );    % fourth column is the direction of the message
    else
        m4 = rep1( [ 2 1 ], dim(2)-1 );
    end
    m = [ m m4 ];
    
end

% as explained above, if the request is for a vertical subtree, then
% we now adjust the list we just made for a horizontal subtree to describe
% a vertical subtree.
if hv==2
    
    % when we transpose a grid, i and j coordinates are reversed
    m(:,[ 2 3 ]) = fliplr(m(:,[ 2 3 ]));
    
    % make a matrix that describes how directions change when we transpose
    % a grid, e.g., direction 1 (northwest) remains direction flipk(1) = 1,
    % whereas direction 2 (southwest) becomes direction flipk(2)=4 (northeast).
    flipk = [ 1 4 3 2 ];
    
    % adjust all message directions accordingly
    m(:,4) = flipk( m(:,4) );
    
end

end
