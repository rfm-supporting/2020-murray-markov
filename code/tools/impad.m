function [ imp, ij1, ij2 ] = impad( im, dim )

% IMPAD  Pad an image with borders at mean image luminance to enlarge
%        it to a specified image size
% 
% usage:  imp = impad( im, dim )
%   - im is the image to be padded
%   - dim is the size [ m n ] of the result
%   - imp is the padded image

% initialize
imp = repmat( mean( im, 'all' ), dim );

% find indices for embedding image
dim0 = size( im );
mid0 = floor( dim0 / 2 ) + 1;
mid = floor( dim / 2 ) + 1;
ij1 = (mid-mid0) + 1;
ij2 = (mid-mid0) + dim0;

% embed
imp( ij1(1):ij2(1), ij1(2):ij2(2) ) = im;

end
