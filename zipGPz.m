%zip parameters of GPz into a vector
function [ gpz, zipInf ] = zipGPz( GPz )

gpz = [];

zipInf.sigmaLLn = -inf*ones( length(GPz), 1 );%assigning an invalid value of -inf for length

for currLtGPIdx = 1:length(GPz);
    
    gpz = [ gpz; GPz{currLtGPIdx}.sigmaF ];
    
    gpz = [ gpz; GPz{currLtGPIdx}.sigmaL ];
    
    zipInf.sigmaLLn(currLtGPIdx) = length( GPz{currLtGPIdx}.sigmaL );
    
    gpz = [ gpz; GPz{currLtGPIdx}.sigmaN ];

end

end
