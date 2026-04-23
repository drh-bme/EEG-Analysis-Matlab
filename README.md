# EEG-Analysis-Matlab
MATLAB-based pipeline for digital analysis and quantification of beta-gap compensation following resective surgery in pediatric focal epilepsy with known etiology. The project focuses on quantifying changes in Brain Power Spectral Density (PSD) before and after surgery, with a specific emphasis on comparing the lesion site versus the non-lesion site.

## Project Overview
The goal of the analysis is to define two biomarkers: **Asymmetry Index (AsI)** (static biomarker) and **Bistability Score (BiS)** (dynamic biomarker). AsI focuses on the relative difference of hemispheric power, while BiS focuses on the shift from pathological toward healthy regime. The goal of this analysis is to identify shifts for each Berger band, with a beta-band slightly modified, following surgical intervention.

* **AsI** focuses on the relative difference of hemispheric power.
* **BiS** focuses on the shift from a pathological toward a healthy regime.

The analysis identifies shifts for each Berger band following surgical intervention. For this specific cohort, a modified beta-band was used. All patients were treated with benzodiazepines, pharmacological agents that induce fast activity in the beta-band. This effect is proven to be absent in the epileptogenic zone—a phenomenon called the **beta-gap**. 

Due to unusual and artifacted activity above 40Hz observed in many tracks, an FIR Low-Pass Filter (LPF) at 40Hz was applied to every PSD to ensure data integrity.

The pipeline utilizes:
* **Bootstrap Resampling**: To generate 95% confidence intervals for PSD trends.
* **Non-Parametric Testing**: Wilcoxon Rank-Sum tests to validate changes in power.
* **Lesion-Specific Mapping**: Realigning EEG channels to isolate the surgical hemisphere regardless of anatomical side (Lx/Rx).

## Structure 

### **Core Pipeline**
* **`main.m`**: The primary entry point for the analysis. Defines subject IDs and frequency bands (Delta, Theta, Alpha, and Beta).
* **`loadData.m`**: Handles data I/O by constructing file paths and loading `.mat` PSD structures.
* **`ComputeMeanPSD.m`**: Calculates the average Power Spectral Density across all channels for a specific subject and condition.

### **Statistics & Group Analysis**
* **`bootstrapDist.m`**: Calculates the bootstrap distribution of the mean PSD by resampling channels.
* **`wilcoxonTest.m`**: Performs the Wilcoxon Rank-Sum test for a single subject across all channels for defined frequency bands.
* **`wilcoxon4Lesions.m`**: Compares pre- vs. post-surgery power. Includes **False Discovery Rate (FDR)** correction using the MATLAB `mafdr` function to adjust for multiple comparisons.
* **`wilcoxonSymmetry.m`**: Performs group-level statistical testing (Rank-Sum + FDR) specifically for the AsI and BiS biomarkers.
* **`lesionDistribution.m`**: Aggregates mean PSD data, AsI, and BiS for lesion vs. non-lesion groups across multiple subjects and bands.
* **`computeSymmetryIndices.m`**: Calculates the **Asymmetry Index (AsI)** and integrates the proprietary **Bistability Score (BiS)** calculation.
* **`realignPSD.m`**: Standardizes data by mapping electrodes to 'Lesion' or 'Non-Lesion' sides regardless of which hemisphere contains the lesion.

### **Visualization**
* **`plotAllPrePost.m`**: Generates a layout comparing global group trends against individual subject outcomes (e.g., Subjects 03 and 08).
* **`plotConfidenceInterval.m`**: Plots mean PSD and 95% confidence intervals into current axes using bootstrap data.
* **`plotAllSub.m`**: Creates a tiled layout comparing Pre- vs. Post-surgery PSD for every subject in the study.
* **`fill_between.m`**: A utility function used to draw the shaded patches representing confidence intervals.

## Setup & Requirements

* **MATLAB Toolbox**: Requires the **Statistics and Machine Learning Toolbox** (for `bootstrp` and `ranksum`) and the **Bioinformatics Toolbox** (for `mafdr`).
* **Data Path Configuration**: Users must manually update the `basePath` variable in `loadData.m` to match their local directory.
* **Data Format**: 
    * Input files must follow the naming convention `SubjectXX_PrePSD.mat` or `SubjectXX_PostPSD.mat`.
    * The `.mat` files must contain a structure with the fields `powspctrm`, `freq`, and `label`.
* **Frequency Consistency**: The analysis assumes a standard frequency bin dimension (e.g., $f = 257$) across subjects.
