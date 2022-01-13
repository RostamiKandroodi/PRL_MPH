% Main for simulation of the task
% By Mojtaba Rostami Kandroodi

% Start 15 Sep 2018
% Last Update 16 june 2021
%--------------------------------------------------------------------------
clc; clear all; close all;

%% Load model parameters
% 1) EWA+F Delta-Phi
load('..\Run_result\M2b_EWA+F2_lap.mat')
% parameter transform
Parameters(:,1)  = 1./(1+exp(-cbm.output.parameters(:,1)));
Parameters(:,2)  = 1./(1+exp(-cbm.output.parameters(:,2)));
Parameters(:,3)  = 1./(1+exp(-cbm.output.parameters(:,3)));
Parameters(:,4)  = 1./(1+exp(-cbm.output.parameters(:,4)));
Parameters(:,5)  = exp(cbm.output.parameters(:,5));
model = 'EWA+F';
% -------------------------------------------------------------------------

%% simulate data
acq = 1:40;    % Acquisition
rev = 41:80;   % Reversal
AllT= 1:80;    % All Trials
trials = 80;
NoSub=102; % No. of Subjects
NoSim = 100;
for i=1:NoSub
    ParaPLA = Parameters(i,[1,2,3,5]);      % For EWA+F
    for j=1:NoSim
        [actions, outcome] = PRL3Simulation(model, ParaPLA);
        Sdata{i,j}.PLA.actions = actions;
        Sdata{i,j}.PLA.outcome = outcome;
        % Choice percentage
        SimulationFeature.PLA.preChoice_1_acq(i,j) = length(find(Sdata{i,j}.PLA.actions(acq) == 1))/ length(acq);
        SimulationFeature.PLA.preChoice_2_acq(i,j) = length(find(Sdata{i,j}.PLA.actions(acq) == 2))/ length(acq);
        SimulationFeature.PLA.preChoice_3_acq(i,j) = length(find(Sdata{i,j}.PLA.actions(acq) == 3))/ length(acq);
        SimulationFeature.PLA.preChoice_1_rev(i,j) = length(find(Sdata{i,j}.PLA.actions(rev) == 1))/ length(rev);
        SimulationFeature.PLA.preChoice_2_rev(i,j) = length(find(Sdata{i,j}.PLA.actions(rev) == 2))/ length(rev);
        SimulationFeature.PLA.preChoice_3_rev(i,j) = length(find(Sdata{i,j}.PLA.actions(rev) == 3))/ length(rev);
        SimulationFeature.PLA.preChoice_1(i,j)     = length(find(Sdata{i,j}.PLA.actions == 1))/ length(AllT);
        SimulationFeature.PLA.preChoice_2(i,j)     = length(find(Sdata{i,j}.PLA.actions == 2))/ length(AllT);
        SimulationFeature.PLA.preChoice_3(i,j)     = length(find(Sdata{i,j}.PLA.actions == 3))/ length(AllT);
        
        % Total performance
        SimulationFeature.PLA.TotalPerfo(i,j)      = length(find(Sdata{i,j}.PLA.outcome ==1))/trials;
    end
    % Mean Choice percentage
    SimulationFeature.PLA.meanpreChoice_1_acq(i,1) = mean(SimulationFeature.PLA.preChoice_1_acq(i,:));
    SimulationFeature.PLA.meanpreChoice_2_acq(i,1) = mean(SimulationFeature.PLA.preChoice_2_acq(i,:));
    SimulationFeature.PLA.meanpreChoice_3_acq(i,1) = mean(SimulationFeature.PLA.preChoice_3_acq(i,:));
    SimulationFeature.PLA.meanpreChoice_1_rev(i,1) = mean(SimulationFeature.PLA.preChoice_1_rev(i,:));
    SimulationFeature.PLA.meanpreChoice_2_rev(i,1) = mean(SimulationFeature.PLA.preChoice_2_rev(i,:));
    SimulationFeature.PLA.meanpreChoice_3_rev(i,1) = mean(SimulationFeature.PLA.preChoice_3_rev(i,:));
    SimulationFeature.PLA.meanpreChoice_1(i,1)     = mean(SimulationFeature.PLA.preChoice_1(i,:));
    SimulationFeature.PLA.meanpreChoice_2(i,1)     = mean(SimulationFeature.PLA.preChoice_2(i,:));
    SimulationFeature.PLA.meanpreChoice_3(i,1)     = mean(SimulationFeature.PLA.preChoice_3(i,:));
    
    % Mean Total performance
    SimulationFeature.PLA.meanTotalPerfo(i,1)      = mean(SimulationFeature.PLA.TotalPerfo(i,:));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    ParaMPH = Parameters(i,[1,4,3,5]);      % For EWA+F
    for j=1:NoSim
        [actions, outcome] = PRL3Simulation(model, ParaMPH);
        Sdata{i,j}.MPH.actions = actions;
        Sdata{i,j}.MPH.outcome = outcome;
        % Choice percentage
        SimulationFeature.MPH.preChoice_1_acq(i,j) = length(find(Sdata{i,j}.MPH.actions(acq) == 1))/ length(acq);
        SimulationFeature.MPH.preChoice_2_acq(i,j) = length(find(Sdata{i,j}.MPH.actions(acq) == 2))/ length(acq);
        SimulationFeature.MPH.preChoice_3_acq(i,j) = length(find(Sdata{i,j}.MPH.actions(acq) == 3))/ length(acq);
        SimulationFeature.MPH.preChoice_1_rev(i,j) = length(find(Sdata{i,j}.MPH.actions(rev) == 1))/ length(rev);
        SimulationFeature.MPH.preChoice_2_rev(i,j) = length(find(Sdata{i,j}.MPH.actions(rev) == 2))/ length(rev);
        SimulationFeature.MPH.preChoice_3_rev(i,j) = length(find(Sdata{i,j}.MPH.actions(rev) == 3))/ length(rev);
        SimulationFeature.MPH.preChoice_1(i,j)     = length(find(Sdata{i,j}.MPH.actions == 1))/ length(AllT);
        SimulationFeature.MPH.preChoice_2(i,j)     = length(find(Sdata{i,j}.MPH.actions == 2))/ length(AllT);
        SimulationFeature.MPH.preChoice_3(i,j)     = length(find(Sdata{i,j}.MPH.actions == 3))/ length(AllT);
        % Total performance
        SimulationFeature.MPH.TotalPerfo(i,j)      = length(find(Sdata{i,j}.MPH.outcome ==1))/trials;
    end
    % Mean Choice percentage
    SimulationFeature.MPH.meanpreChoice_1_acq(i,1) = mean(SimulationFeature.MPH.preChoice_1_acq(i,:));
    SimulationFeature.MPH.meanpreChoice_2_acq(i,1) = mean(SimulationFeature.MPH.preChoice_2_acq(i,:));
    SimulationFeature.MPH.meanpreChoice_3_acq(i,1) = mean(SimulationFeature.MPH.preChoice_3_acq(i,:));
    SimulationFeature.MPH.meanpreChoice_1_rev(i,1) = mean(SimulationFeature.MPH.preChoice_1_rev(i,:));
    SimulationFeature.MPH.meanpreChoice_2_rev(i,1) = mean(SimulationFeature.MPH.preChoice_2_rev(i,:));
    SimulationFeature.MPH.meanpreChoice_3_rev(i,1) = mean(SimulationFeature.MPH.preChoice_3_rev(i,:));
    SimulationFeature.MPH.meanpreChoice_1(i,1)     = mean(SimulationFeature.MPH.preChoice_1(i,:));
    SimulationFeature.MPH.meanpreChoice_2(i,1)     = mean(SimulationFeature.MPH.preChoice_2(i,:));
    SimulationFeature.MPH.meanpreChoice_3(i,1)     = mean(SimulationFeature.MPH.preChoice_3(i,:));
    % Mean Total performance
    SimulationFeature.MPH.meanTotalPerfo(i,1)      = mean(SimulationFeature.MPH.TotalPerfo(i,:));
    
    %___________ Between two session calculations__________________________
    % random selection between NoSim simulation for each subject
    RaInd = randi(NoSim); % Random selection between multiple simulation for each subject
        
