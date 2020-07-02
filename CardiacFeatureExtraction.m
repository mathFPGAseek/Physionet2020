%--------------------------------------------------------------------
% University: University of North Dakota
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
               
    end
    
    methods
        
        function obj = CardiacFeatureExtraction(rawData,sampFreq,threshold)
            
            obj.rawData   = rawData;
            obj.sampFreq  = sampFreq; 
            
            
            obj.lengthFFT = 0;
            obj.leads     = 0;
            obj.P1        = [];
            obj.P2        = [];
            obj.f         = [];
            
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
            
            if nargin == 3
                
            end
            
        end
        
        function obj = start(obj)
            
            obj.BaselineFiltering();
            obj.WaveletDenoising();
            
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
           
           % ??? Add some filtering
           
        end
        
        function obj = WaveletDenoising(obj)
            
            obj.P1_size = size(obj.P1,2);
            for j = 1: obj.leads
                [obj.ca,obj.cd] = dwt(obj.P1(j,:),'db1','mode','sym');
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
            
        end
        
        function obj = IndependentComponentAnalysis(obj)
            
        end
        
    end % methods
    
end % class