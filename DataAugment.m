%% Computing the Daily Variance Covariance Matrix
clear
Stock = StockList(1);
for c = 2:length(Stock)
    eval(sprintf('load %sZTPrmt175',char(Stock(c))));
    Returns = Returns(:,7) + 1;
    Returns(1:23:end) = -9999;
    Returns = Returns(Returns ~= -9999);
    % Daily returns
    for d = 1:1241
        ReturnsAGGt(d,c-1) = prod(Returns((d-1)*22+1:d*22))-1;
    end
end
VCoV = cov(ReturnsAGGt);
save VCoV VCoV ;
%% Computing Intraday Variance Covariance Matrix
clear
load TotReturns22;
TotReturns = reshape(TotReturns,40,22,1241);
VCoV = zeros(40,40,22);
for i = 1:22
    for j = 1:1241
        ReturnsTmp = TotReturns(:,i,j);
        VCoV(:,:,i) = VCoV(:,:,i) + ReturnsTmp*ReturnsTmp';
    end
end
VCoV
VCoV = VCoV/1241;
save IntraVCoV VCoV ;

%% U Statistics or Returns
clear
state = 48916290;
rand('state', state);
randn('state', state);
Reps = 50;
T = 1241;

% % % % Rho*10
%  Rho = [8];
% % OTher inputs
% K = [40];
% M = [5     7    10    11    14    22    35    55    70    77   110   154   385];

load IntraVCoV
K = [40];
M = [22];
Rho = 'DI';

