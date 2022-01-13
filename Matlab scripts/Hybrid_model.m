function a_value = Hybrid_model(para,choice,outcome)
% Hybrid model 
% INPUT
% para    : learning rates (Rho and Phi) 
%           para(1) is kapa
%           para(2) is eta
% choice  : actions in each trial
% outcome : environment feedback
% OUTPUT
% a_value : value of each action during trials

% By Mojtaba Rostami Kandroodi
% Last Update : 03 July 2019
%--------------------------------------------------------------------------
N=length(outcome);            %number of trials
k=length(unique(choice));     %number of options
k= max(3,k);
Q=nan(N,k);                   %values of each choice each trial
Alpha=nan(N,1);               % Updating Learning rate
Q(1,:) = 0;                   %initialize guesses   (use Outcome: Reward = +1, Punishment = -1)
Alpha(1)=1;                   %initialize experience weight
kapa = para(1);
eta  = para(2);
outcome = 2 * outcome -1;     % Outcome was Reward = +1, Punishment = 0

for ind = 1:(N - 1) 
    % copy forward action values to next trial
    Delta(ind) = outcome(ind)- Q(ind, choice(ind));
    Q(ind + 1, :) = Q(ind, :);
    
    % update option chosen on this trial for next trial's choice
    Q(ind + 1,choice(ind)) = Q(ind ,choice(ind))+ kapa * Alpha(ind)* Delta(ind);     
    Alpha(ind+1) = eta * abs(Delta(ind)) + (1-eta)* Alpha(ind);
end

%return vector of action values for each trial
a_value=Q;