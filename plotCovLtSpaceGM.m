clear global;
clear;

load juraCuHGPSqrdExpm1_6m2_6_c9E;
Zm = juraCuHGPSqrdExpm1_6m2_6_c9E.lrn{5}.Zm{1};
Xm = juraCuHGPSqrdExpm1_6m2_6_c9E.lrn{5}.Xm{1};
X = juraCuHGPSqrdExpm1_6m2_6_c9E.X;

XZm = [ Xm Zm ];

m = size( Xm, 1 );

n = size(X, 1);

gmxz = gmdistribution.fit( XZm, ceil(log(m)), 'Regularize', 0.1 );

gmz = gmdistribution.fit( Zm, ceil(log(m)), 'Regularize', 0.1 );

nump = 100;

zsamples = gmz.random(nump);

for currLocIdx = 1:n
    x = X(currLocIdx,:);
    for currSampleIdx=1:nump
        w(currSampleIdx, 1) = gmxz.pdf( [ x zsamples(currSampleIdx) ] );
    end
    wbar = w/sum(w); clear w;
    
    [ resampledz, ~ ] = resampleParticles( zsamples, wbar );
    currgmz = gmdistribution.fit(resampledz, ceil(log(nump)), 'Regularize', 0.1 );
    Z(:, currLocIdx) = currgmz.random(nump);
end

Kz = cov(Z);

