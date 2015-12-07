function [ gpy, zipInf ] = zipGPy( GPy )
%zip parameters of GPy into a vector

zipInf.isSigmaF = isfield(GPy, 'sigmaF' );

if zipInf.isSigmaF
    gpy = GPy.sigmaF;
else
    gpy = [];
end

zipInf.isSigmaL = isfield(GPy, 'sigmaL' );

if zipInf.isSigmaL
    gpy = [ gpy; GPy.sigmaL ];
    
    zipInf.sigmaLLn = length( GPy.sigmaL );
end

zipInf.isSigmaN = isfield( GPy, 'sigmaN' );

if zipInf.isSigmaN
    gpy = [ gpy; GPy.sigmaN ];
end

end