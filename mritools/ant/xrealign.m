
% #yk     Realign a 3d-(time)series/4Dvolume using SPM-realign procedure.   
% 
% #ka ==============================================
% #ka  BASIC PARAMETER                                     
% #ka ==============================================
% #b <u> INPUT IMAGE/VOLUME: 
%  either 
%   (a) z.image3D:  select 1st image(volume) of 3D-(time)-series  (all other images of this timeseries 
%        will be determined automatically
%    or
%   (b) z.image4D:  select a 4D-volume
% #b convertDataType : sometimes 4D-data are to large, such that the image cannot be loaded...
%       in this case the dataType can be changed, for instance from double to single precission
%      (this is: 16, "see spm_type.m") and 50% dataSize will be stored
%      0  : keep orignal data type /precision
%      16 : change to single precision 
%      other : -->  #g see spm_type.m
% #b merge4D:  merge 3D-series to 4D-volume: 
%          [0]no,keep 3D-volumes
%          [1]save as 4D-volume 
%     ..obsolete for 4D input data (4D data remain 4D)
% #b outputname:  optional: rename outputfile INSTEAD OF USING A PREFIX
%    (a) use PREFIX: --> outputname is EMPTY!
%         z.outputname       = '';
%       (empty): output-filename is generated via "roptions_prefix"+"inputfilename"
%        example 4D: 'mau.nii' --> 'rmau.nii'; (if roptions_prefix is 'r')
%                3D: 'mau_00001.nii/mau_00002.nii' becomes 'rmau_00001.nii/rmau_00002.nii...'
%    (b) use EXPLICIT OUTFILE NAME: --> outputname is a STRING
%      z.outputname       = 'wau.nii';
%      example 4D: 'WAU' or 'wau.nii' : output is 'WAU.nii' or 'wau.nii'
%      for 3D using "wau"  : 'mau_00001.nii/mau_00002.nii...' becomes 'wau_00001.nii/wau_00002.nii...'
% #b isparallel : use parallel-processing
%       [0] no
%       [1] yes..use Parallel processing
% 
%  #r ___________________________________________________________
%  #r NOTE: FOR SPM PARAMETERS (eoptions/roptions)..see below
%  #r ___________________________________________________________
%   
% 
% #ka ==============================================
% #ka   EXAMPLES                                      
% #ka ==============================================
% ==============================================
%% #wg   realign 4D-volume.. merge to 4D-volume..
% input: 'test2.nii': 4D volume
% output: "out5.nii" which is 4D
% ===============================================
% z=[];                                                                                                                                                             
% z.image3D          = { '' };              % % SELECT: a 3D-volume series to realign (only 1st image is needed to select here)                                     
% z.image4D          = { 'test2.nii' };     % % SELECT: a 4D-volume to realign                                                                                      
% z.convertDataType  = [16];                % % converts dataType if 4D volume is to large: [0]no..keep dataType, [16] change to single precision                   
% z.merge4D          = [1];                 % % merge 3D-series to 4D-volume: [0]no,keep 3D-volumes, [1]save as 4D-volume                                           
% z.outputname       = 'out5.nii';          % % optional: rename outputfile; if empty the output-filename is "roptions_prefix"+"inputfilename"                      
% 
% z.eoptions_quality = [0.9];               % % Quality versus speed trade-off {0-1},Highest   quality   (1)   gives   most   precise   results                     
% z.eoptions_sep     = [1];                 % % The separation (in mm) between the points sampled in the reference image.                                           
% z.eoptions_fwhm    = [0.5];               % % SMOOTHING: FWHM of the Gaussian smoothing kernel (mm) applied to the images before estimating                       
% z.eoptions_rtm     = [0];                 % % [0]Register  to  first:  Images  are registered to the first image in the series. [1]  Register to mean..           
% z.eoptions_interp  = [2];                 % % Interpolation: Method by which the images are sampled when estimating the optimum transformation.                   
% z.eoptions_wrap    = [0  0  0];           % % Wrapping: Directions in the volumes the values should wrap around in.                                               
% z.eoptions_weight  = '';                  % % Weighting: Optional  weighting  image  to  weight  each  voxel  of  the  reference  image                           
% z.roptions_which   = [2  0];              % % Specify the images to reslice..see HELP                                                                             
% z.roptions_interp  = [4];                 % % Interpolation: The method by which the images are sampled when being written in a different space.                  
% z.roptions_wrap    = [0  0  0];           % % Wrapping: This indicates which directions in the volumes the values should wrap around in.                          
% z.roptions_mask    = [1];                 % % MASKING: see HELP                                                                                                   
% z.roptions_prefix  = 'r';                 % % Filename Prefix:specify the string to be prepended to the filenames of the resliced image                           
% xrealign(1,z); 
% ==============================================
%% #wg   realign 3d-series.. merge to 4D-volume..
% 'test2_00001.nii' is the 1st image of the 3d-series
% output: "out4.nii" which is 4D
% ===============================================
% z=[];                                                                                                                                                             
% z.image3D          = { 'test2_00001.nii' };     % % SELECT: a 3D-volume series to realign (only 1st image is needed to select here)                               
% z.image4D          = { '' };                    % % SELECT: a 4D-volume to realign                                                                                
% z.convertDataType  = [16];                      % % converts dataType if 4D volume is to large: [0]no..keep dataType, [16] change to single precision             
% z.merge4D          = [1];                       % % merge 3D-series to 4D-volume: [0]no,keep 3D-volumes, [1]save as 4D-volume                                     
% z.outputname       = 'out4.nii';                % % optional: rename outputfile; if empty the output-filename is "roptions_prefix"+"inputfilename"                
% 
% z.eoptions_quality = [0.9];                     % % Quality versus speed trade-off {0-1},Highest   quality   (1)   gives   most   precise   results               
% z.eoptions_sep     = [1];                       % % The separation (in mm) between the points sampled in the reference image.                                     
% z.eoptions_fwhm    = [0.5];                     % % SMOOTHING: FWHM of the Gaussian smoothing kernel (mm) applied to the images before estimating                 
% z.eoptions_rtm     = [0];                       % % [0]Register  to  first:  Images  are registered to the first image in the series. [1]  Register to mean..     
% z.eoptions_interp  = [2];                       % % Interpolation: Method by which the images are sampled when estimating the optimum transformation.             
% z.eoptions_wrap    = [0  0  0];                 % % Wrapping: Directions in the volumes the values should wrap around in.                                         
% z.eoptions_weight  = '';                        % % Weighting: Optional  weighting  image  to  weight  each  voxel  of  the  reference  image                     
% z.roptions_which   = [2  0];                    % % Specify the images to reslice..see HELP                                                                       
% z.roptions_interp  = [4];                       % % Interpolation: The method by which the images are sampled when being written in a different space.            
% z.roptions_wrap    = [0  0  0];                 % % Wrapping: This indicates which directions in the volumes the values should wrap around in.                    
% z.roptions_mask    = [1];                       % % MASKING: see HELP                                                                                             
% z.roptions_prefix  = 'r';                       % % Filename Prefix:specify the string to be prepended to the filenames of the resliced image                     
% xrealign(1,z);  
% 
% ==============================================
% #wg   realign 3d-series.. keep 3d-series..
% 'test2_00001.nii' is the 1st image of the 3d-series
% output: "out8_00001.nii,out8_00002.nii,out8_00003.nii..."
% ===============================================
% z=[];                                                                                                                                                             
% z.image3D          = { 'test2_00001.nii' };     % % SELECT: a 3D-volume series to realign (only 1st image is needed to select here)                               
% z.image4D          = { '' };                    % % SELECT: a 4D-volume to realign                                                                                
% z.convertDataType  = [16];                      % % converts dataType if 4D volume is to large: [0]no..keep dataType, [16] change to single precision             
% z.merge4D          = [0];                       % % merge 3D-series to 4D-volume: [0]no,keep 3D-volumes, [1]save as 4D-volume                                     
% z.outputname       = 'out8';                     % % optional: rename outputfile; if empty the output-filename is "roptions_prefix"+"inputfilename"                
% 
% z.eoptions_quality = [0.9];                     % % Quality versus speed trade-off {0-1},Highest   quality   (1)   gives   most   precise   results               
% z.eoptions_sep     = [1];                       % % The separation (in mm) between the points sampled in the reference image.                                     
% z.eoptions_fwhm    = [0.5];                     % % SMOOTHING: FWHM of the Gaussian smoothing kernel (mm) applied to the images before estimating                 
% z.eoptions_rtm     = [0];                       % % [0]Register  to  first:  Images  are registered to the first image in the series. [1]  Register to mean..     
% z.eoptions_interp  = [2];                       % % Interpolation: Method by which the images are sampled when estimating the optimum transformation.             
% z.eoptions_wrap    = [0  0  0];                 % % Wrapping: Directions in the volumes the values should wrap around in.                                         
% z.eoptions_weight  = '';                        % % Weighting: Optional  weighting  image  to  weight  each  voxel  of  the  reference  image                     
% z.roptions_which   = [2  0];                    % % Specify the images to reslice..see HELP                                                                       
% z.roptions_interp  = [4];                       % % Interpolation: The method by which the images are sampled when being written in a different space.            
% z.roptions_wrap    = [0  0  0];                 % % Wrapping: This indicates which directions in the volumes the values should wrap around in.                    
% z.roptions_mask    = [1];                       % % MASKING: see HELP                                                                                             
% z.roptions_prefix  = 'r';                       % % Filename Prefix:specify the string to be prepended to the filenames of the resliced image                     
% xrealign(1,z);   
% 
% ==============================================
%% #wb SPM: ESTIMATE OPTIONS
% ===============================================
% #g Quality                                                                                              
% Quality versus speed trade-off.                                                                      
% Highest   quality   (1)   gives   most   precise   results,  whereas  lower  qualities  gives  faster
% realignment. The idea is that some voxels contribute little to the estimation of the realignment     
% parameters. This parameter is involved in selecting the number of voxels that are used.              
% This item has a default value, set via a call to function                                            
% @(val)spm_get_defaults('realign.estimate.quality',val{:})                                            
% Real numbers are entered.                                                                            
% An 1-by-1 array must be entered.
% ___________________________________________________________________________
% #g  Separation                                                                 
% The separation (in mm) between the points sampled in the reference image.  
% Smaller sampling distances gives more accurate results, but will be slower.
% This item has a default value, set via a call to function                  
% @(val)spm_get_defaults('realign.estimate.sep',val{:})                      
% Real numbers are entered.                                                  
% An 1-by-1 array must be entered.
% #g  Smoothing (FWHM)                                                                       
% The  FWHM of the Gaussian smoothing kernel (mm) applied to the images before estimating
% the realignment parameters.                                                                                                                                         
%     * PET images typically use a 7 mm kernel.                                                                                                                              
%     * MRI images typically use a 5 mm kernel.                                          
% This item has a default value, set via a call to function                              
% @(val)spm_get_defaults('realign.estimate.fwhm',val{:})                                 
% Real numbers are entered.                                                              
% An 1-by-1 array must be entered. 
% ___________________________________________________________________________
% #g Smoothing (FWHM)                                                                       
% The  FWHM of the Gaussian smoothing kernel (mm) applied to the images before estimating
% the realignment parameters.                                                            
%                                                                                        
%     * PET images typically use a 7 mm kernel.                                          
%                                                                                        
%     * MRI images typically use a 5 mm kernel.                                          
% This item has a default value, set via a call to function                              
% @(val)spm_get_defaults('realign.estimate.fwhm',val{:})                                 
% Real numbers are entered.                                                              
% An 1-by-1 array must be entered. 
% ___________________________________________________________________________
% #g  Num Passes                                                                                         
% Register  to  first:  Images  are registered to the first image in the series.  Register to mean: A
% two  pass  procedure  is  used in order to register the images to the mean of the images after     
% the first realignment.                                                                                                                                                                             
% PET  images  are  typically  registered to the mean. This is because PET data are more noisy       
% than fMRI and there are fewer of them, so time is less of an issue.                                                                                                                                 
% MRI  images  are  typically  registered to the first image.  The more accurate way would be to     
% use  a two pass procedure, but this probably wouldn't improve the results so much and would        
% take twice as long to run.                                                                         
% This item has a default value, set via a call to function                                          
% @(val)spm_get_defaults('realign.estimate.rtm',val{:})                                              
% One of the following options must be selected:                                                     
% #b * Register to first   --> 0                                                                               
% #b * Register to mean    --> 1
% ___________________________________________________________________________
% #g Interpolation                                                                                    
% The method by which the images are sampled when estimating the optimum transformation.           
% Higher  degree  interpolation  methods  provide  the  better  interpolation,  but they are slower
% because they use more neighbouring voxels .                                                      
% This item has a default value, set via a call to function                                        
% @(val)spm_get_defaults('realign.estimate.interp',val{:})                                         
% One of the following options must be selected:                                                   
% * Trilinear (1st Degree)   --> 1                                                                      
% * 2nd Degree B-Spline      --> 2                                                                      
% * 3rd Degree B-Spline       ..                                                                     
% * 4th Degree B-Spline                                                                            
% * 5th Degree B-Spline                                                                            
% * 6th Degree B-Spline                                                                            
% * 7th Degree B-Spline      --> 7
% ___________________________________________________________________________
% #g Wrapping                                                                                           
% Directions in the volumes the values should wrap around in.                                        
% For  example, in MRI scans, the images wrap around in the phase encode direction, so (e.g.)        
% the subject's nose may poke into the back of the subject's head. These are typically:              
%     No  wrapping  -  for  PET  or images that have already been spatially transformed. Also the    
%     recommended option if you are not really sure.                                                 
%     Wrap  in    Y    -  for  (un-resliced)  MRI  where  phase encoding is in the Y direction (voxel
%     space).                                                                                        
% This item has a default value, set via a call to function                                          
% @(val)spm_get_defaults('realign.estimate.wrap',val{:})                                             
% One of the following options must be selected:                                                     
% * No wrap          --> [0 0 0]                                                                                          
% * Wrap X           --> [1 0 0]                                                                                
% * Wrap Y           --> [0 1 0]                                                                                  
% * Wrap X & Y       --> [1 1 0]                                                                     
% * Wrap Z           --> [0 0 1]                                                                                             
% * Wrap X & Z       --> [1 0 1]                                                                                        
% * Wrap Y & Z       --> [0 1 1]                                                                                        
% * Wrap X, Y & Z    --> [1 1 1] 
% ___________________________________________________________________________
% #g Weighting                                                                                          
% Optional  weighting  image  to  weight  each  voxel  of  the  reference  image  differently when   
% estimating the realignment parameters.                                                             
% The weights are proportional to the inverses of the standard deviations.                           
% This  would  be  used,  for  example,  when  there  is  a  lot of extra-brain motion - e.g., during
% speech, or when there are serious artifacts in a particular region of the images.                  
% ==============================================
%% #wb SPM:RESLICE OPTIONS
% ===============================================
% #g Resliced images                                                                                    
% Specify the images to reslice.                                                                                                                                                                        
% All Images (1..n) :  This reslices all the images - including the first image selected - which will
% remain in its original position.                                                                                                                                                                     
% Images 2..n :  Reslices images 2..n only. Useful for if you wish to reslice (for example) a PET    
% image to fit a structural MRI, without creating a second identical MRI volume.                                                                                                                     
% All  Images  + Mean Image :  In addition to reslicing the images, it also creates a mean of the    
% resliced image.                                                                                                                                                                                     
% Mean Image Only :  Creates the mean resliced image only.                                           
% This item has a default value, set via a call to function                                          
% @(val)spm_get_defaults('realign.write.which',val{:})                                               
% One of the following options must be selected:                                                     
% *  All Images (1..n)        --> [2 0]                                                                              
% * Images 2..n               --> [1 0]                                                                                 
% *  All Images + Mean Image  --> [2 1]                                                                        
% *  Mean Image Only          --> [0 1] 
% ___________________________________________________________________________
% #g Interpolation                                                                                        
% The method by which the images are sampled when being written in a different space.                  
% Nearest   Neighbour   is   fastest,   but  not  recommended  for  image  realignment.  Trilinear     
% Interpolation  is  probably  OK  for  PET,  but  not so suitable for fMRI because higher degree      
% interpolation  generally  gives  better  results.  Although higher degree methods provide better     
% interpolation,  but  they  are  slower  because  they  use  more  neighbouring  voxels.  Fourier     
% Interpolation  is  another  option,  but  note  that  it  is  only  implemented for purely rigid body
% transformations.  Voxel sizes must all be identical and isotropic.                                   
% This item has a default value, set via a call to function                                            
% @(val)spm_get_defaults('realign.write.interp',val{:})                                                
% One of the following options must be selected:                                                       
% * Nearest neighbour      -->0                                                                            
% * Trilinear              -->1                                                                                               
% * 2nd Degree B-Spline    -->2                                                                                 
% * 3rd Degree B-Spline    -->3                                                                                 
% * 4th Degree B-Spline    -->4                                                                                 
% * 5th Degree B-Spline    -->5                                                                                 
% * 6th Degree B-Spline    -->6                                                                                 
% * 7th Degree B-Spline    -->7                                                                                 
% * Fourier Interpolation  -->inf  
% ___________________________________________________________________________
% #g Wrapping                                                                                           
% This indicates which directions in the volumes the values should wrap around in.                   
% For  example, in MRI scans, the images wrap around in the phase encode direction, so (e.g.)        
% the subject's nose may poke into the back of the subject's head. These are typically:              
%     No wrapping - for PET or images that have already been spatially transformed.                  
%     Wrap  in    Y    -  for  (un-resliced)  MRI  where  phase encoding is in the Y direction (voxel
%     space).                                                                                        
% This item has a default value, set via a call to function                                          
% @(val)spm_get_defaults('realign.write.wrap',val{:})                                                
% One of the following options must be selected:                                                     
% * No wrap          --> [0 0 0]                                                                                          
% * Wrap X           --> [1 0 0]                                                                                
% * Wrap Y           --> [0 1 0]                                                                                  
% * Wrap X & Y       --> [1 1 0]                                                                     
% * Wrap Z           --> [0 0 1]                                                                                             
% * Wrap X & Z       --> [1 0 1]                                                                                        
% * Wrap Y & Z       --> [0 1 1]                                                                                        
% * Wrap X, Y & Z    --> [1 1 1] 
% ___________________________________________________________________________
% #g Masking                                                                                            
% Because of subject motion, different images are likely to have different patterns of zeros from    
% where  it  was  not  possible  to  sample  data.  With  masking enabled, the program searches      
% through  the  whole  time series looking for voxels which need to be sampled from outside the      
% original  images.  Where  this  occurs,  that  voxel  is  set  to  zero for the whole set of images
% (unless the image format can represent NaN, in which case NaNs are used where possible).           
% This item has a default value, set via a call to function                                          
% @(val)spm_get_defaults('realign.write.mask',val{:})                                                
% One of the following options must be selected:                                                     
% * Mask images      --> [1]                                                                                  
% * Dont mask images --> [0] 
% ___________________________________________________________________________
% #g Filename Prefix                                                                                  
% Specify the string to be prepended to the filenames of the resliced image file(s). Default prefix
% is 'r'.                                                                                          
% This item has a default value, set via a call to function                                        
% @(val)spm_get_defaults('realign.write.prefix',val{:})                                            
% A string is entered.                                                                             
% The string must have at least 1 characters. 
% 
% #ka ==============================================
% #ka  GUI/batch                                   
% #ka ==============================================
% After evaluation the 'anth'-struct contains the paramter and command for this function
% Type: char(anth) or click [anth]-BTN
% xrealign(showgui,x) wtih "showgui" (0,1) to hide/showgui the GUI and "x" the paramter struct
    



function xrealign(showgui,x,pa)


%===========================================
%%   PARAMS
%===========================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end

%===========================================
%%   %% test SOME INPUT
%===========================================
if 0
    pa={...
        'F:\data3\graham_ana4\dat\20190122GC_MPM_01'
        'F:\data3\graham_ana4\dat\20190122GC_MPM_02'};
    
    
end

%________________________________________________
%% fileList
[fl] =filelist(pa);


[fls] =filelist(pa,struct( 'NIIfile', 'firstImage'));


%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...
    'inf1'      'SECLECT EITHER "image3D"  OR  "image4D"          '                         '' ''
    'image3D'         {''}     'SELECT: a 3D-volume series to realign (only 1st image is needed to select here) '  {@selector2,fls.li,fls.hli,'out',[1 ],'selection','single'};
    'image4D'         {''}     'SELECT: a 4D-volume to realign'  {@selector2,fl.li,fl.hli,'out',[1 ],'selection','single'};
    'convertDataType'  16 'converts dataType if 4D volume is to large: [0]no..keep dataType, [16] change to single precision' {0,16}
    'merge4D'          1 'merge 3D-series to 4D-volume: [0]no,keep 3D-volumes, [1]save as 4D-volume' {0,1}
    'outputname'     ''  'optional: rename outputfile; if empty the output-filename is "roptions_prefix"+"inputfilename"' ''
  
    'isparallel'     1  'parallel-processing: [0]no,[1]yes'  'b'
'inf20' '%' '' ''    
    
'inf33' '___ ESTIMATION OPTIONS __________' '' ''    
'eoptions_quality'    0.9     'Quality versus speed trade-off {0-1},Highest   quality   (1)   gives   most   precise   results'  ''
'eoptions_sep'        1      'The separation (in mm) between the points sampled in the reference image.'  ''
'eoptions_fwhm'      .5      'SMOOTHING: FWHM of the Gaussian smoothing kernel (mm) applied to the images before estimating'  ''
'eoptions_rtm'        0      '[0]Register  to  first:  Images  are registered to the first image in the series. [1]  Register to mean..'  ''
'eoptions_interp'     2      'Interpolation: Method by which the images are sampled when estimating the optimum transformation. '  ''
'eoptions_wrap'     [0 0 0]  'Wrapping: Directions in the volumes the values should wrap around in.'  ''
'eoptions_weight'     ''     'Weighting: Optional  weighting  image  to  weight  each  voxel  of  the  reference  image'  ''
'inf40' '%' '' ''
'inf44' '___ RESLICE OPTIONS __________' '' ''
'roptions_which'     [2 0]    'Specify the images to reslice..see HELP'  ''
'roptions_interp'     4       'Interpolation: The method by which the images are sampled when being written in a different space.'  ''
'roptions_wrap'      [0 0 0]  'Wrapping: This indicates which directions in the volumes the values should wrap around in.'  ''
'roptions_mask'      1        'MASKING: see HELP'  ''
'roptions_prefix'    'r'     'Filename Prefix:specify the string to be prepended to the filenames of the resliced image'  ''
    };


