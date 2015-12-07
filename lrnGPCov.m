function  lrn =  lrnGPCov( Xv, Yv, covStr, init, options )
%
% function:  lrn =  lrnGPCov( Xv, Yv, covStr, init, options )
%
% Learn a GP model on data { Xv, Yv }. An NGP is learned using algorithm
% LISAL that maximizes marginal likelihood of the observed dynamics and
% information gain on latent dynamics. See documentation on lisal for more
% details. 
% 
% covStr: is a structure with fields { 'NGP', 'kFun' }
%
% init: is a structure with fields: { 'GPy', 'GPz', 'GPs' }. GPz is a cell
% vector with each cell representing hyper-parameters of a latent GP.
% 
% options.lisal: is a structure with fields related to the algorithm LISAL : 
% { 'm1', 'm2', 'c', 'infCriterion' }. See documentation for lisalOptions. 
%
% output: lrn is a structure with fields { 'GPy', 'GPz', 'GPs', 'Xm', 'Zm',
% 'inf', 'infTm', 'lml', 'lmlInf' }. 
%
% field 'Xm' is a cell vector with each cell as a column vector of latent
% locations for the corresponding latent GP.
%
% field 'Zm' is a cell vector with each cell as a column vector of latent
% parameterizatios learned across the latent locations. 
%
% field 'inf' is a cell vector with each cell representing information gained 
% so far on latent dynamics. For case of multiple latent GPs, each cell 
% can itself be a cell vector. field infTm is of same structure as field
% inf is, and represents the execution time taken for maximization of 
% information on latent dynamiics.
%
% field 'lml' is a cell vector with each cell value representing log
% marginal likelihood of observed real dynamics for an adaptive iteration
% of algorithm LISAL. 'lmlTm' is a field with same structure as for the 
% field 'lml' that represents execution time for maximization of log
% marginal likelihood.
%
% lrn: is a structure with fields: { 'GPy', 'GPz', 'GPs', 'Xm', 'Zm', 'lml', 'inf', 'history' }. Field 'GPz' is a cell
% vector with each cell representing hyper-parameters of a latent GP.\;
% field 'Xm' represents informatively selected latent locations by
% algorithm LISAL, and field 'Zm' represents the learned latent parameter
% values across the correspodning latent locations. Both Xm and Zm are cell
% vectors with each cell representing latent dynamics for a latent GP.
% Field 'lml' represents log marginal likelihood for learned parameter
% values; field 'inf' represents information gained (entropy or mutual information) while selecting latent locations. 
% 'history' represents the parameter values learned during multiple iterations of the LISAL algorithm. 
%
% Also see documentation on lisal, ngp, kfun, covStr, lisalOptions

if ~isfield( covStr, 'NGP' )
    [ lrn.lml, lrn.lmlTm, lrn.GPy ] = maxLgMrgLkl( Xv, Yv, covStr, init.GPy, options.optimization );%learn a stationary GP covariance
else
    lrn =  lrnNGP( Xv, Yv, covStr, init, options.lisal, options.optimization );%learn covariance of a nonstationary GP.
end

end

