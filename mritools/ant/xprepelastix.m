


function xprepelastix(s)
%
% function xprepelastix(s,approach)
% s       :  extended s.wa-structure
% approach:  aproach-number  (defined in s.elxMaskApproach  )


% if 0
%
%     approach=s.elxMaskApproach
%     xprepelastix(s,approach)
% end
%% ===============================================
if exist(char(num2str(char(s.elxMaskApproach))))==2 % explicit path
    fun= char(s.elxMaskApproach);
    pacurr=pwd;
    [px fis ext]=fileparts(fun);
    cd(fileparts(fun));
    disp(['..using APPROACH: ' fun]);
    feval(fis,s);
    cd(pacurr);
else
    if isnumeric(s.elxMaskApproach)                 % numeric
        fun=['approach_' num2str(s.elxMaskApproach)];
    else                                            %string
       fun=['approach_' (s.elxMaskApproach)]; 
    end
    disp(['..using APPROACH: ' fun]);
    feval(fun,s); 
end
%% ===============================================

    
% if isnumeric(s.elxMaskApproach)
%     fun=['approach_' num2str(s.elxMaskApproach)];
%    disp(['..using APPROACH : ' fun]); 
%    feval(fun,s);
%     
% else %EXTERNAL FILE
%    fun= char(s.elxMaskApproach);
%    pacurr=pwd;
%    [px fis ext]=fileparts(fun);
%    cd(fileparts(fun));
%    disp(['..using APPROACH : ' fun]);
%    feval(fis,s);
%    cd(pacurr);
% end






return


%%     INPUT parameter
parafiles=s.elxParamfile;
load(fullfile(s.pa,'reorient.mat'));



% =============================================================
%% APPROACH -1
% =============================================================
if approach==-1
    % ====================
    %%  [1]  make MOUSE-MASK
    % ====================
    [ha  a]=rgetnii(fullfile(s.pa, 'c1t2.nii'));
    c=a.*10000;
    mouseMASK=fullfile(s.pa,'MSKmouse.nii');
    rsavenii(mouseMASK,ha,c,[16 0]);
    
    v=  spm_vol(mouseMASK); %reorient IMAGW
    spm_get_space(mouseMASK,      inv(M) * v.mat);
    
    % ====================
    %%  [2]  make TEMPLATE-MASK
    % ====================
    [ha  a]=rgetnii(fullfile(s.pa, '_tpmgrey.nii'));
    c=a.*10000;
    tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    rsavenii(tpmMASK,ha,c,[16 0]);
    % ====================
    %%  [3]    calculate ELASTIX-PARAMETER;
    % ====================
    fixim  =     tpmMASK;
    movim  =     mouseMASK;
    doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles)   ;
    %doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles,{fixim movim})   ;
    
    % ====================
    %%  [4]    tests-transformation;
    % ====================
    if 0
        doelastix('transforminv'  , s.pa,    {fullfile(s.pa,'AVGT.nii')}  ,3,M );
        doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M );
    end
    % ====================
    %%  [5]    clean-up
    % ====================
    if s.cleanup==1
        try; delete(tpmMASK);end
        try; delete(mouseMASK);end
    end
end






% =============================================================
%% APPROACH-0
% =============================================================
if approach==0
    % ====================
    %%  [1]  make MOUSE-MASK
    % ====================
    [ha  a]=rgetnii(fullfile(s.pa, 'c1t2.nii'));
    [hb b]=rgetnii(fullfile(s.pa, 'c2t2.nii'));
    [hd d]=rgetnii(fullfile(s.pa, 'c3t2.nii'));
    c=a.*10000+b*20000+d*40000;
    % c=a.*10000+b*20000;
    mouseMASK=fullfile(s.pa,'MSKmouse.nii');
    rsavenii(mouseMASK,ha,c,[16 0]);
    
    v=  spm_vol(mouseMASK); %reorient IMAGW
    spm_get_space(mouseMASK,      inv(M) * v.mat);
    
    % ====================
    %%  [2]  make TEMPLATE-MASK
    % ====================
    [ha  a]=rgetnii(fullfile(s.pa, '_tpmgrey.nii'));
    [hb b]=rgetnii(fullfile(s.pa, '_tpmwhite.nii'));
    [hd d]=rgetnii(fullfile(s.pa, '_tpmcsf.nii'));
    % c=a.*10000+b*20000;
    c=a.*10000+b*20000+d*40000;
    tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    rsavenii(tpmMASK,ha,c,[16 0]);
    % ====================
    %%  [3]    calculate ELASTIX-PARAMETER;
    % ====================
    fixim  =     tpmMASK;
    movim  =     mouseMASK;
    doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles)   ;
    %doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles,{fixim movim})   ;
    
    % ====================
    %%  [4]    tests-transformation;
    % ====================
    if 0
        doelastix('transforminv'  , s.pa,    {fullfile(s.pa,'AVGT.nii')}  ,3,M );
        doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M );
    end
    % ====================
    %%  [5]    clean-up
    % ====================
    if s.cleanup==1
        try; delete(tpmMASK);end
        try; delete(mouseMASK);end
    end
