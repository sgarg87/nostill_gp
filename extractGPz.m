function [ GPz, par ] = extractGPz( par, zipInf )
%extract parameters of GPz from a vector of parameter values as per zip
%information

currParIdx = 1;

%sigmaLLn is a cell vector with each cell containing length of sigmaL for each of the latent GP (i.e. GPz)
GPz = cell( length(zipInf.sigmaLLn), 1);

for currLtGPIdx = 1:length(GPz);
    
    GPz{currLtGPIdx}.sigmaF = par( currParIdx, : );
    currParIdx = currParIdx + 1;
    
    GPz{currLtGPIdx}.sigmaL = par( currParIdx : currParIdx + zipInf.sigmaLLn(currLtGPIdx) -1, : );
    currParIdx = currParIdx + zipInf.sigmaLLn(currLtGPIdx, :);
    
    GPz{currLtGPIdx}.sigmaN = par( currParIdx, : );
    currParIdx = currParIdx + 1;
end

par = par( currParIdx:end );

end
