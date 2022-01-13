% Main for generating the PRL paper figures

% By Mojtaba Rostami Kandroodi
% Last update 31,05,2021
%--------------------------------------------------------------------------
%% Load data for all figures
clc; clear all; close all;
% Import data and extract WMSpan and BIS for sunject 1:102
% Add data path
data_dir  = '..\Data';
addpath(data_dir);
% Result directory
Result_folder = '..\Run_result\';
% load data
load('WMandBIS.mat')

HiWM = find(WMSpan > 4.5);      % Index of Hi working memmory span 
LoWM = find(WMSpan <= 4.5);     % Index of Low working memmory span
%--------------------------------------------------------------------------
load(strcat(data_dir,'\DATA'));
data = data.data;   % This data is after formatting NoSbj*1 cell
[Act_All, Act_PLA, Act_MPH,...
    Act_PLA_HI, Act_PLA_LO, Act_MPH_HI, Act_MPH_LO ]  = ...
    RawActions(data,HiWM, LoWM);
%--------------------------------------------------------------------------
% Mean Action Probablity during Acq and Rev for PLA and MPH
SessionLength = 40*ones(204,2);
[PercentagePLA, PercentageMPH] = ActionContengency(data,SessionLength);

% Add Auxiliary scripts path
addpath('..\Auxiliary')
[cb] = cbrewer('qual','Set2',20,'pchip');
clz{1} = repmat(cb(4,:),6,1);

% Average for PLA and MPLH
dataPULL{1,1} = (PercentagePLA(:,1)+PercentageMPH(:,1))/2;
dataPULL{2,1} = (PercentagePLA(:,2)+PercentageMPH(:,2))/2;
dataPULL{3,1} = (PercentagePLA(:,3)+PercentageMPH(:,3))/2;

dataPULL{1,2} = (PercentagePLA(:,5)+PercentageMPH(:,5))/2;
dataPULL{2,2} = (PercentagePLA(:,4)+PercentageMPH(:,4))/2;
dataPULL{3,2} = (PercentagePLA(:,6)+PercentageMPH(:,6))/2;
% for MPH-PLA
DiffPULL{1,1} = PercentageMPH(:,1)- PercentagePLA(:,1);
DiffPULL{2,1} = PercentageMPH(:,2)- PercentagePLA(:,2);
DiffPULL{3,1} = PercentageMPH(:,3)- PercentagePLA(:,3);

DiffPULL{1,2} = PercentageMPH(:,5)- PercentagePLA(:,5);
DiffPULL{2,2} = PercentageMPH(:,4)- PercentagePLA(:,4);
DiffPULL{3,2} = PercentageMPH(:,6)- PercentagePLA(:,6);
%--------------------------------------------------------------------------
% Wins-Stay and Lose-Shift
for i=1:204
    dat = data{i};
    choice = dat.actions;
    outcome= dat.outcome;
    SL = SessionLength(i,:);
    wsls(i,:)= WStLSt(choice,outcome, SL); % Stay | Win and Stay | Lose 
end
% Average of PLA and MPH for each subject  
wslsPULL{1,1} = (wsls(1:102,2)+wsls(103:204,2))/2   ; % Acq Loss-Stay
wslsPULL{1,2} = (wsls(1:102,4)+wsls(103:204,4))/2    ; % Rev Loss-Stay
wslsPULL{2,1} = (wsls(1:102,1)+wsls(103:204,1))/2   ; % Acq Win-Stay
wslsPULL{2,2} = (wsls(1:102,3)+wsls(103:204,3))/2   ; % Rev Win-Stay
%--------------------------------------------------------------------------
load(strcat(Result_folder,'\Interactions'));

%% Figures characterstics 
fig_position = [200 200 800 500]; % coordinates for figures
LineWidth = 1.5;
Fontsize = 20;
WW =5;
x=1:80;
n_PLA =102;
n_Hi = length(HiWM);
n_Lo = length(LoWM);

Purple = [0.85 0    0.85];
Yellow = [1    0.6  0   ];
Cyan   = [0    0.4  0.95];

