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
simulation = table2array(simulation);
hist_plot(simulation,data_max')