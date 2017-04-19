    %% Signature Plots
clear
Stock = StockList(1);
Freq = [5     7    10    11    14    22    35    55    70    77   110   154   385];
for c = 2:length(Stock)
    eval(sprintf('load %sFreqCC',char(Stock(c))));
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
RVStock = RVStock(2:41,:);
save RVStock RVStock Stock Freq

clear
Freq = [5     7    10    11    14    22    35    55    70    77   110   154   385];
load RVStock
for c = 2:length(Stock)
    subplot(5,8,c-1)
    plot(770./Freq.*0.5, RVStock(c-1,:)*10000,'k*')
    axis([0 78 median(RVStock(c-1)*10000)-0.75 median(RVStock(c-1)*10000)+ 1 ])
    title(sprintf('%s',char(Stock(c))),'fontsize',8)
    set(gca,'FontSize',8)
end
gtext('Volatility Signature Plots of 40 Stocks')

%% Sample time
clear
Stock = StockList(1);
for c = 1:1241
    Idealtime(23*(c-1)+1:23*c,1) = (575*60:17.5*60:960*60)';
end
for c = 2:length(Stock)
    eval(sprintf('load %sZTPrmt175;',char(Stock(c))));
    Timestamp(:,c-1) = Idealtime - (Returns(:,4)*3600+Returns(:,5)*60+Returns(:,6));
end
bar(0:39,median(Timestamp))
axis([ -0.5 39.5 0 12]);
set(gca,'XTick',[0:39])
set(gca,'XTickLabel',{'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'})
ylabel('Median Backtrack, Seconds','fontsize',12)
set(gca,'FontSize',8)
title('Median Backtrack in Sampling Scheme','fontsize',12)

%% Low Correlations
clear
Stock = StockList(1);
load AGGZTPrmt175;
ZTPrmtAGG = ZTPrmt;
ReturnsAGG = Returns(:,4);
ReturnsAGG(1:23:end) = -9999;
ReturnsAGG = ReturnsAGG(ReturnsAGG ~= -9999);
for c = 2:length(Stock)
    eval(sprintf('load %sZTPrmt175;',char(Stock(c))));
    StockName(c-1,1) = Stock(c);
    [CorrelationZ(c-1,1), CorrelationZ(c-1,2)]= corr(ZTPrmtAGG,ZTPrmt);
    Betaz(c-1,1:2) = polyfit(ZTPrmtAGG,ZTPrmt,1);
    Returns = Returns(:,7);
    Returns(1:23:end) = -9999;
    Returns = Returns(Returns ~= -9999);
    [Beta(c-1,:)] = polyfit(ReturnsAGG,Returns,1);
end
CorrelationZ(:,1) = CorrelationZ(:,1).^2;

subplot(3,1,1)
plot([0 39],[1 1])
hold
plot(0:39,Beta(:,1),'kx')
title('5 Year $$\beta$$ ; Sampling Interval = 17.5 min','interpreter','latex','fontsize',12)
ylabel('$$\beta$$','interpreter','latex','fontsize',12.5)
set(gca,'XTick',[0:39])
set(gca,'XTickLabel',{'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'})
set(gca,'FontSize',8)
xlabel('Stock_i','fontsize',12)
axis([-1 40 0 2])

subplot(3,1,2)
plot(0:39,Betaz(:,1),'rx')
title('$$\beta(z_i,z_{EQW})$$','fontsize',12.5,'interpreter','latex')
ylabel(' ','fontsize',12.5,'interpreter','latex')
xlabel('Stock_i','fontsize',12)
set(gca,'XTick',[0:39])
set(gca,'XTickLabel',{'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'})
set(gca,'FontSize',8)
axis([-1 40 0 1])

subplot(3,1,3)
plot(0:39,CorrelationZ(:,1),'rx')
title('$$corr(z_i,z_{EQW})$$','fontsize',12.5,'interpreter','latex')
ylabel(' ','fontsize',12.5,'interpreter','latex')
xlabel('Stock_i','fontsize',12)
set(gca,'XTick',[0:39])
set(gca,'XTickLabel',{'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'})
set(gca,'FontSize',8)
axis([-1 40 0 1])

%% ZavrgZEQW
clear
Stock = StockList(1);
for c = 2:length(Stock)
    eval(sprintf('load %sZTPrmt175;',char(Stock(c))));
    ZStat(:,c-1) = ZTPrmt;
