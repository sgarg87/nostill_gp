%This function learns a GP model for a given dataset and test the model as
%per specification
%
%
%inputs:
%
%dataSrcName: is name of data source, see function getData for available data
%sources.
%
%covStr: see function initGP
%
%options: is a structure with fields: 'trnSamplesRatio' for defining ratio of number of training samples to whole data set, 'initScale' for scaling the hyperparameters during initialization, 'lisal' as a structure for defining parameters to LISAL algorithm (see lisalOptions for details).   
%
%
%outputs:
%
%Xv: is a vector of input locations coordinates for training data samples
%with size nv*p wherein nv is the number of training samples and p is the number of input dimensions.
%
%Yv: is a vector of training data points with size nv*1 wherein nv is the number of training samples.
%
%X: is a vector of input locations for the entire data set with size n*p
%wherein n is the number of input locations and p is the number of input
%dimensions.
%
%Y: is a vector of data points from the whole dataset with size n*1 wherein
%n is the number of datapoints.
%
%init: is the structure of hyperparameters initialized as a prerequisite step to learning of the
%the model. init has three fields: 'GPy' is a structure of hyperparameters
%of GPy that model real dynamics; 'GPz' is a vector of cells with each cell
%representing structure of hyperparameters for a latent GPz that models
%latent dynamics.; 'GPs' is a structure of hyperparameters of a stationary GP that is used for selecting a preliminary set of latent locations under LISAL algorithm setup
%
%lrn: is a structure of hyper-parameters learned for a GP model (stationary
%or NGP). In addition to the fields 'GPy', 'GPz', 'GPs', the history on
%parameters learned in each iteration of the LISAL algorithm, log marginal
%likelihood values (field 'lml'), and information gain during latent
%locations selection (field 'inf') are also part of it. See the
%documentation on function lrnGPCov() for more details.
%
function [ Xv, Yv, X, Y, init, lrn, test ] = main( dataSrcName, covStr, options )

[ X, Y ] = getData( dataSrcName );%get data for learning and testing of model

[ Xv, Yv ] = gtTrnData( X, Y, options.trnSamplesRatio );%get the subset of datasamples for training the model. Ratio of samples size for training is trnSamplesRatio.

% Yv = Yv - mean(Yv);

init = initGPCov( covStr, Xv, Yv, options.initScale );%initialize hyperparameters of Gaussian Process model (stationary or nonstationary NGP model) using training data set {Xv, Yv} as per covariance structure covStr. options.initScale is for scaling the parameter values by a constant multiplying factor.

if options.randMultiRuns == 1 %run multiple runs with random initialization of parameters
    
    lrn = cell(1, options.numRuns);
    test = cell(1, options.numRuns);
    preInit = init;
    clear init;
    
    rng('default'); %to ensure that running the experiment multiple times would give same random initializations of parameters

    for currRun = 1:options.numRuns
        
        if isfield( covStr, 'NGP' )
            [ currPars, currZipInf ] = zipPar( preInit.GPy, preInit.GPz, [] ); %zipping the initialized parameters into a vector. The last parameter is [] since the latent parameters are initialized only during the learing process under LISAL algorithm as per the intialization of parameters for GPy, GPz (see lrnGPCov()).
            currPars = currPars.*rand(size(currPars));%scaling the parameters randomly  
            [init{currRun}.GPy, init{currRun}.GPz, ~] = extractPar( currPars, currZipInf );
            clear currPars currZipInf;

            [ currPars, currZipInf ] = zipGPy( preInit.GPs ); %zipping the initialized parameters of GPs into a vector. The function zipGPy() is generic enough to zip parameters of even GPs (see zipGPy() for more details).
            currPars = currPars.*rand(size(currPars));%scaling the parameters randomly  
            init{currRun}.GPs = extractGPy( currPars, currZipInf ); %extracting the parameters of GPs
            clear currPars currZipInf;
        else
            [ currPars, currZipInf ] = zipGPy( preInit.GPy ); %zipping the initialized parameters of GPs into a vector. The function zipGPy() is generic enough to zip parameters of even GPs (see zipGPy() for more details).
            currPars = currPars.*rand(size(currPars));%scaling the parameters randomly  
            init{currRun}.GPy = extractGPy( currPars, currZipInf ); %extracting the parameters of GPs
            clear currPars currZipInf;            
        end
        
        lrn{currRun} = lrnGPCov( Xv, Yv, covStr, init{currRun}, options );%learn hyperparameters of GP model from the initialized hyperparametes init for a given covariance structure. options parameters is used for configuration on LISAL algorithm.  

        test{currRun} = testGPCov( X, Y, covStr, lrn{currRun}, options.test );%test the learned model on the whole dataset. Function values are inferred for 10% input locations conditioning upon another ser of 10% data points. The test runs are performed multiple times, selecting the 10% test sample locations and 10% observed sample locations randomly in each of the runs.        
    end
        
    clear preInit;
