function [Mean, SD] = SmootPerSubjectMulti(Actions1,Actions2, WW)
% This function smoothing the signal using a sliding window (Width of WW)

% INPUT
% Actions1    : Actions of all subjects 1 session. nSub*nTrial
% Actions2    : Actions of all subjects 2 session. nSub*nTrial
% WW          : width of Sliding window
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
Mean = zeros(size(Actions1,2),1);
SD   = zeros(size(Actions1,2),1);
SmootAction1 =zeros(size(Actions1));
SmootAction2 =zeros(size(Actions2));

for Sub = 1: size(Actions1,1)
    
    Sig1 = Actions1(Sub,:);
    Sig2 = Actions2(Sub,:);
    for i = 1: length(Sig1)
        if i <= Bsh
            w  = Sig1(1:i+Fsh);       % window is from begining until the current trial
            WL = length(w);           % window length
            w2  = Sig2(1:i+Fsh);       % window is from begining until the current trial
        elseif i > length(Sig1)- Fsh
            w  = Sig1(i-Bsh:length(Sig1));
            WL = length(w);
            w2  = Sig2(i-Bsh:length(Sig2));
        else
            w  = Sig1(i-Bsh:i+Fsh);
            WL = WW;
            w2  = Sig2(i-Bsh:i+Fsh);
        end
        p(1)= length(find(w==1))/WL;
        p(2)= length(find(w==2))/WL;
        p(3)= length(find(w==3))/WL;
        SmootAction1(Sub,i) = mean(w);
        SmootAction2(Sub,i) = mean(w2);
    end
end
SmootAction = (SmootAction1+SmootAction2)/2;
Mean = mean(SmootAction);
SD   = std(SmootAction);


end