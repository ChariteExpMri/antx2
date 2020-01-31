

%% #yk xgetlabels4: get regionwise parameter for an image
%
%% #ko readout parameter: 'frequency', 'percOverlapp','volref','vol','mean','std','median','min','max'    
%  'percOverlapp': regionwise percent overlap with a mask ('masks'-must be defined, otherwise "100%")
%                 or regionwise percent survived above threshold-value  
%  'vol'        : volume of the region mask/threshold-dependent
%  'volref'     : volume of the region mask/threshold-independent --> reference value
%  'mean',  'std','median','min','max'  : parmaeter value within a region, mask/threshold-dependent
% #b: OUTPUT: excelfile with parameter values for the selected animal(s)..stored in the "results"-folder
%  
%
%% #ko PARAMETER
% 'files'   (read-out image) NIFTI file used for regionwise calculation of the readout parameter
%          - i.e. the resulting output: frequncies/intensities/mean... is extracted from this file
% 'masks'  (optional) a corresponding mask file. #b For instance a lesion mask file.
%         - order is irrelevant
%         - it is assumed that the mask-file is located in the animal's folder
%         - For space-parameter is "native" and "standard" : The masksfile
%           can be locate in another folder (templates folder)
%         
% ________________________________________________________________
% #r ADDITIONAL FILES FOR "OTHER SPACE". NECESSARY IF "OTHER SPACE"-SCENARIO
% Irrelevant for "native" and "standard" space.
% "OTHER SPACE" (see parameter below) describes the situation where the image is not in standard space (i.e. templates space)
% and not in the native space ("t2.nii"-space). 
% Examplary situation: The aim is to keep the read-out image in the original space. This space differs from native space:
% In this case, the atlas and hemisphere image is transformed from standard to native space and than further transformed
% (e.g. by registration) to the space of the read-out image. In this case the "OTHER SPACE" refers to the space of the 
% read-out image.
% 
% 'atlasOS'     The atlas in "other space". This is IMPORTANT ONLY IF "SPACE"-PARAMER IS SET TO "other"
% 'hemimaskOS'  The hemisphere mask in "other space". This is IMPORTANT ONLY IF "SPACE"-PARAMER IS SET TO "other"
% 
% #r NOTE: 'files', 'atlasOS' and 'hemimaskOS' are obligatory for "OTHER SPACE". It is also assumed that these images are in register
% ________________________________________________________________
% 
% PARAMETER
% 'atlas'       select atlas here (default: ANO.nii), atlas has to be the standard space  
% 'space'       calculation from images in "standard space", "native space" or "other space": 'standard','native','other'
%                 'standard':  read out from images in templates space
%                 'native'  :  read out from images space of the "t2.nii"
%                 'other'   :  see above
% 'hemisphere'  hemisphere to use:  {'left','right','both'}
%                 'left' : read out of left hemisphere only
%                 'right': read out of right hemisphere only
%                 'both' : read out of both hemisphere (united)
% 'threshold'   - lower intensity threshold value (values >=threshold will be excluded); 
%               - #r leave this field empty when using a mask ('masks'-parameter)
%% #ko RUN
% select animal(s) from gui before
% xgetlabels4: open gui, parmaeter will be defined via gui
% xgetlabels4(1,x); %open gui, use predfined struct-filed
% xgetlabels4(0,x); %no gui, use predfined struct-filed
%% #ko BATCH
% type "anth" or select [anth]-button from main-gui
%
%% =====================================================
%% #wg EXAMPLE-1 image from "STANDARD" SPACE with standard atlas
%% =====================================================
% x=[]
% x.files        =  { 'x_t2.nii' };	% files used for calculation
% x.masks        =  {''};	% <optional> corresponding maskfiles (order is irrelevant)or mask from templates folder
% x.atlas        =  'ANO.nii';	% select atlas here (default: ANO.nii), atlas has to be the standard space atlas
% x.space        =  'standard';	% calculation in standard space or native space {"standard","native"} 
% x.hemisphere   =  'both';	% hemisphere used: [left,right or both]
% x.threshold    =  '';	% lower intensity threshold value (values >=threshold will be excluded); leave field empty when using a mask
% xgetlabels4(0,x);  % NO GUI
%% =====================================================
%% #wg EXAMPLE-2 image from "OTHER SPACE" with special atlas
%% =====================================================
% x=[]
% x.files        =  { 'newSpace_t2.nii' };	% files used for calculation
% x.masks        =  {'newSpace_ix_caudoputamen.nii'};	% <optional> corresponding maskfiles (order is irrelevant)or mask from templates folder
% x.atlasOS      =  { 'newSpace_ix_pseudoANO.nii' };	% The atlas in "other space". IMPORTANT ONLY IF "SPACE"-PARAMER IS SET TO "other">
% x.hemimaskOS   =  { 'newSpace_ix_AVGThemi.nii' };	% The hemispher mask in "other space". IMPORTANT ONLY IF "SPACE"-PARAMER IS SET TO "other">
% x.atlas        =  'D:\Paul\data1\LabelsOtherSpace\templates\pseudoANO.nii';	% select atlas here (default: ANO.nii), atlas has to be the standard space atlas
% x.space        =  'other';	% calculation in standard space or native space {"standard","native"} 
% x.hemisphere   =  'both';	% hemisphere used: [left,right or both]
% x.threshold    =  '';	% lower intensity threshold value (values >=threshold will be excluded); leave field empty when using a mask
% xgetlabels4(1,x);  % gui pops up



function [z varargout] = xgetlabels4(showgui,x)
warning off;

if 0
    
end

%====================================================================================================

if exist('showgui')~=1;  showgui=1; end
if exist('x')~=1;        x=[]; end
if isempty(x); showgui=1; end
%====================================================================================================

pa=antcb('getsubjects');
v=getuniquefiles(pa);

