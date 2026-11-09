classdef MIR < matlab.mixin.Copyable

    % MIR  Markov illuminance and reflectance model
    % 
    % See runme_mir.m for an illustration of how to use this object.
    % 
    % Also see the Supplementary Methods for a full description of
    % the conditional random field model and belief propagation algorithm
    % implemented in this object.
    % 
    % Some useful methods:
    % 
    %   MIR        constructor
    %   initpsi    initialize the MRF's local cost functions; must assign properties 'mstates' and 'imL' first (see below)
    %   initdelta  initialize belief propagation messages to zero
    %   mpass      run belief propagation (message passing)
    %   energy     calculate potential of current illuminance-reflectance assignment
    %   plotLMR    show images of luminance stimulus (imL) and current estimates of illuminance (imMhat) and reflectance (imRhat)
    % 
    % Some useful properties:
    % 
    %   imL       the luminance stimulus image
    %   mstates   a vector of allowed illuminance values
    %   wmedge0   weight for sum-of-squares cost function for illumiance edges not at image luminance edges
    %   wmedge1   weight for sum-of-squares cost function for illumiance edges at image luminance edges
    %   wmedgex   weight for sum-of-squares cost function for illuminances edges at luminance X junctions
    %   wmtwist   weight for illuminance twist cost function
    %   imMhat    current illuminance estimate
    %   imRhat    current reflectance estimate
    
    properties
        imL = [], dim = [ 0 0 ]      % luminance image (stimulus)
        mstates = [], nstate = 0     % illuminance values
        node1, node4                 % cluster graph nodes
        imMhat, imRhat               % illuminance and reflectance estimates
        wmedge0, wmedge1, wmtwist, wmedgex  % cost parameters
    end
    
    methods
        
        % constructor
        function obj = MIR( imL, mstates )
            
            % assign image luminance matrix (stimulus)
            if nargin >= 1 && ~isempty( imL )
                obj.imL = imL;
            end
            
            % assign illuminance values
            if nargin >= 2 && ~isempty( mstates )
                obj.mstates = mstates;
            end
            
        end
        
        % assign image luminance matrix (stimulus)
        function set.imL( obj, imL )
            
            obj.imL = imL;
            obj.dim = size( imL );
            
            % if we have enough information, initialize the cluster graph
            if ~isempty( obj.imL ) && ~isempty( obj.mstates )
                obj.initcluster;
            end
            
        end
        
        % assign illuminance values
        function set.mstates( obj, mstates )
            
            obj.mstates = mstates;
            obj.nstate = numel( mstates );
            
            % if we have enough information, initialize the cluster graph
            if ~isempty( obj.imL ) && ~isempty( obj.mstates )
                obj.initcluster;
            end
            
        end
        
    end
    
end
