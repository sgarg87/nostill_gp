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

nump = 10;

zsamples = gmz.random(nump);

for currLocIdx = 1:n
    x = X(currLocIdx,:);
    for currSampleIdx=1:nump
        w(currSampleIdx, 1) = gmxz.pdf( [ x zsamples(currSampleIdx) ] );
    end
    wbar = w/sum(w); clear w;
    zmean = sum(wbar.*zsamples);
    Z(currLocIdx,1) = zmean;
end

subplot(211);
interpolateSurface( Xm, Zm, 2 );

subplot(212);
interpolateSurface( X, Z, 2 );

hold on; 

plot( Xm(:,1), Xm(:,2), 'kx' );

hold on; 

plot( X(:,1), X(:,2), 'ko' );
