
% GUI to show exponential signal decay fit for CESL or DIFFUSION
% for:
%  1) CESL / R1ρ mapping:
%     R1ρ Exponential Relaxation Fit:
%     -> describes how fast spins lose coherence over time (TSL domain)
%
%  2) DIFFUSION / ADC mapping:
%     Diffusion Decay Fit (ADC Model):
%     -> describes how fast signal is attenuated by diffusion weighting (b-values)
%
% --------------------------------------------------------------
% GENERAL MODEL
% --------------------------------------------------------------
% For each voxel, the signal decay is modeled as:
%
%   S(x) = S0 * exp(-k * x) [+ C]
%
% where:
%   S(x)   = measured signal
%   S0     = signal at x = 0
%   k      = decay rate (R1ρ or ADC depending on modality)
%   x      = TSL (CESL) or b-value (diffusion)
%   C      = optional constant offset (noise floor / baseline)
%
% --------------------------------------------------------------
% INTERPRETATION OF k
% --------------------------------------------------------------
% CESL / TSL domain:
%   k = R1ρ   [1/s]        (relaxation rate in rotating frame)
%
% Diffusion / b-value domain:
%   k = ADC   [mm^2/s]     (apparent diffusion coefficient)
%
% NOTE:
%   Both represent exponential decay rates but reflect different physics.
%
% --------------------------------------------------------------
% FITTING OPTIONS
% --------------------------------------------------------------
% 'linear'
%   log-linearized fit:
%       ln(S) = ln(S0) - k*x
%   + fast, stable
%   - biased at low SNR
%
% 'nonlinear'
%   direct nonlinear fit:
%       S(x) = S0 * exp(-k*x)
%   + accurate
%   - slower
%
% 'nonlinear_constant'
%   nonlinear fit with baseline offset:
%       S(x) = S0 * exp(-k*x) + C
%   + handles noise floor / residual signal
% --------------------------------------------------------------
% INPUT DATA
% --------------------------------------------------------------
% 3rd dimension contains either:
%   - spin-lock times (TSL) for CESL
%   - b-values for diffusion
%
% Example size:
%   [220 220 N]
%
% where N = number of TSL or b-value points
%
% IMPORTANT:
%   length(TSL) must match size(image,3)
%
% --------------------------------------------------------------
% USAGE
% --------------------------------------------------------------
% xCESL_monoexpfit_showfit(showgui, x)
% xCESL_monoexpfit_showfit(showgui, x, pa)
%
%
%
% ==============================================================
% INPUT
% ==============================================================
% [showgui]  Show graphical user interface.
%               [1] show GUI
%               [0] no GUI
% [x]       Structure containing processing parameters.
% [pa]      Optional cellstring containing animal paths outside ANTx project structure.
%           Default:  Uses currently selected animals from ANTx GUI.
% ==============================================================
% PARAMETERS (x)  , struct
% ==============================================================
% [file]  Input CESL map/Diffusion-map (3D NIfTI).
%         Example dimensions: [220 220 13]
%         where dim3 corresponds to the different spin-lock times or b-values.
% --------------------------------------------------------------
% [fit_othermaps] Process additional CESL/diffusion maps belonging to the same series.
%   [1] process all matching files
%   [0] process only selected file
%         Matching is based on:
%           - identical basename
%           - numeric suffixes (001,002,...)
%         Default: [1]
% --------------------------------------------------------------
% [mask] Optional binary brain mask (2D NIfTI slice).
%         Advantages:
%           - accelerates computation
%           - suppresses background fitting
%         Example:   ix_AVGTmask_slice.nii
%         Example dimensions:   [220 220 1]
% 
%     alternatively make internal mask via  thresholding image via '>value'
%         example '>10'  ..threshold image
% --------------------------------------------------------------
% [fitmethod] Mono-exponential fitting method.
%         Options:     'linear' , 'nonlinear' , 'nonlinear_constant'
%         Default:      'nonlinear'
% --------------------------------------------------------------
% [TSL] Spin-lock times corresponding to dim3 of the CESL map.
%       or b-values for diffusion images (ADC / IVIM-like fitting)
%         Requirements:
%           - number of TSL or  b-values values must match dim3
%           - order must match dim3 order exactly
%         Input format:
%           - numeric array
%           - string containing numeric values
%         The GUI provides a helper tool to extract:
%              - TSL-values directly from Bruker raw-data: Select a corresponding "TSL"-file here.
%              - b-values directly from Bruker raw-data: Select  a corresponding "method"-file here.
% 
% --------------------------------------------------------------
% [TSL_unit] Units of the supplied spin-lock times.
%         Options:
%           's'    seconds
%           'ms'   milliseconds
%           'us'   microseconds
%         Internally all TSL/b-values values are converted to seconds before fitting.
%         Notes:
%           - Bruker raw data commonly stores TSL values in 'us'
%           - incorrect units lead to incorrect R1rho values
%         Default: 'us'
% --------------------------------------------------------------
% [xlabel] xlabel of plot
% --------------------------------------------------------------
% [ylabel] xlabel of plot
%
% ==============================================================
% OUTPUT: none
% ==============================================================
% ANTx HISTORY:
% ==============================================================
% Use:   anth
% or:    disp(char(anth))
% to display the last executed command.
% ==============================================================
%% ####################################################################
%  MAIN GUI
% ####################################################################
% 
% [animals]         (pulldown) select a specific animal here
%      -animal-list is defined via selected animals in the ANTx-animal listbox 
% [screenshot path] (edit), the output path for screenshots
%      -if not exist, path will be created on the fly
%      -default: pwd
% [prefix]   (edit) file prefix for saved screenshot, default: "fit"
% 
% [count up] (radio) add counter-suffix (0001,0002...) and counts-up by checking prefix and counter-string in [screenshot path] )
% [add info] (radio) add aditional information (point, rectangle, square, circle) and location to screenshot-filename
% [animal]   (radio) add animal-name to screenshot-filename
% [file]     (radio) add fille-name to screenshot-filename
% 
% [autosave] (radio): [1] open GUI to select/modify screenshot-filename
%                     [0] no GUI ..automatically save screenshot based on above radio-configuration
% 
% 
% [DPI] (edit)  dpi of schreenshot; default: 150 (dpi)
% 
% [screen capture] (button)  -make screenshot, depending on [autosave]-status, a filename-selection opens
%                             or screenshot is directly saved 
% 
% 
% [load ROI] (button)  -load ROI-file (textfile) 
%      a ROI-file looks as follows:   type('ROI.txt')
%         square-4     93.7 97.7 97.7 93.7 ;83.9 83.9 87.9 87.9                                                                                                                           
%         square-4     89.3 93.3 93.3 89.3 ;72.5 72.5 76.5 76.5                                                                                                                           
%         userdefined  110.2 121.7 116.7 ;62.0 59.3 66.3                                                                                                                                  
%         userdefined  144.8 144.2 149.4 150.7 146.8 ;80.9 88.3 87.1 79.8 77.7                                                                                                            
%         circle-4     98.1 97.7 96.8 95.3 93.7 92.1 90.9 90.2 90.2 90.9 92.1 93.7 95.3 96.8 97.7 98.1 ;84.7 86.3 87.6 88.5 88.7 88.1 87.0 85.5 83.8 82.3 81.2 80.7 80.9 81.7 83.0 84.7   
% 
% [save ROI] (button)  -save ROIs as ROI-file (textfile) 
% 
% [Range (dual-knob) slider] - can be used to define the lower/upper colormap-limits of the middle image (input or fitted image)
%                             -you can move the lower or upper knob of both
% [fix range] (radio): [1] hold lower/upper colormap-limits fixed when a new image/animal is loaded
%                      [0] set colormap-limits to current image range 
% [show fitted imge] (toggle button)  [1]  middle image shows fitted image 
%                                     [0]  middle image shows input image
% 
% [roi] (radio):   [1] ROI-based readout .. create specific (polygon-based) ROI (userdefined, square, rectangle,circle)
%                      -based on right [ROIs]-puldown menu 
%                  [0] pointwise (i.e. voxel-wise) readout
% [specific ROIs]   (pulldown) select a ROI here (userdefined, square, rectangle,circle)
%                   - the middle image will display the ROI, 
%                   -ROIs can be moved, points of the ROI can be relocated
% [keyboard] (button) -show keyboard shortcuts in the comand-line  
%                     -shortcuts can be used to add/remove a ROI to/from a ROI-list, show ROI-list
%                     -automatically create screenshots over animals/files/ROIs
% [help] (button) -show help of this function 
% 
%% ===================================================================================================
% [left image]  : - shows the first 2D-image  of a 3D-input image (static)
% [middle image]: - shows either the fitted image or the first 2D-image  of a 3D-input image
%                   depending on the [show fitted imge] toggle button
%                 -ROI-mode: -you can define ROIs here 
%                            -move ROI to see the correponding fitted plot the in the right
%                 -voxel/pointwise-mode: hover mouse-pointer over voxels to see the correponding fitted plot
%                  in the right plot
% [right plot]: exponential signal decay Fit :
%              - R1ρ Exponential Relaxation Fit:  how fast spins lose coherence over time
%              - Diffusion Decay Fit (ADC Model)): how fast water signal is suppressed by spatial diffusion weighting
%                 
% 
%% ####################################################################
%  POST HOC SETTINGS
% ####################################################################
% POSTHOC settings can be made via 'set'
% xCESL_monoexpfit_showfit('set',<cellarray with pairwise inputs>);
% 
% 'countup'  -set 'count-up'-radio, {0,1}
% 'addinfo'  -set 'add info'-radio, {0,1}
% 'autosave' -set 'autosave'-radio, {0,1}
% 'animal'   -set 'animal'-radio, {0,1}
% 'file'     -set 'file'-radio, {0,1}
% 'showfit'  -set 'showfit'-togglebutton, {0,1}
% 'fixrange' -set 'fixrange'-radio, {0,1}
% 'outdir'   -set 'screenshot output parh'-edit field, <string>
% 'cmap'     -set 'colormap'-pulldown, either numeric index value or name of the cmap (example: 'parula') 
% 'dpi'      -set 'screenshot DPI-value'-edit field, <string>
% 
% 'clim'     -set colormap limits
%             example: xCESL_monoexpfit_showfit('set',{'clim',[0 20],'fixrange',1} )
%             
% 
% 'capture'   make screenshot
%              -[1]  make screenshot from current plot
%                 example: xCESL_monoexpfit_showfit('set',{'capture',1} )
%              -'outputname.png'   make screenshot from current plot, using defined outputname
%                example: xCESL_monoexpfit_showfit('set',{'capture',fullfile(pwd,'dum.png')} )
%              -{animals, files, ROis}
%                example: make screenshots from 1st animal and all files and all ROIs 
%                xCESL_monoexpfit_showfit('set',{'capture',{1 'all' 'all'} })
% 
% 'loadrois'  -load ROIfile with rois,  specify fullpath-name of ROIfile 
%               example: xCESL_monoexpfit_showfit('set',{'loadrois',fullfile(pwd,'ROI2.txt') })
%          
% 'addroi'   programmatically add a ROI to ROI-list
%            examples:
%                xCESL_monoexpfit_showfit('set',{'addroi',{'point' [120 130]} });
%                xCESL_monoexpfit_showfit('set',{'addroi',{'square' [80 85 85 80 ;100 100 105 105]} });
% 'delroi'   delete ROI from ROIlist
%             example
%              xCESL_monoexpfit_showfit('set',{'delroi',[1 2]});
%              xCESL_monoexpfit_showfit('set',{'delroi','all'});
%    
% 
% 'showroi'  show ROI-list
%              xCESL_monoexpfit_showfit('set',{'showroi',1}); %show ROIlist in CMD
%              xCESL_monoexpfit_showfit('set',{'showroi',2}); %show ROIlist in figure (more detailed info)
% 
% 'plotroi'  plot specific ROI from ROI-list
%             examples: 
%               xCESL_monoexpfit_showfit('set',{'plotroi',1}); %plot 1st ROI from ROI-list
%               xCESL_monoexpfit_showfit('set',{'plotroi',2}); %plot 2nd ROI from ROI-list
% 
% 'loadfile'  load & fit a file from left listbox
%             examples: 
%                xCESL_monoexpfit_showfit('set',{'loadfile',3}); %load 3rd file (index based)
%                xCESL_monoexpfit_showfit('set',{'loadfile','c_c_T1rho_2DG__004.nii'}); %load file by name
% 
% 'loadanimal' load specific animal from upper pulldownmenu
%             examples:
%               xCESL_monoexpfit_showfit('set',{'loadanimal',2}); %load 2nd animal (index based)
%               xCESL_monoexpfit_showfit('set',{'loadanimal','2023117PM_hypothermia_2DG'}); %load animal by name
% 'isfreeze'   set freeze-toggle, {0,1}
%                 xCESL_monoexpfit_showfit('set',{'isfreeze',1})
% 'xlabel'     set 'xlabel' of fit-plot, <string>
% 'ylabel'     set 'ylabel' of fit-plot, <string>
%               xCESL_monoexpfit_showfit('set',{'xlabel','bla[a.u.]','ylabel','Sig'});
% 
% 'flipXY'     flip x,y-dimension, {0,1}, ..has to be re-fitted to take effect
%                  xCESL_monoexpfit_showfit('set',{'flipXY',0});
% 
% 
% 'flipLR'     flip L,R-dimension, {0,1}, ..has to be re-fitted to take effect
% 
% 'TSL_unit'   set 'TSL_unit'
% 
% 'decayRateName'  set 'decayRateName' in title of fit-plot
%                   xCESL_monoexpfit_showfit('set',{'decayRateName','D'});
% 
% 'fitmethod'   set  'fitmethod' 
%                 xCESL_monoexpfit_showfit('set',{'fitmethod','nonlinear'});
% 
%% ####################################################################
%  POST HOC EXAMPLES
% ####################################################################
%% ====[ example-1: using ROI-file]===========================================
% xCESL_monoexpfit_showfit(0,z);
% 
% xCESL_monoexpfit_showfit('set',{'countup',1,'addinfo',1, 'animal',1,'file',1,'showfit',1,'autosave',1 })
% xCESL_monoexpfit_showfit('set',{'cmap','hot'})
% xCESL_monoexpfit_showfit('set',{'outdir',fullfile(pwd,'pngs1') })
% xCESL_monoexpfit_showfit('set',{'loadrois',fullfile(pwd,'ROI2.txt') })
% 
% xCESL_monoexpfit_showfit('set',{'dpi',75})
% xCESL_monoexpfit_showfit('set',{'clim',[10 25],'fixrange',1} )
% %      xCESL_monoexpfit_showfit('set',{'clim',[nan nan]} )
% %      xCESL_monoexpfit_showfit('set',{'clim',[nan 20]} )
% 
% %      xCESL_monoexpfit_showfit('set',{'capture',1} )
% 
% xCESL_monoexpfit_showfit('set',{'capture',{1 1 'all'} })
%     
% 
%% ====[ example-2: programatically define ROIs ]===========================================
% xCESL_monoexpfit_showfit(0,z);
% 
% xCESL_monoexpfit_showfit('set',{'countup',1,'addinfo',1, 'animal',1,'file',1,'autosave',1 });
% xCESL_monoexpfit_showfit('set',{'showfit',0});
% xCESL_monoexpfit_showfit('set',{'cmap','parula'});
% xCESL_monoexpfit_showfit('set',{'dpi',75})
% xCESL_monoexpfit_showfit('set',{'clim',[0 20],'fixrange',1} )
% xCESL_monoexpfit_showfit('set',{'outdir',fullfile(pwd,'pngs2') });
% xCESL_monoexpfit_showfit('set',{'delroi','all'});
% xCESL_monoexpfit_showfit('set',{'addroi',{'point' [120 130]} });
% xCESL_monoexpfit_showfit('set',{'addroi',{'square' [80 85 85 80 ;100 100 105 105]} });
% xCESL_monoexpfit_showfit('set',{'showroi',[]});
% 
% xCESL_monoexpfit_showfit('set',{'capture',{1 'all' 'all'} })
%    
%% ====[ example-3: code-snippets ]===========================================
% 
% %make screenshot with specifc name
% xCESL_monoexpfit_showfit('set',{'capture',fullfile(pwd,'dum.png')} )
% 
% % plot specific ROIs
% xCESL_monoexpfit_showfit('set',{'plotroi',1});
% xCESL_monoexpfit_showfit('set',{'plotroi',2});
% 
% %load file from list-box
% xCESL_monoexpfit_showfit('set',{'loadfile',3});
% xCESL_monoexpfit_showfit('set',{'loadfile','c_c_T1rho_2DG__004.nii'});
% 
% %load animal
% xCESL_monoexpfit_showfit('set',{'loadanimal',2});
% xCESL_monoexpfit_showfit('set',{'loadanimal','2023117PM_hypothermia_2DG'});
% 
% 
% %specific parameter
% xCESL_monoexpfit_showfit('set',{'xlabel','bla[a.u.]','ylabel','Sig'});
% xCESL_monoexpfit_showfit('set',{'decayRateName','D'});
% 
% % flip-xy-dimension: ..data havw to be fitted before taking effect
% xCESL_monoexpfit_showfit('set',{'flipXY',0});
% 
% %change fitting-method..data havw to be fitted before taking effect
% xCESL_monoexpfit_showfit('set',{'fitmethod','nonlinear'});
% 
% 
% 
%% ####################################################################
%  EXAMPLES
% ####################################################################
%% EXAMPLE-1  : CESL -R1rho                                                                                                                                                              
% z=[];                                                                                                                                                                                                                          
% z.file          = { 'c_c_T1rho_2DG__001.nii' };                                                                      % % single CESL / diffusion map (NIfTI)                                                                   
% z.fit_othermaps = [1];                                                                                               % % fit also all other maps of this series (if available)                                                 
% z.mask          = { 'ix_AVGTmask_slice.nii' };                                                                       % % (optional,but prefered):binary brainmask (2D-NIFTI): example "ix_AVGTmask_slice.nii"                  
% z.fitmethod     = 'nonlinear_constant';                                                                              % % fitting method: {linear | nonlinear | nonlinear_constant}                                             
% z.TSL           = [5000  10000  20000  30000  40000  50000  60000  70000  80000  90000  100000  150000  200000];     % % signal encoding values (TSL for CESL or b-values for diffusion). Must match 3rd dimension             
% z.TSL_unit      = 'us';                                                                                              % % units of TSL or encoding values: [s] seconds; [ms] milliseconds; [us] microseconds; or none           
% z.decayRateName = 'R1rho';                                                                                           % % name of decay rate (R1ρ for CESL or ADC for diffusion; shown in plot title)                           
% z.xlabel        = 'TSL(s)';                                                                                          % % x-axis label (TSL for CESL or b-value for diffusion)                                                  
% z.ylabel        = 'Signal';                                                                                          % % y-axis label (signal intensity; diffusion often uses DW signal)                                       
% xCESL_monoexpfit_showfit(1,z);  
% 
%% EXAMPLE-2  : DIFFUSION-ADC                                                                                                                                                               
%% =====================================================                                                                                                                                                                       
%% #g FUNCTION:    [xCESL_monoexpfit_showfit.m]                                                                                                                                                                                
%%  GUI to show exponential signal decay fit for:                                                                                                                                                                              
%% =====================================================                                                                                                                                                                       
% z=[];                                                                                                                                                                                                                          
% z.file          = '03_ADC_map_19F_22.nii';                                                                                      % % single CESL / diffusion map (NIfTI)                                                        
% z.fit_othermaps = [1];                                                                                                          % % fit also all other maps of this series (if available)                                      
% z.mask          = 'mask.nii';                                                                                                   % % (optional,but prefered):binary brainmask (2D-NIFTI): example "ix_AVGTmask_slice.nii"       
% z.fitmethod     = 'nonlinear_constant';                                                                                         % % fitting method: {linear | nonlinear | nonlinear_constant}                                  
% z.TSL           = [13.18056512  1009.622548  3010.317768  6010.999112  10011.67604  20012.91999  50015.38817  100018.1697];     % % signal encoding values (TSL for CESL or b-values for diffusion). Must match 3rd dimension  
% z.TSL_unit      = 'none';                                                                                                       % % units of TSL or encoding values: [s] seconds; [ms] milliseconds; [us] microseconds; or none
% z.decayRateName = 'ADC';                                                                                                        % % name of decay rate (R1ρ for CESL or ADC for diffusion; shown in plot title)                
% z.xlabel        = 'b-value (s/mm^2)';                                                                                           % % x-axis label (TSL for CESL or b-value for diffusion)                                       
% z.ylabel        = 'DW signal';                                                                                                  % % y-axis label (signal intensity; diffusion often uses DW signal)                            
% xCESL_monoexpfit_showfit(1,z);                                                                                                                                                                                                 
%                                 


