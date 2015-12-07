function init =  initGPCov( covStr, X, Y, scale )
% function: init =  initGPCov (covStr, X, Y)
%
% initGPCov() initializes covariance function parameters of GPy, GPz{:}, GPs for a given covariance structure 
% based upon statistics of data {X, Y}.
%
% GPy is a global hyper-parameters set for modeling real observed dynamics 
% Yv across Xv.
%
% GPz is a cell vector with each cell containing a global hyper-parameters 
% set of a latent GP for modeling the corresponding latent parameterization 
% dynamics.
%
% GPs is a hyper-parameters set to a stationary covariance function that 
% is used to select an initial set of suboptimal latent locations under
% LISAL.
%
% covStr: is a structure with properties: { 'NGP', 'kFun' }.
%
% outputs:
% 
% init: is a structure with fields GPs, GPy, GPz. Field 'GPy'
% represents initialized hyperparametes of GPy that models real observable
% dynamics; field 'GPz' is a vector of cells with each cell a structure of
% initialized hyperparameters of a latent GPz; field 'GPs' is a structure
% of initialized hyperparameters of stationary GPs. Hyperparameter fields
% for GPy, GPz, GPs includes { 'sigmaF', 'sigmaN', 'sigmaL'.
% 
% Also see documentation for ngp, lisal, covStr

init.GPy = initGPyCov( covStr, X, Y, scale );

if isfield( covStr, 'NGP' )
    if ~isfield( covStr, 'GM' )
        init.GPz = initGPzCov( covStr, X, Y, scale );
    end
    
    init.GPs = initGPsCov( X, Y, scale );%GPs is stationary GP learned on real dynamics    
end

end

function GPy = initGPyCov( covStr, X, Y, scale )
%Initializes global hyper-parameters of GPy. 
% 
% GPy is a structure with fields { 'sigmaF', 'sigmaL', 'sigmaN' }.
% 
% Field 'sigmaF' standard deviation of underlying model dynamics f across
% X.
% 
% Field 'sigmaL' is a vector of latent length scales for all the input
% dimensions.
% 
% Field 'sigmaN' is standard deviation of a Gaussian noise signal. 
% 
% X is a vector of input locations with size n*p wherein n represents
% number of locations and p represents number of dimensions. 
%
% Y is a vector of data points with size n*1.
%
%scale parameter value represents scaling factor for the parameters of GPy.

stdY = std(Y);

if ~isfield( covStr, 'NGP' ) || ~strcmp( covStr.NGP, 'GPPM' )
    GPy.sigmaF = stdY*scale;
end

if ~isfield( covStr, 'NGP' ) || ( ~strcmp( covStr.NGP, 'PCLSK' ) && ~strcmp( covStr.NGP, 'BWGP' ) )
    
    rng = coordsRng( X );
    
    GPy.sigmaL = rng*scale;
    
    if isfield( covStr, 'NGP' ) && strcmp( covStr.NGP, 'LEIS' )
        GPy.sigmaL(end+1) = 1*scale;
    end
    
elseif strcmp( covStr.NGP, 'BWGP' )
    GPy.sigmaL = 1*scale;
end

if ( isfield( covStr, 'NGP' ) && ~strcmp( covStr.NGP, 'HGP' ) || ~isfield( covStr, 'NGP' ) )
    GPy.sigmaN = stdY/10*scale;
end

end

function GPz = initGPzCov( covStr, X, Y, scale )
% Initializes hyperparameteres set for each of the latent GP. GPz is a cell
% vector with each cell representing one latent GP. Each cell GPz{:} is a
% structure with fields { 'sigmaF', 'sigmaL', 'sigmaN' }. 
% 
% Field 'sigmaF' represents standard deviation of underlying model dynamics 
% for the latent dynamics. 
% 
% Field 'sigmaL' is a latent length scales vector.
% 
% Field 'sigmaN' represents Gaussian signal noise standard deviation for 
% latent dynamics. 
% 
% X is a vector of input locations with size n*p wherein n represents
% number of locations and p represents number of dimensions. 
%
% Y is a vector of data points with size n*1.
%
% scale parameter value represents scaling factor for the parameters of GPz.
%

if ~isfield( covStr, 'NGP' )
    error('function is relevant for N-GPs only.')
end

rng = coordsRng( X );

%latent GPs corresponds to the dimensions for PCLSK amd SDIS
if strcmp( covStr.NGP, 'PCLSK' ) || strcmp( covStr.NGP, 'SDIS' )
    
    p = size( X, 2 );
    
    GPz = cell( p, 1 );
    
    for currLtGPIdx = 1:p
        if strcmp( covStr.NGP, 'PCLSK' )
            GPz{currLtGPIdx}.sigmaF = rng(currLtGPIdx)*10*scale;
        elseif strcmp( covStr.NGP, 'SDIS' )
            GPz{currLtGPIdx}.sigmaF = rng(currLtGPIdx)*scale;
        end
        
        GPz{currLtGPIdx}.sigmaN = GPz{currLtGPIdx}.sigmaF/10;
        
        GPz{currLtGPIdx}.sigmaL = rng*10*scale;
    end
else
    if strcmp( covStr.NGP, 'HGP' )
        stdY = std(Y);
        sigmaF = stdY;
    else
        sigmaF = 1;
    end
    
    GPz{1}.sigmaF = sigmaF*scale;
    
    GPz{1}.sigmaN = sigmaF/10*scale;

    GPz{1}.sigmaL = rng*10*scale;
end

end

function GPs = initGPsCov( X, Y, scale )
%Initializes hyper-parameters of GPs. GPs is a structure with fields {
%'sigmaF', 'sigmaL', 'sigmaN' }.
% 
% 
% X is a vector of input locations with size n*p wherein n represents
% number of locations and p represents number of dimensions. 
%
% Y is a vector of data points with size n*1.
%
%scale parameter value represents scaling factor for the parameters of GPs.

stdY = std(Y);

GPs.sigmaF = stdY*scale;
GPs.sigmaN = stdY/10*scale;

rng = coordsRng( X );

GPs.sigmaL = rng*scale;

end

function rng = coordsRng( X )
%Obtains range of coordinates for each dimension of X. rng is a column
%vector.

p = size( X, 2 );

rng = zeros( p, 1 );

for currDimIdx = 1:p
    rng(currDimIdx, 1) = abs( max(X(:, currDimIdx)) - min(X(:, currDimIdx )) );
end

end