p=paramadd(p,x);
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[0.2604    0.3833    0.5056    0.3511 ],...
        'title',[mfilename],'info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end



xmakebatch(z,p, mfilename);


% ==============================================
%%   proceed
% ===============================================


if z.isparallel==1
    timex=tic;
    parfor i=1: length(pa)
        px=pa{i};
        f1=fullfile(px,num2str([char(z.image3D) char(z.image4D)]));
        try
            cprintf([1 .5 0],[ num2str(i) '/' num2str(length(pa)) '__REALIGNING: ' strrep(f1,[filesep],[filesep filesep]) '\n']);
        catch
            fprintf(  [ num2str(i) '/' num2str(length(pa)) '__REALIGNING: ' strrep(f1,[filesep],[filesep filesep]) '\n']);
        end
        proc(z,px);
    end
    cprintf(-[1 .5 0],sprintf(['DONE (dT=%2.2f min).\n'],toc(timex)/60));
else
    timex=tic;
    for i=1: length(pa)
        px=pa{i};
        f1=fullfile(px,num2str([char(z.image3D) char(z.image4D)]));
        try
            cprintf([1 .5 0],[ num2str(i) '/' num2str(length(pa)) '__REALIGNING: ' strrep(f1,[filesep],[filesep filesep]) '\n']);
        catch
            fprintf(  [ num2str(i) '/' num2str(length(pa)) '__REALIGNING: ' strrep(f1,[filesep],[filesep filesep]) '\n']);
        end
        proc(z,px);
    end
    cprintf(-[1 .5 0],sprintf(['DONE (dT=%2.2f min).\n'],toc(timex)/60));
