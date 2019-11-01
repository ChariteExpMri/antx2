

function [success]=xnormalizeElastix(pstruct)


if 0%===== TESTS====================================================
    
    
     xnormalizeElastix(struct('task',[2:4],'voxres',[.07 .07 .07],'t2',pwd,'autoreg',1))
    
     xnormalizeElastix(struct('task',[1:4],'voxres',[.07 .07 .07],'t2',pwd,'autoreg',1))
    
     xnormalizeElastix(struct('task',[1],'voxres',[.07 .07 .07],'t2',pwd,'autoreg',1))
     
     
end

%% =========================================================
%% [0] PRELUDE (in all steps always "initialized")
% INPUT:
%% =========================================================


% struct to variables
if ~isfield(pstruct,'task') || isempty(pstruct.task); pstruct.task=1:4 ;end  %  if  pstruct.task is empty or not declared
fn=fieldnames(pstruct);
for j=1:length(fn); eval([fn{j} '=pstruct.' fn{j} ';' ]) ;end


%=========================================================

[pant r]=   antpath;
success=    0;

infocw=['process: '  strrep(t2,filesep,[filesep filesep])  '\t'  datestr(now) '\n'] ;
cprintf([0 0 1],([ repmat('–',[1 length(infocw)]) '\n']  ));
cprintf([0 0 1],(infocw) );
cprintf([0 0 1],([ repmat('–',[1 length(infocw)]) '\n']  ));
% define t2-file (from path)
[pa fi ext]=fileparts(t2);
if isempty(ext) %% only path was given-->link t2
    t2=     fullfile(t2,'t2.nii');
    pa=     fileparts(t2);
    if exist(t2,'file')~=2;             return                      ;    end
end
% get ID
[~, ID]=fileparts(pa);



try;  statusbar2(0,  'ELASTIX'  ,'-SETUP', ID);  end

%% =================================================================================
%% [1] INITIALIZATION:
%% >> if 'defs.mat' does not exist in t2-folder  than  copy TPMS/volumes to the t2-folder
%% >>otherwise, set reorientMAT of TPMS to its original values (..from 'defs.mat', this is faster than recopy stuff)
% INPUT:
%% =================================================================================
if find(task==1)
try;  statusbar2(1,  'busy'  ,'-INITIALIZATION', ID);  end

  %% copy templates to studyTemplatepath
     if isdir(fullfile(fileparts(fileparts(pa)),'templates'))==1
           fa=xcopyfiles(r, pa,  voxres);
     end
           

    
    if exist(fullfile(pa,'defs.mat'))==0  %% COPY TPMS if not exists
        
        %% COPY TEMPLATES FROM studyTemplatepath to current MOUSEPATH
        templatepath=fullfile(fileparts(fileparts(pa)),'templates')
        %(1)TPMS
        tpm00  ={...
            fullfile(templatepath, '_b1grey.nii')  
            fullfile(templatepath, '_b2white.nii') 
            fullfile(templatepath, '_b3csf.nii') }
        tpm=replacefilepath(tpm00,pa)
        for i=1:length(tpm00)
            copyfile(tpm00{i},tpm{i},'f');
        end
        %(2) copy [_sample.nii]
        copyfile(  fullfile(templatepath, '_sample.nii')  ,           fullfile(pa, '_sample.nii')            ,'f' );
        %(3) copy [AVGT.nii] , [ANO.nii]
        copyfile(  fullfile(templatepath, 'AVGT.nii')  ,           fullfile(pa, 'AVGT.nii')            ,'f' );
        copyfile(  fullfile(templatepath, 'ANO.nii')  ,           fullfile(pa, 'ANO.nii')            ,'f' );
        
        %(4)make copies of TPM [_refIMG.nii] & [_tpmgrey.nii],[_tpmwhite.nii],[_tpmcsf.nii]; used as ORIG TPMS
        copyfile(tpm{1},  fullfile(pa, '_refIMG.nii' )         ,'f' );
        copyfile(tpm{1},  fullfile(pa, '_tpmgrey.nii' )       ,'f' );
        copyfile(tpm{2},  fullfile(pa, '_tpmwhite.nii' )     ,'f' );
        copyfile(tpm{3},  fullfile(pa, '_tpmcsf.nii' )          ,'f' );
        refIMG=fullfile(pa,'_refIMG.nii');
        
