%% Parameters
clear
Stock = StockList(1);
Freq = [770];

%% Extracting Minute
for c = 1:length(Stock)
    Stock(c)
    %Selecting Year
    for Year = 2001:2005
        tic
        Year
        % reset counter
        I = [];
        try
            %Loading Data and getting into general form
            eval(sprintf('load %sDate%s;',char(Stock(c)),num2str(Year)));
            PseuYr(:,9) = 1:length(PseuYr);
            for m = 1:12;
                ITemp = Extract(Freq,PseuYr,m);
                I = [I;ITemp];
            end
        catch
        end
        for f = 1:length(Freq)
            clear IVol ITemp Vol
            ITemp = I(I(:,f) ~= 0,f);
            IVol(2:length(ITemp),1) = ITemp(1:length(ITemp)-1);
            for v = 1:length(IVol)
                Vol(v,1) = sum(PseuYr(IVol(v)+1:ITemp(v),8));
            end
            Vol(1:Freq(f):length(Vol)) == 0;
            %Selective Saving for Minutes
            eval(sprintf('Price.Freq%s = [PseuYr(ITemp,1:7) Vol];',num2str(Freq(f))));
        end
        %saving
        eval(sprintf('save %sTemp%s Price;',char(Stock(c)),num2str(Year)));
        toc
    end
end

%% Recombining
for c = 1:length(Stock)
    Stock(c)
    Break = 0;
    for f = 1:length(Freq)
        eval(sprintf('PriceC.Freq%s = [];',num2str(Freq(f))));
    end
    for Year = 2001:2005
        eval(sprintf('exist %sTemp%s.mat;', char(Stock(c)),num2str(Year)))
        if ans == 2
            for y = Year:2005
                eval(sprintf('load %sTemp%s;',char(Stock(c)),num2str(y)));
                for f = 1:length(Freq)
                    eval(sprintf('PriceC.Freq%s = [PriceC.Freq%s ; Price.Freq%s];',num2str(Freq(f)),num2str(Freq(f)),num2str(Freq(f))));
                end
            end
            Break = 1;
        end
        if Break == 1;
            Break = 0;
            break
        end
    end
    Price = PriceC;
    eval(sprintf('save %sFreq Price',char(Stock(c))));
end
