function mpass( obj, npass, plotit, initflag )

% mpass  Run several iterations of message passing
% 
% usage:  obj.mpass( npass, plotit, initflag )
%   - npass is number of complete iterations of message passing
%   - plotit is 0/1 to flag whether intermediate results should be plotted
%   - initflag is 0/1 to flag whether all messages should be reset to zero before starting

if nargin < 2 || isempty( npass ),    npass = 5;    end
if nargin < 3 || isempty( plotit ),   plotit = 1;   end
if nargin < 4 || isempty( initflag ), initflag = 0; end

% if flagged, initialize all messages to zero
if initflag
    obj.initdelta;
end

% run several iterations
for i = 1:npass
    fprintf('  belief propagation pass %d / %d\n',i,npass);

    % do one pass of belief propagation using tree reparameterization
    % with horizontal and vertical subtrees
    obj.mpass_line;
    
    % show intermediate results
    if plotit
        obj.updateMR;  % update estimates of illuminance and reflectance
        obj.plotLMR;   % plot current estimates
        drawnow;
    end
    
end

% update estimates of illuminance and reflectance
obj.updateMR;

end