cmap{1} = [51    34     136]/256; % Dark Blue
cmap{2} = [102   156    204]/256; % Light Blue
valString = {'75 %','25 %','50 %'};
nVal = length(valString);
cl{1} = repmat(cmap{1}, nVal, 1); % Acq
cl{2} = repmat(cmap{2}, nVal, 1); % Rev
%% Figure 1

%--------------------------------------------------------------------------
% C. Trial-by-trial choice. Trial-by-trial averaged probability of action 
% selection for each stimulus (average behaviour). 
% A sliding window with 5 trial width is used for smoothing.
font = 'Helvetica';
figure('pos',[100 100 800 500],'DefaultTextFontName', font, 'DefaultAxesFontName', font)
hold on;
% SmootPerSubject Multi Sessions
[Mean, SD] = SmootPerSubjectMulti(squeeze(Act_PLA(1,:,:)), squeeze(Act_MPH(1,:,:)),WW);
SE = SD/sqrt(n_PLA);
[l,p] = boundedline(x,Mean',SE','-r');
MeanBehavior(1,:)= Mean;

[Mean, SD] = SmootPerSubjectMulti(squeeze(Act_PLA(2,:,:)), squeeze(Act_MPH(2,:,:)),WW);
SE = SD/sqrt(n_PLA);
[l,p] = boundedline(x,Mean',SE','-b');
MeanBehavior(2,:)= Mean;

[Mean, SD] = SmootPerSubjectMulti(squeeze(Act_PLA(3,:,:)), squeeze(Act_MPH(3,:,:)),WW);
SE = SD/sqrt(n_PLA);
[l,p] = boundedline(x,Mean',SE','-g');
MeanBehavior(3,:)= Mean;
% save('MeanBehaviorPLAMPH.mat','MeanBehavior');
xlabel('Trial','FontSize',Fontsize,'FontWeight','bold')
ylabel('p(Stimulus)','FontSize',Fontsize,'FontWeight','bold')
PL = line([40 40], [0,1]);
PL.Color = [0.75, 0.75, 0.75];
PL.LineStyle = '--';
PL.LineWidth = LineWidth;
set(gcf, 'Renderer', 'painters');
xticks([0 20 40 60 80]);
yticks([0 0.25 0.50 0.75 1]);
set(gca,'FontSize',Fontsize)

% saveas(gcf,'PLAPlusMPHSmoot_test','epsc')

%--------------------------------------------------------------------------
% D. Average choice probability. Distribution of choice probability averaged
% within acquisition (dark blue) and reversal (light blue) phases.
% In both phases participants learnt to select mostly the ‘correct’ 
% (rewarded in 75%) option, but do significantly less well during the reversal phase

f1 = figure('Position', fig_position);
h = raincloud_lineplot_2_hdo(dataPULL,cl,1,1,valString);
set(gcf,'renderer','Painters')
set(gca, 'YLim', [2 37.5]);
set(gca, 'XLim', [-0.19 1.19]);
set(gca,'FontSize',Fontsize)

ylabel('Choice')
% saveas(gcf,'Rain-PLAMPH-AcqRev','epsc')

%--------------------------------------------------------------------------
% E. Feedback sensitivity. The degree to which people repeated a choice was
% modulated by the valence of the previous outcome for that choice:
% People were more likely to reselect a stimulus (‘stay’) after it had been 
% rewarded than after it was punished. This effect was weaker during the 
% reversal phase (less stay after a win, more stay after a loss), 
% in line with slower learning during reversal. 

wslsvalString = {'Loss','Win'};
wslsnVal = length(wslsvalString);
wslscl{1} = repmat(cmap{1}, wslsnVal, 1); 
wslscl{2} = repmat(cmap{2}, wslsnVal, 1); 

