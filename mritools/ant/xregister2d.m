%% slicewise register (2D)  sourceImage(nii) to referenceImage (nii)
% #ww
% #ww
% #yk xregister2d.m
%% #b slicewise register (2D)  sourceImage(nii) to referenceImage (nii)
%
% might be used for tasks, where slice-to-slice assignment is ok, but a transformation
% (rigid, affine and/or b-spline) has to be done slice-wise (2D-problem)
% #r EXAMPLE: register CBF-DATA (single slice) onto t2.nii image
% DIRS:  works on preselected mouse dirs, i.e. mouse-folders in [ANT] have to be selected before
% ______________________________________________________________________________________________
%
%% #ky PARAMETER:
%
% x.refIMG  	- SELECT REFERENCE IMAGE (example: t2.nii)
% x.sourceIMG   - SELECT SOURCE IMAGE (the image that should be transformed,slicewise)
% x.renameIMG   - (optional) rename-string for the new file, otherwise the name of the new file is
%                 ['p' sourceIMGname]        (default: '', i.e. use p-prefix)
% __________________________________________
% x.rigid       - do    rigid transformation <boolean> [1] yes, [0] no    (default: 1)
% x.affine      - do   affine transformation <boolean> [1] yes, [0] no    (default: 1)
% x.bspline     - do b-spline transformation <boolean> [1] yes, [0] no    (default: 1)
% __________________________________________
% x.InterpOrder       -  'InterpolationOrder: [0]nearest neighbor, [1]trilinear interpolation, [3]cubic' {0 1 3}(default: 0)
% x.xyresolution      - xy-slice-resolution  "ref" from refIMG, "source" from sourceIMG (default: 'ref')
% x.preserveIntensity - keep original image intensity:
%                     - [0] no
%                     - [1] min-max-range of the slice is preserved
%                     - [2] preserve mean+SD
% x.sliceAssign       - slice-to-slice assignment of refIMG & sourceIMG:
%                       set "auto" to use image information from refIMG & sourceIMG; (default: 'auto')
%                       otherwise specify a pairwise vector/matrix such
%                       as [15 1] to assign refIMG-slice-15 to sourceIMG-slice-1 or
%                       or [15 1; 16 2]  to assign refIMG-slice-15 to sourceIMG-slice-1 and
%                       refIMG-slice-16 to sourceIMG-slice-2
% x.reslice2refIMG'    - force to match dimensions of refImage'  <boolean> [1] yes, [0] no    (default: 1)
%                      - NOTE: currently, this is mandatory to later warp the sourceIMG to Allen-space
%                      - this step fills "spacing" dummy slices with zero-elements
% x.createMask'        - create binary MaskImage    <boolean> [1] yes, [0] no    (default: 1)
%                      - mask name: filename: "newfilename+_mask"]'  'b'
%                      - rule: registered slices with "1"s, spacing dummy slices with "0"-elements
%                      - NOTE: maskImage can be later used to assist the atlas-based read out of
%                        values in native or allen space. For Allen space readout, the registered
%                        sourceIMG and corresponding mask has to be brought into Allen space
% __________________________________________
% x.cleanup           - remove unnecessary data afterwards, <boolean> [1] yes, [0] no (default: 1)
% x.keepFolder=       - keeps local 2d-elastix folder       <boolean> [1] yes, [0] no (default: 0)
%
% ______________________________________________________________________________________________
%% #ky RUN-def:
% xregister2d(showgui,x)
% with inputs:
% showgui: (optional)  :  0/1   :no gui/open gui
% x      : (optional)  : struct with one/more specified parameters from above:
%
% xregister2d(1) or  FUNCTION    ... open PARAMETER_GUI with defaults
% xregister2d(0,z)                ...run without GUI with specified parametes (z-struct)
% xregister2d(1,z)                ...run with opening GUI with specified parametes (z-struct)
%
% ______________________________________________________________________________________________
%% #ky BATCH EXAMPLE
%%% ••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%% BATCH:        [xregister2d.m]
%%% descr:  #b slicewise register (2D)  sourceImage(nii) to referenceImage (nii)
%%% ••••••••••••••••••••••••••••••••••••••••••••••••••••••
% z=[];
% z.refIMG            = { 't2.nii' };      % % (<<) SELECT REFERENCE IMAGE (example: t2.nii)
% z.sourceIMG         = { 'cbf.nii' };     % % (<<) SELECT IMAGE to transform in 2D
% z.applyIMG          = { '' };            % % (<<) SELECT IMAGE to apply transformation, (if empty sourceIMG is also the applied IMAGE)
% z.renameIMG         = '';                % % (optional) rename-string for the new file, otherwise the prefix "p"+sourceIMG-name is used
% z.rigid             = [1];               % % do rigid transformation
% z.affine            = [1];               % % do affine transformation
% z.bspline           = [1];               % % do b-spline transformation
% z.InterpOrder       = [1];               % % Final InterpolationOrder: [0]binary masks, [1]linear, [3]cubic
% z.xyresolution      = 'ref';             % % Final XY-resolution: "ref" from refIMG, "source" from sourceIMG
% z.preserveIntensity = [2];               % % keep original image intensity
% z.sliceAssign       = 'auto';            % % Slice-to-slice assigment of refIMG & sourceIMG: "auto" use image information; otherwise specify as pairwise vector/matrix such as [15 1] or [15 1; 16 2]
% z.reslice2refIMG    = [1];               % % force to match dimensions of refImage
% z.createMask        = [1];               % % create binary MaskImage  [ used slices contain "1"-elements; filename: "newfilename+_mask"]
% z.cleanup           = [1];               % % remove unnecessary data
% z.keepFolder        = [0];               % % keeps local 2d-elastix folder
% xregister2d(1,z);
%
%% #r RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
%
%

