function[freq, meanPSD] = ComputeMeanPSD(Id, condition)
% COMPUTEMEANPSD Calculates the mean PSD across all channels for a subject/condition.
%
% Inputs:
%   Id:        Numeric subject ID (e.g., 3).
%   condition: String, can be 'Pre' or 'Post'.
%
% Output:
%   freq:      Vector of frequencies (X-axis data).
%   meanPSD:   Vector, the average PSD across every channel at each frequency. 
%              This is expected to be a 1 x N_freq vector (1x257 in this case).

    % Load the full data structure containing all fields.
    A=loadData(Id, condition);
    % Calculate the mean across the first dimension (channels), remove singleton
    % dimensions, and transpose to ensure a row vector (1 x N_freq).
    [meanPSD] = squeeze(mean(A.powspctrm,1))';
    if iscolumn(meanPSD)
            meanPSD = meanPSD';
    end % of if
    % Extract the frequency vector.
    [freq] = A.freq;
end %of function