end


% =============================================================
%% APPROACH-1  -using Masklesion-filler
% =============================================================
if approach==1
    % ====================
    %%  [1]  make MOUSE-MASK
    % ====================
    brainmaskref =fullpath(s.pa,'brainmaskref.nii');
    makebrainmask3({fullfile(s.pa, 'c1t2.nii'); fullfile(s.pa, 'c2t2.nii')}, .1,brainmaskref);
    
    
    
    %     if 1 %CD1
    %         disp('CD1-data-xprepelastix line 89')
    %         mask00=fullpath(s.pa,'_msk.nii');
    %         copyfile(mask00,brainmaskref,'f');
    %         [hu u]=rgetnii(brainmaskref);
    %         u=u>0;
    %         rsavenii(brainmaskref  ,hu,u);
    %
    %     end
    
    %     makebrainmask3({fullfile(s.pa, 'c1t2.nii'); fullfile(s.pa, 'c2t2.nii');; fullfile(s.pa, 'c2t2.nii')}, .1,brainmaskref);
    
    [ho  o]=rgetnii(brainmaskref);
    
    
%%  ---remove isolated pixels outside mask
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

if 1
    rsavenii( brainmaskref,ho,o );
end

 useMASK=0;
  disp(['useMASK: ' num2str(useMASK)]);
%%
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
    %% TEST-MT
     [hmt mt] =rgetnii(fullfile(s.pa, 'mt2.nii'));
     c=mt.*o;
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
    % ====================
    %%  [2]  make TEMPLATE-MASK
    % ====================
    [ha  a] =rgetnii(fullfile(s.pa, '_tpmgrey.nii'));
    [hb  b] =rgetnii(fullfile(s.pa, '_tpmwhite.nii'));
    [hd  d] =rgetnii(fullfile(s.pa, '_tpmcsf.nii'));
    %====================================================    # configuration #
    c=a*10000+b*20000+1000; 
    %c=a*10000+1000; %good with ANO
    
    [hano ano] =rgetnii(fullfile(s.pa, 'ANO.nii'));
    c=c.*(ano>0);
    
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
    %% TEST-MT
    [hmt mt] =rgetnii(fullfile(s.pa, 'AVGT.nii'    ));
    [hma ma] =rgetnii(fullfile(s.pa, 'AVGTmask.nii'));
    
    c=mt.*ma;
    c=round(normalize01(c).*500);
    %*************************************************
    
    if useMASK==1
        [hm m]=rgetnii(fullfile(s.pa, 'AVGTmask.nii'));
        c=c.*double(m);  % USE MASK
    end
    tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    rsavenii(tpmMASK,ha,c,[16 0]);
    
    
    %     %% HIKISHIMA
    %     inp=input('HIKIshima [0|1]:');
    %     if inp==1%HIKISH
    %
    %         [he e]=rgetnii(fullfile(s.pa, 'AVGTmask.nii'));
    %         tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    %         rsavenii(tpmMASK,ha,e.*c,[16 0]);
    %
    %         %        [hf f]=rgetnii(fullfile(s.pa, 'AVGT.nii'));
    %         %        b1=makeMaskT4(f,65);
    %         %        %        rsavenii(fullfile(s.pa,'AVGTmask2.nii') , he, b1,[2 0] );
    %         %        tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    %         %        rsavenii(tpmMASK,ha,b1.*c,[16 0]);
    %
    %         f=single((a>.2)|(b>.2));
    %         b1=makeMaskT4(f,0);
    %         rsavenii(fullfile(s.pa,'MSKtemplate.nii')  ,ha,b1.*c,[16 0]);
    %     end
    
    
    % ====================
    %%  [3]    calculate ELASTIX-PARAMETER;
    % ====================
    fixim  =     tpmMASK;
    movim  =     mouseMASK;
    
    
    
    
    if isfield(s,'species') && strcmp(s.species,'rat')  % # RAT
        parafiles2=replacefilepath(parafiles(:),s.pa);
        copyfilem(parafiles,parafiles2)
        %rm_ix2(parafiles2{1},'MaximumStepLength'); % remove Mouse-specific parameter 
        set_ix2(parafiles2{1},'MaximumStepLength', 1); % 
        %%rm_ix2(parafiles2{2},'MaximumStepLength'); <# etwas schlechter
        
%         
%         //(MaximumStepLength 0.006)
%         //(MaximumStepLength 0.145833)
%         (MaximumStepLength 0.009)  ...MOUSE
    else
%         parafiles2=parafiles;  %orig approach
        
       %alternative approach: change: MaximumStepLength
        parafiles2=replacefilepath(parafiles(:),s.pa);
        copyfilem(parafiles,parafiles2)
        %rm_ix2(parafiles2{1},'MaximumStepLength'); % remove Mouse-specific parameter 
