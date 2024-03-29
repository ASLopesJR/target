function[x,g]  = energyboxplot(peakAmpVar,TH)
    data_OverTh = (peakAmpVar>=TH);
    energia_ADCcnt = sum(peakAmpVar);
    ADC_TO_PE = 0.0098/0.006875;
    energia_pe = energia_ADCcnt*ADC_TO_PE;
    NPMTs = sum(data_OverTh); %número de coincidências por evento
    %*****************
% histogramas
%*****************


k=0;
UNIT = 1; %0 = ADC count // 1 = p.e.
INIT = 1;
END = 32;
%figure;
for iNPMTs = INIT:END %número de PMTs de interesse
   k = k+1;
   xVar(k) = iNPMTs;
   idx = (NPMTs==iNPMTs);
   subplot(ceil((END-INIT+1)/3),3,k);      
   if UNIT==0
      histogram(energia_ADCcnt(idx)); 

      if k==1
         x = [energia_ADCcnt(idx)'];         
         g = [iNPMTs*ones(length(energia_ADCcnt(idx)), 1)];
      else
         x = [x; energia_ADCcnt(idx)'];         
         g = [g; iNPMTs*ones(length(energia_ADCcnt(idx)), 1)];
      end
     
      %meanVar(k) = mean2(energia_ADCcnt(idx));
      %stdVar(k) = std2(energia_ADCcnt(idx));
      %minVar(k) = min(energia_ADCcnt(idx));
      %maxVar(k) = max(energia_ADCcnt(idx));
      xlabel('Event energy (peak amplitude in ADC counts)') % x-axis label

   else
      histogram(energia_pe(idx));

      if k==1
         x = [energia_pe(idx)'];         
         g = [iNPMTs*ones(length(energia_pe(idx)), 1)];
      else
         x = [x; energia_pe(idx)'];         
         g = [g; iNPMTs*ones(length(energia_pe(idx)), 1)];
      end

      %meanVar(k) = mean2(energia_pe(idx));
      %stdVar(k) = std2(energia_pe(idx));
      %minVar(k) = min(energia_pe(idx));
      %maxVar(k) = max(energia_pe(idx));
      xlabel('Event energy (p.e.)') % x-axis label
   end

   ylabel('Events') % y-axis label
   set(gca, 'YScale', 'log');
   set(gca, 'XScale', 'log');
   xlim([1 1000]);
   %xlim([100 10000]);
   grid on;
   legend(num2str(iNPMTs));
end

%figure;
%boxplot(x, g, 'whisker', 500);
%xlabel('Number of PMTs in coincidence');

%if UNIT==0
%   ylabel('Event energy (peak amplitude in ADC counts)'); % x-axis label
%else
    
    
%   ylabel('Event energy (p.e.)'); % x-axis label
%end
%set(gca, 'YScale', 'log');



