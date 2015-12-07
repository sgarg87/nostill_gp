function [ Zm, par ] = extractZm( par, zipInf )
%extract latent parameter values Zm from a vector as per zip information 

currParIdx = 1;

Zm = cell( length(zipInf.ln), 1 );

for currLtGPIdx = 1: length(Zm);
    Zm{currLtGPIdx} = par( currParIdx : currParIdx + zipInf.ln(currLtGPIdx) - 1, : ); %each element of column vector ln is length of each vector Zm{:}
    currParIdx = currParIdx + zipInf.ln(currLtGPIdx);
end

par = par(currParIdx:end);

end
