
function table01(table1)
%this function prints out Table 01
disp('Table 1');
disp('\begin{tabular}{cccccc}');
fprintf('& %8s & %8s & %8s &%8s &%8s \\\\\n','SP 500','VWRet','$VIX^2$','$Fut^2$','$Daily^2$');
fprintf('%8s &%8.3f & %8.3f &%8.2f &%8.2f &%8.2f \\\\ \n','Mean',table1(1,:));
fprintf('%8s &%8.3f & %8.3f &%8.2f &%8.2f &%8.2f  \\\\ \n','Median',table1(2,:));
fprintf('%8s &%8.2f & %8.2f &%8.2f &%8.2f &%8.2f  \\\\ \n','Std.Dev',table1(3,:));
fprintf('%8s &%8.3f & %8.3f &%8.2f &%8.2f &%8.2f  \\\\ \n','Skewness',table1(4,:));
fprintf('%8s &%8.2f & %8.2f &%8.2f &%8.2f &%8.2f  \\\\ \n','kurtosis',table1(5,:));
fprintf('%8s &%8.2f & %8.2f &%8.2f &%8.2f &%8.2f  \\\\ \n','AR(1)',table1(6,:));
disp('\end{tabular}');
end