fig_position = [200 200 800 500]; % coordinates for figures
f1 = figure('Position', fig_position);
% Change : spacing     = 2 * max(cellfun(@max,f));
h = raincloud_lineplot_2_hdo(wslsPULL,wslscl,1,1,wslsvalString);
set(gcf,'renderer','Painters')
set(gca, 'YLim', [4 46]);
set(gca, 'XLim', [-0.19 1.19]);

% saveas(gcf,'WSLS for Loss and Win_RainCloud_PLAMPH','epsc')

%% clear  
clear wslsPULL dataPULL

%% Figure 2
%--------------------------------------------------------------------------
% C. MPH effects predicted by WM span. MPH increased the accuracy of selecting
% ‘correct’ option vs ‘incorrect’ option in acquisition phase more than reversal 
% phase for high WM span participants, yet decreased it for low WM span 
% participants (r=.26, p=.008). 

fig_position = [200 100 450 400]; % coordinates for figures

f3 = figure('Position', fig_position);
xx = WMSpan; 
y = InterStimDragPhase;
mdl = fitlm(xx,y);
Xnew = linspace(2, 7.5, 1000)';
[ypred,yci] = predict(mdl, Xnew);
plot(Xnew, ypred, '-','Color',[0,1 , 0],'LineWidth',3) % fitted line
                hPatch = patch([Xnew ; flip(Xnew)], [yci(:,1); flip(yci(:,2))], ...
                    [0, 1, 0],'FaceAlpha',0.2,'EdgeAlpha', 0,'Linewidth',0.1); %  confidence intervals
                set(get(get(hPatch,'Annotation'),'LegendInformation'),...
                    'IconDisplayStyle','off'); % Exclude Patch from legend
                hold on
SCATTER2_Jit(WMSpan , InterStimDragPhase, 'Working memory span', {'p(Rewarded) - p(Punished)';'for [MPH - PLA] x [Acq - Rev]'},[2, 7.5] , [-1.4 ,1.4])
xticks([2 3 4 5 6 7]);
yticks([-1 -0.5 0 0.5 1]);
set(gcf, 'Renderer', 'painters');
box off
% saveas(gcf,'DrugPhaseStim','epsc')


% C. Acq -------------------------------------------------------
fig_position = [200 100 450 400]; % coordinates for figures

f1 = figure('Position', fig_position);
xx = WMSpan; 
y = InterStimDragAcq;
mdl = fitlm(xx,y);
Xnew = linspace(2, 7.5, 1000)';
[ypred,yci] = predict(mdl, Xnew);
plot(Xnew, ypred, '-','Color',[0,1 , 0],'LineWidth',3) % fitted line
                hPatch = patch([Xnew ; flip(Xnew)], [yci(:,1); flip(yci(:,2))], ...
                    [0, 1, 0],'FaceAlpha',0.2,'EdgeAlpha', 0,'Linewidth',0.1); %  confidence intervals
                set(get(get(hPatch,'Annotation'),'LegendInformation'),...
                    'IconDisplayStyle','off'); % Exclude Patch from legend
                hold on
SCATTER2_Jit(WMSpan , InterStimDragAcq, 'Working memory span', {'p(Rewarded) - p(Punished)';'for [MPH - PLA]'},[2, 7.5] , [-1,1])
xticks([2 3 4 5 6 7]);
yticks([-1 -0.5 0 0.5 1]);
set(gcf, 'Renderer', 'painters');
box off
% saveas(gcf,'DrugStim(Acq)','epsc')

% C.Rev -------------------------------------------------------
f2 = figure('Position', fig_position);
xx = WMSpan; 
y = InterStimDragRev;
mdl = fitlm(xx,y);
Xnew = linspace(2, 7.5, 1000)';
[ypred,yci] = predict(mdl, Xnew);
plot(Xnew, ypred, '-','Color',[0,1 , 0],'LineWidth',3) % fitted line
                hPatch = patch([Xnew ; flip(Xnew)], [yci(:,1); flip(yci(:,2))], ...
                    [0, 1, 0],'FaceAlpha',0.2,'EdgeAlpha', 0,'Linewidth',0.1); %  confidence intervals
                set(get(get(hPatch,'Annotation'),'LegendInformation'),...
                    'IconDisplayStyle','off'); % Exclude Patch from legend
                hold on