p={...
    'inf98'      '*** GET ANATOMICAL LABELS             '                         '' ''
    'inf100'     '==================================='                          '' ''
    
    'inf11'        '____[ FILES/MASKS]________________________________________________________'    '' ''
    
    'files'      ''                                                           'files used for calculation' ,  {@selectfile,v,'single'} ;%'mf'
    'masks'      ''                                                           '<optional> corresponding maskfiles (order is irrelevant)or mask from templates folder', {@selectfileMask,v,'single'} % ,'mf' ...
    
    
    'inf133'        '________________________________________________________________________________'    '' ''
    'inf12'        '   ADDITIONAL FILES FOR "OTHER SPACE". Irrelevant for "native" and "standard" space. '    '' ''

    'atlasOS'    ''             'The atlas in "other space". IMPORTANT ONLY IF "SPACE"-PARAMER IS SET TO "other">' ,  {@selectfile,v,'single'} ;%'mf'
    'hemimaskOS' ''             'The hemispher mask in "other space". IMPORTANT ONLY IF "SPACE"-PARAMER IS SET TO "other">' ,  {@selectfile,v,'single'} ;%'mf'

    %
    
    'inf33'        '________________________________________________________________________________'    '' ''
    'inf3'      ' % PARAMETERS ' ''  ''
    'atlas'       'ANO.nii'     'select atlas here (default: ANO.nii), atlas has to be the standard space atlas' {@selectAtlas,v}
    'space'      'standard'     'use images from "standard","native" or "other" space '               {'standard' 'native' 'other'}
    'hemisphere'  'both'        'hemisphere used: [left,right or both]'                                     {'left','right','both'}
    
    'threshold'    ''     'lower intensity threshold value (values >=threshold will be excluded); leave field empty when using a mask' {'' 0}
    
    
    'inf44'        '________________________________________________________________________________'    '' ''
    'inf4'        '% READ-OUT PARAMETERS'      ' THESE PARAMETERS WILL BE GENERATED FROM EACH REGION '   ''
    'frequency'    1     'frequency: number of voxels within an anatomical region'                            'b'
    'percOverlapp' 1     'percent overlapp between mask and anatomical region'                                'b'
    'volref'       1     'volume [qmm] of anatomical region (REFERENCE)'                                      'b'
    'vol'          1     'volume [qmm] of (masked) anatomical region'                                         'b'
    'volPercBrain' 1     'percent volume [percent] of anatomical region relative to brain volume'             'b'
    'mean'         1     'mean of values (intensities) within anatomical region'                              'b'
    'std'          1     'standard deviation of values (intensities) within anatomical region'                'b'
    'median'       1     'median of values (intensities) within anatomical region'                            'b'
    'min'          1     'min of values (intensities) within anatomical region'                               'b'
    'max'          1     'max of values (intensities) within anatomical region'                               'b'
    };


p=paramadd(p,x);%add/replace parameter



%% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .6 .5 ],...
        'title','LABELING','info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

disp('..Atlas labeling..');
xmakebatch(z,p, mfilename); % ## BATCH


s=z;
s=getatlasType(s);  %get atlasType (1,2,3,4)
s=checkfiles(s);
s=readAtlas(s);     % read the atlas -->parse to table in s-struct

% assignin('base','s',s);
% return

dx    =[];
names ={};
voxvol=[];
for i=1:length(s.files)
    s2=s;
    s2.files=s.files{i};
    if isempty(s.masks)
        s2.masks='';
    else
        if s.isMskinOtherDir==1
            s2.masks=s.masks{1};
        else
            s2.masks=s.masks{i};
        end
    end
    dum=extractdata(s2);   % extrat data
    dx(   :,:,i)  =dum.tb   ;   % cube: [regs x params x subjects]
    names{1  ,i}  =dum.name;
    voxvol(i ,i)  =dum.voxvol;
end


%% SAVE
pp         = dum;
pp.tb      = dx;
pp.names   = names;
pp.voxvol  = voxvol;


fout=sub_atlaslabel2xls(pp,s);  %save to excel
showinfo2('new file' ,fout);







% disp('------------------------------------');
% disp(s);

return



%====================================================================================================


%% ##############################################################
%% % ############################### NEW SUBS  ###############################
%% ##############################################################






function pp=extractdata(s)
pp={};


%% CHAR
s.files=char(s.files);
s.masks=char(s.masks);
s.atlas=char(s.atlas);
s.atlaslabelsource=char(s.atlaslabelsource);

file=s.files;
mask=s.masks;

% ==============================================
%%   get necessary files
% ===============================================
pa=fileparts(s.files);
[~,name,~]=fileparts(pa);

clear w
if strcmp(s.space,'standard')==1
    w.hhemi=fullfile(pa,'AVGThemi.nii');
    w.hmask =fullfile(pa,'AVGTmask.nii');
    [pt]=fileparts(s.atlas);
    if isempty(pt);
        w.hano =fullfile(pa,s.atlas);
    else
        w.hano =s.atlas;
    end
    w.hfib =fullfile(pa,'FIBT.nii');
    
elseif strcmp(s.space,'native')==1
    w.hhemi=fullfile(pa,'ix_AVGThemi.nii');
    w.hmask =fullfile(pa,'ix_AVGTmask.nii');
    [pt fis ext]=fileparts(s.atlas);
    if isempty(pt);
        w.hano =fullfile(pa,['ix_' s.atlas]);
    else
        w.hano =fullfile(pt,['ix_' fis ext]);
    end
    w.hfib =fullfile(pa,'ix_FIBT.nii');

elseif strcmp(s.space,'other')==1  %other space
    
    w.hhemi=fullfile(pa, char(s.hemimaskOS));
    w.hmask =[];%fullfile(pa,'ix_AVGTmask.nii');
    w.hano =fullfile(pa, char(s.atlasOS));
     
end

% ==============================================
%%  always check wether atlas  it is in the mouse folder
% ===============================================