function lrn = lrnNGP( Xv, Yv, covStr, init, lisalOptions, optimization )
% Learns an NGP model with algorithm LISAL.

    lrn.GPs = lrnGPs( Xv, Yv, covStr, init.GPs, optimization ); %learn parameters of GPs
    
    GP.GPy = lrn.GPs;
    [ lrn.inf{1}, lrn.infTm{1}, Xm1, ~ ] = lrnXm( Xv, [], rmfield(covStr, 'NGP'), GP, lisalOptions.infCriterion, lisalOptions.m1 );%learn latent locations
    clear GP;
    
    for currLtGPIdx = 1:length(init.GPz);
        lrn.Xm{currLtGPIdx} = Xm1;
    end
    
    [ lrn.lml{1}, lrn.lmlTm{1}, lrn.GPy, lrn.GPz, lrn.Zm ] = maxLgMrgLklNGP( Xv, Yv, covStr, init.GPy, init.GPz, [], [], lrn.Xm, optimization ); %maximize log marginal likelihood for learning hyperparameters of GPy, GPz and the latent parameters Zm across Xm.
    clear Xm1;
    
    lrn.history.GPy{1} = lrn.GPy;
    lrn.history.GPz{1} = lrn.GPz;
    
    if ~( length(lrn.Xm) == length(lrn.Zm) )
        error( 'number of vectors for Xm and Zm mismatch' );
    end
    
    for currAdptLrnIter = 1:lisalOptions.c;
        
        for currLtGPIdx = 1:length( lrn.GPz );
            GP.GPy = lrn.GPz{currLtGPIdx};
            [ lrn.inf{currAdptLrnIter+1}{currLtGPIdx}, lrn.infTm{currAdptLrnIter+1}{currLtGPIdx}, Xm{currLtGPIdx}, ~ ] = lrnXm( Xv, lrn.Xm{currLtGPIdx}, rmfield(covStr, 'NGP'), GP, lisalOptions.infCriterion, lisalOptions.m2 );%learn latent locations using the each of the learned latent GPs for exploring dynamics in each of the latent spaces
            clear GP;
        end
        clear currLtGPIdx;
        
        [ lrn.lml{currAdptLrnIter+1}, lrn.lmlTm{currAdptLrnIter+1}, lrn.GPy, lrn.GPz, Zm ] = maxLgMrgLklNGP( Xv, Yv, covStr, lrn.GPy, lrn.GPz, lrn.Xm, lrn.Zm, Xm, optimization );%maximize log marginal likelihood to adapt hyper-parameters of GPy, GPz and to learn latent parameters on new selected latent locations
        
        lrn.history.GPy{currAdptLrnIter+1} = lrn.GPy;
        lrn.history.GPz{currAdptLrnIter+1} = lrn.GPz;
        
        if ~( length(Xm) == length(Zm) )
            error( 'number of vectors for Xm and Zm mismatch' );
        end
        
        [ lrn.Xm, lrn.Zm ] = updateLclLtPar( lrn.Xm, lrn.Zm, Xm, Zm );
        
        clear Xm;
        clear Zm;
    end
    
    clear currAdptLrnIter;

end

function GPs = lrnGPs( Xv, Yv, covStr, GPs, optimization )
% Learns 'GPs' that is a stationary GP model used for learning a 
% preliminary set of latent locations under LISAL.

init.GPy = GPs;
options.optimization = optimization;

GPs = getfield( lrnGPCov ( Xv, Yv, rmfield( covStr, 'NGP' ), init, options ), 'GPy' );

end

function [ inf, infTm, Xm, idxXm ] = lrnXm( Xv, XmPrv, covStr, GP, infCriterion, m )
% Learns a new set of latent locations Xm as a subset of Xv by maximizing 
% information gain on previous latent locations XmPrv and new latent 
% locations Xm.
%
% covStr represents covariance stationary structure with field 'kFun'.
%
% GP is a structure with field GPy that is a global parameterization to a 
% stationary covariance function.
% 
% infCriterion represents a criterion for information gain with possible
% valid choices { 'E', 'MI' }. E represents entropy and MI represents
% mutual information gain. See [Krause et al. JMLR 2008] for greedy maximization of entropy and mutual information.

if ( strcmp( infCriterion, 'E' ) == 1)
    [ inf, infTm, Xm, idxXm ] = maxCndEntropy( Xv, XmPrv, m, covStr, GP );
% elseif ( strcmp( infCriterion, 'MI' ) == 1 )
%     [ inf, infTm, Xm, idxXm ] = maxMutualInf( Xv, XmPrv, Xv, m, covStr, GP );
else
    error ('Invalid information criterion.');
end

end

