function [actions, outcome] = PRL2Simulation(model, para)
% This function simulate PRL2cues for 'model' wilth 'para'
% Simulation uses orginal feedback of 3-option task and just uses first 2 option 
load('../PRL_Task_Code/prob75_3cues.mat');
switch model
    case 'EWA+F'
        alpha = para(1:3);   % model update patameters (rho, phi, forgetting)
        beta  = para(4);     % softmax update parameters (beta)
end

% setup final things.
incorrStim    = [];
chanceStim    = [];
% Initial value for Q-value
Q(1 , 1:2) = [0,0];
EW(1, 1:2) = [1,1];
ct         = 1;    % counter of trial in each phase (Acq. and Rev.)

RN = 0.0; % random noise to selection
RandomNoise = [0, rand(1,79)>(1-RN)];
preChoice = [0 , 0 , 0];  % previous choice needed to modelling the stickness
for iTrial = 1:80
    if iTrial<41
        iSes = 1;     % 1: 'ACQUISITION'
    else
        iSes = 2;     % 2: 'REVERSAL'
    end
    if iTrial ==41; ct = 1; end
    
    % chosen Color
    if length(beta)==1
        chosenColor = softmax(Q(iTrial,: ),beta);
    elseif length(beta)==2
        chosenColor = softmaxStick(Q(iTrial,: ),preChoice,beta);
    end
    % add random noise
    if RandomNoise(iTrial)==1
        chosenColor = Change(chosenColor);
    end
    % determine which stim receives positive/negative reinforcement in
    % first session, and which stim is at chance level during whole
    % experiment, if not done yet.
    if iTrial == 1 && iSes == 1
        corrStim = chosenColor;
    elseif isempty(incorrStim) && chosenColor ~= corrStim
        incorrStim = chosenColor;
    end
    
    % determine feedback.
    prob = find(chosenColor == [corrStim incorrStim]);
    outcome(iTrial) = fb{prob,iSes}(ct);
    actions(iTrial) = prob;
    ct = ct +1;

    % Q-value update
    switch model

        case 'EWA+F'
            [Q(iTrial+1, :), EW(iTrial+1, :) ]= EWA_F(Q(iTrial, :),EW(iTrial, :), chosenColor, outcome(iTrial), alpha);
    end
    preChoice(:)=0;
    preChoice(actions(iTrial))= 1;
end

end

function action = softmax(Q,beta)
hh = exp(Q*beta); %exponentiate values
norm = sum(hh,2); %normalization (sum each row; i.e., sum over options of exp(xx))
pro = hh./norm;
X = [1,2];
action = X(find(rand<cumsum(pro),1,'first'));
end

function action = softmaxStick(Q, preChoice, beta)
xx = beta(1) * Q + beta(2) * preChoice;
hh = exp(xx); %exponentiate values
norm = sum(hh,2); %normalization (sum each row; i.e., sum over options of exp(xx))
pro = hh./norm;
X = [1,2,3];
action = X(find(rand<cumsum(pro),1,'first'));
end


function Q = RP(q,action, outcome, alpha)
outcome = 2 * outcome -1;
Reward = 1;
alpha_r = alpha(1);
alpha_p = alpha(2);

for iCh=1:2      % Chosen action
    if iCh==action
        if outcome== Reward
            Q(1,iCh) = q(1,iCh) + alpha_r * (outcome - q(1,iCh));
        elseif outcome ~= Reward
            Q(1,iCh) = q(1,iCh) + alpha_p * (outcome - q(1,iCh));
        end
        
    elseif iCh~=action % forgetting for unchosen actions
        Q(1,iCh) = q(1,iCh);
    end
end
end



function [Q, EW] = EWA_F(q, ew, action, outcome, alpha)
outcome = 2 * outcome -1;
rho = alpha(1);
phi = alpha(2);
forget = alpha(3);

EW = ew;
EW(1,action) = EW(1,action) * rho + 1;
Q=q;

for iCh=1:2      % Chosen action, for 2-option task
    if iCh==action
        Q(1,iCh) = (q(1,action)* phi * ew(1,action) + outcome) / EW(1,action);
        
    elseif iCh~=action % forgetting for unchosen actions
        Q(1,iCh) = (1 - forget) * q(1,iCh);
    end
end

end

function Q = RP_F(q,action, outcome, alpha)
outcome = 2 * outcome -1;
Reward = 1;
alpha_r = alpha(1);
alpha_p = alpha(2);
forget = alpha(3);

for iCh=1:3      % Chosen action
    if iCh==action
        if outcome== Reward
            Q(1,iCh) = q(1,iCh) + alpha_r * (outcome - q(1,iCh));
        elseif outcome ~= Reward
            Q(1,iCh) = q(1,iCh) + alpha_p * (outcome - q(1,iCh));
        end
        
    elseif iCh~=action % forgetting for unchosen actions
        Q(1,iCh) = (1 - forget) * q(1,iCh);
    end
end
end

function y = Change(x)
% change desicion x
% for example if x=1 change it to 2 or 3
options = [1,2];
options(x) = [];
pro = [1];
y = options(find(rand<cumsum(pro),1,'first'));
end