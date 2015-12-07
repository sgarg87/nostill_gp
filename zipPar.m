function [ par, zipInf ] = zipPar( GPy, GPz, Zm )
%zip parameters of GPy, GPz, and the latent parameters Zm into a vector

[ gpy, zipInf.GPy ] = zipGPy(GPy);
clear GPy;

[ gpz, zipInf.GPz ] = zipGPz(GPz);
clear GPz;

isEmptyZm = isempty(Zm);

if ~isEmptyZm
    [ zm, zipInf.Zm ] = zipZm( Zm ); %zmLn is a vector of cells
    clear Zm;
end

if ~isEmptyZm
    par = [ gpy; gpz; zm ];
    clear gpy gpz zm;
else
    par = [ gpy; gpz ];
    clear gpy gpz;
end

if ~isEmptyZm
    zipInf.sqns = { 'GPy', 'GPz', 'Zm' };
else
    zipInf.sqns = { 'GPy', 'GPz' };
end
    
end

