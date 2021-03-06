%--------------------------------------------------------------------
% University: University of North Dakota
% Project: Physionet Challenge 2020
% Student: rbd
% initial date: 6/26/20
% file : CardiacFeatureExtraction_Class.m 
%--------------------------------------------------------------------
%fdaMPath = 'c:/design/misc/PhD_EE/misc/fda/fdaM'; 
fdaMPath = 'c:/design/PhD/misc/functional_data/fda/fdaM';
addpath(fdaMPath)



% Load a Matleab file for a patient
%%rawData                = val; % Patient
Fs                     = 500; % For Baseline wandering filtering
filter_rejection_in_hz = 1; % Filter rejecgtion in Hz
threshold              = .01;  % Wavelet De-noising
features               = 50;  % For RICA
iterationLimit         = 100; % For RICA
%g = CardiacFeatureExtraction(rawData,Fs,threshold,features,iterationLimit,filter_rejection_in_hz);

% Variables for Functional Data
time_units = 1/Fs;
time_term  = 2;     % Time in seconds
samples = time_term/time_units;


%------------
% Test Baseline Filter
%------------
%{
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
%}
%-------------------
% Process all of data
%-------------------
input_directory      = '../../Training_WFDB'
output_directory     = '../../output_class_data_exp_test6/'
output_csv_directory = '../../output_class_csv_data'
matlab_suffix = '.mat'
csv_suffix    = '.csv'   

i = 0;
    for f = dir(input_directory)'
        if exist(fullfile(input_directory, f.name), 'file') == 2 && f.name(1) ~= '.' && all(f.name(end - 2 : end) == 'mat')
            input_files{i + 1} = f.name;
            i = i + 1;
        end
    end
    
 debug = 0;
 
 disp(' Process all files')
 %num_files = length(input_files);
 num_files = size(input_files,2);
 for i = 1:num_files
    disp(['    ', num2str(i), '/', num2str(num_files), '...'])
    % Load data.
    file_tmp=strsplit(input_files{i},'.');
    tmp_input_file = fullfile(input_directory, file_tmp{1});
    f= load([tmp_input_file '.mat']);
    try 
        rawData                = f.val; % Patient
    catch ex
        rethrow(ex)
    end
    
        % Load a Matlab file for a patient and filter, de-noise and do ICA
        h = CardiacFeatureExtraction(rawData,Fs,threshold,features,iterationLimit,filter_rejection_in_hz);
        h.start;
        extracted_features = h.sparse_transform
        file_out_tmp=strsplit(input_files{i},'.');
        % Load a Matlab file and do Functional PCA
        
        
        % Ouput MAT file
        tmp_output_file = fullfile(output_directory, file_out_tmp{1});
        tmp_output_file_2 = strcat(tmp_output_file,matlab_suffix);
        save(tmp_output_file_2,'extracted_features')
        % Output CSV file
        tmp_output_csv_file_2 = strcat(tmp_output_file,csv_suffix);
        csvwrite(tmp_output_csv_file_2,extracted_features)
        
 end
 
 debug = 0;