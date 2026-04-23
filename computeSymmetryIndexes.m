function [AsI, BiS_val] = computeSymmetryIndices(psd_lesion, psd_non_lesion)
% Calculates AsI and calls proprietary BiS.
% Inputs: Matrices (Channels x Frequencies) for each side.

    % Calculate Mean Power for each side
    mean_L = mean(psd_lesion(:));
    mean_NL = mean(psd_non_lesion(:));

    % Calculate Asymmetry Index (AsI)
    AsI = (mean_L - mean_NL) / (mean_L + mean_NL);

    % Call Proprietary Bistability Score function
    % I have used a proprietary function is named 'BiS_calc', hence it will 
    % not be added to the repository.
    try
        BiS_val = BiS_calc(psd_lesion, psd_non_lesion);
    catch
        warning('Proprietary BiS function not found. Returning NaN.');
        BiS_val = NaN;
    end
end