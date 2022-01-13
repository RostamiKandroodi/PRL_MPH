function [PercentagePLA,  PercentageMPH] = ActionContengency(data,SL)
% Trial by trial action probability given data, parameters and model
% INPUT
% data   : subject behavioral data
%           dat.actions is actions in each trial
%           dat.outcome is environment feedback
% SL     : SessionLength
%           SL(:,1) No. of trials in Acq
%           SL(:,2) No. of trials in Rev

% OUTPUT
% PercentagePLA : Actions Contengency for PLA sassion [A1_Acq, A2_Acq, A3_Acq, A1_Rev, A2_Rev, A3_Re]
% PercentageMPH : Actions Contengency for MPH sassion [A1_Acq, A2_Acq, A3_Acq, A1_Rev, A2_Rev, A3_Re]

% By Mojtaba Rostami Kandroodi
% Last Update : 30 Jan 2019
%--------------------------------------------------------------------------
PLAsessions = 1:102;
MPHsessions = 103:204;

for i=1:length(data)
    Percentage(i,:) =  [length(find(data{i,1}.actions(1:SL(i,1))==1))/SL(i,1),...
                        length(find(data{i,1}.actions(1:SL(i,1))==2))/SL(i,1),...
                        length(find(data{i,1}.actions(1:SL(i,1))==3))/SL(i,1),...
                        length(find(data{i,1}.actions(SL(i,1)+1:SL(i,1)+SL(i,2))==1))/SL(i,2),...
                        length(find(data{i,1}.actions(SL(i,1)+1:SL(i,1)+SL(i,2))==2))/SL(i,2),...
                        length(find(data{i,1}.actions(SL(i,1)+1:SL(i,1)+SL(i,2))==3))/SL(i,2)];
end
PercentagePLA = Percentage(PLAsessions,:);
PercentageMPH = Percentage(MPHsessions,:);

end