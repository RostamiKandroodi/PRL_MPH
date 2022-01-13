% Main for simulation the task
% This script simulates the 2-option PRL task in order to find the
% optimal parameters for the optimal performance.

% By Mojtaba Rostami Kandroodi

% Start 10 nov 2018
% Last Update 1 July 2019
%--------------------------------------------------------------------------
clc; clear all; close all;
%% parameters
Acq = 1:40;
Rev = 41:80;
NOTrial = 80;
%% Model parameters
% The Optimal model for 2-option task is EWA which is equvalent with EWA+F with AlphaF=0
% We used EWA+F formulation to be able to simulate both models (EWA and EWA+F).
% We simulate the EWA+F model with the following ranges for parameters
model = 'EWA+F';
Rho = 0:0.05:1;
Phi = 0:0.05:1;
% AlphaF = 0.35;          % We used the median value of the fitted parameters across participants  
AlphaF = 0.0;             % By using AlphaF = 0 --> EWA+F model will be reduced to EWA model
Beta   = 4.5;             % We used the median value of the fitted parameters across participants

%% simulate data
NoSim = 100;
Conut = 1;
for i= 1:length(Beta)                    % loop over Beta
    for j= 1:length(AlphaF)              % loop over AlphaF
        for k=1:length(Rho)              % loop over Rho
            for l= 1:length(Phi)         % loop over Phi
                Para = [Rho(k), Phi(l), AlphaF(j), Beta(i)];      % Parameter set for EWA+F
                Parameters(Conut,:) = Para;
                for SimId=1:NoSim
                    [actions, outcome] = PRL2Simulation(model, Para);
                    Sdata{Conut,SimId}.actions = actions;
                    Sdata{Conut,SimId}.outcome = outcome;
                    SimIndex (Conut,SimId) = min(94.99,(0.75 * sum(actions(Acq)==1)+...
                                             0.25 * sum(actions(Acq)==2)+... % for Acq
                                             0.75 * sum(actions(Rev)==2)+...
                                             0.25 * sum(actions(Rev)==1)- 0.25* NOTrial)* 100/(0.5* NOTrial));    % For Rev
                end
                Conut = Conut+1;
            end
        end

%% save
        % Fig
        meanIndex = mean(SimIndex,2);
        PhiRho = reshape(meanIndex,[length(Phi),length(Rho)]);
        figure
        contourf(Rho,Phi,PhiRho)
        colorbar
        caxis([50 100])
        colormap('jet')
        xlabel('\rho','FontWeight','bold','FontSize',20);
        ylabel('\Phi','FontWeight','bold','FontSize',20);
        set(gcf, 'Renderer', 'painters');
    end
end
       