function varargout=xCESL_monoexpfit_showfit(showgui,x,pa)

  

% ==============================================
%%   obtain function from outside
% ===============================================

%% =====example call function from outside==========================================
% q=xCESL_monoexpfit_showfit('bla')
% if ischar(showgui) && strcmp(showgui,'bla')
%     halloworld=str2func('halloworld')
%     varargout{1}=halloworld;
%     return
% end


if exist('showgui')==1
    % procmap=xCESL_monoexpfit_showfit('getfun_procmap')
    % ..to obtain % [w]=procmap(a,z)
    if ischar(showgui) && strcmp(showgui,'getfun_procmap')
        ff=str2func('procmap');
        varargout{1}=ff;
        return
    end
    % fromBrukerrawfile=xCESL_monoexpfit_showfit('getfun_fromBrukerrawfile')
    % to get:  o=fromBrukerrawfile(e,e2)
    if ischar(showgui) && strcmp(showgui,'getfun_fromBrukerrawfile')
        ff=str2func('fromBrukerrawfile');
        varargout{1}=ff;
        return
    end
    % =[posthoc set parameter via set]===============
    
    if ischar(showgui) && strcmp(showgui,'set')
        setparams(x);
        return
    end
end



%% ===============================================



isExtPath=0; % external path
if exist('pa')==1 && ~isempty(pa)
    isExtPath=1;
end

%===========================================
%%   PARAMS
%===========================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if isExtPath==0      ;    pa=antcb('getsubjects')  ;end
if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end



%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
%% fileList
if 1
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
end


%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

decayRateName_opt={};
decayRateName_opt(end+1,:)={'for CESL: R1ρ Exponential Relaxation Fit -->[R1rho] '      'R1rho' };
decayRateName_opt(end+1,:)={'for  Diffusion: apparent diffusion coefficient --> [ADC]'   'ADC' };
decayRateName_opt(end+1,:)={'for  Diffusion: apparent diffusion coefficient --> [D]'     'D' };


p={...
    'inf1'      '--- show exponential signal decay fit   ---            '                         '' ''
    'inf2'      ' CESL / R1ρ mapping or Diffusion (ADC) decay fit:', '' ''
    'inf3'      [repmat('_',[1,100])]                            '' ''
    
    'file'              ''            'single CESL / diffusion map (NIfTI)'     {@selector2,li,{'CESL-map'},'out','list','selection','single','position','auto','info','select first CESL-image'}
    'fit_othermaps'     1            'fit also all other maps of this series (if available)'  'b'
    'mask'              ''           '(optional,but prefered):binary brainmask (2D-NIFTI): example "ix_AVGTmask_slice.nii" '   {@selector2,li,{'brain-mask'},'out','list','selection','single','position','auto','info','selectbrain-mask (slice)'}
    'fitmethod'         'nonlinear'  'fitting method: {linear | nonlinear | nonlinear_constant}'   {'linear' 'nonlinear' 'nonlinear_constant'}
    'TSL'               []           'signal encoding values (TSL for CESL or b-values for diffusion). Must match 3rd dimension'   {@fromBrukerrawfile}
    'TSL_unit'    'us'               'units of TSL or encoding values: [s] seconds; [ms] milliseconds; [us] microseconds; or none'  {'s' 'ms' 'us' 'none'}
    
    'inf4' '' '' ''
     'inf5' '__PLOT (decay-rate)___' '' ''
    'decayRateName'  'R1rho'         'name of decay rate (R1ρ for CESL or ADC for diffusion; shown in plot title)'   decayRateName_opt
    'xlabel'     'TSL(s)'            'x-axis label (TSL for CESL or b-value for diffusion)' { 'TSL(s)'  'b-value (s/mm^2)'}
    'ylabel'     'Signal'            'y-axis label (signal intensity; diffusion often uses DW signal)' { 'Signal'  'DW signal'}

    
    
    };


p=paramadd(p,x);%add/replace parameter
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[ 0.2542    0.3200    0.5389    0.3367 ],...
        'title',['***CESL monoexponential fit GUI***' '[' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

% ==============================================
%%   BATCH
% ===============================================
try
    isDesktop=usejava('desktop');
    if isExtPath==0
        xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z);' ]);
    else
        xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z,mdirs);' ],pa);
    end
end
% return
% ==============================================
%%

%% ======[proc]=========================================
% ==============================================
%% loop OVER animals:
% ===============================================

% addit.params
z.isfreeze=0;
z.flipXY =1;
z.flipLR =0;
z.usemask=1;
z.autolog=0; %log positions
z.cmap='gray';
z.dpi =150;  %DPI-screenshots
z.scale=[1 1];


%% ===============================================

z.file=cellstr(z.file);
z.mask=cellstr(z.mask);


makefig(pa,z);
updatefiles();





return


tic1=tic;
for i=1:length(pa)
    [~,animal]=fileparts(pa{i});
    tic2=tic;
    cprintf('[0 0 1]',['[' num2str(i) '/' num2str(length(pa)) '] ' animal '\n']);
    proc_anmal(z,pa{i},i)
    cprintf('[0 0 1]',['..DONE (' animal '). ET:' sprintf('%2.1fmin',toc(tic2)/60)  '\n']);
end
cprintf('*[0 .5 0]',['DONE. ET:' sprintf('%2.1fmin',toc(tic1)/60)  '\n']);


function setparams(x)
drawnow;
x=cell2struct(x(2:2:end),x(1:2:end),2);
%% ===============================================
t={% cmd                   tag                  evoke handle
     'countup'       'capture_rd_counter'        'rd'     
     'addinfo'       'capture_rd_addinfo'        'rd'     
     'autosave'      'capture_rd_auto'           'rd'     
     'animal'        'capture_rd_addanimal'      'rd'     
     'file'          'capture_rd_addfile'        'rd'     
     'showfit'       'switch_image'                  'tb'     
     'fixrange'      'fixrange_rd'               'rd'
     'outdir'        'capture_ed_path'               'ed'
     'cmap'          'set_cmap'                      'pd' %pulldown
     'dpi'            'set_dpi'                      'ed'
     
     'capture'       'capture'                       'pb'
     'loadrois'      'loadrois'                      'pb' 
     'clim'          '-'                             'fun'
     'addroi'        '-'                          'fun'
     'delroi'        '-'                          'fun'
     'showroi'       '-'                          'fun'
     'plotroi'       '-'                          'fun'
     'loadfile'      '-'                          'fun'
     'loadanimal'    '-'                          'fun'
     
     'isfreeze'       '-'                          'u'
     'xlabel'         '-'                          'u'
     'ylabel'         '-'                          'u'
     'flipXY'         '-'                          'u'
     'flipLR'         '-'                          'u'
     'TSL_unit'         '-'                        'u'
     'decayRateName'    '-'                        'u'
     'fitmethod'        '-'                        'u'
    };

