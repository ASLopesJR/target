clear variables
clc
close all
%% constants
PE_TO_ADC          = (0.006875/0.0098);

%% load simulation data 
% row -> events
% col -> pmt number (1:16 = sup) (16:32 = inf)
load('../../target_files/data_sim_tvek.mat');
load('../../target_files/data_sim.mat');
load('../../target_files/data_sim_tvek_abs_maior.mat')
simulation_tvk     = (pmtstargettvek)';
simulation_tvk_abs = (pmttyvekAbsmaior)';
simulation_gore    = table2array(simulation)';

%% load real data
filename = 'data_max_SemFit';
load(['../../target_files/' filename]);
data_real         = round((1/PE_TO_ADC)*data_max);  


clear filename simulation pmtstargettvek pmttyvekAbsmaior data_max

%% histograma n events/pmt (realxsim)
hist_plot(simulation_tvk,data_real)
legend('simulation','real')

%% energy plots
corte = 500;
[bars.s,bars.r,norm] = energyHist(data_max,simulation_tvk,corte);
stairs(bars.s(1,:),bars.s(2,:)/norm.s,'LineStyle','--','LineWidth',1.0,'Color','k')
hold on
stairs(bars.r(1,:),bars.r(2,:)/norm.r,'LineStyle','-','LineWidth',1.0,'Color','k')
legend('real data','simulation tvk')
xlim([corte 15000])


%% energy histograms


[xr,yr] = energyboxplot(data_real,4);
[xs,ys] = energyboxplot(simulation_tvk,4);
close all
count  = 1;
for i = 1:1:32
    
       l{count} = ['R' int2str(i)];
       l{count+1} = ['Si' int2str(i)];
       count = count + 2;
end
boxplot([xr;xs], [yr-0.3;ys+0.3], 'whisker', 500,'Label',l);
xtickangle(90)
set(gca, 'YScale', 'log');

%% Events peak
ax = subplot(1,1,1);
peakAmpVar = data_real;
[M,I]=max(peakAmpVar);
idx1 = find(M~=0);
[ym,xm]       = histcounts(M(idx1), 50);
stairs(ax,xm(1:end-1),ym/(sum(diff(xm).*ym)),'LineStyle','-','LineWidth',1.0,'Color','k')
xlabel('Energy in the most energetic PMT (amplitude in PE counts)') % x-axis label
ylabel('Events') % y-axis label


ax2 = subplot(1,1,1);


%SUPERIOR
%[M,I]=max(peakAmpVar(1:16, :));
idx2 = find(M~=0 & I<=16);
histogram(ax2,M(idx2), 50, 'FaceColor','r','EdgeColor', 'r'); %histograma das máximos
set(gca, 'YScale', 'log');
xlabel('Energy in the most energetic PMT (amplitude in ADC counts)') % x-axis label
ylabel('Events') % y-axis label
hold(ax2,'on')
%INFERIOR
%[M,I]=max(peakAmpVar(17:32, :));
idx3 = find(M~=0 & I>16);
histogram(ax2,M(idx3), 50, 'FaceColor','b','EdgeColor', 'b'); %histograma das máximos
%set(gca, 'YScale', 'log');
%xlabel('Energy in the most energetic PMT (amplitude in ADC counts)') % x-axis label
%ylabel('Events') % y-axis label
%legend('FULL DETECTOR', ['SUP (' num2str((length(idx2)/length(idx1))*100, '%0.1f') '%)' ], ['INF (' num2str((length(idx3)/length(idx1))*100, '%0.1f') '%)' ]);
%alpha(0.2);




hold(ax,'on')
peakAmpVar = simulation_tvk;
[M,I]=max(peakAmpVar);
idx1 = find(M~=0);
[ym,xm]       = histcounts(M(idx1), 50);
stairs(ax,xm(1:end-1),ym/(sum(diff(xm).*ym)),'LineStyle','--','LineWidth',1.0,'Color','k')
legend('Real','Simulation')









