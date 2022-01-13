function a_value = EWA_model(para,choice,outcome)
% EWA (Experience Weighted Attraction) model 
% INPUT
% para    : learning rates (Rho and Phi) 
%           para(1) is rho
%           para(2) is phi
% choice  : actions in each trial
% outcome : environment feedback
% OUTPUT
% a_value : value of each action during trials

% By Mojtaba Rostami Kandroodi
% Last Update : 28 June 2018
%--------------------------------------------------------------------------
N=length(outcome);            %number of trials
k=length(unique(choice));     %number of options
k= max(3,k);
Q=nan(N,k);                   %values of each choice each trial
EW=nan(N,k);                  %experience weight values for each choice during trials
Q(1,:) = 0;                   %initialize guesses   (use Outcome: Reward = +1, Punishment = -1)
EW(1,:)=1;                    %initialize experience weight
rho = para(1);
phi = para(2);
outcome = 2 * outcome -1;   % Outcome was Reward = +1, Punishment = 0

for ind = 1:(N - 1) 
    % copy forward action values to next trial
    Q(ind + 1, :) = Q(ind, :);
    EW(ind + 1, :)=EW(ind, :);
    
    % update option chosen on this trial for next trial's choice
    EW(ind+1,choice(ind)) = EW(ind,choice(ind)) * rho + 1;
    Q(ind + 1,choice(ind)) = (Q(ind,choice(ind))* phi * EW(ind,choice(ind))+outcome(ind)) / EW(ind+1,choice(ind));     
end

%return vector of action values for each trial
a_value=Q;