%Timeline of dataset 5/3/2004 – 5/3/2009 CAPITAL MARKET INDICE 'CANADA'
w=100;
indiceCAN = zeros (w,13);  
Log_return_CAN = zeros(w-1,13);
Return_CAN = zeros (w-1,13);
%Time series split into 13 windows
Index_change_CAN = zeros (w-1,13);
for i=1:13
    indiceCAN(:,i)=CAN((i-1)*w+1:i*w);
    Index_change(:,i)= diff((indiceCAN(:,i)));
    for j = 1:99
        Log_return_CAN(j,i)= log(indiceCAN(j+1,i)/indiceCAN(j,i));
        Return_CAN(j,i)= (indiceCAN(j+1,i)-indiceCAN(j,i))/indiceCAN(j,i);
    end
end
%Plot of index in 13 windows
for i=1:13
   figure(i)
   plot(indiceCAN(:,i),'black');
   ylabel('Capital Market Indice');
   xlabel('observations');
   title('CANADA');
   set(gca,'FontName','Calibri','FontSize',10);
   %savefig(strcat('sample1',int2str(i)));
   hold on
end
% %Plot of log returns in 13 windows
 for i=1:13
    figure(i+13)
    plot(Return_CAN(:,i),'b');
    ylabel('Capital Market Indice Returns');
    xlabel('observations');
    title('CANADA');
    set(gca,'FontName','Calibri','FontSize',10);
    %savefig(strcat('sample2',int2str(i)));
    hold on
end
%Autocorrelation of log returns
for i = 1:13
    figure(i+26)
    autocorr(Log_return_CAN(:,i),'NumLags',35,'NumSTD',2);
    title(sprintf('Autocorrelation %d',i));
    ylabel('Canada Index')
    set(gca,'FontName','Calibri','FontSize',10);
    hold on
end
% %Partial correlation of log returns
for i = 1:13
    figure(i+39)
    parcorr(Log_return_CAN(:,i))
    title(sprintf('Partial Correlation %d',i));
    ylabel('Canada Index')
    set(gca,'FontName','Calibri','FontSize',10)
    hold on
end


%Estimating model based on AIC,BIC for every window
for en=1:13
    fit = 1;
    CAN_train = Return_CAN(1:90,en);
    
   for p = 0:2  
         for q= 0:2
            ARIMA_I = arima(p,0,q);
            [model_temp,~,Loglike] = estimate(ARIMA_I,CAN_train,'display','off');
            [aicE,bicE] = aicbic(Loglike,2,100);
            NAme = convertCharsToStrings(strcat('ARMA(',num2str(p),',',num2str(q),')'));
            model_CANADA_returns(fit,en) = model_temp;
            if en==1
                Name(fit) = NAme;
            end
            AIC(fit,en) = aicE;
            BIC(fit,en) = bicE;
            fit=fit+1;
         end
   end

end

