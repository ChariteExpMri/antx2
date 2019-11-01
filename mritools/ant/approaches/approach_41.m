% #ok approach_21: 
% #b DETAILS: 
% #k moving IMAGE brainmask:  #r no mask generated, not used
% #k 
% #k 
% #k moving IMAGE: #bc "t2.nii"
% #k               -no mask used
% #k fixed  IMAGE: #bc "AVGT.nii"
% #r               -image is masked by "ANO.nii>0" to deal with 
% #r                DEVIATIONS BETWEEN ANO.nii and templates TPM's
% #r                and additionally masked by "AVGTmask.nii"
% #k PARAMETERFILE
% #k   changes in  affine parameter-file
% #k         -for "rat"   --> 'MaximumStepLength' set to 1 
% #k         -for "mouse" --> 'MaximumStepLength' set to 0.1 
            



function approach_21(s)


% =============================================== 
%%  [1]  INPUT parameter
% =============================================== 

parafiles=s.elxParamfile;
load(fullfile(s.pa,'reorient.mat'));

% =============================================== 
%%  [2]  make MOUSE-BRAINMASK
% =============================================== 



% =============================================== 
%%  [3]  make MOUSE IMAGE FOR REGISTRATION
% =============================================== 


%*************************************************
%% USE "t2.nii"
%*************************************************
[hmt mt] =rgetnii(fullfile(s.pa, 't2.nii'));
c=mt;
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
rsavenii(mouseMASK,hmt,c,[16 0]);
v=  spm_vol(mouseMASK);
spm_get_space(mouseMASK,      inv(M) * v.mat);

% =============================================== 
%% [4]  make TEMPLATE IMAGE FOR REGISTRATION
% =============================================== 

%*************************************************
%% USE "AVGT.nii"
%*************************************************
[hmt mt] =rgetnii(fullfile(s.pa, 'AVGT.nii'    ));
[hma ma] =rgetnii(fullfile(s.pa, 'AVGTmask.nii'));
c=mt;
c=round(normalize01(c).*500);

%*************************************************
[hano ano] =rgetnii(fullfile(s.pa, 'ANO.nii'));
c=c.*(ano>0);

tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
rsavenii(tpmMASK,hmt,c,[16 0]);



% =============================================== 
%%  [5]  copy & modify PARAMETERFILES
% =============================================== 

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
% =============================================== 
%%  [6]  calculate ELASTIX-PARAMETER
% =============================================== 
fixim  =     tpmMASK;
movim  =     mouseMASK;
doelastix('calculate' ,s.pa, {fixim movim}             ,parafiles2)   ;
doelastix('transform' ,s.pa, {fullfile(s.pa,'t2.nii')} ,3,M ); %transform "t2.nii"
% =============================================== 
%%   [7]    clean-up
% =============================================== 
if s.cleanup==1
    try; delete(tpmMASK);end
    try; delete(mouseMASK);end
    try; delete(brainmaskref);end
    try; delete(parafiles2);end
end