SCATTER2_Jit(WMSpan , InterStimDragRev, 'Working memory span', {'p(Rewarded) - p(Punished)';'for [MPH - PLA]'},[2, 7.5] , [-1,1])
xticks([2 3 4 5 6 7]);
yticks([-1 -0.5 0 0.5 1]);
set(gcf, 'Renderer', 'painters');
box off
% saveas(gcf,'DrugStim(Rev)','epsc')

%--------------------------------------------------------------------------
% B. Average trial-by-trial choice. Trial-by-trial averaged probability of 
% action selection for each stimulus (median split based on WM span). 
% Top panel: high WM group (n=48), probability of ‘Correct’ action selection
% increased under MPH (dash line) in comparison to Placebo (solid line) 
% during the acquisition phase. Bottom panel: low WM group(n=54), probability 
% of ‘Correct’ action selection decreased under MPH in comparison to Placebo
% during the acquisition phase. A sliding window with 5 trial width is used for smoothing. 

% B. HI  -------------------------------------------------------

LineWidth = 1;
figure('pos',[100 100 800 500])
hold on;
[Mean, SD] = SmootPerSubject(squeeze(Act_PLA_HI(1,:,:)),WW);
SE = SD/sqrt(n_Hi);
[l,p] = boundedline(x,Mean',SE','-r');
[Mean, SD] = SmootPerSubject(squeeze(Act_PLA_HI(2,:,:)),WW);
SE = SD/sqrt(n_Hi);
[l,p] = boundedline(x,Mean',SE','-b');
[Mean, SD] = SmootPerSubject(squeeze(Act_PLA_HI(3,:,:)),WW);
SE = SD/sqrt(n_Hi);
[l,p] = boundedline(x,Mean',SE','-g');


[Mean, SD] = SmootPerSubject(squeeze(Act_MPH_HI(1,:,:)),WW);
SE = SD/sqrt(n_Hi);
[l,p] = boundedline(x,Mean',SE','--r');
[Mean, SD] = SmootPerSubject(squeeze(Act_MPH_HI(2,:,:)),WW);
SE = SD/sqrt(n_Hi);
[l,p] = boundedline(x,Mean',SE','--b');
[Mean, SD] = SmootPerSubject(squeeze(Act_MPH_HI(3,:,:)),WW);
SE = SD/sqrt(n_Hi);
[l,p] = boundedline(x,Mean',SE','--g');
% title('High')
xlabel('Trial','FontSize',Fontsize,'FontWeight','bold')
ylabel('p(Stimulus)','FontSize',Fontsize,'FontWeight','bold')
PL = line([40 40], [0,1]);
PL.Color = [0.75, 0.75, 0.75];
PL.LineStyle = '--';
PL.LineWidth = LineWidth;
set(gcf, 'Renderer', 'painters');
xticks([0 20 40 60 80]);
yticks([0 0.25 0.50 0.75 1]);
set(gca,'FontSize',Fontsize)
% saveas(gcf,'PLAMPHSmoot_HI','epsc')


%--------------------------------------------------------------------------
% Average Behavior PLA solid and MPH dash 
% LO WM
figure('pos',[100 100 800 500])
hold on;
[Mean, SD] = SmootPerSubject(squeeze(Act_PLA_LO(1,:,:)),WW);
SE = SD/sqrt(n_Lo);
[l,p] = boundedline(x,Mean',SE','-r');
[Mean, SD] = SmootPerSubject(squeeze(Act_PLA_LO(2,:,:)),WW);
SE = SD/sqrt(n_Lo);
[l,p] = boundedline(x,Mean',SE','-b');
[Mean, SD] = SmootPerSubject(squeeze(Act_PLA_LO(3,:,:)),WW);
SE = SD/sqrt(n_Lo);
[l,p] = boundedline(x,Mean',SE','-g');


