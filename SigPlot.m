%% Parameters
clear
Stock = StockList(1);
Freq = [5     7    10    11    14    22    35    55    70    77   110   154   385];

for c = 2:length(Stock)
    Stock(c)
    eval(sprintf('load %sFreqCC',char(Stock(c))));
    Price.Freq770 = Price.Freq770(Price.Freq770(:,1) == 2004,:);
    PriceAll = Price.Freq770(:,7);
    for d = 1:length(PriceAll)/771
        PriceD = PriceAll(1+771*(d-1):771+771*(d-1));
        for f = 1:length(Freq)
            Price = PriceD(1:770/Freq(f):end);
            TmpReturn = (log(Price(2:length(Price),1)) - log(Price(1:length(Price)-1,1)))';
            RV(d,f) = sum(TmpReturn.^2);
        end
    end
    RVStock(c,:) = mean(RV);
    clear RV
end
save RVStock RVStock Stock Freq

%% Plotting
clear
load RVStock
for c = 2:length(Stock)
    figure
    plot(770./Freq.*0.5, RVStock(c,:),'k*')
    xlabel('Sampling Frequency , (Minutes)')
    ylabel('Sample Average of Realized Volatility')
    eval(sprintf('title(''Signature Plots %s'')',char(Stock(c))))
end