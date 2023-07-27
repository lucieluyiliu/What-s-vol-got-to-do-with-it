function table09(lhcR2,lhrR2)
%this function prints table 9
disp('Table 09');
disp('\begin{tabular}{cccc}');
fprintf('%20s \\\\ \n', 'Consumption predictability');

fprintf('%20s & %8s & %8s & %8s \\\\ \n','','$5\%$','$50\%$','$95\%$');
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$R^2(3y)$',quantile(lhcR2(:,1),0.05),median(lhcR2(:,1)),quantile(lhcR2(:,1),0.95));
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$R^2(5y)$',quantile(lhcR2(:,2),0.05),median(lhcR2(:,2)),quantile(lhcR2(:,2),0.95));
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$R^2(1y)$',quantile(lhcR2(:,3),0.05),median(lhcR2(:,3)),quantile(lhcR2(:,3),0.95));
fprintf('%20s \\\\ \n', 'Return predictability OLS');
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$R^2(1y)$',quantile(lhrR2(:,1),0.05),median(lhrR2(:,1)),quantile(lhrR2(:,1),0.95));
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$R^2(3y)$',quantile(lhrR2(:,2),0.05),median(lhrR2(:,2)),quantile(lhrR2(:,2),0.95));
fprintf('%20s &%8.2f & %8.2f & %8.2f \\\\ \n', '$R^2(5y)$',quantile(lhrR2(:,3),0.05),median(lhrR2(:,3)),quantile(lhrR2(:,3),0.95));
disp('\end{tabular}');
end