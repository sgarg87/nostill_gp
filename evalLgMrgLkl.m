function lml = evalLgMrgLkl( Xv, Yv, covStr, GP )
% function: lml = evalLgMrgLkl( Xv, Yv, covStr, GP )
% 
% Evaluates log marginal likelihood of observed real dynamics Yv across Xv 
% for a given GP with covariance structure covStr.
% 
% covStr is a structure with fields { 'NGP', 'kFun' }.
% 
% GP is a structure with fields { 'GPy', 'GPz', 'Xm', 'Zm' } for an NGP 
% covariance structure, and with the only field 'GPy' for a stationary GP. 
% 
% Fields 'GPz', 'Xm', 'Zm' are cell vectors with each cell corresponding to
% each of latent GPs for an NGP.
% 
% Also see documentation on ngp, covStr, lisal. For more details on
% equations for log marginal likelihood expressions, see the corresponding
% mathematical formulations in the journal draft.

Ky = evalCov(  Xv, Xv, covStr, GP );

if det(Ky) < 1e-10 %determinant zero is not favoured since it leads to high likelihood value becuase of unstability. This additional step of unfavoring zero determinant matrices would lead to local optima issue with gradient optimization but supposed to work with MCMC sampling
    lml = -inf;
    return;
else
    lml = -0.5*(Yv'/Ky)*Yv -evalLogDetExpr(Ky);
end

% clear Ky n Yv;

% if lml > 0 %lml can positive in case K is not stable i.e. determinant of K is zero
%     error('lml should not be positive if determinant of K is not zero');
% else
if lml == -inf
    lml = -1e308;
end

if isfield( covStr, 'NGP' )
    %evaluate  determinant of predicitive covariance across input locations
    %as per latent GP parameteriation
   for currLtGPIdx = length( GP.GPz );
        currGP.GPy = GP.GPz{currLtGPIdx};
        currKzXzz = evalCov( GP.Xm{currLtGPIdx}, GP.Xm{currLtGPIdx}, rmfield( covStr, 'NGP' ), currGP );
        currKzXvv = evalCov( Xv, Xv, rmfield( covStr, 'NGP' ), currGP );
        currKzXvz = evalCov( Xv, GP.Xm{currLtGPIdx}, rmfield( covStr, 'NGP' ), currGP );
        currSigmaz = currKzXvv - currKzXvz*(currKzXzz\currKzXvz');
        clear currGP currKzXzz currKzXvv currKzXvz;
        
        lml = lml - evalLogDetExpr(currSigmaz);
        clear currSigmaz;
   end
end

% if lml > 0 %lml can positive in case K is not stable i.e. determinant of K is zero
%     error('lml should not be positive');
% else
if lml == -inf
    lml = -1e308;
end

end

function lndetexp = evalLogDetExpr(K)

    n = length(K);

    detK = det(K);
    
    clear K;

    %For some parameterizations, matrix's determinant becomes zero. In such case, we approximate log of determinant.
    if ( detK <= 0 )
        detK = 1e-320; 
    elseif detK == inf
        detK = 1e308;
    end
    
    lndetexp = log( ((2*pi)^(n/2))*detK );
    
    if lndetexp == inf
        lndetexp = 1e308;
    end
end