%         
        %% SKULLSTRIP T2.nii
        disp('...do skullstripping (be patient)');
        skullstrip_pcnn3d(t2, fullfile(pa, '_msk.nii' ),  'skullstrip'   );
        
        %% save orientation of TPMs, due to transformation...in next step we won't copy them from source
        for j=1:length(tpm)
            htemp=spm_vol(tpm{j});
            tpms(j,:)=    {  htemp.fname htemp.mat htemp.dim };
        end
        defs.tpms     =tpms;
        save(fullfile(pa, 'defs.mat' ),'defs'  );
    else
        refIMG      =fullfile(pa,'_refIMG.nii');
        load(fullfile(pa,'defs.mat'));
        tpm         =replacefilepath(defs.tpms(:,1),pa);   %tpm=defs.tpms(:,1);
        for j=1:length(tpm)
            spm_get_space(tpm{j}, defs.tpms{j,2}  );
        end
    end
end %task


%% =================================================================================
%% [2] COREGISTRATION
% INPUTS:   tpm, t2(file), refIMG,parafile,   (roregfigcatpure)
%  reorient image                       ( FBtool [-pi/2 pi 0]   |    BERLIN [ PI/2 PI PI])
%% =================================================================================


if find(task==2)
    try;  statusbar2(1,  'ELASTIX'  ,'-COREGISTRATION', ID);  end

    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%     INPUT parameter
    load(fullfile(pa,'defs.mat'));
    tpm                         =replacefilepath(defs.tpms(:,1),pa);
    refIMG                      =fullfile(pa,'_refIMG.nii');
    parafile                    =which('trafoeuler.txt');
    coregFigname         =fullfile(pa,'coreg.jpg');
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    %set TPM to orig orientation
    tpm         =replacefilepath(defs.tpms(:,1),pa);   %tpm=defs.tpms(:,1);
    for j=1:length(tpm)
        spm_get_space(tpm{j}, defs.tpms{j,2}  );
    end
    
    
    %% STEP-1  : FIND ROTATION
    if autoreg==1
        spm fmri;
        [rot id trafo]=findrotation(refIMG ,t2 ,parafile, 1,1);
        preorient=trafo;
        Bvec=[ [preorient]  1 1 1 0 0 0];
        fsetorigin(tpm,   spm_imatrix(inv(spm_matrix(Bvec)))    );
        
        %% check and make screenshut
        pause(.5);drawnow;
        displaykey3inv( tpm{1} ,t2,0,struct('parafile',parafile,'screencapture',coregFigname  ) );
        
        hgfeval(  get( findobj(findobj(gcf,'tag','Graphics'),'string','END'),'callback')  );     %make screenshut usong callback
        
        % parafile=fullfile(pant,'paraaffine4rots.txt');
        %     [rot id trafo]=findrotation(r.refsample ,t2 ,parafile, 1,1);
        % preorient=[0 0 0 -pi/2 pi 0];%Freiburg
        % preorient=[0 0 0 pi/2 pi pi];%BErlin to ALLEN
        %     fsetorigin(tpm, Bvec);  %ANA
        
    elseif autoreg==0
        %     if isempty(findobj(0,'tag','Graphics'));
        %         spm fmri; %drawnow;drawnow;
        %     end
        %     displaykey2(r.refsample,t2,1);
        % spm fmri; drawnow;drawnow;
        %    figure(findobj(0,'tag','Graphics')); drawnow; pause(.5); drawnow
        % displaykey3inv(  refIMG ,t2,1); %shoenso [grayMAtter(=.._refIMG.nii), t2.nii]
        %displaykey3inv(  refIMG ,t2,0,  parafile ); %with option to autorotate
        
        displaykey3inv( refIMG ,t2,1,struct('parafile',parafile,'screencapture',coregFigname  ) );
        %    return
        
        %% TESTER
        if 0
            refIMG=fullfile(pwd,'_refIMG.nii')
            t2=fullfile(pwd,'t2.nii')
            displaykey3inv(  refIMG ,t2,0,  struct('parafile', which('trafoeuler.txt') ) ); %with option to autorotate
        end
    end
    
    %  return
    
    
    %     0.0672   -6.5761    1.4926    1.5260    3.1178    3.1340---6---1.5708    3.1416    3.1416
    
    
    % %% STEP-2+3  :  autocoregister+COREG
    % predef=[ [[0 0 0   0 0 0 ]]  1 1 1 0 0 0];
    % reorient=autoregister(tpm{1} , t2 , predef);
    % %% reorient TPMS
    % for i=1:length(tpm)
    %     mfvol=spm_vol(tpm{i});
    %     spm_get_space(tpm{i}, reorient * mfvol.mat);
    % end
    
    
    %
    %
    %
    % %% STEP-2+3  :  autocoregister
    % predef=[ [[0 0 0   0 0 0 ]]  1 1 1 0 0 0];
    % [shift vec]=restimateOrigin4(tpm{1} , t2 ,[-7 7], [2 .5 .1 .05],predef);
    % st=fullfile(pa,'_test333SHIFT.nii');
    % copyfile(t2,st);
    %  trafo=[ [shift] [-pi/2 pi 0] 1 1 1 0 0 0]
    % fsetorigin({st}, vec);  %ANA
    
    
    
    %••••••••••••••  original •••••••••••••••••••••••••••••••••••••
