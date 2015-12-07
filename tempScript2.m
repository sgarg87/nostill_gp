clear;

load juraCuSSqrdExp;
rs = juraCuSSqrdExp;
for i=1:20 
    ct(i) = rs.lrn{i}.lmlTm;
end
final(:,1) = ct;

load juraCuPCLSKSqrdExpm1_6m2_6_c9E;
rs = juraCuPCLSKSqrdExpm1_6m2_6_c9E;

for i=1:20
    ct(i) = 0;
    for j=1:10
        ct(i) = ct(i) + rs.lrn{i}.lmlTm{j};
    end
end
final(:,2) = ct;

load juraCuGPPMSqrdExpm1_6m2_6_c9E;
rs = juraCuGPPMSqrdExpm1_6m2_6_c9E;

for i=1:20
    ct(i) = 0;
    for j=1:10
        ct(i) = ct(i) + rs.lrn{i}.lmlTm{j};
    end
end
final(:,3) = ct;

load juraCuHGPSqrdExpm1_6m2_6_c9E;
rs = juraCuHGPSqrdExpm1_6m2_6_c9E;

for i=1:20
    ct(i) = 0;
    for j=1:10
        ct(i) = ct(i) + rs.lrn{i}.lmlTm{j};
    end
end
final(:,4) = ct;


load juraCuBWGPSqrdExpm1_6m2_6_c9E;
rs = juraCuBWGPSqrdExpm1_6m2_6_c9E;

for i=1:20
    ct(i) = 0;
    for j=1:10
        ct(i) = ct(i) + rs.lrn{i}.lmlTm{j};
    end
end
final(:,5) = ct;


load juraCuSDISSqrdExpm1_6m2_6_c9E;
rs = juraCuSDISSqrdExpm1_6m2_6_c9E;

for i=1:20
    ct(i) = 0;
    for j=1:10
        ct(i) = ct(i) + rs.lrn{i}.lmlTm{j};
    end
end
final(:,6) = ct;


load juraCuLEISSqrdExpm1_6m2_6_c9E;
rs = juraCuLEISSqrdExpm1_6m2_6_c9E;

for i=1:20
    ct(i) = 0;
    for j=1:10
        ct(i) = ct(i) + rs.lrn{i}.lmlTm{j};
    end
end
final(:,7) = ct;
