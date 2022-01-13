function a_value = Hybrid_F_model(para,choice,outcome)
% EWA (Experience Weighted Attraction) model
% INPUT
% para    : learning rates (Rho and Phi)
%           para(1) is kapa
%           para(2) is eta
%           para(3) is alpha_f
% choice  : actions in each trial
% outcome : environment feedback
% OUTPUT
% a_value : value of each action during trials

% By Mojtaba Rostami Kandroodi
% Last Update : 20 June 2019
%--------------------------------------------------------------------------
N=length(outcome);            %number of trials
k=length(unique(choice));     %number of options
k= max(3,k);
% k=2;  % For MIND dataset
Q=nan(N,k);                   %values of each choice each trial
Alpha=nan(N,1);                  % Updating Learning rate

% Q(1,:) = 0.5;                  %initialize guesses (Punishment = 0)
Q(1,:) = 0;                      %initialize guesses   (Punishment = -1)

Alpha(1)=1;                    %initialize experience weight

kapa = para(1);
eta  = para(2);
alpha_f  = para(3);

% If use outcome +1, 0 => comment next line
outcome = 2 * outcome -1;

for ind = 1:(N - 1)
    % copy forward action values to next trial
    Delta(ind) = outcome(ind)- Q(ind, choice(ind));
    Q(ind + 1, :) = Q(ind, :);
    
    for iCh=1:k      % Chosen action
        if iCh==choice(ind)
            Q(ind + 1,choice(ind)) = Q(ind ,choice(ind))+ kapa * Alpha(ind)* Delta(ind);
            Alpha(ind+1) = eta * abs(Delta(ind)) + (1-eta)* Alpha(ind);
            
        elseif iCh~=choice(ind) % forgetting for unchosen actions
            Q(ind+1,iCh) = (1 - alpha_f) * Q(ind,iCh);
        end
    end
end

%return vector of action values for each trial
a_value=Q;