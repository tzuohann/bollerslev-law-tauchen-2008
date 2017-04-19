clear
load SystCompile
Umean = mean(UZSigall')';
Zmean = mean(Zall,3);
plot((1:10),Umean,'k.',(1:10),Zmean(:,1),'kx');
set(gca,'XTickLabel',{'0.1' '0.25' '0.5' '0.75' '1' '1.25' '1.5' '2' '3' '5'})
ylabel('Number of UStats and ZStats > 4.2491 (U) and 3.09 (Z)')
title('Mean Number of Significant U-stats from MC with T = 5 at Different Jump Size \sigma')

hold on

load IdioCompile
Zmean = mean(Zall,3);
Umean = mean(UZSigall')';
plot((1:10),Umean,'k^',(1:10),Zmean(:,1),'ks');


legend('Syst U', 'Syst Z', 'Idio U', 'Idio Z')