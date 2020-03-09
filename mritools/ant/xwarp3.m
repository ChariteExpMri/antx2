

%% #yk xwarp3: calculate transformation parameters to register images to AllenSpace (and back to mouseSpace)
% _______________________________________________________________________________________________________________________________________________
% #yk ..WHEN CALLED FROM ANT-GUI
% ..perform the following steps:
%  #g   '[1]  xwarp-initialize'   #k (steps: reslice templates, copy templates, skullstrip "t2.nii")
%  #g   '[2a] xwarp-coregister auto'  #k automatic preregister volume (roughly)
%  #g   '[2b] xwarp-coregister manu'  #r this step is OPTIONAL, only usefull if 2a fails  #k manually preregister volume (roughly)
%  #g   '[3]  xwarp-segment'     #k  SPM'S UNIFIED APPROACH (segment image to GrayMatter(c1t2.nii),WhiteMatter(c2t2.nii),CSFGrayMatter(c3t2.nii), NORMALIZE +BIAS FIELD CORRECTION
%  #g   '[4]  xwarp-ELASTIX'     #k ELASTIX transformation
%  #r NOTE:  EACH STEP IS A PREREQUISITE FOR A SUBSEQUENT STEP
%  #r (THUS IN ORDER TO PERFORM STEP [4] YOU HAVE TO PERFORM THE STEPS [1],[2a] or [2b], and [3] before doing step [4])
% _______________________________________________________________________________________________________________________________________________
% #yk INPUTS VIA COMMANDLINE
% #by function can be used to batch the warping procedure
%   xwarp3('batch', ..optional pairwise inputs)
% <optional parameter>
% 'mdirs'      : cell array with mouse directory(s), (do not use the fullpath to the directories!!)
%              : if not defined, the selected dirs from the ANT mouse-listbox ist used
% 'task'       : task or combination of tasks to perform,  [1]initialize,[2]register,[3]segementation
%                [4]warping using elastix
%                 - example: [1:4]; do all tasks
%                 - if not defined all tasks will be performed [1,2,3,4]
% 'autoreg'    :[1] automatic preregistration, or [0]manual registration
%                 -if not defined 'autoreg is' set to [1]...automatic mode
% ,'parfor'    :[0|1] using PARALLEL-COMPUTATION <default:0>
% _______________________________________________________________________________________________________________________________________________
%% #gy BATCH  EXAMPLES
% EXAMPLES to batch the warping step
% [1]: perform all tasks, using the mouse dirs as defined in "dirs"-cell array, automatic preregistration
%  xwarp3('batch','mdirs',dirs,'task',[1:4],'autoreg',1)
% [2] same.., but onle mice previously highlighted in the ANT listbox will be processed
%  xwarp3('batch','task',[1:4],'autoreg',1)
% [3] USING PARALLEL-COMPUTATION
% xwarp3('batch','task',[1:2],'autoreg',1,'parfor',1)
%
%
% #wk _______________________________________________________________________________________________________________________________________________
% #wr [2] how to apply transformation to other images:
% - run this function
% doelastix(direction, [], files  ,interpx ,'local' );
% arg1:  direction .. which direction to warp [1]to allen [-1] to native space
% arg2:  voxresolution--> leave it empty
% arg3: files --> cell with nifti files to warp
% arg4: interpolation order [0,1,2,3] for NN, linear, 2nd order, 3rd order (spline)
% arg5: apply additional rigid body transformation (calculated beforehand) ..use 'local' to use the local parameters
% example:
%     files={'O:\harms1\harms3_lesionfill\dat\s20150505SM02_1_x_x\lesion_64.nii'
%     'O:\harms1\harms3_lesionfill\dat\s20150505SM03_1_x_x\lesion_64.nii'
%     'O:\harms1\harms3_lesionfill\dat\s20150505SM09_1_x_x\lesion_64.nii'}
%     doelastix(1   , [],      files                      ,3 ,'local' );



function [success]=xwarp3(s,varargin)





if strcmp(s,'batch')
    %if exist('paramsbatch')~=1; paramsbatch=[]; end
    batchwarp(varargin);
    return
end





timex=tic;

if 0%===== TESTS====================================================
    
    global an
    s=an.wa
    s.voxsize=an.voxsize
    s.task=[4]
    s.t2='O:\TOMsampleData\study4\dat\s20160623_RosaHDNestin_eml_29_1_x_x'
    s.autoreg=1
    [success]=xwarp3(s)
    
    % example 2
    global an
    s=an.wa
    s.voxsize=an.voxsize
    s.task=[1:4]
    s.t2='O:\data2\jing\dat\MMRE_age_20w_mouse5_cage6_13122017'
    s.autoreg=1
    [success]=xwarp3(s)
    
    
end



%% =========================================================
%% [0] PRELUDE (in all steps always "initialized")
% INPUT:
%% =========================================================
warning off;
process=upper(mfilename);
% struct to variables
if ~isfield(s,'task') || isempty(s.task); s.task=1:4 ;end  %  if  s.task is empty or not declared
% fn=fieldnames(pstruct);
% for j=1:length(fn); eval([fn{j} '=pstruct.' fn{j} ';' ]) ;end


