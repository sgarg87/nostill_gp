% clear;
% 
% clear global;
% 
% dataSrcName = 'juraZn';
% 
% CovStr.kFun = 'sqrdExp';
% 
% options.initScale = 1;
% 
% options.trnSamplesRatio = 2;
% 
% options.optimization = 'MCMC';
% 
% options.randMultiRuns = 1;
% 
% options.numRuns = 5;
% 
% test.numTestSims = 100;
% test.testSamplesRatio = 1/10;
% test.obsSamplesRatio = 1/10;
% options.test = test;
% clear test;
% 
% [ Xv, Yv, X, Y, init, lrn, test ] = main( dataSrcName, CovStr, options );
% 
% rs.Xv =  Xv;
% rs.Yv =  Yv;
% 
% rs.X =  X;
% rs.Y =  Y;
% 
% rs.init =  init;
% rs.lrn =  lrn;
% rs.test = test;
% 
% rs.dataSrcName =  dataSrcName;
% rs.CovStr =  CovStr;
% rs.options =  options;
% 
% juraZnSSqrdExp = rs;
% 
% save juraZnSSqrdExp juraZnSSqrdExp;
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% clear;
% 
% clear global;
% 
% dataSrcName = 'juraZn';
% 
% CovStr.NGP = 'HGP';
% 
% CovStr.kFun = 'sqrdExp';
% 
% options.initScale = 1;
% 
% options.trnSamplesRatio = 2;
% 
% options.optimization = 'MCMC';
% 
% lisalOptions.m1 = 6;
% lisalOptions.m2 = 6;
% lisalOptions.c = 9;
% lisalOptions.infCriterion = 'E';
% 
% options.lisal = lisalOptions;
% 
% options.randMultiRuns = 1;
% 
% options.numRuns = 5;
% 
% test.numTestSims = 100;  
% test.testSamplesRatio = 1/10;
% test.obsSamplesRatio = 1/10;  
% options.test = test; clear test;
% 
% [ Xv, Yv, X, Y, init, lrn, test ] = main( dataSrcName, CovStr, options );
% 
% rs.Xv =  Xv; rs.Yv =  Yv;
% 
% rs.X =  X; rs.Y =  Y;
% 
% rs.init =  init; rs.lrn =  lrn; rs.test = test;
% 
% rs.dataSrcName =  dataSrcName; rs.CovStr =  CovStr; 
% rs.options = options;
% 
% juraZnHGPSqrdExpm1_6m2_6_c9E = rs;
% 
% save juraZnHGPSqrdExpm1_6m2_6_c9E juraZnHGPSqrdExpm1_6m2_6_c9E;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear;
% 
% clear global;
% 
% dataSrcName = 'juraZn';
% 
% CovStr.NGP = 'LEIS';
% 
% CovStr.kFun = 'sqrdExp';
% 
% options.initScale = 1;
% 
% options.trnSamplesRatio = 2;
% 
% options.optimization = 'MCMC';
% 
% lisalOptions.m1 = 6;
% lisalOptions.m2 = 6;
% lisalOptions.c = 9;
% lisalOptions.infCriterion = 'E';
% 
% options.lisal = lisalOptions;
% 
% options.randMultiRuns = 1;
% 
% options.numRuns = 5;   
% 
% test.numTestSims = 100;  
% test.testSamplesRatio = 1/10;
% test.obsSamplesRatio = 1/10;  
% options.test = test; clear test;
% 
% [ Xv, Yv, X, Y, init, lrn, test ] = main( dataSrcName, CovStr, options );
% 
% rs.Xv =  Xv; rs.Yv =  Yv;
% 
% rs.X =  X; rs.Y =  Y;
% 
% rs.init =  init; rs.lrn =  lrn; rs.test = test;
% 
% rs.dataSrcName =  dataSrcName; rs.CovStr =  CovStr; 
% rs.options = options;
% 
% juraZnLEISSqrdExpm1_6m2_6_c9E = rs;
% 
% save juraZnLEISSqrdExpm1_6m2_6_c9E juraZnLEISSqrdExpm1_6m2_6_c9E;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% clear;
% 
% clear global;
% 
% dataSrcName = 'juraZn';
% 
% CovStr.NGP = 'BWGP';
% 
% CovStr.kFun = 'sqrdExp';
% 
% options.initScale = 1;
% 
% options.trnSamplesRatio = 2;
% 
% options.optimization = 'MCMC';
% 
% lisalOptions.m1 = 6;
% lisalOptions.m2 = 6;
% lisalOptions.c = 9;
% lisalOptions.infCriterion = 'E';
% 
% options.lisal = lisalOptions;
% 
% options.randMultiRuns = 1;
% 
% options.numRuns = 5;
% 
% test.numTestSims = 100;  
% test.testSamplesRatio = 1/10;
% test.obsSamplesRatio = 1/10;  
% options.test = test; clear test;
% 
% [ Xv, Yv, X, Y, init, lrn, test ] = main( dataSrcName, CovStr, options );
% 
% rs.Xv =  Xv; rs.Yv =  Yv;
% 
% rs.X =  X; rs.Y =  Y;
% 
% rs.init =  init; rs.lrn =  lrn; rs.test = test;
% 
% rs.dataSrcName =  dataSrcName; rs.CovStr =  CovStr; 
% rs.options = options;
% 
% juraZnBWGPSqrdExpm1_6m2_6_c9E = rs;
% 
% save juraZnBWGPSqrdExpm1_6m2_6_c9E juraZnBWGPSqrdExpm1_6m2_6_c9E;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear;
% 
% clear global;
% 
% dataSrcName = 'juraZn';
% 
% CovStr.NGP = 'GPPM';
% 
% CovStr.kFun = 'sqrdExp';
% 
% options.initScale = 1;
% 
% options.trnSamplesRatio = 2;
% 
% options.optimization = 'MCMC';
% 
% lisalOptions.m1 = 6;
% lisalOptions.m2 = 6;
% lisalOptions.c = 9;
% lisalOptions.infCriterion = 'E';
% 
% options.lisal = lisalOptions;
% 
% options.randMultiRuns = 1;
% 
% options.numRuns = 5;   
% 
% test.numTestSims = 100;  
% test.testSamplesRatio = 1/10;
% test.obsSamplesRatio = 1/10;  
% options.test = test; clear test;
% 
% [ Xv, Yv, X, Y, init, lrn, test ] = main( dataSrcName, CovStr, options );
% 
% rs.Xv =  Xv; rs.Yv =  Yv;
% 
% rs.X =  X; rs.Y =  Y;
% 
% rs.init =  init; rs.lrn =  lrn; rs.test = test;
% 
% rs.dataSrcName =  dataSrcName; rs.CovStr =  CovStr; 
% rs.options = options;
% 
% juraZnGPPMSqrdExpm1_6m2_6_c9E = rs;
% 
% save juraZnGPPMSqrdExpm1_6m2_6_c9E juraZnGPPMSqrdExpm1_6m2_6_c9E;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% clear;
% 
% clear global;
% 
% dataSrcName = 'juraZn';
% 
% CovStr.NGP = 'SDIS';
% 
% CovStr.kFun = 'sqrdExp';
% 
% options.initScale = 1;
% 
% options.trnSamplesRatio = 2;
% 
% options.optimization = 'MCMC';
% 
% lisalOptions.m1 = 3;
% lisalOptions.m2 = 3;
% lisalOptions.c = 9;
% lisalOptions.infCriterion = 'E';
% 
% options.lisal = lisalOptions;
% 
% options.randMultiRuns = 1;
% 
% options.numRuns = 5;
% 
% test.numTestSims = 100;  
% test.testSamplesRatio = 1/10;
% test.obsSamplesRatio = 1/10;  
% options.test = test; clear test;
% 
% [ Xv, Yv, X, Y, init, lrn, test ] = main( dataSrcName, CovStr, options );
% 
% rs.Xv =  Xv; rs.Yv =  Yv;
% 
% rs.X =  X; rs.Y =  Y;
% 
% rs.init =  init; rs.lrn =  lrn; rs.test = test;
% 
% rs.dataSrcName =  dataSrcName; rs.CovStr =  CovStr; 
% rs.options = options;
% 
% juraZnSDISSqrdExpm1_3m2_3_c9E = rs;
% 
% save juraZnSDISSqrdExpm1_3m2_3_c9E juraZnSDISSqrdExpm1_3m2_3_c9E;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
clear;

clear global;

dataSrcName = 'juraZn';

CovStr.NGP = 'PCLSK';

CovStr.kFun = 'sqrdExp';

options.initScale = 1;

options.trnSamplesRatio = 2;

options.optimization = 'MCMC';

lisalOptions.m1 = 3;
lisalOptions.m2 = 3;
lisalOptions.c = 9;
lisalOptions.infCriterion = 'E';

options.lisal = lisalOptions;

options.randMultiRuns = 1;

options.numRuns = 5;   

test.numTestSims = 100;  
test.testSamplesRatio = 1/10;
test.obsSamplesRatio = 1/10;  
options.test = test; clear test;

[ Xv, Yv, X, Y, init, lrn, test ] = main( dataSrcName, CovStr, options );

rs.Xv =  Xv; rs.Yv =  Yv;

rs.X =  X; rs.Y =  Y;

rs.init =  init; rs.lrn =  lrn; rs.test = test;

rs.dataSrcName =  dataSrcName; rs.CovStr =  CovStr; 
rs.options = options;

juraZnPCLSKSqrdExpm1_3m2_3_c9E = rs;

save juraZnPCLSKSqrdExpm1_3m2_3_c9E juraZnPCLSKSqrdExpm1_3m2_3_c9E;
