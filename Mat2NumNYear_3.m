%% Parameters
clear
Stock = StockList(1);
%AMEX BOSTON CINCI MIDWEST NYSE PACIFIC NASD PHILLY CBOE ABCMNPTXW
Ex = 'N';
Month = ['JAN';'FEB';'MAR';'APR';'MAY';'JUN';'JUL';'AUG';'SEP';'OCT';'NOV';'DEC'];
Freq = [50:50:100];

%% Combining files and double format only
for c = 2:length(Stock);
    %initializing Data
    eval(sprintf('Data = single(zeros(1,8));',char(Stock(c))))
    for x = 0:9999
        try
            %loading data
            eval(sprintf('load(''%s%s'')',char(Stock(c)),num2str(x,'%.4d')));
            %numbering month
            for m = 1:12;
                Mo = find(date(:,3) == Month(m,1) & date(:,4) == Month(m,2) & date(:,5) == Month(m,3));
                i(Mo,1) = str2num(date(Mo,6:9));
                i(Mo,2) = m;
            end
            DataP = [i All];
            % Specific Exchange
            DataP = single(DataP(find(ex == Ex),:));
            %combining
            Data = [Data ; DataP];
            %clearing variables
            clear i
        catch
            break
        end
    end
    %removing first line of zeros
    eval(sprintf('%sData = Data(2:length(Data),:);',char(Stock(c))));
    %saving numbers only data
    eval(sprintf('save %sData%s %sData;',char(Stock(c)),Ex,char(Stock(c))));
    %clearing data for memory
    eval(sprintf('clear %sData;',char(Stock(c))));
end

%% Splitting by year
for c = 1:length(Stock)
    %Loading Data and getting into general Data
    eval(sprintf('load %sData%s;',char(Stock(c)),Ex));
    eval(sprintf('Data = %sData;',char(Stock(c))));
    eval(sprintf('clear %sData;',char(Stock(c))));
    %Selecting Year
    for Year = 1993:2005
        PseuYr = Data(find(Data(:,1) == Year),:);
        if length(PseuYr) ~= 0
            eval(sprintf('save %sDate%s PseuYr;',char(Stock(c)),num2str(Year)))
        else
        end
    end
end

