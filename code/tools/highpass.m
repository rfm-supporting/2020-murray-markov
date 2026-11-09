function imf = highpass( im, filtersize )

% HIGHPASS  High-pass filter model of brightness
% 
% usage:  imf = highpass( im, filtersize )
%   - im is image to be filtered
%   - filtersize is length of square filter (in pixels)
%   - imf is filtered image
% 
% based on:  Shapiro, A., & Lu, Z.-L. (2011).  Relative brightness in
%   natural imges can be accounted for by removing blurry content.
%   Psychological Science, 22(11), 1452-1459.

% find image size
dim = size( im );
if dim(1) ~= dim(2)
    error( 'requires a square image' );
end

% make coordinate matrices
midn = floor(dim(1)/2)+1;
xy = (1:dim(1)) - midn;
[x,y] = meshgrid(xy,-xy);

% make square inhibitory surround
filter = zeros(dim);
dleft  = -floor( filtersize/2 );
dright =  floor( (filtersize-1)/2 );
filter( x>=dleft & x<=dright & y>=dleft & y<=dright ) = -1/((filtersize^2) - 1);

% add excitatory centre
filter(midn,midn) = 1;

% filter image
imf = ifft2( fft2( im ) .* fft2( fftshift( filter ) ) );

end
