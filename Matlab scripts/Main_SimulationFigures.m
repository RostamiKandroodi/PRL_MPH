% Main for generating the PRL paper figures (Simulations)

% By Mojtaba Rostami Kandroodi

% Start 13 Nov 2018
% Last Update 15 April 2020
%--------------------------------------------------------------------------
clc; clear all; close all;
% load data
load('WMandBIS.mat')

HiWM = find(WMSpan > 4.5);      % Index of Hi working memmory span 
LoWM = find(WMSpan <= 4.5);     % Index of Low working memmory span
%% Figure 4C
% Add Auxiliary scripts path
addpath('..\Auxiliary')
% load Simulation data
DataLocation = '..\Run_result\';      % Local
load(strcat(DataLocation,'Simulation_EWA+F2.mat'));
data = Sdata;
[ActionsPro_All, ActionsPro_PLA, ActionsPro_MPH]  = SimulationRawActionProbablity2(data);

LineWidth =1.5;
Fontsize = 20;
WW =5;
x=1:80;

% Hi Working Memory
figure('pos',[100 100 800 500])
hold on;
n_Hi = 102;
[Mean, SD] = SmootPerSubject(ActionsPro_PLA.action1(HiWM,:),WW);
SE = SD/sqrt(n_Hi);
[l,p] = boundedline(x,Mean,SE,'-r');

[Mean, SD] = SmootPerSubject(ActionsPro_MPH.action1(HiWM,:),WW);
SE = SD/sqrt(n_Hi);
[l,p] = boundedline(x,Mean,SE,'--r');

[Mean, SD] = SmootPerSubject(ActionsPro_PLA.action2(HiWM,:),WW);
SE = SD/sqrt(n_Hi);
[l,p] = boundedline(x,Mean,SE,'-b');

[Mean, SD] = SmootPerSubject(ActionsPro_MPH.action2(HiWM,:),WW);
SE = SD/sqrt(n_Hi);
[l,p] = boundedline(x,Mean,SE,'--b');

[Mean, SD] = SmootPerSubject(ActionsPro_PLA.action3(HiWM,:),WW);
SE = SD/sqrt(n_Hi);
[l,p] = boundedline(x,Mean,SE,'-g');

[Mean, SD] = SmootPerSubject(ActionsPro_MPH.action3(HiWM,:),WW);
SE = SD/sqrt(n_Hi);
[l,p] = boundedline(x,Mean,SE,'--g');

xlabel('Trial','FontSize',Fontsize,'FontWeight','bold')
ylabel('p(Stimulus)','FontSize',Fontsize,'FontWeight','bold')
PL = line([40 40], [0,1]);
PL.Color = [0.75, 0.75, 0.75];
PL.LineStyle = '--';
PL.LineWidth = LineWidth;
xticks([0 20 40 60 80]);
yticks([0 0.25 0.50 0.75 1]);
set(gca,'FontSize',Fontsize)
% saveas(gcf,'PLAMPHSmoot_SimuH','epsc')

% Low Working Memory
figure('pos',[100 100 800 500])
hold on;
n_Lo = 102;
[Mean, SD] = SmootPerSubject(ActionsPro_PLA.action1(LoWM,:),WW);
SE = SD/sqrt(n_Lo);
[l,p] = boundedline(x,Mean,SE,'-r');

[Mean, SD] = SmootPerSubject(ActionsPro_MPH.action1(LoWM,:),WW);
[l,p] = boundedline(x,Mean,SE,'--r');

[Mean, SD] = SmootPerSubject(ActionsPro_PLA.action2(LoWM,:),WW);
SE = SD/sqrt(n_Lo);
[l,p] = boundedline(x,Mean,SE,'-b');

[Mean, SD] = SmootPerSubject(ActionsPro_MPH.action2(LoWM,:),WW);
SE = SD/sqrt(n_Lo);
[l,p] = boundedline(x,Mean,SE,'--b');

[Mean, SD] = SmootPerSubject(ActionsPro_PLA.action3(LoWM,:),WW);
SE = SD/sqrt(n_Lo);
[l,p] = boundedline(x,Mean,SE,'-g');

[Mean, SD] = SmootPerSubject(ActionsPro_MPH.action3(LoWM,:),WW);
SE = SD/sqrt(n_Lo);
[l,p] = boundedline(x,Mean,SE,'--g');

xlabel('Trial','FontSize',Fontsize,'FontWeight','bold')
ylabel('p(Stimulus)','FontSize',Fontsize,'FontWeight','bold')
PL = line([40 40], [0,1]);
PL.Color = [0.75, 0.75, 0.75];
PL.LineStyle = '--';
PL.LineWidth = LineWidth;
xticks([0 20 40 60 80]);
yticks([0 0.25 0.50 0.75 1]);
set(gca,'FontSize',Fontsize)
% saveas(gcf,'PLAMPHSmoot_SimuL','epsc')

%%-------------------------------------------------------------------------
%% Figure 4D
% Plot correlation 
fig_position = [200 10 450 400]; % coordinates for figures
f2 = figure('Position', fig_position);
StimDraug_Acq = (mean(ActionsPro_MPH.action1(:,1:40),2) - mean(ActionsPro_MPH.action2(:,1:40),2)) - ...
                (mean(ActionsPro_PLA.action1(:,1:40),2) - mean(ActionsPro_PLA.action2(:,1:40),2));
StimDraug_Rev = (mean(ActionsPro_MPH.action2(:,41:80),2) - mean(ActionsPro_MPH.action1(:,41:80),2)) - ...
                (mean(ActionsPro_PLA.action2(:,41:80),2) - mean(ActionsPro_PLA.action1(:,41:80),2));
StimDrugPhase = StimDraug_Acq - StimDraug_Rev;
x = WMSpan; 
y = StimDrugPhase;
mdl = fitlm(x,y);
Xnew = linspace(2, 7.5, 1000)';
[ypred,yci] = predict(mdl, Xnew);
plot(Xnew, ypred, '-','Color',[0,1 , 0],'LineWidth',3) % fitted line
                hPatch = patch([Xnew ; flip(Xnew)], [yci(:,1); flip(yci(:,2))], ...
                    [0, 1, 0],'FaceAlpha',0.2,'EdgeAlpha', 0,'Linewidth',0.1); %  confidence intervals
                set(get(get(hPatch,'Annotation'),'LegendInformation'),...
                    'IconDisplayStyle','off'); % Exclude Patch from legend
                hold on
SCATTER2_Jit(WMSpan , StimDrugPhase, 'Working memory span', {'p(Correct) - p(InCorrect)';'for [MPH - PLA] x [Acq - Rev]'},[2, 7.5] , [-0.65 ,0.65])
xticks([2 3 4 5 6 7]);
yticks([-1 -0.5 0 0.5 1]);
set(gcf, 'Renderer', 'painters');
box off
% saveas(gcf,'DrugPhaseStim_Simulation','epsc')