function table07(Returns)
%this function prints table 7
disp('Table 07');
disp('\begin{tabular}{cccccc}');
fprintf('%30s & %8s  & %8s & %8s \\\\ \n','', '$5\%$','$50\%$','$95\%$');
fprintf('%30s & %8.2f &  %8.2f & %8.2f \\\\ \n','$E[r_m]$',quantile(Returns(:,1),0.05),median(Returns(:,1)),quantile(Returns(:,1),0.95));
fprintf('%30s & %8.2f &  %8.2f & %8.2f \\\\ \n','$E[r_f]$',quantile(Returns(:,2),0.05),median(Returns(:,2)),quantile(Returns(:,2),0.95));
fprintf('%30s & %8.2f &  %8.2f & %8.2f \\\\ \n','$\sigma(r_m)$',quantile(Returns(:,3),0.05),median(Returns(:,3)),quantile(Returns(:,3),0.95));
fprintf('%30s & %8.2f &  %8.2f & %8.2f \\\\ \n','$\sigma(r_f)$',quantile(Returns(:,4),0.05),median(Returns(:,4)),quantile(Returns(:,4),0.95));
fprintf('%30s & %8.2f &  %8.2f & %8.2f \\\\ \n','$E[p-d]$',quantile(Returns(:,5),0.05),median(Returns(:,5)),quantile(Returns(:,5),0.95));
fprintf('%30s & %8.2f &  %8.2f & %8.2f \\\\ \n','$\sigma(p-d)$',quantile(Returns(:,6),0.05),median(Returns(:,6)),quantile(Returns(:,6),0.95));
fprintf('%30s & %8.2f &  %8.2f & %8.2f \\\\ \n','$skew(r_m-r_f)$(M)',quantile(Returns(:,7),0.05),median(Returns(:,7)),quantile(Returns(:,7),0.95));
fprintf('%30s & %8.2f &  %8.2f & %8.2f \\\\ \n','$kurt(r_m-r_f)$(M)',quantile(Returns(:,8),0.05),median(Returns(:,8)),quantile(Returns(:,8),0.95));
fprintf('%30s & %8.2f &  %8.2f & %8.2f \\\\ \n','$AC1(r_m-r_f)$(M)',quantile(Returns(:,9),0.05),median(Returns(:,9)),quantile(Returns(:,9),0.95));
fprintf('%30s & %8.2f &  %8.2f & %8.2f \\\\ \n','$kurt(r_m-r_f)$(A)',quantile(Returns(:,10),0.05),median(Returns(:,10)),quantile(Returns(:,10),0.95));
disp('\end{tabular}');
end