%=========================================================

% [pant r]=   antpath;
success=    0;




% get fullpath-filename  "t2.nii"-file (from path)
[pa fi ext]=fileparts(s.t2);
if isempty(ext) %% only path was given-->link t2
    s.t2=     fullfile(s.t2,'t2.nii');
    s.pa=     fileparts(s.t2);
    if exist(s.t2,'file')~=2;   
        disp([ ' missing file : '  char(s.t2)   '   ... premature abortion']);
        return                    
    end
end
clear pa fi ext
% get ID
[~, ID]=fileparts(s.pa);

%% showinfo
maincol= [ 0.9294    0.3941    0.1255 ];
infoc.a1=['process: '  ID  char(9)  datestr(now)];
infoc.a2=[ repmat('*',[1 length(infoc.a1)+10]) ];
showinfo(infoc.a2   ,1,maincol);
showinfo(infoc.a1   ,1,maincol);
% showinfo(infoc.a2   ,1);
disp(['  dir: <a href="matlab: systemopen('' ' s.pa '  '');">' s.pa '</a>']);% show h<perlink

%templetpath
s.templatepath=fullfile(fileparts(fileparts(s.pa)),'templates');


%% MAC/LINUX/WIN replace file-path 
defsmatfile=fullfile(s.pa,'defs.mat');
if exist(defsmatfile)==2
    load(defsmatfile);
    defs.tpms(:,1)={...
        fullfile(s.pa,'_b1grey.nii')
        fullfile(s.pa,'_b2white.nii')
        fullfile(s.pa,'_b3csf.nii')
        };
    save(defsmatfile,'defs');
   clear defsmatfile 
end

