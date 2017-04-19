%% Splits files in chunks
Stock = StockList(1);
for x = 1:length(Stock)
    try
        eval(sprintf('!csplit -k -f %s -n 4 %s.txt 100000 {100000000}',char(Stock(x)),char(Stock(x))))
    catch
    end
    eval(sprintf('delete %s.txt',char(Stock(x))));
end