%     if 0
%         %% retrieve & save orient MAT
%         v1 =  spm_vol(refIMG);
%         % v2 =  spm_vol('_test333FIN.nii');;
%         v2=   spm_vol(tpm{1});%
%         M =  v2.mat/v1.mat;
%         % M=diag([1 1 1 1]);
%         save(fullfile(pa,'reorient.mat'),'M');
%     end
    %••••••••••••• test elastix only •••••••••••••••••••••••••••
        %% retrieve & save orient MAT
        % v1 =  spm_vol(fullfile(pa,'_test333SHIFT.nii'));
        v1 =  spm_vol(fullfile(pa,'_refIMG.nii'));; %ORIG GM_in_ALLENSPACE !!
        v2=   spm_vol(tpm{1});%transformed GM in mouseSPace with ALLENorientMAT
        M =  v2.mat/v1.mat;
        save(fullfile(pa,'reorient.mat'),'M');

    %% CHECKS
    if 0
        % t2 from mouseSPACE to ALLENSPACE
        t2new=fullfile(pa,'_test_t2_inALLENSPACE.nii')
        copyfile(t2,t2new,'f');
        v=  spm_vol(t2new);
        spm_get_space(t2new,    inv(M) * v.mat);
        %GM from ALLENSAPCE to mouseSPACE
        w1=fullfile(pa,'_test_refIMG_inMOUSEPACE.nii')
        copyfile(fullfile(pa, '_refIMG.nii' ),w1,'f');
        v=  spm_vol(w1);
        spm_get_space(w1,     (M) * v.mat);
    end
    
end %TASK: coreg




%% =================================================================================
%% [3] SEGMENTATION
% Input:  (pa), tpm   (template)
%% =================================================================================
if find(task==3)
        try;  statusbar2(1,  'ELASTIX'  ,'-SEGMENTATION', ID);  end
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%     INPUT parameter
    defstemp                =load(fullfile(pa,'defs.mat'));
    tpm                         =replacefilepath(defstemp.defs.tpms(:,1),pa);
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    template                = [tpm; fullfile(pa, 'reorient.mat')];
    if isempty(findobj(0,'tag','Graphics'));
        spm fmri;drawnow;
    end
    loadspmmouse;drawnow;
    %xsegment(t2,template,'segment'); % 
    xsegment(t2,template); % 
end %TASK: segment



%% =================================================================================
%%  [4]  NORMALIZATION using ELASTIX
% Input:  (pa), parafiles, M (reorientMAt)
%% =================================================================================

