function mpass_list( obj, mlist )

% mpass_list  Pass messages in a list
%
% usage:  obj.mpass_list( mlist )
%
%   mlist is an n x 4 matrix where each row specifies a message passing operation.
%   messages are passed in order, from top to bottom of mlist.
%
%   let m = m(k,:) be a row of mlist.
% 
%   if m(1)==1 then the message is passed from a 1-cluster to a 4-cluster.
%   if m(1)==2 then the message is passed from a 4-cluster to a 1-cluster.
% 
%   ( m(2), m(3) ) are the (i,j) coordinates of the sending cluster
%   in the cluster graph.
% 
%   m(4) is the direction of the message.  see 'help mpass14' or 'help mpass41'
%   for the direction encoding scheme.

% step through rows of mlist
for i = 1:size(mlist,1)
    
    % do message passing operation indicated by entry mlist(i,:)
    if mlist(i,1)==1
        
        % pass from 1-cluster to 4-cluster
        obj.mpass14( mlist(i,2), mlist(i,3), mlist(i,4) );
        
    elseif mlist(i,1)==4
        
        % pass from 4-cluster to 1-cluster
        obj.mpass41( mlist(i,2), mlist(i,3), mlist(i,4) );
        
    else
        error('invalid node type');
    end
    
end

end
