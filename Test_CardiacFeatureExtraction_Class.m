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

% Variables for Filtering/De-noising/ICA
Fs                     = 500; % For Baseline wandering filtering
filter_rejection_in_hz = 1; % Filter rejecgtion in Hz
threshold              = .01;  % Wavelet De-noising
features               = 50;  % For RICA
iterationLimit         = 100; % For RICA

% Variables for Functional Data
time_term  = 2;                     % Time in seconds
basis_ord = 4;
basis_diff_oper = 2;
basis_penalty = 1e-6;
lambda = 1e-4;
nharm = 3;

%-------------------
% Process all of data
%-------------------
input_directory           = '../../Training_WFDB'
output_ica_directory      = '../../output_class_ica_data_1/'
%output_csv_directory     = '../../output_class_csv_data'
output_fpca_directory     = '../../output_class_fpca_data_1/'
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
        h = CardiacFeatureExtraction(rawData,Fs,threshold,features,iterationLimit,filter_rejection_in_hz,...
                                     basis_ord,basis_diff_oper,basis_penalty,lambda,nharm,...
                                     time_term);
        h.start;
        extracted_features = h.sparse_transform
        file_out_tmp=strsplit(input_files{i},'.');
        
        % Retreive Functional PCA
        fpca_features = h.patientpcastr.harmscr
        
        % Prepare ICA Outputs
        tmp_ica_output_file = fullfile(output_ica_directory, file_out_tmp{1});
        % Ouput MAT file ICA
        tmp_output_file_2 = strcat(tmp_ica_output_file,matlab_suffix);
        save(tmp_output_file_2,'extracted_features')
        % Output CSV file ICA
        tmp_output_csv_file_2 = strcat(tmp_ica_output_file,csv_suffix);
        csvwrite(tmp_output_csv_file_2,extracted_features)

        % Prepare ICA Outputs
        tmp_fpca_output_file = fullfile(output_fpca_directory, file_out_tmp{1});
        % Ouput MAT file FPCA
        tmp_output_file_3 = strcat(tmp_fpca_output_file,matlab_suffix);
        save(tmp_output_file_3,'fpca_features')
        % Output CSV file FPCA
        tmp_output_csv_file_3 = strcat(tmp_fpca_output_file,csv_suffix);
        csvwrite(tmp_output_csv_file_3,fpca_features)
        
 end
 
 debug = 0;