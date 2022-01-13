% Mian for fitting base models and comparison using HBI toolbox
% Simultaneously model fitting to PLA and MPH with the same set of parameters
% Implemented by Mojtaba Rostami Kandroodi
% Start Sep 2018
% Last Update Feb 2020
%--------------------------------------------------------------------------
 clc; clear all; close all;
% add code dir. to your path
Current_dir = fileparts(which('Main_Fit_BaseModels'));
addpath(Current_dir);
% add HBI to your path
% Download CBM toolbox, which is based on Piray at al. 2019,
% Hierarchical Bayesian inference for concurrent model fitting and comparison for group studies. 
% PLoS computational biology, 15(6), e1007043.
% and put it on HBI folder.
% https://github.com/payampiray/cbm
HBI_dir = '..\HBI';
addpath(HBI_dir);
% Add data path
data_dir  = '..\Data';
addpath(data_dir);
% load data
data_fName = 'DATA';
load(data_fName);
SubInfo = 'PLA and MPH';
% format data,  Nx1 cell which contains data for both sessions, N: Num of subjects 
% make a structure which contain PLA and MPH
NoSub=102; % No. of Subjects
for i=1:NoSub
    dat{i,1}.PLA.actions = data.data{i}.actions;
    dat{i,1}.PLA.outcome = data.data{i}.outcome;
    dat{i,1}.MPH.actions = data.data{i+NoSub}.actions;
    dat{i,1}.MPH.outcome = data.data{i+NoSub}.outcome;
end
data = dat;
% Go to result folder
Result_folder = '..\Run_result\';
cd(Result_folder);
% Specify model and its features 
% M1: EWA
% M2: EWA+f
% M3: Hybrid
% M4: Hybrid_F

%% Models
% M1: EWA
model_1 = @SimSamodel_EWA;
d1      = 3; % Degree of freedom -number of free parameters in the model (Rho, Phi, Beta)
% Prior for parameters
d1_mean = zeros(d1,1);
d1_var  = 10;
prior_1 = struct('mean',d1_mean,'variance',d1_var);
% Output file name
fname_lap_1 = strcat('M1_EWA_lap', '.mat');

% M2: EWA+F
model_2 = @SimSamodel_EWA_F;
d2      = 4; % Degree of freedom -number of free parameters in the model (Rho, Phi, forgetting rate, Beta)
% Prior for parameters
d2_mean = zeros(d2,1);
d2_var  = 10;
prior_2 = struct('mean',d2_mean,'variance',d2_var);
% Output file name
fname_lap_2 = strcat('M2_EWA+F_lap', '.mat');

% M3: Hybrid
model_3 = @SimSamodel_Hybrid;
d3      = 3; % Degree of freedom -number of free parameters in the model (Kapa, Eta, Beta)
% Prior for parameters
d3_mean = zeros(d3,1);
d3_var  = 10;
prior_3 = struct('mean',d3_mean,'variance',d3_var);
% Output file name
fname_lap_3 = strcat('M3_Hybrid_lap', '.mat');

% M4: Hybrid+F 
model_4 = @SimSamodel_Hybrid_F;
d4      = 4; % Degree of freedom -number of free parameters in the model (Kapa, Eta, forgetting rate, Beta)
% Prior for parameters
d4_mean = zeros(d4,1);
d4_var  = 10;
prior_4 = struct('mean',d4_mean,'variance',d4_var);
% Output file name
fname_lap_4 = strcat('M4_Hybrid+F_lap', '.mat');

%% parameter estimation and model comparison
cbm_lap(data, model_1, prior_1, fname_lap_1);
cbm_lap(data, model_2, prior_2, fname_lap_2);
cbm_lap(data, model_3, prior_3, fname_lap_3);
cbm_lap(data, model_4, prior_4, fname_lap_4);

models = {model_1, model_2, model_3, model_4};
fcbm_maps = {fname_lap_1, fname_lap_2, fname_lap_3, fname_lap_4};
fname_hbi = 'hbi_1-4.mat';
cbm_hbi(data,models,fcbm_maps,fname_hbi);
cbm_hbi_null(data,fname_hbi);

