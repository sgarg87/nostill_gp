clear;

load juraCrSSqrdExp;
rs = juraCrSSqrdExp;
t = 0; for i=1:5; ct(i) = mean( rs.test{i}.RMSE ); t = t + ct(i); end; t/5;
final(:,1) = ct;

load juraCrPCLSKSqrdExpm1_6m2_6_c9E;
rs = juraCrPCLSKSqrdExpm1_6m2_6_c9E;
t = 0; for i=1:5; ct(i) = mean( rs.test{i}.RMSE ); t = t + ct(i); end; t/5;
final(:,2) = ct;

load juraCrGPPMSqrdExpm1_6m2_6_c9E;
rs = juraCrGPPMSqrdExpm1_6m2_6_c9E;
t = 0; for i=1:5; ct(i) = mean( rs.test{i}.RMSE ); t = t + ct(i); end; t/5;
final(:,3) = ct;

load juraCrHGPSqrdExpm1_6m2_6_c9E;
rs = juraCrHGPSqrdExpm1_6m2_6_c9E;
t = 0; for i=1:5; ct(i) = mean( rs.test{i}.RMSE ); t = t + ct(i); end; t/5;
final(:,4) = ct;

load juraCrBWGPSqrdExpm1_6m2_6_c9E;
rs = juraCrBWGPSqrdExpm1_6m2_6_c9E;
t = 0; for i=1:5; ct(i) = mean( rs.test{i}.RMSE ); t = t + ct(i); end; t/5;
final(:,5) = ct;

load juraCrSDISSqrdExpm1_6m2_6_c9E;
rs = juraCrSDISSqrdExpm1_6m2_6_c9E;
t = 0; for i=1:5; ct(i) = mean( rs.test{i}.RMSE ); t = t + ct(i); end; t/5;
final(:,6) = ct;

load juraCrLEISSqrdExpm1_6m2_6_c9E;
rs = juraCrLEISSqrdExpm1_6m2_6_c9E;
t = 0; for i=1:5; ct(i) = mean( rs.test{i}.RMSE ); t = t + ct(i); end; t/5;
final(:,7) = ct;