else
    lrn = lrnGPCov( Xv, Yv, covStr, init, options );%learn hyperparameters of GP model from the initialized hyperparametes init for a given covariance structure. options parameters is used for configuration on LISAL algorithm.  
    test = testGPCov( X, Y, covStr, lrn, options.test );%test the learned model on the whole dataset. Function values are inferred for 10% input locations conditioning upon another ser of 10% data points. The test runs are performed multiple times, selecting the 10% test sample locations and 10% observed sample locations randomly in each of the runs.
end

end

function [ Xv, Yv ] = gtTrnData( X, Y, trnSamplesRatio )
%Get training data {Xv, Yv} from a given dataset {X, Y} as per training
%samples ratio. Training Samples ration is ratio of number of total samples
%divided by number of samples required for training the model. Xv, X are
%column vectors with each column representing dimensions of inout space. Yv
%and Y are column vectors with the only single column for data points.

Xv = X( 1:trnSamplesRatio:end, : );
Yv = Y( 1:trnSamplesRatio:end, : );

end

function test = testGPCov( X, Y, covStr, GP, options )
%This function tests a GP model using dataset {X,Y} as per given covariance
%structure covStr.
%
%inputs:
%
%X: is a column vector of input coordinates with size n*p wherein n is the number
%of data samples and p is the number of input space dimensions. 
%
%Y: is a column vector of size n*1 representing the datapoints observations on the corresponding n number of input locations. 
%
%covStr is a structure representing covariance structure specification for
%a GP. See documentation on covStr for more details.
%
%GP is structure of hyperparameters for a GP model. For an NGP model, GP
%has fields: 'GPy', 'GPz'. Field 'GPy' is a structure of hyperparameters
%for GPy that model real observable dynamics; 'GPz' is a vectors of cells with each cell representing a structure of hyperparameters of a latent GPz. 
%

startTime = cputime;

numTotalSamples = length(Y);

for currTstSim=1:options.numTestSims
    testSamplesIdx = unique( randi( numTotalSamples, round(numTotalSamples*options.testSamplesRatio), 1 ));%selecting 10% test samples randomly
    obsSamplesIdx = unique( randi( numTotalSamples, round(numTotalSamples*options.obsSamplesRatio), 1 ));%selecting 10% observation samples randomly
    
    Xo = X( obsSamplesIdx , :);
    Yo = Y(obsSamplesIdx);
    
    test.Xo{currTstSim} = Xo;
    test.Yo{currTstSim} = Yo;
    
    clear obsSamplesIdx;
    
    Xt = X( testSamplesIdx, : );
    Yt = Y( testSamplesIdx );
    
    test.Xt{currTstSim} = Xt;
    test.Yt{currTstSim} = Yt;

    clear testSamplesIdx;
    
%     mYoYt = mean([ Yo; Yt ] );
%     
%     Yo = Yo - mYoYt;
%     Yt = Yt - mYoYt;
    
    Ko = evalCov(  Xo, Xo, covStr, GP );
    
    Kto = evalCov(  Xt, Xo, covStr, GP );
    
    invKoExp = Kto/Ko;
    clear Ko Xo;
    
    Ft = invKoExp*Yo;
    
%     test.Ft{currTstSim} = Ft + mYoYt;
    test.Ft{currTstSim} = Ft ;

    clear Yo;
    
    Kt = evalCov(  Xt, Xt, covStr, GP );
    clear Xt;
    
    varFt = diag( Kt - invKoExp*Kto' );
    clear Kt invKoExp Kto;
    test.varFt{currTstSim} = varFt;
    
    test.RMSE(currTstSim) = sqrt(mean( (Yt-Ft).^2 )); %evaluating Root Mean Square Error
    
    test.LL(currTstSim) = mean( -0.5*log(2*pi*varFt) - (((Yt-Ft).^2) ./ (2*varFt)) ); %evaluating Log likelihood
    
    clear Yt Ft varFt;
end

test.time = cputime - startTime;

end