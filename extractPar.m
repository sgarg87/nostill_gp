function [ GPy, GPz, Zm ] = extractPar( par, zipInf )
%extract parameters as per zip information

for currSqnsIdx = 1:length( zipInf.sqns )
    switch zipInf.sqns{currSqnsIdx}
        case 'GPy'
            [ GPy, par ] = extractGPy( par, zipInf.GPy );
        case 'GPz'
            [ GPz, par ] = extractGPz( par, zipInf.GPz );
        case 'Zm'
            [ Zm, ~ ] = extractZm( par, zipInf.Zm );
        otherwise
            error( 'an invalid sequence element for extraction' )
    end
end

if isempty( strmatch( 'Zm', zipInf.sqns ) )
    Zm = [];
end

end
