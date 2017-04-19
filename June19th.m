%% Parameters
clear

%% Low Correlations
Stock = {'SPY';'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'};
load SPYZTPrmt;
ZTPrmtSPY = ZTPrmt;
ReturnsSPY = Returns(:,7);
load AGGZTPrmt;
ZTPrmtAGG = ZTPrmt;
ReturnsAGG = Returns(:,4);
for c = 2:length(Stock)
    eval(sprintf('load %sZTPrmt;',char(Stock(c))));
    StockName(c-1,1) = Stock(c);
    [CorrelationZ(c-1,1), CorrelationZ(c-1,3)]= corr(ZTPrmtAGG,ZTPrmt);
    [CorrelationZ(c-1,2), CorrelationZ(c-1,4)] = corr(ZTPrmtSPY,ZTPrmt);
    [CorrelationR(c-1,1), CorrelationR(c-1,3)] = corr(ReturnsAGG,Returns(:,4));
    [CorrelationR(c-1,2), CorrelationR(c-1,4)] = corr(ReturnsSPY,Returns(:,4));
end
CorrelationZ(:,1) = CorrelationZ(:,1).^2;
CorrelationZ(:,2) = CorrelationZ(:,2).^2;
CorrelationR(:,1) = CorrelationR(:,1).^2;
CorrelationR(:,2) = CorrelationR(:,2).^2;

subplot(2,1,1)
plot(0:39,CorrelationZ(:,1),'r.')
hold
plot(0:39,CorrelationZ(:,2),'rx')
%axis([0 39 0 0.04])
legend(['AGG';'SPY'])
Mean = mean(CorrelationZ);
eval(sprintf('text(15,0.035,''                                AGG           SPY'')',num2str(Mean)))
eval(sprintf('text(15,0.03,''Mean Correlation = %s'')',num2str(Mean(1:2))))
title('Correlations of ZStats of 40 stocks vs SPY and AGG')
ylabel('Correlation')
set(gca,'XTick',[0:39])
set(gca,'XTickLabel',{'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'})
set(gca,'FontSize',8)

subplot(2,1,2)
plot(0:39,CorrelationR(:,1),'k.')
hold
plot(0:39,CorrelationR(:,2),'kx')
legend(['AGG';'SPY'])
%axis([0 39 5e-6 12e-6])
Mean = mean(CorrelationR);
eval(sprintf('text(15,11E-6,''                                AGG           SPY'')',num2str(Mean)))
eval(sprintf('text(15,10e-6,''Mean Correlation = %s'')',num2str(Mean(1:2))))
title('Correlations of Returns of 40 stocks vs SPY and AGG')
ylabel('Correlation')
set(gca,'XTick',[0:39])
set(gca,'XTickLabel',{'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'})
set(gca,'FontSize',8)

figure
plot(0:39,CorrelationR(:,3:4),'.',0:39,CorrelationZ(:,3:4),'o')
legend({'AGG Returns';'SPY Returns';'AGG ZTPrmt';'SPY ZTPrmt'},'Location','Best')
set(gca,'XTick',[0:39])
set(gca,'XTickLabel',{'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'})
set(gca,'FontSize',8)
title('p-value of Correlations')

%% Significant Z-Stats on AGG
Stock = {'SPY';'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'};
for c = 2:length(Stock)
    eval(sprintf('load %sZTPrmt;',char(Stock(c))));
    ZStat(:,c-1) = ZTPrmt;
