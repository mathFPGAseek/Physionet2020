%fdaMPath = 'c:/design/misc/PhD_EE/misc/fda/fdaM';
fdaMPath = 'c:/design/PhD/misc/functional_data/fda/fdaM';
addpath(fdaMPath)

Fs                     = 500;
time_units = 1/Fs;
length = 7500; 

time_term = 2; % time in seconds
samples = time_term/time_units;

time = zeros(1,samples);

data = val';
leads = size(data,2);
debug = 0;
for m = 1 : samples
    data_sub(m,:) = data(m,:);
end
debug = 0;

% Pre-process
for t = 1 : samples
    time(t) = time(t) + t*time_units;
end
time = time';

debug = 0;

basis_num = samples;
basis_ord = 4;
basis_diff_oper = 2;
basis_penalty = 1e-6;


lambda = 1e-4;
nharm = 3;


debug = 0;


% smooth data
patientBasis = create_bspline_basis([0 time_term],basis_num,basis_ord);
debug = 0;
patientfdPar = fdPar(patientBasis,basis_diff_oper,basis_penalty);
debug = 0;
patientfd = smooth_basis(time,data_sub,patientfdPar);
debug = 0;

%subplot(1,1,1)
%plot(patientfd)
%title('First Few Heart Beats')
%debug = 0;

% Do Functional PCA
patientfdPar  = fdPar(patientBasis,basis_diff_oper,lambda);
debug = 0;
tic
patientpcastr = pca_fd(patientfd,nharm,patientfdPar);
toc
debug = 0;

%plot_pca_fd(patientpcastr)

debug = 0;