if  strcmp(s.space,'other')==0
    source  = strrep(w.hano,[filesep 'ix_'],[filesep ]) ;
    [ pat, atlasname, ext ]=fileparts(source);
    
    if strcmp(pat,pa)==0  %external atlas
        %check existence in the mouse folder
        atlas_inDir=    fullfile( pa,[ atlasname, ext ]);
        if exist(atlas_inDir)~=2
            copyfile(source,atlas_inDir,'f' );
        end
        if strcmp(s.space,'standard')==1
            w.hano=atlas_inDir;
        elseif strcmp(s.space,'native')==1
            w.hano=stradd(atlas_inDir,'ix_',1);
        end
    end
end
% ==============================================
%%  always check existence of FIB-atlas, and wether it is in the mouse folder
% ===============================================

useFIB=0;

if  strcmp(s.space,'other')==0
    if size(s.atlasTB,1)>1200 %workarounf to indentify that FIBT should be used
        
        source  = strrep(w.hfib,[filesep 'ix_'],[filesep ]) ;
        
        
        [ pat, atlasname, ext ]=fileparts(source);
        
        if strcmp(pat,pa)==0  %external atlas
            %check existence in the mouse folder
            atlas_inDir=    fullfile( pa,[ atlasname, ext ]);
            if exist(atlas_inDir)~=2
                copyfile(source,atlas_inDir,'f' );
            end
            if strcmp(s.space,'standard')==1
                w.hfib=atlas_inDir;
            elseif strcmp(s.space,'native')==1
                w.hfib=stradd(atlas_inDir,'ix_',1);
            end
        elseif strcmp(pat,pa)==1  %internal atlas
            atlas_inDir=    fullfile( pa,[ atlasname, ext ]);
            source=fullfile(s.patemp,[ atlasname, ext ]);
            if exist(atlas_inDir)~=2
                if exist(source)==2
                    copyfile(source,atlas_inDir,'f' );
                end
            end
            if exist(atlas_inDir)==2
                if strcmp(s.space,'standard')==1
                    w.hfib=atlas_inDir;
                elseif strcmp(s.space,'native')==1
                    w.hfib=stradd(atlas_inDir,'ix_',1);
                end
            end
        end
        
        fib_inDir=    fullfile( pa,[ atlasname, ext ]);
        if exist(fib_inDir)==2
            useFIB = 1;
        end
    end
end  % NATIVE/STANDARD-SPACE ONLY



% ==============================================
%%   check existence of masks in mouse folder
% ===============================================
if  strcmp(s.space,'other')==0
    % IF [AVGTmask.nii] does not exist, take it from the templates folder
    source  = strrep(w.hmask,[filesep 'ix_'],[filesep ])  ;
    [ pat fis ext ]=fileparts(source);
    if exist(replacefilepath(source,pa))~=2
        fistempl=fullfile(s.patemp,[fis ext]);
        if exist(fistempl)==2
            fano=strrep(w.hano,[filesep 'ix_'],[filesep ]);
            rreslice2target(fistempl, fano, source, 0);
        end
    end
    
    % IF [AVGThemi.nii] does not exist, take it from the templates folder
    source  = strrep(w.hhemi,[filesep 'ix_'],[filesep ])  ;
    [ pat fis ext ]=fileparts(source);
    if exist(replacefilepath(source,pa))~=2
        fistempl=fullfile(s.patemp,[fis ext]);
        if exist(fistempl)==2
            fano=strrep(w.hano,[filesep 'ix_'],[filesep ]);
            rreslice2target(fistempl, fano, source, 0);
        else % BEFORE UPDATE SITUATION for ALLENMOUSE
            
            AVmaskTPL=fullfile(s.patemp,'AVGTmask.nii');   %make HEMI-MASK in TEMPLATE-FOLDER
            AVhemiTPL=makeAVGThemi(AVmaskTPL);
            
            fano=strrep(w.hano,[filesep 'ix_'],[filesep ]); %RESLCE HEMI_MASK IN MOUSE-FOLDER
            rreslice2target(AVhemiTPL, fano, source, 0);
        end
    end
    
end  % NATIVE/STANDARD-SPACE ONLY


% ==============================================
%%   native space
% ===============================================

% fis=doelastix('transform'  , pa,    f3 ,0,'local' );
if strcmp(s.space,'native')==1     
    %% ANO-ATLAS
    volx = w.hano;
    if exist(volx)~=2
        source  = strrep(volx,[filesep 'ix_'],[filesep ]);
        if exist(source)==0; error(['### ' source ' - not found']);end
        
        [ ~, atlasname, ext ]=fileparts(source);
        if exist(fullfile(pa,[atlasname ext])) ==2          % # internal atlas
            fis=doelastix(-1, [],{source} ,0,'local' ) ; %,struct('source','intern'));
        else                                               % # EXTERNAL SOURCE
            fis=doelastix(-1, pa ,source ,0,'local',struct('source','intern'));
        end
        % external atlas 
    end
    
    %% FIB-ATLAS
    if useFIB==1
        volx = w.hfib;
        if exist(volx)~=2
            source  = strrep(volx,[filesep 'ix_'],[filesep ]);
            if exist(source)==0; error(['### ' source ' - not found']);end
            
            [ ~, atlasname, ext ]=fileparts(source);
            if exist(fullfile(pa,[atlasname ext])) ==2          % # internal atlas
                fis=doelastix(-1, [],{source} ,0,'local' ) ; %,struct('source','intern'));
            else                                               % # EXTERNAL SOURCE
                fis=doelastix(-1, pa ,source ,0,'local',struct('source','intern'));
            end
            % external atlas
        end
    end
    
    %% HEMISPHERE
    if strcmp(s.hemisphere,'both'); %brainMASK
        
        volx = w.hmask;
        if exist(volx)~=2
            source  = strrep(volx,[filesep 'ix_'],[filesep ]);
            if exist(source)==0; error(['### ' source ' - not found']);end
            fis=doelastix(-1, [],source ,0,'local' ) ; %,struct('source','intern'));
        end
        
    elseif strcmp(s.hemisphere,'left') || strcmp(s.hemisphere,'right')
        volx = w.hhemi;
        if exist(volx)~=2
            source  = strrep(volx,[filesep 'ix_'],[filesep ]);
            if exist(source)==0; error(['### ' source ' - not found']);end
            fis=doelastix(-1, [],source ,0,'local' ) ; %,struct('source','intern'));
        end
    end
    
    
