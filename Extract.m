function [ITemp] = Extract(Freq,PseuYr,m)
i = zeros(length(Freq),1);
ITemp = 0;
PseuMon = PseuYr(find(PseuYr(:,2) == m),3:9);
if length(PseuMon) ~= 0
    %Selecting Day
    for D = 1:31;
        PseuD = PseuMon(find(PseuMon(:,1) == D),[2:4 7]);
        if length(PseuD) > 0;
            %9.30 and 4 pm only
            PseuDp = PseuD(:,1)*60+PseuD(:,2);
            PseuD = PseuD(find(PseuDp >= 570 & PseuDp <= 960),:);
            %redefining PseuD Minutes Seconds Index Only
            PseuD = [PseuD(:,1)*60+PseuD(:,2)+PseuD(:,3)/60 PseuD(:,4)];
            % different sampling freq
            for f = 1:length(Freq)
                for M = 575:385/(Freq(f)):960
                    i(f) = i(f) + 1;
                    try
                        ITemp(i(f),f) = PseuD(find(PseuD(:,1) < M,1,'last'),2);
                    catch
                        ITemp(i(f),f) = PseuD(1,2);
                    end
                end
            end
        end
    end
end

