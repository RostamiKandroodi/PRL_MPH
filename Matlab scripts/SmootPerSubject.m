function [Mean, SD] = SmootPerSubject(Actions,WW)
% This function smoothing the signal using a sliding window (Width of WW)

% INPUT
% Actions    : Actions of all subjects. nSub*nTrial
% WW         : width of Sliding window
%
% OUTPUT
% Mean    : Mean of Action probablity in sliding window
% SD      : Standard Deviation of mean
% By Mojtaba Rostami Kandroodi
% Last Update : 28 August 2019
%--------------------------------------------------------------------------

% Working time (t) is the midel one trial in sliding window
% sliding window become smaller in borders
if mod(WW,2)==1            % WW is odd number
    Bsh = fix(WW/2);       % Begiging shift
    Fsh = Bsh;             % Finishing shift
else                       % WW is even number
    Bsh = fix(WW/2)-1;     % Begiging shift
    Fsh = fix(WW/2) ;      % Finishing shift
end
Mean = zeros(size(Actions,2),1);
SD   = zeros(size(Actions,2),1);
SmootAction =zeros(size(Actions));
for Sub = 1: size(Actions,1)
    
    Sig = Actions(Sub,:);
    for i = 1: length(Sig)
        if i <= Bsh
            w  = Sig(1:i+Fsh); % window is from begining until the current trial
            WL = length(w);           % window length
        elseif i > length(Sig)- Fsh
            w  = Sig(i-Bsh:length(Sig));
            WL = length(w);
        else
            w  = Sig(i-Bsh:i+Fsh);
            WL = WW;
        end
        p(1)= length(find(w==1))/WL;
        p(2)= length(find(w==2))/WL;
        p(3)= length(find(w==3))/WL;
        SmootAction(Sub,i) = mean(w);
    end
end
Mean = mean(SmootAction);
SD   = std(SmootAction);


end