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
            
            if nargin == 3
                
            end
            
        end
        
        function obj = start(obj)
            
            obj.BaselineFiltering();
            
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
            
            
            %for j = 1: obj.leads
            %    [obj.ca,obj.cd] = dwt(obj.P1(j,:),'dbl','mode','sym');
            %    obj.abs_cd = abs(obj.cd);
            %    for k = 1: 
            
        end
        
        function obj = IndependentComponentAnalysis(obj)
            
        end
        
    end % methods
    
end % class