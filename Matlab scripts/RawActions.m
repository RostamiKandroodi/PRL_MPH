function [Act_All, Act_PLA, Act_MPH, Act_PLA_HI, Act_PLA_LO,  Act_MPH_HI, Act_MPH_LO ] = RawActions(data, HI, LO)
% Trial by trial actions given Raw data

% INPUT
% dat    : subject behavioral data
%           dat.actions is actions in each trial
%           dat.outcome is environment feedback

% OUTPUT
% Act_All : average action probablity as a function of trials for all subject during the both session
% Act_PLA : ... during the PLA session
% Act_MPH : ... during the MPH session
%          size of this outputs are NoActions * NoTrials : 3 * nSub* 80 for each
%          trial, 1 means the subject selected that action and 0 means the
%          subject selected one of the other actions
% Act_PLA_HI : 
% Act_PLA_LO :
% Act_MPH_HI :
% Act_MPH_LO :

% By Mojtaba Rostami Kandroodi
% Last Update : 28 August 2019
%--------------------------------------------------------------------------
acq = 1:40;
rev = 41:80;
AllT= 1:80;
NTrials = 80;
NoSub= 102; % No. of Subjects


% All 1:204
for i=1:2*NoSub
    Actions_All(i,:) = data{i,1}.actions;
end

for j=1:NTrials
    Act_All (1,:,:) = double(Actions_All==1);
    Act_All (2,:,:) = double(Actions_All==2);
    Act_All (3,:,:) = double(Actions_All==3);
end


% PLA 1:102
Act_PLA = Act_All(:,1:102,:);
% PLA HI
Act_PLA_HI = Act_PLA(:,HI,:);
% PLA Lo
Act_PLA_LO = Act_PLA(:,LO,:);


% MPH 103:204
Act_MPH = Act_All(:,103:204,:);
% MPH HI
Act_MPH_HI = Act_MPH(:,HI,:);
% MPH Lo
Act_MPH_LO = Act_MPH(:,LO,:);
