function [A] = loadData(Id, condition)
% LOADdATA Builds the file path and loads the raw PSD data structure.
%
% Inputs:
%   Id:        The numeric subject ID (e.g., 3).
%   condition: String indicating the condition ('Pre' or 'Post').
%
% Output:
%   A:         The loaded MATLAB struct containing all data fields (e.g., dimord, powspctrm, freq).

%% Build file path
% Format the numeric ID to a two-digit string (e.g., 3 -> '03') and prepend 'Subject'.
Id = 'Subject' + string(sprintf('%02d',Id)); 
% Define the base directory where the PSD .mat files are stored.
basePath = 'C:\Users\...';% <<< This part NEEDS to be changed
% Construct the full file path string (e.g., .../DataPSD/Subject03_PostPSD.mat)
Path = basePath + Id + '_' + condition + 'PSD.mat';      % according to file saving format

% Check if the file exists before attempting to load.
if not(isfile(Path))
    disp(Id)
    error('File not found')
end

% Load the data structure into variable A.
A = load(Path);
end