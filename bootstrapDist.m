function [BD] = bootstrapDist(Id, condition, nboot)
% bootstrapDist Calculates the bootstrap distribution of the mean PSD.
%
% Inputs:
%   Id:         Numeric subject ID (e.g., 3, 8, 12).
%   condition:  String ('Pre' or 'Post').
%   nboot:      Number of bootstrap repetitions (e.g., 5000).
%
% Output:
%   BD:         Matrix (nboot x N_freq) of the bootstrap distribution.

    % Load the raw data struct
    A = loadData(Id, condition);

    % Average over the Time dimension (dim 2) to get Channels x Frequencies
    % Note: bootstrp resamples rows, so we ensure channels are in rows.
    rawPSD2d = squeeze(mean(A.powspctrm, 2)); 

    % Define statistic: mean across channels (dimension 1)
    mean_statistic = @(x) mean(x, 1);

    % Run the bootstrap resampling
    [BD, ~] = bootstrp(nboot, mean_statistic, rawPSD2d);
end