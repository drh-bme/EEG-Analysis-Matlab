function [] = plotAllSub(subj, f)
% PLOTALLSUB Generates individual subject plots comparing Pre- vs Post-surgery PSD.
%
% Inputs:
%   subj: array with the subjects numerical ID.
%   f:    Dimension of the PSD vector (number of frequency bins).

%% Variables
preAv = zeros(length(subj), f); 
postAv = zeros(length(subj), f);
freqPre = preAv;
freqPost = postAv;

% Loop through all subjects to compute and store their mean PSD and frequencies.
for i = 1:length(subj)
    j = subj(i);
    [freqPre(i,:), preAv(i,:)] = ComputeMeanPSD(j,'Pre');
    [freqPost(i,:), postAv(i,:)] = ComputeMeanPSD(j,'Post');
end

%% Plotting
figure('NumberTitle','off', 'Name', 'Individual Subject Comparisons');
tiledlayout(3,2); % Set up a layout for the number of subjects

for i=1:length(subj)
    nexttile
    
    % --- Pre-Surgery Plotting ---
    loglog(freqPre(i,:), preAv(i,:), 'LineWidth', 3, 'DisplayName','Pre-surgery', 'Color', 'b')
    hold on;
    
    preCh = squeeze(loadData(subj(i), 'Pre').powspctrm);
    for j = 1:size(preCh,1)
        loglog(freqPre(i,:), preCh(j,:), 'LineWidth', 0.5, 'HandleVisibility', 'off', 'Color', 'b')
    end 
    
    % --- Post-Surgery Plotting ---
    loglog(freqPost(i,:), postAv(i,:), 'LineWidth', 3, 'DisplayName','Post-surgery', 'Color', 'r')
    
    postCh = squeeze(loadData(subj(i), 'Post').powspctrm);
    for j = 1:size(postCh,1)
        loglog(freqPost(i,:), postCh(j,:), 'LineWidth', 0.5, 'HandleVisibility', 'off', 'Color', 'r')
    end 
    
    hold off;
    
    title('Average PSD Pre-Surgery vs Post-Surgery')
    subtitle('Subject ' + string(sprintf('%02d',subj(i))))
    xlim([1 40]) 
    grid on
    legend('FontSize', 6);
    xlabel('Frequency (Hz)')
    ylabel('log(PSD)')
end 
end