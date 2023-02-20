

%% <b> plot DTI-results as matrix-layout, save as Powerpoint-file </b>
% This script does the following:
% <b><u><font color="fuchsia"> (1) calculation using "dtistat.m" has to be done and saved (as mat-file) before  </font></b></u>
% -results are stored in a powerpoint-file, which is stored in the same folder
%  as the calculation (mat-file) is located
% The PPT-file contains the plots in matrix-layout for different p-values and FDR-correciton
%
% <b>  MANDATORY INPUTS:  </b>
%  pax: main folder containing 1/several matfiles with the saved calculation generated via "dtistat.m"
%  atlas  : the atlas (excelfile) used for DTI-prepreprocessing
% ==============================================

% ==============================================
%%   change this paramters
% ===============================================

pax='F:\data6\DTI_thomas_reduceMatrix\result_DTI_reducedCON'  ;%main Folder with calculations
atlas='F:\data6\DTI_thomas_reduceMatrix\schmitzAtlas301022\SchmitzAtlas_301022.xlsx'


% ==============================================
%%   do NOT change this paramters
% ===============================================

[files] = spm_select('FPListRec',pax,'^calc.*.mat');
files=cellstr(files);

for i=1:length(files)
    matfile=files{i};
    dtistat('loadcalc',matfile);
    [pam fi ext]=fileparts(matfile);
    pptfile=fullfile(pam,['resPlot_'  regexprep(fi,{'^calc_'},{''})  '.pptx']);
    dtistat('summaryplot','atlas',atlas,'pptfile',pptfile);
end