if find(task==4)
      try;  statusbar2(1,  'ELASTIX'  ,'-NORMALIZATION', ID);  end
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    %%     INPUT parameter
    parafiles                  = {...
        'V:\mritools\elastix\paramfiles\Par0025affine.txt'
        'V:\mritools\elastix\paramfiles\Par0033bspline_EM2.txt'};
    load(fullfile(pa,'reorient.mat'));
    %–––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    %%  [4.1]  make brainMASKS
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    
    %% make mousemask
    [ha  a]=rgetnii(fullfile(pa, 'c1t2.nii'));
    [hb b]=rgetnii(fullfile(pa, 'c2t2.nii'));
    [hd d]=rgetnii(fullfile(pa, 'c3t2.nii'));
    c=a.*10000+b*20000+d*40000;
    % c=a.*10000+b*20000;
    mouseMASK=fullfile(pa,'MSKmouse.nii');
    rsavenii(mouseMASK,ha,c,[16 0]);
    
    v=  spm_vol(mouseMASK);
    spm_get_space(mouseMASK,      inv(M) * v.mat);
    
    %% make templateMAKS
    [ha  a]=rgetnii(fullfile(pa, '_tpmgrey.nii'));
    [hb b]=rgetnii(fullfile(pa, '_tpmwhite.nii'));
    [hd d]=rgetnii(fullfile(pa, '_tpmcsf.nii'));
    % c=a.*10000+b*20000;
    c=a.*10000+b*20000+d*40000;
    tpmMASK=fullfile(pa,'MSKtemplate.nii');
    rsavenii(tpmMASK,ha,c,[16 0]);
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    %%  [4.2]    calculate ELASTIX-PARAMETER;
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    
    fixim      =     tpmMASK;            %fullfile(pa, 'tpmMASK.nii');
    movim  =     mouseMASK;        %fullfile(pa, 'mouseMASK.nii');
    doelastix('calculate'  ,pa, {fixim movim} ,parafiles)   ;
    
    
    if 1  %TESTS
        %% TESTBACKWARD
        doelastix('transforminv'  , pa,    {fullfile(pa,'sAVGT.nii')}  ,3,M )
        doelastix('transforminv'  , pa,    {fullfile(pa,'_tpmgrey.nii')}  ,-1,M )
        doelastix('transforminv'  , pa,    {fullfile(pa,'_sample.nii')},3,M   )
        doelastix('transforminv'  , pa,    {fullfile(pa,'sANO.nii')}  ,0,M )
        %% TEST FORWARD
        doelastix('transform'  , pa,    {fullfile(pa,'t2.nii')}  ,3,M )
        % doelastix('transform'  , pa,    {fullfile(pa,'20150701_wr1_Anat_#i0.nii')}  ,0,M )
        doelastix('transform'  , pa,    {fullfile(pa,'c1t2.nii')}  ,3,M )
    end
    
    %% cleanUP
    if 1
        
        try; delete(fullfile(pa,'mt2.nii'));end
        try; delete(fullfile(pa,'_t2_findrotation2.nii'));end
        
        try; delete(fullfile(pa,'MSKmouse.nii'));end
        try; delete(fullfile(pa,'MSKtemplate.nii'));end
        % try; delete(fullfile(pa,'t2_seg_*.mat'));end
        
    end
    
end %TASK: normalize(Elastix)


 try;  statusbar2(-1);  end



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% old
% %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if 0
    %
    %     addpath('C:\Users\skoch\Downloads\PCNN3D matlab\PCNN3D')
    %     t2='O:\harms1\koeln\dat\s20150701_BB1';
    %     voxres=[  0.0700    0.0700    0.0700];
    %     manualorient=1;
    %     [success]=xnormalizeElastix(t2, voxres, manualorient)
    %
    %     %% EXAMPLE-2
    %     cd('O:\harms1\koeln\dat\_leer')  ;%check if everything is put to t2-folder
    %     t2='O:\harms1\koeln\dat\s20150701_BB2';
    %     voxres=[  0.0700    0.0700    0.0700];
    %     manualorient=0;
    %     [success]=xnormalizeElastix(t2, voxres, manualorient)
    %
    %
    %        %% EXAMPLE-3
    %     cd('O:\harms1\koeln\dat\_leer')  ;%check if everything is put to t2-folder
    %     t2='O:\harms1\koeln\dat\s20202020_otherc3m15';
    %     voxres=[  0.0700    0.0700    0.0700];
    %     manualorient=1;
    %     [success]=xnormalizeElastix(t2, voxres, manualorient)
end