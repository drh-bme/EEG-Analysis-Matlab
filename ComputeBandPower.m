function [ch_values, ch_labels] = ComputeBandPower(Id, condition, montageType, bandLimits)
% COMPUTEBANDPOWER Calculates the mean PSD within a specified frequency 
% band for every channel (required for topography plotting).

    %% Load Data
    % Calls loadData to get the subject structure
    A = loadData(Id, condition, montageType);

    % Squeeze the PSD to Channels x Frequencies
    psd_2d = squeeze(A.powspctrm); 

    % Ensure we work with the standard (Channels x Frequencies) dimensions
    if size(psd_2d, 1) > size(psd_2d, 2) && size(psd_2d, 2) == length(A.freq)
        psd_2d = psd_2d'; 
    end

    %% Find Frequency Indices
    min_freq = bandLimits(1);
    max_freq = bandLimits(2);

    % Find indices corresponding to the frequency band
    freq_indices = find(A.freq >= min_freq & A.freq <= max_freq);

    if isempty(freq_indices)
        error('No frequencies found in the specified band [%g, %g] Hz.', min_freq, max_freq);
    end

    %% Calculate Mean Power per Channel
    % Average the PSD across the selected frequency bins
    ch_values = mean(psd_2d(:, freq_indices), 2);

    %% Extract and Remap Channel Labels
    ch_labels = A.label;

    % REMAPPING FOR TOPOGRAPHY: T5/T6 -> P7/P8 (Modern 10-20 standard)
    ch_labels = strrep(ch_labels, 'T5', 'P7');
    ch_labels = strrep(ch_labels, 'T6', 'P8');
    % Ensure labels match the case required by plot_topography
    ch_labels = upper(ch_labels);
end