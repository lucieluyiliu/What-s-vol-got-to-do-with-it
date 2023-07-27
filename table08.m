function table08(VP,vpbeta,vpR2)
%this function prints table 8
disp('Table 07');
disp('\begin{tabular}{cccc}');
disp('Variance Premium\\');
fprintf('%30s & %8s & %8s & %8s \\\\ \n','','$5\%$','$50\%$','$95\%$');
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$\sigma(var_t(r_m))$',quantile(VP(:,1),0.05),median(VP(:,1)),quantile(VP(:,1),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$AC1(var_t(r_m))$',quantile(VP(:,2),0.05),median(VP(:,2)),quantile(VP(:,2),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$AC2(var_t(r_m))$',quantile(VP(:,3),0.05),median(VP(:,3)),quantile(VP(:,3),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$E[VP]$',quantile(VP(:,4),0.05),median(VP(:,4)),quantile(VP(:,4),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$\sigma(VP)$',quantile(VP(:,5),0.05),median(VP(:,5)),quantile(VP(:,5),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$skew(VP)$',quantile(VP(:,6),0.05),median(VP(:,6)),quantile(VP(:,6),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$kurt(VP)$',quantile(VP(:,7),0.05),median(VP(:,7)),quantile(VP(:,7),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$kurt(\Delta VIX)$',quantile(VP(:,8),0.05),median(VP(:,8)),quantile(VP(:,8),0.95));
disp('Return Predictability (vp)\\');
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$\beta(1m)$',quantile(vpbeta(:,1),0.05),median(vpbeta(:,1)),quantile(vpbeta(:,1),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$R^2(1m)$',quantile(vpR2(:,1),0.05),median(vpR2(:,1)),quantile(vpR2(:,1),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$\beta(3m)$',quantile(vpbeta(:,2),0.05),median(vpbeta(:,2)),quantile(vpbeta(:,2),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$R^2(3m)$',quantile(vpR2(:,2),0.05),median(vpR2(:,2)),quantile(vpR2(:,2),0.95));
disp('Return Predictability (VP,p-d)\\');
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$\beta_1(1m)$',quantile(vpbeta(:,3),0.05),median(vpbeta(:,3)),quantile(vpbeta(:,3),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$\beta_2(1m)$',quantile(vpbeta(:,4),0.05),median(vpbeta(:,4)),quantile(vpbeta(:,4),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$R^2(1m)$',quantile(vpR2(:,3),0.05),median(vpR2(:,3)),quantile(vpR2(:,3),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$\beta_1(3m)$',quantile(vpbeta(:,5),0.05),median(vpbeta(:,5)),quantile(vpbeta(:,5),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$\beta_2(3m)$',quantile(vpbeta(:,6),0.05),median(vpbeta(:,6)),quantile(vpbeta(:,6),0.95));
fprintf('%30s & %8.2f & %8.2f & %8.2f \\\\ \n ','$R^2(3m)$',quantile(vpR2(:,4),0.05),median(vpR2(:,4)),quantile(vpR2(:,4),0.95));
disp('\end{tabular}');
end