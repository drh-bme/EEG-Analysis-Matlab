function [dist_matrix] = lesionDistribution(subj, condition, bands)
% LESIONdISTRIBUTION Computes the mean PSD for lesion vs. non-lesion groups
% across multiple frequency bands and multiple subjects.
%
% Inputs:
%   subj:        Array of numeric subject IDs (e.g., [3, 8, 12]).
%   condition:   String specifying condition ('Pre' or 'Post').
%   bands:       Cell array defining the bands. Format: {{Name, StartFreq, EndFreq}, ...}
%
% Output:
%   dist_matrix: Array of size 2 x N_bands x N_subjects
%                Dimension 1: [Lesion Mean PSD; Non-Lesion Mean PSD]
%                Dimension 2: Frequency Bands
%                Dimension 3: Subjects

    %% Setup
    N_bands = size(bands, 1);
    N_subjects = length(subj);
    
    % Pre-allocate the final output matrix
    % Dimensions: 2 (Lesion/Non-Lesion) x N_bands x N_subjects
    dist_matrix = zeros(2, N_bands, N_subjects);

    
    %% Loop through Subjects and Bands
    
    for i = 1:N_subjects
        id = subj(i);
        
        % Find the lesion side for each subject. Must be set for each case.
        switch id
            case 2
                lesion_side = 'Lx';
            case 3
                lesion_side = 'Rx';
            case 8
                lesion_side = 'Rx';
            case 12
                lesion_side = 'Rx';
            case 13
                lesion_side = 'Lx';
            case 14 
                lesion_side = 'Lx';
            case 15
                lesion_side = 'Rx';
        end
        
        % Load data once per subject
        try
            % Assuming loadData exists and returns the structure
            data_struct = loadData(id, condition); 
        catch
            warning('Could not load data for subject %d and condition %s. Skipping.', id, condition);
            continue;
        end
        
        fprintf('Processing Subject %d for condition %s...\n', id, condition);

        for j = 1:N_bands
            % Extract band parameters from the input cell array
            currBand = bands{j};
            bandName = currBand{1,1};
            startFreq = currBand{1, 2};
            endFreq = currBand{1, 3};
            
            % Realign Data 
            % Lesion side will be first 5 channels, non-lesion side last 5
            realigned_struct = realignPSD(data_struct, startFreq, endFreq, lesion_side);
            
            % Compute mean
            % This returns the 2x1 vector of [Lesion Mean; Non-Lesion Mean] for this band.
            mean_psd_vector = meanLesionPSD(realigned_struct);
            
            % Store Result
            dist_matrix(:, j, i) = mean_psd_vector;
        end
    end
    
    fprintf('Analysis complete. Output matrix size: %dx%dx%d\n', 2, N_bands, N_subjects);
    
end