[Mean, SD] = SmootPerSubject(squeeze(Act_MPH_LO(1,:,:)),WW);
SE = SD/sqrt(n_Lo);
[l,p] = boundedline(x,Mean',SE','--r');
[Mean, SD] = SmootPerSubject(squeeze(Act_MPH_LO(2,:,:)),WW);
SE = SD/sqrt(n_Lo);
[l,p] = boundedline(x,Mean',SE','--b');
[Mean, SD] = SmootPerSubject(squeeze(Act_MPH_LO(3,:,:)),WW);
SE = SD/sqrt(n_Lo);
[l,p] = boundedline(x,Mean',SE','--g');
% title('Low')
xlabel('Trial','FontSize',Fontsize,'FontWeight','bold')
ylabel('p(Stimulus)','FontSize',Fontsize,'FontWeight','bold')
PL = line([40 40], [0,1]);
PL.Color = [0.75, 0.75, 0.75];
PL.LineStyle = '--';
PL.LineWidth = LineWidth;
set(gcf, 'Renderer', 'painters');
xticks([0 20 40 60 80]);
yticks([0 0.25 0.50 0.75 1]);
set(gca,'FontSize',Fontsize)
% saveas(gcf,'PLAMPHSmoot_LO','epsc')


%--------------------------------------------------------------------------
% A. No main effect of MPH on average choice. Distribution of difference of 
% action selection probability between two sessions (MPH-placebo) for 
% acquisition and reversal phase demonstrated in dark and light blue, respectively.
fig_position = [200 200 800 500]; 
figure('Position', fig_position);
% change: spacing     = 1.6 * max(cellfun(@max,f));
h = raincloud_lineplot_2_hdo(DiffPULL,cl,1,1,valString);
set(gcf,'renderer','Painters')
set(gca, 'YLim', [0.5 22]);
set(gca, 'XLim', [-1 1]);
ylabel('Choice')
yticks([0 0.50 1]);
set(gca,'FontSize',Fontsize)
% saveas(gcf,'Rain-MPH-PLA','epsc')

%% Figure 3

%--------------------------------------------------------------------------
% A. Model comparison (Base models)
load(strcat(Result_folder,'\hbi_1-4'));

