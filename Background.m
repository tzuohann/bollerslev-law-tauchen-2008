%%
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
%%
clear
close all
load Background
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
subplot(2,1,2)
plot(100*(log(Price(2:end))-log(Price(1:end-1))))
set(gca,'XTick',[1:length(Price)/5:length(Price)])
set(gca,'XTickLabel',{2001,2002,2003,2004,2005})
title('Returns of PG from 2001 to 2005, M = 22')
xlabel('Year')
ylabel('Returns, %')

%%
clear
load Background
Price = Price(:,7);
Price(19643:end) = Price(19643:end)*2;
subplot(5,1,1)
plot(100*(log(Price(2:end))-log(Price(1:end-1))))
set(gca,'XTick',[1:length(Price)/5:length(Price)])
set(gca,'XTickLabel',{2001,2002,2003,2004,2005})
title('Returns of PG from 2001 to 2005, M = 22','fontsize',9)
xlabel('Year','fontsize',9)
ylabel('Returns, %','fontsize',9)
axis([0 length(Price) -10 10])
set(gca,'FontSize',8)
subplot(5,1,2)
plot(1:23:length(Price),10000*RV)
set(gca,'XTick',[1:length(Price)/5:length(Price)])
set(gca,'XTickLabel',{2001,2002,2003,2004,2005})
title('RV from 2001 to 2005, M = 22','fontsize',9)
xlabel('Year','fontsize',9)
ylabel('RV, %','fontsize',9)
set(gca,'FontSize',8)
axis([0 length(Price) 10000*min(RV) 10000*max(RV)])
subplot(5,1,3)
plot(1:23:length(Price),10000*BV)
set(gca,'XTick',[1:length(Price)/5:length(Price)])
set(gca,'XTickLabel',{2001,2002,2003,2004,2005})
title('BV from 2001 to 2005, M = 22','fontsize',9)
xlabel('Year','fontsize',9)
ylabel('BV, %','fontsize',9)
set(gca,'FontSize',8)
axis([0 length(Price) 10000*min(BV) 10000*max(BV)])
subplot(5,1,4)
plot(1:23:length(Price),100*RJ)
set(gca,'XTick',[1:length(Price)/5:length(Price)])
set(gca,'XTickLabel',{2001,2002,2003,2004,2005})
title('RJ from 2001 to 2005, M = 22','fontsize',9)
xlabel('Year','fontsize',9)
ylabel('RJ, %','fontsize',9)
set(gca,'FontSize',8)
axis([0 length(Price) 100*min(RJ) 100*max(RJ)])
subplot(5,1,5)
plot(1:23:length(Price),ZTPrmt)
set(gca,'XTick',[1:length(Price)/5:length(Price)])
set(gca,'XTickLabel',{2001,2002,2003,2004,2005})
title('z_{TP,rm,t} from 2001 to 2005, M = 22','fontsize',9)
xlabel('Year','fontsize',9)
ylabel('z_{TP,rm,t}','fontsize',9)
set(gca,'FontSize',8)
axis([0 length(Price) min(ZTPrmt) max(ZTPrmt)])
hold on
plot(1:length(Price),norminv(0.999))
text(14500,3.5,'$$\Phi^{-1}(0.999)$$','interpreter','latex')
hold off

%%
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