%         set_ix2(parafiles2{1},'MaximumStepLength', .1); % 
        
       % (FinalBSplineInterpolationOrder 3)
       % set_ix2(parafiles2{1},'FinalBSplineInterpolationOrder', 1); % 
        
    end
    
    
    
    
    doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles2)   ;
    doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M );
    
    % ====================
    %%  [4]    tests-transformation;
    % ====================
    if 0
        doelastix('transforminv'  , s.pa,    {fullfile(s.pa,'AVGT.nii')}  ,3,M );
        doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M );
    end
    % ====================
    %%  [5]    clean-up
    % ====================
    if s.cleanup==1
        try; delete(tpmMASK);end
        try; delete(mouseMASK);end
        try; delete(brainmaskref);end
        try; delete(parafiles2);end 
    end
end

% =============================================================
%% APPROACH-2  using graymatter-mask -->           suboptimal approach !!!
% =============================================================
if approach==2
    % ====================
    %%  [1]  make MOUSE-MASK
    % ====================
    brainmaskref =fullpath(s.pa,'brainmaskref.nii');
    makebrainmask3({fullfile(s.pa, 'c1t2.nii'); fullfile(s.pa, 'c2t2.nii')}, .1,brainmaskref);
    [ho  o]=rgetnii(brainmaskref);
    
    [ha  a]=rgetnii(fullfile(s.pa, 'c1t2.nii'));
    [hb b]=rgetnii(fullfile(s.pa, 'c2t2.nii'));
    [hd d]=rgetnii(fullfile(s.pa, 'c3t2.nii'));
    % c=a.*10000+b*20000;
    thresh=.6;
    a(a<thresh)=0;
    b(b<thresh)=0;
    d(d<thresh)=0;
    
    %     c=a.*10000+b*20000+d*40000;
    %   c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
    %         c=(10000*a.*double(a>.1));
    %   c=(10000*b.*double(b>.1));
    
    % c=a.*10000+b*20000;
    % c=a.*10000;
    % c=b.*10000;
    %     c=c.*double(o>0);
    c=a;
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
    
    
    % ====================
    %%  [2]  make TEMPLATE-MASK
    % ====================
    [ha  a]=rgetnii(fullfile(s.pa, '_tpmgrey.nii'));
    [hb b]=rgetnii(fullfile(s.pa, '_tpmwhite.nii'));
    [hd d]=rgetnii(fullfile(s.pa, '_tpmcsf.nii'));
    
    a(a<thresh)=0;
    % c=a.*10000+b*20000;
    c=a.*10000+b*20000+d*40000;
    %     c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
    %   c=(10000*a.*double(a>.1));
    %   c=(10000*b.*double(b>.1));
    % c=a.*10000+b*20000;
    % c=a.*10000;
    % c=b.*10000;
    c=a;
    tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    rsavenii(tpmMASK,ha,c,[16 0]);
    
    % ====================
    %%  [3]    calculate ELASTIX-PARAMETER;
    % ====================
    fixim  =     tpmMASK;
    movim  =     mouseMASK;
    doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles)   ;
    
    % ====================
    %%  [4]    tests-transformation;
    % ====================
    if 0
        doelastix('transforminv'  , s.pa,    {fullfile(s.pa,'AVGT.nii')}  ,3,M );
        doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M );
    end
    % ====================
    %%  [5]    clean-up
    % ====================
    if s.cleanup==1
        try; delete(tpmMASK);end
        try; delete(mouseMASK);end
        try; delete(brainmaskref);end
    end
end


% ####

