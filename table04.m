
function table04(bpred1,bpred2,bpred3,bpred4,bpred5,R2pred1,R2pred2,R2pred3,R2pred4,R2pred5,tpred1,tpred2,tpred3,tpred4,tpred5,robust)
%This function prints Table 04
disp('Table 4');
disp('\begin{tabular}{ccccccccc}');
fprintf('%8s & %16s & %24s & %24s \\\\ \n',' ','\multicolumn{2}{c}{Regressors}', '\multicolumn{3}{c}{OLS}', '\multicolumn{3}{c}{Robust Reg.}');
fprintf('%8s & %8s &%8s & %8s & %8s & %8s & %8s & %8s & %8s \\\\ \n','Dependent', 'X1','X2','$\beta_1$','$\beta_2$','$R^2(\%)$',' $\beta_1$','$\beta_2$','$R^2(\%)$');
fprintf('%8s & %8s & %8s & %8.2f & %8s & %8.2f & %8.2f & %8s & %8.2f\\\\ \n','$r_{t+1}$','$VP_t$','',bpred1(2),'',R2pred1*100,robust.RobustMdl1.Coefficients{'x1','Estimate'},'',robust.RobustMdl1.Rsquared.ordinary*100);
fprintf('%8s & (%8s) & %8s & (%8.2f) & %8s & %8s & (%8.2f) & %8s & %8s \\\\ \n',' ','t-stat',' ',tpred1(2),' ',' ',robust.RobustMdl1.Coefficients{'x1','tStat'},' ',' ');
fprintf('%8s & %8s & %8s & %8.2f & %8s & %8.2f & %8.2f & %8s & %8.2f \\\\ \n','$r_{t+1}$','$VP_{t-1}$',' ',bpred2(2),' ',R2pred2*100,robust.RobustMdl2.Coefficients{'x1','Estimate'},'',robust.RobustMdl1.Rsquared.ordinary*100);
fprintf('%8s & (%8s) & %8s & (%8.2f) & %8s & %8s & (%8.2f) & %8s & %8s \\\\ \n',' ','t-stat',' ',tpred2(2),' ',' ',robust.RobustMdl2.Coefficients{'x1','tStat'},' ',' ');
fprintf('%8s & %8s & %8s & %8.2f & %8s & %8.2f & %8.2f & %8s & %8.2f \\\\ \n','$r_{t+3}$','$VP_t$',' ',bpred3(2),' ',R2pred3*100,robust.RobustMdl3.Coefficients{'x1','Estimate'},'',robust.RobustMdl3.Rsquared.ordinary*100);
fprintf('%8s & (%8s) & %8s & (%8.2f) & %8s & %8s & (%8.2f) & %8s & %8s \\\\ \n',' ','t-stat',' ',tpred3(2),' ',' ',robust.RobustMdl3.Coefficients{'x1','tStat'},' ',' ');
fprintf('%8s & %8s & %8s & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f\\\\ \n','$r_{t+1}$','$VP_t$','$log(P/E)_t$',bpred4(2),bpred4(3),R2pred4*100,robust.RobustMdl4.Coefficients{'x1','Estimate'},robust.RobustMdl4.Coefficients{'x2','Estimate'},robust.RobustMdl4.Rsquared.ordinary*100);
fprintf('%8s & (%8s) & %8s & (%8.2f) & (%8.2f) %8s & (%8.2f) & (%8.2f) & %8s \\\\ \n',' ','t-stat',' ',tpred4(2),tpred4(3),' ',robust.RobustMdl4.Coefficients{'x1','tStat'},robust.RobustMdl4.Coefficients{'x2','tStat'},' ');
fprintf('%8s & %8s & %8s & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f \\\\ \n','$r_{t+1}$','$VP_t$','$log(P/E)_t$',bpred5(2),bpred5(3),R2pred5*100,robust.RobustMdl5.Coefficients{'x1','Estimate'},robust.RobustMdl5.Coefficients{'x2','Estimate'},robust.RobustMdl5.Rsquared.ordinary*100);
fprintf('%8s & (%8s) & %8s & (%8.2f) & (%8.2f) %8s & (%8.2f) & (%8.2f) & %8s \\\\ \n',' ','t-stat',' ',tpred5(2),tpred5(3),' ',robust.RobustMdl5.Coefficients{'x1','tStat'},robust.RobustMdl5.Coefficients{'x2','tStat'},' ');
disp('\end{tabular}');
end