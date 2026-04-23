function [] = wilcoxon4Lesions(subj, bands)
% wilcoxon4Lesions Group-level analysis comparing Power on Lesion vs Non-Lesion sides.

    %% Setup
    % Load distributions (Matrix size: 4 x N_bands x N_subjects)
    lesion_dist_Pre  = lesionDistribution(subj, 'Pre', bands);
    lesion_dist_Post = lesionDistribution(subj, 'Post', bands);
    
    pVal = zeros(2, length(bands));
    alpha = 0.05;
    
    %% 1. Build raw p-value array for Power
    for i = 1:length(bands)
        % Test the lesion side power (Row 1 of the distribution matrix)
        testBandPreL = squeeze(lesion_dist_Pre(1, i, :)); 
        testBandPostL = squeeze(lesion_dist_Post(1, i, :)); 
        pVal(1,i) = ranksum(testBandPreL, testBandPostL, 'tail', 'right'); 
    
        % Test the non-lesion side power (Row 2)
        testBandPreNL = squeeze(lesion_dist_Pre(2, i, :)); 
        testBandPostNL = squeeze(lesion_dist_Post(2, i, :)); 
        pVal(2,i) = ranksum(testBandPreNL, testBandPostNL, 'tail', 'right'); 
    end 

    %% 2. Apply FDR Correction (Toolbox Function)
    % Correcting for multiple comparisons across all bands using BHFDR
    raw_p_vector = pVal(:);
    adj_p_vector = mafdr(raw_p_vector, 'BHFDR', true); 
    pVal_adj = reshape(adj_p_vector, size(pVal));
    
    %% 3. Display Results
    disp('Wilcoxon Results for Power (Pre > Post) with FDR correction:')
    for i = 1:2
        sideLabel = "Lesion Side"; if i==2, sideLabel = "Non-Lesion Side"; end
        fprintf('\n--- %s ---\n', sideLabel);
        for j = 1:size(bands, 1)
            bandName = bands{j}{1};
            if pVal_adj(i,j) < alpha, sign = 'SIGNIFICANT'; else, sign = 'NOT SIGNIFICANT'; end
            fprintf('Band %-11s: Adj-P = %.4f [%s]\n', bandName, pVal_adj(i,j), sign);
        end 
    end 
end