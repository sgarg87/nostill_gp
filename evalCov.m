function K = evalCov(  X1, X2, covStr, GP )
% 
% K = evalCov(  X1, X2, covStr, GP )
% 
% Evaluates covariance between two input locations column vectors X1, X2 
% using GP with covariance structure specification covStr. 
% 
% covStr is a structure with fields { 'NGP', 'kFun' }.
% 
% GP is a structure of hyperparameters with fields { 'GPy', 'GPz', 'Xm', 'Zm' } for an NGP 
% covariance structure, and with the single field 'GPy' for a stationary GP. 
% 
% Fields 'GPz', 'Xm', 'Zm' are cell vectors with each cell corresponding to
% each of latent GPs for an NGP.
% 
% Also see documentation on ngp, covStr, lisal, kfun. For more details on
% covariance evaluation for different NGPs, see the mathematical
% formulations in the corresponding journal draft. 
% 
isX1EqlX2 = isequal( X1, X2 );

if ~isfield( covStr, 'NGP' )
        K = evalSCov( X1, X2, covStr, GP.GPy );
else    
    if ~( ~isX1EqlX2 && strcmp( covStr.NGP, 'HGP' ) )
        Z1 = infLtPrdMean( X1, GP.Xm, GP.Zm, rmfield( covStr, 'NGP'), GP.GPz );
        
        if isequal( X1, X2 )
            Z2 = Z1;
        else
            Z2 = infLtPrdMean( X2, GP.Xm, GP.Zm, rmfield( covStr, 'NGP'), GP.GPz );
        end
    end
    
    GP = rmfield( GP, { 'GPz', 'Xm', 'Zm' } );
    
    switch covStr.NGP
        case 'HGP'
            if isequal( X1, X2 ) %HGP is applicable only for covariance on same set of locations K(X, X) and not for K(X1, X2)
                K = evalHGPCov( X1, Z1, covStr, GP.GPy );
            else
                K = evalSCov( X1, X2, rmfield( covStr, 'NGP' ), GP.GPy ); %HGP is stationary covariance for this case
            end
        case 'GPPM'
            K = evalGPPMCov( X1, X2, Z1, Z2, covStr, GP.GPy );
        case 'BWGP'
            K = evalBWGPCov( Z1, Z2, covStr, GP.GPy );
        case 'LEIS'
            K = evalLEISCov( X1, X2, Z1, Z2, covStr, GP.GPy );
        case 'SDIS'
            K = evalSDISCov( Z1, Z2, covStr, GP.GPy );
        case 'PCLSK'
            K = evalPCLSKCov( X1, X2, Z1, Z2, covStr, GP.GPy );
        otherwise
            error( 'Invalid NGP' );
    end
end

if isfield( GP.GPy, 'sigmaN' ) && isX1EqlX2 && ( ~isfield( covStr, 'NGP' ) || ~strcmp( covStr.NGP, 'HGP' ) )
    K = evalCovY( K, GP.GPy.sigmaN );
end

end

function K = evalSCov ( X1, X2, covStr, GPy )
% Evaluates stationary covariance using a global parameterization GPy to a 
% stationary covariance
% 
% covStr is a structure with field 'kFun'. See documentation on kFun.
% 
% GPy is a structure with fields { 'sigmaF', 'sigmaL' } where the field
% sigmaF represents standard deviation for underlying model dynamics fv
% across Xv, and sigmaL represents a vector of latent length scales for all
% the input dimensions. 
% 
% output: K is the evaluated covariance matrix.
% 
p = size(X1, 2); %dimenions for X1 and X2 match

Q = cell( p, 1 );%scaled squared distance

for currDimIdx = 1:p;
    Q{currDimIdx} = evalSqrdDist( X1(:, currDimIdx), X2(:, currDimIdx) )/(GPy.sigmaL(currDimIdx)^2);
end

K = feval( covStr.kFun, GPy.sigmaF.^2, Q );

end

function Ky = evalCovY ( Kf, sigmaN )
% Evaluates covariance Ky on real observed dynamics by adding Gaussian noise
% with sigmaN representing standard deviation of Gaussian signal noise to 
% covariance on underlying model dynamics represented as Kf.

if ~(size(Kf, 1) == size(Kf, 2))
    error('matrix is not a square');
end

n = length(Kf);

