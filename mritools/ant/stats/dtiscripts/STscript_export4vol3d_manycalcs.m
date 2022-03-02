

%% <b> script to export result for visalization for several calculations (vol3d)  </b>
% 
%  <u><b><font color=blue> following is assumed:    </b></u>
% - DTI-statistic via dtistat.m already performed for several calculations
%   ..different calculations for instance because different group-
%     comparisons were used or different DTI-matrices were tested
% - the calculations were saved as 'calc_*.mat'
% AIM:
% - export results to visualize connections via "vol3d.m"
% - as excel-file(s)
% 
% ========================================================
% -<b><font color=blue> EXAMPLE BELOW   </b>
% ========================================================
% <pre>
%  Scenario:
% the folder 'pa' contains three subfolders: 
%     eranet_connectome         
%     eranet_connectome_6vsAll  
%     eranet_connectome__3x3
%  each of these subfolders contains three calculations
%    -the name of the calculations starting with "calc_":
%        example:
%        calc_eranet_connectome__gc_CTRL_VS_HR.mat
%        calc_eranet_connectome__gc_CTRL_VS_LR.mat
%        calc_eranet_connectome__gc_HR_VS_LR.mat
%  Here we want to export the results for visualization for all calc-files
%  from all subfolders and store the results (excel-files) in the 
%  respective subfolders
% </pre>
%        
% ===============================================



% ==============================================
%%
% ===============================================
clear; warning off
% path containg subdirs, each subdir conains some calculations
% pa='F:\data5\eranet_round2_statistic\DTI\result_propTresh0';
pa='F:\data5\eranet_round2_statistic\DTI\result_propTresh1';   % main-folder containing the subfolders

[subdir_all] = spm_select('FPList',pa,'dir','.*'); %get sub-folders
subdir_all=cellstr(subdir_all);

for j=1:length(subdir_all) % for all subdirs...
    
    outdir=subdir_all{j}; %save export-file to same subdir-directory
    
    [calcfiles_all] = spm_select('FPList',outdir,'^calc_.*.mat'); %obtain calculation-files
    calcfiles_all=cellstr(calcfiles_all);
    
    
    for i=1:length(calcfiles_all) %for all calc-files in subdir
        calcfile=calcfiles_all{i};
        
        dtistat('new');               % #g make new "dtistat"-window
        dtistat('loadcalc',calcfile); % load calculation         
        % ==============================================
        %%   export excel-file for 3dvol
        % ===============================================
        z=[];
        z.ano           = 'F:\data5\eranet_round2_statistic\DTI\PTSDatlas_01dec20\PTSDatlas.nii';                % % select corresponding DTI-Atlas (NIFTI-file); such as "ANO_DTI.nii"
        z.hemi          = 'F:\data5\eranet_round2_statistic\DTI\templates\AVGThemi.nii';                         % % select corresponding Hemisphere Mask (Nifti-file); such as "AVGThemi.nii"
        z.cs            = 'diff';                                                                                % % connection strength (cs) or other parameter to export/display via xvol3d
        z.sort          = [1];                                                                                   % % sort connection list: (0)no sorting ; (1)sort after CS-value; (2)sort after p-value;
        z.outDir        = outdir;     % % output folder
        z.filePrefix    = 'e_';                                                                                 % % output filename prefix (string)
        z.fileNameConst = '$filePrefix_$cs_$contrast_$keep';                                                     % % resulting fileName is constructed by...
        z.contrast      = 1 ;     %first contrast                                                                     % % constrast to save (see list (string) or numeric index/indices)
        z.keep          = 'FDR';                                                                                 % % connections to keep in file {'all' 'FDR' 'uncor' 'manual selection' 'p<0.001' 'p<0.0001'}
        z.underscore    = [0];                                                                                   % % {0,1} underscores in atlas labels:  {0} remove or {1} keep
        z.LRtag         = [1];                                                                                   % % {0,1} left/right hemispheric tag in atlas labels:  {0} remove or {1} keep
        dtistat('export4xvol3d',z,'gui',0); % closed gui
        % ==============================================
        %%
        % ===============================================
    end %i:calcfiles_all
end %j:subdir_all