% =============================================================
%% APPROACH-3  using t2w image masked
% =============================================================
if approach==3
    disp('APPROACH-3');
    
    % ====================
    %%  [0]  recompute brainMask
    % ====================
    if 0
        if s.usePriorskullstrip==1
            disp('..recompute brainmask');
            t2file    =fullfile(s.pa,'mt2.nii');
            brainmask =fullfile(s.pa,'_mask.nii');
            mode    = 'mask';%'skullstrip'
            thresh  =0.1; %compartment threshold
            tolperc =5 ;%5percent
            skullstrip_pcnn3d_post(t2file, brainmask,  mode , thresh,tolperc);
            %     else
            %         brainmask =fullfile(s.pa,'_mask.nii');
            %         copyfile(fullfile(s.pa,'mt2.nii'),   brainmask,'f');
            
        end
        
        
        % ====================
        %%  [1]  make MOUSE-MASK
        % ====================
        %     brainmaskref =fullpath(s.pa,'brainmaskref.nii');
        %     makebrainmask3({fullfile(s.pa, 'c1t2.nii'); fullfile(s.pa, 'c2t2.nii')}, .1,brainmaskref);
        %
        %
        %
        %     if 1 %CD1
        %         disp('CD1-data-xprepelastix line 89')
        %         mask00=fullpath(s.pa,'_msk.nii');
        %         copyfile(mask00,brainmaskref,'f');
        %         [hu u]=rgetnii(brainmaskref);
        % %         u=u>0;
        % %         rsavenii(brainmaskref  ,hu,u);
        %
        %     end
        
        %     makebrainmask3({fullfile(s.pa, 'c1t2.nii'); fullfile(s.pa, 'c2t2.nii');; fullfile(s.pa, 'c2t2.nii')}, .1,brainmaskref);
        
        if s.usePriorskullstrip==1
            [ht t]=rgetnii(fullfile(s.pa,'mt2.nii'));
            [ho  o ]=rgetnii(brainmask);
            
            mouseMASK=fullfile(s.pa,'MSKmouse.nii');
            rsavenii(mouseMASK,ht,o.*t,[16 0]);
        else
            mouseMASK=fullfile(s.pa,'MSKmouse.nii');
            copyfile(fullfile(s.pa,'mt2.nii'),   mouseMASK,'f');
        end
        
        v=  spm_vol(mouseMASK);
        spm_get_space(mouseMASK,      inv(M) * v.mat);
    end % if 0 : 21.03.19
    
    
    % ================================================================================
    %% USING TPMS
    [ha a]=rgetnii(fullfile(s.pa, 'c1t2.nii'));
    [hb b]=rgetnii(fullfile(s.pa, 'c2t2.nii'));
    [hc c]=rgetnii(fullfile(s.pa, 'c3t2.nii'));
    
    w=(a+b)>.3;
    w2=imopen(w,strel('disk',6));
    
    % %     slicvol=squeeze(sum(sum(w2,1),2));
    % %     ix=find(slicvol>0);
    % %     w2(:,:,ix(end-2:end))=0;
    
    
    brainmaskref =fullfile(s.pa,'brainmaskref.nii');
    rsavenii(brainmaskref,ha,w2)
    %     rmricron([],s.t2,brainmaskref,1);
    
    [ht  t ]=rgetnii(fullfile(s.pa,'t2.nii'));
    [ho  o ]=rgetnii(brainmaskref);
    
    mouseMASK=fullfile(s.pa,'MSKmouse.nii');
    rsavenii(mouseMASK,ht,o.*t,[16 0]);
    
    v=  spm_vol(mouseMASK);
    spm_get_space(mouseMASK,      inv(M) * v.mat);
    %     fg,montage_p(imdilate(  imerode(w,strel('disk',3)),strel('disk',3)));
    % ================================================================================
    
    
    
    
    
    % ====================
    %%  [2]  make TEMPLATE-MASK
    % ====================
    [ha  a]=rgetnii(fullfile(s.pa, 'AVGT.nii'));
    [hm  m]=rgetnii(fullfile(s.pa, 'AVGTmask.nii'));
    
    tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    rsavenii(tpmMASK,ha,a.*m,[16 0]);
    
    
    %     %% HIKISHIMA
    %     inp=input('HIKIshima [0|1]:');
    %     if inp==1%HIKISH
    %
    %         [he e]=rgetnii(fullfile(s.pa, 'AVGTmask.nii'));
    %         tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    %         rsavenii(tpmMASK,ha,e.*c,[16 0]);
    %
    %         %        [hf f]=rgetnii(fullfile(s.pa, 'AVGT.nii'));
    %         %        b1=makeMaskT4(f,65);
    %         %        %        rsavenii(fullfile(s.pa,'AVGTmask2.nii') , he, b1,[2 0] );
    %         %        tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    %         %        rsavenii(tpmMASK,ha,b1.*c,[16 0]);
    %
    %         f=single((a>.2)|(b>.2));
    %         b1=makeMaskT4(f,0);
    %         rsavenii(fullfile(s.pa,'MSKtemplate.nii')  ,ha,b1.*c,[16 0]);
    %     end
    
    
    % ====================
    %%  [3]    calculate ELASTIX-PARAMETER;
    % ====================
    fixim  =     tpmMASK;
    movim  =     mouseMASK;
    doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles)   ;
    doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M );
    
    % ====================
    %%  [4]    tests-transformation;
    % ====================
    if 0
        doelastix('transforminv'  , s.pa,    {fullfile(s.pa,'AVGT.nii')}  ,3,M );
        doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M );
    end
    % ====================
    %%  [5]    clean-up
    % ====================
    if s.cleanup==1
        try; delete(tpmMASK);end
        try; delete(mouseMASK);end
        try; delete(brainmaskref);end
    end
end