if 0
    %% ===============================================
    
    xCESL_monoexpfit_showfit(0,z);
    
    %% ===============================================
    
    xCESL_monoexpfit_showfit('set',{'countup',1,'addinfo',1, 'animal',1,'file',1,'showfit',1,'autosave',1 })
    xCESL_monoexpfit_showfit('set',{'cmap','hot'})
    xCESL_monoexpfit_showfit('set',{'outdir',fullfile(pwd,'pngs1') })
    xCESL_monoexpfit_showfit('set',{'loadrois',fullfile(pwd,'ROI2.txt') })
    
     xCESL_monoexpfit_showfit('set',{'dpi',75})
     xCESL_monoexpfit_showfit('set',{'clim',[10 25],'fixrange',1} )
%      xCESL_monoexpfit_showfit('set',{'clim',[nan nan]} )
%      xCESL_monoexpfit_showfit('set',{'clim',[nan 20]} )
     
%      xCESL_monoexpfit_showfit('set',{'capture',1} )
    
    xCESL_monoexpfit_showfit('set',{'capture',{1 1 'all'} })
    
    %% ===============================================
    cf
    xCESL_monoexpfit_showfit(0,z);
    
    
    xCESL_monoexpfit_showfit('set',{'countup',1,'addinfo',1, 'animal',1,'file',1,'autosave',1 });
    
     xCESL_monoexpfit_showfit('set',{'showfit',0});
    xCESL_monoexpfit_showfit('set',{'cmap','parula'});
    xCESL_monoexpfit_showfit('set',{'dpi',75})
    xCESL_monoexpfit_showfit('set',{'clim',[0 20],'fixrange',1} )
    
    xCESL_monoexpfit_showfit('set',{'outdir',fullfile(pwd,'pngs2') });
    
    xCESL_monoexpfit_showfit('set',{'delroi','all'});
    xCESL_monoexpfit_showfit('set',{'addroi',{'point' [120 130]} });
    xCESL_monoexpfit_showfit('set',{'addroi',{'square' [80 85 85 80 ;100 100 105 105]} });
    xCESL_monoexpfit_showfit('set',{'showroi',[]});
    
    
    xCESL_monoexpfit_showfit('set',{'capture',{1 'all' 'all'} })
    
    
    %% ===============================================
    xCESL_monoexpfit_showfit('set',{'capture',fullfile(pwd,'dum.png')} )
    
    
    xCESL_monoexpfit_showfit('set',{'plotroi',1});
    xCESL_monoexpfit_showfit('set',{'plotroi',2});
    
    %load file from list-box
    xCESL_monoexpfit_showfit('set',{'loadfile',3});
    xCESL_monoexpfit_showfit('set',{'loadfile','c_c_T1rho_2DG__004.nii'});
    
    %load animal
    xCESL_monoexpfit_showfit('set',{'loadanimal',2});
    xCESL_monoexpfit_showfit('set',{'loadanimal','2023117PM_hypothermia_2DG'});


    %specific parameter
    xCESL_monoexpfit_showfit('set',{'xlabel','bla[a.u.]','ylabel','Sig'});
  
    xCESL_monoexpfit_showfit('set',{'decayRateName','D'});

    % flip-xy-dimension: ..data havw to be fitted before taking effect
    xCESL_monoexpfit_showfit('set',{'flipXY',0});
    
    %change fitting-method..data havw to be fitted before taking effect
    xCESL_monoexpfit_showfit('set',{'fitmethod','nonlinear'});

    
    
end


%% ===============================================
hf=findobj(0,'tag','showfit');
fn=fieldnames(x);

for i=1:length(fn)
    ix=find(strcmp(t(:,1),fn{i}));
    if isempty(ix); continue; end
    tag=t{ix,2};
    hb=findobj(hf,'tag',tag);
    ctype=t{ix,3};
    %if strcmp(ctype,'rd') || strcmp(ctype,'tb')  || strcmp(ctype,'ed')
    val=getfield(x, fn{i});
    if strcmp(ctype,'rd') || strcmp(ctype,'tb')
        set(hb,'value',val);
    elseif strcmp(ctype,'ed')
        set(hb,'string',val);
    elseif strcmp(ctype,'pd')
        if ischar(val)
           set(hb, 'value',  find(strcmp(get(hb,'string'),val))   ) ;
        else
           set(hb, 'value',  value   ) ;
        end
    elseif strcmp(ctype,'pb')    
        %pushbutton
    elseif strcmp(ctype,'fun') 
        
        if strcmp(t{ix,1},'clim')
            slider_set(x.clim(1),x.clim(2));
        elseif strcmp(t{ix,1},'addroi')
            addroi(x.addroi);
        elseif strcmp(t{ix,1},'delroi')
            deleteindex_logposition(x.delroi);
        elseif strcmp(t{ix,1},'showroi')
            show_ROIlist(x.showroi);
        elseif strcmp(t{ix,1},'plotroi'  )
            screencapturebylog('showsingle',num2str(x.plotroi))
        elseif strcmp(t{ix,1},'loadfile'  )
            loadfile(x.loadfile);
            elseif strcmp(t{ix,1},'loadanimal'  );
            loadanimal(x.loadanimal)
        end
    elseif strcmp(ctype,'u') 
        u=get(gcf,'userdata');
        u=setfield(u,t{ix,1},  getfield(x,t{ix,1}) );
        set(hf,'userdata',u);
        
        
    end
    cb = get(hb,'callback');
    if ~isempty(cb)
        cb = get(hb,'callback');
        if strcmp(tag,'loadrois')
            hgfeval(cb, hb, [],x.loadrois);
        elseif strcmp(tag,'capture')
            inp=x.capture;
            if length(inp)==1 && isnumeric(inp)
                hgfeval(cb, hb, []);
            elseif length(inp)>4 && ischar(inp) %path to save as png
                v.savefile=inp;
                screencapture(v)
                
            else
               
               animals= inp{1};
               files  = inp{2};
               rois   = inp{3};
               screencature_specific(animals, files, rois);
                
                
            end
        else
            hgfeval(cb, hb, []);
        end
    end
    % end
end

function loadanimal(num)
% xCESL_monoexpfit_showfit('set',{'loadanimal',2});
hf=findobj(0,'tag','showfit');
hb=findobj(gcf,'tag','c_animals');
str=get(hb,'string');
if ischar(num)
    filename=num;
    num=find(strcmp(str,filename)); 
end
if isempty(num); disp('could not load file..file not found..'); return; end
if num>0 && num<=length(str)
    set(hb,'value',num);
    cb = get(hb,'callback');
     hgfeval(cb, hb, []);
    
end




function loadfile(num)
hf=findobj(0,'tag','showfit');
hb=findobj(gcf,'tag','c_files');
str=get(hb,'string');
if ischar(num)
    filename=num;
    num=find(strcmp(str,filename)); 
end
if isempty(num); disp('could not load file..file not found..'); return; end
if num>0 && num<=length(str)
    set(hb,'value',num);
    cb = get(hb,'callback');
     hgfeval(cb, hb, []);
    
end


%% ===============================================
function delroi(x)
hf=findobj(0,'tag','showfit');
u=get(hf,'userdata');
%% ===============================================

function show_ROIlist(mtype)
hf=findobj(0,'tag','showfit');
u=get(hf,'userdata');

if isfield(u,'logposition')==0
    disp(['there is no ROI-list']);
else
    if isempty(mtype) || mtype==1
    disp(['ROI-list']);
    disp(u.logposition);
    else
       uhelp(plog([],[u.logposition],0,'ROIs'),0,'name','ROI-list' ); 
    end
end


function addroi(x)
%% ===============================================
hf=findobj(0,'tag','showfit');
u=get(hf,'userdata');
try
    logpos={};
    if isfield(u,'logposition')==1
        logpos=u.logposition;
    end
    for i=1:2:length(x)
        if strcmp(x{i},'point')
            logpos(end+1,:)={nan x{i} regexprep(num2str(x{i+1}),'\s+',',')  };
        else
            pos=x{i+1}';
            co=[sprintf('%2.1f ',pos(:,1)) ';' sprintf('%2.1f ',pos(:,2))]; %back: str2num(co)'
            logpos(end+1,:)={nan x{i} co  };
        end
    end
    logpos(:,1)=num2cell(1:size(logpos,1));
    
    u.logposition=logpos;
    set(hf,'userdata',u);
    disp(['roi added to ROI-list' ]);
    disp(u.logposition);
end

%% ===============================================





%% ===============================================



function makefig(pa,z)
%% ===============================================

z.pa         =pa;
[~,z.animals]=fileparts2(pa);


fg;
delete(findobj(0,'tag','showfit'));
hf=gcf;
set(hf,'name','showfit','NumberTitle','off','tag','showfit','menubar','none');
set(hf,'units','norm','position',[ 0.0097    0.4200    0.9674    0.4667]);


hb=uicontrol(hf,'style','popupmenu','units','norm','tag','c_animals');
set(hb,'position',[0.0050251 0.94636 0.25 0.047616]);
set(hb,'tooltipstring','animals');
set(hb,'string', z.animals,'fontname','consolas','fontsize',8);
set(hb,'callback',@updatefiles);

hb=uicontrol(hf,'style','listbox','units','norm','tag','c_files');
set(hb,'position',[0 0.5 .1 .45 ]);
set(hb,'tooltipstring','files');
set(hb,'string', 'empty','fontname','consolas','fontsize',8);
set(hb,'callback',@plotter);

% set(hf,'userdata',z)

% ht=uicontrol(hf,'style','text');
% set(ht,'string','R1rho','backgroundcolor','w','fontweight','bold','units','norm');
% set(ht,'position',[0.29075 0.010714 0.043071 0.047616]);

% set(ht,'hittest','off');

ht=uicontrol(hf,'style','radio');
set(ht,'string','roi','backgroundcolor','w','fontweight','bold','units','norm','tag','roi');
set(ht,'callback',@roitool)

ht=uicontrol(hf,'style','togglebutton');
set(ht,'string','show fitted image','backgroundcolor','w','fontweight','bold','units','norm','tag','switch_image');
set(ht,'position',[0.013662 0.10594 0.061 0.047616],'fontsize',8)
set(ht,'callback',@switch_image,'value',1);



ht=uicontrol(hf,'style','popupmenu');
str={'userdefined'  'square-2' 'square-3' 'square-4' 'square-5' 'square-6' 'square-7'...
    'square-8' 'square-9' 'square-10' 'square-12' 'square-15' 'square-20' ...
    'rectangle [1,2]' 'rectangle [1,3]' 'rectangle [2,1]' 'rectangle [3,1]' ...
    'circle-2' 'circle-3' 'circle-4' 'circle-5' 'circle-6' 'circle-7'...
    'circle-8' 'circle-9' 'circle-10'
    
    
    };
set(ht,'string',str,'value',1,'backgroundcolor','w','fontweight','bold','units','norm','tag','roi_defined');
set(ht,'position',[0.043812 0.041664 0.07 0.047616])
set(ht,'callback',@roitool_defined)


% ==============[screenshot]=================================

hb=uicontrol(hf,'style','pushbutton', 'string','screencapture','units','norm');
set(hb,'position',[0.18451 0.35355 0.05 0.0476])
set(hb,'tag','capture')
set(hb,'callback',@screencapture);

hb=uicontrol(hf,'style','edit', 'string',pwd,'units','norm');
set(hb,'position',[0.0021765 0.4083 0.24 0.035],'fontsize',8);
set(hb,'tag','capture_ed_path','HorizontalAlignment','left');
set(hb,'tooltipstring','path to save screenshots');
set(hb,'callback',@ed_path);

hb=uicontrol(hf,'style','edit', 'string','fit','units','norm');
set(hb,'position',[0.0021765 0.37021 0.03 0.035],'fontsize',8);
set(hb,'tag','capture_ed_prefix','HorizontalAlignment','left');
set(hb,'tooltipstring','prefix of screenshots');

hb=uicontrol(hf,'style','radio', 'string','count up','units','norm');
set(hb,'position',[0.039505 0.36545 0.045 0.035],'fontsize',8);
set(hb,'tag','capture_rd_counter','value',1);
set(hb,'tooltipstring','screenshots: automatically count up number in filename');
set(hb,'BackgroundColor','w');

hb=uicontrol(hf,'style','radio', 'string','add info','units','norm');
set(hb,'position',[0.085447 0.36545 0.045 0.035],'fontsize',8);
set(hb,'tag','capture_rd_addinfo','value',1);
set(hb,'tooltipstring','screenshots:add location info in filename');
set(hb,'BackgroundColor','w');

hb=uicontrol(hf,'style','radio', 'string','autosave','units','norm');
set(hb,'position',[0.13139 0.36545 0.045 0.035],'fontsize',8);
set(hb,'tag','capture_rd_auto','value',0);
set(hb,'tooltipstring','screenshots:autosave image without GUI');
set(hb,'BackgroundColor','w');


hb=uicontrol(hf,'style','radio', 'string','animal','units','norm');
set(hb,'position',[0.039505 0.32498 0.045 0.035],'fontsize',8);
set(hb,'tag','capture_rd_addanimal','value',0);
set(hb,'tooltipstring','screenshots:add animal-name to filename');
set(hb,'BackgroundColor','w');