function loglkl = sampleProxyEvalLgMrgLkl(par)
    global glbXv
    global glbYv;
    global glbcovStr;
    global glbzipInf;
    
    loglkl = -proxyEvalNgLgMrgLkl( glbXv, glbYv, glbcovStr, par', glbzipInf );
    
    if loglkl == -inf
        loglkl = -1e308;
    end
end

function loglkl = sampleProxyEvalLgMrgLklNGP(par)
    global glbXv
    global glbYv;
    global glbcovStr;
    global glbzipInfPar;
    global glbXmPrv;
    global glbZmPrv;
    global glbXm;
    
    loglkl = -proxyEvalNgLgMrgLklNGP( glbXv, glbYv, glbcovStr, par', glbzipInfPar, glbXmPrv, glbZmPrv, glbXm );
    
    if loglkl == -inf
        loglkl = -1e308;
    end
    
end

function [ lml, lmlTm, GPy ] = maxLgMrgLkl( Xv, Yv, covStr, GPy, optimization )
% Maximizes log marginal likelihood (lml) of real observed dynamics Yv across Xv for
% a stationary parameterization GPy with a stationary covariance structure.  

srtTm = cputime;

[ par, zipInf ] = zipGPy( GPy );

if strcmp( optimization, 'MCMC' )    
    global glbXv
    global glbYv;
    global glbcovStr;
    global glbzipInf;
    glbXv = Xv;
    glbYv = Yv;
    glbcovStr = covStr;
    glbzipInf = zipInf;
    
    nums = length(par)^4; %number of samples
    
    parSamples = mhsample( par', nums, 'logpdf', @sampleProxyEvalLgMrgLkl, 'proprnd', @(x) abs(mvnrnd(x, abs(diag(par)), 1 )), 'symmetric', 1 );
        
%     parSamples = slicesample( par', nums, 'logpdf', @sampleProxyEvalLgMrgLkl );
    
    for currSampleIdx = 1:size( parSamples, 1 );
         loglkls(currSampleIdx) = sampleProxyEvalLgMrgLkl( parSamples(currSampleIdx,:) );
    end
    
    [ lml, parIdx ] = max(loglkls);
    
    par = parSamples( parIdx(1), : )';
    
    clear glbXv glbYv glbcovStr glbzipInf;    
else
    [ par, nlml ] = ktrlink( @(par) proxyEvalNgLgMrgLkl( Xv, Yv, covStr, par, zipInf ), par, [], [] );
    lml = -nlml;
end

GPy = extractGPy( par, zipInf );

lmlTm = cputime - srtTm;

end

function [ lml, lmlTm, GPy, GPz, Zm ] = maxLgMrgLklNGP( Xv, Yv, covStr, GPy, GPz, XmPrv, ZmPrv, Xm, optimization )
% Maximizes marginal likelihood (lml) of real observed dynamics Yv across Xv for
% a global parametrization GPy on real dynamics, a global parameterization
% GPz on latent dynamics and learned local latent dynamics parameterization ZmPrv 
% across latent locations ZmPrv. Local latent dynamics parameterization Zm across
% new latent locations Xm is learned by maximization of lml in addition to
% adaptive learning of GPy, GPz.

srtTm = cputime;

isEmptyXm = isempty(Xm);

if ~isEmptyXm
    Zm = initZm( GPz, Xm );
else
    Zm = [];
end

[ par, zipInfPar ] = zipPar( GPy, GPz, Zm );

if strcmp( optimization, 'MCMC' )
    
    global glbXv
    global glbYv;
    global glbcovStr;
    global glbzipInfPar;
    global glbXmPrv;
    global glbZmPrv;
    global glbXm;
    
    glbXv = Xv;
    glbYv = Yv;
    glbcovStr = covStr;
    glbzipInfPar = zipInfPar;
    glbXmPrv = XmPrv;
    glbZmPrv = ZmPrv;
    glbXm = Xm;
    
    nums = length(par)^4; %number of samples
    
    parSamples = mhsample( par', nums, 'logpdf', @sampleProxyEvalLgMrgLklNGP, 'proprnd', @(x) abs(mvnrnd(x, abs(diag(par)), 1 )), 'symmetric', 1 );

%     parSamples = slicesample( par', nums, 'logpdf', @sampleProxyEvalLgMrgLklNGP );
    
    for currSampleIdx = 1:size( parSamples, 1 );
         loglkls(currSampleIdx) = sampleProxyEvalLgMrgLklNGP( parSamples(currSampleIdx,:) );
    end
    
    [ lml, parIdx ] = max(loglkls);
    
    par = parSamples( parIdx(1), : )';
    
    clear glbXv glbYv glbcovStr glbzipInfPar glbXmPrv glbZmPrv glbXm;    
else
    [ par, nlml ] = ktrlink( @(par) proxyEvalNgLgMrgLklNGP( Xv, Yv, covStr, par, zipInfPar, XmPrv, ZmPrv, Xm ), par, [], [] );
    lml = -nlml;
end

[ GPy, GPz, Zm ] = extractPar( par, zipInfPar );

lmlTm = cputime - srtTm;

end

function nlml = proxyEvalNgLgMrgLkl( Xv, Yv, covStr, par, zipInf )
%This function is a proxy to the function evalLgMrgLkl() that evaluates log
%marginal likelihood for an stationary GP model. This proxy function extracts parameters of GPy from a vecctor of parameters and then passes the
%parameters to the actual function for evaluation of log marginal
%likelihood.

GP.GPy = extractGPy( par, zipInf );

lml = evalLgMrgLkl( Xv, Yv, covStr, GP );

nlml = -lml;

end

function nlml = proxyEvalNgLgMrgLklNGP( Xv, Yv, covStr, par, zipInfPar, XmPrv, ZmPrv, Xm )
%This function is a proxy to the function evalLgMrgLkl() that evaluates log marginal likelihood for an NGP model. 
%This proxy function extracts parameters of GPy from a vecctor of parameters and then passes the
%parameters to the actual function for evaluation of log marginal
%likelihood. 

[ GP.GPy, GP.GPz, Zm ] = extractPar( par, zipInfPar );

isEmptyXm = isempty(Xm);

if ~isEmptyXm
    if ~( length(Xm) == length(Zm) )
        error( 'number of vectors for Xm and the extracted Zm do not match' );
    end

    if ~( isempty(XmPrv) ) %both XmPrv and ZmPrv should be empty
        [ GP.Xm, GP.Zm ] = updateLclLtPar( XmPrv, ZmPrv, Xm, Zm );
    else
        GP.Xm = Xm;
        GP.Zm = Zm;        
    end
else
    GP.Xm = XmPrv;
    GP.Zm = ZmPrv;            
end

clear XmPrv ZmPrv;

lml = evalLgMrgLkl( Xv, Yv, covStr, GP );

nlml = -lml;

end


function Zm = initZm( GPz, Xm )
% Initializes local latent parameterization Zm for latent locations Xm based upon
% global parameterization GPz.

numGPz = length(GPz);

Zm = cell( numGPz, 1);

for currLtGPIdx = 1:numGPz;
    Zm{currLtGPIdx} = GPz{currLtGPIdx}.sigmaF*ones( size( Xm{currLtGPIdx}, 1 ), 1);
end

end

function [ Xm, Zm ] = updateLclLtPar( Xm, Zm, XmNw, ZmNw )
%Add new latent locations and the corresponding latent parameter values

for currLtGPIdx = 1:length( XmNw ); %each Xm{:} vector corresponds to each GPz{:}
    
    if ~( size( XmNw{currLtGPIdx}, 1 ) == size( ZmNw{currLtGPIdx}, 1 ) )
        error('Number of latent locations and latent parameters mismatch');
    end
    
    Xm{currLtGPIdx} = [ Xm{currLtGPIdx}; XmNw{currLtGPIdx} ];
    Zm{currLtGPIdx} = [ Zm{currLtGPIdx}; ZmNw{currLtGPIdx} ];
    
end

end

