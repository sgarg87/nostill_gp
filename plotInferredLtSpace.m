load juraZnSDISSqrdExpm1_3m2_3_c9E;
Zm = juraZnSDISSqrdExpm1_3m2_3_c9E.lrn{1}.Zm{1};
Xm = juraZnSDISSqrdExpm1_3m2_3_c9E.lrn{1}.Xm{1};
GPz = juraZnSDISSqrdExpm1_3m2_3_c9E.lrn{1}.GPz{1};
covStr = rmfield( juraZnSDISSqrdExpm1_3m2_3_c9E.CovStr, 'NGP');
X = juraZnSDISSqrdExpm1_3m2_3_c9E.X;

GP.GPy = GPz;

Kmm = evalCov( Xm, Xm, covStr, GP );

Km = evalCov( X, Xm, covStr, GP );

z = Km*(Kmm\Zm);