end


% ==============================================
%%   OTHER SPACE
% ===============================================

if strcmp(s.space,'other')==1 
    
   
    [pas filename ext]=fileparts(w.hhemi);
    if ~isempty(strfind(filename,'hemi'));
        filename=regexprep(filename,'hemi','mask');
    else
        filename=[filename 'mask'];
    end
    w.hmask=fullfile(pas,[filename ext]);
    
    %if exist(w.hmask)~=2
        [ht t]=rgetnii(w.hhemi);
        t(t>0)=1;
        rsavenii(w.hmask,ht,t);
    %end
    clear pas filename ext ht t
    
end



% ==============================================
%%   read data
% ===============================================

% files = {fullfile(s.patemp,'ANO.nii') };
% mdirs = {'O:\data4\recode2Rat_WHS2\dat\t_fastsegm'
%     'O:\data4\recode2Rat_WHS2\dat\test_uncut' };
% fis=doelastix(1, pa,{fullfile(s.patemp,'ANO.nii') } ,0,'local' ,struct('source','extern'));

% [hac ac  ] =rgetnii(file);
[hac ac  ] =rreslice2target(file, w.hano, [], 0);
[hano ano]=rgetnii(w.hano);
ac0=ac;

%% HEMISPHERE
if strcmp(s.hemisphere,'both'); %brainMASK
    %[hbm bm]=rgetnii(w.hmask);
    [hbm bm  ] =rreslice2target(w.hmask, w.hano, [], 0);           %reslice if not the same format
elseif strcmp(s.hemisphere,'left')
    %[hbm bm]=rgetnii(w.hhemi);
    [hbm bm  ] =rreslice2target(w.hhemi, w.hano, [], 0);           %reslice if not the same format
    bm=double(bm==1);
elseif strcmp(s.hemisphere,'right')
    %[hbm bm]=rgetnii(w.hhemi);
    [hbm bm  ] =rreslice2target(w.hhemi, w.hano, [], 0);           %reslice if not the same format
    bm=double(bm==2);
end




%% MASK OR SET THRESHOLD
if ~isempty(mask)
    if s.isMskinOtherDir==0
         [hm m]=    rreslice2target(mask, w.hano, [], 0);
    elseif s.isMskinOtherDir==1
        if strcmp(s.space,'standard')
         [hm m]=    rreslice2target(mask, w.hano, [], 0);
        elseif strcmp(s.space,'native')
            %have to warp the file first in local drive
          % maskinverse= replacefilepath(stradd(mask,'ix_',1), fileparts(file))
         % fis=doelastix(-1, [],source ,0,'local' ) ; %,struct('source','intern'));  
         disp('..transform mask to native-space');            
         po.source =  'extern';
         fis=doelastix(-1, {fileparts(file)},{mask},0,'local' ,po);
         [hm m]=    rreslice2target(fis{1}, w.hano, [], 0);   
        elseif strcmp(s.space,'other') 
            error('mask must be in animal''s directory for space=="other"');
        end
    end
   
    m(m<1)=nan;  %m(m~=1)=nan;
    ac=ac.*(m);
else
    if ~isempty(s.threshold)
        ac(ac<=s.threshold)=nan;
    end
end

%% get AREA size
% s=areaSize({ano },bm,s);

%% get parameter
hano=spm_vol(w.hano);
[p q]=getvals(s,ano.*bm,ac,hano);

if useFIB==1
    [hfib fib]=rgetnii(w.hfib);
    [p2 ]=getvals(s,fib.*bm,ac,hano);
    
    %fibertracts starting with line-986 --> s.atlasTB(986,1)
    iFIBstart=find(strcmp(s.atlasTB(:,1), ['fiber tracts' ]));
    
    pano=[p.par(:,1:iFIBstart-1)];
    pfib=[p2.par(:,iFIBstart:end)];
    aglom=[pano  pfib];
    
    p.par=aglom;  %replace by ANO&FIB
    
end

%% —————————————————————————————————————————————————————————————————————————————————————————————————
%% ADDITIONAL PARAS
hem=bm;
hem(hem~=1)=nan;

voxvol=abs(det(hano.mat(1:3,1:3)));

%% [1] fulllbrain-size (both/left or right)
vals2=ac0.*hem;
vals3=vals2(hem==1);
vbrain=stats2(vals3,s,voxvol);        


%% [2] mask-size (both/left or right)
vals2=ac.*hem;
vals3=vals2(hem==1);
vmask=stats2(vals3,s,voxvol);

% disp(vbrain);
% disp('----');
% disp(vmask);

%  p.parh: {9x1 cell}
%  p.par: [9x80 double]