%SUPERIOR
%[M,I]=max(peakAmpVar(1:16, :));
idx2 = find(M~=0 & I<=16);
hold on;
histogram(M(idx2), 50, 'FaceColor','r','EdgeColor', 'r'); %histograma das máximos
set(gca, 'YScale', 'log');
xlabel('Energy in the most energetic PMT (amplitude in ADC counts)') % x-axis label
ylabel('Events') % y-axis label

%INFERIOR
%[M,I]=max(peakAmpVar(17:32, :));
idx3 = find(M~=0 & I>16);
histogram(M(idx3), 50, 'FaceColor','b','EdgeColor', 'b'); %histograma das máximos
set(gca, 'YScale', 'log');
xlabel('Energy in the most energetic PMT (amplitude in ADC counts)') % x-axis label
ylabel('Events') % y-axis label
legend('FULL DETECTOR', ['SUP (' num2str((length(idx2)/length(idx1))*100, '%0.1f') '%)' ], ['INF (' num2str((length(idx3)/length(idx1))*100, '%0.1f') '%)' ]);
alpha(0.2);

%----------------------------------------------------------------------------------------
%energia máxima em uma PMT por evento em p.e.
%----------------------------------------------------------------------------------------
peakAmpVar_pe = peakAmpVar*ADC_TO_PE;
[M,I]=max(peakAmpVar_pe);
figure;
histogram(M(M~=0), 300); %histograma das máximos
set(gca, 'YScale', 'log');
xlabel('Energy in the most energetic PMT (p.e.)') % x-axis label
ylabel('Events') % y-axis label



%--------------------------------------------------------------
%FIM
%--------------------------------------------------------------


%--------------------------------------------------------------
% nr de fotoelétrons na PMT de maior energia 
% para planos inferior e superior
%--------------------------------------------------------------
iLim = 0;
sLim = Inf;

%superior e inferior
idx0 = find(M~=0 & M>iLim & M<=sLim);
figure;
PSupInf = M(idx0)./energia_pe(idx0);
histogram(M(idx0)./energia_pe(idx0), -0.05:0.1:1.05);

%superior
idx1 = find(I<=16 & M~=0 & M>iLim & M<=sLim);
PSup = M(idx1)./energia_pe(idx1);
hold on;
histogram(M(idx1)./energia_pe(idx1), -0.05:0.1:1.05);

%inferior
idx2 = find(I>16 & M~=0& M>iLim & M<=sLim);
PInf = M(idx2)./energia_pe(idx2);
histogram(M(idx2)./energia_pe(idx2), -0.05:0.1:1.05);

legend('INF+SUP', 'SUP','INF');
xlabel('número de fotoelétrons (%)') % x-axis label
ylabel('events') % y-axis label
set(gca, 'YScale', 'log');

%--------------------------------------------------------------
%FIM
%--------------------------------------------------------------



%--------------------------------------------------------------
% distribuição em ADC count na PMT por regiçao de energia
%--------------------------------------------------------------

save = 0;
step = 200;
upLimit = 1;
for i = 0:upLimit

   if i == 0 iLim = 3+step*i;
   else iLim = step*i;
   end

   sLim = step+step*i;
   idx = find(energia_pe>iLim & energia_pe<sLim & energia_pe~=0);
   energia_pe_reg = energia_pe(idx);

   %verificar corte em energia
   %figure;
   %histogram(energia_pe_reg, 'BinMethod','fd')

   figure;
   histogram(peakAmpVar(:, idx), 20)
   xlim([0 250]);

   %legend('INF+SUP', ['SUP (' num2str(ProbSup(i+1)*100,  '%0.2f') ')'],['INF (' num2str(ProbInf(i+1)*100, '%0.2f') ')']);
   xlabel('Energy (ADC counts)') % x-axis label
   ylabel('events') % y-axis label
   set(gca, 'YScale', 'log');
   title(['Energy from ' num2str(iLim) ' to ' num2str(sLim) ' fotoelétrons'])

   ADCmean(i+1) = mean2(peakAmpVar(:, idx));
   ADCrms(i+1) = std2(peakAmpVar(:, idx));

   %calcula percentagem saturada se ganho 10x maior
   idx2 = find((max(peakAmpVar)*9.8*10.5) > 1400);
   ['%PMTSat: ' num2str(iLim) '-' num2str(sLim) ' p.e. = ' num2str(length(idx2)/length(idx))]

   
   if save==1
      saveas(gca, [FOLDER 'ADCcountDist_Ener' num2str(iLim) '_' num2str(sLim) '.fig']);
      saveas(gca, [FOLDER 'ADCcountDist_Ener' num2str(iLim) '_' num2str(sLim) '.png']);
   end

   