% =============================================================
%% APPROACH-4  using t2w image masked
% =============================================================
if approach==4
    disp('APPROACH-4');
    % ====================
    %%  [0]  recompute brainMask
    % ====================
    if s.usePriorskullstrip==1
        disp('..recompute brainmask');
        t2file    =fullfile(s.pa,'mt2.nii');
        brainmask =fullfile(s.pa,'_mask.nii');
        mode    = 'mask';%'skullstrip'
        thresh  =0.1; %compartment threshold
        tolperc =5 ;%5percent
        skullstrip_pcnn3d_post(t2file, brainmask,  mode , thresh,tolperc);
    end
    % ====================
    %%  [1] define moving and fixed image
    % ====================
    fav =fullfile(s.pa,'AVGT.nii');            [ha  a  ]=rgetnii(fav);
    fam =fullfile(s.pa,'AVGTmask.nii');        [ham am ]=rgetnii(fam);
    templ=a.*am;
    tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    rsavenii(tpmMASK,ha,templ,[16 0]);
    if s.usePriorskullstrip==1
        tmo =fullfile(s.pa,'mt2.nii');            [ht  t ]=rgetnii(tmo);
        tmm =fullfile(s.pa,'_mask.nii');          [hm  tm]=rgetnii(tmm);
        mouse=tm.*t;
        mouse=(mouse./max(mouse(:))).*1000;
        mouseMASK=fullfile(s.pa,'MSKmouse.nii');
        rsavenii(mouseMASK,ht,mouse,[16 0]);
    else
        mouseMASK=fullfile(s.pa,'MSKmouse.nii');
        copyfile(fullfile(s.pa,'mt2.nii'),   mouseMASK,'f');
    end
    v=  spm_vol(mouseMASK);
    spm_get_space(mouseMASK,      inv(M) * v.mat);
    % ====================
    %%  [3]    calculate ELASTIX-PARAMETER;
    % ====================
    disp('..register image');
    tic
    fixim  =     tpmMASK;
    movim  =     mouseMASK;
    doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles)   ;
    doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M );
    toc
    % ====================
    %%  [4]    tests-transformation;
    % ====================
    if 0
        doelastix('transforminv'  , s.pa,    {fullfile(s.pa,'AVGT.nii')}  ,3,M );
        doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M );
    end
    % ====================
    %%  [5]    clean-up
    % ====================
    if s.cleanup==1
        try; delete(tpmMASK);end
        try; delete(mouseMASK);end
        try; delete(brainmaskref);end
    end
end

% =============================================================
%% APPROACH-5  using unmasked t2w and masked AVGT
% =============================================================
if approach==5
    disp('APPROACH-5');
    
    % ====================
    %%  [1] define moving and fixed image
    % ====================
    fav =fullfile(s.pa,'AVGT.nii');            [ha  a  ]=rgetnii(fav);
    fam =fullfile(s.pa,'AVGTmask.nii');        [ham am ]=rgetnii(fam);
    templ=a.*am;
    tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    rsavenii(tpmMASK,ha,templ,[16 0]);
    
    tmo =fullfile(s.pa,'t2.nii');            [ht  t ]=rgetnii(tmo);
    %tmm =fullfile(s.pa,'_msk.nii');          [hm  tm]=rgetnii(tmm);
    mouse=t;
    mouseMASK=fullfile(s.pa,'MSKmouse.nii');
    rsavenii(mouseMASK,ht,mouse,[16 0]);
    
    v=  spm_vol(mouseMASK);
    spm_get_space(mouseMASK,      inv(M) * v.mat);
    % ====================
    %%  [3]    calculate ELASTIX-PARAMETER;
    % ====================
    
    disp('..register image');
    tic
    fixim  =     tpmMASK;
    movim  =     mouseMASK;
    doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles)   ;
    doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M );
    % rmricron([],fullfile(s.pa,'x_t2.nii'),fixim,0);
    toc
    % ====================
    %%  [4]    tests-transformation;
    % ====================
    if 0
        doelastix('transforminv'  , s.pa,    {fullfile(s.pa,'AVGT.nii')}  ,3,M );
        doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M );
    end
    % ====================
    %%  [5]    clean-up
    % ====================
    if s.cleanup==1
        try; delete(tpmMASK);end
        try; delete(mouseMASK);end
        try; delete(brainmaskref);end
    end
end

% =============================================================
%% APPROACH-6
% =============================================================
if approach==6
    disp('APPROACH-6');
    
    % ========================================
    %%  [1] define moving and fixed image
    % ========================================
    fav =fullfile(s.pa,'AVGT.nii');            [ha  a  ]=rgetnii(fav);
    fam =fullfile(s.pa,'AVGTmask.nii');        [ham am ]=rgetnii(fam);
    templ=a.*am;
    tpmMASK=fullfile(s.pa,'MSKtemplate.nii');
    rsavenii(tpmMASK,ha,templ,[16 0]);
    
    
    
    tmo =fullfile(s.pa,'mt2.nii');
    [ht  t0 ] =rgetnii(tmo);
    t=reshape(imadjust(mat2gray(t0(:))),[ht.dim]) *10000 ;
    %     t=normalize01(t).*5000;
    
    [ha a]=rgetnii(fullfile(s.pa, 'c1t2.nii'));
    [hb b]=rgetnii(fullfile(s.pa, 'c2t2.nii'));
    [hc c]=rgetnii(fullfile(s.pa, 'c3t2.nii'));
    
    w=(a+b)>.3;  % old version
