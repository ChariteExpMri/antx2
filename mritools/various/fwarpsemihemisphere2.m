function s=fwarpsemihemisphere2(mystruct,issubstack)
%% warp brain for each heisphere, separately, also tested for substacks
% function s=fwarpsemihemisphere2(mystruct)
%% [1] create struct as INPUT
% s=fwarpsemihemisphere2(1)  : yields a struct with predefined fieldnames and examplary entries (which has to be modified)
%    which can be modified and used as input for the function
% s.info : contains further information about the struct's fields
%% [2] run function
%% [2a] for complete data (all slices aquired) use: 
% s=fwarpsemihemisphere2(mystruct,0) or
% s=fwarpsemihemisphere2(mystruct,0) 
%% [2b]  for substack data use: 
% s=fwarpsemihemisphere2(mystruct,1)
%% OUTPUT: same struct as INput but with fullpathname
%            -for complete data: same struct as input but with fullpathnames
%            -for substack data: the filenames have been modified (suffix: '_ss') 

%% substack
if exist('issubstack')==0
    issubstack=0;
end

if ~isstruct(mystruct)
    if mystruct==0
        s.thispath         ='V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1';
        s.lesion            =1;
        s.mskHemi       ='whemi2.nii';
        s.mskLesion     ='wmask2.nii';
        s.T2                   ='wT2.nii';
        s.T2ref                ='_Atpl_mouseatlasNew.nii';
        s.tpm               ={    'wc1T2.nii'    'wc2T2.nii'   'wc3T2.nii'     }';  %tpm=fullpath(pwd,tpm);
        s.tpmref            =  {    '_Atpl_greyr62.nii'    '_Atpl_whiter62.nii'   '_Atpl_csfr62.nii' }';
        s.otherVolTRI=[];
        s.otherVolNN=[];
        
        %% info here
        info={};
        info{end+1,1}='*** struct-fieldname information***';
        info{end+1,1}='---------------------------------------' ;
        info{end+1,1}='s.thispath:    datapath with all necessary data (masks,TPM, TPMref,T2,T2ref)';
        info{end+1,1}='s.lesion    : side of lesion--> (1)left or (2)right';
        info{end+1,1}='s.mskHemi:     filename (without path) of the hemispheric mask (has to be contain values "1" for left and "2" for the right hemisphere (string)';
        info{end+1,1}= 's.mskLesion:   filename (without path) of the lesion''s location, lesion is coded with "1" ';
        info{end+1,1}= 's.T2              :  filename (without path) of the individual T2 image  (string)';
        info{end+1,1}= 's.T2ref         :  filename (without path) of the reference T2 image,i.e the template (string)';
        info{end+1,1}= 's.tpm           :  filenames (without path) of the Tissue probability maps from segemented individual T2 image (3x1 cell)';
        info{end+1,1}= 's.tpmref       :  filenames (without path) of the Tissue probability maps from reference T2 image,i.e the template (3x1 cell)';
        info{end+1,1}= 's.otherVolTRI:  (optional) filename(s) of other volumes to be involved in trilinear warping, (single file: string;  n-more files: nx1 cell)';
        info{end+1,1}= 's.otherVolNN: (optional) filename(s) of other volumes to be involved in next-neighbour warping, (single file: string;  n-more files: nx1 cell)';
        s.info=info;
        
        disp('output: predefined struct');
        return
    end
    
elseif isstruct(mystruct)
    %% extract fields from struct
    s=mystruct;
    thispath=       s.thispath ;
    lesion=         s.lesion    ;
    mskHemi=    s.mskHemi    ;
    mskLesion=   s.mskLesion     ;
    T2 =                s.T2                 ;
    T2ref =         s.T2ref               ;
    tpm =           s.tpm              ;
    tpmref =      s.tpmref          ;
    otherVolTRI =   s.otherVolTRI;
    otherVolNN=     s.otherVolNN;
    
end



%

%%

% thispath=pwd
% cd('V:\mritools')
% maus
% cd(thispath)

% clear

if 0
    %___________________inputs___________
    lesion=1;
    mskHemi ='whemi2.nii'
    mskLesion='wmask2.nii'
    T2          ='wT2.nii'
    T2ref   ='_Atpl_mouseatlasNew.nii'
    tpm=  {    'wc1T2.nii'    'wc2T2.nii'   'wc3T2.nii'     }';  %tpm=fullpath(pwd,tpm);
    tpmref=  {    '_Atpl_greyr62.nii'    '_Atpl_whiter62.nii'   '_Atpl_csfr62.nii' }';
    %path
    thispath='V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1'
    
    otherVolTRI=[];
    otherVolNN=[];
