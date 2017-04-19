function Z = zconv(X);
Stdev = std(X);
Average = mean(X);
for r = 1:size(X,1);
    Z(r,:) = (X(r,:) - Average)./(Stdev);
end