best_fit_AIC = zeros(en,2);
best_fit_BIC = zeros(en,2);
for en = 1:13
    fit =1;
    minAIC = AIC (1,en);
    minBIC = BIC (1,en);
    minAIC_CANADA = [0,0];
    minBIC_CANADA = [0,0];
    for p = 0:2
      for q = 0:2
          if AIC(fit,en) < minAIC
              minAIC_CANADA = [p,q];
              minAIC = AIC(fit,en);
          end
          if BIC(fit,en) < minBIC
              minBIC_CANADA = [p,q];
              minBIC = BIC(fit,en);
          end
          fit = fit +1;
      end
    end
    best_fit_aic_CANADA(en,:) = minAIC_CANADA; % ΚΑΤΑΛΛΗΛΟ ΜΟΝΤΕΛΟ ΓΙΑ ΚΑΘΕ WINDOW
    best_fit_bic_CANADA(en,:) = minBIC_CANADA; % -//-

    fit = minAIC_CANADA(1)*3+minAIC_CANADA(2)+1;
    X = [1,2,3,4,5,6,7,8,9];
    Y = [0,0,0,0,0,0,0,0,0];
    for i=1:9
        if i==fit
            Y(i) = AIC(fit,en);
        end
    end
    figure
    stem(AIC(:,en),'diamondk','marker','.')
    title(sprintf('AIC CANADA %d',en))
    xticklabels(Name)
    ylim([-700 -100])
    hold on
    grid on
    stem(X,Y,'LineStyle','--','MarkerFaceColor','yellow','MarkerEdgeColor','black')
    legend({'best fit,yellow dot'},'Color','y');
    hold off

    fit = minBIC_CANADA(1)*3+minBIC_CANADA(2)+1;
    X = [1,2,3,4,5,6,7,8,9];
    Y = [0,0,0,0,0,0,0,0,0];
    for i=1:9
        if i==fit
            Y(i) = BIC(fit,en);
        end
    end
    figure
    stem(BIC(:,en),'diamondk','marker','.')
    title(sprintf('BIC CANADA %d',en))
    xticklabels(Name)
    ylim([-700 -100])
    hold on
    grid on
    stem(X,Y,'LineStyle','--','MarkerFaceColor','yellow','MarkerEdgeColor','black')
    legend({'best fit,yellow dot'},'Color','y');
    hold off
 end
%Training the data and fitting the model
for i=1:13
    CAN_train = Return_CAN(1:90,i);
    p = best_fit_aic_CANADA(i,1);
    q = best_fit_aic_CANADA(i,2);
    %In the last 3 windows MA(2) explodes so MA(1) is chosen instead
    if i==11
    q = best_fit_aic_CANADA(3,2);
    elseif i==12
    q = best_fit_aic_CANADA(3,2);
    elseif i==13
    q = best_fit_aic_CANADA(3,2);
    end
    fit = p*3+q+1;
    md = model_CANADA_returns(fit,i);
    residuals = infer(md,CAN_train);
    obs_fit = CAN_train - residuals;
    %Fitting model on log returns
    figure
    clf
    plot(CAN_train,'k')
    hold on
    plot(obs_fit,'g')
    title('Fit model on Returns',i)
    xlabel('Train Sample')
    ylabel('Returns')
    legend('Returns',sprintf('ARMA(%d,%d)',p,q))
    hold off
    
    CAN_train = indiceCAN(1:90,i);
    ARIMA_I = arima(p,0,q);
    md = estimate(ARIMA_I,CAN_train,'display','off');
    mdCAN(i) = md;
    residuals = infer(md,CAN_train);
    obs_fit = CAN_train - residuals;
    %Fitting model on index
    figure
    clf
    plot(CAN_train,'k')
    hold on
    plot(obs_fit,'g')
    title('Fit model on Index',i)
    xlabel('Train Sample')
    ylabel('Capital Market Indice')
    legend('C M Indice',sprintf('ARMA(%d,%d)',p,q))
    hold off


end
%Prediction for 1,2 steps 
%NRMSE estimation for each window
N=2;
for i =1:13
    CAN_test = indiceCAN(91:end,i);
    CAN_train = indiceCAN(1:90,i);
    Prediction = forecast(mdCAN(i),N,'Y0',CAN_train);
    NRMSE = mean(CAN_test(1:N)-Prediction).^2/mean(CAN_test(1:N).^2);
    for j=1:13
        j=NRMSE;
    end
    figure
    plot(CAN_test(1:N),'k')
    hold on
    plot(Prediction,'g')
    title(sprintf('CANADA INDICE PREDICTION %d',i))
    ylabel('Capital Market Indice')
    xlabel('step 1 2')
    lgd=legend({'Indice','Prediction'},'Location','southeast');
    title(lgd,sprintf('NRMSE(%d)',j),'FontSize',10)
    legend('boxoff')
    hold off
  
end



