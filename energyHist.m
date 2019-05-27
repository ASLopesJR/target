function[out_s,out_r,area] = energyHist(data_sim,data_real,cut)

%% simulado
TH = 0; %threshold de dispado
%ADC_TO_PE = 0.0098/0.006875;
data_sim(data_sim<TH) = 0; %zerando as amplitudes abaixo de TH
energia_sim = sum(data_sim);
BIN = 600;  
energia_sim = energia_sim(energia_sim>cut);  % removendo baixa energia
[ys,xs]       = histcounts(energia_sim, BIN);
area.s        = sum(diff(xs).*ys);
%hold on
%bar(x(1:end-1),y/area,'FaceColor','none','EdgeColor','b')
%% real
TH = 3; %threshold de dispado
%ADC_TO_PE = 0.0098/0.006875;
data_real(data_real<TH) = 0; %zerando as amplitudes abaixo de TH
energia_real = sum(data_real);
%BIN = 600;
%YLIM = [0 140];   
energia_real  = energia_real(energia_real>cut);  % removendo baixa energia
[yr,xr]       = histcounts(energia_real, BIN);
area.r        = sum(diff(xr).*yr);
out_s         = [xs(1:end-1);ys];
out_r         = [xr(1:end-1);yr];
%hold on
%bar(xr(1:end-1),yr/area_r,'FaceColor','none','EdgeColor','k')
return 