hb=uicontrol(hf,'style','radio', 'string','file','units','norm');
set(hb,'position',[0.085447 0.32736 0.045 0.035],'fontsize',8);
set(hb,'tag','capture_rd_addfile','value',0);
set(hb,'tooltipstring','screenshots:add input filename to filename');
set(hb,'BackgroundColor','w');


hb=uicontrol(hf,'style','pushbutton', 'string','load ROIs','units','norm');
set(hb,'position',[0.0021765 0.27498 0.045 0.035],'fontsize',8);
set(hb,'tag','loadrois','callback',@loadrois);
set(hb,'tooltipstring','load rois');
set(hb,'BackgroundColor','w');

hb=uicontrol(hf,'style','pushbutton', 'string','save ROIs','units','norm');
set(hb,'position',[0.0021765 0.23689 0.045 0.035],'fontsize',8);
set(hb,'tag','saverois','callback',@saverois);
set(hb,'tooltipstring','save rois');
set(hb,'BackgroundColor','w');


hb=uicontrol(hf,'style','edit', 'string',num2str(z.dpi),'units','norm');   %DPI
set(hb,'position',[0.13211 0.3226 0.03 0.035],'fontsize',8);
set(hb,'tag','set_dpi','HorizontalAlignment','left');
set(hb,'tooltipstring','DPI of screenshots');
set(hb,'callback',@set_dpi);

cmaps = {'parula','gray', 'jet' , 'hot' , 'turbo','hsv','cool','spring','summer', ...
    'autumn','winter','bone','copper','pink', ...
    'lines','colorcube','prism','flag','white'};

hb=uicontrol(hf,'style','popupmenu', 'string',cmaps,'value',find(strcmp(cmaps,z.cmap)),'units','norm');   %DPI
set(hb,'position',[0.18882 0.46544 0.04 0.035],'fontsize',8);
set(hb,'tag','set_cmap','HorizontalAlignment','left');
set(hb,'tooltipstring','colormap');
set(hb,'callback',@set_cmap);


hb=uicontrol(hf,'style','pushbutton', 'string','shortcuts','units','norm');
set(hb,'position',[0.0014587 0.0035712 0.045 0.035],'fontsize',8);
set(hb,'tag','show_shortcuts','callback',@show_shortcuts);
set(hb,'tooltipstring','show shortcuts');
set(hb,'BackgroundColor','w');

hb=uicontrol(hf,'style','pushbutton', 'string','help','units','norm');
set(hb,'position',[0.048119 0.004048 0.03 0.035],'fontsize',8);
set(hb,'tag','help','callback',@helper);
set(hb,'tooltipstring','show help');
set(hb,'BackgroundColor','w');


%% ===============================================

jRangeSlider = com.jidesoft.swing.RangeSlider(0,1000,0,1000);  % min,max,low,high
[jRangeSlider, hContainer]  = javacomponent(jRangeSlider, [100,80,200,40], gcf);
set(jRangeSlider, 'MajorTickSpacing',500, 'MinorTickSpacing',0, 'PaintTicks',true,...
    'PaintLabels',true, ...
    'Background',java.awt.Color.white, 'StateChangedCallback',@slider_cb);

% % remove arrow key bindings
% im = jRangeSlider.getInputMap(javax.swing.JComponent.WHEN_FOCUSED);
% im.put(javax.swing.KeyStroke.getKeyStroke('LEFT'),  []);
% im.put(javax.swing.KeyStroke.getKeyStroke('RIGHT'), []);
% im.put(javax.swing.KeyStroke.getKeyStroke('UP'),    []);
% im.put(javax.swing.KeyStroke.getKeyStroke('DOWN'),  []);
%



z.jslid =jRangeSlider;
z.hslid =hContainer;

% set(hContainer,'visible','off')

hb=uicontrol(hf,'style','radio', 'string','fix range','units','norm');
set(hb,'position',[0.19169 0.14642 0.045 0.035],'fontsize',8);
set(hb,'tag','fixrange_rd','value',0);
set(hb,'tooltipstring','fix dynamic range of map');
set(hb,'BackgroundColor','w');

set(hb,'callback',@fix_range_cb);

%% ===============================================
set(hf,'userdata',z)
set(hf,'WindowKeyPressFcn',@keys)
% set(hf,'KeyPressFcn',@keys)


function helper(e,e2)

uhelp([mfilename '.m']) ;

function show_shortcuts(e,e2)
shortcuts();




function fix_range_cb(e,e2)
%% ===============================================

hf=findobj(0,'tag','showfit');
hb=findobj(hf,'tag','fixrange_rd');
ax2=findobj(hf,'tag','ax2');
himg=findobj(ax2,'type','image');

% u=get(gcf,'userdata');
% % u.range=[[min(himg.CData(:)) max(himg.CData(:))]];
% % u.range=caxis(ax2);
% % u.sliderval=[u.jslid.getLowValue u.jslid.getHighValue];
% set(hf,'userdata',u);



%% ===============================================



function ed_path(e,e2)

% pause(0.1);
hf=findobj(0,'tag','showfit');
ax3=findobj(hf,'tag','ax3');
setfocus(ax3);



function set_cmap(e,e2)
hf=findobj(0,'tag','showfit');
hb=findobj(hf,'tag','set_cmap');
u=get(hf,'userdata');
u.cmap=hb.String{hb.Value};
disp([' ..new cmap: ' u.cmap ]);
set(hf,'userdata',u);

ax2=findobj(hf,'tag','ax2');
try
    eval(['cmap=' u.cmap ';']);
    colormap(ax2,cmap);
catch
    colormap(ax2,parula);
end


function set_dpi(e,e2)
hf=findobj(0,'tag','showfit');
hb=findobj(hf,'tag','set_dpi');
u=get(hf,'userdata');
u.dpi=str2num(get(hb,'string'));
% disp([' ..new DPI: ' num2str(u.dpi) ]);
set(hf,'userdata',u);


function saverois(e,e2)
hf=findobj(0,'tag','showfit');
u=get(hf,'userdata');
if isfield(u,'logposition')==0
    disp('no ROI-list created..abort'); return
end
% [fi pa]=uiputfile(fullfile(pwd,'ROI.mat'),'set ROI-file (*.mat)');
% [fi pa]=uiputfile(fullfile(pwd,'ROI.txt'),'set ROI-file (*.txt)');

[fi, pa, idx] = uiputfile( {'*.txt','Text file (*.txt)'; '*.mat','MAT-file (*.mat)'}, ...
    'Save ROI file', ...
    fullfile(pwd,'ROI.txt'));
if isnumeric(fi); disp('abort'); return; end
file=fullfile(pa,fi);
pos=u.logposition;
switch idx
    case 1 %txt
        o=plog([],pos(:,2:end),0,'w','s=0,plotlines=0,al=1,style=2');
        pwrite2file(file,o );
    case 2 %mat
        save(file,'pos');
end
showinfo2(' saved ROIfile',file);



function loadrois(e,e2, file )
hf=findobj(0,'tag','showfit');
u=get(hf,'userdata');
if exist('file')~=1
    % [fi pa]=uigetfile(fullfile(pwd,'*.mat'),'get ROI-file (*.mat)');
    % [fi pa]=uigetfile(fullfile(pwd,'*.txt'),'get ROI-file (*.mat)');
    [fi, pa] = uigetfile( ...
        {'*.txt','Text files (*.txt)'; '*.mat','MAT-files (*.mat)'}, ...
        'Load ROI file');
    if isnumeric(fi); disp('abort'); return; end
    file=fullfile(pa,fi);
end