FontSize = 20;
figure('pos',[100 100 800 500])
a=[cbm.output.model_frequency' zeros(4,1) ];
b=[zeros(4,1)    cbm.output.protected_exceedance_prob' ];
[AX,H1,H2] =plotyy([1:4],a, [1:4],b, 'bar', 'bar');
AX(1).YGrid = 'on';
AX(1).GridLineStyle = '-';
xticks(AX,[1 2 3 4]);
ylim (AX(1), [0,1])
ylim (AX(2), [0,1])

ylabel(AX(1),'Model frequency (%)','FontSize', FontSize,'FontWeight','bold')
ylabel(AX(2),'Protected exceedance probability', 'FontSize', FontSize,'FontWeight','bold')
set(gcf, 'Renderer', 'painters');
yticks(AX(1),[0 0.2 0.4 0.6 0.80 1]);
yticks(AX(2),[0 0.2 0.4 0.6 0.80 1]);
xticklabels(AX,{  'EWA', 'EWA+F', 'Hybrid', 'Hybrid+F'});
set(gca,'FontSize',FontSize)

% saveas(gcf,'Model Comparision BaseModels','epsc')

%% Figure 4
%--------------------------------------------------------------------------
% A. Model comparison (MPH models)
load(strcat(Result_folder,'\hbi_2a-d'));
FontSize = 20;
figure('pos',[100 100 800 500])
a=[cbm.output.model_frequency' zeros(5,1) ];
b=[zeros(5,1)    cbm.output.protected_exceedance_prob' ];
[AX,H1,H2] =plotyy([1:5],a, [1:5],b, 'bar', 'bar');
AX(1).YGrid = 'on';
AX(1).GridLineStyle = '-';
xticks(AX,[1 2 3 4 5]);
ylim (AX(1), [0,1])
ylim (AX(2), [0,1])

ylabel(AX(1),'Model frequency (%)','FontSize', FontSize,'FontWeight','bold')
ylabel(AX(2),'Protected exceedance probability', 'FontSize', FontSize,'FontWeight','bold')
set(gcf, 'Renderer', 'painters');
yticks(AX(1),[0 0.2 0.4 0.6 0.80 1]);
yticks(AX(2),[0 0.2 0.4 0.6 0.80 1]);
xticklabels(AX,{  'Baseline', '\Delta\rho', '\Delta\phi', '\Delta\alpha_f', '\Delta\beta' });
set(gca,'FontSize',FontSize)

% saveas(gcf,'Model Comparision delataModels','epsc')

%--------------------------------------------------------------------------
% E. Methylphenidate changes inverse learning rate as a function of working memory span
load('..\Run_result\M2b_EWA+F2_lap.mat')

% ttest Phi_placebo. Phi_MPH
Phi_PLA = 1./(1+exp(-cbm.output.parameters(:,2)));
Phi_MPH = 1./(1+exp(-cbm.output.parameters(:,4)));
[h,p,ci,stats] = ttest(Phi_PLA,Phi_MPH);

DeltaPhi = 1./(1+exp(-cbm.output.parameters(:,4))) - 1./(1+exp(-cbm.output.parameters(:,2)));

fig_position = [200 100 450 400]; % coordinates for figures

f4 = figure('Position', fig_position);
x = WMSpan; 
y = DeltaPhi;
mdl = fitlm(x,y);
Xnew = linspace(2, 7.5, 1000)';
[ypred,yci] = predict(mdl, Xnew);
plot(Xnew, ypred, '-','Color',[0,1 , 0],'LineWidth',3) % fitted line
                hPatch = patch([Xnew ; flip(Xnew)], [yci(:,1); flip(yci(:,2))], ...
                    [0, 1, 0],'FaceAlpha',0.2,'EdgeAlpha', 0,'Linewidth',0.1); %  confidence intervals
                set(get(get(hPatch,'Annotation'),'LegendInformation'),...
                    'IconDisplayStyle','off'); % Exclude Patch from legend
                hold on
SCATTER2_Jit(WMSpan , DeltaPhi, 'Working memory span', {'','\Delta_\phi (MPH-Pacebo)'},[2, 7.5] , [-1,1])
xticks([2 3 4 5 6 7]);
yticks([-1 -0.5 0 0.5 1]);
% set(gca,'FontSize',Fontsize)
set(gcf, 'Renderer', 'painters');
box off
% saveas(gcf,'WMSpanVSdeltaPHI','epsc')

%--------------------------------------------------------------------------
% F. Methylphenidate-induced effect on raw performance scores

fig_position = [200 100 450 400]; % coordinates for figures
f4 = figure('Position', fig_position);
x = InterStimDragPhase; 
y = DeltaPhi;
mdl = fitlm(x,y);
Xnew = linspace(-1.2, 1.2, 1000)';
[ypred,yci] = predict(mdl, Xnew);
plot(Xnew, ypred, '-','Color',[0,1 , 0],'LineWidth',3) % fitted line
                hPatch = patch([Xnew ; flip(Xnew)], [yci(:,1); flip(yci(:,2))], ...
                    [0, 1, 0],'FaceAlpha',0.2,'EdgeAlpha', 0,'Linewidth',0.1); %  confidence intervals
                set(get(get(hPatch,'Annotation'),'LegendInformation'),...
                    'IconDisplayStyle','off'); % Exclude Patch from legend
                hold on
SCATTER2(InterStimDragPhase,DeltaPhi, {'p(Correct) - p(InCorrect)'; 'for [MPH - PLA] x [Acq - Rev]'},{'','\Delta_\phi (MPH-Pacebo)'} ,[-1.2 ,1.2], [-1,1])
xticks([-1 0 1]);
yticks([-1 -0.5 0 0.5 1]);
set(gcf, 'Renderer', 'painters');
box off
% saveas(gcf,'DrugPhaseStimVSdeltaPHI','epsc')


