function e = energy( obj )

% energy  Calculate energy of current illuminance and reflectance estimates
% 
% usage:  e = obj.energy

% find indices of illuminance values
imMk = NaN( size( obj.imMhat ) );
for i = 1:numel( imMk )
    imMk(i) = find( obj.mstates == obj.imMhat(i) );
end

% sum energy across 1-cliques
e = 0;
for i = 1:numel( obj.node1 )
    e = e + obj.node1(i).psi( imMk(i) );
end

% sum energy across 4-cliques
for i = 1:size(imMk,1)-1
    for j = 1:size(imMk,2)-1
        e = e + obj.node4(i,j).psi( imMk(i,j), imMk(i+1,j), imMk(i+1,j+1), imMk(i,j+1) );
    end
end

end
