function a_value = EWA_F_model(para,choice,outcome)
% EWA + Forgetting model 
% INPUT
% para    : learning rates (Rho and Phi) 
%           para(1) is rho
%           para(2) is phi
%           para(3) is forgetting factor
% choice  : actions in each trial
% outcome : environment feedback
% OUTPUT
% a_value : value of each action during trials

% By Mojtaba Rostami Kandroodi
% Last Update : 30 July 2018
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
outcome = 2 * outcome -1;

for ind = 1:(N - 1)
    EW(ind + 1, :)=EW(ind, :);
    
    EW(ind+1,choice(ind)) = EW(ind,choice(ind)) * rho + 1;
    for iCh=1:k      % Chosen action
        if iCh==choice(ind)
            Q(ind + 1,iCh) = (Q(ind,choice(ind))* phi * EW(ind,choice(ind))+outcome(ind)) / EW(ind+1,choice(ind));     

        elseif iCh~=choice(ind) % forgetting for unchosen actions 
                Q(ind+1,iCh) = (1 - para(3)) * Q(ind,iCh);
%                 Q(ind+1,iCh) = Q(ind,iCh) - alpha(3) ;
                
        end
    end
end

%return vector of action values for each trial
a_value=Q;