[~,~,ext]=fileparts(file);
if strcmp(ext,'.mat')
    q=load(file);
    pos=[ num2cell([1:size(q.pos,1)]') q.pos(:,2:end)]
    u.logposition=pos;
else
    q=preadfile(file); q=q.all;
    pos={};
    for i=1:size(q,1)
        s=strtrim(q{i});
        tok = regexp(s, '^(\S+)\s+(.*)$', 'tokens', 'once');
        name = tok{1};
        loc  = tok{2};
        pos(i,:)={i name loc};
    end
    u.logposition=pos;
end


try
    set(hf,'userdata',u);
    disp('ROI-list loaded');
    disp( u.logposition);
catch
    disp('no ROI-list loaded..error ...');
end




%% ===============================================
function screencapture(e,e2, p)

hf=findobj(0,'tag','showfit');
prefix =get(findobj(hf,'tag','capture_ed_prefix'),'string');
spath  =get(findobj(hf,'tag','capture_ed_path'),'string');

isauto      =get(findobj(hf,'tag','capture_rd_auto'),'value');
isaddifo    =get(findobj(hf,'tag','capture_rd_addinfo'),'value');
iscounterup =get(findobj(hf,'tag','capture_rd_counter'),'value');

isanimaladd =get(findobj(hf,'tag','capture_rd_addanimal'),'value');
isfileadd =get(findobj(hf,'tag','capture_rd_addfile'),'value');

hroi=findobj(hf,'tag','roi_defined');





%% ===============================================
addinfo='';
if isaddifo==1
    %hd=findobj(hf,'tag','dot')
    ax3=findobj(hf,'tag','ax3');
    tok = regexp(ax3.Title.String, '\[([^\]]*)\]\s*$', 'tokens');
    
    if ~isempty(strfind(char(tok{1}),'nvox'))
        ax2=findobj(hf,'tag','ax2');
        h = findobj(ax2, 'Type', 'images.roi.Polygon');
        pos=get(h,'position');
        me=round(mean(get(h,'position')));
        info1=sprintf('mean[%d,%d],np[%d]',round(mean(pos)), size(pos,1));
        addinfo=['_' hroi.String{hroi.Value} '_'  info1 ];
    else
        addinfo=['_point_' char(tok{1})];
    end
end
%% ======counter=========================================
counter=pnum(1,4);
if iscounterup==1
    %     fis=spm_select('List',spath,['^' prefix  '.*.png$' ]);
    fis=spm_select('List',spath,['^' prefix  '\d+.*.png$' ]);
    if ~isempty(fis)
        fis=cellstr(natsort(fis));
        %num = str2double(regexp(fis{end}, [ prefix '(\d+)'], 'tokens', 'once'));
        num =str2double(regexp(fis{end},[ prefix '?(\d+)'], 'tokens', 'once'));
        counter=pnum(num+1,4);
    end
end
if isempty(char(counter))
    counter=pnum(1,4);
end
if iscounterup==0
    counter='';
end


%% ======[filename]=========================================
ha=findobj(hf,'tag','c_animals');
hfi=findobj(hf,'tag','c_files');

animal='';
img   ='';
if isanimaladd==1
    animal=['_' ha.String{ha.Value}];
end
if isfileadd==1
    img=['_[' hfi.String{hfi.Value} ']'];
end

%  fileshort=[ prefix  counter  addinfo '.png'];

if exist('p') && isstruct(p) && isfield(p,'roiNumber')
    fileshort=[ prefix  counter  ['[ROI'  pnum(p.roiNumber,3) ']']   animal  img   addinfo '.png'];
else
    
    fileshort=[ prefix  counter   animal  img   addinfo '.png'];
end

%% =========[override using defined path]======================================
% xCESL_monoexpfit_showfit('set',{'capture',fullfile(pwd,'dum.png')} )
if exist('e')==1 && isfield(e,'savefile')
    [spath,fileshort ext]=fileparts(e.savefile);
    if isempty(ext); ext='.png'; end
    fileshort =[fileshort ext];
end


%% ===============================================
if isauto==0
    [file pa]=uiputfile(fullfile(spath,fileshort),'save screenshot');
    if isnumeric(file); return; end
    fo1=fullfile(pa,file);
    spath=pa;
else
    fo1=fullfile(spath,fileshort);
end

if exist(spath)~=7; mkdir(spath); end

set(findobj(hf,'tag','capture_ed_path'),'string',spath);

hf=findobj(0,'tag','showfit');
u=get(hf,'userdata');
exportgraphics(hf,fo1,'Resolution',u.dpi);
showinfo2('saved png',fo1)




function imageClicked(e,e2)
hf=findobj(0,'tag','showfit');
isRoi=get(findobj(hf,'tag','roi'),'value');
if isRoi==0
    %     disp('freeze image')
    u=get(hf,'userdata');
    u.isfreeze=1-u.isfreeze;
    set(hf,'userdata',u);
    
end

function screencapturebylog(task,num)
% num: as char '1' or '1,2,4' -->than specific rois
% num as numeric [-1,1] to file rhrough rois
%% ===============================================


hf=findobj(0,'tag','showfit');
u=get(hf,'userdata');
if isfield(u,'logposition')==0;
    disp('no ROI-list found ..create first');
    return;
end
l=u.logposition;
% disp('log-positions');
% disp(l);
u.isfreeze=0;
u.autolog=1;
set(hf,'userdata',u);

if exist('num')~=1
    vec=1:size(l,1); %specific roi
else
    if ischar(num)
        vec=str2num(num);
    else
        if isfield(u,'currentROI')==0
            u.currentROI=0
            set(hf,'userdata',u);
        end
        vec=u.currentROI+num;
        if vec>size(l,1); vec=size(l,1); disp('last ROI'); end
        if vec<1; vec=1; disp('first ROI'); end
        u.currentROI=vec;
        set(hf,'userdata',u);
    end
end

for i=vec
    disp(['ROI-' num2str(l{i,1} )  [': ' l{i,2} ' ' l{i,3}]]);
    if strcmp(l{i,2},'point')
        set(findobj(hf,'tag','roi'),'value',0)
        drawnow;
        roitool([],[]);
        hd=findobj(hf,'tag','dot');
        xy=str2num(l{i,3});
        hd.XData=xy(2);
        hd.YData=xy(1);
        
        ax=findobj(hf,'tag','ax2');
        ax3=findobj(hf,'tag','ax3');
        us=get(ax,'userdata');
        try; delete(us.hpoly); end
        
        %     himg=findobj(ax,'type','image')
        %     set(hf,'WindowButtonMotionFcn',{@motion,us.hImg,us.a,us.w,ax3,[]});
        %     function motion(src,~,hImg,a,w,ax3,mask)
        motion([],[],us.hImg,us.a,us.w,ax3,[]);
    else
        hb=findobj(hf,'tag','roi_defined');
        iv=find(strcmp(hb.String,l{i,2}));
        if isempty(iv)
            iv=find(strcmp(hb.String,'square-8'));
        end
        
        if  strcmp(l{i,2},'userdefined');
            set(hb,'value',2);
        else
            set(hb,'value',iv);
        end
        roitool_defined([],[],1);
        ax2=findobj(hf,'tag','ax2');
        h = findobj(ax2, 'Type', 'images.roi.Polygon');
        set(h,'position',str2num(l{i,3})','visible','on');
        set(hb,'value',iv)
        
        ax=findobj(hf,'tag','ax2');
        ax3=findobj(hf,'tag','ax3');
        us=get(ax,'userdata');
        img = findobj(ax,'Type','Image');
        pos=get(h,'position');
        
        bw = poly2mask(pos(:,1), pos(:,2), size(img.CData,1), size(img.CData,2));
        ax=findobj(hf,'tag','ax2');
        motion([],[],us.hImg,us.a,us.w,ax3,bw);
    end
    
    drawnow;
    if strcmp(task,'save')
        
        p.roiNumber=i;
        screencapture([],[],p);
    elseif strcmp(task,'show')
        disp('pause...hit enter to go to next ROI');
        %         pause;
        %         disp('Press a key in the figure');
        waitforbuttonpress
        disp('Continue');
    elseif strcmp(task,'showsingle')
        
        
    end
    
end

u=get(hf,'userdata');
u.autolog=0;
set(hf,'userdata',u);


%% ===============================================





function deleteindex_logposition(delindex)
%% ===============================================

hf=findobj(0,'tag','showfit');
u=get(hf,'userdata');

if isfield(u,'logposition')==0
    disp('there is no ROIS defined');
    return
end

if exist('delindex')~=1
    disp('ROI-list');
    disp(u.logposition);
    s=input('delete ROI-index from list: ','s');
    if isempty(s);
        disp('abort..no rois deleted');
        return;
    end
else
    s=delindex;
end


if strcmp(s,'all') 
   s='1:end'; 
end

eval(['u.logposition([' s '],:)=[];']);
disp(['removed items: ' s ]);
u.logposition(:,1)=num2cell([1:size(u.logposition,1)]);

if isempty(u.logposition)
    try; u=rmfield(u,'logposition'); end
    disp(['** deleted ROI-list**']); 
else
   disp(['** updated ROI-list**']); 
    disp([u.logposition]);
end
set(hf,'userdata',u);
%% ===============================================
function shortcuts()
sk={
    '[a] add ROI to ROI-list' 
    '     -for points/voxels: hover coursor to voxel, than hit [a])'
    '     -for ROIs: first create and position ROI, than hit [a])'
    '[d] delete ROI(s) from ROI-list '
    '     -evokes a comand-line input:  enter indices of ROIs to delete from ROI-list'
    '[l] list all ROIs in comand window'
    ''
    '[s] make screenshot for each ROI for this image'
    '[i] make screenshot for each ROI and all images'
    '[o] make specific screenshot over animals,files, ROIs'
    '     -evokes comand-line inputs for animals/files/ROIs:  enter repsective indices here '
    '[leftarrow/rightarrow]  show fit for each ROI from ROI-list interactively'
    ''
    '[k] show shortcuts'
    };
disp('** SHORTCUTS **');
disp(char(sk));


%     '[p] show ROIs in '




function keys(src,event)
% disp(event.Key)
hf=findobj(0,'tag','showfit');
u=get(hf,'userdata');

%  obj = hittest(hf)
% if strcmp(get(ancestor(obj,'axes'),'tag'),'ax2')~=1
%     return
% end

focusObj = get(hf,'CurrentObject');
try
    if strcmp(get(focusObj,'Style'),'edit')
        return   % ignore shortcuts while typing
    end
end


switch event.Key
    %     case 'space'
    % %         disp('freeze image')
    %         u.isfreeze=1-u.isfreeze;
    %         set(hf,'userdata',u);
    case 'k' %show rois
        shortcuts();
        
    case 'l' %show rois
        if isfield(u,'logposition')==0
            disp('no ROI-list defined');
            return
        end
        disp('ROI-LIST');
        disp(u.logposition);
        
    case 'i' %run over images
        screencature_overimages
    case 'a' %log
        logposition();
    case 'd' %log
        deleteindex_logposition();
    case 'p' %log
        screencapturebylog('show');
    case 'o'
        screencature_specific()
        
        
    case 's' %log
        screencapturebylog('save');
    case 'rightarrow'
        screencapturebylog('showsingle',1);
    case 'leftarrow'
        screencapturebylog('showsingle',-1);
        
        
        
        %     case 'leftarrow'
        %         disp('left')
        %     case 'escape'
        %         disp('ESC')
end


function screencature_overimages

hf=findobj(0,'tag','showfit');
hfi=findobj(hf,'tag','c_files');

for i=1:length(hfi.String)
    set(hfi,'value',i)
    plotter([],[]); drawnow
    screencapturebylog('save');
end


function screencature_specific(animals, files, rois)
%% ===============================================
drawnow;



hf=findobj(0,'tag','showfit');
u=get(hf,'userdata');
hfi=findobj(hf,'tag','c_files');
han=findobj(hf,'tag','c_animals');


vhan=length(get(han,'string'));
vfi=length(get(hfi,'string'));

if exist('animals')~=1
    disp('=======[ SCREENSHOTS ]=======================================');
    disp([ num2cell([1:length(han.String)]') han.String]);
    s1=input(['[1] from which animals (numeric, or ''all''): '],'s');
else
    s1=num2str(animals);
end
if exist('files')~=1
    disp([ num2cell([1:length(hfi.String)]') hfi.String]);
    s2=input(['[2] from which files (numeric, or ''all''): '],'s');
else
    s2=num2str(files);
end
if exist('rois')~=1
    disp([ u.logposition]);
    s3=input(['[3]  which ROIs (numeric, or ''all''): '],'s');
 else
    s3=num2str(rois);
end   

% s1='all';
% s2='1 2';
% s3='1,2,3';



if ischar(s1) && ~isempty(strfind(s1,'all'));
    vhan=[1:length(han.String)];
else
    vhan=[str2num(s1)];
end
if ischar(s2) && ~isempty(strfind(s2,'all'))
    vfi=[1:length(hfi.String)]  ;
else
    vfi=[str2num(s2)];
end
if ischar(s3) && ~isempty(strfind(s3,'all'))
    vroi=[1:size(u.logposition,1)];
else
    vroi=[str2num(s3)];
end
%% ===============================================
for k=vhan
    han.Value=k;
    for j=vfi
        hfi.Value=j;
        plotter([],[]); drawnow
        for i=vroi
            screencapturebylog('save',num2str(i));
        end
    end
end

%% ===============================================






%% ===============================================




function logposition(e,e2)
%% ===============================================

hf=findobj(0,'tag','showfit');
u=get(hf,'userdata');

if isfield(u,'logposition')==0
    u.logposition={};
end

num=size(u.logposition,1)+1;


%hd=findobj(hf,'tag','dot')
ax3=findobj(hf,'tag','ax3');
tok = regexp(ax3.Title.String, '\[([^\]]*)\]\s*$', 'tokens');

l={};
if ~isempty(strfind(char(tok{1}),'nvox'))
    ax2=findobj(hf,'tag','ax2');
    h = findobj(ax2, 'Type', 'images.roi.Polygon');
    pos=get(h,'position');
    %     me=round(mean(get(h,'position')));
    %     info1=sprintf('mean[%d,%d],np[%d]',round(mean(pos)), size(pos,1));
    co=[sprintf('%2.1f ',pos(:,1)) ';' sprintf('%2.1f ',pos(:,2))]; %back: str2num(co)'
    
    hr=findobj(hf,'tag','roi_defined');
    roitype=hr.String{hr.Value};
    l={num roitype,  co};
    
    
else
    %     addinfo=['_point_' char(tok{1})];
    l={num 'point',  char(tok{1}) };
end
u.logposition=[u.logposition; l];

set(hf,'userdata',u);
disp('ROI-list')
disp(u.logposition);



%% ===============================================



function roitool_defined(e,e2,ishidden)

hf=findobj(0,'tag','showfit');
hb=findobj(hf,'tag','roi');
set(hb,'value',1);
ax2=findobj(hf,'tag','ax2');
ha=findobj(hf,'tag','roi_defined');
if isempty(ha.Value)
    str='square-6';
else
    str=ha.String{ha.Value};
end

if exist('ishidden')==1 && ishidden==1
    %       val=str2num(strrep(str,'square-',''));
    L  = 4;   % side length in voxels/pixels
    x0=ceil(ax2.XLim(1))+diff(ax2.XLim)/2;
    y0=ceil(ax2.YLim(1))+diff(ax2.YLim)/2;
    
    x = [x0 x0+L x0+L x0]';% polygon coordinates (closed square)
    y = [y0 y0 y0+L y0+L]';
    xy=[x y];
    roitool([],[],xy,ishidden)
    
    return
end



if strcmp(str,'userdefined')
    roitool([],[]);
elseif ~isempty(strfind(str,'square'))
    val=str2num(strrep(str,'square-',''));
    L  = val;   % side length in voxels/pixels
    
    %     x0 = 50;   % upper-left x
    %     y0 = 50;   % upper-left y
    x0=ceil(ax2.XLim(1))+diff(ax2.XLim)/2;
    y0=ceil(ax2.YLim(1))+diff(ax2.YLim)/2;
    
    x = [x0 x0+L x0+L x0]';% polygon coordinates (closed square)
    y = [y0 y0 y0+L y0+L]';
    xy=[x y];
    roitool([],[],xy)
    
elseif ~isempty(strfind(str,'rectangle'))
    vals=str2num(strrep(str,'rectangle',''));
    L  = vals;   % side length in voxels/pixels
    
    %     x0 = 50;   % upper-left x
    %     y0 = 50;   % upper-left y
    x0=ceil(ax2.XLim(1))+diff(ax2.XLim)/2;
    y0=ceil(ax2.YLim(1))+diff(ax2.YLim)/2;
    
    x = [x0 x0+L(1) x0+L(1) x0]';% polygon coordinates (closed square)
    y = [y0 y0 y0+L(2) y0+L(2)]';
    xy=[x y];
    roitool([],[],xy)
    
    
elseif ~isempty(strfind(str,'circle'))
    val=str2num(strrep(str,'circle-',''));
    x0=ceil(ax2.XLim(1))+diff(ax2.XLim)/2;
    y0=ceil(ax2.YLim(1))+diff(ax2.YLim)/2;
    
    theta = linspace(0,2*pi,val*4 );   % number of polygon points
    r  = val;
    cx = x0;
    cy = y0;
    
    x = [cx + r*cos(theta)]';
    y = [cy + r*sin(theta)]';
    xy=[x y];
    roitool([],[],xy)
    
end



function ds=halloworld(d,d2)
ds=d+d2



function roitool(e,e2,xy,ishidden)
hf=findobj(0,'tag','showfit');
hb=findobj(hf,'tag','roi');
if get(hb,'value')==1
    set(hf,'WindowButtonMotionFcn',[]);
    ha=findobj(hf,'tag','ax2');
    ch=get(ha,'children');
    axes(ha);
    delete(findobj(ha,'Type','images.roi.polygon'))
    
    ax = ha;  % your axes
    if exist('xy')==0
        h = drawpolygon(ax,'FaceAlpha',0.1);
    else
        if exist('ishidden')==1 && ishidden==1
            h = drawpolygon(ax,'FaceAlpha',0.1,'Position',[xy(:,1) xy(:,2)],'visible','off');
        else
            h = drawpolygon(ax,'FaceAlpha',0.1,'Position',[xy(:,1) xy(:,2)]);
        end
    end
    % keep view fixed if needed
    xlims = xlim(ax);
    ylims = ylim(ax);
    % callback function
    updateFcn = @(src,evt) myFunction(src, evt);
    % trigger when moved / edited
    addlistener(h,'ROIMoved',updateFcn);
    ax=findobj(hf,'tag','ax2');
    us=get(ax,'userdata');
    
    
    us.hpoly=h;
    set(ax,'userdata',us);
    
    try
        myFunction(h, [])  ;
    end
    
    
    
else
    ax=findobj(hf,'tag','ax2');
    us=get(ax,'userdata');
    ax3=findobj(hf,'tag','ax3');
    ax=findobj(hf,'tag','ax2');
    us=get(ax,'userdata');
    try; delete(us.hpoly); end
    
    hd=findobj(hf,'tag','dot');
    if isempty(hd)
        
        hdot = line(ax,...
            NaN,NaN,...
            'Marker','.',...
            'MarkerSize',10,...
            'LineStyle','none',...
            'Color','r','tag','dot','HitTest','off','PickableParts','none','hittest','off');
        
    end
    
    
    set(hf,'WindowButtonMotionFcn',{@motion,us.hImg,us.a,us.w,ax3,[]});
end

u=get(hf,'userdata');
u.isfreeze=0;
set(hf,'userdata',u);




function myFunction(src, evt)
pos = src.Position; % current polygon position
%disp('Polygon moved or modified');
ax = src.Parent;
img = findobj(ax,'Type','Image');

if ~isempty(img)
    bw = poly2mask(pos(:,1), pos(:,2), size(img.CData,1), size(img.CData,2));
    hf=findobj(0,'tag','showfit');
    ax=findobj(hf,'tag','ax2');
    
    us=get(ax,'userdata');
    ax3=findobj(hf,'tag','ax3');
    motion([],[],us.hImg,us.a,us.w,ax3,bw);
    
    
    % do something with bw here
end



function roypoly_recreate
hf=findobj(0,'tag','showfit');
ax=findobj(hf,'tag','ax2');
us=get(ax,'userdata');
if isfield(us,'hpoly')
    % old polygon handle
    hOld = us.hpoly;
    % store properties BEFORE deleting
    pos        = hOld.Position;
    color      = hOld.Color;
    lineWidth  = hOld.LineWidth;
    faceAlpha  = hOld.FaceAlpha;
    visible    = hOld.Visible;
    % delete old polygon
    delete(hOld)
    % recreate polygon on new image/axes
    hNew = drawpolygon(ax, ...
        'Position',  pos, ...
        'Color',     color, ...
        'LineWidth', lineWidth, ...
        'FaceAlpha', faceAlpha, ...
        'Visible',   visible);
    % store new handle
    us.hpoly = hNew;
    set(ax,'userdata',us);
end


function px=roypoly_getparameter
hf=findobj(0,'tag','showfit');
ax=findobj(hf,'tag','ax2');
us=get(ax,'userdata');
px=[];
if isfield(us,'hpoly') && isvalid(us.hpoly)==1
    %px = us.hpoly;    % old polygon handle
    %     % store properties BEFORE deleting
    px.pos        = us.hpoly.Position;
    px.color      = us.hpoly.Color;
    px.lineWidth  = us.hpoly.LineWidth;
    px.faceAlpha  = us.hpoly.FaceAlpha;
    px.visible    = us.hpoly.Visible;
    %     % delete old polygon
    %     delete(hOld)
    %     % recreate polygon on new image/axes
    %     hNew = drawpolygon(ax, ...
    %         'Position',  pos, ...
    %         'Color',     color, ...
    %         'LineWidth', lineWidth, ...
    %         'FaceAlpha', faceAlpha, ...
    %         'Visible',   visible);
    %     % store new handle
    %     us.hpoly = hNew;
    %     set(ax,'userdata',us);
end

function roypoly_setparameter(px)
hf=findobj(0,'tag','showfit');
if get(findobj(hf,'tag','roi'),'value')==0 || isempty(px) %ROI-radio is OFF
    return
end


ax=findobj(hf,'tag','ax2');
us=get(ax,'userdata');
h = drawpolygon(ax, ...
    'Position',  px.pos, ...
    'Color',     px.color, ...
    'LineWidth', px.lineWidth, ...
    'FaceAlpha', px.faceAlpha, ...
    'Visible',   px.visible);
% store new handle
us.hpoly = h;
set(ax,'userdata',us);



% set(hf,'WindowButtonMotionFcn',[]);
% ha=findobj(hf,'tag','ax2');
% ch=get(ha,'children');
% axes(ha);
%
% ax = ha;  % your axes
% h = drawpolygon(ax,'FaceAlpha',0.1);
% % keep view fixed if needed
% xlims = xlim(ax);
% ylims = ylim(ax);
% callback function
updateFcn = @(src,evt) myFunction(src, evt);
% trigger when moved / edited
addlistener(h,'ROIMoved',updateFcn);
% ax=findobj(hf,'tag','ax2');
% us=get(ax,'userdata');
% us.hpoly=h;
% set(ax,'userdata',us);

function switch_image(e,e2)
% plotter()
%% ===============================================

% hf=findobj(0,'tag','showfit');
% ax2=findobj(hf,'tag','ax2')
% u=get(ax2,'userdata')
%
% hx=findobj(hf,'tag', 'switch_image');
% axes(ax2)
% if hx.Value==1
%     hImg =imagesc(u.w.R1rho(:,:,1));
% else
%     hImg =imagesc(u.a(:,:,1));
% end

hf=findobj(0,'tag','showfit');
hr=findobj(hf,'tag','fixrange_rd');
set(hr,'value',0);

plotter(e,e2,'replot')



%% ===============================================



function plotter(e,e2,replot)

%% ===============================================
hf=findobj(0,'tag','showfit');
try;
    delete(findobj(hf,'tag','ax3'));
end

z=get(hf,'userdata');

fitmethod = z.fitmethod;% 'nonlinear';% OPTIONS: 'linear'  'nonlinear'
hb=findobj(hf,'tag','c_animals');
ha=findobj(hf,'tag','c_files');
animal=hb.String{hb.Value};
pam=z.pa{find(strcmp(z.animals,animal))};
file=ha.String{ha.Value};

f1=fullfile(pam, file);
[ha a]=rgetnii(f1);  % [220 220 13]

%% using mask
u=get(hf,'userdata');

ismask_ok=0;
if ~isempty(regexpi2({char(z.mask)},'=|<|>')) % using threshold
    try
    eval([  'm=a(:,:,1)' char(z.mask) ';'])
     a=a.*double(repmat(m,[1 1 size(a,3)]));
     ismask_ok=1;
    end 
else
    fm=fullfile(pam, char(z.mask));
    if u.usemask==1 && ~isempty(char(z.mask)) && exist(fm)==2
        [hm m]=rgetnii(fm);  % [220 220 1]
        a=a.*repmat(m,[1 1 size(a,3)]);
        ismask_ok=1;
    end
end


if u.flipXY ==1;    a=permute(a,[2 1 3]);  end
if u.flipLR ==1;    a=flipdim(a,[2]);      end

if u.usemask==1 && ~isempty(char(z.mask)) && ismask_ok==1
    if u.flipXY ==1;    m=permute(m,[2 1 3]);  end
    if u.flipLR ==1;    m=flipdim(m,[2]);      end
end

try; delete(findobj(hf,'tag','ax1')); end
hax=axes;
set(hax,'position',[0.013662 0.51306 0.3 0.4],'tag','ax1');
ax1=gca;
axes(ax1);
imagesc(a(:,:,1)); axis image;
set(gca,'tag','ax1');
cb=colorbar;
set(cb,'position',[0.225    0.5131    0.005    0.2000]);
axis off
title(['input image [' num2str(size(a)) ']'],'fontsize',8);
% set(gca,'hittest','off');

%% ===============================================
px=roypoly_getparameter;

if exist('replot')==1
    ub=[];
    try
        ub=get(findobj(hf,'tag','ax2'),'userdata');
    end
end

ax2=findobj(hf,'tag','ax2');
% himg=findobj(ax2,'type','image');
range=[]; sliderval=[];
try
    range    =caxis(ax2);
    sliderval =[u.jslid.getLowValue u.jslid.getHighValue];

    
end

try; delete(findobj(hf,'tag','ax2')); end
hax=axes;
% set(hax,'position',[0.25 0.51306 0.3 0.4],'tag','ax2');
set(hax,'position',[.245 0 .3 .9],'tag','ax2');
ax2=gca;
axes(ax2);
ht=text(.5,.5,'wait!','fontsize',20);
axis off;
drawnow;

if exist('replot')~=1
    [w]=procmap(a,z);
else
    %[w]=procmap(a,z);
    
    w=ub.w;
    
    %     if u.flipXY ==1;    w.S0map=permute(w.S0map,[2 1 3]);  end
    %     if u.flipXY ==1;    w.S0map=permute(w.R1rho,[2 1 3]);  end
    %     if u.flipLR ==1;    w.R1rho=flipdim(w.S0map,[2]);      end
    %     if u.flipLR ==1;    w.R1rho=flipdim(w.R1rho,[2]);      end
    %     hx=findobj(hf,'tag', 'switch_image');
    %     if hx.Value==1
    %         if u.flipLR ==1;    w.R1rho=flipdim(w.Cmap,[2]);      end
    %         if u.flipLR ==1;    w.R1rho=flipdim(w.Cmap,[2]);      end
    %     end
    
    
    
end


% if u.flipXY ==1;    w.S0map =permute(w.S0map,[2 1 3]);  end
% if u.flipXY ==1;    w.R1rho =permute(w.R1rho,[2 1 3]);  end
%
%
% if u.flipLR ==1;    w.S0map =flipdim(w.S0map,[2]);      end
% if u.flipLR ==1;    w.R1rho =flipdim(w.R1rho,[2]);      end


% if u.flipXY ==1;    w.S0map= permute(w.S0map,[2 1 3]);  end
% if u.flipXY ==1;    w.R1rho= permute(w.R1rho,[2 1 3]);  end
% if u.flipLR ==1;    w.S0map= flipdim(w.S0map,[2]);      end
% if u.flipLR ==1;    w.R1rho= flipdim(w.R1rho,[2]);      end



hx=findobj(hf,'tag', 'switch_image');
ax.ActivePositionProperty = 'position';
if hx.Value==1
    hImg =imagesc(w.R1rho(:,:,1));
else
    hImg =imagesc(a(:,:,1));
end
% axis image;
set(gca,'tag','ax2');
% set(hax,'position',[-.09 0  1 1],'tag','ax2');
set(hax,'position',[.245 0.01 .3 .9],'tag','ax2');
cb=colorbar;
set(cb,'position',[0.55 0.1    0.005    .4]);
axis off
if u.usemask==1 && exist('m')==1 % enlarge image based on mask
    bb=regionprops(m,'BoundingBox');
    if length(bb)==1
    bb=bb.BoundingBox;
    bb=bb+[-1 -1 +2 +2  ];
    xlim([bb(1) bb(1)+bb(3)]);
    ylim([bb(2) bb(2)+bb(4)]);
    else
       xlim([0.5 size(a,1)+.5])
       ylim([0.5 size(a,2)+.5])
        
    end
end
try
    eval(['cmap=' u.cmap ';']);
    colormap(ax2,cmap);
catch
    colormap(ax2,parula);
end
title(ax2, 'click to freeze/unfreeze plot','fontsize',8);
roypoly_setparameter(px)
set(hImg,'ButtonDownFcn',@imageClicked);
% ==============================================
%%    set slider and caxis
% ===============================================

is_fixedRange=get(findobj(hf,'tag','fixrange_rd'),'value');
if is_fixedRange==1
    %     mima=[u.jslid.getMinimum u.jslid.getMaximum ];
    %     slidval=[u.jslid.getLowValue u.jslid.getHighValue];
    %     caxis(ax2,slidval);
    caxis([range]);
    
    slidval=caxis(ax2);
    mima=slidval;
else % spcific range
    mima=[min(hImg.CData(:)) max(hImg.CData(:))];
    slidval=caxis(ax2);
    
end


if is_fixedRange==0
    %% ===============================================
    sliderMin = 0;
    sliderMax = 1000;
    u.jslid.setMinimum(sliderMin);
    u.jslid.setMaximum(sliderMax);
    
    [realMin lowReal]  = deal(mima(1));
    [realMax highReal] = deal(mima(2));
    
    lowSlider = round( ...
        sliderMin + ...
        (lowReal-realMin)/(realMax-realMin) * ...
        (sliderMax-sliderMin));
    highSlider = round( ...
        sliderMin + ...
        (highReal-realMin)/(realMax-realMin) * ...
        (sliderMax-sliderMin));
    
%     if is_fixedRange==1
%         u.jslid.setLowValue(u.sliderval(1));
%         u.jslid.setHighValue(u.sliderval(2));
%     else
%         u.jslid.setLowValue(lowSlider);
%         u.jslid.setHighValue(highSlider);
%     end
    nticksReal=3;
    nticks=nticksReal-1;
    TickSpacing=sliderMax/nticks;
    u.jslid.setMajorTickSpacing(TickSpacing);
    u.jslid.setMinorTickSpacing(0);
    
    % ====[set tickabels]===========================================
    %% lab=imin:majorStep:imax
    labels = java.util.Hashtable;
    font = javax.swing.JLabel().getFont;
    font = font.deriveFont(18);   % <-- font size in points
    for s = sliderMin:TickSpacing:sliderMax
        %     labels.put(int32(v), javax.swing.JLabel(num2str(v)));
        realVal = realMin + ...
            (s-sliderMin)/(sliderMax-sliderMin) * ...
            (realMax-realMin);
        %     labels.put(int32(s), javax.swing.JLabel(num2str(realVal)));
        lbl = javax.swing.JLabel(sprintf('%.4g',realVal));
        lbl.setFont(font);   % <<< IMPORTANT
        labels.put(int32(s), lbl);
    end
    u.jslid.setLabelTable(labels);
    u.jslid.setPaintLabels(true);
    u.jslid.setPaintTicks(true);
    u.jslid.repaint();
end


%             %% ===============================================
%
%
%
%
%
%             % scale=10000;
%             scale = 10^max(0,-floor(log10(max(abs([mima(1) mima(2)]))))+2)
%             imin = round(mima(1) * scale)
%             imax = round(mima(2) * scale)
%
%             u.scale(1)=scale;
%             set(hf,'userdata',u);
%
%             if scale>10
%                 u.jslid.setMinimum(imin);
%                 u.jslid.setMaximum(imax);
%                 u.jslid.setLowValue(imin);
%                 u.jslid.setHighValue(imax);
%                 %% ===============================================
%
%                 rngVal = imax - imin;
%
%                 targetTicks = 6;
%                 rawStep = rngVal / targetTicks;
%
%                 pow10 = 10^floor(log10(rawStep));
%                 frac = rawStep / pow10;
%
%                 if frac < 1.5
%
%                     nice = 1;
%                 elseif frac < 3
%                     nice = 2;
%                 elseif frac < 7
%                     nice = 5;
%                 else
%                     nice = 10;
%                 end
%
%                 majorStep = nice * pow10;
%                 minorStep = max(1,round(majorStep/5));
%
%                 u.jslid.setMajorTickSpacing(majorStep);
%                 u.jslid.setMinorTickSpacing(minorStep);
%
%                 %% ====[set tickabels]===========================================
%                 %lab=imin:majorStep:imax
%                 labels = java.util.Hashtable;
%                 for v = imin:majorStep:imax
%                     labels.put(int32(v), javax.swing.JLabel(num2str(v)));
%                 end
%                 u.jslid.setLabelTable(labels);
%                 u.jslid.setPaintLabels(true);
%                 u.jslid.setPaintTicks(true);
%                 u.jslid.repaint();
%
%                 %% ===============================================
%
%             else
%                 u.jslid.setMinimum(mima(1))
%                 u.jslid.setMaximum(mima(2))
%                 u.jslid.setLowValue(slidval(1))
%                 u.jslid.setHighValue(slidval(2));
%
%
%                 % u.jslid.setMajorTickSpacing(5)
%                 % u.jslid.setMinorTickSpacing(1)
%                 % u.jslid.setPaintTicks(true)
%
%                 % jRangeSlider.setVisible(1)
%                 % set(hContainer,'visible','off')
%
%
%                 %% ====[set steps]===========================================
%                 minV = u.jslid.getMinimum();
%                 maxV = u.jslid.getMaximum();
%                 rngVal = maxV - minV;
%                 targetTicks = 6;
%                 rawStep = rngVal / targetTicks;
%                 pow10 = 10^floor(log10(rawStep));
%                 frac = rawStep / pow10;
%                 if frac < 1.5
%                     nice = 1;
%                 elseif frac < 3
%                     nice = 2;
%                 elseif frac < 7
%                     nice = 5;
%                 else
%                     nice = 10;
%                 end
%                 majorStep = nice * pow10;
%                 minorStep = majorStep / 5;
%
%                 u.jslid.setMajorTickSpacing(majorStep)
%                 u.jslid.setMinorTickSpacing(minorStep)
%
%
%                 % u.jslid.setPaintTicks(true)
%                 %% ====[set tickabels]===========================================
%                 labels = java.util.Hashtable;
%                 for v = minV:majorStep:maxV
%                     labels.put(int32(v), javax.swing.JLabel(num2str(v)));
%                 end
%                 u.jslid.setLabelTable(labels);
%                 u.jslid.setPaintLabels(true);
%                 u.jslid.setPaintTicks(true);
%                 u.jslid.repaint();
%
%             end
%% ===============================================
im = u.jslid.getInputMap(javax.swing.JComponent.WHEN_FOCUSED);

im.put(javax.swing.KeyStroke.getKeyStroke('LEFT'),  []);
im.put(javax.swing.KeyStroke.getKeyStroke('RIGHT'), []);
im.put(javax.swing.KeyStroke.getKeyStroke('UP'),    []);
im.put(javax.swing.KeyStroke.getKeyStroke('DOWN'),  []);
u.jslid.setFocusable(false);


%% ===============================================
% try; delete(findobj(hf,'tag','ax3')); end

% ax3=findobj(findobj(0,'tag','showfit'),'tag','ax3');
% if isempty(ax3)
%     hax=axes;
%     set(hax,'position',[0.62 0.1 0.37 0.8],'tag','ax3');
%     ax3=hax;
%     ht=text(ax3,.5,.5,'wait!','fontsize',20);
%     set(ax3,'userdata','ax3');
%     plot(ax3,0:0.001,0.01); hold off
%     drawnow
%     colormap gray
% end
% % ax3=findobj(findobj(0,'tag','showfit'),'tag','ax3');
%





%% ===============================================
hf = findobj(0,'tag','showfit');
ax3 = findobj(hf,'tag','ax3');
if isempty(ax3)
    ax3 = axes( ...
        'Parent',hf,...
        'Position',[0.62 0.11 0.37 0.8],...
        'Tag','ax3');
    text(ax3,.5,.5,'wait!','fontsize',20);
    ax3.UserData = 'ax3';
    %plot(ax3,0:00001:0001,0:00001:0001,'r');
    %     try
    %         eval(['cmap=' u.cmap ';']);
    %         colormap(ax3,cmap);
    %     catch
    %         colormap(ax3,parula);
    %     end
    drawnow
end
ax3 = findobj(hf,'tag','ax3');

% ax3 =
%
%   0×0 empty GraphicsPlaceholder array.
%% ===============================================



ax2=findobj(hf,'tag','ax2');
v=get(ax2,'userdata');
v.hImg=hImg;
v.a=a;
v.w=w;
v.ax3=ax3;
set(ax2,'userdata',v);
isRoi=get(findobj(hf,'tag','roi'),'value');
if isRoi==0
    axes(ax2);
    hold on
    delete(findobj(hf,'tag','dot'));
    %   hdot = plot(ax2,NaN,NaN,'.','MarkerSize',10,'tag','dot','color','r');
    
    hdot = line(ax2,...
        NaN,NaN,...
        'Marker','.',...
        'MarkerSize',10,...
        'LineStyle','none',...
        'Color','r','tag','dot','HitTest','off','PickableParts','none','hittest','off');
    
    
    set(hf,'WindowButtonMotionFcn',{@motion,hImg,a,w,ax3,[]})
elseif isRoi==1
    myFunction(v.hpoly, [])
end
axes(ax3);
ax3=findobj(hf,'tag','ax3');
set(hf,'CurrentObject',ax3);
set(hf,'CurrentAxes',ax3);
%set(hf,'WindowButtonMotionFcn',{@motion2})



function slider_set(low,high)
%% ===============================================

hf=findobj(0,'tag','showfit');
ax2=findobj(hf,'tag','ax2');
himg=findobj(ax2,'type','image');
mima=[min(himg.CData(:)) max(himg.CData(:))];
u=get(hf,'userdata');

sliderMin =  u.jslid.getMinimum;
sliderMax =  u.jslid.getMaximum;
realMin=mima(1);
realMax=mima(2);
% lowReal=30
% highReal=135
if isnan(low);  low=mima(1); end
if isnan(high); high=mima(2); end

% if [high-low]>1 &&  low>sliderMin  &&  high<sliderMax % limits not reached because resolution is not fine enough
%     
%     
% end

lowReal=low;
highReal=high;



lowSlider = round( ...
    sliderMin + ...
    (lowReal-realMin)/(realMax-realMin) * ...
    (sliderMax-sliderMin));
highSlider = ceil ( ...
    sliderMin + ...
    (highReal-realMin)/(realMax-realMin) * ...
    (sliderMax-sliderMin));

% lowSlider
% highSlider

u.jslid.setLowValue(lowSlider);
u.jslid.setHighValue(highSlider);

caxis(ax2,[  low high])

%% ===============================================
    


function slider_cb(e,e2)
%% ===============================================

hf=findobj(0,'tag','showfit');
ax2=findobj(hf,'tag','ax2');
u=get(hf,'userdata');
% clims=[u.jslid.getLowValue u.jslid.getHighValue];
ax2=findobj(hf,'tag','ax2');
himg=findobj(ax2,'type','image');

realMin=min(himg.CData(:));
realMax=max(himg.CData(:));

sliderMin = 0;
sliderMax = 1000;

lowS  = u.jslid.getLowValue;
highS = u.jslid.getHighValue;

clims = realMin+([lowS highS] - sliderMin)/(sliderMax - sliderMin) * (realMax - realMin);
try
caxis(ax2,clims);
catch
   if [clims(1) == clims(2)] 
       clims(2)=[clims(1)+eps];
       
   end
end

%===================================================================================================


% clims=clims./u.scale(1);




% setfocus(ax2)


% set(hf,'WindowButtonMotionFcn',{@motion,hImg,w})

function motion(src,~,hImg,a,w,ax3,mask)
% rand(1)



hf=findobj(0,'tag','showfit');

%  rand(1)
% return


u=get(hf,'userdata');
% u.isfreeze
% return

if u.isfreeze==1
    return
end


if ~isempty(mask)
    useroi=1;
    row=2;
    col=2;
    sz(1)=10;
    sz(2)=10;
else
    useroi=0;
end


if useroi==0  %MOVING DOT
    % mouse position in axes coordinates
    ax=findobj(hf,'tag','ax2');
    
    if u.autolog ==0
        cp = ax.CurrentPoint;
        x = cp(1,1);
        y = cp(1,2);
        % optional: stay only inside image/axes limits
        xl = xlim(ax);
        yl = ylim(ax);
        inside = ...
            x >= xl(1) && x <= xl(2) && ...
            y >= yl(1) && y <= yl(2);
        if inside
            try
                hDot=findobj(hf,'tag','dot');
                hDot.XData = x;
                hDot.YData = y;
                set(hDot,'visible','on');
                drawnow
            end
        end
    else
        hDot=findobj(hf,'tag','dot');
        set(hDot,'visible','on');
        x=hDot.XData;
        y=hDot.YData ;
    end
else
    hDot=findobj(hf,'tag','dot');
    set(hDot,'visible','off');
    
end


if useroi==0
    if u.autolog ==0
        obj = hittest(src);   % object currently under mouse
        % alternatively: obj = src.CurrentObject;
        if ~isequal(obj,hImg); return; end
        
        ax = ancestor(hImg,'axes');
        % Mouse position in axes coordinates
        cp = ax.CurrentPoint;
        x = cp(1,1);
        y = cp(1,2);
    else
        % x,y are defined above
        
    end
    % Image coordinate mapping
    xd = hImg.XData;
    yd = hImg.YData;
    sz = size(hImg.CData);
    % Convert axes coordinates -> pixel indices
    col = round( (x - xd(1)) / (xd(end)-xd(1)) * (sz(2)-1) + 1 );
    row = round( (y - yd(1)) / (yd(end)-yd(1)) * (sz(1)-1) + 1 );
end
if row >= 1 && row <= sz(1) && col >= 1 && col <= sz(2) % Check bounds
    if useroi==0
        %val = hImg.CData(row,col);
        q.S0map=w.S0map(row,col);
        q.R1rho=w.R1rho(row,col);
        q.a    =squeeze(a(row,col,:)); %CESL-vector
        q.pfit =w.pfit;
        q.TSL =w.TSL;%[0.005 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.15 0.2]
        
        if strcmp(u.fitmethod,'nonlinear_constant')
            q.Cmap   = w.Cmap(row,col);     % constant
        end
        
    elseif useroi==1
        q.S0map=  mean(w.S0map(mask==1));
        q.R1rho=   mean(w.R1rho(mask==1));
        nvox=sum(mask(:));
        m2=double(repmat(mask,[1 1 size(a,3)]));
        m2(m2==0)=nan;
        a2=a.*m2;
        a3=reshape(a2, [size(a2,1)*size(a2,2) size(a2,3) ]);
        q.a=nanmean(a3,1);
        q.pfit =w.pfit;
        
        if strcmp(u.fitmethod,'nonlinear_constant')
            q.Cmap   = mean(w.Cmap(mask==1))   ; % constant
        end
        
        q.TSL =w.TSL;%[0.005 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.15 0.2]
        col=nan;
        row=nan;
        
        
        
    end
    
    
    %xCESL_monoexpfit: Estimate voxel-wise R1rho relaxation maps from CESL/T1rho MRI
    %   S(TSL)   = measured CESL signal intensity
    %   S0       = estimated signal at TSL = 0
    %   R1rho    = relaxation rate in the rotating frame [1/s]
    %   TSL      = spin-lock time
    
    %% ===============================================
    
    %         x = q.TSL(:);
    %         y = q.a(:);
    %
    %         yfit = q.S0map * exp(-q.R1rho * x);
    %         fg
    %         plot(x,y,'bo')
    %         hold on
    %         plot(x,yfit,'r-','LineWidth',2)
    %
    %         legend('Measured','Stored fit')
    %         xlabel('TSL')
    %         ylabel('Signal')
    %
    %% ===============================================
    hf=findobj(0,'tag','showfit');
    %ax3=findobj(hf,'tag','ax3');
    
    % axp=findobj(findobj(0,'tag','showfit'),'tag','ax3')
    %        ['ud:' get(ax3,'userdata')]
    %        ['tag:' get(ax3,'tag')]
    
    if isempty(ax3)
        ax3=findobj(hf,'tag','ax3');
        set(ax3,'tag','ax3');
    end
    
    if isempty(ax3)
        lin=(findobj(findobj(0,'tag','showfit'),'type','line'));
        ax3=get(findobj(lin,'DisplayName', 'Measured data'),'parent');
        set(ax3,'tag','ax3');
    end
    
    %     ax3
    
    
    
    axes(ax3);
    hold off
    x = q.TSL(:);
    y = q.a(:);
    % smooth x-axis for display
    %         xfine = linspace(min(x),max(x),500);
    %         yfine = q.S0map * exp(-q.R1rho * xfine);
    xfine = linspace(0,max(x),500);
    
    if strcmp(u.fitmethod,'nonlinear_constant')
        yfine = q.S0map * exp(-q.R1rho * xfine) + q.Cmap;
    else
        yfine = q.S0map * exp(-q.R1rho * xfine);
    end
    
    plot(x,y,'bo','MarkerFaceColor','b');
    hold on
    plot(xfine,yfine,'r-','LineWidth',2);
    
    if strcmp(u.fitmethod,'nonlinear_constant')
        % optional: plot offset level
        % yline(q.Cmap,'k--','Offset C');
        yline(q.Cmap,'k--');
    end
    
    decayRateName=u.decayRateName;
    if ~isempty(decayRateName)
       decayRateName=[decayRateName '='];
    end
    
    if strcmp(u.fitmethod,'nonlinear_constant')
        if useroi==0
            ti=title(sprintf('%s%g, S0=%g C=%g   [%d,%d]'  ,decayRateName,q.R1rho,q.S0map,q.Cmap,row,col));
        else
            ti=title(sprintf('%s%g, S0=%g C=%g  [nvox: %d]' ,decayRateName,q.R1rho,q.S0map,q.Cmap,nvox));
        end
    else
        if useroi==0
            ti=title(sprintf('%s%g, S0=%g   [%d,%d]'    ,decayRateName,q.R1rho,q.S0map,row,col));
        else
            ti=title(sprintf('%s%g, S0=%g   [nvox: %d]' ,decayRateName,q.R1rho,q.S0map,nvox));
        end
    end
    
    xlabel(u.xlabel);
    ylabel(u.ylabel);
    xlim([0 max(x) ])
    legend('Measured data','Monoexp fit');
    grid on
    set(ax3,'tag','ax3');
    % ===============================================
    
    %% ===============================================
    
    
    
    %fprintf('row=%d col=%d value=%g\n',row,col,q.R1rho);
end






function updatefiles(e,e2)
hf=findobj(0,'tag','showfit');
u=get(hf,'userdata');
hb=findobj(hf,'tag','c_animals');
ha=findobj(hf,'tag','c_files');
animal=hb.String{hb.Value};
pam=u.pa{find(strcmp(u.animals,animal))};

%% ===============================================
z=u;
% get otherCESL-maps if requested
[~,z.rooutname]=fileparts(z.file{1});
fi=char(z.file);
[numstr isep] = regexp(fi,'\d+(?=\.[^.]+$)','match','once');
if ~isempty(isep)
    nametag=['^' fi(1:isep-1)  '.*.nii'];
    z.rooutname=fi(1:isep-1);
end
if z.fit_othermaps==1
    fi=char(z.file);
    %tok = regexp(fi,'(\d+)(?=\.[^.]+$)','tokens')
    %[numstr isep] = regexp(fi,'\d+(?=\.[^.]+$)','match','once');
    if ~isempty(isep)
        %nametag=['^' fi(1:isep-1)  '.*.nii'];
        %z.rooutname=fi(1:isep-1);
        [fis] = spm_select('List',pam,nametag);
        fis=cellstr(fis);
    else
        fis=cellstr(z.file);
    end
else
    fis=cellstr(z.file);
end

set(ha,'string',fis,'value',1);
hf=findobj(0,'tag','showfit');
try; delete(findobj(hf,'tag','ax3')); end

try;
    delete(findobj(hf,'tag','ax2'));
end


plotter();




%% ===============================================



function  proc_anmal(z,pam,iter)
% get otherCESL-maps if requested
[~,z.rooutname]=fileparts(z.file{1});
fi=char(z.file);
[numstr isep] = regexp(fi,'\d+(?=\.[^.]+$)','match','once');
if ~isempty(isep)
    nametag=['^' fi(1:isep-1)  '.*.nii'];
    z.rooutname=fi(1:isep-1);
end

if z.fit_othermaps==1
    fi=char(z.file);
    %tok = regexp(fi,'(\d+)(?=\.[^.]+$)','tokens')
    %[numstr isep] = regexp(fi,'\d+(?=\.[^.]+$)','match','once');
    if ~isempty(isep)
        %nametag=['^' fi(1:isep-1)  '.*.nii'];
        %z.rooutname=fi(1:isep-1);
        [fis] = spm_select('List',pam,nametag);
        fis=cellstr(fis);
    else
        fis=cellstr(z.file);
    end
else
    fis=cellstr(z.file);
end



% ==============================================
%% loop OVER maps:   parfor here
% ===============================================

% if z.isparallel==1
%     parfor i = 1:length(fis)
%         file = fis{i};
%         procmap(file, pam, z);
%     end
% else
for i=1:length(fis)
    file=fis{i};
    procmap(file,pam,z);
end
% end











%% ===============================================

% function  procmap(file,pam,z)
function  [w]=procmap(a,z)

fitmethod = z.fitmethod;% 'nonlinear';% OPTIONS: 'linear'  'nonlinear'
%
% pam='H:\Daten-2\Imaging\AG_Mergenthaler\2DG_CEST_Manuskript\dat\2023117PM_hypothermia_2DG_PME000652_2DG'
% f1=fullfile(pam,'c_c_T1rho_2DG__002.nii');%input
% fm=fullfile(pam,'ix_AVGTmask_slice.nii');%mask
%% ===============================================
if 0
    
    f1=fullfile(pam, file);
    [ha a]=rgetnii(f1);  % [220 220 13]
    
    %% using mask
    fm=fullfile(pam, char(z.mask));
    if ~isempty(char(z.mask)) && exist(fm)==2
        [hm m]=rgetnii(fm);  % [220 220 1]
        a=a.*repmat(m,[1 1 size(a,3)]);
    end
    
end
%% ===============================================
% ============================================================
% CESL / T1rho mono-exponential fitting
% MATLAB 2016 + SPM version
% ------------------------------------------------------------
% DATA ASSUMPTION
% ------------------------------------------------------------
% One NIfTI file contains:
%   dim1 = x direction
%   dim2 = y direction
%   dim3 = different spin-lock times (TSL)
% Example:
%   size(a) = [128 128 13]
% meaning:
%   128 x 128 image
%   13 spin-lock times
% ------------------------------------------------------------
% BASIC CESL / T1rho SIGNAL EQUATION
% ------------------------------------------------------------
% The MRI signal decreases exponentially with increasing
% spin-lock time:
%   S(TSL) = S0 * exp( -R1rho * TSL )
% where:
%   S(TSL)   = measured MRI signal
%   S0       = estimated signal at TSL = 0
%   R1rho    = relaxation rate
%   TSL      = spin-lock time
% ------------------------------------------------------------
% WHY WE USE THE LOGARITHM
% ------------------------------------------------------------
% Exponential fitting is harder than linear fitting.
% Therefore we transform the equation:
%   ln(S) = ln(S0) - R1rho * TSL
% This is now:
%   y = b + m*x
% where:
%   y = ln(S)
%   b = ln(S0)
%   m = -R1rho
% Therefore:
%   slope = -R1rho
% ------------------------------------------------------------
% IMPORTANT UNIT NOTE
% ------------------------------------------------------------
% TSL values MUST be in SECONDS.
% Example:
%   5 ms  = 0.005 sec
% Otherwise R1rho values become wrong by factor 1000.
% ============================================================

% ============================================================
% DEFINE SPIN-LOCK TIMES
% ============================================================
% IMPORTANT:
% These must correspond EXACTLY to the order of the
% 13 volumes in dim3.
% Example only:
% Replace with your real TSL values.
% Units = seconds
% ============================================================
% TSL_microseconds = [ ...
%      5000 ...
%     10000 ...
%     20000 ...
%     30000 ...
%     40000 ...
%     50000 ...
%     60000 ...
%     70000 ...
%     80000 ...
%     90000 ...
%    100000 ...
%    150000 ...
%    200000 ];
% % convert µs -> seconds
% TSL = TSL_microseconds / 1e6;

%% ===============================================

TSL_au=z.TSL;
if ~isnumeric(TSL_au)
    TSL_au=str2num(TSL_au);
end
TSL_au=TSL_au(:)';
switch z.TSL_unit
    case {'seconds' 's'  'none'}
        factor = 1;
    case {'milliseconds' 'ms'}
        factor = 1e3;
    case {'microseconds' 'us'}
        factor = 1e6;
end
TSL = TSL_au / factor;  % this is TSL in seonds






%% ===============================================

% ============================================================
R1rho = zeros(size(a,1), size(a,2));%This map will contain one fitted R1rho value
S0map = zeros(size(a,1), size(a,2)); % OPTIONAL: STORE S0 MAP,S0 is the fitted signal intensity at TSL = 0.,Usually not used further, but helpful for debugging.

if strcmp(fitmethod,'nonlinear_constant')
    Cmap=S0map;
end
% ============================================================
% LOOP OVER ALL VOXELS
% ============================================================
for x = 1:size(a,1)
    for y = 1:size(a,2)
        s = squeeze(a(x,y,:));% EXTRACT SIGNAL DECAY CURVE
        %s = s(:);
        
        if all(s == 0)  % SKIP INVALID VOXELS (outside mask)
            continue
        end
        % ====================================================
        % LINEARIZED FIT: ln(S) = ln(S0) - R1rho * TSL
        % ====================================================
        if strcmp(fitmethod,'linear')
            if any(s <= 0)  % SKIP INVALID VOXELS -->due to log
                continue
            end
            
            logS = log(s);   % log transform
            p = polyfit(TSL, logS', 1);  % linear regression
            R1rho(x,y) = -p(1); % slope = -R1rho
            S0map(x,y) = exp(p(2));  % intercept = ln(S0)
            pfit=[-p(1) p(2)];
        end
        % ====================================================
        % NONLINEAR MONOEXPONENTIAL FIT
        % ====================================================
        % fits: S = S0 * exp( -R1rho * TSL ) using least squares optimization.
        if strcmp(fitmethod,'nonlinear')
            % INITIAL START VALUES;Optimization needs initial guesses.
            % parameter vector: p(1) = S0; p(2) = R1rho
            % p0 = [ max(s) 15 ];
            p0 = [ max(s) 1/mean(TSL) ];
            % ERROR FUNCTION:
            % Computes: sum of squared residuals
            % residual = measured signal - predicted signal
            errfun = @(p) sum(( s' - p(1) * exp( -p(2) * TSL )).^2);
            %   errfun = @(p) sum(( s - p(1) * exp( -p(2) * TSL )).^2);
            % RUN OPTIMIZATION: fminsearch searches parameter values to minimize error function
            pfit = fminsearch(errfun, p0);
            S0map(x,y) = pfit(1);
            R1rho(x,y) = pfit(2);
        end
        % ====================================================
        % NONLINEAR MONOEXPONENTIAL FIT WITH CONSTANT OFFSET
        % ====================================================
        % fits:
        % S = S0 * exp( -R1rho * TSL ) + C
        % p(1) = S0
        % p(2) = R1rho
        % p(3) = C
        if strcmp(fitmethod,'nonlinear_constant')
            % --------------------------------------------
            % INITIAL START VALUES
            % --------------------------------------------
            % S0     -> maximum signal
            % R1rho  -> rough inverse time scale estimate
            % C      -> minimum signal as noise-floor estimate
            % --------------------------------------------
            p0 = [ max(s)  1/mean(TSL)  min(s) ];
            % --------------------------------------------
            % ERROR FUNCTION . residual = measured signal - predicted signal
            opts = optimset('MaxFunEvals',1e5,'MaxIter',1e5,'Display','off');
            
            errfun = @(p) sum( ...
                ( s' - ( p(1) * exp( -p(2) * TSL ) + p(3) ) ).^2 );
            pfit = fminsearch(errfun, p0,opts); % RUN OPTIMIZATION
            S0map(x,y)   = pfit(1); % STORE FITTED PARAMETERS
            R1rho(x,y)   = pfit(2);
            Cmap(x,y)    = pfit(3);
            
        end
        
        
        
    end
end
%         %% ===========[save NIFTI]====================================
%         % isep=max(strfind(file,'_'));
%         % suffix=file(isep:end);
%         % outnameprefix='R1rho';
%         suffix=strrep(file, z.rooutname,''); %pure numeric
%
%
%         fo3=fullfile(pam, [ z.outPrefix  suffix ]);
%         if exist(fo3)==2
%             try; delete(fo3); end
%         end
%         hc=ha;
%         hc.dim=[ha.dim(1:2) 1];
%         rsavenii(fo3, hc,  R1rho);
%         showinfo2('R1rho-map',fo3);


w.pfit=pfit;
w.S0map=S0map;
w.R1rho=R1rho;
w.TSL=TSL;

if exist('Cmap')==1
    w.Cmap=Cmap;
end

%% ===============================================



function o=fromBrukerrawfile(e,e2)
o=[];

%% ===============================================

head=strjoin({...
    ['data source']
    ['TSL → R1ρ / relaxation mapping']
    ['b-value → diffusion (ADC/IVIM-like fitting)']
    ['other ' '..not dfined']
    
    }',char(10));

task = questdlg(head, 'source of the data', ...
	'TSL' ,'b-value','cancel','TSL');
% Handle response
switch task
    case 'TSL'
        dessert = 1;
    case 'b-value'
        dessert = 2;
    case 'cancel'
        disp('cancel'); return
end
    


%% ===============================================
if strcmp(task,'TSL')
    sel='';
    wd=pwd;
    mesg='select TSL-file (BrukerData)';
    [t,sts] = spm_select(1,'any',mesg,sel,wd);
    if isempty(t); return; end
    try;
        a=preadfile(t); a=a.all;
        a(cellfun(@isempty,a))=[];
        a=(strjoin((a),','));
        %     a=str2num(a);
        o=a;
    end
elseif strcmp(task,'b-value')
    %% ===============================================
    sel='';
    wd=pwd;
    mesg='select Bruker methods file containing "PVM_DwEffBval"';
    [t,sts] = spm_select(1,'any',mesg,sel,wd);
    if isempty(t); return; end
    try; 
        m=readBrukerParamFile(t);
        o=m.PVM_DwEffBval;
        o=a;      
    end
    %% ===============================================
    
    
end