function xregister2d(showgui,x,pa)


%———————————————————————————————————————————————
%%   example
%———————————————————————————————————————————————
if 0
    
    
    
    
end

%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                           ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end

if ischar(pa); pa=cellstr(pa); end

%% get unique-files from all data
% pa=antcb('getsubjects'); %path
v=getuniquefiles(pa);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end
p={...
    'inf0'      '*** SLICEWISE TRANSFORM-2D      ****     '         '' ''
    'inf1'      ['routine: [' mfilename '.m]']                         '' ''
    'inf7'     '====================================================================================================='        '' ''
    'refIMG'        {''}      '(<<) SELECT REFERENCE IMAGE (example: t2.nii)'  {@selectfile,v,'single'}
    'sourceIMG'     {''}      '(<<) SELECT IMAGE to calculate the transformation        '  {@selectfile,v,'single'}
    'applyIMG'      {''}      '(<<) SELECT 1/more IMAGES to apply transformation, (if empty sourceIMG is transformed         '  {@selectfile,v,'multi'}
    'inf77'     '====================================================================================================='        '' ''
    %     'renameIMG'     ''       '(optional) rename-string for the new file, otherwise the prefix "p"+sourceIMG-name is used'  {@renamefiles,[],[]}
    'prefix'     'p'       'this prefix is used for the output file >>[prefix+"name of applyIMG"]'   {@renamefiles,[],[]}
    
    
    % z.applyIMG          = { '' };            % % (<<) SELECT IMAGE to apply transformation, (if empty sourceIMG is also the applied IMAGE)
    
    %   'fileprefix'    'h_'     'add a file-prefix to output-files (this is only used if "renameIMG" is empty )'   ''
    'rigid'          0        'do rigid transformation'    'b'
    'affine'         1        'do affine transformation'   'b'
    'bspline'        1        'do b-spline transformation' 'b'
    'inf8'     '====================================================================================================='        '' ''
    'InterpOrder'         0    'InterpolationOrder: [0]nearest neighbor, [1]trilinear interpolation, [3]cubic' {0 1 3}
    'xyresolution'      'ref'  'Final XY-resolution: "ref" from refIMG, "source" from sourceIMG'   {'ref'  'source'}
    'preserveIntensity'   0    'preserve intensity: [0] no, [1] preserve min-max-range [2] preserve mean+SD' {0 1 2}
    'sliceAssign'     'auto' 'Slice-to-slice assigment of refIMG & sourceIMG: "auto" use image information; otherwise specify as pairwise vector/matrix such as [15 1] or [15 1; 16 2]  ' {'auto'; '1 15'}
    'reslice2refIMG'      1    'force to match dimensions of refImage'  'b'
    'createMask'          1    'create binary MaskImage  [ used slices contain "1"-elements; filename: "newfilename+_mask"]'  'b'
    'inf9'     '====================================================================================================='        '' ''
    'cleanup'         1        'remove unnecessary data' 'b'
    'keepFolder'      1        'keeps local 2d-elastix folder' 'b'
    
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .5 .35 ],...
        'title','PARAMETERS: replaceheader','info',{@uhelp, 'xregister2d.m'});
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%———————————————————————————————————————————————
%%   PROCESS
%———————————————————————————————————————————————
atic=tic;  %timer


