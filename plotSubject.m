function [] = plotSubject(subj, r)
% PLOTSUBJECT Simple plot for individual subject Pre vs Post check.

    %% Variables
    [freqPre, preAv] = ComputeMeanPSD(subj(r),'Pre');
    [freqPost, postAv] = ComputeMeanPSD(subj(r),'Post');

    %% Plot
    loglog(freqPre, preAv, 'LineWidth', 2, 'DisplayName','Pre-surgery', 'Color', 'b')
    hold on;
    loglog(freqPost, postAv, 'LineWidth', 2, 'DisplayName','Post-surgery', 'Color', 'r')
    hold off;

    id = string(sprintf('%02d', subj(r)));
    title('Average PSD Pre-Surgery vs Post-Surgery')
    subtitle('Subject ' + id)
    xlim([1 40]) 
    ylim([1e-15 1e-9])
    grid on
    legend();
    xlabel('Frequency (Hz)')
    ylabel('PSD')
end