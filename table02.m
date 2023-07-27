
function table02(beta_daily,R2_daily,t_daily,beta_Fut,R2_Fut,t_Fut)
%This function prints Table 02
disp('Table 2');
disp('\begin{tabular}{ccccccc}');
fprintf('%8s & %8s & %8s & %8s & %8s & %8s & %8s \\\\ \n','Dept.Var','X1','X2','intercept','$\beta_1$','$\beta_2$','$R^2$');
fprintf('%8s & %8s & %8s & %8.2f & %8.2f & %8.2f & %8.2f \\\\ \n','$Daily_{t+1}^2$','$Daily^2_t$','MA(1)',beta_daily',R2_daily);
fprintf('%8s & %8s & %8s & (%8.2f) &(%8.2f) & (%8.2f) & %8s \\\\ \n','(t-stat)','','',t_daily','');
fprintf('%8s & %8s & %8s & %8.2f & %8.2f & %8.2f & %8.2f \\\\ \n','$Fut_t^2$','$Fut^2_t$','$VIX^2$',beta_Fut',R2_Fut);
fprintf('%8s & %8s & %8s & (%8.2f) &(%8.2f) & (%8.2f) & %8s \\\\ \n','(t-stat)','','',t_Fut','');
disp('\end{tabular}');
end