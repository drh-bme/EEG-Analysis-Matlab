function [mean_psd_vector, AsI, BiS] = meanLesionPSD(realigned_psd_matrix_struct)
% MEANlESIONpsd Computes the mean PSD for the lesion and non-lesion groups 
% across the entire frequency band, then calculates symmetry indices.
%
% Inputs:
%   realigned_psd_matrix_struct: Structure from realignPSD, containing:
%                                 - data (PSD matrix, N_chan_total x N_freq_bins_band)
%                                 - N_lesion (number of lesion channels)
%
% Outputs:
%   mean_psd_vector: 2x1 vector [Mean_Lesion_PSD; Mean_NonLesion_PSD]
%   AsI:             The calculated Asymmetry Index.
%   BiS:             The proprietary Bistability Score.

    %% Extract data
    psd_matrix = realigned_psd_matrix_struct.data;
    N_lesion = realigned_psd_matrix_struct.N_lesion;

    %% Separate Groups
    % The first N_lesion channels are the lesion side
    psd_lesion = psd_matrix(1:N_lesion, :);
    % Remaining channels are the non-lesion side
    psd_non_lesion = psd_matrix(N_lesion+1: end, :);
    
    %% Compute Overall Mean PSD
    % This is the mean across all channels and all frequency bins in the band.
    
    % Calculate mean of all values in the lesion block
    mean_lesion_psd = mean(psd_lesion(:));
    
    % Calculate mean of all values in the non-lesion block
    mean_non_lesion_psd = mean(psd_non_lesion(:));
    
    %% Output Means
    % Resulting array is 2x1
    mean_psd_vector = [mean_lesion_psd; mean_non_lesion_psd];

    %% Compute Symmetry Indices
    % Calls the new function to calculate AsI and proprietary BiS
    [AsI, BiS] = computeSymmetryIndices(psd_lesion, psd_non_lesion);

end