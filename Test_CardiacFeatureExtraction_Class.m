
%------------
% Test Baseline Filter
%------------

% Load a Matleab file for a patient
rawData = val;
Fs = 500;g = CardiacFeatureExtraction(rawData,Fs);

g.start;
figure(1)
plot(g.f,g.P1(1,:)) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

figure(2)
plot(g.f,g.P1(2,:)) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

debug = 0;