%     w=(a+b+c)>.45;%
    tm=imopen(w,strel('disk',6));
    
    
    
    
    if 0
        [ht  r1 ]=rgetnii(fullfile(s.pa,'c1t2.nii'));
        [ht  r2 ]=rgetnii(fullfile(s.pa,'c2t2.nii'));
        
        f2=fullfile(s.pa,'_mask.nii');
        if exist(f2)
            [hx  r3 ]=rgetnii(f2);
        else
            f2=fullfile(s.pa,'_msk.nii');
            [hx  r3 ]=rgetnii(f2);
            r3=r3>0.2;
        end
        
        c=r1+r2;
        c2= smooth3(c,'box',[3 3 1]);
        %% this
        f3=fullfile(s.pa,'_compmask.nii');
        %     rsavenii(f3,ht,(c2>0.2).*r3);
        rsavenii(f3,ht,(c2>0.2));
        % rmricron([],tmo,f3,1);
        
        
        tmm     =fullfile(s.pa,'_compmask.nii');
        [hm  tm]=rgetnii(tmm);
        mouse=tm;
    end
    
    mouseMASK=fullfile(s.pa,'MSKmouse.nii');
    
    %t0=t-min(t(:)); t0=(t0./max(t0(:))).*1000;
    t2=t;
    
    rsavenii(mouseMASK,ht,tm.*t2,[16 0]);
    v=  spm_vol(mouseMASK);
    spm_get_space(mouseMASK,      inv(M) * v.mat);
    
    % ========================================
    %%  [2]register Image/calculate ELASTIX-PARAMETER;
    % ========================================
    parmf0=s.elxParamfile;
    parmf0{1}=fullfile(fileparts(parmf0{1}),'parm038_affine.txt');
    
    z=[];
    z.parafiles= parmf0;
    z.path     = s.pa;
    z.fix1     = tpmMASK;
    z.mov1     = mouseMASK;
    z.M        = M;
    z.cleanup  = s.cleanup;
    
    %tic
    register_dual(z);
    %toc
    
    
    
    %doelastix('calculate'  ,s.pa, {fixim movim} ,parafiles)   ;
    %doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M );
    % rmricron([],fullfile(s.pa,'x_t2.nii'),fixim,0);
    
    % ====================
    %%  [4]    tests-transformation;
    % ====================
    if 0
        doelastix('transforminv'  , s.pa,    {fullfile(s.pa,'AVGT.nii')}  ,3,M );
        doelastix('transform'     , s.pa,    {fullfile(s.pa,'t2.nii')}    ,3,M );
    end
    % ====================
    %%  [5]    clean-up
    % ====================
    if s.cleanup==1
        try; delete(tpmMASK);end
        try; delete(mouseMASK);end
        try; delete(brainmaskref);end
    end
end


%=========================================
%=========================================
%=========================================
%=========================================
%%               eof
%=========================================
%=========================================
%=========================================
%=========================================









if 0 %% TEST WITH MASK
    
    %% FIXIMG
    fix0=fullfile(pa,'AVGT.nii')
    fixim=fullfile(pa,'allen.nii')
    copyfile(fix0,fixim,'f')
    % REF
    tpmref         ={ '_tpmgrey.nii' '_tpmwhite.nii' };% REF
    tpmref           =fullpath(pa,tpmref);
    brainmaskref =fullpath(pa,'brainmaskref.nii');
    makebrainmask3(tpmref, .1,brainmaskref);
    [ha a]=rgetnii(brainmaskref);
    [hb b]=rgetnii(fixim);
    c=b.*(a>0);
    rsavenii(fixim, hb,c);
    %% MOVIMG
    
    mov0=fullfile(pa,'t2.nii');
    movim=fullfile(pa,'mouse.nii');
    copyfile(mov0,movim,'f');
    
    [ha a]=rgetnii(fullfile(pa,'_test1.nii'));
    [hb b]=rgetnii(movim);
    c=b;%.*(a>0);
    [hd d ]=rreslice2target(fullfile(pa,'masklesion.nii'), movim, []);
    
    val=c(d>0);
    valx=median(val).*.7;
    e=c;
    e(d>0)=valx;
    rsavenii(movim, hb,e);
    
    v=  spm_vol(movim);
    spm_get_space(movim,    inv(M) * v.mat);
    
    doelastix('calculate'  ,pa, {fixim movim} ,parafiles,{[] []})   ;
end













