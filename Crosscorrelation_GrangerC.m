%In order to run properly make sure to run the variables from
%GERMANY,CANADA first,at least until line 16.

%Crosscorrelation

for i=1:13
    figure(1*i)
    crosscorr(Log_return_CAN(:,i),Log_return_GER(:,i))
    title(sprintf('Cross Correlation %d',i));
    hold on
end

%GRANGER CASUALITY

for i=1:13
 sample_CAN=Return_CAN(:,i);
 sample_GER=Return_GER(:,i);
 
 tbl=table(sample_CAN,sample_GER);
 tbl = rmmissing(tbl);
 T = size(tbl,1);

 numseries=2;
 numlags=(1:4);
 nummdls=numel(numlags);

 maxp=max(numlags);
 idxpre=1:maxp;
 idxest=(maxp+1):T;
 EstMdl(nummdls)=varm(numseries,0);
 aic=zeros(nummdls,1);

 Y0 = tbl{idxpre,:}; % Presample
 Y = tbl{idxest,:};  % Estimation sample
 for j = 1:numel(numlags)
     Mdl = varm(numseries,numlags(j));
     Mdl.SeriesNames = tbl.Properties.VariableNames;
     EstMdl(j) = estimate(Mdl,Y,'Y0',Y0);
     results = summarize(EstMdl(j));
     aic(j) = results.AIC;
 end

    [~,bestidx] = min(aic);
    p = numlags(bestidx)

    BestMdl = EstMdl(bestidx);

    h = gctest(BestMdl)
    [~,Summary] = gctest(BestMdl,'Display',false)
    pvalues=Summary.PValue
end
 







