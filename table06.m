function table06(CF)
%this function prints table 6
disp('Table 06');
disp('\begin{tabular}{cccc}');
fprintf('%26s & %8s & %8s & %8s \\\\ \n', ' ', '$5\%$','$50\%$','$95\%$');
fprintf('%26s & %8.2f & %8.2f & %8.2f \\\\ \n','$E[\Delta c]$', quantile(CF(:,1),0.05),median(CF(:,1)),quantile(CF(:,1),0.95));
fprintf('%26s & %8.2f & %8.2f & %8.2f \\\\ \n','$\sigma(\Delta c)$', quantile(CF(:,2),0.05),median(CF(:,2)),quantile(CF(:,2),0.95));
fprintf('%26s & %8.2f & %8.2f & %8.2f \\\\ \n','$AC1(\Delta c)$', quantile(CF(:,3),0.05),median(CF(:,3)),quantile(CF(:,3),0.95));
fprintf('%26s & %8.2f & %8.2f & %8.2f \\\\ \n','$E[\Delta d]$', quantile(CF(:,4),0.05),median(CF(:,4)),quantile(CF(:,4),0.95));
fprintf('%26s & %8.2f & %8.2f & %8.2f \\\\ \n','$\sigma(\Delta d)$', quantile(CF(:,5),0.05),median(CF(:,5)),quantile(CF(:,5),0.95));
fprintf('%26s & %8.2f & %8.2f & %8.2f \\\\ \n','$AC1(\Delta d)$', quantile(CF(:,6),0.05),median(CF(:,6)),quantile(CF(:,6),0.95));
fprintf('%26s & %8.2f & %8.2f & %8.2f \\\\ \n','$\rho_{\Delta c,\Delta d}$', quantile(CF(:,7),0.05),median(CF(:,7)),quantile(CF(:,7),0.95));
fprintf('%26s & %8.2f & %8.2f & %8.2f \\\\ \n','$kurt(\Delta c)(Q)$', quantile(CF(:,8),0.05),median(CF(:,8)),quantile(CF(:,8),0.95));
disp('\end{tabular}');
end