end
load AGGZTPrmt175;
Zaverage = mean(ZStat(:,:)');
plot(ZTPrmt,Zaverage,'.')
hold on
plot([norminv(0.999) norminv(0.999)],[-3 4])
title('$$\overline{z_{i}}$$ vs $$z_{EQW}$$','interpreter','latex','fontsize',12)
xlabel('$$z_{EQW}$$','interpreter','latex','fontsize',12)
ylabel('$$\overline{z_{i}}$$','interpreter','latex','fontsize',12,'rotation',90)
annotation1 = annotation('textarrow',[0.6664+.09 0.7133+.09],[0.2122 0.2122],'String',{'$$\Phi^{-1}(0.999)$$'},'interpreter','latex','fontsize',12);
axis([-3 4 -3 4])

%% Individual6days
clear
Stock = StockList(1);
for c = 2:length(Stock)
    eval(sprintf('load %sZTPrmt175;',char(Stock(c))));
    ZStat(:,c-1) = ZTPrmt;
end
load AGGZTPrmt175
Dayz = Returns(:,1:3);
Dayz = Dayz(1:23:end,:);
Dayz = Dayz(ZTPrmt>norminv(0.999),:);
ZStat = ZStat(ZTPrmt>norminv(0.999),:);
ZTPrmt = ZTPrmt(ZTPrmt > norminv(0.999));
for c = 1:6
    subplot(3,2,c)
    plot(ZStat(c,:),'.')
    hold
    plot([1 40],[norminv(0.999) norminv(0.999)])
    axis([0 41 -2 5])
    set(gca,'XTick',[1 [10:10:40]])
    set(gca,'XTickLabel',[1 [10:10:40]])
    set(gca,'FontSize',8)
    xlabel('Stock $$i$$','interpreter','latex','fontsize',12)
    ylabel('$$z_{i}$$','interpreter','latex','rotation',90,'fontsize',12)
    eval(sprintf('title(''$$z_{i}$$ on %0.0f-%0.0f-%0.0f, $$z_{EQW}$$ = %4.2f'',''interpreter'',''latex'',''fontsize'',12)',Dayz(c,2),Dayz(c,3),Dayz(c,1),ZTPrmt(c)))
    hold
    text(20,3.5,'$$\Phi^{-1}(0.999)$$','interpreter','latex')
end
suptitle('z_i | z_{EQW} > \Phi^{-1}(0.999)')
%% Number Jump Days
clear
Stock = StockList(1);
for c = 1:length(Stock)
    eval(sprintf('load %sZTPrmt175;',char(Stock(c))));
    Number(c) = sum(ZTPrmt > norminv(0.999));
end
bar(0:40,Number)
axis([ -1 41 0 35]);
set(gca,'XTick',[0:40])
set(gca,'XTickLabel',{'EQW';'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'})
ylabel('Number of Jump Days at 0.001 Level','fontsize',12)
set(gca,'FontSize',8)
title('Number of Jump Days in EQW and Individual Stocks','fontsize',12)
text(32, 30, 'Mean estimated jump days')
text(32,29, 'per stock = 22.1 days')
%% Individual Plots
close all
clear
load Sel;
p = 1
for d = [1 2 3]
    subplot(2,3,p)
    plot(580:17.5:960,100.*ReturnsSel((d-1)*22+1:d*22,4),'x-');
    eval(sprintf('title(''EQW Returns on %s-%s-%s z_{EQW} = %s'')',num2str(ReturnsSel(d*22,2)),num2str(ReturnsSel(d*22,3)),...
        num2str(ReturnsSel(d*22,1)),num2str(FlagDate(d,4))))
    xlabel('Time')
    ylabel('Returns, (%)')
    set(gca,'XTick',[600:60:960])
    set(gca,'XTickLabel',{'10';'11';'12';'1';'2';'3';'4'})
    axis([580 960 -.75 2.5])
    subplot(2,3,p+3)
    plot(580:17.5:960,(UStatSel((d-1)*22+1:d*22,1)-mean(UStatSel((d-1)*22+1:d*22,1)))/std(UStatSel((d-1)*22+1:d*22,1)),'x-');
    eval(sprintf('title(''z_{cp}on %s-%s-%s'')',num2str(ReturnsSel(d*22,2)),num2str(ReturnsSel(d*22,3)),num2str(ReturnsSel(d*22,1))))
    xlabel('Time')
    ylabel('z_{cp}')
    set(gca,'XTick',[600:60:960])
    set(gca,'XTickLabel',{'10';'11';'12';'1';'2';'3';'4'})
    p = p+1;
    axis([580 960 -1 5])
end
figure
p = 1;
for d = [4 5 6]
    subplot(2,3,p)
    plot(580:17.5:960,100.*ReturnsSel((d-1)*22+1:d*22,4),'x-');
    eval(sprintf('title(''EQW Returns on %s-%s-%s z_{EQW} = %s'')',num2str(ReturnsSel(d*22,2)),num2str(ReturnsSel(d*22,3)),...
        num2str(ReturnsSel(d*22,1)),num2str(FlagDate(d,4))))
    xlabel('Time')
    ylabel('Returns, (%)')
    set(gca,'XTick',[600:60:960])
    set(gca,'XTickLabel',{'10';'11';'12';'1';'2';'3';'4'})
    axis([580 960 -.75 2.5])
    subplot(2,3,p+3)
    plot(580:17.5:960,(UStatSel((d-1)*22+1:d*22,1)-mean(UStatSel((d-1)*22+1:d*22,1)))/std(UStatSel((d-1)*22+1:d*22,1)),'x-');
    eval(sprintf('title(''z_{cp}on %s-%s-%s'')',num2str(ReturnsSel(d*22,2)),num2str(ReturnsSel(d*22,3)),num2str(ReturnsSel(d*22,1))))
    xlabel('Time')
    ylabel('z_{cp}')
    set(gca,'XTick',[600:60:960])
    set(gca,'XTickLabel',{'10';'11';'12';'1';'2';'3';'4'})
    p = p+1;
    axis([580 960 -1 5])
end
%% AutocorrUstat
clear
load Sel
Autocorrs = zeros(21,1);
for d = 1:1241
    [a b c] = autocorr(UStat((d-1)*22+1:d*22));
    Autocorrs = Autocorrs + 1/1241*a;
end
stem(Autocorrs,'fill','r')
set(gca,'XTick',[1:2:20])
set(gca,'XTickLabel',{0   2   4   6   8  10  12  14  16  18  20})
set(gca,'YTick',[-0.2:0.2:1])
title('Mean of Daily Sample Autocorrelation of $$cp$$-statistic','interpreter','latex','fontsize',12)
ylabel('Autocorrelation')
xlabel('Lag')
axis([1 20 -0.2 1])
grid on
%% RJ AGG so Small, BV too
clear
close all
Stock = StockList(1);
for c = 1:length(Stock)
    eval(sprintf('load %sZTPrmt175;',char(Stock(c))));
    RJ(RJ<0) = 0;
    RJMean(c) = mean(RJ);
    BV(BV<0) = 0;
    BVMean(c) = mean(BV);
    RV(RV<0) = 0;
    RVMean(c) = mean(RV);
end
plot(0:40,RJMean*100,'*')
set(gca,'XTick',[0:40])
set(gca,'XTickLabel',{'EQW';'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'})
ylabel('$$\overline{RJ_{i,t}}$$, $$\overline{BV_{i,t}}$$ and $$\overline{RV_{i,t}}(\%) $$','interpreter','latex','fontsize',12,'rotation',90)
set(gca,'FontSize',8)
title('Sample Mean RV, BV and RJ of EQW and Stocks','fontsize',12)
axis([-1 41 0  15])
hold
plot(0:40,BVMean*100^2,'x',0:40,RVMean*100^2,'.')
legend('RJ','BV','RV')
plot(0,RJMean(1)*100,'s')
plot(0,RVMean(1)*100^2,'s')
%% UStatistics
clear
Stock = StockList(1);
for c = 2:length(Stock)
    eval(sprintf('load %sZTPrmt175;',char(Stock(c))));
    TotReturns(:,c-1) = Returns(:,7);
end
for d = 1:length(TotReturns)
    PseuReturns(:,1) = TotReturns(d,:);
    UStatTemp(d,1) = 1/(2*39*40)*(sum(sum(PseuReturns*PseuReturns')) - sum(PseuReturns'*PseuReturns));
end
load AGGZTPrmt175
ReturnsAGG = Returns(:,4);
clear Returns
%Calculating U-Stats and Returns for Intraday Returns
for d = 1:1241;
    UStat((d-1)*22+1:d*22,1) = UStatTemp(2+23*(d-1):23+23*(d-1));
    Returns((d-1)*22+1:d*22,1) = ReturnsAGG(2+23*(d-1):23+23*(d-1));
end
save UStat UStat Returns;
load UStat
plot(Returns(:,1),UStat,'.')
title('UStat vs Returns_{EQW}')
xlabel('Returns_{EQW}')
ylabel('U-Statistic')
axis([-0.021 0.035 -0.5E-4 5E-4])

%% u Stat Selective AGG
clear
Stock = StockList(1);
for c = 2:length(Stock)
    eval(sprintf('load %sZTPrmt175;',char(Stock(c))));
    TotReturns(:,c-1) = Returns(:,7);
end
for d = 1:length(TotReturns)
    PseuReturns(:,1) = TotReturns(d,:);
    UStatTemp(d,1) = 1/(2*39*40)*(sum(sum(PseuReturns*PseuReturns')) - sum(PseuReturns'*PseuReturns));
end
save UStatTemp
clear
load UStatTemp
load AGGZTPrmt175
FlagDate(:,1:3) = Returns(find(ZTPrmt > norminv(0.999)).*23,1:3);
FlagDate(:,4) = ZTPrmt(ZTPrmt > norminv(0.999));
ReturnsTemp = Returns;
clear Returns

% Intraday Returns and UStat Only 22 Returns
for d = 1:1241;
    UStat((d-1)*22+1:d*22,1) = UStatTemp(2+23*(d-1):23*d);
    Returns((d-1)*22+1:d*22,1:4) = ReturnsTemp(2+23*(d-1):23*d,1:4);
end
ReturnsSel = [];
UStatSel = [];
for d = 1:length(FlagDate)
    ReturnsSel =  [ReturnsSel; Returns(ismember(Returns(:,1:3),FlagDate(d,1:3),'rows'),:)];
    UStatSel =  [UStatSel; UStat(ismember(Returns(:,1:3),FlagDate(d,1:3),'rows'),:)];
end
Stock = StockList(1);
save Sel
clear
load Sel
for d = 1:6
    figure
    T = UStatSel((d-1)*22+1:d*22,1);
    I = find(T == max(T));
    MeanRet = 0;
    for c = 2:length(Stock)
        subplot(5,8,c-1)
        eval(sprintf('load %sZTPrmt175;',char(Stock(c))));
        ZDay = ZTPrmt(find(ismember(Returns(:,1:3),FlagDate(d,1:3),'rows')== 1,1,'last')/23);
        B = Returns(ismember(Returns(:,1:3),FlagDate(d,1:3),'rows'),:);
        A = B(2:length(B),7);
        plot(9+525/600:17.5/60:16,A(:).*100)
        set(gca,'XTick',[10:2:16])
        set(gca,'XTickLabel',{'10';'12';'14';'16'})
        hold on
        Time = 9+525/600:17.5/60:16;
        hold off
        axis tight;
        eval(sprintf('title(''%s'')',char(Stock(c))))
        h = get(gca,'Title');
        set(h,'FontSize',9)
        eval(sprintf('ylabel(''Z = %s'')',num2str(ZDay)))
        set(gca,'FontSize',9)
        h = get(gca,'YLabel');
        set(h,'FontSize',9)
    end
    set(gcf,'Position',[    -3          33        1280         705]);
    eval(sprintf('suptitle(''Individual Stock Returns on %s-%s-%s'')',num2str(FlagDate(d,2)),num2str(FlagDate(d,3)),num2str(FlagDate(d,1))));
end


%% RetvsZu
clear
load Sel;
for d = 1:1241
    UZ((d-1)*22+1:d*22,1) = (UStat((d-1)*22+1:d*22,1)-mean(UStat((d-1)*22+1:d*22,1)))/std(UStat((d-1)*22+1:d*22,1));
end
UZSig = UZ(UZ>=  4.1451);
RetSig = Returns(UZ>=  4.1451,4);
UZunSig = UZ(UZ<  4.1451);
RetunSig = Returns(UZ<  4.1451,4);
plot(UZSig,RetSig*100,'kx')
hold
plot(UZunSig,RetunSig*100,'k.')
title('$$r_{EQW}$$ vs $$z_{cp}$$','interpreter','latex','fontsize',12.5)
ylabel('$$r_{EQW},(\%)$$','interpreter','latex','fontsize',12.5)
xlabel('$$z_{cp}$$','interpreter','latex','fontsize',12.5)
legend('Significant at 0.001' , 'Not Significant at 0.001 ')



%% UStat varying Threshold
clear
load UStatsData22;
load AGGZTPrmt22;
for d = 1:1241
    UZ((d-1)*22+1:d*22,1) = (UStat((d-1)*22+1:d*22,1)-mean(UStat((d-1)*22+1:d*22,1)))/std(UStat((d-1)*22+1:d*22,1));
end
%sorting
Thres = 0.002:0.001:1;
UZTemp = [];
for t = 1:length(Thres)
    Flag = find(ZTPrmt<norminv(Thres(t)));
    for d = 1:length(Flag)
        UZTemp((d-1)*22+1:d*22,1) = UZ((Flag(d)-1).*22+1:Flag(d).*22,1);
    end
    LUZSig(t,1) = sum(UZTemp>norminv(0.999));
end
plot(Thres,LUZSig)
title('Confidence Level Threshold in Z-Stat Filter of Daily Data vs Number of Significant U-Stats')
ylabel('Number of U-Stats above norminv(0.999)')
xlabel('p-value of filter applied to Z_{EQW}')

%% KO bad plot
clear
load KOMin1
subplot(2,1,1)
plot(Price.Min1(:,7))
title('KO: Jan 2001 - DEC 2005\newline                Price','fontsize',11)
xlabel('Year','fontsize',11)
set(gca,'XTick',[1:length(Price.Min1)/5:length(Price.Min1)+1])
set(gca,'XTickLabel',{'2001';'2002';'2003';'2004';'2005';'2006'})
ylabel('Price ($)','fontsize',11)
subplot(2,1,2)
plot(price2ret(Price.Min1(:,7))*100)
xlabel('Year','fontsize',11)
set(gca,'XTick',[1:length(Price.Min1)/5:length(Price.Min1)+1])
set(gca,'XTickLabel',{'2001';'2002';'2003';'2004';'2005';'2006'})
ylabel('Percent Return','fontsize',11)
title('Returns','fontsize',11)

%% PG Example
close all
load Background
PricePlot = Price(57*23+1:59*23,7);
subplot(2,1,1)
plot(0:22,PricePlot(1:23),'.',23:45,PricePlot(24:end),'x')
A = 50*22/770:120*22/770:22;
A = 23+A;
set(gca,'XTick',[50*22/770:120*22/770:22, A] )
set(gca,'XTickLabel',{'10am';'11am';'12pm';'1pm';'2pm';'3pm';'4pm'})
title('Price of PG on March 26^{th}-27^{th} 2001, M = 22')
xlabel('j')
ylabel('Price, $')
axis([0,45,59,63])
subplot(2,1,2)
Returns = 100*(log(PricePlot(2:end))-log(PricePlot(1:end-1)));
Returns(23) = 0;
plot(1:22, Returns(1:22),'.',24:45, Returns(24:end),'x')
set(gca,'XTick',[50*22/770:120*22/770:22, A] )
set(gca,'XTickLabel',{'10am';'11am';'12pm';'1pm';'2pm';'3pm';'4pm'})
title('Returns of PG on March 26^{th}-27^{th} 2001, M = 22')
xlabel('j')
ylabel('Returns, %')
axis([0,45,-1.5,1.5])
%% PG ALL
clear
close all
load PGZTPrmt22
Price = Price(:,7);
figure
subplot(2,1,1)
Price(19643:end) = Price(19643:end)*2;
plot(Price(:,1))
title('Price of PG from 2001 to 2005, M = 22')
set(gca,'XTick',[1:length(Price)/5:length(Price)])
set(gca,'XTickLabel',{2001,2002,2003,2004,2005})
xlabel('Year')
ylabel('Price, $')
axis([0 1241*22 min(Price)-1 max(Price)+1])
subplot(2,1,2)
A(2:length(Price)) = 100*(log(Price(2:end))-log(Price(1:end-1)));
plot(A);
set(gca,'XTick',[1:length(Price)/5:length(Price)])
set(gca,'XTickLabel',{2001,2002,2003,2004,2005})
title('Returns of PG from 2001 to 2005, M = 22')
xlabel('Year')
ylabel('Returns, %')
axis([0 1241*22 -6 6])

%% PG Statistics
clear
load Background
Price = Price(:,7);
Price(19643:end) = Price(19643:end)*2;
% subplot(5,1,1)
% plot(100*(log(Price(2:end))-log(Price(1:end-1))))
% set(gca,'XTick',[1:length(Price)/5:length(Price)])
% set(gca,'XTickLabel',{2001,2002,2003,2004,2005})
% title('Returns of PG from 2001 to 2005, M = 22','fontsize',9)
% xlabel('Year','fontsize',9)
% ylabel('Returns, %','fontsize',9)
% axis([0 length(Price) -10 10])
% set(gca,'FontSize',8)
subplot(4,1,1)
plot(1:23:length(Price),10000*RV,'k')
set(gca,'XTick',[1:length(Price)/5:length(Price)])
set(gca,'XTickLabel',{2001,2002,2003,2004,2005})
title('Realized Variance','fontsize',10)
xlabel('Year','fontsize',10)
% ylabel('RV','fontsize',10)
set(gca,'FontSize',8)
axis([0 length(Price) 10000*min(RV) 10000*max(RV)])
subplot(4,1,2)
plot(1:23:length(Price),10000*BV,'k')
set(gca,'XTick',[1:length(Price)/5:length(Price)])
set(gca,'XTickLabel',{2001,2002,2003,2004,2005})
title('Bipower Variation','fontsize',10)
xlabel('Year','fontsize',10)
% ylabel('BV','fontsize',10)
set(gca,'FontSize',8)
axis([0 length(Price) 10000*min(BV) 10000*max(BV)])
subplot(4,1,3)
plot(1:23:length(Price),100*RJ,'k')
set(gca,'XTick',[1:length(Price)/5:length(Price)])
set(gca,'XTickLabel',{2001,2002,2003,2004,2005})
title('Relative Jump','fontsize',10)
xlabel('Year','fontsize',10)
% ylabel('RJ, %','fontsize',10)
set(gca,'FontSize',8)
axis([0 length(Price) 100*min(RJ) 100*max(RJ)])
subplot(4,1,4)
plot(1:23:length(Price),ZTPrmt,'k')
set(gca,'XTick',[1:length(Price)/5:length(Price)])
set(gca,'XTickLabel',{2001,2002,2003,2004,2005})
title('$$z$$','fontsize',12.5,'interpreter','latex')
xlabel('Year','fontsize',10)
% ylabel('$$z_{t}$$','fontsize',12.5,'interpreter','latex')
set(gca,'FontSize',8)
axis([0 length(Price) min(ZTPrmt) max(ZTPrmt)])
hold on
plot(1:length(Price),norminv(0.999),'k')
text(14500,3.5,'$$\Phi^{-1}(0.999)$$','interpreter','latex')
hold off
gtext('PG Sample Statistics from 2001 to 2005, M = 22')


%% PG One Day
clear
close all
load PGFreqCC
Price = Price.Freq770(884*771+1:885*771,7);
plot(Price,'.');
set(gca,'XTick',[51:120:771])
set(gca,'XTickLabel',{'10am';'11am';'12pm';'1pm';'2pm';'3pm';'4pm'})
xlabel('Time of Day')
ylabel('Price, $')
title('Price of Proctor&Gamble (PG) on August 3, 2004 sampled every 30 seconds from 9.35am to 4pm')

%% Counts
clear
Freq = [5     7    10    11    14    22    35    55    70    77   110   154   385];
i = 0;
for f = 6%:1:length(Freq)
%     i = i+1;
%     subplot(4,2,i)
    PPD = Freq(f);
    eval(sprintf('load Whatever%s;',num2str(PPD)));
    UStat = reshape(UStat,PPD,1241);
    UZ = zconv(UStat);
    Counts = sum(UZ' > 4.1451);
    plot(1:PPD,Counts,'-x')
    A = 50*(PPD-1)/770:120*(PPD-1)/770:PPD;
    set(gca,'XTick',[50*(PPD)/770:120*(PPD)/770:(PPD)] )
    set(gca,'XTickLabel',{'10am';'11am';'12pm';'1pm';'2pm';'3pm';'4pm'})
    xlabel('Time of Day')
    ylabel(' Counts of Significant $$z_{cp}$$','interpreter','latex','fontsize',12.5);
    title('Interday Counts of Significant $$z_{cp}$$','interpreter','latex','fontsize',12.5);
end

%% BNS_CP_Comparison
clear
close
load Sel;
for d = 1:1241
    UZ((d-1)*22+1:d*22,1) = (UStat((d-1)*22+1:d*22,1)-mean(UStat((d-1)*22+1:d*22,1)))/std(UStat((d-1)*22+1:d*22,1));
end
% CP in first row, BNS in second
UZ = reshape(UZ, 22,1241);
UZ = max(UZ);
load AGGZTPrmt175
scatter(ZTPrmt,UZ)
xlabel('$$z_{BNS}$$','interpreter','latex','fontsize',12.)
ylabel('Daily max($$z_{cp}$$)','interpreter','latex','fontsize',12.)
axis([-3 4.5 -3 7])
title('Comparing daily max($$z_{cp}$$) and $$z_{BNS}$$','interpreter','latex','fontsize',12)
text(-2.51,4.15,'(0.0163)    (0.0171)')
text(-2.51,4.08,'r^{2} = 0.110')

%% RetvsZu 5 mins
clear
PPD = 77;
load Sel5mins;
for d = 1:1241
    UZ((d-1)*(PPD)+1:d*(PPD),1) = (UStat((d-1)*(PPD)+1:d*(PPD),1)-mean(UStat((d-1)*(PPD)+1:d*(PPD),1)))/std(UStat((d-1)*(PPD)+1:d*(PPD),1));
end
UZSig = UZ(UZ>=  4.1451);
RetSig = Returns(UZ>=  4.1451,4);
UZunSig = UZ(UZ<  4.1451);
RetunSig = Returns(UZ<  4.1451,4);
plot(UZSig,RetSig*100,'kx')
hold
plot(UZunSig,RetunSig*100,'k.')
title('$$r_{EQW}$$ vs $$z_{cp}$$ at 5 minutes','interpreter','latex','fontsize',12.5)
ylabel('$$r_{EQW},(\%)$$','interpreter','latex','fontsize',12.5)
xlabel('$$z_{cp}$$','interpreter','latex','fontsize',12.5)
legend('Significant at 0.001' , 'Not Significant at 0.001 ')

%% TallOrder
clear
Stock = StockList(1);
Freq = [5     7    10    11    14    22    35    55    70    77   110   154   385];
for f = 1:length(Freq)
    PPD = Freq(f);
    clear Index
    for d = 1:1241
        Index((PPD+1)*(d-1)+1:(PPD+1)*d,1) = (d-1)*771+1:770/PPD:771*d;
    end
    for c = 1:length(Stock)
        eval(sprintf('load %sFreqCC',char(Stock(c))));
        Price = Price.Freq770(Index,:);
        Returns(2:length(Price),7) =  (log(Price(2:length(Price),7)) - log(Price(1:length(Price)-1,7)));
        Returns(1:length(Price),1:6) = Price(:,1:6);
        IntraDayIndex = zeros(length(Returns),1);
        IntraDayIndex(1:PPD+1:end) = 1;
        IntraDayIndex = ~IntraDayIndex;
        Returns = Returns(IntraDayIndex,7);
        [RV BV RJ ZTPrmt] = AllStats(Returns,PPD);
        eval(sprintf('save %sZTPrmt%s RV BV RJ ZTPrmt Returns Price;',char(Stock(c)),num2str(PPD)))
        sprintf('%sZTPrmt%s',char(Stock(c)),num2str(PPD))
    end
end

%% AGG FOR ALL
clear
Stock = StockList(1);
Freq = [5     7    10    11    14    22    35    55    70    77   110   154   385];
for f = 1:length(Freq)
    PPD = Freq(f);
    clear Index
    for d = 1:1241
        Index((PPD+1)*(d-1)+1:(PPD+1)*d,1) = (d-1)*771+1:770/(PPD):771*d;
    end
    ReturnsA = zeros(1241*(PPD+1),1);
    for c = 2:length(Stock)
        eval(sprintf('load %sFreqCC',char(Stock(c))));
        Price = Price.Freq770(Index,:);
        Returns(2:length(Price),1) =  (log(Price(2:length(Price),7)) - log(Price(1:length(Price)-1,7)));
        ReturnsA = ReturnsA + Returns;
    end
    Returns = ReturnsA/40;
    IntraDayIndex = zeros(length(Returns),1);
    IntraDayIndex(1:PPD+1:end) = 1;
    IntraDayIndex = ~IntraDayIndex;
    Returns = Returns(IntraDayIndex);
    [RV BV RJ ZTPrmt] = AllStats(Returns,PPD);
    eval(sprintf('save AGGZTPrmt%s RV BV RJ ZTPrmt Returns',num2str(PPD)))
    sprintf('AGGZTPRmt%s',num2str(PPD));
end
%% Forming the total returns at different frequencies.
clear
Freq = [5     7    10    11    14    22    35    55    70    77   110   154   385];
Stock = StockList(1);
for f = 1:length(Freq)
    PPD = Freq(f);
    for c = 2:length(Stock)
        eval(sprintf('load %sZTPrmt%s;',char(Stock(c)),num2str(PPD)))
        TotReturns(c-1,:) = Returns;
    end
    eval(sprintf('save TotReturns%s TotReturns',num2str(PPD)))
    clear TotReturns
end

%% CP Statistics for all
clear
Freq = [5     7    10    11    14    22    35    55    70    77   110   154   385];
Stock = StockList(1);
for f = 1:length(Freq)
    PPD = Freq(f);
    eval(sprintf('load TotReturns%s TotReturns',num2str(PPD)))
    for d = 1:size(TotReturns,2)
        PseuReturns = TotReturns(:,d);
        UStat(d,1) = 1/(2*39*40)*(sum(sum(PseuReturns*PseuReturns')) - sum(PseuReturns'*PseuReturns));
    end
    USig = zconv(reshape(UStat,PPD,length(UStat)/PPD));
    eval(sprintf('save USig%s USig',num2str(PPD)))
    clear UStat USig
end

%% CP Time of Jump for all
clear
load Sel;
for d = 1:1241
    UZ((d-1)*22+1:d*22,1) = (UStat((d-1)*22+1:d*22,1)-mean(UStat((d-1)*22+1:d*22,1)))/std(UStat((d-1)*22+1:d*22,1));
end
UZ = reshape(UZ, 22,1241)';
Counts = sum(UZ > 4.1451);
plot(1:22,Counts,'-x')
A = 50*21/770:120*21/770:22;
set(gca,'XTick',[50*22/770:120*22/770:22] )
set(gca,'XTickLabel',{'10am';'11am';'12pm';'1pm';'2pm';'3pm';'4pm'})
xlabel('Time of Day')
ylabel(' Counts of Significant $$z_{cp}$$','interpreter','latex','fontsize',12.5);
title('Interday Counts of Significant $$z_{cp}$$','interpreter','latex','fontsize',12.5);


%% Fixed Returns EQW vs Zcp Standardization
clear
Freq = [5     7    10    11    14    22    35    55    70    77   110   154   385];
K = 40;
km = 1;
for f = 6%1:length(Freq)
    PPD = Freq(f);
    eval(sprintf('load TotReturns%s TotReturns',num2str(PPD)))
    TotReturns = TotReturns';
    TotReturns = reshape(TotReturns,PPD,1241,40);
    BVsor = zeros(size(TotReturns));
    BVsor(2:end-1,:,:) = abs(TotReturns(1:end-2,:,:).^(0.5).*TotReturns(2:end-1,:,:).*TotReturns(3:end,:,:).^(0.5));
    RVsor = abs(TotReturns(:,:,:).^2);
    BVsor(1,:,:) = BVsor(2,:,:);
    BVsor(end,:,:) = BVsor(end-1,:,:);
    BVsor = pi/2*mean(BVsor,2);
    for i = 1:1241
    TotReturns(:,i,:) = TotReturns(:,i,:)./sqrt(BVsor);
    end
    TotReturns = reshape(TotReturns,1241*PPD,40);
    for d = 1:size(TotReturns,1)
        PseuReturns = TotReturns(d,:)';
        UStat(d,1) = 1/(2*K(km)*(K(km)-1))*(sum(sum(PseuReturns*PseuReturns')) - sum(PseuReturns'*PseuReturns));
    end
    eval(sprintf('save UStatsData%s UStat',num2str(PPD)))
    clear UStat 
end
%% Plotting new Zcp vs Ret
clear
load UStatsData22
load AGGZTPrmt22
for d = 1:1241
    UZ((d-1)*22+1:d*22,1) = (UStat((d-1)*22+1:d*22,1)-mean(UStat((d-1)*22+1:d*22,1)))/std(UStat((d-1)*22+1:d*22,1));
end
UZSig = UZ(UZ>=  4.1451);
RetSig = Returns(UZ>=  4.1451);
UZunSig = UZ(UZ<  4.1451);
RetunSig = Returns(UZ<  4.1451);
plot(UZSig,RetSig*100,'kx')
hold
plot(UZunSig,RetunSig*100,'k.')
title('$$r_{EQW}$$ vs $$z_{cp}$$','interpreter','latex','fontsize',12.5)
ylabel('$$r_{EQW},(\%)$$','interpreter','latex','fontsize',12.5)
xlabel('$$z_{cp}$$','interpreter','latex','fontsize',12.5)
legend('Significant at 0.001' , 'Not Significant at 0.001 ')
