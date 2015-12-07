function [ maxE, excTm, Xi, idxXi ] = maxCndEntropy( Xv, Xa, m, covStr, GP )
% 
% function: [ maxE, excTm, Xi, idxXi ] = maxEntropy( Xv, Xa, m, covStr,
% GP )
% 
% Learns a column vector of m informative locations Xi as a subset of Xv 
% such that entropy H( {Xa U Xi} ) is maximized greedily where Xa is 
% already observed locations set.
% 
% Entropy is evaluated using model GP with given covariance structure
% (covStr).
% 
% covStr is a structure with fields { 'NGP', 'kFun' }
% 
% GP is a structure with fields { 'GPy', 'GPz', 'Xm', 'Zm' } for an NGP and
% field 'GPy' only for a stationary representation.
% 
% output maxE is maximized entropy value for learning Xi.
% 
% output excTm is execution time for maximizing entropy to learn
% informative locations
% 
% idxXi is index of informative locations Xi that are selected from Xv.
% 
% References: [ Krause et al., JMLR, 2008, Near-Optimal Sensor Placements in Gaussian Processes- Theory, Efficient Algorithms and Empirical Studies ]
% 

srtTm = cputime;

Kvv = evalCov( Xv, Xv, covStr, GP );

if ~isempty( Xa )
    Kva = evalCov( Xv, Xa, covStr, GP );
    Kaa = evalCov( Xa, Xa, covStr, GP );
end

n_v = size( Xv, 1 );

idxXi = [];

for i = 1:m;

    e = -inf*zeros( n_v, 1 );
    
    for j = 1:setdiff(n_v, idxXi);

        Kcc = Kvv( j, j ); %choice of locations
        
        if ~isempty( Xa )
            Kii = [ Kaa Kva( idxXi, :)'; Kva( idxXi, : ) Kvv( idxXi, idxXi) ]; %informative locations including Xa
        else
            Kii = Kvv( idxXi, idxXi); %informative locations including Xa
        end
        
        if ~isempty( Xa )
            Kci = [ Kva( j, : ) Kvv( j, idxXi ) ]; %covariance between informative locations and choice location
        else
            Kci = Kvv( j, idxXi ); %covariance between informative locations and choice location
        end
        
        cndKExp = Kci*(Kii\Kci');
        
        if ~isempty(cndKExp)
            e(j) = 0.5*log( 2*pi*exp(1)*(Kcc - cndKExp ) );        
        else
            e(j) = 0.5*log( 2*pi*exp(1)*Kcc);
        end
    end
    
    [ ~, maxEIdx ] = max(e);

    idxXi(i) = maxEIdx;

end

Xi = Xv( idxXi, :);

maxE = evalE( evalCov( Xi, Xi, covStr, GP ) );

excTm = cputime - srtTm;

end