p.par2  = cell2mat([   vbrain(:,2)  vmask(:,2)   ]);
p.par2h ={'#brainvol' '#maskvol'}';
% ==============================================
%%   OUT
pp.tb     = ([p.par p.par2]') ;
pp.tbh    = [p.parh;]'       ;
pp.labadd =  p.par2h;
pp.name   =name;
pp.voxvol =voxvol;

%% ————————————————BACKUP—————————————————————————————————————————————————————————————————————————————————
%% logic:  map to measure (ac) is set to 'nan' below threshold or within mask (if used)
%% num ano-voxels calculated via exisiting ANO-id, num values and parematers calculated via 'no-nan' values
%% ### backup
if 0
    
    hem(hem==0)=nan;
    vals2=actmap.*hem;
    
    %     s  =stats(vals2(:),z,hano); %treshIMG
    %     s2 =stats(hem(:),z,hano);   %
    
    
    if 1 %BUG volREF
        
        
        %         if length(unique(vc))>2 %not binary mask
        %
        %         else
        %
        %
        %         end
        
        vals3=vals2(AVGTmask2==1);
        s  =stats(vals3(:),z,hano); %BRAINMASKED
        
        vals3=vals2(hem==1);
        s2  =stats(vals3(:),z,hano); %BRAINMASKED
        
        vc=vals2(:); vc(isnan(vc))=[];
        % length(unique(vc))
        if isempty(char(z.masks)) && isempty(char(z.masktag)) && length(unique(vc))>2
            sext=s;
        else
            
            
            vals4=vals2;
            vals4(isnan(hem))=-pi;
            AVGTmaskextended=((vals4~=-pi & ~isnan(vals4))+AVGTmask2)>0;
            %BINARY
            %AVGTmaskextended=((vals4>0)+AVGTmask2)>0;
            valsext=vals2(AVGTmaskextended==1);
            sext  =stats(valsext(:),z,hano);
            
        end
        
        % unmasked brain volume
        w.vol_brain(ii,1)         =abs(det(hAVGTmask.mat(1:3,1:3)) *(sum(AVGTmask2(:)==1)));
        w.vol_maskinbrain(ii,1)   =s{regexpi2(s(:,1),'^vol$'),2};
        w.vol_maskpainted(ii,1)   =s2{regexpi2(s2(:,1),'^vol$'),2};
        
        %         clc; sext,s,s2
        %         return
        
    end
    
    
    %     'frequency'       [    211175]
    %     'percOverlapp'    [   16.1114]
    %     'vol'             [1.0559e+03]
    %     'volref'          [6.5536e+03]
    %     'mean'            [  105.0729]
    %     'std'             [  152.0912]
    %     'median'          [    2.9860]
    %     'min'             [3.1284e-26]
    %     'max'             [  780.3038]
    %      return
    
    
    
    labnum=size(tab,1)+1;
    w.params(labnum,ii,:)= cell2mat(s(:,2));
    w.labels{labnum,1}  = 'withinBrainMask'  ;
    w.colorhex{1,labnum}='CA254D'  ;%red --> http://www.color-hex.com/
    
    labnum=size(tab,1)+2;
    w.params(labnum,ii,:)= cell2mat(sext(:,2));
    w.labels{labnum,1}  = 'withinBrainMaskExtended'  ;
    w.colorhex{1,labnum}='#800000'  ;%reddark --> http://www.color-hex.com/
    
    labnum=size(tab,1)+3;
    w.params(labnum,ii,:)= cell2mat(s2(:,2));
    w.labels{labnum,1}  = 'withinVolume'  ;
    w.colorhex{1,labnum}='E7D925'  ;%yellow --> http://www.color-hex.com/
    
    
    st={['[withinBrainMask]' enter...
    '  input volume is masked by the Allen mouse brain mask (AVGtmask.nii or ix_AVGTmask.nii, depending on space): ' enter...
    ' # The output parameters (frequency, percOverlapp, vol,mean etc.) refer to the punched-out input-volume "" ' enter ...
    '   The output  is relative to the hemispheric input parameter ("left","right" or "both").' enter...
    '   Thus volref & percentoverlapp allways refer to the  selected "left","right" or "both" - AllenMask volume ' enter...
    ' # If an additional mask is used, this stamped out inputvolume is further stamped out by the mask,' enter...
    '   thus, all output parameters refer to the volume located within the Allen mouse brain mask AND the inputMask ' enter...
    ]};
infox=[infox;st];
st={['[withinBrainMaskExtended]' enter...
    '  # similar to [withinBrainMask]. The difference is that sometimes a lesion (masklesion)is slightly ' enter...
    '    located outside the Allen mouse brain mask (in ~20 cases 1-5% volume outside the AVGtmask.nii ) ' enter ...
    '    Here, the Brain mask is extended, see below' enter ...
    '  # Possible Reasons: Combination of accuracy of mask delineation, transformation, ' enter...
    '    mask-interpolation (next neighbour interp), accuracy of overlay between ANO.nii, AVGT.nii, threshold-level to generate AVGTmask.nii   ' enter...
    '  # In this case the  Allen mouse brain mask  (AVGTmask.nii) is:   ' enter...
    '     (a) extended (set union) by the input volume: ' enter...
    '        -for this, the input volume must be binary:  '  enter...
    '        -example:  input volume is a binary lesion mask --> volume of brainMask is extended by masklesion.nii '  enter...
    '     (b) extended (set union) by the mask volume: which is given as additonal parameter' enter ...
    '        -for this, the mask vulume must be binary:  '  enter...
    '        -example: input volume "x_t2.nii" and the mask "masklesion.nii" --> volume of brainMask is extended by masklesion.nii  '  enter...
    ' # If input volume is not binary and no further mask is used [withinBrainMaskExtended] and [withinBrainMask] should yield similar results ,' enter...
    ' # NOTE: you have to decide whether [withinBrainMask] or [withinBrainMaskExtended] better suits to your data (see reasons) ,' enter...
    ' # NOTE: the read out parameters for the Anatomical regions is independet from [withinBrainMask]/[withinBrainMaskExtended] and should be the same (i.e. anatomical regions are not! masked again by a brain mask! )  ,' enter...
     ]};
infox=[infox;st];
st={['[withinVolume]' enter...
    '  # here the reference is the entire input volume (bounding box) depending which   ' enter...
    '    hemispheric input parameter ("left","right" or "both") has been selected'   ...
    ]};

end
%% —————————————————————————————————————————————————————————————————————————————————————————————————

% ###








function [p s]=getvals(s,ANO,ac,hano);
% ==============================================
%%   get values
% s    : struct with all information
% ANO  : ANO vol (3d)
% ac   : volume to measure data from (3d)
% ===============================================


anv=(ANO(:));
% ac=actmap(:);
uni=unique(anv);
if uni(1)==0; uni(1)=[]; end
si=size(ANO);

%% get all vox-idx for all labels within ANO.nii
iv={};
for i=1:length(uni)
    ix= find(anv==uni(i));
    iv{i,1}=ix;
end
% toc
%% get label and ots children from LUTS
% lab=[{luts.info.id }' {luts.info.children}'];

id     =  s.atlasTB(:,4);
child  =  s.atlasTB(:,5);
child  = cellfun(@(a) {str2num(regexprep(num2str(a),'NaN',''))} ,child);
child  = cellfun(@(a) { (a(:))} ,child);  %force  downVector

% lab=cellfun(@(a,b) {[a b]}, id, child)
lab=[[id child]];

voxvol=abs(det(hano.mat(1:3,1:3))) ;
params={};
for i=1:size(lab,1)
    %% INTERSECTION UNIQUE LABEL IN ANO AND LUTS+ITS CHILDREN
    [com a1 a2]=intersect(uni, [lab{i,1} ;lab{i,2} ]); %
    vx=iv(a1);
    vz=cell2mat(vx); %get indices for label ( Nx2 array)
    vals=ac(vz); %get values of inputfile
    
    %% EXTRACT PARAMETERS (DEFINED IN Z-STRUCT)
    %s=stats(vals,z,hano);
    vv=stats2(vals,s,voxvol);
    params(:,i)=vv(:,2);
end
p.parh=vv(:,1);
p.par   =cell2mat(params);
% p.label    ={luts.info.name }';

s.p=p;

% ==============================================
%%   stats2
% ===============================================


function [params]=stats2(anm,z,voxvol)
%     anm: masked volume
%       z: parameterstruct containing boolean (freqnecy, percOverlapp etc)
% voxvol: voxelvolume of ANO-file .. abs(det(hano.mat(1:3,1:3)))
%----------------------
% hano: header ANO
is=find(~isnan(anm));%idx of noNAN

d.paramname ={};
d.param     ={};
if z.frequency==1
    d.param{1,end+1}  = length(is);                        d.paramname{1,end+1}   = 'frequency'  ;
end
if z.percOverlapp==1
    d.param{1,end+1}  = (length(is)/length(anm))*100;      d.paramname{1,end+1}  = 'percOverlapp'    ;
end
if z.vol==1
    d.param{1,end+1}  = voxvol*length(is);                 d.paramname{1,end+1}='vol';
    %d.param{1,end+1}  = abs(det(hano.mat(1:3,1:3)) *( length(is)  ));  d.paramname{1,end+1}='vol';
end
if z.volref==1
    d.param{1,end+1}  = voxvol*length(anm);                d.paramname{1,end+1}='volref';
    %d.param{1,end+1}  = abs(det(hano.mat(1:3,1:3)) *( length(anm)  ));  d.paramname{1,end+1}='volref';
    
end


if z.mean==1
    d.param{1,end+1} = mean(anm(is));                      d.paramname{1,end+1}  = 'mean'        ;
end
if z.std==1
    d.param{1,end+1} = std(anm(is));                       d.paramname{1,end+1}  = 'std'        ;
end
if z.median==1
    d.param{1,end+1} = median(anm(is));                    d.paramname{1,end+1}  = 'median'        ;
end
if z.min==1
    d.param{1,end+1} = min(anm(is));                       d.paramname{1,end+1}  = 'min'        ;
end
if z.max==1
    d.param{1,end+1} = max(anm(is));                       d.paramname{1,end+1}  = 'max'        ;
end



d.param(cellfun('isempty',d.param))={nan};

params=[d.paramname' d.param'];



function s=readAtlas(s);

if s.atlastype==2     % ALLEN ATLAS -gematlabed #
    % ==============================================
    %%   scenario: ALLENMOUSE-ATLAS..xls not generated jet (not found in the templates folder)
    % ===============================================

    [ lx lu]=getAtlasID_AllenMouse ;
    hex=char(lx(:,4));
    rgb=[hex2dec(hex(:,1:2)) hex2dec(hex(:,3:4)) hex2dec(hex(:,5:6))];
    rgb=cellfun(@(a,b,c) {[a ' ' b ' ' c]}, cellstr(num2str(rgb(:,1))),cellstr(num2str(rgb(:,2))),cellstr(num2str(rgb(:,3))));
    s.atlasTB   =[   lx(:,1)    cellstr(hex)        rgb    lx(:,2)       lx(:,3)    ];
    s.atlasTBH  ={ 'Region'         'colHex'    'colRGB'      'ID'    'Children'    };
    
    atlasxls=fullfile(s.patemp,'ANO.xls')
    if exist(atlasxls)~=2                 
        f1   = which('ANO_AllenMouse.xls');    % copy new xls-file if not existed before in templatePATH
        f2   = atlasxls;
        copyfile(f1,f2,'f');
        %% ALTERBATIVE:         
        %fiout=xls_atlas2xls(tb,volAtlas)      % make new xls-file if not existed before in templatePATH
    end
    
    
    
else
    if isempty(s.atlaslabelsource);
        error(['### no atlas-label file found']);
    end
    [pa fi ext]=fileparts(s.atlaslabelsource);
    if strfind(ext,'.xls')
        do=1;
    else
        do=0;
        disp(['### only exlcelfile {.xls, .xlsx} supported (jet)']); return
    end
    
    if do==1;
        [~, sheets]=xlsfinfo(s.atlaslabelsource);
        sheetid=regexpi2(sheets,'atlas','ignorecase');
        [~,~, a]=xlsread(s.atlaslabelsource,sheetid);
        nanrow=cellfun(@(a) {num2str(a)}, a(:,1));
        a(strcmp(nanrow,'NaN'),:)=[];
        nancol=cellfun(@(a) {num2str(a)}, a(1,:));
        a(:,strcmp(nancol,'NaN'))=[];
        s.atlasTB  =a(2:end,:);
        s.atlasTBH =a(1,:);
    end
    
    % ==============================================
    %%
    % ===============================================

    %if strcmp('space')
    
    
end


function s=checkfiles(s)
%% make fullpath-files -check sanity & order for files and masks
z=s;
if ischar(z.files);  z.files=cellstr(z.files); end

try
    fi_empty=isempty(z.files{1});
catch
    fi_empty=isempty(z.files)  ;
end

try
    ma_empty=isempty(z.masks{1});
catch
    ma_empty=isempty(z.masks);
end

if fi_empty==1; error('## no input files found'); return; end

%% make fullpath files
files={};
[pa fi ext]=fileparts(z.files{1});
if isempty(pa)                              % # use GUI selection --> make fullpath files
    px=antcb('getsubjects');
    files=stradd(px,[ filesep z.files{1}],2);
else
    files=z.files;
end

%% make fullpath masks
masks={};
z.masks=cellstr(z.masks);
if ma_empty==0
    [pa fi ext]=fileparts(z.masks{1});
    if isempty(pa)                              % # use GUI selection --> make fullpath files
        px=antcb('getsubjects');
        masks=stradd(px,[ filesep z.masks{1}],2);
    else
        masks=z.masks;
    end
end

%% check existence of files
fex=zeros(length(files),1);
for i=1:length(files)
    if exist(files{i})==2; fex(i)=1; end
end
files=files(fex==1);

%% check existence and order of masks ...> remove files or masks if one of the two is not found
if ~isempty(masks)
    files2={};
    masks2={};
    for i=1:length(masks)
        if exist(masks{i})==2;
            ix=min(find(~cellfun('isempty',strfind(files, fileparts(masks{i})))));
            if ~isempty(ix);
                files2{end+1,1} = files{ix};
                masks2{end+1,1} = masks{i};
            end
            
        end
    end
else
    files2=files;
    masks2={};
end
%=======================================================================
% check if templates mask-file is used
isMskinOtherDir=0;
if length(masks)==1
    if exist(masks{i})==2
        if ~isempty(strfind(masks{1},[filesep 'templates' filesep]));% in templates folder
           isMskinOtherDir=1; 
        else %another source
            ix=min(find(~cellfun('isempty',strfind(files, fileparts(masks{1}))))); %not in dat-folder
            if isempty(ix)
             isMskinOtherDir=1;    
            end
        end
    end
end
if isMskinOtherDir==1
    files2=files;
    masks2=masks;
end

s.isMskinOtherDir=isMskinOtherDir;
%=======================================================================


if isempty(files2) &&  isempty(masks2)
    error('## no matching input files anf maskfiles found');
end
s.files=files2;
s.masks=masks2;


s.project=fileparts(fileparts(fileparts(s.files{1})));



%
% disp(s.files);
% disp('---')
% disp(s.masks);





% ==============================================
%%   compute area size
% ===============================================

function s=areaSize(vols,bm,s)
% ==============================================
%%   calc area size of input atlas, hemi-dependent
% ===============================================
% vols: 1 mor more vols
% bm: brain mask: 0/1-masked
% s: structure

id    =cell2mat(s.atlasTB(:,4));
childs=(s.atlasTB(:,5));
childs=cellfun(@(a) {str2num(num2str(a))}, childs);



% if 1 %   simulate
%    id(end)=999
%    childs(end)={[1 2]}
% end

if ~iscell(vols); vols={vols}; end %convert to cell
bm(isnan(bm))=0;

counts = zeros(length(id),1);
for i=1:length(vols)
    anox=vols{i}.*bm;
    [countsdum ]=histc(anox(:) ,id );
    counts=counts+countsdum;
end

% idall=num2cell(id); % all ids/subids
for k = 1:length(counts)
    if counts(k) ==0 %isempty(counts(k))
        [common, ia, ib] = intersect(id, childs{k}) ;
        if not(isempty(ia))
            voxsz = sum([counts(ia)]);
            counts(k) = voxsz;
            %idall{k}=[ia'];
        end
    end
end
s.voxcounts=counts;

%% get indices
% % tic
% idx=repmat({0},[length(counts) 1]);
% for j=1:length(vols)
%     anox=vols{j}; anox=anox(:);
%     for k=1:length(counts)
%         [~,ind]=histc( anox,idall{k});
%         idx{k,1}=unique([idx{k,1}; single(find(ind>0))]);
%     end
%     
% end
% % toc
% s.ind=idx;

function v=getuniquefiles(pa)
%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
% keyboard
% global an
% pa=antcb('getallsubjects'); %path
% pa=antcb('getsubjects'); %path

li={};
fi2={};
fifull={};
for i=1:length(pa)
    [files,~] = spm_select('FPList',pa{i},['.*.nii*$']);
    if ischar(files); files=cellstr(files);   end;
    fis=strrep(files,[pa{i} filesep],'');
    fi2=[fi2; fis];
    fifull=[fifull; files];
end
li=unique(fi2);
[li dum ncountid]=unique(fi2);
%% count files
ncount=zeros(size(li,1),1);
for i=1:size(li,1)
    ncount(i,1) =length(find(ncountid==i));
end
%% get properties spm_vol
fifull2=fifull(dum);
tb  = repmat({''},[size(fifull2,1)  ,4]);
tbh ={'Ndims' 'size' 'resolution' 'origin'} ;
for i=1:size(fifull2,1)
    ha=spm_vol(fifull2{i});
    ha0=ha;
    ha=ha(1);
    if length(ha0)==1
        tb{i,1}='3';
        tag='';
    else
        tb{i,1}='4' ;
        tag= length(ha0);
    end
    tb{i,2}=sprintf('%i ',[ha.dim tag]);
    tb{i,3}=sprintf('%2.2f ',diag(ha.mat(1:3,1:3))');
    tb{i,4}=sprintf('%2.2f ',ha.mat(1:3,4)')  ;
end


v.tb =[li cellstr(num2str(ncount)) tb];
v.tbh=[{'Unique-Files-In-Study', '#found'} tbh];

function he=selectfile(v,selectiontype)
% ==============================================
%% get file/masks
% ==============================================
he='';
h1=selector2(v.tb,v.tbh,...%'iswait',0,...
    'out','col-1','selection',selectiontype);
if ~isempty(h1)
    he=cellstr(h1);
end

function he=selectfileMask(v,selectiontype)
he='';
choice = questdlg('Where are/is the mask located?', ...
'Select mask location', ...
'animal folder(s)','templates folder','cancel','animal folder(s)');

if strcmp(choice, 'animal folder(s)')
    he='';
    h1=selector2(v.tb,v.tbh,...%'iswait',0,...
        'out','col-1','selection',selectiontype);
    if ~isempty(h1)
        he=cellstr(h1);
    end
elseif strcmp(choice, 'templates folder')
    pat=fullfile(pwd,'templates');
    if exist(pat)~=7
        pat=pwd;
    end
    [fi pa]=uigetfile(fullfile(pat,'*.nii'),'select a maskfile from templates-folder');
    if isnumeric(fi); he=''; end
    he=cellstr(fullfile(pa,fi));
else
    he=''
end



% % % % % % %fullpath
% % % % % % pa=antcb('getsubjects');
% % % % % % he={};
% % % % % % for i=1:length(h1)
% % % % % %     for j=1:size(pa,1)
% % % % % %         dum=fullfile(pa{j},h1{i})
% % % % % %         if exist(dum)==2;
% % % % % %             he{end+1,1}=dum;
% % % % % %         end
% % % % % %     end
% % % % % % end

function refAtlas=selectAtlas(v)
% ==============================================
%% select atlas intern/extern..
% ==============================================
refAtlas='ANO.nii';

msg=[]; %msg{end+1,1}=['       '];
msg{end+1,1}=['      ************************************************************'];
msg{end+1,1}=['                                     *  Select Atlas  *'];
msg{end+1,1}=['      ************************************************************'];

msg{end+1,1}=['  Select the used reference atlas here. This atlas has to be: '];
msg{end+1,1}=['                          - a Nifti-Image'];
msg{end+1,1}=['                          - located in "standard" space '];

msg{end+1,1}=[''];
msg{end+1,1}=['____<OPTIONS>__________________'];
msg{end+1,1}=['(1) ANO.nii is the default atlas (located in the animal specific folder in the "dat"-folder). '];
msg{end+1,1}=['_______________________________'];
msg{end+1,1}=['(2) Use [OTHER LOCAL ATLAS] to select a specific atlas located in the animal specific folder.'];
msg{end+1,1}=['_______________________________'];
msg{end+1,1}=['(3) Use [OTHER EXTERNAL ATLAS] to select a specific atlas located somewhere else (e.g. an atlas located in the template path)'];

% helpdlg(msg)

iSel=4; %points to help
while iSel==4 %'HELP
    inputOptions={'ANO.nii', 'other local atlas ', 'other external atlas', 'Help',...
        'Cancel'};
    defSelection=inputOptions{1};
    iSel=bttnChoiseDialog(inputOptions, 'Demonstarte bttnChoiseDialog', defSelection,...
        { ['Select ATLAS' char(10) 'ee'],'eee'});
    if iSel==4
        helpdlg(msg);% uhelp(msg);
    end
end
%__________________________________
if     iSel==5; return;
elseif iSel==1; refAtlas='ANO.nii';
elseif iSel==2;
    t=selector2(v.tb,v.tbh,...%'iswait',0,...
        'out','col-1','selection','single');
    if ~isempty(t); refAtlas=char(t);    end
    
elseif iSel==3;
    [t,sts] = spm_select(1,'any','select Atlas' ,'',pwd,'.*.nii',1);
    if ~isempty(t); refAtlas=char(t);    end
end
% he=refAtlas;



function s=getatlasType(s);
%% GET ATLAS ,parse to struct

s.atlas=char(s.atlas);

% get template-path
px=antcb('getsubjects');
s.patemp=fullfile(fileparts(fileparts(px{1})),'templates');

[pa fi ext]=fileparts(s.atlas);
islocal=1;
if ~isempty(pa)
    islocal=0;
end
atname=[fi ext];
atlastype=[];
if  (islocal==1)                                % [1] use local Atlas
    if (strcmp(atname,'ANO.nii')==1)  ;         % [1.1] use ANO.nii
        
        fmt={['ANO.xls'], ['ANO.xlsx']};
        ex(1)=exist(fullfile(s.patemp,fmt{1})) ;         ex(2)=exist(fullfile(s.patemp,fmt{2})) ;
        if ~isempty(find(ex==2) )              %% [1.1.1]; use EXCELFILE
            atlastype         =1;
            atlastypestr      ='local-ANO-excel'                    ;
            atlaslabelsource  =fullfile(s.patemp, fmt{find(ex==2) });
        else                                   %% [1.1.2]; use gematlabtLabels from AllenMouse
            atlastype        =2;
            atlastypestr     ='local-ANO-AllenMouseMat'             ;
            atlaslabelsource =which('gematlabt_labels.mat')         ;
        end
    else                                        %% [1.2] use another local atlas
        atlastype=3;
        atlastypestr='local-otherAtlas-excel'                       ;
        
        [pat name ext2]=fileparts(s.atlas);
        fmt={[name '.xls'], [name '.xlsx']};
        ex(1)=exist(fullfile(s.patemp,fmt{1})) ;   ex(2)=exist(fullfile(s.patemp,fmt{2})) ;
        if ~isempty(find(ex==2) )
            atlaslabelsource   =fullfile(s.patemp, fmt{find(ex==2) });
        else
            disp(['### NO ATLAS LABELS FOUND..see documentation of [' mfilename '.m]']);
            error(' ..');
        end
        
    end
else                                            % [2] external atlas
    atlastype=4;
    atlastypestr='extern-otherAtlas-excel' ;
    
    [pat name ext2]=fileparts(s.atlas);
    fmt={[name '.xls'], [name '.xlsx']};
    ex(1)=exist(fullfile(pat,fmt{1})) ;   ex(2)=exist(fullfile(pat,fmt{2})) ;
    if ~isempty(find(ex==2) )
        atlaslabelsource   =fullfile(pat, fmt{find(ex==2) });
    else
        disp(['### NO ATLAS LABELS FOUND..see documentation of [' mfilename '.m]']);
        error(' ..');
    end
    
end

% disp('---------');
% atlastype
% atlastypestr
% atlaslabelsource

s.atlastype          = atlastype;
s.atlastypestr       = atlastypestr;
s.atlaslabelsource   = atlaslabelsource;























