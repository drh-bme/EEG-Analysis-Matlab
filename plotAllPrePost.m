function [] = plotAllPrePost(subj, f) 
% plotAllPrePost Generates a "tailed" layout:
% Left: Group average with CI | Right Top: Subject 03 | Right Bottom: Subject 08

%% --- DATA AGGREGATION ---
preAv = zeros(length(subj), f);
postAv = zeros(length(subj), f);

for i = 1:length(subj)
    [freqPreTemp, preAv(i,:)] = ComputeMeanPSD(subj(i),'Pre');
    [~, postAv(i,:)] = ComputeMeanPSD(subj(i),'Post');
end
fPre = freqPreTemp;

%% --- GROUP BOOTSTRAP CALCULATION ---
nboot = 5000;
mean_statistic = @(x) mean(x, 1);
[BDPre] = bootstrp(nboot, mean_statistic, preAv);
[BDPost] = bootstrp(nboot, mean_statistic, postAv);

ciPreLow  = prctile(BDPre, 2.5, 1);
ciPreHigh = prctile(BDPre, 97.5, 1);
ciPostLow  = prctile(BDPost, 2.5, 1);
ciPostHigh = prctile(BDPost, 97.5, 1);

% Stability correction for log scale
floorVal = 1e-15;
ciPreLow(ciPreLow <= 0) = floorVal;
ciPostLow(ciPostLow <= 0) = floorVal;

%% --- PLOTTING ---
figure('Color', 'w', 'Name', 'Global vs Individual PSD Comparison');

% --- LEFT PANEL: Group Mean PSD (Large) ---
subplot(2, 2, [1, 3]);
hold on;
% Use the utility for shaded regions
fill([fPre, fliplr(fPre)], [ciPreLow, fliplr(ciPreHigh)], 'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');
fill([fPre, fliplr(fPre)], [ciPostLow, fliplr(ciPostHigh)], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');

% Mean lines
loglog(fPre, mean(preAv, 1), 'LineWidth', 3, 'Color', 'b', 'DisplayName', 'Group Pre-Surgery');
loglog(fPre, mean(postAv, 1), 'LineWidth', 3, 'Color', 'r', 'DisplayName', 'Group Post-Surgery');

set(gca, 'XScale', 'log', 'YScale', 'log');
xlim([1 40]); ylim([1e-14 1e-9]); grid on;
xlabel('Frequency (Hz)'); ylabel('PSD');
title('Global Group Trend (N=8)');
legend('Location', 'northeast');

% --- RIGHT TOP PANEL: Subject 03 ---
subplot(2, 2, 2);
plotConfidenceInterval(3, nboot);
title('Subject 03 (Positive Outcome)');

% --- RIGHT BOTTOM PANEL: Subject 08 ---
subplot(2, 2, 4);
plotConfidenceInterval(8, nboot);
title('Subject 08 (Negative Outcome)');
end