g=z;

%% chekcs
g.refIMG    =cellstr(g.refIMG);
g.sourceIMG =cellstr(g.sourceIMG);
g.applyIMG =cellstr(g.applyIMG);


%% prepare APPLYIMGS: sourceImage is added
g.applyIMG=unique([g.sourceIMG(:); g.applyIMG(:) ]);
g.applyIMG(find(cellfun(@isempty,g.applyIMG)))=[];

%% PREFIX if more than 1 applyIMG
% if size(g.applyIMG,1)==1 && ~isempty(g.renameIMG)
%     g.applyIMGnew= [strrep(g.renameIMG,'.nii','') '.nii'];
% else
%     g.applyIMGnew= stradd(g.applyIMG,'p',1);
% end

if isempty(g.prefix)
    g.prefix='p';
end
g.applyIMGnew= stradd(g.applyIMG,g.prefix,1);




%% running trough MOUSEfolders
disp('*** register2D (slicewise) ***');
size(pa)
disp(length(pa))
for i=1:length(pa)
    disp('inloop____###');
    transformx(pa{i},g );
    
    
    %     ref=fullfile(pa{i},z.refIMG{1});
    %     if exist(ref)==2
    %         img =fullfile(pa{i},g.fold{1});
    %         if exist(img)==2
    %             %                 disp('---------');
    %             %                 disp(['ref: ' ref]);
    %             %                 disp(['img: ' img]);
    %             %                 disp('---------');
    %             imgnew = char(fullfile(pa{i},g.fnew));
    %             transformx(ref,img,imgnew, g   );
    %         end
    %     end
end


try
    makebatch(z,p);
end

btic=toc(atic);
disp(['.DONE!  FUNCTION: [' [mfilename '.m' ] ']; BATCH: see["anth"] in workspace']);
disp([sprintf('   elapsed time: %2.2f min', btic/60)]);



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% subs
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% function  transformx(ref,img,imgnew, g   );
function  transformx(pa,g   );
disp('intransform____###');
%% check existence of files
ref = fullfile(pa,char(g.refIMG));
sou = fullfile(pa,char(g.sourceIMG));
app = stradd(g.applyIMG,[pa filesep],1);

if exist(ref)~=2  ; return;     end
if exist(sou)~=2  ; return;     end
appexist=ones(size(app,1),1);
for i=1:size(app)
    if exist(app{i})~=2  ; appexist(i)=0;    end
end
app=app(find(appexist==1));

disp('files exists____###');



%% COPY PARAMETERFILES
% felastix2d='C:\Users\skoch\Desktop\parafiles2D'
felastix2d=fullfile(fileparts(fileparts(which('ant.m'))),['elastix' ],'paramfiles','paramfiles2D');
pfile00={...
    fullfile(felastix2d,'Par0034rigid_2D.txt'   )
    fullfile(felastix2d,'Par0034affine_2D.txt'  )
    fullfile(felastix2d,'Par0034bspline_2D.txt' )};
pfile0=strrep(pfile00,felastix2d,pa);
copyfilem(pfile00,pfile0);

