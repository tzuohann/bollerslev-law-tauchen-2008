%% Manual Cleaning
clear
Stock = StockList(1);
CloseDate = [2001 6 8; 2001 7 3; 2001 9 11; 2001 9 12; 2001 9 13; 2001 9 14; 2001 11 23; 2001 12 24; 2002 5 30; 2002 7 5; 2002 9 11; 2002 11 29; 2002 12 24; 2003 2 3; 2003 7 3; 2003 9 11; 2003 11 28; 2003 12 24; 2004 6 11; 2004 11 25; 2005 6 1];
Freq = [770];

%% Removing days with abberations
for c = 1:length(Stock)
    Stock(c)
    eval(sprintf('load %sFreq;',char(Stock(c))));
    for f = 1:length(Freq)
        eval(sprintf('C = ~ismember(Price.Freq%s(:,1:3),CloseDate(:,1:3),''rows'');',num2str(Freq(f))))
        eval(sprintf('Price.Freq%s = Price.Freq%s(C,:);',num2str(Freq(f)),num2str(Freq(f))))
    end
    eval(sprintf('save %sFreq Price;',char(Stock(c))))
end

%% Automatic
for c = 1:length(Stock)
    Stock(c)
    eval(sprintf('load %sFreq;',char(Stock(c))));
    %at lower sampling freq, cleaning does not make sense because a lot of
    %stuff is possible starting arbitrarily at 40 samples per day.
    for f = 1:length(Freq)
        eval(sprintf('PriceTemp = Price.Freq%s(:,7);',num2str(Freq(f))));
        ReturnTemp(2:length(PriceTemp),1) = log(PriceTemp(2:length(PriceTemp),1)) - log(PriceTemp(1:length(PriceTemp)-1,1));
        ReturnTemp(1:Freq(f)+1:end) = 0;
        BiRet(2:length(ReturnTemp),1) = ReturnTemp(2:end).*ReturnTemp(1:end-1);
        SqrtRet = sqrt(abs(BiRet.*(BiRet<0)));
        SqrtRet = SqrtRet.*(SqrtRet > 0.015);
        Info(:,1) = find(ReturnTemp.*(SqrtRet ~= 0)~=0);
        Info(:,2) = abs(log(PriceTemp(Info(:,1)-2)) - log(PriceTemp(Info(:,1))));
        Info = Info(Info(:,2) < 0.0025,:);
        NumReps(c,f) = sum(Info(:,2) < 0.0025);
        PriceTemp(Info(:,1)-1) = PriceTemp(Info(:,1)-2,1);
        ReturnTemp(2:length(PriceTemp),1) = log(PriceTemp(2:length(PriceTemp),1)) - log(PriceTemp(1:length(PriceTemp)-1,1));
        ReturnTemp(1:Freq(f)+1:end) = 0;
        figure
        plot(ReturnTemp)
        eval(sprintf('Price.Freq%s(:,7) = PriceTemp(:,1);',num2str(Freq(f))));
        clear ReturnTemp BiRet SqrtRet Info
    end
    eval(sprintf('save %sFreqC Price;',char(Stock(c))))
end

%% Manual
for c = 1:length(Stock)
    Stock(c)
    eval(sprintf('load %sFreqC;',char(Stock(c))));
    for f = 1:length(Freq)
        eval(sprintf('PriceTemp = Price.Freq%s(:,7);',num2str(Freq(f))));
        ReturnTemp(2:length(PriceTemp),1) = log(PriceTemp(2:length(PriceTemp),1)) - log(PriceTemp(1:length(PriceTemp)-1,1));
        ReturnTemp(1:Freq(f)+1:end) = 0;
        s(:,1) = find(abs(ReturnTemp) > 0.015);
        for m = 1:length(s)
            plot(PriceTemp(s(m)-10:s(m)+10,1),'k*')
            hold on
            plot(11,PriceTemp(s(m),1),'rs')
            hold off
            grid
            axis([1 21 min(PriceTemp(s(m)-10:s(m)+10))-5 min(PriceTemp(s(m)-10:s(m)+10))+5])
%             axis([1 21 mean(PriceTemp(s(m)-10:s(m)+10))-2 mean(PriceTemp(s(m)-10:s(m)+10))+2])
            Replace = input('Replace ');
            if Replace == 1;
                % actual points, including the square
                
                Points = input('Points? ');
                if Points == 999;
                    keyboard
                elseif sign(Points) > 0 && Points ~= 999;
                    PriceTemp(s(m):sign(Points):s(m)+Points-1,1) = PriceTemp(s(m)-1,1);
                else
                    PriceTemp(s(m):sign(Points):s(m)+Points+1,1) = PriceTemp(s(m)-1+Points,1);
                end
            end
        end
        eval(sprintf('Price.Freq%s(:,7) = PriceTemp(:,1);',num2str(Freq(f))));
        clear Returns s
    end
    eval(sprintf('save %sFreqCC Price;',char(Stock(c))))
end