% if ispc
%     dum  = strrep(dum,'/','\');
% else
%     dum  = strrep(dum,'\','/');
% end



%% HTML summary initialize if not existing
HTMLfile=fullfile(s.pa,'summary','summary.html');
if exist(HTMLfile)==0
    ht=fun_htmlsummary(0,s.pa);
else
    % ACTIVATE HTML-UPDATE
   xhtml('timer','page',fullfile(s.pa,'summary','summary.html'),'rerun',datestr(now));
end

 

%% =================================================================================
%% [1] INITIALIZATION:
%% >> if 'defs.mat' does not exist in t2-folder  than  copy TPMS/volumes to the t2-folder
%% >>otherwise, set reorientMAT of TPMS to its original values (..from 'defs.mat', this is faster than recopy stuff)
% INPUT:
%% =================================================================================
if find(s.task==1)
    %     try;  statusbar2(1,  process ,'-INITIALIZATION', ID);  end
    showinfo('  [1] INITIALIZATION...(create templates,copy templates,skullstripping)'  ,1 );
    
    
    
     %% HTML summary
     timetask=tic;
    
     
     %% HTML PROCESS_REPORT (group)
     xhtmlgr('update','page',fullfile((fileparts(fileparts(s.pa))),'summary.html'),'currentTask',1, 'currentsubject',s.pa);


    
    %% copy templates to studyTemplatepath
    t=xcreatetemplatefiles2(s,0);
    
    if 1
        t2=fullfile(s.pa,'t2.nii');
        [ha a]=rgetnii(t2);
        ha=rmfield(ha,'private');
        rsavenii(t2,ha,a );
        
    end
    
    
    if exist(fullfile(s.pa,'defs.mat'))==0  %% COPY TPMS if not exists
        %% COPY TEMPLATES FROM studyTemplatepath to current MOUSEPATH
        %(1)TPMS
        tpm00  =t.refTPM;
        tpm=replacefilepath(tpm00,s.pa);
        for i=1:length(tpm00)
            copyfile(tpm00{i},tpm{i},'f');
        end
        %(2) copy [_sample.nii]
        %% copyfile(  fullfile(templatepath, '_sample.nii')  ,           fullfile(pa, '_sample.nii')            ,'f' );
        %(3) copy [AVGT.nii] , [ANO.nii]
        copyfile( t.avg  ,           fullfile(s.pa, 'AVGT.nii')      ,'f' );
        copyfile( t.ano  ,           fullfile(s.pa, 'ANO.nii')      ,'f' );
       if exist(t.avgmask )==2;  copyfile( t.avgmask  ,      fullfile(s.pa, 'AVGTmask.nii')      ,'f' ); end
       if exist(t.avgthemi)==2;  copyfile( t.avgthemi ,      fullfile(s.pa, 'AVGThemi.nii')      ,'f' ); end
        
        %(4)make copies of TPM [_refIMG.nii] & [_tpmgrey.nii],[_tpmwhite.nii],[_tpmcsf.nii]; used as ORIG TPMS
        copyfile(tpm{1},  fullfile(s.pa, '_refIMG.nii' )         ,'f' );
        copyfile(tpm{1},  fullfile(s.pa, '_tpmgrey.nii' )        ,'f' );
        copyfile(tpm{2},  fullfile(s.pa, '_tpmwhite.nii' )       ,'f' );
        copyfile(tpm{3},  fullfile(s.pa, '_tpmcsf.nii' )         ,'f' );
        refIMG=fullfile(s.pa,'_refIMG.nii');
        
        

        
        
       
        
        %% save orientation of TPMs, due to transformation...in next step we won't copy them from source
        for j=1:length(tpm)
            htemp=spm_vol(tpm{j});
            tpms(j,:)=    {  htemp.fname htemp.mat htemp.dim };
        end
        defs.tpms     =tpms;
        save(fullfile(s.pa, 'defs.mat' ),'defs'  );
    else
        refIMG      =fullfile(s.pa,'_refIMG.nii');
        load(fullfile(s.pa,'defs.mat'));
        tpm         =replacefilepath(defs.tpms(:,1),s.pa);   %tpm=defs.tpms(:,1);
        for j=1:length(tpm)
            spm_get_space(tpm{j}, defs.tpms{j,2}  );
        end
    end
    %% BIAS FIELD CORRECTION
    if isfield(s,'BiasFieldCor') && s.BiasFieldCor==1
        origfile=stradd(s.t2,['biased'],2);
        if exist(origfile)~=2
            % CASE: BFC not done before
            [ha ac a]=biasfieldcor(s.t2);
            copyfile(s.t2,origfile,'f');           % copy original file as 't2biased.nii'
            rsavenii(s.t2,ha(1),ac );              % overwrite Original file
        else
            % CASE: BFC DONE BEFORE
            %..>> DO NOTHING
        end
    end
    %% SKULLSTRIP T2.nii
    if s.usePriorskullstrip==1
        fprintf('     ...do skullstripping..');
        
        
        %if isfield(s,'species') && strcmp(s.species,'rat')  % ##-RAT-##
        if isfield(s,'species') && (strcmp(s.species,'rat') || strcmp(s.species,'etruscianshrew'))   
            skparam.species = s.species;
            evalc('skullstrip_pcnn3d(s.t2, fullfile(s.pa, ''_msk.nii'' ),  ''skullstrip'' ,skparam  )'); ;
        else
            %skullstrip_pcnn3d(s.t2, fullfile(s.pa, '_msk.nii' ),  'skullstrip'   );
            evalc('skullstrip_pcnn3d(s.t2, fullfile(s.pa, ''_msk.nii'' ),  ''skullstrip''   )'); ;
        end
        fprintf('done.\n ');
    elseif s.usePriorskullstrip==2 % dirty maskingApproach
        
        fprintf('     ...do skullstripping [method-2]..');
%         skullstrip2(s.t2,5,[3:7],20,1,0,1);
         skullstrip2(s.t2,5,[3],1,20,1,0,1);
        fprintf('done.\n ');
        
    else
        fprintf('     ...remove Background..');
        mskfile=fullfile(s.pa,'_msk.nii');
        copyfile(s.t2, mskfile,'f');
        
        [hm m]=rgetnii(mskfile);
        
        
        r=reshape(otsu(m(:),5),[hm.dim]);
        r=r>1;
        
        %        testfi=fullfile(s.pa,'_test.nii');
        %        rsavenii(testfi,hm,r);
        %        rmricron([],testfi)
        mv=normalize01(m)*1000;
        m2=mv.*r;
        
        mskfile=fullfile(s.pa,'_msk.nii');
        %         hm2=hm;
        %         hm2=rmfield(hm2,{'pinfo','private'})
        try; delete(mskfile); end
        rsavenii(mskfile,hm,m2,[16 0]);
        %rmricron([],mskfile);
        fprintf('done.\n ');
    end
    
   
    %% HTML summary
    hinfo={['processing time: ' secs2hms(toc(timetask))]};
    ht=fun_htmlsummary(1,s.pa,'info',hinfo);
    
    %% HTML PROCESS_REPORT (group)
     xhtmlgr('update','page',fullfile((fileparts(fileparts(s.pa))),'summary.html'));

end %task


%% =================================================================================
%% [2] COREGISTRATION
% INPUTS:   tpm, t2(file), refIMG,parafile,   (roregfigcatpure)
%  reorient image                       ( FBtool [-pi/2 pi 0]   |    BERLIN [ PI/2 PI PI])
%% =================================================================================


if find(s.task==2)
    %     try;  statusbar2(1, process  ,'-COREGISTRATION', ID);  end
    showinfo('  [2] COREGISTRATION...'  ,1 );
    
    %% HTML summary
     timetask=tic;
    
     %% HTML PROCESS_REPORT (group)
     xhtmlgr('update','page',fullfile((fileparts(fileparts(s.pa))),'summary.html'),'currentTask',2, 'currentsubject',s.pa);

    %-----------------------------
    %%     INPUT parameter
    load(fullfile(s.pa,'defs.mat'));
    tpm                         =replacefilepath(defs.tpms(:,1),s.pa);
    refIMG                      =fullfile(s.pa,'_refIMG.nii');
    
    if isfield(s,'orientelxParamfile') && exist(s.orientelxParamfile)==2
        parafile= char(s.orientelxParamfile);
    else
        parafile                    =fullfile(fileparts(fileparts(which('ant.m'))),'elastix','paramfiles','trafoeuler2.txt');
    end
    
    coregFigname                =fullfile(s.pa,'coreg.jpg');
    %-----------------------------
    %set TPM to orig orientation
    tpm         =replacefilepath(defs.tpms(:,1),s.pa);   %tpm=defs.tpms(:,1);
    for j=1:length(tpm)
        spm_get_space(tpm{j}, defs.tpms{j,2}  );
    end
    
    
    %% STEP-1  : FIND ROTATION
    
    %---------------------------------check parameter-choice--------------------------------------------
    if isfield(s,'orientType')==0
        params.orientType     = 5  ; %Reorientation table index: [1]Berlin,[5]Munich/Freiburg
    else
        params.orientType     = s.orientType  ;
    end
    
    if isfield(s,'orientRefimage')==0  %Reorientation reference image:[0]old version-grayMatter
        params.orientRefimage =   2 ;  %[1]grayMatter in AllenSpace,[2]'_sample2.nii'(T2w-image in AllenSpace)
    else
        params.orientRefimage =   s.orientRefimage;
    end
    
    %---------------------------------REFIMAGE/SOURCEIMAGE--------------------------------------------
    if params.orientRefimage==0 % older version
        iref=refIMG;
    elseif params.orientRefimage==1 % REFIMAGE
        % copy of C1-compartment
        %refIMG                      =fullfile(s.pa,'_refIMG.nii');
        iref=refIMG;
    else
        %iref='O:\data2\muenchen_importbug\dat\hab2\_sample.nii';
        iref=fullfile(fileparts(which('ant.m')),'templateBerlin_hres','_sample2.nii');
    end
    isource=s.t2;
    
    
    
    f10      = fullfile(s.pa,'AVGT.nii');
    f11      = fullfile(s.pa,'AVGTmask.nii');
    [ha a]   = rgetnii(f10);
    [hb b]   = rgetnii(f11);
    rigidDir = fullfile(s.pa,'rigid');
    try; mkdir(rigidDir); end
    iref    =fullfile(rigidDir,'rigidtemplate.nii');
    rsavenii( iref ,ha, a.*b);
    
    isource0 =fullfile(s.pa,    '_msk.nii');
    isource  =fullfile(rigidDir,'rigidmouse.nii');
    copyfile(isource0,isource,'f');
    
    params.outdir  =  rigidDir;
    
    %-----------------------------------------------------------------------------
    if s.autoreg==1
        %spm fmri;
        if params.orientRefimage==0 %older version
            disp('..old version');
            [rot id trafo]=findrotation(iref ,isource ,parafile, 1,1);
        else %NEW VERSION
            [rot id trafo ]=findrotation2(iref ,isource,params ,parafile, 1,1);
        end
        
        
        %%orig:    [rot id trafo]=findrotation(refIMG ,s.t2 ,parafile, 1,1);
        preorient =trafo;
        Bvec      =[ [preorient]  1 1 1 0 0 0];
        fsetorigin(tpm,   spm_imatrix(inv(spm_matrix(Bvec)))    );
        
        %% check and make screenshut
%         if 0
%             pause(.5);drawnow;
%             try
%                 % test
%                 %            disp(['changes in 232: '  mfilename ])
%                 %            frefnew='O:\data2\muenchen_importbug\dat\hab2\_sample.nii'
%                 %            displaykey3inv( frefnew ,s.t2,0,struct('parafile',parafile,'screencapture',coregFigname  ) );
%                 %orig
%                 displaykey3inv( tpm{1} ,s.t2,0,struct('parafile',parafile,'screencapture',coregFigname  ) );
%                 hgfeval(  get( findobj(findobj(gcf,'tag','Graphics'),'string','END'),'callback')  );     %make screenshut usong callback
%             end
%         end
%         
        
        
        % parafile=fullfile(pant,'paraaffine4rots.txt');
        %     [rot id trafo]=findrotation(r.refsample ,t2 ,parafile, 1,1);
        % preorient=[0 0 0 -pi/2 pi 0];%Freiburg
        % preorient=[0 0 0 pi/2 pi pi];%BErlin to ALLEN
        %     fsetorigin(tpm, Bvec);  %ANA
        
    elseif s.autoreg==0
        if params.orientRefimage==0 %older version
            displaykey3inv( refIMG ,s.t2,1,struct('parafile',parafile,'screencapture',coregFigname  ) );
        else %NEW VERSION
            params2=struct('parafile',parafile,'screencapture',coregFigname  );
            params2.orientType=1:5;
            params2.orientRefimage=iref;
            params2.version2=1; %run new version for automatic mode using GUI-button
            params2.orientType = s.orientType ; %sets the priory specified orientationType (number 1-9)
            params2.outdir     = rigidDir;
            params2.auto_iref  =iref;
            params2.auto_isource =isource;
           displaykey3inv( refIMG ,s.t2,1,params2 );
        end 
    end
    
    %% ===============================================================
    %     if 0
    %         %% retrieve & save orient MAT
    %         v1 =  spm_vol(refIMG);
    %         % v2 =  spm_vol('_test333FIN.nii');;
    %         v2=   spm_vol(tpm{1});%
    %         M =  v2.mat/v1.mat;
    %         % M=diag([1 1 1 1]);
    %         save(fullfile(pa,'reorient.mat'),'M');
    %     end
    %% ===============================================================
    %% retrieve & save orient MAT
    % v1 =  spm_vol(fullfile(pa,'_test333SHIFT.nii'));
    v1 = spm_vol(fullfile(s.pa,'_refIMG.nii'));; %ORIG GM_in_ALLENSPACE !!
    v2 = spm_vol(tpm{1});%transformed GM in mouseSPace with ALLENorientMAT
    M  = v2.mat/v1.mat;
    save(fullfile(s.pa,'reorient.mat'),'M');
    
    %save older reorientMats
    load(fullfile(s.pa,'defs.mat'));
    if ~isfield(defs,'reorientmats'); defs.reorientmats={}; end
    defs.reorientmats=[defs.reorientmats;  {M  datestr(now)}];
    save(fullfile(s.pa, 'defs.mat' ),'defs'  );
    
    
    % create coreg2.jpg
     makeCoregImage(s.pa,'f1','t2.nii','f2','_refIMG.nii','useReorientMat',1,'save',1,'show',[0],'savename','coreg2.jpg'); %

     coregImage=[ fullfile(s.pa,'coreg2.jpg')];
     bestVol   =fullfile(params.outdir,'_bestROT.nii');

%      disp([' [' ID '] [' strrep(coregImage,[s.pa filesep],'') ']'  ...
%          'coreg <a href="matlab: explorerpreselect(''' coregImage ''')">' 'explorer' '</a>' ...
%          ' or <a href="matlab: system([''' [coregImage ] '''])">' 'Image' '</a>' ...
%          ' or <a href="matlab: rmricron([],''' s.t2 ''' ,''' bestVol ''', 1,[20 -4])">' 'MRicron' '</a>' ...
%          ]);
     
     %shpath =systemopen(s.pa,1);
     shimage=systemopen(coregImage,1);
     disp([' [' ID '] [' strrep(coregImage,[s.pa filesep],'') ']'  ...
         'coreg <a href="matlab: explorerpreselect(''' coregImage ''')">' 'explorer' '</a>' ...
         ' or <a href="matlab: ' shimage '">' 'Image' '</a>' ...
         ' or <a href="matlab: rmricron([],''' s.t2 ''' ,''' bestVol ''', 1,[20 -4])">' 'MRicron' '</a>' ...
         ]);
     
     
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
    cf;
    
     %% HTML summary
    hinfo={['processing time: ' secs2hms(toc(timetask))]};
    ht=fun_htmlsummary(2,s.pa,'info',hinfo);
    
    
    %% HTML PROCESS_REPORT (group)
    xhtmlgr('update','page',fullfile((fileparts(fileparts(s.pa))),'summary.html'));

end %TASK: coreg




%% =================================================================================
%% [3] SEGMENTATION
% Input:  (pa), tpm   (template)
%% =================================================================================
if find(s.task==3)
    %     try;  statusbar2(1,  process ,'-SEGMENTATION', ID);  end
    showinfo('  [3] SPM-SEGMENTATION...'  ,1 );
    %% ===============================================================
    %% HTML summary
     timetask=tic;
     
     %% HTML PROCESS_REPORT (group)
     xhtmlgr('update','page',fullfile((fileparts(fileparts(s.pa))),'summary.html'),'currentTask',3, 'currentsubject',s.pa);
     
     
    
    if isfield(s,'fastSegment')==0; s.fastSegment=1; end   % check param
    %s.fastSegment=1;

    if s.fastSegment==1
        fastsegMethod=2;        % [1] using '_msk.nii',[2] using _b1gray/_b2white/_b3csf.nii
        disp([ 'fastsegmentation..method-' num2str(fastsegMethod) ]);
        cutimage(s.pa,'meth',fastsegMethod,'show',0);
        [t2 template] =fastsegment(s.pa, 'pre','subdir','segm');
        
        
        if isempty(findobj(0,'tag','Graphics'));
            spm fmri;drawnow;
        end
        loadspmmouse;drawnow;
        xsegment(t2,template,s); %
        
        fastsegment(s.pa, 'post','subdir','segm');
        
        %check result- CHECK WHETHER MASK IS PART OF THE BORDER
        
        fc12mask=fullfile(s.pa,'segm','c1c2mask.nii');
        [ha a]=rgetnii(fc12mask);
        
        % [OLD] all dimensions
        if 0
            zb=ones(size(a)-4);
            zb=~padarray(zb,[2 2 2]);
            zm=round((zb.*a))+round(a);
        end
        
        %[NEW]  IGNORE SLICE_DIMENSION for checking mask at borders
        si=size(a);
        sldim=find(si==min(si));               % slice-dimension is min-size-dimension
        if length(sldim)>1; sldim=3; end       % otherwise the 3rd dim
        
        pldim=setdiff(1:3,sldim)               ;% in-planeDims
        sinew=[[sldim si(sldim)  0]]           ;%make tabel with "dimNum","reduced size","padarrayValue"
        sinew=[sinew; [pldim' si(pldim)'-4   [2 2]'   ] ];
        sinew=sortrows(sinew,1)              ;%sort accord dim-num
        
        zb=ones(sinew(:,2)');                %reduzed version of mask
        zb=~padarray(zb,[sinew(:,3)']);      % make border
        zm=round((zb.*a))+round(a);          % overlap of border-image and mask
        
        if round(sum(zm(:)==2))>0
            disp('..fastsegmentation failed..doing conventional segmentation');
            s.fastSegment=0;
        end
    end
    
    
    if s.fastSegment==0
        %%     INPUT parameter
        defstemp                =load(fullfile(s.pa,'defs.mat'));
        tpm                     =replacefilepath(defstemp.defs.tpms(:,1),s.pa);
        %% ===============================================================
        
        template                = [tpm; fullfile(s.pa, 'reorient.mat')];
        if isempty(findobj(0,'tag','Graphics'));
            spm fmri;drawnow;
        end
        loadspmmouse;drawnow;
       xsegment(t2,template,s); %
    end
    
    
  
    
    
    
    
    
    
    
    
    img2=fullfile(s.pa,'c1t2.nii');
    disp([' [' ID '] [' strrep(img2,[s.pa filesep],'') '] segmented <a href="matlab: explorerpreselect(''' img2 ''')">' 'explorer' '</a>' ...
        ' or <a href="matlab: rmricron([],''' s.t2 ''' ,''' img2 ''', 1,[20 -4])">' 'MRicron' '</a>' ...
        ]);
    
     %% HTML summary
    hinfo={['processing time: ' secs2hms(toc(timetask))]};
    ht=fun_htmlsummary(3,s.pa,'info',hinfo);
    
   %% HTML PROCESS_REPORT (group)
     xhtmlgr('update','page',fullfile((fileparts(fileparts(s.pa))),'summary.html'));
    
end %TASK: segment



%% =================================================================================
%%  [4]  NORMALIZATION using ELASTIX
% Input:  (pa), parafiles, M (reorientMAt)
%% =================================================================================

if find(s.task==4)
    %     try;  statusbar2(1,  process  ,'-NORMALIZATION (ELASTIX)', ID);  end
    showinfo('  [4] ELASTIX-ESTIMATE TRANSFORMATION...'  ,1 );
    msgvol=[' -[' ID '] has new volume' ];
    
    
    
    %% HTML summary
    timetask=tic;
    
    %% HTML PROCESS_REPORT (group)
    xhtmlgr('update','page',fullfile((fileparts(fileparts(s.pa))),'summary.html'),'currentTask',4, 'currentsubject',s.pa);
    
    
    
    %%  [4.1]  using MASKAPPRIOACH AND CALC PARAMERS
    
    if 0 %OLD xprepelastix-approach-wrapper
        approach= s.elxMaskApproach;
        xprepelastix_old(s,approach);
    end
    
    xprepelastix(s); %new xprepelastix-wrapper
    
    
    %%  [4.2]  TRANSFORM specified VOLUMES
    
    load(fullfile(s.pa,'reorient.mat'));
    
    %% BACKWARD
    if isfield(s,'tf_ano') && s.tf_ano==1
        file={fullfile(s.templatepath,'ANO.nii')} ; %showinfo(['   ..transform: ' file{1}]);
        try
        fis=doelastix('transforminv'  , s.pa,    file ,0,M );
        showinfo2(msgvol,fis{1},-1) ;
        end
    end
    
    if  isfield(s,'tf_anopcol') && s.tf_anopcol==1
        file={fullfile(s.templatepath,'ANOpcol.nii')} ;%showinfo(['   ..transform: ' file{1}]);
        try
        fis=doelastix('transforminv'  , s.pa,    file ,0,M );
        showinfo2(msgvol,fis{1},-1) ;
        end
    end
    
    if  isfield(s,'tf_avg') && s.tf_avg==1
        file={fullfile(s.templatepath,'AVGT.nii')} ; %showinfo(['   ..transform: ' file{1}]);
        try
        fis=doelastix('transforminv'  , s.pa,    file ,3,M );
        showinfo2(msgvol,fis{1},-1) ;
        end
    end
    
    if  isfield(s,'tf_refc1') && s.tf_refc1==1
        file={fullfile(s.pa,'_refIMG.nii')} ; %showinfo(['   ..transform: ' file{1}]);
        try
        fis=doelastix('transforminv'  , s.pa,    file,-1,M  );
        showinfo2(msgvol,fis{1},-1) ;
        end
    end
    
    
    %% FORWARD
    if isfield(s,'tf_t2') && s.tf_t2==1
        file={fullfile(s.pa,'t2.nii')} ; %showinfo(['   ..transform: ' file{1}]);
        try
            fis=doelastix('transform'  , s.pa,   file  ,3,M );
            showinfo2(msgvol,fis{1},+1) ;
        end
    end
    if isfield(s,'tf_c1') && s.tf_c1==1
        file={fullfile(s.pa,'c1t2.nii')} ; %showinfo(['   ..transform: ' file{1}]);
        try
            fis=doelastix('transform'  , s.pa,    file  ,3,M );
            showinfo2(msgvol,fis{1},+1) ;
        end
    end
    if isfield(s,'tf_c2') && s.tf_c2==1
        file={fullfile(s.pa,'c2t2.nii')} ; %showinfo(['   ..transform: ' file{1}]);
        try
            fis=doelastix('transform'  , s.pa,   file  ,3,M );
            showinfo2(msgvol,fis{1},+1) ;
        end
    end
    if isfield(s,'tf_c3') && s.tf_c3==1
        file={fullfile(s.pa,'c3t2.nii')} ; %showinfo(['   ..transform: ' file{1}]);
        try
            fis=doelastix('transform'  , s.pa,   file ,3,M );
            showinfo2(msgvol,fis{1},+1) ;
        end
    end
    if isfield(s,'tf_c1c2mask') && s.tf_c1c2mask==1
        file={fullfile(s.pa,'c1c2mask.nii')} ; %showinfo(['   ..transform: ' file{1}]);
        try
            fis=doelastix('transform'  , s.pa,   file  ,3,M );
            showinfo2(msgvol,fis{1},+1) ;
        end
    end
    
    
    if 1 % SPM-warp
        try
            evalc('xdeform2(fullfile(s.pa,''AVGT.nii''),-1, [nan nan nan],4 )');
            showinfo2(msgvol,[fullfile(s.pa,'iw_AVGT.nii')],-1) ;
        end
        try
            evalc('xdeform2(fullfile(s.pa,''t2.nii''),        1, [nan nan nan],4 )');
            showinfo2(msgvol,[fullfile(s.pa,'w_t2.nii')],+1) ;
        end
    end
    
    %% ===============================================================
    %% jacobian
    %% ===============================================================
    disp('  ..generate JACOBIAN');
    trafofile=fullfile(s.pa,'elastixForward','TransformParameters.1.txt');
   %      [im4,tr4] =       run_transformix(  [] ,[],trafofile, s.pa ,'jac');
     [logs,im4,tr4]=evalc(['run_transformix(  [] ,[],trafofile, s.pa ,''jac'')']);
    fis{1}=fullfile(s.pa,'JD.nii');
    movefile(tr4,fis{1},'f');
    showinfo2(msgvol,fis{1},+1) ;
    %% ===============================================================
    %%  [4.2]  clean up
    %% ===============================================================
    if s.cleanup==1
        
        %         try; delete(fullfile(s.pa,'mt2.nii'));end
        try; delete(fullfile(s.pa,'_t2_findrotation2.nii'));end
        try; delete(fullfile(s.pa,'MSKmouse.nii'));end
        try; delete(fullfile(s.pa,'MSKtemplate.nii'));end
        try; delete(fullfile(s.pa,'_bestROT.nii'));end
        try; delete(fullfile(s.pa,'_bestROT.txt'));end
        try; delete(fullfile(s.pa,'brainmaskref.nii'));end
        % try; delete(fullfile(pa,'t2_seg_*.mat'));end
        
    end
   
    
    
    %% HTML summary
    hinfo={['processing time: ' secs2hms(toc(timetask))]};
    ht=fun_htmlsummary(4,s.pa,'info',hinfo);
    
    
    %% HTML PROCESS_REPORT (group)
    xhtmlgr('update','page',fullfile((fileparts(fileparts(s.pa))),'summary.html'));

    
end %TASK: normalize(Elastix)

%% HTML summary
ht=fun_htmlsummary(-1,s.pa); %finish


try;  statusbar2(-1);  end
timex2=toc(timex);
% disp(['## DONE (dT:' sprintf('%3.2f min',timex2/60)  ')']);
try
    antcb('update');
end

function showinfo(infox, bold,col )
%% SHOW INFO
if exist('col')~=1
    col=[[0 0 1]];
end
if exist('bold')~=1
    bold=0;
end
if isempty(bold); bold=0; end

colstr=[ '['  num2str(col) ']' ];

if bold~=0
    colstr=['*' colstr];
end



try
    if ispc
        cprintf(colstr,  [strrep(infox,filesep,['\' filesep]) '\n']);
    else
        cprintf(colstr,  [infox '\n']);
    end
catch
    disp(infox);
end


%
% if bold==1
%     try
%         cprintf('*blue',  [strrep(infox,filesep,[filesep filesep]) '\n']);
%     catch
%         try
%             cprintf([0 0 1],  [strrep(infox,filesep,[filesep filesep]) '\n']);
%         catch
%             disp(infox);
%         end
%     end
% else
%     try
%         cprintf([0 0 1],  [strrep(infox,filesep,[filesep filesep]) '\n']);
%     catch
%         disp(infox);
%     end
% end





function batchwarp(paramsbatch);
%% BATCH
% EXAMPLES to batch
%  xwarp3('batch','mdirs',dirs,'task',[1:4],'autoreg',1)
%  xwarp3('batch','task',[1:4],'autoreg',1)
global an
mdirs   = antcb('getsubjects');

s         =an.wa;
s.voxsize =an.voxsize;
s.task    =[1:4];
s.autoreg =1;
% s.t2='O:\data2\jing\dat\MMRE_age_20w_mouse5_cage6_13122017'


%--------------------------------------


q.parfor =0;
atime  =tic;
lmiss   ={};
lok     ={};
%--------------------------------------
if ~isempty(paramsbatch)
    p=struct();
    for i=1:2:length(paramsbatch)
        p=setfield(p,paramsbatch{i},paramsbatch{i+1});
    end
    if isfield(p,'mdirs'   );  mdirs     =p.mdirs; end
    if isfield(p,'task'    );  s.task    =p.task ; end
    if isfield(p,'autoreg' );  s.autoreg =p.autoreg ; end
    
    %% parameters remains here
    if isfield(p,'parfor' );   q.parfor =p.parfor;   end
end


%% HTML SUMMARY REPORT
%disp('antcb-HTMLstatus: line 306');
paths=mdirs;
HTMLpath=   fileparts(fileparts(paths{1}));
ht=xhtmlgr('copyhtml','s' ,which('formgr.html'),'t',fullfile(HTMLpath,'summary.html'));
xhtmlgr('study','page',ht,'study',HTMLpath);
xhtmlgr('timer','page',ht,'start',datestr(now));


settings=antsettings;
if ~isfield(settings,'show_HTMLprogressReport') || (settings.show_HTMLprogressReport==1)
    xhtmlgr('show','page',ht);
end
do_deleteSummaryLOG = 1;  % delete Logfile.mat at the end




%% ===============================================================
%%
%% ===============================================================
disp('BATCH xwarp3');
if q.parfor==0
    try; antcb('status',1,'warping Images'); end
    
    for i=1:length(mdirs)
        s.t2=mdirs{i};
        disp(['..xwarp3<batch>:  ' s.t2]);
        try
            lok(end+1,1)={['xwarp3-success : ' s.t2]};
            xwarp3(s);
        catch
            lmiss(end+1,1)={['xwarp3-failed : ' s.t2]};
        end
    end
elseif q.parfor==1
    
    
    
    createParallelpools;
    disp('..PCT-PARFOR used');
    
    %% change for/parfor here
    atime=tic;
    mouse=mdirs;
    Nm=length(mouse);
    %     tasks =
    %     'xwarp'    [1x2 double]    [1]
    tasks{1}='xwarp';
    tasks{2}=s.task;
    tasks{3}=1;
    
    %---do the initialize-step ones to fill the templates folder
    if strcmp(tasks{1},'xwarp')
        if ~isempty(find(tasks{2}==1))
            v=mouse{1};
            antfun(tasks{1} ,v,  1 ,tasks{3}  ,an);
        end
    end
    %===============================================================================
    % loop across mouse
    %===============================================================================
    
    screensize=get(0,'ScreenSize');
    sizwin=[screensize(3)*2./4 screensize(4)*2/20];
    ppm = ParforProgMon('analysis', Nm ,1, sizwin(1),sizwin(2) );
    
    parfor j=1:Nm
        try
            v=mouse{j};
            antfun(tasks{1} ,v,  tasks{2} ,tasks{3}  ,an);
            %lok(j,1)={['xwarp3-success : ' v]};
        catch
            %             lok(j,1)={['xwarp3-failed : ' v]};
        end
        
        ppm.increment();
    end
    %===============================================================================
    
    %===============================================================================
end

%% HTML SUMMARY REPORT
if  do_deleteSummaryLOG == 1;  % delete Logfile.mat at the end
    HTMLpath=   fileparts(fileparts(paths{1}));
    try
        delete(fullfile(HTMLpath, 'summaryLog.mat'));
    end
end
    
    


cprintf('*black', ['..[DONE] ~' sprintf('%2.2fmin', toc(atime)/60) ' \n' ]);
drawnow;
antcb('update');
antcb('status',0,'IDLE');
drawnow
try; antcb('update'); end

return
%
%
%     % example 2
%     global an
%     s=an.wa
%     s.voxsize=an.voxsize
%     s.task=[1:4]
%     s.t2='O:\data2\jing\dat\MMRE_age_20w_mouse5_cage6_13122017'
%     s.autoreg=1
%     [success]=xwarp3(s)

