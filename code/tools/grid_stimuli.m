function [ imL, test1, test2 ] = grid_stimuli( imname )

% GRID_STIMULI  Load a 16 x 16 grid stimulus image
% 
% usage:  [ im, test1, test2 ] = grid_stimuli( imname )
%   - imname is the name of the stimulus
%   - im is the 16 x 16 image
%   - test1 and test2 are the two isoluminant target locations
%     in the stimulus; e.g., if test1 = [ 8 9 10 11 ], then the first test
%     location is imL(8:10,9:11)
% 
% stimulus names:  argyle, argyle_control, argyle_long,
%     snake, snake_control,
%     koffka_connected, koffka_broken, koffka_adelson,
%     simcon, simcon_articulated,
%     white, checkassim

try
    v = load( 'grid_stimuli.mat', imname );
catch
    error( 'unable to load stimulus ''%s''', imname );
end
imL = v.( imname ).imL;
test1 = v.( imname ).test1;
test2 = v.( imname ).test2;

end
