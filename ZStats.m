% Takes returns in columns each stock, give it returns per day and it gives
% back z
function ZTPrmt = ZStats(RawReturns,PPD);
for i = 1:size(RawReturns,2)
    StockReturns = reshape(RawReturns(:,i),PPD,length(RawReturns(:,i))/PPD);
    RV(:,i) = sum(StockReturns.*StockReturns)';
    RV(isnan(RV)) = 0;
    BV(:,i) = pi/2*PPD/(PPD-1)*sum(abs(StockReturns(2:end,:).*StockReturns(1:end-1,:)))';
    BV(isnan(BV)) = 0;
    RJ(:,i) = (RV(:,i)-BV(:,i))./RV(:,i);
    RJ(isnan(RJ)) = 0;
    TPrmt(:,i) = PPD*(2^(2/3)*gamma(7/6)/gamma(0.5))^(-3)*PPD/(PPD-2)*sum(abs(StockReturns(1:end-2,:).^(4/3).*StockReturns(2:end-1,:).^(4/3).*StockReturns(3:end,:).^(4/3)))';
    QPrmt(:,i) = PPD*(2^0.5*gamma(1)/gamma(0.5))^(-4)*77/74*sum(abs(StockReturns(1:end-3,:).*StockReturns(2:end-2,:).*StockReturns(3:end-1,:).*StockReturns(4:end,:)))';
    ZTPrmt(:,i) = RJ(:,i)./sqrt(((pi/2)^2+pi-5)/PPD*max(1,TPrmt(:,i)./BV(:,i).^2));
    ZQPrmt(:,i) = RJ(:,i)./sqrt(((pi/2)^2+pi-5)/PPD*max(1,QPrmt(:,i)./BV(:,i).^2));
end
