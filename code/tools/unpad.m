function im = unpad( imp, dim0 )

% UNPAD  Remove a border from an image
% 
% usage:  im = unpad( imp, dim0 )
%   - imp  is the image whose border is to be removed
%   - dim0 is the size [ m n ] of the result
%   - imp  is the unpadded image

% find indices for central part of embedding image
dim = size( imp );
mid = floor( dim / 2 ) + 1;
mid0 = floor( dim0 / 2 ) + 1;
ij1 = (mid-mid0) + 1;
ij2 = (mid-mid0) + dim0;

% embed
im = imp( ij1(1):ij2(1), ij1(2):ij2(2) );

end