end






function proc(z,px)

% ==============================================
%%   input file
% ===============================================
if isempty(char(z.image4D)) && isempty(char(z.image3D))
    disp(['3D or 4D image not specified: ' ]);
    return
end

flist={char(fullfile(px,z.image3D)) ; char(fullfile(px,z.image4D))};
existfiles=[exist(flist{1}) exist(flist{2})];
itype=find(existfiles==2);
if itype==1
    is4D=0;
    f1=char(fullfile(px,z.image3D)); %1st-image in 3D series
elseif itype==2
    is4D=1;
    f1=char(fullfile(px,z.image4D)); %4D-volume
end




if exist(f1)~=2
    disp(['image not found: '  f1]);
    return
end
 timx=tic;
% ==============================================
%%   convert DATATYPE if IMAGE IS TO LARGE
% ===============================================
[~, name, ext]=fileparts(f1);

if is4D==1 && z.convertDataType~=0
    % ==============================================
    %% split 4D to 3D
    % ===============================================
    
    pxtemp=fullfile(px,['temp3D__' name  ]);
    warning off;
    mkdir(pxtemp);
    
   
    fprintf('..splitting 4D-image..');
    spm_file_split(f1,pxtemp);
    fprintf(['done (dT=%2.2fmin)'],toc(timx)/60);
    
    
    % ==============================================
    %% change dataType and rewrite 4D volume
    % ===============================================
    fi= spm_select('FPList', pxtemp, ['^' name '_\d{5}.nii']);
    fi=cellstr(fi);
    
    dT=z.convertDataType;
    f2=fullfile(px, [ name num2str(dT) '.nii' ]);
    f2=fullfile(px, [ 'r_' name  '.nii' ]);
    
    fprintf('..creating 4D-image with changed dataType..');
    V4 = spm_file_merge(fi,f2,dT);
    fprintf(['done (dT=%2.2fmin'],toc(timx)/60);
    
    mergedImage=f2;
    % ==============================================
    %% cleanUp temp-folder
    % ===============================================
    if exist(pxtemp)==7
        rmdir(pxtemp,'s');
    end
    
