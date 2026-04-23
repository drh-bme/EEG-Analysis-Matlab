function [] = plotConfidenceInterval(subjID, nboot)
% plotConfidenceInterval Plots mean PSD and 95% CI into the CURRENT axes.

% --- Data Processing ---
[fPre, meanPSDPre] = ComputeMeanPSD(subjID, 'Pre');
[fPost, meanPSDPost] = ComputeMeanPSD(subjID, 'Post');

% Corrected typo to call bootstrapDist.m correctly
BDPre = bootstrapDist(subjID, 'Pre', nboot); 
BDPost = bootstrapDist(subjID, 'Post', nboot);

% --- Calculate 95% CI ---
ciPreLow  = prctile(BDPre, 2.5, 1);
ciPreHigh = prctile(BDPre, 97.5, 1);
ciPostLow  = prctile(BDPost, 2.5, 1);
ciPostHigh = prctile(BDPost, 97.5, 1);

% Stability correction for Log-Log plots
floorVal = 1e-15; 
ciPreLow(ciPreLow <= 0) = floorVal; 
ciPostLow(ciPostLow <= 0) = floorVal;

hold on;

% --- Plot Shaded Regions using fill_between.m logic ---
fill([fPre, fliplr(fPre)], [ciPreLow, fliplr(ciPreHigh)], 'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');
fill([fPost, fliplr(fPost)], [ciPostLow, fliplr(ciPostHigh)], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');

% --- Plot Mean Lines (Thick Lines) ---
loglog(fPre, meanPSDPre, 'LineWidth', 2.5, 'Color', 'b', 'DisplayName', 'Pre-Surgery');
loglog(fPost, meanPSDPost, 'LineWidth', 2.5, 'Color', 'r', 'DisplayName', 'Post-Surgery');

% Aesthetic settings
set(gca, 'XScale', 'log', 'YScale', 'log');
xlim([1 40]); ylim([1e-14 1e-9]); grid on;
xlabel('Frequency (Hz)'); ylabel('PSD');
legend('Location', 'northeast', 'FontSize', 7);
end