return
if 0
    
    %% make masks
    path=pa;
    tpm           ={ 'c1t2.nii' 'c2t2.nii' };
    tpm           =fullpath(path,tpm);
    brainmask=fullpath(path,'brainmask.nii');
    lesionmask=fullpath(path,'masklesion.nii');
    
    makebrainmask3(tpm, .1,brainmask);
    % makebrainmask3({ 'c1T2.nii' 'c2T2.nii' }, .1, 'brainmask.nii')
    [ h a]=rgetnii(brainmask);
    % [ hm b]=rgetnii(lesionmask);
    [hm b ]=rreslice2target(lesionmask, brainmask, []);
    a2=a;
    a2(b==1)=0;
    brainNoLesionMask=fullpath(path,'brainNoLesionMask.nii'); %% MASK USED
    rsavenii(brainNoLesionMask,h,a2 );
    v=  spm_vol(brainNoLesionMask);
    spm_get_space(brainNoLesionMask,    inv(M) * v.mat);
    
    
    % REF
    tpmref         ={ '_tpmgrey.nii' '_tpmwhite.nii' };% REF
    tpmref           =fullpath(path,tpmref);
    brainmaskref =fullpath(path,'brainmaskref.nii');
    makebrainmask3(tpmref, .1,brainmaskref);
    
    ff=@(a,b)fullfile(a,b);
    pa            =path;
    fixim     =ff(pa, 'AVGT.nii');
    
    
    movim =ff(pa, 'mouseMask.nii');
    copyfile(ff(pa, 't2.nii'),  movim,'f');
    v=  spm_vol(movim);
    spm_get_space(movim,    inv(M) * v.mat);
    
    fix_mask      =brainmaskref ;%% ff(pa, 'c1c2mask.2.nii')
    mov_mask = brainNoLesionMask ;%ff(pa, 'brainNoLesionMask.nii')  %mov_mask =ff(pa, 'brainNoLesionMask3.nii')
    
    disp(fixim);
    disp(movim);
    disp(fix_mask);
    disp(mov_mask);
    %         doelastix('calculate'  ,pa, {fixim movim} ,parafiles,{[],[]})   ;
    doelastix('calculate'  ,pa, {fixim movim} ,parafiles,{fix_mask,mov_mask})   ;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %    disp('use approach-2 (warp with masklesion)');
    % % =============================================================
    % %% approach 2 using lesionMask
    % % =============================================================
    % path=pa;%% make masks
    % tpm           ={ 'c1t2.nii' 'c2t2.nii' };
    % tpm           =fullpath(path,tpm);
    % brainmask=fullpath(path,'brainmask.nii');
    % lesionmask=fullpath(path,'masklesion.nii');
    %
    % makebrainmask3(tpm, .1,brainmask);
    % [ h a]=rgetnii(brainmask);
    % [ hm b]=rgetnii(lesionmask);
    % a2=a;
    % a2(b==1)=0;
    % brainNoLesionMask=fullpath(path,'brainNoLesionMask.nii'); %% MASK USED
    % rsavenii(brainNoLesionMask,h,a2 );
    %
    % tpmref           ={ '_tpmgrey.nii' '_tpmwhite.nii' };% REF
    % tpmref           =fullpath(path,tpmref);
    % brainmaskref =fullpath(path,'brainmaskref.nii');
    % makebrainmask3(tpmref, .1,brainmaskref);
    %
    % % =============================================================
    % [ ha a]=rgetnii(brainmaskref);
    % [ hb b]=rgetnii(fullfile(path, 'AVGT.nii'));
    % b2=double(b).*double(a);
    % rsavenii(brainmaskref,hb,b2 );
    %
    % [ ha a]=rgetnii(brainmask);
    % [ hb b]=rgetnii(fullfile(path, 't2.nii'));
    % b2=double(b).*double(a);
    % rsavenii(brainmask,hb,b2 );
    %
    % %--------------------------
    % ff=@(a,b)fullfile(a,b);
    %  z.fiximg       =brainmaskref   ;%ff(path, 'AVGT.nii');
    %  z.movimg  =brainmask    ;   %fullfile(path,'t2.nii') ;  %%ff(pa, 'T2.nii')
    % %  z.fix_mask     =brainmaskref ;%% ff(pa, 'c1c2mask.2.nii')
    % %  z.mov_mask = brainNoLesionMask ;%ff(pa, 'brainNoLesionMask.nii')  %mov_mask =ff(pa, 'brainNoLesionMask3.nii')
    %
    % %   z.fiximg     ='O:\harms1\harms2\dat\_s20150908_FK_C1M01_1_3_1\AVGT.nii'
    % %   z.movimg  ='O:\harms1\harms2\dat\_s20150908_FK_C1M01_1_3_1\t2.nii'
    % %   %    z.outforw  =
    % %   z.fix_mask  ='O:\harms1\harms2\dat\_s20150908_FK_C1M01_1_3_1\brainmaskref.nii'
    % %   z.mov_mask='O:\harms1\harms2\dat\_s20150908_FK_C1M01_1_3_1\brainNoLesionMask.nii'
    % %
    % fiximg=brainmaskref
    % movimg=brainmask
    % fixmsk=[];
    % movmsk=[];
    %  doelastix('calculate'  ,pa, {fiximg movimg} ,parafiles,{fixmsk movmsk})   ;
    % %    [im,trfile] = run_elastix(z.fiximg,z.movimg,    z.outforw  ,parafiles,   z.fix_mask,z.mov_mask     ,[],[],[]);
    %    %     [im,trfile] = run_elastix(z.fiximg,z.movimg,    z.outforw  ,parafiles,   [],[]       ,[],[],[]);
end





