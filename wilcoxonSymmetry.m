function [] = wilcoxonSymmetry(subj, bands)
% wilcoxonSymmetry Performs ranksum test + FDR for AsI and BiS across subjects.

    %% Setup
    % Load distributions (AsI is row 3, BiS is row 4)
    dist_Pre  = lesionDistribution(subj, 'Pre', bands);
    dist_Post = lesionDistribution(subj, 'Post', bands);
    
    pVal = zeros(2, length(bands)); % Row 1 for AsI, Row 2 for BiS
    alpha = 0.05;
    
    %% 1. Build raw p-value array
    for i = 1:length(bands)
        % Test Asymmetry Index (AsI) Pre vs Post
        asi_Pre  = squeeze(dist_Pre(3, i, :)); 
        asi_Post = squeeze(dist_Post(3, i, :)); 
        pVal(1,i) = ranksum(asi_Pre, asi_Post); 
    
        % Test Bistability Score (BiS) Pre vs Post
        bis_Pre  = squeeze(dist_Pre(4, i, :)); 
        bis_Post = squeeze(dist_Post(4, i, :)); 
        pVal(2,i) = ranksum(bis_Pre, bis_Post); 
    end 

    %% 2. Apply FDR Correction
    % Apply toolbox Benjamini-Hochberg FDR correction
    raw_p_vector = pVal(:);
    adj_p_vector = mafdr(raw_p_vector, 'BHFDR', true); 
    pVal_adj = reshape(adj_p_vector, size(pVal));
    
    %% 3. Display Results
    disp('Wilcoxon Results for Symmetry Indices (AsI & BiS) with FDR correction:')
    for i = 1:2
        metricLabel = "Asymmetry Index (AsI)"; if i==2, metricLabel = "Bistability Score (BiS)"; end
        fprintf('\n--- %s ---\n', metricLabel);
        for j = 1:size(bands, 1)
            bandName = bands{j}{1};
            if pVal_adj(i,j) < alpha, sign = 'SIGNIFICANT'; else, sign = 'NOT SIGNIFICANT'; end
            fprintf('Band %-11s: Adj-P = %.4f [%s]\n', bandName, pVal_adj(i,j), sign);
        end 
    end 
end