end


figure;
errorbar((0:step:upLimit*step)+step/2, ADCmean , ADCrms);

xlabel('Event energy (p.e.)') % x-axis label
ylabel('Channel energy (ADC count)')


%--------------------------------------------------------------
%FIM
%--------------------------------------------------------------


%--------------------------------------------------------------
% nr de fotoelétrons na PMT de maior energia 
% para planos inferior e superior 
% (AGORA CORTANDO PELA ENERGIA TOTAL DO EVENTO)
%--------------------------------------------------------------
save = 0;
step = 100;
for i = 0:30;

   if i == 0 iLim = 10+step*i;
   else iLim = step*i;
   end

   sLim = step+step*i;
   idx3 = find(energia_pe>iLim & energia_pe<sLim & energia_pe~=0);
   energia_pe_reg = energia_pe(idx3);

   %verificar corte em energia
   figure;
   histogram(energia_pe_reg)
   %pause

   peakAmpVar_pe_reg = peakAmpVar_pe(:, idx3);
   [M,I]=max(peakAmpVar_pe_reg);
   %histogram(peakAmpVar_pe_reg)


   %superior e inferior
   figure;
   PSupInf = M./energia_pe_reg;
   h = histogram(M./energia_pe_reg, 'FaceColor','k','EdgeColor', 'k', 'BinMethod','fd');  
   if (i == 0) xlim([-0.05 1.05]);
   elseif (i == 1) xlim([-0.05 0.6]);
   else xlim([-0.05 0.4]);
   end
   ylim([0.1 max(h.Values)*1.1]);


   %superior
   idx1 = find(I<=16);   
   meanPSup(i+1) = mean2(M(idx1)./energia_pe_reg(idx1));
   rmsPSup(i+1) = std2(M(idx1)./energia_pe_reg(idx1));
   hold on;
   histogram(M(idx1)./energia_pe_reg(idx1), 'FaceColor','r','EdgeColor', 'r', 'BinMethod','fd', 'BinWidth', h.BinWidth);

   %inferior
   idx2 = find(I>16);
   meanPInf(i+1) = mean2(M(idx2)./energia_pe_reg(idx2));
   rmsPInf(i+1) = std2(M(idx2)./energia_pe_reg(idx2));
   PInf = M(idx2)./energia_pe_reg(idx2);
   histogram(M(idx2)./energia_pe_reg(idx2), 'FaceColor','b','EdgeColor', 'b', 'BinMethod','fd', 'BinWidth', h.BinWidth);

   ProbSup(i+1) = length(idx1)/length(M);
   ProbInf(i+1) = length(idx2)/length(M);
   legend('INF+SUP', ['SUP (' num2str(ProbSup(i+1)*100,  '%0.2f') ')'],['INF (' num2str(ProbInf(i+1)*100, '%0.2f') ')']);
   xlabel('número de fotoelétrons (%)') % x-axis label
   ylabel('events') % y-axis label
   set(gca, 'YScale', 'log');
   title(['Energy from ' num2str(iLim) ' to ' num2str(sLim) ' fotoelétrons'])

   alpha(0.2)

   if save==1      
      saveas(gca, [FOLDER '\MostEnePMT_Ener' num2str(iLim) '_' num2str(sLim) '.fig']);
      saveas(gca, [FOLDER '\MostEnePMT_Ener' num2str(iLim) '_' num2str(sLim) '.png']);
   end

