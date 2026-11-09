% runme_mir.m

clear; clc; clf;

% add toolbox folder to path
addpath( 'tools' );

% create MIR object
model = MIR;

% choose illuminance values
model.mstates = logspace( log10( 30 ), log10( 350 ), 20 );

% choose cost parameters
model.wmedge0 =  600;  % parameter for illuminance edges without an image luminance edge
model.wmedge1 =   20;  % parameter for illuminance edges at an image luminance edge
model.wmedgex =    0;  % parameter for illuminance edges that are part of an X junction
model.wmtwist =  200;  % parameter for illuminance edges that are not straight

% load stimulus and assign to MIR object
% - see 'help grid_stimuli' for additional stimulus names
[ model.imL, test1, test2 ] = grid_stimuli( 'argyle' );

% calculate local potentials for this stimulus
model.initpsi;

% run belief propagation several times and take best result
for i = 1:10
    fprintf('run %d\n',i);
    
    % reset all messages to zero
    model.initdelta;
    
    % run belief propagation (five passes)
    model.mpass( 5 );
    
    % find final energy
    Estar = model.energy;
    fprintf('  final energy = %.2f\n\n',Estar);
    
    % if final energy is lower than best result so far, then save new results
    if i==1 || Estar < Emin
        model_min = copy( model );
        Emin = Estar;
    end
    
end

% show best result
model_min.plotLMR;

% show test regions on results
for i = 1:3
    subplot(1,3,i);
    outline( test1, 'r' );
    outline( test2, 'g' );
end

% find reflectance in test regions
r1 = mean( model_min.imRhat( test1(1):test1(3), test1(2):test1(4) ), 'all' );
r2 = mean( model_min.imRhat( test2(1):test2(3), test2(2):test2(4) ), 'all' );
fprintf('reflectance estimates\n');
fprintf('  test region 1 (red):    %.2f\n',r1 );
fprintf('  test region 2 (green):  %.2f\n\n',r2 );
