% #ok approach_1: 
% #b DETAILS: 
% #k moving IMAGE brainmask:  - not created, not used
% #k                           
% #k                        
% #k moving IMAGE: combination of #gy gray & white TPM #kw +offset
% #r               -no brain mask used
% #k fixed  IMAGE: -combination of #gy gray & white TPM #kw +offset
% #r               -image is masked by "ANO.nii>0" to deal with 
% #r                DEVIATIONS BETWEEN ANO.nii and templates TPM's
% #k PARAMETERFILE
% #k   changes in  affine parameter-file
% #k         -for "rat"   --> 'MaximumStepLength' set to 1 
% #k         -for "mouse" --> 'MaximumStepLength' set to 0.1 
            



function approach_1(s)


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
disp(['useMASK: ' num2str(useMASK)]);
%%
[ha  a] =rgetnii(fullfile(s.pa, 'c1t2.nii'));
[hb  b] =rgetnii(fullfile(s.pa, 'c2t2.nii'));
[hd  d] =rgetnii(fullfile(s.pa, 'c3t2.nii'));

c=a*10000+b*20000+1000;
c=round(normalize01(c).*500);

mouseMASK=fullfile(s.pa,'MSKmouse.nii');
if exist(fullfile(s.pa,'masklesion.nii'))==2
    [he e ]=rreslice2target(fullfile(s.pa,'masklesion.nii'), fullfile(s.pa, 'c1t2.nii'), []);
    e(e<.5)=0; e(e>.5)=1;
    
    v1=c.*(e==1); v1(v1==0)=nan;
    v2=c.*(e==0); v2(v2==0)=nan;
    v22=v2(:);v22(isnan(v22))=[];
    v22=sort(v22);
    %     val=v22( round(length(v22)*0.001) );
    %     val=v22(1);
    val=2000;
    c(e==1)=c(e==1)./3;
end
rsavenii(mouseMASK,ha,c,[16 0]);
v=  spm_vol(mouseMASK);
spm_get_space(mouseMASK,      inv(M) * v.mat);

%% % ===============================================  
%% [4]  make TEMPLATE IMAGE FOR REGISTRATION
%% % ===============================================  


[ha  a] =rgetnii(fullfile(s.pa, '_tpmgrey.nii'));
[hb  b] =rgetnii(fullfile(s.pa, '_tpmwhite.nii'));
[hd  d] =rgetnii(fullfile(s.pa, '_tpmcsf.nii'));
%====================================================    # configuration #
c=a*10000+b*20000+1000;
%c=a*10000+1000; %good with ANO

[hano ano] =rgetnii(fullfile(s.pa, 'ANO.nii'));
c=c.*(ano>0);
tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
rsavenii(tpmMASK,ha,c,[16 0]);



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
