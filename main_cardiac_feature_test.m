%--------------------------------------------------------------------
% University: University of North Dakota
% Student: rbd
% Initial date: 6/26/20
% file : main_cardiac_feature_test.m 
% decription:  Test CardiacFeatureExtraction Class
% Notes:
%--------------------------------------------------------------------

% Some preliminary work on FFT

len = size(val,2);
Fs = 500;

lead_one = val(1,:)

figure(1)
plot(1:len,lead_one);

X = fft(lead_one)
L = len;

P2 = abs(X/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
%Define the frequency domain f and plot the single-sided amplitude spectrum P1. The amplitudes are not exactly at 0.7 and 1, as expected, because of the added noise. On average, longer signals produce better frequency approximations.

f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

debug = 0;
