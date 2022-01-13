function loglik = SimSamodel_Hybrid_F(params,dat)
% WRAPPER FUNCTION: Hybrid model + forgetting
% Same parameter for both PLA & MPH sessions

% INPUT
% params : free parameters of model 
%           params(1) is kapa
%           params(2) is eta
%           params(3) is alpha_f
%           params(4) is beta -softmax inverse temperature 
% dat    : subject behavioral data
%           dat.PLA : for PLA session
%               dat.PLA.actions is actions in each trial
%               dat.PLA.outcome is environment feedback
%           dat.MPH : for MPH session
%               dat.MPH.actions is actions in each trial
%               dat.MPH.outcome is environment feedback
% OUTPUT
% loglik : log likelihood of data given model and parameters

% By Mojtaba Rostami Kandroodi
% Last Update : 18 June 2019
%--------------------------------------------------------------------------
% learning rate parameter: since params(1) and params(2) can take any value,
% it should be transformed to lie in the unit range (between zero and one)
alpha   = 1./(1+exp(-params(1:3)));
% temperature parameter: since params(3) can take any value, it should be
% transformed to be positive
beta    = exp(params(4));

% unpack dat for PLA
outcomeP   = dat.PLA.outcome;   
actionsP   = dat.PLA.actions;
QP = Hybrid_F_model(alpha,actionsP,outcomeP);
% loglik is the output: sum of the log-probability of all actions
loglikP = LL_softmax(beta*QP,actionsP);

% unpack dat for MPH
outcomeM   = dat.MPH.outcome;   
actionsM   = dat.MPH.actions;
QM = Hybrid_F_model(alpha,actionsM,outcomeM);
% loglik is the output: sum of the log-probability of all actions
loglikM = LL_softmax(beta*QM,actionsM);
loglik = loglikP + loglikM;
end