end

%=============================================================
%___________________addPaths___________
mskHemi  =fullpath(thispath,mskHemi);
mskLesion=fullpath(thispath,mskLesion);
tpm         =fullpath(thispath,tpm);
tpmref   =fullpath(thispath,tpmref);
T2           =fullpath(thispath,T2);
T2ref       =fullpath(thispath,T2ref);



%fullpath other volumes for NNinterp
if ~isempty(otherVolNN)
    if iscell(otherVolNN)
        if size(otherVolNN,1)<size(otherVolNN,2) %vector down
            otherVolNN=otherVolNN';
        end
    else
        otherVolNN={fullpath(thispath,otherVolNN)};
    end
end



%fullpath other volumes for trilinInterp
if ~isempty(otherVolTRI)
    if iscell(otherVolTRI)
        if size(otherVolTRI,1)<size(otherVolTRI,2) %vector down
            otherVolTRI=otherVolTRI';
        end
    else
        otherVolTRI={fullpath(thispath,otherVolTRI)};
    end
end


if issubstack
    %% cut all volumes accordinging orig boundingBOX in Z-dir to allow contraintWarping
    
        reffile=mskHemi;
         [hr dr xyzr ]=rgetnii(reffile );
        dr=dr(:);
        dr(dr>0)=1;
        xyzr=xyzr(:,find(dr~=0))';
        mnx=[ min(xyzr); max(xyzr); ];
        %refImage for bounfing BOX
         [bbh voxh]=world_bb(reffile);
        bbh(:,2)=mnx(:,2);
        
        %SUBSTACKED HEMI
        [bbo voxo]=world_bb(    mskHemi);
        mskHemi=   resize_img4(mskHemi, [abs(voxo)], bbh, [],                           0,  '_ss');
    
         %SUBSTACKED LESION
        [bbo voxo]=world_bb(mskLesion);
        mskLesion=   resize_img4(mskLesion, [abs(voxo)], bbh, [],                         0,  '_ss');
   
        %SUBSTACKED T2
        [bbo voxo]=world_bb(T2);
        T2=   resize_img4(T2, [abs(voxo)], bbh, [],                                                    1,  '_ss');
        
        
        %SUBSTACKED TPM
        for i=1:length(tpm)
            [bbo voxo]=world_bb(tpm{i,1});
            tpm{i,1}=   resize_img4(tpm{i,1}, [abs(voxo)], bbh, [],                              1,  '_ss');
        end
        
         %SUBSTACKED otherVolNN
        if ~isempty(otherVolNN)
            if ischar(otherVolNN)
                [bbo voxo]=world_bb(otherVolNN);
                otherVolNN=   resize_img4(otherVolNN, [abs(voxo)], bbh, [],              0,  '_ss');
            else
                otherVolNN=otherVolNN(:);
                [bbo voxo]=world_bb(otherVolNN{i,1});
                otherVolNN{i,1}=   resize_img4(otherVolNN{i,1}, [abs(voxo)], bbh, [],    0,  '_ss');
            end
        end
        
        %SUBSTACKED otherVolTRI
        if ~isempty(otherVolTRI)
            if ischar(otherVolTRI)
                [bbo voxo]=world_bb(otherVolTRI);
                otherVolTRI=   resize_img4(otherVolTRI, [abs(voxo)], bbh, [],              1,  '_ss');
            else
                otherVolTRI=otherVolTRI(:);
                [bbo voxo]=world_bb(otherVolTRI{i,1});
                otherVolTRI{i,1}=   resize_img4(otherVolTRI{i,1}, [abs(voxo)], bbh, [],   1,  '_ss');
            end
        end
        
    
end %SUBSTACK


% mskHemi=fullfile(pwd,    'whemi2.nii')



%%  T2-volumes ausstanzen   (threshold old: .1 .05)
% SOURCE
thresh=.01;%.2%[.01]
%  tpm=  {    'wc1T2.nii'    'wc2T2.nii'   'wc3T2.nii'     }';  tpm=fullpath(pwd,tpm);
makebrainmask2(tpm, thresh, fullfile(thispath, 'mousemask.nii'));
fi1=applymask(T2, fullfile(thispath,'mousemask.nii'),'>0',[],nan,'_masked');
%  fi2=rapplymask('_Atpl_mouseatlasNew.nii ','templatemask.nii','>0',1,nan,'_masked');