Ky = Kf + sigmaN.^2*eye( n );%add noise

end

function Zv = infLtPrdMean( Xv, Xm, Zm, covStr, GPz ) %Xm, Zm, GPz are cell vectors
%infer latent parameters predictive mean values for input locations Xv by
%conditioning upon latent parameter values Zm across Xm using latent GP GPz
%as per given covariance structure covStr.

numGPz = length(GPz);

Zv = cell( numGPz, 1 );

for currLtGPIdx = 1:numGPz;
    
    currGP.GPy = GPz{currLtGPIdx};    
    Kmm = evalCov( Xm{currLtGPIdx}, Xm{currLtGPIdx}, covStr, currGP );
    
    Kvm = evalCov( Xv, Xm{currLtGPIdx}, covStr, currGP );
    Zv{currLtGPIdx} = Kvm*(Kmm\Zm{currLtGPIdx});
    clear currGP Kmm Kvm;
    
end
    
end

function K = evalHGPCov( Xv, Zv, covStr, GPy )
%evaluate covariance for Heteroscedastic Gaussian Process. 
%This function evaluates stationary covariance and then adds the varying
%signal noise variance along the diagonal of stationary covariance. 
K = evalSCov( Xv, Xv, covStr, GPy );
K = K + diag( Zv{:}.^2 ); % size of cell vector Zv is 1 for an HGP
end

function K = evalGPPMCov( X1, X2, Z1, Z2, covStr, GPy )
%evaluate covariance as per Gaussian Process Product Model. 
%This function evaluates stationary covariance with global sigmaF value 1.
%Then, the stationary covariance is scaled as per varying signal variance values. 
Ks = evalSCov( X1, X2, rmfield( covStr, 'NGP'), setfield( GPy, 'sigmaF', 1) );
K = diag(Z1{:}.^2)*Ks*diag(Z2{:}.^2); % size of cell vectors Z1, Z2 are 1 for an GPPM
end

function K = evalBWGPCov( Z1, Z2, covStr, GPy )
%evaluate covariance as per Bayesian Warped Gaussian Process Model
%This function evaluates stationary covariance between the latent
%parameter value sets {Z1, Z2} corresponding to the input location sets { X1, X2}.
K = evalSCov( Z1{:}, Z2{:}, rmfield( covStr, 'NGP'), GPy );
end

function K = evalLEISCov( X1, X2, Z1, Z2, covStr, GPy )
%Evaluate covariance as per the Latent Extension of Input Space Gaussian
%Process nonstationary model.
%This function evaluates stationary covariance between the set of input
%locations [ X1 Z1 ] and [ X2 Z2]. Herein the [X1 Z1] represents latent
%extension of input space.
K = evalSCov( [ X1(:, 1:end-1) Z1{:} X1(:, end) ], [ X2(:, 1:end-1) Z2{:} X2(:, end) ], rmfield( covStr, 'NGP'), GPy ); %the latent space is added to spatial space and then the temporal space is added at end

end

function K = evalSDISCov( Z1, Z2, covStr, GPy )
%evaluate covariance as per the Spatial Deformation of Input Space Model.
if ~( length(Z1) == length(Z2) )
    error( 'size of cell vectors Z1 and Z2 do not match' );
end

z1 = [];
z2 = [];

for currLtGPIdx = 1: length(Z1);
    z1 = [ z1 Z1{currLtGPIdx} ];
    z2 = [ z2 Z2{currLtGPIdx} ];
end

K = evalSCov( z1, z2, rmfield( covStr, 'NGP'), GPy );

end

function K = evalPCLSKCov( X1, X2, Z1, Z2, covStr, GPy )
%evaluate covariance as per Process Convolution Local Smoothing Kernels
%Model
if ~( length(Z1) == length(Z2) )
    error( 'size of cell vectors Z1 and Z2 do not match' );
end

n1 = size(X1, 1);
n2 = size(X2, 1);

p = size( X1, 2 ); %dimensions of input space

Pr = cell( p, 1 );
Pc = cell( p, 1 );
Ps = cell( p, 1 );

Q = cell( p, 1 );

pc = ones( n1, n2 );
pr = ones( n1, n2 );
ps = ones( n1, n2 );

