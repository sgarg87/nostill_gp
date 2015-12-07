function [ GPy, par ] = extractGPy( par, zipInf )
%extract parameters of GPy from a vector of parameter values as per zip
%information

currParIdx = 1;

if zipInf.isSigmaF
    GPy.sigmaF = par(currParIdx, :);
    currParIdx = currParIdx + 1;
end

if zipInf.isSigmaL
    GPy.sigmaL = par( currParIdx : currParIdx + zipInf.sigmaLLn - 1, : );
    currParIdx = currParIdx + zipInf.sigmaLLn;
end

if zipInf.isSigmaN
    GPy.sigmaN = par( currParIdx, : );
    currParIdx = currParIdx + 1;
end

par = par(currParIdx:end, :);

end
