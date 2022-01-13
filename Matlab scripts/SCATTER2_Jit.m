function SCATTER2_Jit(Parameter1,Parameter2,LableX1,LableX2, XL,YL)
LineWidth = 3;
Fontsize  = 15;
% Fontsize  = 10;

XMin=min(min(Parameter1), min(Parameter2));
XMax=max(max(Parameter1), max(Parameter2));
[R,P]= corrcoef(Parameter1,Parameter2,'rows', 'complete');
scatter(Parameter1+0.15*(rand(size(Parameter1))-0.5),Parameter2 ,40, [0.25, 0.25, 0.25], 'LineWidth',1)
xlim(XL)
ylim(YL)

xlabel(LableX1,'FontSize',Fontsize,'FontWeight','bold')
ylabel(LableX2,'FontSize',Fontsize,'FontWeight','bold')
% hline=lsline;
% set(hline,'Color','r','LineWidth',LineWidth)
% title(strcat('Correlation coeff.= ' ,sprintf('%.3f',R(2)), ' &   ', '   P-value= ', num2str(P(2))))

% legend('Parameters','LS Line','Location','NorthOutside')
legend('Observation','LS Line')
end