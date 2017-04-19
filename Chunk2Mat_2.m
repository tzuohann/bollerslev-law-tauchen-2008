clear
%list of stocks
Stock = StockList(1);
%% Loading Data
%strings
Skp = '%*s';
Str = '%s';
Num = '%f';
for s = 1:length(Stock)
    for c = 0:9999
        try
            if c == 0
                eval(sprintf('[DATE TIME PRICE VOL EX] = textread(''%s%s'',''%s%s%s%s%s%s'',''headerlines'',1);',char(Stock(s)),num2str(c,'%.4d'),Skp,Str,Str,Num,Num,Str));
            else
                eval(sprintf('[DATE TIME PRICE VOL EX] = textread(''%s%s'',''%s%s%s%s%s%s'');',char(Stock(s)),num2str(c,'%.4d'),Skp,Str,Str,Num,Num,Str));
            end
            %numbering stuff and correcting for white space in time
            date = char(DATE);
            TIME = char(TIME);
            I1 = find(str2num(TIME(:,1))>3);
            hour(I1,1) = str2num(TIME(I1,1));
            minute(I1,1) = str2num(TIME(I1,3:4));
            second(I1,1) = str2num(TIME(I1,6:7));
            I2 = find(str2num(TIME(:,1))<3);
            hour(I2,1) = str2num(TIME(I2,1:2));
            minute(I2,1) = str2num(TIME(I2,4:5));
            second(I2,1) = str2num(TIME(I2,7:8));
            day = str2num(date(:,1:2));
            All = [day hour minute second PRICE VOL];
            ex = char(EX);
            %saving data
            eval(sprintf('save %s%s All date ex;',char(Stock(s)),num2str(c,'%.4d')));
            clear hour minute second
        catch
            break
        end
    end
end
