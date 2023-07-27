
function table03(table3)
%This function prints Table 3
disp('Table 3');
disp('\begin{tabular}{ccccc}');
fprintf('& %8s & %8s & %8s \\\\ \n','VP(BTZ)', 'VP(daily-MA(1))','VP(Fut-forecast)');
fprintf('%8s & %8.2f & %8.2f & %8.2f \\\\ \n','Mean',table3(1,:));
fprintf('%8s & %8.2f & %8.2f & %8.2f \\\\ \n' ,'Median',table3(2,:));
fprintf('%8s & %8.2f & %8.2f & %8.2f \\\\ \n' ,'Std.Dev',table3(3,:));
fprintf('%8s & %8.2f & %8.2f & %8.2f \\\\ \n' ,'Minimum',table3(4,:));
fprintf('%8s & %8.2f & %8.2f & %8.2f \\\\ \n' ,'Skewness',table3(5,:));
fprintf('%8s & %8.2f & %8.2f & %8.2f \\\\ \n' ,'Kurtosis',table3(6,:));
fprintf('%8s & %8.2f & %8.2f & %8.2f \\\\ \n' ,'AR(1)',table3(7,:));
disp('\end{tabular}');
end
