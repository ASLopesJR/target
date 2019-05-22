function energyHist(peakAmpVar,type)


TH = 3; %threshold de dispado
ADC_TO_PE = 0.0098/0.006875;
peakAmpVar(peakAmpVar<TH) = 0; %zerando as amplitudes abaixo de TH
energia_ADCcnt = sum(peakAmpVar);
if(strcmp(type,'ADC'))
   BIN = 600;
   YLIM = [0 140];
else
   energia_ADCcnt = energia_ADCcnt*ADC_TO_PE; 
   BIN = 300;
   YLIM = [0 240];
end    


h = histogram (energia_ADCcnt, BIN);
h.FaceColor = 'black';
h.FaceAlpha = rand;

XLIM = [0 max(energia_ADCcnt,[],'all')];
ylim(YLIM);
xlim(XLIM);
xlabel('Event energy peak') % x-axis label
ylabel('Events') % y-axis label

end