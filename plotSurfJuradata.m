clear;
clear global;
load juraData;

subplot(3,3,1); interpolateSurface( juraData.X, juraData.Landuse, 2 ); shading interp;
subplot(3,3,2); interpolateSurface( juraData.X, juraData.Rock, 2 ); shading interp;

subplot(3,3,3); interpolateSurface( juraData.X, juraData.Cd, 2 ); shading interp;


subplot(3,3,4); interpolateSurface( juraData.X, juraData.Co, 2 ); shading interp;
 subplot(3,3,5); interpolateSurface( juraData.X, juraData.Cr, 2 ); shading interp;

subplot(3,3,6); interpolateSurface( juraData.X, juraData.Cu, 2 ); shading interp;


subplot(3,3,7); interpolateSurface( juraData.X, juraData.Ni, 2 ); shading interp;

subplot(3,3,8); interpolateSurface( juraData.X, juraData.Pb, 2 ); shading interp;


subplot(3,3,9); interpolateSurface( juraData.X, juraData.Zn, 2 ); shading interp;
