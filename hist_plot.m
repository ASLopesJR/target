function hist_plot(data_simulation,data_real)
    
    TH = 0; %threshold de dispado
    data_OverTh = (data_simulation'>TH); %matriz 32x10000


    %----------------------------------------------------------------------------------------
    %número de PMTs disparadas por evento (-->vetor de 10000)
    %----------------------------------------------------------------------------------------
    Ndisp = sum(data_OverTh,2);
    %figure;
    histogram(Ndisp, -0.5:33,'Normalization','probability','FaceColor','none','EdgeColor','k','FaceAlpha',0.2,'LineStyle','--');
    set(gca, 'YScale', 'log');
    xlim([-0.5 32.5]);
    xlabel('Number of fired PMTs') % x-axis label
    ylabel('Events') % y-axis label
    %ylim([1 10e4])

    hold on

    TH = 4; %threshold de dispado
    
    data_OverTh = (data_real'>TH); %matriz 32x10000
    Ndisp = sum(data_OverTh,2);
    Ndisp = Ndisp(Ndisp>0);
    %figure;

    histogram(Ndisp, -0.5:33,'Normalization','probability','FaceColor','none','EdgeColor','k');
    set(gca, 'YScale', 'log');
    xlim([-0.5 32.5]);
    xlabel('Number of fired PMTs') % x-axis label
    ylabel('Events') % y-axis label
    ylim([10e-5 1])
    
    %ADC_TO_PE = 0.0098/0.006875;
    %ADC_TO_PE = 0.0098/0.006875;
end