end
load AGGZTPrmt;
Zaverage = mean(ZStat(find(ZTPrmt > norminv(0.99)),:)');
scatter(ZTPrmt(find(ZTPrmt > norminv(0.99))),Zaverage);
axis([2 5 0 3.5])
title('mean(ZTPrmt_i) vs ZTPrmt_{AGG} significant.. (need help phrasing this!)')
xlabel('ZTPrmt_{AGG}')
ylabel('mean(ZTPrmt_i | ZTPrmt_{AGG} is significant (Help here too))')

%% u Stat
Stock = {'SPY';'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'};
for c = 2:length(Stock)
    eval(sprintf('load %sZTPrmt;',char(Stock(c))));
    TotReturns(:,c-1) = Returns(:,7);
end
for d = 1:length(TotReturns)
    PseuReturns(:,1) = TotReturns(d,:);
    UStatTemp(d,1) = 390*(sum(sum(PseuReturns*PseuReturns')) - sum(PseuReturns'*PseuReturns));
end
load SPYZTPrmt
ReturnsSPY = Returns(:,7);
load AGGZTPrmt
ReturnsAGG = Returns(:,4);
clear Returns
%Calculating U-Stats and Returns for Intraday Returns
for d = 1:1241;
    UStat((d-1)*77+1:d*77,1) = UStatTemp(2+78*(d-1):78+78*(d-1));
    Returns((d-1)*77+1:d*77,1) = ReturnsAGG(2+78*(d-1):78+78*(d-1));
    Returns((d-1)*77+1:d*77,2) = ReturnsSPY(2+78*(d-1):78+78*(d-1));
end
save UStat UStat Returns;
load UStat
subplot(2,1,1)
plot(Returns(:,1),UStat,'.')
title('UStat vs Returns_{AGG}')
xlabel('Returns_{AGG}')
ylabel('U-Statistic')
axis([-0.02 0.05 -0.02 0.6])
text(-0.005,0.45,'Number Data Points = 95557 \newlinePercentage > 0 = 77.28\newlinePercentage < 0 = 22.72')
subplot(2,1,2)
plot(Returns(:,2),UStat,'.')
title('UStat vs Returns_{SPY}')
xlabel('Returns_{SPY}')
ylabel('U-Statistic')
axis([-0.02 0.05 -0.02 0.6])

%% u Stat Selective AGG
Stock = {'SPY';'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'};
for c = 2:length(Stock)
    eval(sprintf('load %sZTPrmt;',char(Stock(c))));
    TotReturns(:,c-1) = Returns(:,7);
end
for d = 1:length(TotReturns)
    PseuReturns(:,1) = TotReturns(d,:);
    UStatTemp(d,1) = 1/2*(sum(sum(PseuReturns*PseuReturns')) - sum(PseuReturns'*PseuReturns));
end
save UStatTemp
clear
load UStatTemp
load AGGZTPrmt
FlagDate(:,1:3) = Returns(find(ZTPrmt > norminv(0.999)).*78,1:3);
FlagDate(:,4) = ZTPrmt(find(ZTPrmt > norminv(0.999)));
ReturnsTemp = Returns;
clear Returns

% Intraday Returns and UStat Only 77 Returns
for d = 1:1241;
    UStat((d-1)*77+1:d*77,1) = UStatTemp(2+78*(d-1):78+78*(d-1));
    Returns((d-1)*77+1:d*77,4) = ReturnsTemp(2+78*(d-1):78+78*(d-1),4);
    Returns((d-1)*77+1:d*77,1:3) = ReturnsTemp(2+78*(d-1):78+78*(d-1),1:3);
end
ReturnsSel = [];
UStatSel = [];
for d = 1:length(FlagDate)
    ReturnsSel =  [ReturnsSel; Returns(ismember(Returns(:,1:3),FlagDate(d,1:3),'rows'),:)];
    UStatSel =  [UStatSel; UStat(ismember(Returns(:,1:3),FlagDate(d,1:3),'rows'),:)];
end
Stock = {'SPY';'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'};
save Sel
clear
load Sel
for d = 1:length(FlagDate)
    figure
    subplot(2,1,1)
    plot(580:5:960,ReturnsSel((d-1)*77+1:d*77,4));
    eval(sprintf('title(''AGG Returns on %s-%s-%s ZTPrmt = %s'')',num2str(ReturnsSel(d*77,2)),num2str(ReturnsSel(d*77,3)),num2str(ReturnsSel(d*77,1)),num2str(FlagDate(d,4))))
    xlabel('Time')
    ylabel('Returns')
    set(gca,'XTick',[600:60:960])
    set(gca,'XTickLabel',{'10';'11';'12';'1';'2';'3';'4'})
    subplot(2,1,2)
    plot(580:5:960,(UStatSel((d-1)*77+1:d*77,1)-mean(UStatSel((d-1)*77+1:d*77,1)))/std(UStatSel((d-1)*77+1:d*77,1)));
    eval(sprintf('title(''UStatistics on %s-%s-%s'')',num2str(ReturnsSel(d*77,2)),num2str(ReturnsSel(d*77,3)),num2str(ReturnsSel(d*77,1))))
    xlabel('Time')
    ylabel('Standardized U-Stat')
    set(gca,'XTick',[600:60:960])
    set(gca,'XTickLabel',{'10';'11';'12';'1';'2';'3';'4'})
    P = input('Plot? ','s');
    hold off
    if P == '1'
        figure
        T = UStatSel((d-1)*77+1:d*77,1);
        I = find(T == max(T));
        MeanRet = 0;
        for c = 2:length(Stock)
            subplot(5,8,c-1)
            eval(sprintf('load %sZTPrmt;',char(Stock(c))));
            ZDay = ZTPrmt(find(ismember(Returns(:,1:3),FlagDate(d,1:3),'rows')== 1,1,'last')/78);
            B = Returns(ismember(Returns(:,1:3),FlagDate(d,1:3),'rows'),:);
            A = B(2:length(B),7);
            plot(I-5:1:I+5,A(I-5:I+5))
            hold on
            if A(I) > 0;
                plot(I,A(I),'r*')
            else
                plot(I,A(I),'rs')
            end
            hold off
            axis tight;
            eval(sprintf('title(''%s'')',char(Stock(c))))
            eval(sprintf('ylabel(''Z = %s'')',num2str(ZDay)))
            set(gca,'FontSize',5)
            h = get(gca,'YLabel');
            set(h,'FontSize',8)
        end
    end
end

%% Initial Results Plot 'Returns, RJ, ZTPrmt, ZTPrmt_XOM vs ZTPrmt_AGG'
load XOMZTPrmt
subplot(2,2,1)
plot(Returns(:,7))
axis([1 length(Returns) -0.03 0.03])
set(gca,'XTick',[1:252*78:length(Returns)])
set(gca,'XTickLabel',['2001';'2002'; '2003'; '2004'; '2005'])
title('Returns_{XOM} - 2001 : 2005')
xlabel('Year')
ylabel('Returns')

subplot(2,2,2)
plot(RJ)
axis([1 length(RJ) -.25 1])
set(gca,'XTick',[1:252:length(RJ)])
set(gca,'XTickLabel',['2001';'2002'; '2003'; '2004'; '2005'])
title('RJ_{XOM} - 2001 : 2005')
xlabel('Year')
ylabel('RJ')

subplot(2,2,3)
plot(ZTPrmt)
axis([1 length(ZTPrmt) -3 8])
set(gca,'XTick',[1:252:length(ZTPrmt)])
set(gca,'XTickLabel',['2001';'2002'; '2003'; '2004'; '2005'])
title('ZTPrmt_{XOM} - 2001 : 2005')
xlabel('Year')
ylabel('ZTPrmt')

ZTPrmtXOM = ZTPrmt;
load SPYZTPrmt;
subplot(2,2,4)
scatter(ZTPrmtXOM,ZTPrmt)
axis([-3 12 -3 12])
title('ZTPrmt_{XOM} vs ZTPrmt_{SPY} - 2001 : 2005')
xlabel('ZTPrmt_{XOM}')
ylabel('ZTPrmt_{SPY}')
Correlation = corr(ZTPrmtXOM,ZTPrmt);
eval(sprintf('text(8,8,''Corr = %s'')',num2str(Correlation)))
