% plotit.m  Plot results from experiment 1 and 2

clear; clc;

% choose experiment
expt = 1;  % 1 or 2

% make list of data files
flist = dir( sprintf('data_experiment%d/*.txt', expt ) );

% step through data files
pdata = [];
for i = 1:numel( flist )
    
    % load data
    fname = fullfile( flist(i).folder, flist(i).name );
    data = load( fname, 'ascii' );
    stim = data(:,1);  % stimulus number (see list of stimulus nubmers below)
    flip = data(:,2);  % left-right mirror-reversal state; 0 = normal, 1 = reversed
    resp = data(:,3);  % observer response; 1 = left, 2 = right, 3 = same
    
    % sort by stimulus number
    [stim,k] = sort( stim );
    flip = flip( k );
    resp = resp( k );
    
    % find proportion of trials on which observer the chose the expected
    % target region or stimulus as appearing lighter; on non-mirror-reversed
    % this is the one on the left (resp=1) and on mirror-reversed trials
    % this is the one on the right (resp=2).  also, divide trials where
    % the observer responded 'same' between expected and unexpected
    % responses.
    r = [ 1 0 0.5 ];
    p = NaN( size( resp ) );
    k = flip == 0;
    p(  k ) = r( resp(k) );
    p( ~k ) = 1 - r( resp(~k) );
    
    % accumulate data over all data files
    pdata = [ pdata p(k) p(~k) ];
    
end

% find mean response rate and standard error
pmean = mean( pdata, 2 );
pstd = sqrt( pmean .* (1-pmean) ) ./ sqrt( size( pdata, 2 ) );

% plot response rate by condition
errorbar( pmean, 1.96*pstd, 'ro', 'MarkerFaceColor', 'r' ); hold on;
ylabel 'proportion expected'
set( gca, 'YLim', [ 0 1 ] );
xtickangle( 90 );
if expt==1
    plot( [ 0 20 ], [ 0.5 0.5 ], 'k:' );
    set( gca, 'XTick', 1:19 );
    set( gca, 'XTickLabel', { 'argyle', 'argyle control', 'argyle long-range', ...
        'snake', 'snake control', ...
        'koffka connected', 'koffka broken', 'koffka adelson', ...
        'simcon', 'simcon articulated', 'white', 'checkerboard', ...
        'argyle vs control', 'argyle-long vs control', ...
        'snake vs control', ...
        'koffka broken vs connected', 'koffka-adelson vs connected', ...
        'simcon articulated vs simcon', 'argyle vs simcon' } );
else
    plot( [ 0 10 ], [ 0.5 0.5 ], 'k:' );
    set( gca, 'XTick', 1:9 );
    set( gca, 'XTickLabel', { 'argyle', 'argyle control', ...
        'snake', 'snake control', 'simcon', ...
        'argyle vs control', 'argyle vs simcon', ...
        'snake vs control', 'snake vs simcon' } );
end
hold off;

% stimulus numbers, experiment 1
%
%    1 = argyle
%    2 = argyle control
%    3 = argyle long-range
%    4 = snake
%    5 = snake control
%    6 = koffka connected
%    7 = koffka broken
%    8 = koffka-adelson
%    9 = simultaneous contrast
%   10 = articulated simultaneous contrast
%   11 = white's illusio
%   12 = checkerboard assimilation
% 1001 = argyle vs argyle control
% 1002 = argyle long-range vs argyle control
% 1003 = snake vs control
% 1004 = koffka broken vs koffka connected
% 1005 = koffka-adelson vs koffka connected
% 1006 = articulated simultaneous contrast vs simultaneous contrast
% 1007 = argyle vs simultaneous contrast

% stimulus numbers, experiment 2
%
%    1 = argyle
%    2 = argyle control
%    3 = snake
%    4 = snake control
%    5 = simultaneous contrast
% 1001 = argyle vs argyle control
% 1002 = argyle vs simultaneous contrast
% 1003 = snake vs control
% 1004 = snake vs simultaneous contrast
