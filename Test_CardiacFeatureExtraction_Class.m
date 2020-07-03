%--------------------------------------------------------------------
% University: University of North Dakota
% Project: Physionet Challenge 2020
% Student: rbd
% initial date: 6/26/20
% file : CardiacFeatureExtraction.m 
%--------------------------------------------------------------------




% Load a Matleab file for a patient
rawData        = val; % Patient
Fs             = 500; % For Baseline wandering filtering
threshold      = .5;  % Wavelet De-noising
features       = 50;  % For RICA
iterationLimit = 100; % For RICA
g = CardiacFeatureExtraction(rawData,Fs,threshold,features,iterationLimit);


%------------
% Test Baseline Filter
%------------
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

% returned features
extracted_features = g.sparse_transform
debug = 0;