% (ResultImageFormat "mhd")
set_ix(pfile0{1},'ResultImageFormat','nii');
set_ix(pfile0{2},'ResultImageFormat','nii');
set_ix(pfile0{3},'ResultImageFormat','nii');

%% use this pfile
pfile=pfile0(find([g.rigid g.affine g.bspline]==1));





%———————————————————————————————————————————————
%%
%———————————————————————————————————————————————


%% LOAD IMAGES
[ha a ]=rgetnii(ref);
[hb b] =rgetnii(sou);


%% DEFINE SIZE
% if strcmp(g.xyresolution,'source')==1
%     for i=1:length(pfile)
%         set_ix(pfile{i},'Size',hb.dim(1:2));
%     end
% end



%% SLICEASSIGN
if isnumeric(g.sliceAssign)
    %% INTERACTIVE
    if size(g.sliceAssign,2)==2
        snum=g.sliceAssign;
    else
        return
    end
else
    %% AUTO
    sspacea=[1:ha.dim(3)].*ha.mat(3,3)+ha.mat(3,4);
    sspaceb=[1:hb.dim(3)].*hb.mat(3,3)+hb.mat(3,4);
    snum=[];
    for i=1:length(sspaceb)
        snum(i,:)=[  vecnearest2(sspacea,sspaceb(i))   i  ]; %slices in A and B
    end
end


% g.reslicefirst=0;
% if g.reslicefirst==1
%     imgold=img;
%     img   =fullfile(mdir,'mov2d.nii');
%     rreslice2target(imgold, ref, img,1);   % # hb.dt
%
%     %replace header
%     [hb b]=rgetnii(img);
%     rsavenii(img, ha, b);
%
%     snum(:,2)=snum(:,1);              % same slice
% end



mdir=pa;

