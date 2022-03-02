


%% <b> script to export result for visalization (vol3d)  </b>
% 
%  <u><b><font color=blue> following is assumed:    </b></u>
% - DTI-statistic via dtistat.m already performed 
% - the calculation is saved (a 'calc_*.mat')
% AIM:
% - export results to visualize connections via "vol3d.m"
% - as excel-file
% 
% ========================================================
% -<b><font color=blue> VARIABLE PARAMETER   </b>
% ========================================================
% [calcfile] : fullpath-filename of the statistics-calculation ('calc_*.mat')
% [outdir]   : output-directory to save the result (excel-file)
% ===============================================


calcfile='F:\data5\eranet_round2_statistic\DTI\result_propTresh1\eranet_connectome__3x3\calc_eranet_connectome__3x3__gc_HR_VS_LR.mat' ;%calculation file
outdir  ='F:\data5\eranet_round2_statistic\DTI\result_propTresh1\eranet_connectome__3x3\'  % resulting output-directory
     

% ==============================================
%%   [1] opem GUI and load calulation
% ===============================================


dtistat('new');                                                        % #g make new "dtistat"-window
dtistat('loadcalc',calcfile);

% ==============================================
%%   export excel-file for 3dvol
% ===============================================
z=[];
z.ano           = 'F:\data5\eranet_round2_statistic\DTI\PTSDatlas_01dec20\PTSDatlas.nii';                % % select corresponding DTI-Atlas (NIFTI-file); such as "ANO_DTI.nii"
z.hemi          = 'F:\data5\eranet_round2_statistic\DTI\templates\AVGThemi.nii';                         % % select corresponding Hemisphere Mask (Nifti-file); such as "AVGThemi.nii"
z.cs            = 'diff';     % % we use the difference of the connection strength ;  % % connection strength (cs) or other parameter to export/display via xvol3d
z.sort          = [1];        % % sort connection list: (0)no sorting ; (1)sort after CS-value; (2)sort after p-value;
z.outDir        = outdir;     % % output folder
z.filePrefix    = 'e_';       % % output filename prefix (string)
z.fileNameConst = '$filePrefix_$cs_$contrast_$keep';     % % output-filename constructor                                              % % resulting fileName is constructed by...
z.contrast      = 1    ;     % % first contrast is exported                                                                    % % constrast to save (see list (string) or numeric index/indices)
z.keep          = 'FDR';     % % use FDR                                                                              % % connections to keep in file {'all' 'FDR' 'uncor' 'manual selection' 'p<0.001' 'p<0.0001'}
z.underscore    = [0];       % % {0,1} underscores in atlas labels:  {0} remove or {1} keep
z.LRtag         = [1];       % % {0,1} left/right hemispheric tag in atlas labels:  {0} remove or {1} keep
dtistat('export4xvol3d',z,'gui',0); % closed gui (change the 'gui'-paramter to 1 to open the gui)







