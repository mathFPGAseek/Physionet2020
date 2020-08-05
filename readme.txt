%--------------------------------------------------------------------
% University: University of North Dakota
% Project: Physionet Challenge 2020
% Student: rbd
% initial date: 7/3/20
% file : readme.txt
%--------------------------------------------------------------------

%--------------------------------------------------------------------
% Notes for ICA Feature Extraction
%--------------------------------------------------------------------

Requirements:
1. Matlab 2020a
2. DSP System toolbox
3. Statistics and Machine Learning Toolbox
4. Wavelet Toolbox

Instructions:
0. Create three folders
	a. ../../Training_WFDB           -> This is from Physionet Website
	b. ../../output_ica_class_data  - > This is empty
	c. ../../output_fpca_class_data  -> This is empty
1. Run file: Test_CardiacfeatureExtraction_Class.m
2. Observe variable: extracted_features(ICA)
3. Observe variable: extracted_features(FPCA)


Notes:
This Class performs for ICA:
 A baseline wandering filter on data
 A wavelet de-noising of data
 A independent component analysis of data

Theory of Opeartion.
The baseline wandering performs a FFT and then centers data at zero.
It only looks at right hand side of spectrum and then filters
up to an estimate of 1 hz based on the input parameters.
( There seems to be a bug as to why the IFFT returns zeros)

After filtering the data, we do a overall de-noising of the data
with a 1-D wavelet de-noising with a given threshold.

Finally we compute a RICA on the data that.
Example, if the original data was say 12x7500 array input data,
after the wavelet de-noising we get a 12x75 array( Note the column 
value is variable depending on the size of the wavelet coefficients and
the threshold value). Now the RICA will use the features and iterationlimit
to compute a model, for our example above this is the 75x50 array, with a 
feature value of 50.For the given data I was not able to converge on a 
solution, but Matlab gives you the option of extracting N sparse values.
So, finally we get a 5x50 array that gives us 5 of the leads with our
50 features.

%--------------------------------------------------------------------
% Notes for FPCA Feature Extraction
%--------------------------------------------------------------------
Requirements:
1. Matlab 2020a
2. DSP System toolbox
3. Statistics and Machine Learning Toolbox
4. Wavelet Toolbox
5. Install FDA lib from Ramsey and install path( Availiable through an FTP site
/misc/fda/downloads/FDAfuns/Matlab/)

Instructions:
0. Create three folders
	a. ../../Training_WFDB            -> This is from Physionet Website
	b. ../../output_class_ica_data1   -> This is empty
	b. ../../output_class_fpca_data1  -> This is empty

1. Run file: Test_CardiacfeatureExtraction_Class.m
2. Observe variable: extracted_features
3. Observe variable: extracted_features(FPCA)


Notes:
This Class performs for FPCA
 A FPCA analysis

Theory of Opeartion.
The order of the polynomial,number of basis , smoothing penalties are set
for functional data analysis. The class will represent the data after eigenvalue analysis
as a fucntion that has been dimernsionally reduced.