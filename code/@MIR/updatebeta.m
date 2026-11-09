function updatebeta( obj )

% updatebeta  Update belief matrices (betas) based on local potentials and
%             current messages from neighbours
% 
% usage:  obj.updatebeta

% update belief matrices for 1-cliques
for i = 1:numel( obj.node1 )
    
    % calculate belief matrix:  local cost plus messages from neighbours
    obj.node1(i).beta = obj.node1(i).psi;
    for kk = 1:4
        obj.node1(i).beta = obj.node1(i).beta + obj.node1(i).delta{kk};
    end
    
end

% update belief matrices for 4-cliques
for i = 1:numel( obj.node4 )
    
    % calculate belief matrix:  local cost plus messages from neighbours
    obj.node4(i).beta = obj.node4(i).psi;
    for kk = 1:4
        obj.node4(i).beta = obj.node4(i).beta + obj.node4(i).delta{kk};
    end
    
end

end
