
% <b> script to make summary of voxelwise statistic (simple)    </b>  
% <font color=fuchsia><u>RUN THIS AFTER CALCULATION OF VOXELWISE STATISTIC!:</u></font> 
% 
% 
% <font color=fuchsia><u>DESCRIPTION:</u></font> 
% [1] a powerpoint-file for the voxelwise statistic is created within the SPM-analysis-folder
% [2] an output-folder is created within the SPM-analysis-folder; containing:
%      -the stat.table as excelfile
%      -the thresholded-volume accord. to the applied statistical specifications
% * here the following is PPT/excelfiles & volumes are made for
%   a) uncorrected at p=0.001
%   b) peak-cluster-threshold at p=0.001 with clusterSize-estimation
%   c) FWE-coorection at p=0.05
% for both directions of the contrast (a<b & a>b)...
% ===============================================

% clear;cf;
warning off;
clc

% ==============================================
%% #km  mandatory inputs (change these paramters)
% ===============================================
% [1] get DIR of SPM_analysis
currdir=pwd;  % current directory...just to jump back after running through the script
spmdir ='F:\data5\eranet_round2_statistic\voxstat\voxstat_test1'  ;% SPM-direcotry containing the STATISTIC (folde rmut contain "spm.mat")


% [2] fileName prefix of the resulting powerPoint file (stored in "pabase"-dir)
PPTFILEprefix  = 'result_voxw_03mar22';              % PowerPoint - fileNamePrefix

% [4] output-folder of the resulting excel-files and thresholded volumes
outdir         = fullfile(spmdir,'results_03mar22'); % output-folder for Excelfiles & volumes






% ==============================================
%% #km  internal inputs: do not change or be careful!
% ===============================================
% ==============================================
%% #b    some settings
% ===============================================
cd(spmdir);
[~,spmdirsShort]=fileparts2(spmdir); % shortNames of the SPM-dirs..used for PPT-file-names
mkdir(outdir); % make outdir-folder
% ==============================================
%% #b   loop over SPM-dirs
% ===============================================

thisDir=char(spmdirsShort);
PPTFILE=fullfile(spmdir,[PPTFILEprefix '_' thisDir '.pptx'   ]);

% #b  =====LOAD SPMmat==========================================
cd(spmdir);
cf; xstat('loadspm',fullfile(pwd,'SPM.mat'));

% #b =====loop over the two directional contrasts (x larger y, x smaller y)=============
for con=1:2
    if mod(con,2)==1 % alterate PPT-backgroundcolor for each contrast
        bgcol=[1 1 1]; % PPT-bgColor
        DOC='new';  % for each SPM-DIR, if contrast is 1--> create "new" PPTfile
    else
        bgcol=[0.8941    0.9412    0.9020];
        DOC='add';   % add PPT-slide to existing PPT-file
    end
    
    % #m [1] SUMMARY: uncorrected, at p=0.001, clusterSize k=1 -------
    xstat('set',struct('MCP','none','thresh',0.001,'clk',1,'con',con,'show',0)); % set PARAMETER
    xstat('report',PPTFILE,struct('doc',DOC,'con',con,'bgcol',bgcol  )); % save stat. table in PPT
    xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
    xstat('savevolume',outdir); % save tresholded volume
    xstat('export',outdir);     % save stat. table as excelfile
    
    % #m [2] SUMMARY: Peak-cluster with estimated clusterSize -------
    clustersize = cp_cluster_Pthresh(xSPM, 0.001); %estimate clusterSize
    xstat('set',struct('MCP','none','thresh',0.001,'clk',clustersize,'con',con,'show',0)); % set PARAMETER
    xstat('report',PPTFILE,struct('doc','add','con',con,'bgcol',bgcol    )); % save stat. table in PPT
    xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  ));% save volume in PPT
    xstat('savevolume',outdir); % save tresholded volume
    xstat('export',outdir);     % save stat. table as excelfile
    
    % #m [3] SUMMARY: FWE_CORRECTION, at p=0.05,  clusterSize k=1 -------
    xstat('set',struct('MCP','FWE','thresh',0.05,'clk',1,'con',con,'show',0)); % set PARAMETER
    xstat('report',PPTFILE,struct('doc','add','con',con,'bgcol',bgcol    )); % save stat. table in PPT
    xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
    xstat('savevolume',outdir); % save tresholded volume
    xstat('export',outdir);     % save stat. table as excelfile
    
end
cd(currdir);