% TEMPLATE
%  tpm=  {    '_Atpl_greyr62.nii'    '_Atpl_whiter62.nii'   '_Atpl_csfr62.nii' }';  tpm=fullpath(pwd,tpm);
makebrainmask2(tpmref, thresh, fullfile(thispath,'templatemask.nii')); %checked
fi2=applymask(T2ref,fullfile(thispath,'templatemask.nii'),'>0',[],nan,'_masked');

timex=tic;
for side=1:2
    
    %% create T2 volume for left/right hemisphere for source and template
    % side=2
    if side==1
        sideTag =   '_left'  ;
        operator=  '==1'  ;
        operatorNormalized='>';
    else
        sideTag='_right';
        operator=  '==2';
        operatorNormalized='<=';
    end
    val2replace=nan;
    
    
    source   = applymask(fi1           ,   mskHemi,                         operator      ,[],val2replace, sideTag);
    template=maskdata(fi2             ,     [0 0 0],1, operatorNormalized ,val2replace,                             sideTag);
    
    
    %% separate left/righ masks
    mskHemiSingle   = applymask(mskHemi,mskHemi,                                     operator      ,1 ,val2replace,      sideTag);
    
    
    
    
    
    
    %% source & template Image
    % otherVolNN otherVolTRI
    % val2replace=0
    % source   = applymask(fullfile(pwd, 'wc1T2.nii'),                 mskHemi,                     '==1',1,val2replace,'_left');
    % template=maskData(fullfile(pwd, '_Atpl_greyr62.nii'),                    [0 0 0],1,'>',val2replace, '_left' )
    
    %% volumes for NNinterp
    % resn1   = applymask(fullfile(pwd, 'whemi2.nii'),mskHemi,                                     operator      ,[],val2replace,      sideTag);
    
    %LESION
    if lesion==side
        resn2   = applymask(mskLesion,mskHemiSingle,                             '==1'      ,[],val2replace,       sideTag);
    else
        resn2=   [];
    end
    
    % if ~isempty(otherVolNN)
    %     for j=1:size(otherVolNN,1)
    %
    %     end
    %
    % end
    
    vol4NN=otherVolNN;%files to apply hemisphericMask
    resNN=[];
    for j=1:size(vol4NN,1)
        resNN{j,1}   = applymask(vol4NN{j},     mskHemiSingle,                                  '==1'      ,[],val2replace,            sideTag);
    end
    
    
    resampleNN=[mskHemiSingle; resn2;resNN];
    if ~iscell(resampleNN);     resampleNN=cellstr(resampleNN); end
    resampleNN(cellfun(@isempty,resampleNN))=[]; %delete empty arrays
    
    %% volumes for  trilinInterp
    % res1   = applymask(fullfile(pwd, 'wT2.nii'),     mskHemiSingle,                                  '==1'      ,[],val2replace,            sideTag);
    % res2   = applymask(fullfile(pwd, 'wc1T2.nii'), mskHemiSingle,                                  '==1'      ,[],val2replace,            sideTag);
    % res3   = applymask(fullfile(pwd, 'wc2T2.nii'), mskHemiSingle,                                  '==1'      ,[],val2replace,            sideTag);
    % resampleTRI={res1;res2;res3}
    
    vol4tri=[ T2; tpm(1:2) ;otherVolTRI ];%files to apply hemisphericMask
    resTri=[];
    for j=1:size(vol4tri,1)
        resTri{j,1}   = applymask(vol4tri{j},     mskHemiSingle,                                  '==1'      ,[],val2replace,            sideTag);
    end
    resampleTRI=resTri;
    if ~iscell(resampleTRI);     resampleTRI=cellstr(resampleTRI); end
    
    %% SETUP NORMALIZATION STRUCT
    
    
    matlabbatch=[];
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.source ={source};% {'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wT2_masked.nii'};
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.wtsrc = {''};
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample ='';
    
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.template ={template};% {'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\_Atpl_mouseatlasNew_masked.nii'};
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smosrc =.7;% [.3]%35%[.72];%0.3;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smoref =0 ;%%[.2];%0.2;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.regtype = 'subj';
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.cutoff =1 ;%%1.8%1.8;%[2.25]% 1;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.nits = 16;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg =.1  ;% [1];
    matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.preserve = 0;
    matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.bb = [-5.9252 -9.4889 -8.671
        5.5466 6.5385 0.7027];
    matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.vox = [0.069 0.07 0.07];
    matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.interp = 0;
    matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix = 'H_';
    
    
    
    %% START NORMALIZATION TRILINEAR
    if ~isempty(resampleTRI)
        %         matlabbatch=[];
        matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = resampleTRI;%; resampleTRI
        matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.interp = 1;
        mbatchBK=matlabbatch;
        
         spm_jobman('run',  matlabbatch);
    end
    
    
    if 1
        if ~isempty(resampleNN)
            
            [pax fi ext]=fileparts(fi1);
            matfile= fullfile  (thispath,[ fi sideTag '_sn.mat' ]);
            
            %matlnames: wT2_masked_left_sn.mat,  wT2_masked_right_sn.mat
            matlabbatch=[];
            matlabbatch{1}.spm.spatial.normalise.write.subj.matname ={matfile};% {'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wT2_masked_left_sn.mat'};
            matlabbatch{1}.spm.spatial.normalise.write.subj.resample =resampleNN ;
            %             ; {
            %                 'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\E_wT2_left.nii,1'
            %                 'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\E_wT2_right.nii,1'
            %                 'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\E_wc1T2_left.nii,1'
            %                 };
            matlabbatch{1}.spm.spatial.normalise.write.roptions.preserve =     mbatchBK{1}.spm.spatial.normalise.estwrite.roptions.preserve;
            matlabbatch{1}.spm.spatial.normalise.write.roptions.bb =            mbatchBK{1}.spm.spatial.normalise.estwrite.roptions.bb;
            matlabbatch{1}.spm.spatial.normalise.write.roptions.vox =           mbatchBK{1}.spm.spatial.normalise.estwrite.roptions.vox; %[0.18 0.18 0.18];
            
            matlabbatch{1}.spm.spatial.normalise.write.roptions.interp = 0; %% INTERP
            matlabbatch{1}.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
            matlabbatch{1}.spm.spatial.normalise.write.roptions.prefix =   mbatchBK{1}.spm.spatial.normalise.estwrite.roptions.prefix;
            
            spm_jobman('run',  matlabbatch);
            
        end
    end
    
    
    if 0  %% takes longer
        if ~isempty(resampleNN)
            matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample =resampleNN;
            matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.interp = 0;
            spm_jobman('run',  matlabbatch);
        end
    end
    
