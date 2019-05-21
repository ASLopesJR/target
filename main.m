clear variables
clc
close all
%% load simulation data 
% row -> events
% col -> pmt number (1:16 = sup) (16:32 = inf)
load('../../target_files/data_sim.mat');

%% load real data
filename = 'data_max_SemFit';
load(['../../target_files/' filename]);
data_max = data_max';
peakAmpVar = data_max';
peakAmpVar = data_sim;
%********************************
%PARÂMETROS GLOBAIS AJUSTÁVEIS
%********************************
TH = 0; %threshold de dispado
ADC_TO_PE = 0.0098/0.006875;
data_OverTh = (peakAmpVar>TH); %matriz 32x10000


%----------------------------------------------------------------------------------------
%número de PMTs disparadas por evento (-->vetor de 10000)
%----------------------------------------------------------------------------------------
Ndisp = sum(data_OverTh');
%figure;
histogram(Ndisp, -0.5:33,'Normalization','probability');
set(gca, 'YScale', 'log');
xlim([-0.5 32.5]);
xlabel('Number of fired PMTs') % x-axis label
ylabel('Events') % y-axis label
%ylim([1 10e4])

hold on

peakAmpVar = data_max';
TH = 3; %threshold de dispado
ADC_TO_PE = 0.0098/0.006875;
data_OverTh = (peakAmpVar>TH); %matriz 32x10000
Ndisp = sum(data_OverTh');
Ndisp = Ndisp(Ndisp>0)
%figure;

histogram(Ndisp, -0.5:33,'Normalization','probability');
set(gca, 'YScale', 'log');
xlim([-0.5 32.5]);
xlabel('Number of fired PMTs') % x-axis label
ylabel('Events') % y-axis label
ylim([10e-5 1])