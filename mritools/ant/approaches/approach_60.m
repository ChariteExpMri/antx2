% #ok approach_60: 
% #b DETAILS: 
% #b t2.nii is registered onto a sample t2w-image which is in  
% #b standard/atlas space 
% #k moving IMAGE brainmask:  - not created, not used
% #k                                                
% #k moving IMAGE:  #kc "t2.nii" #kw used
% #r               -no brain mask used
% #k fixed  IMAGE:  #kc "sample.nii" #kw used withfollowing properties: 
% #r                   (1) "sample.nii" is a t2w-image 
% #r                   (2) "sample.nii" must be in standard/atlas space              
% #r                   (3) must be located in the template's folder
% #r                   (4) must be named "sample.nii"
% #k PARAMETERFILE
% #k   changes in  affine parameter-file
% #k         -for "rat"   --> 'MaximumStepLength' set to 1 
% #k         -for "mouse" --> 'MaximumStepLength' set to 0.1 
            



function approach_60(s)


%% % ===============================================  
%%  [1]  INPUT parameter
%% % ===============================================  

parafiles=s.elxParamfile;
load(fullfile(s.pa,'reorient.mat'));

%% % ===============================================  
%%  [2]  make MOUSE-BRAINMASK
%% % ===============================================  



%% % ===============================================  
%%  [3]  make MOUSE IMAGE FOR REGISTRATION
%% % ===============================================  

useMASK=0;
% disp(['useMASK: ' num2str(useMASK)]);
% %%
% [ha  a] =rgetnii(fullfile(s.pa, 'c1t2.nii'));
% [hb  b] =rgetnii(fullfile(s.pa, 'c2t2.nii'));
% [hd  d] =rgetnii(fullfile(s.pa, 'c3t2.nii'));


[ha c] =rgetnii(fullfile(s.pa, 't2.nii'));
ha=rmfield(ha,{'private' 'pinfo'});
mouseMASK=fullfile(s.pa,'MSKmouse.nii');
rsavenii(mouseMASK,ha,c,[16 0]);
v=  spm_vol(mouseMASK);
spm_get_space(mouseMASK,      inv(M) * v.mat);

%% % ===============================================  
%% [4]  make TEMPLATE IMAGE FOR REGISTRATION
%% % ===============================================  

patemp=fullfile(fileparts(fileparts(s.pa)),'templates');
fisample0=fullfile(patemp,'sample.nii');
fisample1=fullfile(s.pa,'sample.nii');
ref      =fullfile(patemp,'AVGT.nii');
if exist(fisample0)~=2;
    error('"sample.nii" not found in templates-path');
end

rreslice2target(fisample0, ref, fisample1, 1);


[hf f] =rgetnii(fisample1);
tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
ha=rmfield(hf,{'private' 'pinfo'});
rsavenii(tpmMASK,hf,f,[16 0]);



%% % ===============================================  
%%  [5]  copy & modify PARAMETERFILES
%% % ===============================================  

if isfield(s,'species') && strcmp(s.species,'rat')  %##RAT
    parafiles2=replacefilepath(parafiles(:),s.pa);
    copyfilem(parafiles,parafiles2)
    set_ix2(parafiles2{1},'MaximumStepLength', 1); %
    %%rm_ix2(parafiles2{2},'MaximumStepLength'); <# etwas schlechter
    %         //(MaximumStepLength 0.006)
    %         //(MaximumStepLength 0.145833)
    %         (MaximumStepLength 0.009)  ...MOUSE
else
    parafiles2=replacefilepath(parafiles(:),s.pa); %##MOUSE
    copyfilem(parafiles,parafiles2)
%     set_ix2(parafiles2{1},'MaximumStepLength', .1); % change: MaximumStepLength
    %rm_ix2(parafiles2{1},'MaximumStepLength'); % remove Mouse-specific parameter    
    % (FinalBSplineInterpolationOrder 3)
    % set_ix2(parafiles2{1},'FinalBSplineInterpolationOrder', 1); %
    
end
%% % ===============================================  
%%  [6]  calculate ELASTIX-PARAMETER
%% % ===============================================  
fixim  =     tpmMASK;
movim  =     mouseMASK;
doelastix('calculate' ,s.pa, {fixim movim}             ,parafiles2)   ;
doelastix('transform' ,s.pa, {fullfile(s.pa,'t2.nii')} ,3,M ); %transform "t2.nii"
%% % ===============================================  
%%   [7]    clean-up
%% % ===============================================  
if s.cleanup==1
    try; delete(tpmMASK);end
    try; delete(mouseMASK);end
    try; delete(brainmaskref);end
    try; delete(parafiles2);end
end
