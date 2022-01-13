% Mian for fitting Drug effect models and comparison using HBI toolbox
% Simultaneously model fitting to PLA and MPH 
% Implemented by Mojtaba Rostami Kandroodi
% Start Sep 2018
% Last Update Feb 2020
%--------------------------------------------------------------------------
 clc; clear all; close all;
% add code dir. to your path
Current_dir = fileparts(which('Main_Fit_MPHModels'));
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
% winning base model is EWA+f
% M2:  EWA+f d = 0 (same parameters) 
% M2a: EWA+f d_rho
% M2b: EWA+f d_phi
% M2c: EWA+f d_f
% M2d: EWA+f d_beta

%% Models
% M2: EWA+f
model_2 = @SimSamodel_EWA_F;
d2      = 4; % Degree of freedom -number of free parameters in the model (Rho, Phi, forgetting rate, Beta)
% Prior for parameters
d2_mean = zeros(d2,1);
d2_var  = 10;
prior_2 = struct('mean',d2_mean,'variance',d2_var);
% Output file name
fname_lap_2 = strcat('M2_EWA+F_lap', '.mat');

% M2a: EWA+f d_rho
model_2a = @Simmodel_EWA_F1;
d2a      = 5; % Degree of freedom -number of free parameters in the model (Rho_PLA, Phi, forgetting rate, Rho_MPH, Beta)
% Prior for parameters
d2a_mean = zeros(d2a,1);
d2a_var  = 10;
prior_2a = struct('mean',d2a_mean,'variance',d2a_var);
% Output file name
fname_lap_2a = strcat('M2a_EWA+F1_lap', '.mat');

% M2b: EWA+f d_phi
model_2b = @Simmodel_EWA_F2;
d2b      = 5; % Degree of freedom -number of free parameters in the model (Rho, Phi_PLA, forgetting rate, Phi_MPH, Beta)
% Prior for parameters
d2b_mean = zeros(d2b,1);
d2b_var  = 10;
prior_2b = struct('mean',d2b_mean,'variance',d2b_var);
% Output file name
fname_lap_2b = strcat('M2b_EWA+F2_lap', '.mat');

% M2c: EWA+f d_f
model_2c = @Simmodel_EWA_F3;
d2c      = 5; % Degree of freedom -number of free parameters in the model (Rho, Phi, forgetting rate_PLA, forgetting rate_MPH, Beta)
% Prior for parameters
d2c_mean = zeros(d2c,1);
d2c_var  = 10;
prior_2c = struct('mean',d2c_mean,'variance',d2c_var);
% Output file name
fname_lap_2c = strcat('M2c_EWA+F3_lap', '.mat');

% M2d: EWA+f d_beta
model_2d = @Simmodel_EWA_F4;
d2d      = 5; % Degree of freedom -number of free parameters in the model (Rho, Phi, forgetting rate, Beta_MPH, Beta_PLA)
% Prior for parameters
d2d_mean = zeros(d2d,1);
d2d_var  = 10;
prior_2d = struct('mean',d2d_mean,'variance',d2d_var);
% Output file name
fname_lap_2d = strcat('M2d_EWA+F4_lap', '.mat');

%% parameter estimation and model comparison
% cbm_lap(data, model_2, prior_2, fname_lap_2);
cbm_lap(data, model_2a, prior_2a, fname_lap_2a);
cbm_lap(data, model_2b, prior_2b, fname_lap_2b);
cbm_lap(data, model_2c, prior_2c, fname_lap_2c);
cbm_lap(data, model_2d, prior_2d, fname_lap_2d);

models = {model_2, model_2a, model_2b, model_2c, model_2d};
fcbm_maps = {fname_lap_2, fname_lap_2a, fname_lap_2b, fname_lap_2c, fname_lap_2d};
fname_hbi = 'hbi_2a-d.mat';
cbm_hbi(data,models,fcbm_maps,fname_hbi);
cbm_hbi_null(data,fname_hbi);