% 99.5098 ;
if 0
    
    %         %% make mousemask
    %         [ha  a]=rgetnii(fullfile(pa, 'c1t2.nii'));
    %         [hb b]=rgetnii(fullfile(pa, 'c2t2.nii'));
    %         [hd d]=rgetnii(fullfile(pa, 'c3t2.nii'));
    %         % c=a.*10000+b*20000+d*40000;
    % %         c=a.*10000+b*20000;
    %         c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
    %         mouseMASK=fullfile(pa,'MSKmouse.nii');
    %         rsavenii(mouseMASK,ha,c,[16 0]);
    %
    %         v=  spm_vol(mouseMASK);
    %         spm_get_space(mouseMASK,      inv(M) * v.mat);
    %
    %         %% make templateMAKS
    %         [ha  a]=rgetnii(fullfile(pa, '_tpmgrey.nii'));
    %         [hb b]=rgetnii(fullfile(pa, '_tpmwhite.nii'));
    %         [hd d]=rgetnii(fullfile(pa, '_tpmcsf.nii'));
    %         %c=a.*10000+b*20000+d*40000;
    % %         c=a.*10000+b*20000;
    %          %c=10000*b.*double(b>.1);
    %           c=(10000*a.*double(a>.1))+(20000*b.*double(b>.1));
    %         tpmMASK=fullfile(pa,'MSKtemplate.nii');
    %         rsavenii(tpmMASK,ha,c,[16 0]);
    
    
    %         [ha  a]=rgetnii(mouseMASK);
    %         [hx  x]=rgetnii(tpmMASK);
    %
    %         [hb  b]=rgetnii(fullfile(pa,'_test1.nii'));
    %         bm=double(b~=0);
    %         c=a.*bm;
    %         rsavenii(mouseMASK,ha,c);
    %         doelastix('calculate'  ,pa, {tpmMASK mouseMASK} ,parafiles)   ;
    %         mouseMASK=fullfile(pa,'MSKmouse.nii');
    %
    %
    [hd  d]=rgetnii(fullfile(pa,'t2.nii'));
    [hb  b]=rgetnii(fullfile(pa,'_test1.nii'));
    c=d;
    c=c-min(c(:));
    c=(c./max(c(:))).*10000;
    c=c.*double(b~=0);
    %         c=round(c);
    rsavenii(mouseMASK,hd,c,[16 0]);
    
    v=  spm_vol(mouseMASK);
    spm_get_space(mouseMASK,      inv(M) * v.mat);
    
    %______________________________________
    %           [hb  b]=rgetnii(fullfile(pa,'_test1.nii'));
    %           movM=fullfile(pa, 'mask2Mouse.nii')
    %           c2=double(b~=0);
    %           rsavenii(movM,hd,c2,[2 0]);
    %
    %
    %           v=  spm_vol(movM);
    %           spm_get_space(movM,      inv(M) * v.mat);
    %          % =============================================================
    %
    %
    %         [hd  ]=rgetnii(fullfile(pa, '_tpmgrey.nii'));
    [ha a]=rgetnii(fullfile(pa, 'AVGT.nii'));
    [hb  b]=rgetnii(fullfile(pa,'_testref1.nii'));
    %        [hb b]=rgetnii(fullfile(pa, 'MSKtemplate.nii'));
    %        c=a.*(b>.10000);
    c=a.*(a>40);
    c=c-min(c(:));
    c=(c./max(c(:))).*10000;
    c=c.*double(b~=0);
    %         c=round(c);
    %c=abs(c-max(c(:))); c(c==max(c(:)))=0; %invert
    
    rsavenii(tpmMASK,ha,c,[16 0]);
    
    %______________________________________
    %        fixim2=fullfile(pa,'_testref1.nii')
    %        makebrainmask3({fullfile(pa,'_tpmgrey.nii') ;fullfile(pa,'_tpmwhite.nii')  }, .1,fixim2);
    %          [ha a]=rgetnii(fixim2);
    %          rsavenii(fixim2,ha,a,[2 0]);
    %
    %           fixM=fullfile(pa, 'mask2ref.nii')
    %         c2=double(c~=0);
    %          rsavenii(fixM,ha,c2,[16 0]);
    
    %         [hb a]=rgetnii(fullfile(pa, '_test1.nii'));
    % =============================================================
    
    fixim=fullfile(pa,'MSKtemplate.nii')
    movim=fullfile(pa,'MSKmouse.nii')
    %        fixM=fixim2
    %        movM=movM
    doelastix('calculate'  ,pa, {fixim movim} ,parafiles)   ;
    %         doelastix('calculate'  ,pa, {fixim movim} ,parafiles,{fixM movM})   ;
    
    
end


if 0
    mouseMASK=fullfile(pa,'MSKmouse.nii');
    [ha  a]=rgetnii(mouseMASK);
    [hb  b]=rgetnii(fullfile(pa,'_test1.nii'));
    %          c=a.*(b~=0);
    c=b.*(b>0);
    
    c=c-min(c(:));
    c=(c./max(c(:))).*10000;
    c=abs(c-max(c(:))); c(c==max(c(:)))=0; %invert
    rsavenii(mouseMASK,ha,c,[16 0]);
    
    
    
    
    [hd  ]=rgetnii(fullfile(pa, '_tpmgrey.nii'));
    [ha a]=rgetnii(fullfile(pa, 'AVGT.nii'));
    %        [hb b]=rgetnii(fullfile(pa, 'MSKtemplate.nii'));
    %        c=a.*(b>.10000);
    c=a.*(a>70);
    c=c-min(c(:));
    c=(c./max(c(:))).*10000;
    c=abs(c-max(c(:))); c(c==max(c(:)))=0; %invert
    
    rsavenii(tpmMASK,hd,c,[16 0]);
    %
    %         [hb a]=rgetnii(fullfile(pa, '_test1.nii'));
    
    fixim=fullfile(pa,'MSKtemplate.nii')
    movim=fullfile(pa,'MSKmouse.nii')
    doelastix('calculate'  ,pa, {fixim movim} ,parafiles)   ;
    
end