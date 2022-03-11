

% <b> script to make summary of voxelwise statistic FOR SEVERAL IMAGES   </b>  
% <font color=fuchsia><u>RUN THIS AFTER CALCULATION OF VOXELWISE STATISTIC FOR SEVERAL IMAGES!:</u></font>
%
% to performing voxelwise statistic see: "VWscript_twosampleStat_severalimages.m"
% 
% <font color=fuchsia><u>DESCRIPTION:</u></font> 
% [1] the variable "spmdirMain" defines the path to a folder containing voxelwise-statistics for
% several images. The voxelwise statistic for each image is stored in a subfolder with the image-name
% [2] via spm_select we search in spmdirMain-path for the "SPM.mat"-file and obtain the folders
% containing the voxelwise statistic of the images 
% [3] the variable "PPTFILEprefix" is the prefixstring of the resulting PPT-file
% For each image a PPT-file is created.
% 
% [4] the variable "outdirMain" is the output-folder containing the summary output 
%  and is created in the spmdirMain-folder
%    -The outdir-folder will contain:
%          - a PPT-file for each image with a summary report
%          - a folder for each image containing the thresholded volumes and the resulting
%            excel-table
%  
% * here the following is PPT/excelfiles & volumes are made:
%     NOT DONE HERE:  a) uncorrected at p=0.001  (you may enable this step)
%   b) peak-cluster-threshold at p=0.001 with clusterSize-estimation
%   c) FWE-coorection at p=0.05
% for both directions of the contrast (a<b & a>b)...
% 
% <font color=red><u> ... COPY ENTIRE CONTENT AND MODIFY ACCODINGLY..</u></font>
% _______________________________________________________________________________





clear;
warning off;
clc;

 % ==============================================
 %% #km  mandatory inputs (change these paramters)
 % ===============================================
 % [1] spmdirMain is the main-folder containing subfolders with SPM-analysis
spmdirMain='F:\data5\eranet_round2_statistic\voxstat\voxstat_test2';

 % [2] get DIRS of SPM-analysis (those containing the "SPM.mat"-file)
[fi] = spm_select('FPListRec',spmdirMain,'^SPM.mat');
spmdirs=fileparts2(cellstr(fi));

 % [3] fileName prefix of the resulting powerPoint file (stored in "spmdirMain"-dir)
PPTFILEprefix  = 'result_voxw_26jan22';              % PowerPoint - fileNamePrefix

 % [4] output-folder of excel-files and thresholded volumes
outdirMain         = fullfile(spmdirMain,'results_26jan22'); % output-folder for Excelfiles & volumes

% ==============================================
%% #b    some settings
% ===============================================
cd(spmdirMain);
[~,spmdirsShort]=fileparts2(spmdirs); % shortNames of the SPM-dirs..used for PPT-file-names
mkdir(spmdirMain); % make spmdirMain-folder
% ==============================================
%% #b   loop over SPM-dirs
% ===============================================

for g=1:length(spmdirs) % SPM_folders
    thisDir=spmdirs{g};
    PPTFILE=fullfile(outdirMain,[PPTFILEprefix '_' spmdirsShort{g} '.pptx'   ]);
    outdir=fullfile(outdirMain,[ spmdirsShort{g}    ]);
    mkdir(outdir);
    
    % #b  =====LOAD SPMmat==========================================
    cd(thisDir);
    cf; xstat('loadspm',fullfile(pwd,'SPM.mat'));  

    % #b =====loop over the two directional contrasts (x smaller y, x larger y)=============
    for con=1:2
        if mod(con,2)==1 % alterate PPT-backgroundcolor for each contrast
            bgcol=[1 1 1]; % PPT-bgColor
            DOC='new';  % for each SPM-DIR, if contrast is 1--> create "new" PPTfile
        else
            bgcol=[0.8941    0.9412    0.9020];
            DOC='add';   % add PPT-slide to existing PPT-file
        end
        
        % ______________UNCORRECTED with p=0.001_________________________________
        % set to [1] if you want to have the uncorrected plots
        if 0 % 
            % #m [1] SUMMARY: uncorrected, at p=0.001, clusterSize k=1 -------
            xstat('set',struct('MCP','none','thresh',0.001,'clk',1,'con',con,'show',0)); % set PARAMETER
            xstat('report',PPTFILE,struct('doc',DOC,'con',con,'bgcol',bgcol  )); % save stat. table in PPT
            xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
            xstat('savevolume',outdir); % save tresholded volume
            xstat('export',outdir);     % save stat. table as excelfile
        end
        
        % ______________Peak-cluster with estim. clustersize____________________
        % #m [2] SUMMARY: Peak-cluster with estimated clusterSize -------
        % estimate clustersize
        pthresh=0.001;
        xstat('set',struct('MCP','none','thresh',pthresh,'clk',1,'con',con,'show',1)); % set PARAMETER, mandatory to estimate clustersize
        clustersize = cp_cluster_Pthresh(xSPM, pthresh); %estimate clusterSize
        
        xstat('set',struct('MCP','none','thresh',0.001,'clk',clustersize,'con',con,'show',0)); % set PARAMETER
        xstat('report',PPTFILE,struct('doc','add','con',con,'bgcol',bgcol    )); % save stat. table in PPT
        xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  ));% save volume in PPT
        xstat('savevolume',outdir); % save tresholded volume
        xstat('export',outdir);     % save stat. table as excelfile
        
        % ______________FWE___________________________________________________
        % #m [3] SUMMARY: FWE_CORRECTION, at p=0.05,  clusterSize k=1 -------
        xstat('set',struct('MCP','FWE','thresh',0.05,'clk',1,'con',con,'show',0)); % set PARAMETER
        xstat('report',PPTFILE,struct('doc','add','con',con,'bgcol',bgcol    )); % save stat. table in PPT
        xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
        xstat('savevolume',outdir); % save tresholded volume
        xstat('export',outdir);     % save stat. table as excelfile
        
    end
end
cd(spmdirMain);

