%% Returns and Statistics
clear
Stock = StockList(1);
PPD = 77;
for d = 1:1241
    Index((PPD+1)*(d-1)+1:(PPD+1)*d,1) = (d-1)*771+1:770/PPD:771*d;
end
for c = 2:length(Stock)
    eval(sprintf('load %sFreqCC',char(Stock(c))));
    Price = Price.Freq770(Index,:);
    Returns(2:length(Price),7) =  (log(Price(2:length(Price),7)) - log(Price(1:length(Price)-1,7)));
    Returns(1:length(Price),1:6) = Price(:,1:6);
    Returns(1:PPD+1:end,7) = 0;
    for d = 1:length(Price)/(PPD+1)
        TmpReturn = Returns(2+(PPD+1)*(d-1):(PPD+1)+(PPD+1)*(d-1),7);
        L = length(TmpReturn);
        RV(d,1) = sum(TmpReturn.^2);
        RV(isnan(RV)) = 0;
        BV(d,1) = pi/2*L/(L-1)*sum(abs(TmpReturn(2:L).*TmpReturn(1:L-1)));
        BV(isnan(BV)) = 0;
        RJ(d,1) = (RV(d)-BV(d))/RV(d);
        RJ(isnan(RJ)) = 0;
        TPrmt(d,1) = L*(2^(2/3)*gamma(7/6)/gamma(0.5))^(-3)*L/(L-2)*sum(abs(TmpReturn(1:L-2).^(4/3).*TmpReturn(2:L-1).^(4/3).*TmpReturn(3:L).^(4/3)));
        ZTPrmt(d,1) = RJ(d)/sqrt(((pi/2)^2+pi-5)/L*max(1,TPrmt(d)/BV(d)^2));
    end
    eval(sprintf('save %sZTPrmt5 RV BV RJ ZTPrmt Returns Price;',char(Stock(c))))
    sprintf('%sZTPrmt5',char(Stock(c)))
end

%% Aggregate
PPD = 77;
ReturnsA = zeros(1241*(PPD+1),1);
clear Returns
for d = 1:1241
    Index((PPD+1)*(d-1)+1:(PPD+1)*d,1) = (d-1)*771+1:770/(PPD):771*d;
end
for c = 2:length(Stock)
    eval(sprintf('load %sFreqCC',char(Stock(c))));
    Price = Price.Freq770(Index,:);
    Returns(2:length(Price),1) =  (log(Price(2:length(Price),7)) - log(Price(1:length(Price)-1,7)));
    ReturnsA = ReturnsA + Returns;
end
Returns(:,4) = ReturnsA/40;
Returns(1:(PPD+1):end,4) = 0;
Returns(:,1:3) = Price(:,1:3);
for d = 1:length(Price)/(PPD+1)
    TmpReturn = Returns(2+(PPD+1)*(d-1):(PPD+1)+(PPD+1)*(d-1),4);
    L = length(TmpReturn);
    RV(d,1) = sum(TmpReturn.^2);
    RV(isnan(RV)) = 0;
    BV(d,1) = pi/2*L/(L-1)*sum(abs(TmpReturn(2:L).*TmpReturn(1:L-1)));
    BV(isnan(BV)) = 0;
    RJ(d,1) = (RV(d)-BV(d))/RV(d);
    RJ(isnan(RJ)) = 0;
    TPrmt(d,1) = L*(2^(2/3)*gamma(7/6)/gamma(0.5))^(-3)*L/(L-2)*sum(abs(TmpReturn(1:L-2).^(4/3).*TmpReturn(2:L-1).^(4/3).*TmpReturn(3:L).^(4/3)));
    ZTPrmt(d,1) = RJ(d)/sqrt(((pi/2)^2+pi-5)/L*max(1,TPrmt(d)/BV(d)^2));
end
save AGGZTPrmt5 RV BV RJ TPrmt ZTPrmt Returns