elseif is4D==1 && z.convertDataType==0
    f2=f1;
elseif is4D==0 %---------------------------------------3D-data
    
    
end


% ==============================================
%%   REALIGN-1: FILES
% ===============================================
if is4D==1
    [~,name2]=fileparts(f2);
    f3= spm_select('ExtFPList', px, ['^' name2 '.nii$']);
    
else
    [~ ,namex,ext]=fileparts(f1);
    %namestem=regexprep(namex,'_00+1$','');
    %namestem=regexprep(namex,'.*_0?1.nii$','')
    namestem=namex(1:strfind(namex,'_')-1);
    
    %f2= spm_select('FPList', px, ['^' namestem '_0\d+' '.nii$']);
    f2= spm_select('FPList', px, ['^' namestem '_0?\d+' '.nii$']);
    f2=cellstr(f2);
    f2=natsort(f2);
    f3=f2;    
    
    
    [~,name2]=fileparts(f3{1});
    
end

% ==============================================
%%   REALIGN-2: batch
% ===============================================

% matlabbatch{1}.spm.spatial.realign.estwrite.data = {f1};
% matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
% matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 1;
% matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = .5;
% matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 0;
% matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
% matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
% matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
% matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 0];
% matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
% matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
% matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
% matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';

