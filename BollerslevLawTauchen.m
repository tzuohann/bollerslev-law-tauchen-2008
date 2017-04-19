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
    Returns = Returns(:,7);
    Returns(1:23:end) = -9999;
    Returns = Returns(Returns ~= -9999);
    [Beta(c-1,:)] = polyfit(ReturnsAGG,Returns,1);
end
CorrelationZ(:,1) = CorrelationZ(:,1).^2;

subplot(2,1,1)
plot(0:39,Beta(:,1),'k.')
title('5 Year $$\beta_{i}$$ ; M = 22','interpreter','latex','fontsize',12)
ylabel('$$\beta_{i}$$','interpreter','latex','fontsize',12.5)
set(gca,'XTick',[0:39])
set(gca,'XTickLabel',{'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'})
set(gca,'FontSize',8)
xlabel('Stock_i','fontsize',12)

subplot(2,1,2)
plot(0:39,CorrelationZ(:,1),'r.')
title('corr(z_i,z_{EQW})','fontsize',12)
ylabel('r^2','fontsize',12)
xlabel('Stock_i','fontsize',12)
set(gca,'XTick',[0:39])
set(gca,'XTickLabel',{'ABT';'AIG';'AXP';'BAC';'BLS';'BMY';'C';'DNA';'FNM';'GE';'GS';'HD';'IBM';'JNJ';'JPM';'KO';'LLY';'LOW';'MCD';'MDT';'MER';'MMM';'MO';'MOT';'MRK';'NOK';'PEP';'PFE';'PG';'SLB';'TGT';'TXN';'TYC';'UPS';'UTX';'VZ';'WB';'WFC';'WMT';'XOM'})
set(gca,'FontSize',8)


%% Zaverage vs Zagg
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
plot([norminv(0.999) norminv(0.999)],[-.8 1.2])
title('$$\overline{z_{TP,rm,t,i}}$$ vs $$z_{TP,rm,t,EQW}$$','interpreter','latex','fontsize',12)
xlabel('$$z_{TP,rm,t,EQW}$$','interpreter','latex','fontsize',12)
ylabel('$$\overline{z_{TP,rm,t,i}}$$','interpreter','latex','fontsize',12,'rotation',90)
annotation1 = annotation('textarrow',[0.6664+.09 0.7133+.09],[0.2122 0.2122],'String',{'$$\Phi^{-1}(0.999)$$'},'interpreter','latex','fontsize',12);

%% Individual 6 days out of 7
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
    set(gca,'XTickLabel',[2:1:40])
    set(gca,'FontSize',8)
    xlabel('Stock $$i$$','interpreter','latex','fontsize',12)
    ylabel('$$z_{TP,rm,t,i}$$','interpreter','latex','rotation',90,'fontsize',12)
    eval(sprintf('title(''$$z_{TP,rm,t,i}$$ on %0.0f-%0.0f-%0.0f, $$z_{TP,rm,t,EQW}$$ = %4.2f'',''interpreter'',''latex'',''fontsize'',12)',Dayz(c,2),Dayz(c,3),Dayz(c,1),ZTPrmt(c)))
    hold
    text(20,3.5,'$$\Phi^{-1}(0.999)$$','interpreter','latex')
end
suptitle('z_i | z_{EQW} > \Phi^{-1}(0.999)')
%% Number of jumps per stock
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
ylabel('Number of Jump Days at 99.9% Significance Level','fontsize',12)
set(gca,'FontSize',8)
title('Number of Jump Days in EQW and Individual Stocks','fontsize',12)
text(32, 30, 'Mean estimated jump days')
text(32,29, 'per stock = 22.1 days')

%% Return UStat 3 Plots
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
    axis tight
    subplot(2,3,p+3)
    plot(580:17.5:960,(UStatSel((d-1)*22+1:d*22,1)-mean(UStatSel((d-1)*22+1:d*22,1)))/std(UStatSel((d-1)*22+1:d*22,1)),'x-');
    eval(sprintf('title(''Standardized U-Stat on %s-%s-%s'')',num2str(ReturnsSel(d*22,2)),num2str(ReturnsSel(d*22,3)),num2str(ReturnsSel(d*22,1))))
    xlabel('Time')
    ylabel('z_{U}')
    set(gca,'XTick',[600:60:960])
    set(gca,'XTickLabel',{'10';'11';'12';'1';'2';'3';'4'})
    p = p+1;
    axis tight
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
    axis tight
    subplot(2,3,p+3)
    plot(580:17.5:960,(UStatSel((d-1)*22+1:d*22,1)-mean(UStatSel((d-1)*22+1:d*22,1)))/std(UStatSel((d-1)*22+1:d*22,1)),'x-');
    eval(sprintf('title(''Standardized U-Stat on %s-%s-%s'')',num2str(ReturnsSel(d*22,2)),num2str(ReturnsSel(d*22,3)),num2str(ReturnsSel(d*22,1))))
    xlabel('Time')
    ylabel('z_{U}')
    set(gca,'XTick',[600:60:960])
    set(gca,'XTickLabel',{'10';'11';'12';'1';'2';'3';'4'})
    p = p+1;
    axis tight
end
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

%% Usig vs Ret_AGG | USig
clear
load Sel;
for d = 1:1241
    UZ((d-1)*22+1:d*22,1) = (UStat((d-1)*22+1:d*22,1)-mean(UStat((d-1)*22+1:d*22,1)))/std(UStat((d-1)*22+1:d*22,1));
end
UZSig = UZ(UZ>norminv(0.999));
RetSig = Returns(UZ>norminv(0.999),4);
UZunSig = UZ(UZ<norminv(0.999));
RetunSig = Returns(UZ<norminv(0.999),4);
plot(UZSig,RetSig*100,'k.')
hold
plot(UZunSig,RetunSig*100,'kx')
title('$$r_{t,j,EQW}$$ vs $$z_{U,t,j}$$','interpreter','latex','fontsize',12.5)
ylabel('$$r_{t,j,EQW},(\%)$$','interpreter','latex','fontsize',12.5)
xlabel('$$z_{U,t,j}$$','interpreter','latex','fontsize',12.5)
legend('Significant at \Phi^{-1}(0.999)' , 'Not Significant at \Phi^{-1}(0.999)','best')
grid minor