end

figure;
plot((0:100:3000)+50, ProbSup, 'ro');
hold on;
plot((0:100:3000)+50, ProbInf, 'bo');

legend('SUP' , 'INF');
xlabel('Energy (p.e.)') % x-axis label
%ylabel('percentage of the most energetic PMTs in the superior (and inferior) plane (%)') % y-axis label
 ylabel({'Percentage of the most energetic PMTs', 'in the superior (and inferior) plane (%)'})
grid on;


figure;
errorbar((0:100:3000)+50, meanPSup, rmsPSup);
hold on;
errorbar((0:100:3000)+50, meanPInf, rmsPInf);

legend('SUP' , 'INF');
xlabel('Energy (p.e.)') % x-axis label
%ylabel('percentage of the most energetic PMTs in the superior (and inferior) plane (%)') % y-axis label
 ylabel('Energy (p.e.)')
grid on;

%salvei manualmente como EnePorcMostEnePMT.fig

%--------------------------------------------------------------
%FIM
%--------------------------------------------------------------




%--------------------------------------------------------------
% distribuição de energia na PMT superior e inferior
%--------------------------------------------------------------
save = 0;

peakAmpVar_pe_inf = peakAmpVar_pe(17:32, :);
peakAmpVar_pe_sup = peakAmpVar_pe(1:16, :);

step = 100;
for i = 0:30;

   if i == 0 iLim = 10+step*i;
   else iLim = step*i;
   end

   sLim = step+step*i;
   idx = find(energia_pe>iLim & energia_pe<sLim & energia_pe~=0);
   energia_pe_reg = energia_pe(idx);

   %verificar corte em energia
   %histogram(energia_pe_reg)

   peakAmpVar_pe_sup_reg = peakAmpVar_pe_sup(:, idx);
   peakAmpVar_pe_inf_reg = peakAmpVar_pe_inf(:, idx);

   figure;    
   histogram(sum(peakAmpVar_pe_sup_reg), 'FaceColor','r','EdgeColor', 'r', 'BinMethod','fd');
   hold on;
   histogram(sum(peakAmpVar_pe_inf_reg), 'FaceColor','b','EdgeColor', 'b', 'BinMethod','fd');

   EneSupRms(i+1) = std(sum(peakAmpVar_pe_sup_reg));
   EneSupMean(i+1) = mean(sum(peakAmpVar_pe_sup_reg));

   EneInfRms(i+1) = std(sum(peakAmpVar_pe_inf_reg));
   EneInfMean(i+1) = mean(sum(peakAmpVar_pe_inf_reg));

   alpha(0.2);

   title(['Energy from ' num2str(iLim) ' to ' num2str(sLim) ' fotoelétrons'])
   legend('SUP', 'INF');
   xlabel('Energy (p.e.)') % x-axis label
   ylabel('events') % y-axis label

   if save==1
      saveas(gca, [FOLDER 'EnergyDist_Ener' num2str(iLim) '_' num2str(sLim) '.fig']);
      saveas(gca, [FOLDER 'EnergyDist_Ener' num2str(iLim) '_' num2str(sLim) '.png']);
   end

end

figure;
errorbar((0:100:3000)+50, EneSupMean, EneSupRms);
hold on;
errorbar((0:100:3000)+50, EneInfMean, EneInfRms);

legend('SUP' , 'INF');
xlabel('Energy (p.e.)') % x-axis label
%ylabel('percentage of the most energetic PMTs in the superior (and inferior) plane (%)') % y-axis label
 ylabel('Energy (p.e.)')
grid on;

%--------------------------------------------------------------
%FIM
%--------------------------------------------------------------
