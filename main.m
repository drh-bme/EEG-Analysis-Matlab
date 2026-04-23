%% Declaration of constants
% Numeric array of subject IDs to be processed. IDs must be integers.
subj = [];
% Expected number of frequency bins (dimension of the PSD vector). 
% For this project:
f = 257; 
% Define the standard frequency bands
% Format: {Band Name, Start Frequency, End Frequency}
bands = { ...
    {'Delta',    0.5,    4}; ...
    {'Theta',    4,    7.75}; ...
    {'Alpha',    11,    12.75}; ...
    {'Beta', 13, 39.75}
};

%% Plotting all Pre-surgycal Average PSD
% Calls the function to plot the mean PSD for Pre and Post conditions 
% across all subjects in two grouped subplots.
plotAllPrePost(subj,f);
% Calls the function to plot the Pre- vs Post-surgery comparison for 
% each individual subject, including individual channel data and confidence intervals.
plotAllSub(subj,f)

%% Plotting confidence interval
% Calls the function to plot the 95% confidence interval for each individual
% subject in one figure using the bootstrap method.
plotConfidenceInterval(subj,10000)

%% Wilcoxon test
% Performs Wilcoxon Rank-Sum tests per subject (comparing channel distributions)
wilc4All(subj, bands);
% Computes power shifts across the group on both hemispheres
wilcoxon4Lesions(subj,bands);
% Performs group-level statistics for the Asymmetry Index and 
% the proprietary Bistability Score (BiS) with FDR correction.
wilcoxonSymmetry(subj, bands);