matlabbatch{1}.spm.spatial.realign.estwrite.data = {cellstr(f3)};
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality =z.eoptions_quality ;% 0.9;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep     =z.eoptions_sep     ;% 1;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm    =z.eoptions_fwhm    ;% .5;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm     =z.eoptions_rtm     ;%  0;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp  =z.eoptions_interp  ;% 2;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap    =z.eoptions_wrap    ;% [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight  =z.eoptions_weight  ;% '';

matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which   =z.roptions_which   ;% [2 0];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp  =z.roptions_interp  ;% 4;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap    =z.roptions_wrap    ;% [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask    =z.roptions_mask    ;% 1;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix  =z.roptions_prefix  ;% 'r';


if isfield(z,'debug')==1 && z.debug==1  %DEBUG MODE
    spm_jobman('interactive',matlabbatch)
end
% ==============================================
%%   REALIGN-2: RUN BATCH
% ===============================================
% spm_jobman('run',matlabbatch)
% toc
% 
fprintf('..realign Data..');
% [o1 o2]=spm_jobman('run',matlabbatch);
[arg o1 o2]=evalc('spm_jobman(''run'',matlabbatch)');
fprintf(['done (dT=%2.2fmin)\n'],toc(timx)/60);


[~, animal]=fileparts(px);



% ==============================================
%%   convert 4D from 3D timeseries
% ===============================================
if is4D==0 && z.merge4D==1
    % ==============================================
    %% change dataType and rewrite 4D volume
    % ===============================================
    name=[ z.roptions_prefix namestem];
    fi   =o1{1}.sess.rfiles;
    
    dT=z.convertDataType;
    f2=fullfile(px, [ name   '.nii' ]);
    
    fprintf('..creating 4D-image ..');
    V4 = spm_file_merge(fi,f2,dT);
    fprintf(['Done (dT=%2.2fmin)\n'],toc(timx)/60);
    
    %% delete 3D-series
    for i=1:length(fi)
        delete(fi{i});
    end
   
    f4=f2;
    if ~isempty(z.outputname)
        f5=fullfile(px,[strrep(z.outputname,'.nii','') '.nii']);
        movefile(f4,f5,'f');
        showinfo2(['alignedFile(4D)[' animal ']' ],f5);
    else
        showinfo2(['alignedFile(4D)[' animal ']' ],f4);
    end
    
    
elseif is4D==0 && z.merge4D==0
    %% keep 3D data-series
    if ~isempty(z.outputname)
        fis=o1{1}.sess.rfiles;
        [pas nams ext ]=fileparts2(fis);
        namsnew=regexprep(nams, [ z.roptions_prefix namestem ] ,strrep(z.outputname,'.nii',''));
        fis2=cellfun(@(a,b,c){[ a filesep b c ]},pas,namsnew,ext);
        movefilem(fis,fis2);
        
        f5  =fis2{1};
        showinfo2(['aligned series(1st image)[' animal ']' ],f5);
        
    else
        f4  =o1{1}.sess.rfiles{1};
        showinfo2(['aligned series(1st image)[' animal ']' ],f4);
    end
else
    f4=fullfile(px,[z.roptions_prefix  name2 '.nii']);
    if ~isempty(z.outputname)
        f5=fullfile(px,[strrep(z.outputname,'.nii','') '.nii']);
        movefile(f4,f5,'f');
        showinfo2(['alignedFile(4D)[' animal ']' ],f5);
        
        rpfile0=fullfile(px,['rp_' name2 '.txt']);
        if exist(rpfile0)==2
           rpfile=fullfile(px,[ strrep(z.outputname,'.nii','')  '_rp'  '.txt']);
            movefile(rpfile0,rpfile,'f');
        end
        
    else
        showinfo2(['alignedFile(4D)[' animal ']' ],f4);
    end
end

% ==============================================
%%   cleanup
% ===============================================

% if exist(mergedImage)==2
try; delete(mergedImage); end
try; matfile=strrep(mergedImage,'.nii','.mat');
    
    
    if exist(matfile)==2
        try; delete(matfile); end
    end
end
% end

try; delete(stradd(f2,'r',1)); end












% ==============================================
%%   fileList
% ===============================================

function [fl] =filelist(pa,pp)

p0.NIIfile='all';
if exist('pp')~=0
   p0=catstruct(p0,pp); 
end

% -----FILTERType
if strcmp(p0.NIIfile,'all')
    flt=['.*.nii$'];
elseif strcmp(p0.NIIfile,'firstImage')
%     flt=['.*_0+1.nii$'];
    flt='.*_0?1.nii$';
end


fi2={};
for i=1:length(pa)
    [files,~] = spm_select('FPList',pa{i},flt);
    if ischar(files); files=cellstr(files);   end;
    fi2=[fi2; files];
end
[px fis ext  ]=fileparts2(fi2);
namesLong=cellfun(@(a,b){[ a b ]},fis,ext);
names=unique(namesLong);

[r r2]=ismember(namesLong,names);
counts=histc(r2, unique(r2));
tx={};[names cellstr(num2str(counts))];
for i=1:length(names)
    ix=min(find(r2==i));
    firstfile=fi2{ix};
    h=spm_vol(firstfile);
    if ~isempty(h)
        h1=h(1);
        if length(h)>1
            dims=sprintf('%dx%dx%dx%d',h1.dim,length(h));
            ndims='4';
        else
            dims=sprintf('%dx%dx%d',h1.dim) ;
            ndims='3';
        end
        %----BYTE
        k=dir(firstfile);
        MB=sprintf('%8.2fMB', k.bytes/1e6);
        
        %---date
        %Date=k.date;
        Date=datestr(k.datenum,'yy/mm/dd HH:MM:SS');
        %#### agglom ###
        tx(end+1,:)={names{i} num2str(counts(i))   dims ndims  MB  Date};
    end
end


fl.hli={'file' 'counts' 'dims' 'Ndims' 'size(MB)'  'Date'};
if isempty(tx)
   tx=repmat({''},[1  length(fl.hli)]) ;
end
fl.li =tx;



%
% tx
% selector2(li,hli,'out','list','selection','single')


% ==============================================
%%
% ===============================================














