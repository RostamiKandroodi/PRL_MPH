function [All, PLA, MPH] = SimulationRawActionProbablity2(data)
% Trial by trial action probability given Raw data

% INPUT
% dat    : subject behavioral data
%           data{i,j}.PLA/MPH.actions is actions in each trial
%           data{i,j}.PLA/MPH.outcome is environment feedback

% OUTPUT
% Pro : Actions probablity, is a k*n matrix, n is k is % number of actions and number of trials

% By Mojtaba Rostami Kandroodi
% Last Update : 13 Nov 2018
%--------------------------------------------------------------------------
acq = 1:40;
rev = 41:80;
AllT= 1:80;
NTrials = 80;
NoSub= 102; % No. of Subjects
NoSim = 30; % No of Simulations % It is 30 for Fig results

for i=1:NoSub
    for isim =1:NoSim
        Subjecti_PLA(isim,:) = data{i,isim}.PLA.actions;
        Subjecti_MPH(isim,:) = data{i,isim}.MPH.actions;
    end
    
    for j=1:NTrials
        Pro_PLA_1(i,j) = sum( Subjecti_PLA(:,j)==1) / (NoSim);
        Pro_PLA_2(i,j) = sum( Subjecti_PLA(:,j)==2) / (NoSim);
        Pro_PLA_3(i,j) = sum( Subjecti_PLA(:,j)==3) / (NoSim);
        
        Pro_MPH_1(i,j) = sum( Subjecti_MPH(:,j)==1) / (NoSim);
        Pro_MPH_2(i,j) = sum( Subjecti_MPH(:,j)==2) / (NoSim);
        Pro_MPH_3(i,j) = sum( Subjecti_MPH(:,j)==3) / (NoSim);
    end
end

All.action1 = [Pro_PLA_1; Pro_MPH_1];
All.action2 = [Pro_PLA_2; Pro_MPH_2];
All.action3 = [Pro_PLA_3; Pro_MPH_3];

PLA.action1 = Pro_PLA_1 ;
PLA.action2 = Pro_PLA_2 ;
PLA.action3 = Pro_PLA_3 ;

MPH.action1 = Pro_MPH_1 ;
MPH.action2 = Pro_MPH_2 ;
MPH.action3 = Pro_MPH_3 ;


% % All 1:204
% for isim =1:100
%     
%     
%     for j=1:NTrials
%         Pro_All (1,j) = sum( Actions_All(:,j)==1) / (2*NoSub);
%         Pro_All (2,j) = sum( Actions_All(:,j)==2) / (2*NoSub);
%         Pro_All (3,j) = sum( Actions_All(:,j)==3) / (2*NoSub);
%     end
%     
%     All.action1(isim,:) = Pro_All (1,:);
%     All.action2(isim,:) = Pro_All (2,:);
%     All.action3(isim,:) = Pro_All (3,:);
%     
%     
%     
%     % PLA 1:102
%     for i=1:NoSub
%         Actions_PLA(i,:) = data{i,isim}.PLA.actions;
%     end
%     
%     for j=1:NTrials
%         Pro_PLA (1,j) = sum( Actions_PLA(:,j)==1) / NoSub;
%         Pro_PLA (2,j) = sum( Actions_PLA(:,j)==2) / NoSub;
%         Pro_PLA (3,j) = sum( Actions_PLA(:,j)==3) / NoSub;
%     end
%     
%     PLA.action1(isim,:) = Pro_PLA (1,:);
%     PLA.action2(isim,:) = Pro_PLA (2,:);
%     PLA.action3(isim,:) = Pro_PLA (3,:);
%     
%     
%     % MPH 103:204
%     for i= 1:NoSub
%         Actions_MPH(i,:) = data{i ,isim}.MPH.actions;
%     end
%     
%     for j=1:NTrials
%         Pro_MPH (1,j) = sum( Actions_MPH(:,j)==1) / NoSub;
%         Pro_MPH (2,j) = sum( Actions_MPH(:,j)==2) / NoSub;
%         Pro_MPH (3,j) = sum( Actions_MPH(:,j)==3) / NoSub;
%     end
%     
%     MPH.action1(isim,:) = Pro_MPH (1,:);
%     MPH.action2(isim,:) = Pro_MPH (2,:);
%     MPH.action3(isim,:) = Pro_MPH (3,:);
end
%__________________________________________________________________________
