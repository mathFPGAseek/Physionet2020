%--------------------------------------------------------------------
% University: University of North Dakota
% Project: Physionet Challenge 2020
% Student: rbd
% initial date: 6/26/20
% file : CardiacFeatureExtraction.m 
% Description: To extract feature from Physionet data Challenge 2020
% that will allow us to classify different cardiac arrhythmias.
% This class will perform the functions of wavelet de-noising; baseline 
% wander filtering and then perform Independent Component Analysis 
% to genereate features to then be used for classification.
%--------------------------------------------------------------------
classdef CardiacFeatureExtraction < handle
    properties
        rawData = []
        sampFreq
        lengthFFT
        leads
        P1 =  []
        P2 =  []
        X  =  []
        f  =  []
        frquency_bin_width
        filter_rejection_in_hz
        rejection_num_bins
        P1_rejection_num_bins
        P1_time_Real_value = []
        
        threshold 
        ca = []
        cd = []
        abs_ca = []
        abs_cd = []
        P1_size
        cd_thrsh = []
        denoised_wavelet = []
        num_of_coeffs    = []
        abs_cd_size
        min_num_of_coeffs
        max_num_of_coeffs
        denoised_wavelets_min = []
        
        features
        iterationLimit
        rica_extract = []
        sparse_transform = []
        P1_time = []
                
    end
    
    methods
        
        function obj = CardiacFeatureExtraction(rawData,sampFreq,threshold,features,iterationLimit,filter_rejection_in_hz)
            
            obj.rawData   = rawData;
            obj.sampFreq  = sampFreq; 
            
            
            obj.lengthFFT = 0;
            obj.leads     = 0;
            obj.P1        = [];
            obj.P2        = [];
            obj.f         = [];
            obj.P1_time   = [];
            obj.frquency_bin_width = 0;
            obj.filter_rejection_in_hz = filter_rejection_in_hz;
            obj.rejection_num_bins = 0;
            obj.P1_rejection_num_bins = 0;
            obj.P1_time_Real_value = [];
            
            % wavelet properties
            obj.threshold = threshold;
            obj.ca        = [];
            obj.cd        = [];
            obj.abs_ca    = [];
            obj.abs_cd    = [];
            obj.P1_size   = 0;
            obj.cd_thrsh  = [];
            obj.denoised_wavelet = [];
            obj.num_of_coeffs    = [];
            obj.abs_cd_size = 0;
            obj.min_num_of_coeffs = 0;
            obj.max_num_of_coeffs = 0;
            obj.denoised_wavelets_min = [];
            
            % Rica properties
            
            obj.features = features;
            obj.iterationLimit = iterationLimit;
            obj.rica_extract = [];
            obj.sparse_transform     = [];
            
            if nargin == 3
                
            end
            
        end
        
        function obj = start(obj)
            
            obj.BaselineFiltering();
            obj.WaveletDenoising();
            obj.IndependentComponentAnalysis();
            
        end
        
        
        function obj = BaselineFiltering(obj)
           obj.leads       = size(obj.rawData,1);
           obj.lengthFFT   = size(obj.rawData,2);
           obj.f           = obj.sampFreq*(0:(obj.lengthFFT/2))/obj.lengthFFT;  
           
           for i = 1: obj.leads  
            obj.X(i,:)          = fft(obj.rawData(i,:));
            obj.P2(i,:)         = abs(obj.X(i,:)/obj.lengthFFT);
            obj.P1(i,:)         = obj.P2(i,1:obj.lengthFFT/2 + 1);           
           end
           
           %Estimate of filter bins
           obj.lengthFFT/2; % pi- Nyquist sampling in bins
           obj.sampFreq/2;  % Nyquist in frequency
           obj.frquency_bin_width = (obj.sampFreq/2)/(obj.lengthFFT/2);
           obj.rejection_num_bins = (obj.filter_rejection_in_hz)/(obj.frquency_bin_width);
           obj.P1_rejection_num_bins = obj.rejection_num_bins * obj.leads;
           
           obj.P1(1:obj.P1_rejection_num_bins) = 0;
           obj.P1_time = ifft(obj.P1); %% Not sure why 1st components are zeo??
           obj.P1_time_Real_value = abs(obj.P1_time); 
           
        end
        
        function obj = WaveletDenoising(obj)
            
            obj.P1_size = size(obj.P1,2);
            for j = 1: obj.leads
                %[obj.ca,obj.cd] = dwt(obj.P1(j,:),'db1','mode','sym');
                [obj.ca,obj.cd] = dwt(obj.P1_time_Real_value(j,:),'db1','mode','sym');
                obj.abs_cd      = abs(obj.cd);
                obj.abs_cd_size = size(obj.abs_cd,2);
                obj.cd_thrsh    = zeros(1,obj.abs_cd_size);
                for k = 1:obj.abs_cd_size 
                    if( obj.abs_cd(k) <= obj.threshold)
                        obj.cd_thrsh(k) = 0;
                    else
                        obj.cd_thrsh(k) = obj.abs_cd(k);
                    end
                end
                obj.denoised_wavelet(j,:) = obj.cd_thrsh;
                obj.num_of_coeffs(j) = nnz(obj.cd_thrsh);      
                
            end           
            obj.min_num_of_coeffs = min(obj.num_of_coeffs);
            obj.max_num_of_coeffs = max(obj.num_of_coeffs);
      
            obj.denoised_wavelets_min = maxk(obj.denoised_wavelet,obj.min_num_of_coeffs,2); 
     
        end
        
        function obj = IndependentComponentAnalysis(obj)
            
            obj.rica_extract = rica(obj.denoised_wavelets_min,obj.features, 'IterationLimit',obj.iterationLimit);
            obj.sparse_transform    = transform(obj.rica_extract,obj.denoised_wavelets_min(1:5,:));
            
            
        end
        
    end % methods
    
end % class