end%side/hemisphere
toc(timex);


%% create struct-OUTPUT (modified filenames for SUBSTACK-approach)
s.mskHemi       =   mskHemi;
s.mskLesion     =   mskLesion;
s.T2                 =  T2;
s.T2ref           =T2ref;
s.tpm               =tpm;
s.tpmref         =tpmref;
s.otherVolTRI  =otherVolTRI;
s.otherVolNN  =otherVolNN;
s.info2='..done..' ;
s.issubstack =issubstack;

%% output
if 1
    try
        [ vol1 ]=getvolume(fullfile(thispath, 'hemisphere.nii'),'==1');
        [ vol2 ]=getvolume(fullfile(thispath, 'hemisphere.nii'),'==2');
        
        try
        prefix=matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix;
        catch
          prefix=matlabbatch{1}.spm.spatial.normalise.write.roptions.prefix;   
        end
        [pa hemitest ext]=fileparts(mskHemi);
        fiHemiWarpL=fullfile(pa,[ prefix hemitest '_left' ext] );
        fiHemiWarpR=fullfile(pa,[ prefix hemitest '_right' ext] );
        
        
        [ vol3 ]=getvolume(fiHemiWarpL,'==1');
        [ vol4 ]=getvolume(fiHemiWarpR,'==1');
        
        disp('hemisphere LR');
        mm=  [vol1 vol2; vol3 vol4];
        disp(mm);
        
        disp('Ratio');
        %     [vol1/vol2 vol3/vol4]
        ratio=[ 1/(mm(1,2)/(mean(mm(1,:))))
            1/(mm(2,2)/(mean(mm(2,:))))];
        disp(ratio);
        
        
        [ vol5]=getvolume(fullfile(thispath, 'mask.nii'),'==1');
        %       [ vol5]=getvolume(fullfile(pwd, 'wmask2_left.nii'),'==1')
        [pam fim ext]=fileparts(s.mskLesion);
        if s.lesion==1
              [ vol6]=getvolume(fullfile(pam,  [prefix  fim '_left' ext]),'==1') ;