%% warp slicewise
% offset=[];
xd=[];
for i=1:size(snum,1)
    
    a2=a(:,:,snum(i,1));
    b2=b(:,:,snum(i,2));
    
    
    ha2=ha;
    ha2.dim=[ha.dim(1:2) 1];
    ha2.mat=[...
        ha.mat([1:2],:)
        ha.mat([3:4],:)];
    %ha2.mat(3,3)=1;
    ftarget=fullfile(mdir,'target2D.nii');
    rsavenii(ftarget,ha2,a2);
    
    hb2=hb;
    hb2.dim=[hb.dim(1:2) 1];
    hb2.mat=[...
        hb.mat([1:2],:)
        ha.mat([3:4],:)];
    %hb2.mat(3,3)=1;
    fsource=fullfile(mdir,'source2D.nii');
    rsavenii(fsource,hb2,b2);
    
    %% reslice 2D
    rreslice2target(fsource, ftarget, fsource, g.InterpOrder    ,hb.dt);   % # hb.dt
    
    % %     %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    if ~isempty(pfile)
        %———————————————————————————————————————————————
        %% RUN ELASTIX
        %———————————————————————————————————————————————
        try
            cprintf([.8 0 1], ['<busy>..run ELASTIX in [' strrep(mdir,[fileparts(mdir) filesep],'') ']'     [', Slice[' num2str(snum(i,2)) '] onto >> slice[' num2str(snum(i,1)) ']\n']]);
        end
        %     disp(['•PATH             : ' strrep(mdir,[fileparts(mdir) filesep],'')]);
        disp(['•TRAFOS             : ' strjoin(strrep(pfile,[mdir filesep],''),' • ')]);
        disp(['•Ref & Source files : ' ['[' strrep(ref,[(mdir) filesep],'') '] • [' strrep(sou,[(mdir) filesep],'') ']'] ]);
        disp(['•Applied files      : ' strjoin(strrep(app,[mdir filesep],''),' • ')]);
        
        
        %% MAKE DIR
        % pfiles={'Par0034rigid.txt' 'Par0034affine.txt' 'Par0034bspline.txt'}
        outdir=fullfile(mdir,'ELX2d',['i' pnum(i,3) '_slice' num2str(snum(i,1)) '-' num2str(snum(i,2)) ]);
        mkdir(outdir);
        
        fix = ftarget;
        mov = fsource;
        
        %% RUN ELASTIX
        %   [rmovs,tfile] = run_elastix(fix,mov,outdir,pfile, [],[],[],[],[]);
        [infox1,rmovs,tfile] =evalc('run_elastix(fix,mov,outdir,pfile, [],[],[],[],[])');
        %   [infox1,rmovs,tfile] =evalc('run_elastix(fix,movtpm,outdir,pfile, [],[],[],[],[])');
        
        wfiles=cellstr(rmovs);
        tfile=cellstr(tfile);
        
        %———————————————————————————————————————————————
        %%   RUN TRANSFORMIX
        %———————————————————————————————————————————————
        try
            cprintf([0 .5 1], ['<busy>..run TRANSFORMIX in [' strrep(mdir,[fileparts(mdir) filesep],'') ']' [' : slice[' num2str(snum(i,2)) '] onto >> slice[' num2str(snum(i,1)) ']\n']]);
        end
        set_ix(tfile{end},'FinalBSplineInterpolationOrder' ,g.InterpOrder);      % INTERPOLATION
    end
    
    
    
    %% FOR EACH VOLUME
    for j=1:size(app,1)
        
        
        
        
        [hc c]=rgetnii(app{j});
        c2=c(:,:,snum(i,2));
        
        
        
        hc2=hc;
        hc2.dim=[hc.dim(1:2) 1];
        hc2.mat=[...
            hb.mat([1:2],:)
            ha.mat([3:4],:)];
        %hb2.mat(3,3)=1;
        fapply=fullfile(mdir,'apply2D.nii');
        rsavenii(fapply,hc2,c2);
        
        %% reslice 2D
        rreslice2target(fapply, ftarget, fapply,g.InterpOrder,hc.dt);   % # hb.dt
        
        
        if ~isempty(pfile)
            [infox,wim,wps] = evalc('run_transformix(fapply,[],tfile{end},outdir,'''')');
        else
            wim = fapply;
        end
        
        
        %      if strcmp(g.xyresolution,'source')==1                                    % ORIG-RESOLUTION
        %         set_ix(tfile{end},'Size'     ,hb.dim(1:2));
        %         set_ix(tfile{end},'Spacing'  ,[hb.mat(1,1) hb.mat(2,2)]);
        %     end
        
        %———————————————————————————————————————————————
        %%   GET VOLUME
        %———————————————————————————————————————————————
        %[hd d]=rgetnii(wfiles{end});
        [hd d]=rgetnii(wim);
        
        %         if 1 %% APPLY
        %             [hv v]=rgetnii(fapply);
        %             v2=v(:,:,snum(i,2));
        %         end
        
        %% INTENSITY SCALE TO ORIGIN
        if g.preserveIntensity==1
            mima1=[min(c2(:)) max(c2(:)) ];
            mima2=[min(d(:))  max(d(:)) ];
            
            dx=d-min(d(:));
            dx=dx./max(dx(:));
            dx=dx.*(mima1(2)-mima1(1))+mima1(1);
            %d2(:,:,i)=dx;  %for each slice
            xd(:,:,i,j)=dx;
            
            %             [mean(c2(:))  std(c2(:)) min(c2(:)) max(c2(:))]
            %             [mean(dx(:))  std(dx(:)) min(dx(:)) max(dx(:))]
            
        elseif g.preserveIntensity==2
            disp('preserveINtensTYPE-2')
            ms1=[mean(c2(:))  ];
            ms2=[mean( d(:))  ];
            
            w1=c2-ms1(1);
            w2= d-ms2(1);
            w2=(w2.*std(w1(:))/std(w2(:))  ) ;
            w2=w2+ms1(1);
            xd(:,:,i,j)=w2;
            
            %             [mean(c2(:))  std(c2(:)) min(c2(:)) max(c2(:))]
            %             [mean(w2(:))  std(w2(:)) min(w2(:)) max(w2(:))]
            
        else
            %d2(:,:,i)=d;  %for each slice
            xd(:,:,i,j)=d;
        end
        
        
    end %EACH VOLUME
    
end




%———————————————————————————————————————————————
%%   stack image  newImage
%———————————————————————————————————————————————

zeromat = zeros(size(a));
for i=1:size(xd,4)           % for each VOLUME
    w  = zeromat;
    wm = w;                  % MASK
    for j=1:size(xd,3)       % for each SLICE
        w( :,:,snum(j,1))  = squeeze(xd(:,:,j,i));
        wm(:,:,snum(j,1))  = 1;
    end
    fin =fullfile(mdir, g.applyIMG{i});
    fout=fullfile(mdir, g.applyIMGnew{i});
    
    hfin=spm_vol(fin);
    rsavenii(fout,ha,w   , hfin.dt   );
    try
        disp(['2d-registered image: <a href="matlab: explorerpreselect(''' ...
            fout ''')">' fout '</a>']);
    end
    
    if g.createMask == 1
        foutmask=fullfile(mdir, strrep(g.applyIMGnew{i},'.nii','mask.nii'));
        rsavenii(foutmask,ha,wm   , [2 0]   );
    end
    
    
    
    
    
end



%———————————————————————————————————————————————
%%
%———————————————————————————————————————————————
%
%
% if hb.dim(3)~=size(d2,3)
%     d3=zeros([size(d2,1) size(d2,2) hb.dim(3)]);
%     for i=1:size(snum,1)
%         d3(:,:,snum(i,1))=d2(:,:,i);
%     end
% else
%     d3=d2;
% end
%
%
%
% if strcmp(g.xyresolution,'ref')
%     if strcmp(g.sliceAssign,'auto')
%         hx=hb;
%         hx.dim=[ha.dim([1 2]) hb.dim([3])];
%         hx.mat=[...
%             ha.mat([1:2],:)
%             hb.mat([3:4],:)];
%         %         rsavenii(imgnew,hx,d3);
%
%
%     else
%
%         sspacea=[1:ha.dim(3)].*ha.mat(3,3)+ha.mat(3,4);
%         sspaceb=[1:hb.dim(3)].*hb.mat(3,3)+hb.mat(3,4);
%
%
%         %rsl=g.sliceAssign(1,1)-1;
%         rsl=snum(1,1);
%         ce=sspacea(rsl);
%
%         hx=hb;
%         hx.dim=[ha.dim([1 2]) hb.dim([3])];
%         hx.mat=[...
%             ha.mat([1:2],:)
%             hb.mat([3:4],:)];
%         hx.mat(3,4)=ce
%         hx.mat(3,3)=ha.mat(3,3)
%         %         rsavenii(imgnew,hx,d3);
%     end
%
% else
%     hx=hb;
%     %     rsavenii(imgnew,hx,d3);
% end
%
%
% %———————————————————————————————————————————————
% %%   save new image
% %———————————————————————————————————————————————
% rsavenii(imgnew,hx,d3);
% if g.reslice2refIMG==1
%     rreslice2target(imgnew, ref,imgnew, g.InterpOrder,hx.dt);
% end
%
% % MASK
% if g.createMask==1
%     imgnewmask=strrep(imgnew,'.nii','_mask.nii');
%     rsavenii(imgnewmask,hx,ones(size(d3)));
%
%     if g.reslice2refIMG==1
%         rreslice2target(imgnewmask, ref,imgnewmask, 0,[2 0]);
%     end
%
% end
%
% try
%     disp(['2d-registered image: <a href="matlab: explorerpreselect(''' imgnew ''')">' imgnew '</a>']);
% end



%———————————————————————————————————————————————
%%   cleanUP
%———————————————————————————————————————————————
% try;delete(fix);end  % DELETE TARGET-2d-NIFTI

if g.cleanup==1
    
    try;delete(ftarget);end  % DELETE TARGET-2d-NIFTI
    try;delete(fsource);end  % DELETE SIURCE-2d-NIFTI
    try;delete(fapply);end  % DELETE APLLY-2d-NIFTI
    
    
    for i=1:length(pfile0)
        try;delete(pfile0{i});end
    end
    
    % DELETE NIFTIS in ELXfolder
    [files,dirs] = spm_select('FPListRec',fileparts(outdir),'.*.nii');
    if ischar(files); files=cellstr(files); end
    for i=1:length(files)
        try;delete(files{i});end
    end
    
    % DELETE IterationInfo in ELXfolder
    [files,dirs] = spm_select('FPListRec',fileparts(outdir),'IterationInfo.*.txt');
    if ischar(files); files=cellstr(files); end
    for i=1:length(files)
        try;delete(files{i});end
    end
end

%———————————————————————————————————————————————
%%   keepFolder
%———————————————————————————————————————————————
if g.keepFolder==0
    % DELETE TARGET-2d-NIFTI
    try; rmdir(fileparts(outdir),'s'); end
end



% disp(' .. done [for history see "anth" in workspace]');












return

% return
hr=spm_vol(ref);     hr=hr(1);
ha=spm_vol(img);

copyfile(img,imgnew,'f');
hb = spm_vol(imgnew);
for i = 1:size(hb,1)
    hc     = hb(i)       ; %get orig header
    hc.mat = hr.mat      ; % REPLACE -[mat]
    if g.keep_dt==0
        hc.dt   =hr.dt   ; % replace [dt]
    end
    spm_create_vol(hc);
end
try; delete( strrep(imgnew,'.nii','.mat')  ) ;     end


[~,imgs]=fileparts(img); imgs=[imgs ];
[~,refs]=fileparts(ref); refs=[refs ];


disp([...
    'NEW: <a href="matlab: explorerpreselect(''' imgnew ''')">' imgnew '</a>' ...
    ' OLD: <a href="matlab: explorerpreselect(''' img    ''')">' imgs    '</a>'...
    ' REF: <a href="matlab: explorerpreselect(''' ref    ''')">' refs    '</a>' ]);


% disp(['NEW: <a href="matlab: explorerpreselect(''' imgnew ''')">' imgnew '</a>' ]);
% disp(['OLD: <a href="matlab: explorerpreselect(''' img    ''')">' img    '</a>' ]);
% disp(['REF: <a href="matlab: explorerpreselect(''' img    ''')">' img    '</a>' ]);


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
function v=getuniquefiles(pa)
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
%REMOVE FILE if empty folder found
idel        =find(cell2mat(cellfun(@(a){[ isempty(a)]},fifull)));
fifull(idel)=[];
fi2(idel)   =[];


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

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function he=selectfile(v,selectiontype)
he=selector2(v.tb,v.tbh,...
    'out','col-1','selection',selectiontype);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%________________________________________________
%%  rename files
%________________________________________________
function he=renamefiles(li,lih)



%% get parameter from paramgui
hpara = findobj(0,'tag','paramgui');
us    = get(hpara,'userdata');
txt   = char(us.jCodePane.getText);
eval(txt);

filex    = x.applyIMG(:)   ;
tbrename = [unique(filex(:))  repmat({''}, [length(unique(filex(:))) 1])  ]; % old name & new name


%% make figure
f = fg; set(gcf,'menubar','none','units','normalized','position',[    0.3049    0.4933    0.6    0.3922]);
t = uitable('Parent', f,'units','norm', 'Position', [0 0.1 1 .8], 'Data', tbrename,'tag','table',...
    'ColumnWidth','auto');
t.ColumnName = {'distributed files                          ',...
    'new name        (without path and without extension)         ',...
    %                 'used volumes (inv,1,3:5),etc             ',...
    %                 '(c)copy or (e)expand                  ',...
    };

%columnsize-auto
set(t,'units','pixels');
pixpos=get(t,'position')  ;
set(t,'ColumnWidth',{pixpos(3)/2});
set(t,'units','norm');


t.ColumnEditable = [false true  ];
t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];

tx=uicontrol('style','text','units','norm','position',[0 .95 1 .05 ],...
    'string',      '..new filenames can be given here...',...
    'fontweight','bold','backgroundcolor','w');
pb=uicontrol('style','pushbutton','units','norm','position',[.05 0.02 .15 .05 ],'string','OK','fontweight','bold','backgroundcolor','w',...
    'callback',   'set(gcf,''userdata'',get(findobj(gcf,''tag'',''table''),''Data''));'          );%@renameFile


h={' #yg  ***COPY FILES or EXPAND 4D-files  ***'} ;
h{end+1,1}=['# 1st column represents the original-name '];
h{end+1,1}=['# 2nd column contains the new filename (without file-path and without file-extension !!)'];
h{end+1,1}=['  -if cells in the 2nd column are empty (no new filename declared), the original filename is used '];


%    uhelp(h,1);
%    set(gcf,'position',[ 0.55    0.7272    0.45   0.1661 ]);

setappdata(gcf,'phelp',h);

pb=uicontrol('style','pushbutton','units','norm','position',[.85 0.02 .15 .05 ],'string','Help','fontweight','bold','backgroundcolor','w',...
    'callback',   'uhelp(getappdata(gcf,''phelp''),1); set(gcf,''position'',[    0.2938    0.4094    0.6927    0.4933 ]);'          );%@renameFile
% set(gcf,''position'',[ 0.55    0.7272    0.45   0.1661 ]);
drawnow;
waitfor(f, 'userdata');
% disp('geht weiter');
tbrename=get(f,'userdata');
ikeep=find(cellfun('isempty' ,tbrename(:,2))) ;
ishange=find(~cellfun('isempty' ,tbrename(:,2))) ;

oldnames={};
for i=1:length(ikeep)
    [pas fis ext]=fileparts(tbrename{ikeep(i),1});
    tbrename(ikeep(i),2)={[fis ext]};
end
oldnames={};
for i=1:length(ishange)
    [pas  fis  ext]=fileparts(tbrename{ishange(i),1});
    [pas2 fis2 ext2]=fileparts(tbrename{ishange(i),2});
    tbrename(ishange(i),2)={[fis2 ext]};
end
he=tbrename;
%     disp(tbrename);
close(f);






function makebatch(z,p)

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

try
    hlp=help(mfilename);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end

% hh={};
% hh{end+1,1}=('%%% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
% hh{end+1,1}=[ '%%% #g BATCH:        [' [mfilename '.m' ] ']' ];
% hh{end+1,1}=[ '%%% descr: ' hlp];
% hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
% hh=[hh; 'z=[];' ];

hh={};
hh{end+1,1}=('% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
hh{end+1,1}=['% % #g FUNCTION:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=['% % #b info :            ' hlp];
hh{end+1,1}=('% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
hh=[hh; 'z=[];' ];
% uhelp(hh,1);


% ----------
% hh=[hh; struct2list(z)];
zz=struct2list(z);
ph={};
spa=[];
fnames=fieldnames(z);
infox={};
for i=1:length(fnames)
    ix=find(cellfun('isempty',regexpi(p(:,1),['^' fnames{i} '$']))==0);
    if ~isempty(ix) & length(ix)==1
        ph{i,1}=['     % % ' p{ix,3}];
    else
        ph{i,1}=['       '         ];
    end
    % = sep
    is=strfind(zz{i},'=');
    if ~isempty(is)
        spa(i,1)=is(1);
    else
        spa(i,1)=nan;
    end
end
spaceadd=nanmax(spa)-spa;
for i=1:length(fnames)
    if ~isnan(spaceadd(i))
        zz{i,1}= [ regexprep(zz{i} ,'=',[repmat(' ',1,1+spaceadd(i)) '= '],'once')  ];
    end
end
sizx=size(char(zz),2);
zz=cellfun(@(a,b) {[a repmat(' ' ,1,sizx-size(a,2)) b ]}, zz,ph);
hh=[hh; zz];
% ----------
hh(end+1,1)={[mfilename '(' '1',  ',z' ');' ]};
% disp(char(hh));
% uhelp(hh,1);

try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '}];
assignin('base','anth',v);









