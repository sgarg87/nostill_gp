%zip parameters of Zm into a vector
function [ zm, zipInf  ] = zipZm( Zm )

zm = [];

zipInf.lm = -inf*ones( length(Zm), 1 ); %-inf as an invalid value for length of each Zm{:}

for currLtGPIdx = 1:length(Zm); % each of the Zm{:} vector corresponds to the latent GP (GPz{:})
    
    zm = [ zm; Zm{currLtGPIdx} ];
    
    zipInf.ln(currLtGPIdx) = length(Zm{currLtGPIdx});
    
end

end
