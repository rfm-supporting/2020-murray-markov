function initpsi( obj )

% initpsi  Initialize local potential functions
% 
% usage:  obj.initpsi

% create potential functions (lookup tables) for horizontal 2-cliques
psiE2h = cell( obj.dim - [ 0 1 ] );  % this structure will hold the results
for i = 1:obj.dim(1)
    for j = 1:obj.dim(2)-1
        
        % call psi2 to find the potential matrix for this 2-clique
        psiE2h{i,j} = psi2( obj, j==1, j==obj.dim(2)-1, i==1 || i==obj.dim(1), ...
            obj.imL( i, [ j j+1 ] ), obj.isxedge( i, j, 1 ) );
        
    end
end

% create potential functions (lookup tables) for vertical 2-cliques
psiE2v = cell( obj.dim - [ 1 0 ] );  % this structure will hold the results
for i = 1:obj.dim(1)-1
    for j = 1:obj.dim(2)
        
        % call psi2 to find the potential matrix for this 2-clique
        psiE2v{i,j} = psi2( obj, i==1, i==obj.dim(1)-1, j==1 || j==obj.dim(2), ...
            obj.imL( [ i i+1 ], j ), obj.isxedge( i, j, 2 ) );
        
    end
end

% calculate illuminance twist potential function (same for all 4-cliques)
logm = log10( obj.mstates );
[lm1,lm2,lm3,lm4] = ndgrid( logm, logm, logm, logm );
twist2 = ( ( lm1 + lm3 ) - ( lm2 + lm4 ) ).^2;
E4t = obj.scaleit( obj.wmtwist, twist2 );

% create potentials for 4-cliques
for i = 1:obj.dim(1)-1
    for j = 1:obj.dim(2)-1
        
        % combine 2-clique potentials
        n = obj.nstate;
        E2_14 = reshape( psiE2h{i,j},    [ n 1 1 n ] );
        E2_23 = reshape( psiE2h{i+1,j},  [ 1 n n 1 ] );
        E2_12 =          psiE2v{i,j};
        E2_34 = reshape( psiE2v{i,j+1}', [ 1 1 n n ] );  % note transpose
        E2 = E2_14 + E2_23 + E2_12 + E2_34;
        
        % record 4-clique potential
        obj.node4(i,j).psi = E2 + E4t;
        
        % initialize belief matrix
        obj.node4(i,j).beta = obj.node4(i,j).psi;
        
    end
end

end

function E2 = psi2( obj, border1, border2, border12, imL, xedge )

% psi2  Calculate potential matrix for a 2-clique
% 
% usage:  E2 = psi2( obj, border1, border2, border12, imL, xedge )
%   - obj is the MIR object
%   - border1 is 0/1 to indicate whether imL(1) is at an image border perpendicular to the 2-clique
%   - border2 is 0/1 to indicate whether imL(2) is at an image border perpendicular to the 2-clique
%   - border12 is 0/1 to indicate whether imL(1:2) is at an image border parallel to the 2-clique
%   - imL is a 2-element matrix that gives the image luminances for this 2-clique
%   - xedge is 0/1 to indicate whether this 2-clique spans a luminance edge that is part of an X junction
%   - E2 is a 2D matrix that serves as a lookup table for the cost of each possible illuminance assignment to the 2-clique

% create grids for log illuminance states
logm = log10( obj.mstates );
[ lm1, lm2 ] = ndgrid( logm, logm );

% 1-clique log illuminance cost
c1 = lm1;
c2 = lm2;

% 1-clique reflectance cost ( implied reflectance:  reflectance = pi * luminance / illuminance )
r1 = obj.rprior_nll( pi * imL(1) ./ obj.mstates(:) );
r2 = obj.rprior_nll( pi * imL(2) ./ obj.mstates(:) )';

% divide costs by number of 2-cliques that include each 1-clique
if ~border1
    c1 = c1 / 2;
    r1 = r1 / 2;
end
if ~border2
    c2 = c2 / 2;
    r2 = r2 / 2;
end
if ~border12
    c1 = c1 / 2;
    c2 = c2 / 2;
    r1 = r1 / 2;
    r2 = r2 / 2;
end
E2 = c1 + c2 + r1 + r2;

% 2-clique illuminance edge cost
if xedge
    w = obj.wmedgex;    % 2-clique spans a luminance edge in an X junction
elseif imL(1)==imL(2)
    w = obj.wmedge0;    % 2-clique is in a uniform luminance region
else
    w = obj.wmedge1;    % 2-clique spans a luminance edge
end
E2 = E2 + obj.scaleit( w, ( lm1 - lm2 ).^2 );

% pool 2-clique costs within uniform luminance regions
if imL(1)==imL(2)
    E2 = E2 / 2;
end

% divide 2-clique cost by number of 4-cliques that include this 2-clique
if ~border12
    E2 = E2 / 2;
end

end
