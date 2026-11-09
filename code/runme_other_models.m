% runme_other_models.m

clear; clc; clf;

% add toolbox folder to path
addpath( 'tools' );

% choose model
modelfn = @( imL ) odog( imL );                          % ODOG (Blakeslee & McCourt, 1999)
% modelfn = @( imL ) highpass( imL, 96 );                  % high-pass (Shapiro & Lu, 2011)
% modelfn = @( imL ) retinex_mccann99( log10( imL ), 4 );  % retinex (McCann, 1999)

% load stimulus
% - see 'help grid_stimuli' for additional stimulus names
[ stim, test1, test2 ] = grid_stimuli( 'argyle' );

% resize stimulus to 512 x 512 and center it in a 1024 x 1024 image where
% the background is the mean of the original image
stim = imresize( stim, 32, 'nearest' );
[ imL, ij1 ] = impad( stim, [ 1024 1024 ] );

% apply model
imR = modelfn( imL );

% show result
subplot(1,2,1); imagesc( imL ); colormap gray; axis image; title 'stimulus';
subplot(1,2,2); imagesc( imR ); axis image; title 'model output';

% find test regions in upsampled stimuli (512 x 512 instead of 16 x 16)
k = 512 / 16;  % size of a single block in upsampled stimuli
test1 = [ k*(test1(1)-1)+1 k*(test1(2)-1)+1 k*test1(3) k*test1(4) ] + [ ij1(1) ij1(2) ij1(1) ij1(2) ]-1;
test2 = [ k*(test2(1)-1)+1 k*(test2(2)-1)+1 k*test2(3) k*test2(4) ] + [ ij1(1) ij1(2) ij1(1) ij1(2) ]-1;

% show test regions on result figures
for i = 1:2
    subplot(1,2,i);
    outline( test1, 'r' );
    outline( test2, 'g' );
end

% find model outputs in test regions
r1 = mean( imR( test1(1):test1(3), test1(2):test1(4) ), 'all' );
r2 = mean( imR( test2(1):test2(3), test2(2):test2(4) ), 'all' );
fprintf('model outputs\n');
fprintf('  test region 1 (red):    %.2f\n',  r1 );
fprintf('  test region 2 (green):  %.2f\n\n',r2 );