%     % Stim * Drag
%     SimulationFeature.StimDrag(i,1)= ( SimulationFeature.MPH.preChoice_1_acq(i,RaInd) - SimulationFeature.MPH.preChoice_2_acq(i,RaInd) ) ... % MPH
%                                    - ( SimulationFeature.PLA.preChoice_1_acq(i,RaInd) - SimulationFeature.PLA.preChoice_2_acq(i,RaInd) ) ;   % PLA
%     
%     % Stim * Drag
%     SimulationFeature.StimDragPhase(i,1) = ( ( SimulationFeature.MPH.preChoice_1_acq(i,RaInd) - SimulationFeature.MPH.preChoice_2_acq(i,RaInd) )  ... % MPH_Acq
%                                             -( SimulationFeature.MPH.preChoice_1_rev(i,RaInd) - SimulationFeature.MPH.preChoice_2_rev(i,RaInd) ) )... % MPH_Rev
%                                           -( ( SimulationFeature.PLA.preChoice_1_acq(i,RaInd) - SimulationFeature.PLA.preChoice_2_acq(i,RaInd) )  ... % PLA_Acq
%                                             -( SimulationFeature.PLA.preChoice_1_rev(i,RaInd) - SimulationFeature.PLA.preChoice_2_rev(i,RaInd) ) );   % PLA_Rev
    
    % Stim * Drag
    SimulationFeature.StimDragAcq(i,1)= ( mean(SimulationFeature.MPH.preChoice_1_acq(i,:)) - mean(SimulationFeature.MPH.preChoice_2_acq(i,:)) ) ... % MPH
                                   - ( mean(SimulationFeature.PLA.preChoice_1_acq(i,:)) - mean(SimulationFeature.PLA.preChoice_2_acq(i,:)) ) ;   % PLA
    
    % Stim * Drag
    SimulationFeature.StimDragPhase(i,1) = ( ( mean(SimulationFeature.MPH.preChoice_1_acq(i,:)) - mean(SimulationFeature.MPH.preChoice_2_acq(i,:)) )  ... % MPH_Acq
                                            -( mean(SimulationFeature.MPH.preChoice_1_rev(i,:)) - mean(SimulationFeature.MPH.preChoice_2_rev(i,:)) ) )... % MPH_Rev
                                          -( ( mean(SimulationFeature.PLA.preChoice_1_acq(i,:)) - mean(SimulationFeature.PLA.preChoice_2_acq(i,:)) )  ... % PLA_Acq
                                            -( mean(SimulationFeature.PLA.preChoice_1_rev(i,:)) - mean(SimulationFeature.PLA.preChoice_2_rev(i,:)) ) );   % PLA_Rev
    
    % Stim * Drag
    SimulationFeature.StimDragRev(i,1)= ( mean(SimulationFeature.MPH.preChoice_1_rev(i,:)) - mean(SimulationFeature.MPH.preChoice_2_rev(i,:)) ) ... % MPH
                                      - ( mean(SimulationFeature.PLA.preChoice_1_rev(i,:)) - mean(SimulationFeature.PLA.preChoice_2_rev(i,:)) ) ;   % PLA
    
    % Stim * Drag (All)                    
    SimulationFeature.StimDrag(i,1)= ( SimulationFeature.MPH.meanpreChoice_1(i,1) - SimulationFeature.MPH.meanpreChoice_2(i,1) ) ... % MPH
                                   - ( SimulationFeature.PLA.meanpreChoice_1(i,1) - SimulationFeature.PLA.meanpreChoice_2(i,1) ) ;   % PLA
i
end


%% Save
% save('../Run_result/Simulation_EWA+F2.mat');