for km = length(K):length(K)
    for r = 1:length(Rho)
        for v = 1:22
            clear TotReturns
            DT = 1/M(km);
            %         VCoV = (1-Rho(r)/10)*eye(K(km),K(km)) + Rho(r)/10*ones(K(km),K(km));
            CholMat = chol(VCoV(:,:,v));
            clear VCoV;
            for n = 1:Reps
                TotReturns(1:M(km)*T,:) = DT*randn([M(km)*T, K(km)])*CholMat;
                % THIS PART
                TotReturns = reshape(TotReturns,M(km),T,K(km));
                BVsor = zeros(size(TotReturns));
                BVsor(2:end-1,:,:) = abs(TotReturns(1:end-2,:,:).^(0.5).*TotReturns(2:end-1,:,:).*TotReturns(3:end,:,:).^(0.5));
                BVsor(1,:,:) = BVsor(2,:,:);
                BVsor(end,:,:) = BVsor(end-1,:,:);
                BVsor = mean(BVsor,2);
                for i = 1:1241
                    TotReturns(:,i,:) = TotReturns(:,i,:)./sqrt(BVsor);
                end
                clear BVsor;
                TotReturns = single(TotReturns);
                %% THIS PART END
                for d = 1:size(TotReturns,1)
                    PseuReturns = TotReturns(d,:)';
                    UStat(d,rem(n,10)+1) = 1/(2*K(km)*(K(km)-1))*(sum(sum(PseuReturns*PseuReturns')) - sum(PseuReturns'*PseuReturns));
                end
                if rem(n,10) == 0
                    eval(sprintf('save UStatSims/UStatModRawNull0_%sK%sM%s_%s UStat',num2str(Rho(r)),num2str(K(km)),num2str(M(km)),num2str(n/10)));
                    clear UStat
                end;
                %     eval(sprintf('save SimJumps/SimTotReturns%s
                %     TotReturns',num2str(r)));
            end
        end
    end
end

%% Getting the 0.999 significance level from simulation
clear
% Rho*10
Rho = 'D';
% % % % OTher inputs
K = [40 40 40 40 40 40 40 40 40 40 40 40 40];
M = [5     7    10    11    14    22    35    55    70    77   110   154   385];
T = 1241;

for km = 1:length(K)
    for r = 1:length(Rho)
        UBig = [];
        for n = 1:10
            eval(sprintf('load UStatSims/UStatRawNull0_%sK%sM%s_%s UStat',num2str(Rho(r)),num2str(K(km)),num2str(M(km)),num2str(n)));
            for A = 1:10
                B = zconv(reshape(UStat(:,A),M(km),T));
                UBig = [UBig , B];
            end
        end
        UBig = sort(UBig(:));
        UBig(floor(numel(UBig) * 0.999));
        eval(sprintf('save UStatSims/UBig0_%sK%sM%s UBig',num2str(Rho(r)),num2str(K(km)),num2str(M(km))));
        sprintf('UStatSims/UBig0_%sK%sM%s \n',num2str(Rho(r)),num2str(K(km)),num2str(M(km)))
    end
end
%% Looking at them
clear
% Rho*10
Rho = [8];
% OTher inputs
K = [40,20,40,20];
M = [22,22,78,78];
T = 1241;

% load VCoV

for km = 1:length(K)
    for r = 1:length(Rho)
        UBig = [];
        for n = 1:10
            eval(sprintf('load UStatSims/UBig0_%sK%sM%s',num2str(Rho(r)),num2str(K(km)),num2str(M(km))));
        end
        UBig = sort(UBig(:));
        fprintf('Rho0_%sK%sM%s %f \n',num2str(Rho(r)),num2str(K(km)),num2str(M(km)),UBig(floor(numel(UBig) * 0.999)));
    end
end
%% Forming systematic jumps
clear
state = 09261984;
rand('state', state);
randn('state', state);
JI = [1.4]; %number jumps per year
JS = [0:0.075:1.5]; %std of jumps
JS = JS/100; %converting percent to fractions
load BetaAnnual

for T = 1:1000
    SystJumpPoiss = single(poissrnd(JI*5/(1241*22),[1241*22,1]));
    PoissIndex = [find(SystJumpPoiss > 0) , nonzeros(SystJumpPoiss)];
    L = size(PoissIndex,1);
    for js = 1:length(JS)
        %number * size
        SystJump = single(PoissIndex(:,2) .* normrnd(0,JS(js),[size(PoissIndex,1),1]));
        for i = 1:40;
            SystJumpTot(1:L,i,js) = SystJump*Beta(i+1);
        end
    end
    eval(sprintf('save SystJumpTot%s SystJumpTot PoissIndex',num2str(T)));
    clear SystJumpTot
end

%% Forming idiosyncratic jumps
clear
state = 19840926;
rand('state', state);
randn('state', state);

load JI %precalculated Jump Intensities
JI = single(JI/(1241*22)');
JS = [0:0.075:1.5]; ; %std of jumps
JS = JS/100; %converting percent to fractions

for T = 1:1000
    for ji = 1:length(JI)
        IdioJumpPoiss = single(poissrnd(JI(ji),[1241*22 1]));
        L = sum(IdioJumpPoiss>0);
        IdioPoissIndex(1:L,:,ji) = single([find(IdioJumpPoiss > 0) , nonzeros(IdioJumpPoiss)]);
        for js = 1:length(JS)
            %number * size
            IdioJumpTot(1:L,ji,js) = single(IdioPoissIndex(1:L,2,ji).*normrnd(0,JS(js),[L,1]));
        end
    end
    eval(sprintf('save IdioJumpTot%s IdioJumpTot IdioPoissIndex',num2str(T)));
    clear IdioJumpTot IdioPoissIndex
end

%% Adding Jumps
clear
load TotReturns
load Baseline
PPD = 22;
AddIdio = 0;
AddSyst  = 1;
AddIdioSyst = 0;

for T =1:1000
    T
    eval(sprintf('load SimJumps/IdioJumpTot%s.mat',num2str(T)));
    eval(sprintf('load SimJumps/SystJumpTot%s.mat',num2str(T)));
    % Filling in the base to the data that needs to be saved
    for i = 1:size(IdioJumpTot,3)
        UStat(:,i) = UStatBase;
        ZTPrmt(:,:,i) = ZTPrmtBase;
    end
    % Figuring out which days are changed for ZTP and returns for U
    %%% ADDED RETURNS
    RetAdd = [];
    Days = [];
    for i = 1:40;
        a = nonzeros(IdioPoissIndex(:,1,i));
        a = sortrows(unique([a; nonzeros(PoissIndex(:,1))]));
        RetAdd(1:length(a),i+1) = a;
    end
    i = nonzeros(unique(RetAdd));
    RetAdd(1:length(i),1) = sortrows(unique(i));
    %% ADDED DAYS
    for i = 1:41;
        a = sortrows(unique(ceil(nonzeros(RetAdd(:,i))/22)));
        Days(1:length(a),i) = a;
    end
    %% For Ustats, need all possible days where change was made
    RetAdd = nonzeros(RetAdd(:,1));
    % loop through the jump sizes
    for js = 1:size(IdioJumpTot,3)
        % Dumping in the original returns
        TotReturnsAug(:,2:41) = TotReturns;
        if ((AddIdio == 1) | (AddIdioSyst == 1));
            % adding idio jumps to dataset
            for i = 1:size(IdioJumpTot,2)
                L = length(nonzeros(IdioPoissIndex(:,1,i)));
                TotReturnsAug(nonzeros(IdioPoissIndex(:,1,i)),i+1) = TotReturnsAug(nonzeros(IdioPoissIndex(:,1,i)),i+1) + IdioJumpTot(1:L,i,js);
            end
        end
        if ((AddSyst == 1) | (AddIdioSyst == 1));
            TotReturnsAug(PoissIndex(:,1),2:41) = TotReturnsAug(PoissIndex(:,1),2:41) + SystJumpTot(:,:,js);
        end
        % reforming the index
        TotReturnsAug(:,1) = mean(TotReturnsAug(:,2:41),2);
        %Calculating Ustatistics
        for i = 1:numel(RetAdd)
            PseuReturns = TotReturnsAug(RetAdd(i),2:41)';
            UStat(RetAdd(i),js) = 1/(2*39*40)*(sum(sum(PseuReturns*PseuReturns')) - PseuReturns'*PseuReturns);
        end
        % calculating the BNS junk. %%% THIS NEEDS FIXING
        for i = 1:41
            % Extract returns on days that need fixing
            ReturnsTmp = [];
            for r = 1:length(nonzeros(Days(:,i)));
                ReturnsTmp = [ReturnsTmp; TotReturnsAug(22*(Days(r,i)-1)+1:22*Days(r,i),i)];
            end
            %Calculate the ZStats with Returns
            ZTPrmt(nonzeros(Days(:,i)),i,js) = ZStats(ReturnsTmp,PPD);
        end
    end
    if AddIdio == 1;
        eval(sprintf('save SimCalc/IdioOnlyAddedFast%s ZTPrmt UStat',num2str(T)))
    elseif AddSyst == 1;
        ZTPrmtFast = ZTPrmt; UStatFast = UStat;
        eval(sprintf('save SimCalc/SystOnlyAddedFast%s ZTPrmt UStat',num2str(T)))
    elseif AddIdioSyst == 1;
        ZTPrmtFast = ZTPrmt; UStatFast = UStat;
        eval(sprintf('save SimCalc/SystIdioAddedFast%s ZTPrmt UStat',num2str(T)))
    end
    clear ZTPrmt UStat
end
%% Compilation Syst and Idio
clear
AddIdio = 0;
AddSyst  = 1;
AddIdioSyst = 0;
T = 1000;
Days = zeros(21,1000);
UZsigall = zeros(21,1000);
Zall = zeros(41,21,1000);
for T = 1:T
    T
    if AddIdio == 1;
        eval(sprintf('load SimCalc/IdioOnlyAddedFast%s ZTPrmt UStat',num2str(T)))
    elseif AddSyst == 1;
        eval(sprintf('load SimCalc/SystOnlyInten%s ZTPrmt UStat',num2str(T)))
    elseif AddIdioSyst == 1;
        eval(sprintf('load SimCalc/SystIdioAddedFast%s ZTPrmt UStat',num2str(T)))
    end
    for js = 1:size(ZTPrmt,3)
        UStatjs = reshape(UStat(:,js),22,length(UStat(:,js))/22);
        UZ = zconv(UStatjs);
        Days(js,T) = sum(sum(UZ > 4.1451)>0);
        UZ = reshape(UZ,numel(UZ),1);
        Zall(:,js,T) = sum(ZTPrmt(:,:,js) > norminv(0.999));
        UZSigall(js,T) = sum(UZ(:,1) > 4.1451);
    end
end
if AddIdio == 1;
    save IdioCompileInten Zall UZSigall Days
elseif AddSyst == 1;
    save SystCompileInten Zall UZSigall Days
elseif AddIdioSyst == 1;
    save SystIdioCompileInten Zall UZSigall Days
end

%% Generating Syst Jumps vary inten
clear
state = 09261984;
rand('state', state);
randn('state', state);
JI = [0:10:200]; %number jumps per year
JS = 0.25; %std of jumps
JS = JS/100; %converting percent to fractions
load BetaAnnual

for T = 1:1000
    T
    for ji = 2:length(JI)
        SystJumpPoiss = single(poissrnd(JI(ji)*5/(1241*22),[1241*22,1]));
        L = numel(nonzeros(SystJumpPoiss));
        PoissIndex(1:L,:,ji) = [find(SystJumpPoiss > 0) , nonzeros(SystJumpPoiss)];
        SystJump = PoissIndex(1:L,2,ji) .* normrnd(0,JS,[L,1]);
        for i = 1:40;
            SystJumpTot(1:L,i,ji) = SystJump*Beta(i+1);
        end
    end
    eval(sprintf('save SimJumps/SystJumpInten%s SystJumpTot PoissIndex',num2str(T)));
    clear SystJumpTot PoissIndex
end
%% Calculating Varying Intensities
clear
AddSyst = 1;
load TotReturns
load Baseline;
PPD = 22;
for T =1:1000;
    T
    eval(sprintf('load SimJumps/SystJumpInten%s.mat',num2str(T)));
    %Getting the baseline statistics for the simulated returns
    for i = 1:size(SystJumpTot,3)
        UStat(:,i) = UStatBase;
        ZTPrmt(:,:,i) = ZTPrmtBase;
    end
    %%% ADDED RETURNS
    for ji = 2:size(SystJumpTot,3)
        % Figuring out which days are changed for ZTP and returns for U
        RetAdd = nonzeros(PoissIndex(:,1,ji));
        %% ADDED DAYS
        Days = ceil(RetAdd/22);
        % Dumping in the original returns
        TotReturnsAug(:,2:41) = TotReturns;
        if ((AddSyst == 1) | (AddIdioSyst == 1));
            TotReturnsAug(RetAdd,2:41) = TotReturnsAug(RetAdd,2:41) + SystJumpTot(1:numel(RetAdd),:,ji);
        end
        % reforming the index
        TotReturnsAug(:,1) = mean(TotReturnsAug(:,2:41),2);
        %Calculating Ustatistics
        for i = 1:numel(RetAdd)
            PseuReturns = TotReturnsAug(RetAdd(i),2:41)';
            UStat(RetAdd(i),ji) = 1/(2*39*40)*(sum(sum(PseuReturns*PseuReturns')) - PseuReturns'*PseuReturns);
        end
        % calculating the BNS junk.
        for i = 1:41
            % Extract returns on days that need fixing
            ReturnsTmp = [];
            for r = 1:length(Days);
                ReturnsTmp = [ReturnsTmp; TotReturnsAug(22*(Days(r)-1)+1:22*Days(r),i)];
            end
            %Calculate the ZStats with Returns
            ZTPrmt(Days,i,ji) = ZStats(ReturnsTmp,PPD);
        end
    end
    eval(sprintf('save SimCalc/SystOnlyInten%s ZTPrmt UStat',num2str(T)))
    clear ZTPrmt UStat
end