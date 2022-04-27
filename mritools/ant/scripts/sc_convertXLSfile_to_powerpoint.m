% <b> posthoc; convert Excelsheets to one powerpoint-file   </b>          
% Here the statistical output (excel-files)a after running the region-based statistic analysis 
% is converted to a single PPT-file
% <font color=orange> *** Use this script after running the region-based statistic analysis! *** </font>
% <font color=fuchsia><u>EXAMPLE-1:</u></font>
% in example-1 the paxls-path contains 6 excel-files (produced via region-based statistic analysis):
% <pre>  statROI_SIG_VOL_rw_t2__ttest2.xlsx        statROI_SIG__rw_ad__ttest2.xlsx,  
%        statROI_SIG__rw_adc__ttest2.xlsx          statROI_SIG__rw_c1t2__ttest2.xlsx,  
%        statROI_SIG__rw_fa__ttest2.xlsx           statROI_SIG__rw_rd__ttest2.xlsx  </pre>
% all files contain the statistical comparisons for the following group-comparisons
%     'CTRL vs HR' (sheet-2);     'CTRL vs LR' (sheet-3);     'HR vs LR' (sheet-4)
% Here we convert the all sheets-2/3/4 from all xlsfiles to a single PPT-file


% ==============================================
%% example[1]: convert sheets-2,3 and 4 from all Excelfiles starting with name 'statROI_SIG_' from folder
%% paxls-dir to a single PPT-file. Here, a new PPTfile is created ('append',1) and the PPT-slides are
%% sorted('sort',1): ppt-slides ordered according sheetorder, first sheet-no 2,2,...,2, than 3,3,...,3 than 4,4,...,4)
% ===============================================
paxls='F:\data5\eranet_round2_statistic\regionwise';
xls2ppt(paxls,'^statROI_SIG_.*.xlsx',[2:4],fullfile(paxls,'SUMMARY_ROI_SIG.pptx'),'append',0,'sort',1);


% ==============================================
%% example[2]: convert sheets-2,3 and 4 from all Excelfiles starting with name 'statSIG_' from folder
%% paxls-dir to a single PPT-file. Here, a new PPTfile is created ('append',1) and the PPT-slides are
%% sorted('sort',1): ppt-slides ordered according sheetorder, first sheet-no 2,2,...,2, than 3,3,...,3 than 4,4,...,4)
% ===============================================
paxls='F:\data5\eranet_round2_statistic\regionwise';
xls2ppt(paxls,'^statSIG_.*.xlsx',[2:4],fullfile(paxls,'SUMMARY_SIG.pptx'),'append',0,'sort',1);