%             [ vol6]=getvolume(fullfile(thispath, [prefix 'wmask2_left.nii']),'==1');
        else
             [ vol6]=getvolume(fullfile(pam,  [prefix  fim '_right' ext]),'==1') ;
        end
        
        disp('lesion');
        disp([vol5 vol6]);
    catch
        disp('could not show the OPTIONAL output');
    end
end






return


%% =========================EOF======================
% % % %
% % % % %% calc volumes
% % % % % [ vol ]=getvolume(['Xmask2_left.nii'],'==1')
% % % % % [ vol ]=getvolume(['hemi2_left.nii'],'==1')
% % % % % [ vol ]=getvolume(['Xhemi2_left.nii'],'==1')
% % % %
% % % %     disp('hemisphere(pre/post)');
% % % %     file=resn1;
% % % %     [pa2 fi ext]=fileparts(file);
% % % %     [ vol1 ]=getvolume(file,'~=0');
% % % %     [ vol2 ]=getvolume(fullfile(pa2,[     matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix  fi ext ]  ),'~=0');
% % % %     disp([vol1 vol2]);
% % % %
% % % %
% % % % disp('lesion(pre/post)');
% % % % file=resn2;
% % % % [pa2 fi ext]=fileparts(file);
% % % % [ vol3 ]=getvolume(file,'==1');
% % % % [ vol4]=getvolume(fullfile(pa2,[     matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix  fi ext ]  ),'==1');
% % % % disp([vol3 vol4]);
% % % %
% % % % vol4*(vol1/vol2)
% % % %
% % % %
% % % %
% % % %
% % % %
% % % %
% % % % %% left side
% % % % % hemisphere(pre/post)
% % % % %   270.5328  277.9331
% % % % %
% % % % % lesion(pre/post)
% % % % %    76.2024   65.9200
% % % % %
% % % % %
% % % % % ans =
% % % % %
% % % % %    64.1648
% % % % %% right side
% % % % % 254.3545  254.1853
% % % %
% if 0
%
%     [ vol1 ]=getvolume(fullfile(thispath, 'hemisphere.nii'),'==1');
%     [ vol2 ]=getvolume(fullfile(thispath, 'hemisphere.nii'),'==2');
%
%     prefix=matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix
%     [pa hemitest ext]=fileparts(mskHemi)
%     fiHemiWarpL=fullfile(pa,[ prefix hemitest '_left' ext] )
%     fiHemiWarpR=fullfile(pa,[ prefix hemitest '_right' ext] )
%
%
%     [ vol3 ]=getvolume(fiHemiWarpL,'==1');
%     [ vol4 ]=getvolume(fiHemiWarpR,'==1');
%
%     disp('hemisphere LR');
%     mm=  [vol1 vol2; vol3 vol4];
%     disp(mm);
%
%     disp('Ratio');
%     %     [vol1/vol2 vol3/vol4]
%     ratio=[ 1/(mm(1,2)/(mean(mm(1,:))))
%         1/(mm(2,2)/(mean(mm(2,:))))];
%     disp(ratio);
%
%
%     [ vol5]=getvolume(fullfile(pwd, 'mask.nii'),'==1');
%     %       [ vol5]=getvolume(fullfile(pwd, 'wmask2_left.nii'),'==1')
%     [ vol6]=getvolume(fullfile(pwd, 'Xwmask2_left.nii'),'==1');
%     disp('lesion');
%     disp([vol5 vol6]);
%
% end

% % % %
% % % %     if 0 %susanne
% % % %         %=CON+IPS - (CON+IPS-LAS)*(CON+IPS)/(2*CON)
% % % %         %78,49	230,18	259,22	52,57
% % % %         LAS=78.49
% % % %         CON=230.18
% % % %         IPS=259.22
% % % %         CON+IPS - (CON+IPS-LAS)*(CON+IPS)/(2*CON)
% % % %     end
% % % %        LAS=vol6
% % % %         CON=mm(2,2)
% % % %         IPS=mm(2,1)
% % % %         CON+IPS - (CON+IPS-LAS)*(CON+IPS)/(2*CON)
% % % %
% % % %
% % % %
% % % %
% % % %
% % % % end
% % % %
% % % %
% % % % %   259.2250  230.1750
% % % % %   262.5965  267.1815
% % % % %     1.1262    0.9828
% % % %

% % % %
% % % %