for currDimIdx = 1:p;
    
    Pc{currDimIdx} = repmat( Z1{currDimIdx}.^2, 1, n2 );
    Pr{currDimIdx} = repmat(Z2{currDimIdx}.^2', n1, 1);
    Ps{currDimIdx} = Pc{currDimIdx} + Pr{currDimIdx};
    
    pc = pc.*Pc{currDimIdx};
    pr = pr.*Pr{currDimIdx};
    ps = ps.*Ps{currDimIdx};
    
    Q{currDimIdx} = evalSqrdDist( X1(:, currDimIdx), X2(:, currDimIdx) )./(Ps{currDimIdx}/2);
    
end

clear Pc Pr Ps Z1 Z2 X1 X2;

K = sqrt( sqrt(pr.*pc) ./ (ps/(2^p)) ).* feval( covStr.kFun, GPy.sigmaF.^2, Q );

end

function S = evalSqrdDist( x1, x2 ) %x1, x2 are column vectors
%This function should be used locally and not as a general global function for evaluation of squared distance because the evaluation by extending
%x1 column wise and x2' by column wise is specifically in relevance to
%variable length scale matrices computed for PCLSK

n1 = length( x1 );
n2 = length( x2 );

S = ( ( repmat( x1, 1, n2 ) - repmat( x2', n1, 1 ) ).^2 ); %squared distance vector

end

function K = sqrdExp( sigmaV, Q )
%evaluate equared exponential covariance
%sigmaV is signal variance (square of sigmaF)
%Q is a cell vector with each cell for scaled distance along the corresponding dimension

Qs = sumScaledSqrdDist( Q );

K = sigmaV*exp( -0.5*Qs );

end

function K = stEx1Cressie( sigmaV, Q )
%Spatio-Temporal Covariance in Example 1 in [Cressie, Huang; Classes of 
% Nonseparable Spatio-Temporal Stationary Covariance Functions; 1998 ]
%The last dimenions is considered to be for the temporal domain sigmaV is 
% signal variance (square of sigmaF). Q is a cell vector with each cell for
% scaled distance along the corresponding dimension

p = length(Q) - 1; % one dimension for time domain and p dimensions for spatial domain

if p < 1
    error( 'input space is not spatio temporal' );
end

Qs = sumScaledSqrdDist( Q(1:p, 1) );

Qt = Q{end, 1};

K = sigmaV.* exp( - Qs./(Qt + 1) ) ./ ( (Qt + 1).^p/2 );

end

function K = stEx3Cressie( sigmaV, Q )
% Spatio-Temporal Covariance in Example 3 in [Cressie, Huang; Classes of 
% Nonseparable Spatio-Temporal Stationary Covariance Functions; 1998 ].
% The last dimension is considered to be for the temporal domain sigmaV is 
% signal variance (square of sigmaF). Q is a cell vector with each cell for
% scaled distance along the corresponding dimension

p = length(Q) - 1; % one dimension for time domain and p dimensions for spatial domain

if p < 1
    error( 'input space is not spatio temporal' );
end

Qs = sumScaledSqrdDist( Q(1:p, 1) );

Qt = Q{end, 1};

K = sigmaV.*( 1 + Qt ) ./ ( ( ( 2 + Qt ).^2 + Qs ).^((p+1)/2) );

end

function Qs = sumScaledSqrdDist( Q )
%Q is a cell vector where each cell is a scaled squared distance matrix
%Qs is sum of scaled squared distance matrices for all of the dimensions

Qs = zeros( size( Q( 1 ) ) );

for currDimIdx = 1: length(Qs);
    
    Qs = Qs + Q{currDimIdx};
    
end

end

%compact Support concept based Sparse Spatial Covariance function proposed
%in [Melkumyan, Ramos; A Sparse Covariance Function for Exact Gaussian Process Inference in Large Datasets; 2009]
%sigmaV is signal variance (square of sigmaF)
%Q is a cell vector with each cell for scaled distance along the corresponding dimension
% function K = sparseSineCos( sigmaV, Q )
%     
%     R = sqrt( sumScaledSqrdDist( Q )  ) ;
%     clear Q;
%     
%     Rexpr = 2*pi*R;
%     
%     K = sigmaV*( ( (2 + cos( Rexpr) )/3).*( 1 - R ) + (1/2*pi)*sin(Rexpr) );
%     clear Rexpr;
%     
%     K( R >= 1) = 0;
% end
