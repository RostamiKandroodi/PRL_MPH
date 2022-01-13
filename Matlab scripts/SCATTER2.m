function SCATTER2(Parameter1,Parameter2,LableX1,LableX2, XL,YL)
LineWidth = 3;
Fontsize  = 15;
cmap{1} = [51    34     136]/256; % Dark Blue
cmap{2} = [102   156    204]/256; % Light Blue
XMin=min(min(Parameter1), min(Parameter2));
XMax=max(max(Parameter1), max(Parameter2));
[R,P]= corrcoef(Parameter1,Parameter2,'rows', 'complete');
scatter(Parameter1,Parameter2 ,40, [0.25, 0.25, 0.25], 'LineWidth',1)
xlim(XL)
ylim(YL)

xlabel(LableX1,'FontSize',Fontsize,'FontWeight','bold')
ylabel(LableX2,'FontSize',Fontsize,'FontWeight','bold')
% hline=lsline;
% set(hline,'Color','g','LineWidth',LineWidth)
% title(strcat('Correlation coeff.= ' ,sprintf('%.3f',R(2)), ' &   ', '   P-value= ', sprintf('%.5f',P(2))))
% title(strcat('Correlation coeff.= ' ,sprintf('%.3f',R(2)), ' &   ', '   P-value= ', num2str(P(2))))

legend('Parameters','LS Line','Location','northeast')
end