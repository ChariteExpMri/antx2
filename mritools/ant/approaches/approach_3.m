% #ok approach_3: 
% #b DETAILS: 
% #k moving IMAGE brainmask:  - using gray & white TPM,
% #k                          - fill holes in mask
% #k                          - remove pixels outide mask+smoooth mask
% #k moving IMAGE: combination of #gy gray & white TPM #kw +offset
% #r               -image is masked by brainmask
% #k fixed  IMAGE: -combination of #gy gray & white TPM #kw +offset
% #r               -image is masked by "AVGTmask.nii" 
% #k                 #wr  no "ANO.nii"-MASKING !!!
% #k PARAMETERFILE
% #k   changes in  affine parameter-file
% #k         -for "rat"   --> 'MaximumStepLength' set to 1 
% #k         -for "mouse" --> 'MaximumStepLength' set to 0.1 
            



function approach_3(s)


% =============================================== 
%%  [1]  INPUT parameter
% =============================================== 

parafiles=s.elxParamfile;
load(fullfile(s.pa,'reorient.mat'));

% =============================================== 
%%  [2]  make MOUSE-BRAINMASK
% =============================================== 

brainmaskref =fullpath(s.pa,'brainmaskref.nii');
makebrainmask3({fullfile(s.pa, 'c1t2.nii'); fullfile(s.pa, 'c2t2.nii')}, .1,brainmaskref);
[ho  o]=rgetnii(brainmaskref);

%-remove isolated pixels outside mask (TPMS are pixelated)
o2=o;
sizeD=2;
for i=1:size(o2,3)
    u1=o(:,:,i);
    u2=imerode(u1,strel('disk',sizeD));
    u3=bwlabeln(u2);
    uni=unique(u3(:)); uni(uni==0)=[];
    if ~isempty(uni)
        cuni=histc(u3(:),uni);
        is=min(find(cuni==max(cuni)));
        u4=single(u3==uni(is));
        u5=imdilate(u4,strel('disk',sizeD));
        o2(:,:,i)=u5;
    end
end
o=o2;
rsavenii( brainmaskref,ho,o );


% =============================================== 
%%  [3]  make MOUSE IMAGE FOR REGISTRATION
% =============================================== 

useMASK=1;


[ha  a] =rgetnii(fullfile(s.pa, 'c1t2.nii'));
[hb  b] =rgetnii(fullfile(s.pa, 'c2t2.nii'));
[hd  d] =rgetnii(fullfile(s.pa, 'c3t2.nii'));

c=a*10000+b*20000+1000;
c=round(normalize01(c).*500);
% c=a.*10000+b*20000;
%     c=a.*10000+b*20000+d*40000;
%====================================================    # configuration #
%c=a*10000+1000;  %-->good results with ANO
%c=a*10000+b*20000+((d>0.3)*0); % set CSF->ZERO  --> good results
%c=a.*10000+b*20000+d*40000;% PREVIOUSLY USED
%c=a.*10000+b*20000+((d>0.3)*60000); c=c.*(d<0.3); % currently tested
%====================================================
%   c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
%         c=(10000*a.*double(a>.1));
%   c=(10000*b.*double(b>.1));
% c=a.*10000+b*20000;

%*************************************************
% %% TEST-MT
% [hmt mt] =rgetnii(fullfile(s.pa, 'mt2.nii'));
% c=mt.*o;
%*************************************************

if useMASK==1
    c=c.*double(o>0); % USE MASK
end
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

% =============================================== 
%% [4]  make TEMPLATE IMAGE FOR REGISTRATION
% =============================================== 


[ha  a] =rgetnii(fullfile(s.pa, '_tpmgrey.nii'));
[hb  b] =rgetnii(fullfile(s.pa, '_tpmwhite.nii'));
[hd  d] =rgetnii(fullfile(s.pa, '_tpmcsf.nii'));
%====================================================    # configuration #
c=a*10000+b*20000+1000;
%c=a*10000+1000; %good with ANO

% [hano ano] =rgetnii(fullfile(s.pa, 'ANO.nii'));
% c=c.*(ano>0);

%c=a*10000+b*20000+((d>0.3)*0); % set CSF->ZERO   --> good results
% c=a.*10000+b*20000+d*40000;% PREVIOUSLY USED
%c=a.*10000+b*20000+((d>0.3)*60000);    c=c.*(d<0.3);  %currently tested
%====================================================
%     c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
%   c=(10000*a.*double(a>.1));
%   c=(10000*b.*double(b>.1));
% c=a.*10000+b*20000;
% c=a.*10000;
% c=b.*10000;

%*************************************************
% %% TEST-MT
% [hmt mt] =rgetnii(fullfile(s.pa, 'AVGT.nii'    ));
% [hma ma] =rgetnii(fullfile(s.pa, 'AVGTmask.nii'));
% 
% c=mt.*ma;
% c=round(normalize01(c).*500);
%*************************************************

if useMASK==1
    [hm m]=rgetnii(fullfile(s.pa, 'AVGTmask.nii'));
    c=c.*double(m);  % USE MASK
end
tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
rsavenii(tpmMASK,ha,c,[16 0]);



% =============================================== 
%%  [5]  copy & modify PARAMETERFILES
% =============================================== 

if isfield(s,'species') && strcmp(s.species,'rat')  %##RAT
    parafiles2=replacefilepath(parafiles(:),s.pa);
    copyfilem(parafiles,parafiles2)
    set_ix2(parafiles2{1},'MaximumStepLength', 1); %
    %%rm_ix2(parafiles2{2},'MaximumStepLength'); <# etwas schlechter
    %         //(MaximumStepLength 0.006),(MaximumStepLength 0.145833)
elseif isfield(s,'species') && strcmp(s.species,'cat')  %##CAT
    parafiles2=replacefilepath(parafiles(:),s.pa);
    copyfilem(parafiles,parafiles2)
    set_ix2(parafiles2{1},'MaximumStepLength', 1); %
    set_ix2(parafiles2{2},'MaximumStepLength', 1); % default(MaximumStepLength 0.015)
   % rm_ix2(parafiles2{2},'MaximumStepLength');
    
   set_ix2(parafiles2{2},'MaximumNumberOfIterations', 2000);
%     set_ix2(parafiles2{2},'FinalGridSpacingInVoxels', [2 2 2]);
    
    %%rm_ix2(parafiles2{2},'MaximumStepLength'); <# etwas schlechter
    %         //(MaximumStepLength 0.006),(MaximumStepLength 0.145833)
else
    parafiles2=replacefilepath(parafiles(:),s.pa); %##MOUSE
    copyfilem(parafiles,parafiles2)
    % set_ix2(parafiles2{1},'MaximumStepLength', .1); % change: MaximumStepLength
    % rm_ix2(parafiles2{1},'MaximumStepLength'); % remove Mouse-specific parameter    
    % (FinalBSplineInterpolationOrder 3)
    % set_ix2(parafiles2{1},'FinalBSplineInterpolationOrder', 1); %
    %         (MaximumStepLength 0.009)  ...MOUSE
end
% =============================================== 
%%  [6]  calculate ELASTIX-PARAMETER
% =============================================== 
fixim  =     tpmMASK;
movim  =     mouseMASK;

pp.calcforwardonly = 0; %calc FORWARD transformation only 
doelastix('calculate' ,s.pa, {fixim movim}             ,parafiles2,[],pp)   ;
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
