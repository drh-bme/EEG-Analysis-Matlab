function [] = wilc4All(subj, bands)
    for i= 1:length(subj)
        wilcoxonTest(subj(i),5,bands)
    end
end