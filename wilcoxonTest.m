function [] = wilcoxonTest(Id, sl, bands)
% wilcoxonTest Compares channel power distribution Pre vs Post for a single subject.

    alpha = sl / 100; %
    pre = loadData(Id, 'Pre'); %
    post = loadData(Id, 'Post'); %
    
    IdStr = string(sprintf('%02d', Id));
    fprintf('\n--- Individual Stats: Subject %s (alpha = %.2f) ---\n', IdStr, alpha);

    for i = 1:size(bands, 1)
        currBand = bands{i};
        bandName = currBand{1,1};
        bandMask = pre.freq >= currBand{2} & pre.freq <= currBand{3}; %
        
        % Average across frequencies to get one value per channel
        preSample = mean(squeeze(pre.powspctrm(:, bandMask)), 2);
        postSample = mean(squeeze(post.powspctrm(:, bandMask)), 2);
        
        pValue = ranksum(preSample, postSample); %
        
        if pValue < alpha, msg = 'Significant'; else, msg = 'Not Significant'; end
        fprintf('Band %-11s: P = %.3f. %s\n', bandName, pValue, msg);
    end 
end