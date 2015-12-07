function e = evalE(K)
%evaluate entropy given covariance matrix K

    n = length(K);
    detK = det(K);

    if detK <= 0
        detK = 1e-320;
    end
    clear K;
    
    detKExpr = detK*(2*pi*exp(1))^n; clear detK;
    
%     if detKExpr == inf
%         detKExpr = 1e308;
%     end
    
    e = real(0.5*log( detKExpr ));
    
    if e < 0 %entropy can not be negative
        e = 0;
    end
end
