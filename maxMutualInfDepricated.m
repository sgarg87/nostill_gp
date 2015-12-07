function [ maxMI, excTm, Xi, idxXi ] = maxMutualInf( Xv, Xa, Xb, m, covStr, GP )
% 
% function: [ maxMI, excTm, Xi, idxXi ] = maxMutualInf( Xv, Xa, Xb, m,
% covStr, GP )
% 
% Learns a column vector of m informative locations Xi as a subset of Xv 
% such that mutual information between Xai ( Xai = {Xa U Xi} ) and Xb_ai (
% { Xb minus Xai }, i.e. MI( Xai; Xb_ai ), is maximized greedily where Xa is 
% already observed locations set.
% 
% Mutual Information is evaluated using model GP with a given covariance 
% structure (covStr) as per the expression below:
% MI(Xai; Xb_ai) = H( Xb_ai ) - H( Xb_ai | Xai )
% 
% covStr is a structure with fields { 'NGP', 'kFun' }
% 
% GP is a structure with fields { 'GPy', 'GPz', 'Xm', 'Zm' } for an NGP and
% field 'GPy' only for a stationary representation.
% 
% output maxMI is maximized mutual information value for learning Xi.
% 
% output excTm is execution time for maximizing mutual information to learn
% the informative locations
% 
% idxXi is index of informative locations Xi that are selected from Xv.
% 
% References: [ Krause et al., JMLR, 2008, Near-Optimal Sensor Placements in Gaussian Processes- Theory, Efficient Algorithms and Empirical Studies ]
% 

srtTm = cputime;

Kvv = evalCov( Xv, Xv, covStr, GP );

isXaEmpty = isempty(Xa);

if ~isXaEmpty
    Kva = evalCov( Xv, Xa, covStr, GP );
    Kaa = evalCov( Xa, Xa, covStr, GP );
end

idxXb_ = ~ismember( Xb, Xa, 'rows' ); % idxXb_ is a logical vector
Xb_ = Xb( idxXb_, :);
clear idxXb_;
clear Xb;

Kb_b_ =  evalCov( Xb_, Xb_, covStr, GP );
Kvb_ =  evalCov( Xv, Xb_, covStr, GP );
if ~isXaEmpty
    Kab_ =  evalCov( Xa, Xb_, covStr, GP );
end

v = size( Xv, 1 );

idxXi = [];

if ~isXaEmpty
    invKPrv = inv(Kaa); %inference requires conditioning on all of the previous observations Xa
else
    invKPrv = [];
end

for i = 1:m;
    mi = -inf*zeros( v, 1 );

    for j = 1:v;
        idxXi(i) = j;
        idxXb__ = ~ismember( Xb_, Xv( idxXi, :), 'rows' );
        Kb__b__ = Kb_b_( idxXb__, idxXb__ );
                
        if ~isXaEmpty
            invK{j} = updateInvExpr( invKPrv, [ Kva( idxXi(i), : ) Kvv( idxXi(i), idxXi(1:i-1) ) ], Kvv( idxXi(i), idxXi(i) ) );
        else
            invK{j} = updateInvExpr( invKPrv, Kvv( idxXi(i), idxXi(1:i-1) ), Kvv( idxXi(i), idxXi(i) ) );
        end
        
        if ~isXaEmpty
            Kavb__ = [ Kab_( :, idxXb__ ) ; Kvb_( idxXi, idxXb__ ) ];
        else
            Kavb__ = Kvb_( idxXi, idxXb__ );
        end
        
        mi(j) = log( det( Kb__b__ ) ) - log( det( Kb__b__ - Kavb__'*invK{j}*Kavb__ ) );
    end
    
    [ maxMI, maxMIIdx ] = max(mi);
    idxXi(i) = maxMIIdx;
    invKPrv = invK{maxMIIdx};
    clear invK mi maxMIIdx;
end

Xi = Xv( idxXi, :);

excTm = cputime - srtTm;

end

%see section C in [Singh et al.;  Non-Stationary Spatio-Temporal Gaussian Processes for Environmental Surveillance with Mobile Robots; 2010; ICRA]
%for efficient update of matrix inverse
function invKab = updateInvExpr( invKaa, Kba, Kbb )

F22 = Kbb - Kba*invKaa*Kba';

invF22 = inv(F22);

F11 = invKaa + invKaa*Kba'*invF22*Kba*invKaa;

F12 = invKaa*Kba'*invF22; 

invKab = [ F11 -F12; -F12' invF22 ];

end