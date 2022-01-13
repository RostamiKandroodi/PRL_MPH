function Out =WStLSt(choice,outcome, SL)
% Out = [wstay_acq, lstay_acq, wstay_rev, lstay_rev];
% This function takes choice and outcome (0,1) and length of each phase (clean data) 
% and return WinStay(ws) and LoseStay(ls)
% wsA : Stay probability after wining: No. of wins and stay after it / No. of wins Acq
% lsA : Stay probability after lose: No. of lose and stay after it / No. of lose Acq
% wsR : Stay probability after wining: No. of wins and stay after it / No. of wins Rev
% lsR : Stay probability after lose: No. of lose and stay after it / No. of lose Rev
%-------------------------------------------
% By Mojtaba Rostami Kandroodi June 2018
% Last update 07/02/2019
%-------------------------------------------

N_Acq=SL(1);            %number of trials in Acq
N_Rev=SL(2);            %number of trials in Rev

NoWinA  = 0;  % No. Win trials Acq
NoLoseA = 0;  % No. Lose trials Acq  
NoWSA   = 0;  % No. WinStay trials Acq
NoLSA   = 0;  % No. LoseStay trials Acq

NoWinR  = 0;  % No. Win trials Rev
NoLoseR = 0;  % No. Lose trials Rev  
NoWSR   = 0;  % No. WinStay trials Rev
NoLSR   = 0;  % No. LoseStay trials Rev

for i=1:N_Acq-1
    if outcome(i)==1   % Win Trial
        NoWinA = NoWinA + 1;
        if choice(i+1)== choice(i)
            NoWSA = NoWSA +1;
        end          
    elseif outcome(i)==0   % Lose Trial
        NoLoseA = NoLoseA + 1;
        if choice(i+1) == choice(i)
            NoLSA = NoLSA +1;
        end
    else
        disp('Outcome is not well-defined!')
        break;
    end 
end
wsA = NoWSA/NoWinA;
lsA = NoLSA/NoLoseA;

for i=N_Acq+1:N_Acq+N_Rev-1
    if outcome(i)==1   % Win Trial
        NoWinR = NoWinR + 1;
        if choice(i+1)== choice(i)
            NoWSR = NoWSR +1;
        end          
    elseif outcome(i)==0   % Lose Trial
        NoLoseR = NoLoseR + 1;
        if choice(i+1) == choice(i)
            NoLSR = NoLSR +1;
        end
    else
        disp('Outcome is not well-defined!')
        break;
    end 
end
wsR = NoWSR/NoWinR;
lsR = NoLSR/NoLoseR;


Out = [wsA, lsA, wsR, lsR];
end