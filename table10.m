function table10(volbeta,volR2)
%this function prints table 10
disp('Table 10');
disp('\begin{tabular}{cccc}');
fprintf('%20s &%8s & %8s & %8s \\\\ \n', '$R^2(1y)$');
fprintf('%20s \\\\ \n', 'Consumption volatility');
fprintf('%20s & %8s & %8s & %8s \\\\ \n','','$5\%$','$50\%$','$95\%$');
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$\beta(1y)$',quantile(volbeta(:,1),0.05),median(volbeta(:,1)),quantile(volbeta(:,1),0.95));
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$R^2(1y)$',quantile(volR2(:,1),0.05),median(volR2(:,1)),quantile(volR2(:,1),0.95));
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$\beta(5y)$',quantile(volbeta(:,2),0.05),median(volbeta(:,2)),quantile(volbeta(:,2),0.95));
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$R^2(5y)$',quantile(volR2(:,2),0.05),median(volR2(:,2)),quantile(volR2(:,2),0.95));
fprintf('%20s \\\\ \n', 'Return Volatility');
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$\beta(1y)$',quantile(volbeta(:,3),0.05),median(volbeta(:,3)),quantile(volbeta(:,3),0.95));
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$R^2(3y)$',quantile(volR2(:,3),0.05),median(volR2(:,3)),quantile(volR2(:,3),0.95));
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$\beta(5y)$',quantile(volbeta(:,4),0.05),median(volbeta(:,4)),quantile(volbeta(:,4),0.95));
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$R^2(5y)$',quantile(volR2(:,4),0.05),median(volR2(:,4)),quantile(volR2(:,4),0.95));
disp('\end{tabular}');
end
