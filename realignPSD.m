function [realigned_psd_struct] = realignPSD(data_struct, start_freq, end_freq, lesion_side)
% REALIGNPSD Reorders PSD data within a band into lesion-side and non-lesion-side channels.

    %% Channel Categorization 
    % Based on data format: left channels (1-5), right channels (8-12). This might change depending on montage.
    idx_left = 1:5;
    idx_right = 8:12;
    
    %% Determine Lesion/Non-Lesion Indices
    if strcmpi(lesion_side, 'Lx')
        idx_lesion = idx_left;
        idx_non_lesion = idx_right;
    elseif strcmpi(lesion_side, 'Rx')
        idx_lesion = idx_right;
        idx_non_lesion = idx_left;
    else
        error('Lesion side must be specified as ''Lx'' or ''Rx''.');
    end
    
    %% Frequency Band Masking
    rawPSD_2d = squeeze(data_struct.powspctrm); 
    
    bandMask = (data_struct.freq >= start_freq) & (data_struct.freq <= end_freq);
    psd_band = rawPSD_2d(:, bandMask); 

    % Stack lesion channels on top, followed by non-lesion channels
    A = psd_band(idx_lesion,:);
    B = psd_band(idx_non_lesion, :);
    
    realigned_psd_struct.data = [A ; B];
    realigned_psd_struct.N_lesion = length(idx_lesion);
end