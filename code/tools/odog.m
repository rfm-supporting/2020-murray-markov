function imf = odog( im, bg, dx, dim )

% ODOG  ODOG brightness model
%
% usage:  imf = odog( im, bg, dx, dim )
%   - im is image to be filtered
%   - bg is background value to use if image needs to be enlarged with a border
%   - dx is size of one pixel in degrees of visual angle
%   - dim is size of stimulus image that im should be embedded in
% 
% This function is a MATLAB translation of the Mathematica code in:
% 
%     Blakeslee, B., Cope, D., & McCourt, M. E. (2016).  The oriented
% difference of Gaussians (ODOG) model of brightness perception:
% overview and executable Mathematica notebooks.  Behavior Research
% Methods, 48, 306-312.

% set default arguments
if nargin<2 || isempty(bg),  bg = 0;              end
if nargin<3 || isempty(dx),  dx = 1/32;           end
if nargin<4 || isempty(dim), dim = [ 1024 1024 ]; end

% create persistent variable containing filter bank
persistent ODOG
if isempty(ODOG) || ODOG.dx ~= dx || any( ODOG.dim ~= dim )
    ODOG = odogbank( dx, dim );
end

% add border to image
if any( size(im)~=dim )
    im = pad( im, dim, bg );
end

% get fourier transform of image
imft = fft2( im );

% initialize normalization factors
sig = NaN( size(ODOG.thetalist) );

% initialize output
imf = zeros( size(im) );

% combine responses across orientations
for i = 1:numel( ODOG.thetalist )
    
    % filter image
    imi = ifft2( imft .* ODOG.filterft_orient{i} );
    
    % normalize as in Blakeslee et al.'s (2016) Mathematica code
    imi = imi - mean(imi(:));  % mean response should be zero anyway, except for sampling issues
    sig(i) = sqrt( mean( imi(:).^2 ) );
    imi = imi / sig(i);
    
    % add response at this orientation to final result
    imf = imf + imi;
    
end

% normalize as in Blakeslee et al.'s (2016) Mathematica code
imf = imf * mean(sig);

end


function b = odogbank( dx, dim )

% ODOGBANK  Make a bank of filters for ODOG and related models
%
% b = odogbank( dx, dim )

% check parameters
if dx > 1/32
    warning('dx too large for ODOG''s smallest filter, which has sigma = 0.047 degrees; dx should be 1/32 degree or smaller');
end
if any( dx*dim < 24 )
    warning('matrix size too small for ODOG''s largest filter, which has sigma = 6 degrees; dx*dim should be at least 24 degrees');
end

% record scale parameters
b.dim = dim;
b.dx = dx;

% make list of filter orientations (from Blakeslee et al.'s (2016) Mathematica code)
b.thetalist = 0:30:150;

% make list of scales and weights (from Blakeslee et al.'s (2016) Mathematica code)
b.sigmalist =  [ 0.046875  0.09375  0.1875  0.375  0.75  1.5  3.0 ];
b.weightlist = [ 0.125     0.25     0.5     1.0    2.0   4.0  8.0 ].^(-1/10);

% make coordinate matrices at orientation theta = 0
mid = floor(dim/2)+1;
xvec = dx*( (1:dim(1)) - mid(1) );
yvec = dx*( (1:dim(2)) - mid(2) );
[x0,y0] = meshgrid( xvec, -yvec );

% initialize filter fields
b.filterft = cell( numel(b.thetalist), numel(b.sigmalist) );
b.filterft_orient = cell( numel(b.thetalist, 1 ) );
b.filterft_all = zeros(dim);

% step through orientations
for i = 1:numel(b.thetalist)
    
    % make coordinate matrices at this orientation
    if b.thetalist(i)==0
        x = x0;
        y = y0;
    else
        theta = b.thetalist(i);
        x =  cosd(theta)*x0 + sind(theta)*y0;
        y = -sind(theta)*x0 + cosd(theta)*y0;
    end
    
    % initialize orientation-pooled filter
    b.filterft_orient{i,1} = zeros(dim);
    
    % step through scales
    for j = 1:numel(b.sigmalist)
        
        % make unit-volume gaussians
        sigma = b.sigmalist(j);
        g1 = (1/(2*pi*sigma^2))*exp(-0.5*( x.^2 + y.^2 )/(sigma^2) );
        g2 = (1/(2*pi*(2*sigma)*sigma))*exp(-0.5*( (x.^2)/((2*sigma)^2) + (y.^2)/(sigma^2) ) );
        % the above two lines sample the gaussians, so the results don't
        % have exactly unit volume.  we could normalize them.
        
        % make ODOG filter, scaled for consistency with Blakeslee et al.'s (2016) Mathematica code
        f = ( g1 - g2 ) * dx^2;
        b.filterft{i,j} = fft2( fftshift( b.weightlist(j) * f ) );
        
        % add filter to orientation-pooled filter
        b.filterft_orient{i,1} = b.filterft_orient{i,1} + b.filterft{i,j};
        
    end
    
    % add orientation-pooled filter to all-pooled filter
    b.filterft_all = b.filterft_all + b.filterft_orient{i,1};
    
end

% add coordinate matrices to filter bank
b.x = x0;
b.y = y0;

end


function imp = pad( im, dim, bg )

% PAD  Pad an image to a required size
%
% imp = pad( im, dim, bg )

% find actual size
dima = size( im );

% image already the right size?
if all( size(im)==dim )
    imp = im;
    return
end

% image too large?
if any(dima>dim)
    error('input argument ''im'' is larger than %.0f x %.0f',dim);
end

% find offset
ddim = dim - dima;
offset = ceil( ddim/2 )+1;

% create padded image
imp = repmat(bg,dim);
imp(offset(1):offset(1)+dima(1)-1,offset(2):offset(2)+dima(2)-1) = im;

end
