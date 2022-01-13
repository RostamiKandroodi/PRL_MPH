function loglik = Simmodel_EWA_F1(params,dat)
% WRAPPER FUNCTION: EWA + Forgetting model
% Same parameter for both PLA & MPH sessions EXCEPT 1th parameter
% INPUT
% params : free parameters of model 
%           params(1) is rho (PLA)
%           params(2) is phi
%           params(3) is forgetting factor
%           Params(4) is rho for (MPH) (this is PLA+Delta)
%           params(5) is beta -softmax inverse temperature 
% dat    : subject behavioral data
%           dat.actions is actions in each trial
%           dat.outcome is environment feedback
% OUTPUT
% loglik : log likelihood of data given model and parameters

% By Mojtaba Rostami Kandroodi
% Last Update : 10 Aug 2018
%--------------------------------------------------------------------------
% learning rate parameter: since params(1), params(2), params(3), and params(4) can take any value,
% it should be transformed to lie in the unit range (between zero and one)
alpha   = 1./(1+exp(-params(1:4)));
% temperature parameter: since params(4) can take any value, it should be
% transformed to be positive
beta    = exp(params(5));

% unpack dat for PLA
outcomeP   = dat.PLA.outcome;   
actionsP   = dat.PLA.actions;
QP = EWA_F_model(alpha(1:3),actionsP,outcomeP);
% loglik is the output: sum of the log-probability of all actions
loglikP = LL_softmax(beta*QP,actionsP);

% unpack dat for MPH
outcomeM   = dat.MPH.outcome;   
actionsM   = dat.MPH.actions;
QM = EWA_F_model([alpha(4),alpha(2),alpha(3)],actionsM,outcomeM);
% loglik is the output: sum of the log-probability of all actions
loglikM = LL_softmax(beta*QM,actionsM);
loglik = loglikP + loglikM;

end