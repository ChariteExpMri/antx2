
%% register exvivo 2tw-image to invivo-2tw-image
% #yk xregisterexvivo.m
%% #b Scenario: exvivo t2w-image should be registered to invivo t2w-image
%% #r BEST PERFORMANCE IS DONE using the following steps:
%   [1] register the invivo t2w-image to Allen Space
%   [2] the Allen template in native space (ix_AVGT.nii) should exist after step [1], otherwise use 
%       "deform Volumes ELastix" to transform 'AVGT.nii' into native Space
%   [3] select mouse/mice from from left ANT-panel if you want to run "xregisterexvivo" for these cases     
%   [4] run xregisterexvivo: 
%       in the [xregisterexvivo] window use the following parameters:
%       refIMG     : {'ix_AVGT.nii'}   - select  "ix_AVGT.nii" as reference (no skin/bone/csf..thus this image should have the best match) 
%       sourceIMG  : {'t2_exvivo.nii'} - select  the exvivo t2w-image
%       applyIMG   : {'19F_T2_SNR_map_exvivo.nii'}  - <optional> select 1/more images (alined to the exvivo t2w-image)
%                                                      these images will be registed by applying the transformation parameters
%       prefix     : 'e'    - name prefix  of the output image(s)                       
%       tube       :  1     - if exvivo mouse brain is kept in a tube, use [1] to deal with the background/tube signal  
%       InterpOrder: -1     - [-1] autodetect the interpolation order from the original image signal values
%   
% % check also the results if tune is set to [0] 
% ______________________________________________________________________________________________
%
%% #ky PARAMETER:
%
% refIMG  	 - SELECT INVIVO REFERENCE IMAGE (example: or "ix_AVGT.nii" or "t2.nii" )
% sourceIMG  - SELECT EXVIVO SOURCE IMAGE (example "t2_exvivo.nii" )
% applyIMG   - SELECT other IMAGE(S) aligned to the exvivo sourceIMG to be registered to the refIMG
% % __________________________________________
% InterpOrder  -InterpolationOrder: [-1] auto detect Interp order, [0]nearest neighbor, [1]trilinear interpolation, [3]cubic' {0 1 3}(default: 0)
% prefix       - prefix of the output file(s) , (default 'e')
% tube         - if exvivo mouse brain is kept in a tube, use [1] to deal with the background/tube signal
%                if tube is [1]: the sourceIMG is copied with the suffix '*_notube.nii' and the registration
%                is performed on the image with the name [sourceIMG + "-notube.nii"] 
%                thus the registerd image name is [ prefix + sourceIMG + _"-notube.nii"]  
% ______________________________________________________________________________________________
%% #ky RUN-def:
% xregisterexvivo(showgui,x)
% with inputs:
% showgui: (optional)  :  0/1   :no gui/open gui
% x      : (optional)  : struct with one/more specified parameters from above:
%
% xregisterexvivo(1) or  FUNCTION    ... open PARAMETER_GUI with defaults
% xregisterexvivo(0,z)                ...run without GUI with specified parametes (z-struct)
% xregisterexvivo(1,z)                ...run with opening GUI with specified parametes (z-struct)
%
% ______________________________________________________________________________________________
%% #ky BATCH EXAMPLE-1
%% register exvivo image ('t2_exvivo.nii') to the reference Image. Here the reference image is 'ix_AVGT.nii'.
%% NOTE than the invivo t2w-image was previously registered to the AllenSpace and  'ix_AVGT.nii' is the Allen Template
%% backtransformed to the space of the invivo t2w-image. The Transformation is than also applied to '19F_T2_SNR_map_exvivo.nii'
%% note that the mouse brain in the exvivo image ('t2_exvivo.nii') was positioned in a tube: Here we want to reduce the chance
%% that the registration fails do to background/tube signal transitions
%% The interpolation order is set to auto detect the interpolation
%% NOTE: because tube was set to [1] the corresponding names of the registered sourceIMG is 
%%   -"e_t2_exvivo_notube.nii" (output name of the applyIMG is "e19F_T2_SNR_map_exvivo.nii" ; prefix "e")
% z=[];                                                                                                                                                                 
% z.refIMG      = { 'ix_AVGT.nii' };                   % % select invivo reference image (example: ix_AVGT.nii)                                                         
% z.sourceIMG   = { 't2_exvivo.nii' };                 % % select exvivo source image (example: t2_exvivo.nii)                                                          
% z.applyIMG    = { '19F_T2_SNR_map_exvivo.nii' };     % % select 1/more IMAGES to apply transformation                                                                 
% z.prefix      = 'e';                                 % % prefix used for the output file(s) >>[prefix+ names of applyIMG(s)]                                          
% z.tube        = [1];                                 % % if exvivo mouse is positioned in a  tube, [1] deal with the background/tube transition, [0] do nothing       
% z.InterpOrder = [-1];                                % % InterpolationOrder:  [-1] autodetect, [0]nearest neighbor, [1]trilinear interpolation, [3]cubic              
% xregisterexvivo(1,z); 
% ______________________________________________________________________________________________
%% #ky BATCH EXAMPLE-2
%% once the transformation has been calculated other images can be registered later
% z=[];                                                                                                                                                                 
% z.applyIMG    = { '19F_T2_SNR_map_exvivo.nii' };     % % select 1/more IMAGES to apply transformation                                                                 
% z.prefix      = 'e';                                 % % prefix used for the output file(s) >>[prefix+ names of applyIMG(s)]                                          
% z.InterpOrder = [-1];                                % % InterpolationOrder:  [-1] autodetect, [0]nearest neighbor, [1]trilinear interpolation, [3]cubic              
% xregisterexvivo(1,z);   
%
% ______________________________________________________________________________________________
%% #r RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
%
%

function exvivo2invivo(showgui,x)


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

%% get unique-files from all data
% pa=antcb('getsubjects'); %path
v=getuniquefiles(pa);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end
p={...
    'inf0'      '*** exvivo to invivo registration  ****     '         '' ''
    'inf1'      ['routine: [' mfilename '.m]']                         '' ''
    'inf7'     '====================================================================================================='        '' ''
    'refIMG'        {''}      'select invivo reference image (example: ix_AVGT.nii)'       {@selectfile,v,'single'}
    'sourceIMG'     {''}      'select exvivo source image (example: t2_exvivo.nii)'   {@selectfile,v,'single'}
    'applyIMG'      {''}      'select 1/more IMAGES to apply transformation'      {@selectfile,v,'multi'}
    'inf77'     '====================================================================================================='        '' ''
    
    'prefix'            'e'        'prefix used for the output file(s) >>[prefix+ names of applyIMG(s)]'   {@renamefiles,[],[]}
    'tube'                1        'if exvivo mouse is positioned in a  tube, [1] deal with the background/tube transition, [0] do nothing'  {0,1}
    'InterpOrder'         0        'InterpolationOrder:  [-1] autodetect, [0]nearest neighbor, [1]trilinear interpolation, [3]cubic' {0 1 3 -1}
    
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .5 .35 ],...
        'title',['Parameters: ' mfilename '.m'],'info',{@uhelp, [mfilename '.m']});
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%———————————————————————————————————————————————
%%   make batch
%———————————————————————————————————————————————
xmakebatch(z,p, [mfilename ]);

%———————————————————————————————————————————————
%%   PROCESS
%———————————————————————————————————————————————
atic=tic;  %timer


g=z;
%% chekcs
g.refIMG     = cellstr(g.refIMG);
g.sourceIMG  = cellstr(g.sourceIMG);
g.applyIMG   = cellstr(g.applyIMG);


%% prepare APPLYIMGS: sourceImage is added
g.applyIMG=unique([  g.applyIMG(:) ]);
g.applyIMG(find(cellfun(@isempty,g.applyIMG)))=[];

%% PREFIX if more than 1 applyIMG
% if size(g.applyIMG,1)==1 && ~isempty(g.renameIMG)
%     g.applyIMGnew= [strrep(g.renameIMG,'.nii','') '.nii'];
% else
%     g.applyIMGnew= stradd(g.applyIMG,'p',1);
% end

if isempty(g.prefix);     g.prefix='e';  end




%% running trough MOUSEfolders
disp('*** register exvivo to invivo ***');
for i=1:size(pa,1)
    transformx(pa{i},g );
end


%% END
btic=toc(atic);
disp(['.DONE!  FUNCTION: [' [mfilename '.m' ] ']; BATCH: see["anth"] in workspace']);
disp([sprintf('   elapsed time: %2.2f min', btic/60)]);



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% subs
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function  transformx(pa,g   );


% isref     =~((iscell(g.refIMG) && isempty(g.refIMG{1})) || isempty(g.refIMG)) ;
% issource  =~((iscell(g.sourceIMG) && isempty(g.sourceIMG{1})) || isempty(g.sourceIMG));
% isapp  = ~((iscell(g.applyIMG) && isempty(g.applyIMG{1})) || isempty(g.applyIMG));


isref    =~isempty(char(g.refIMG));
issource =~isempty(char(g.sourceIMG));
isapp    =~isempty(char(g.applyIMG));


if isref ==1 && issource==1
     if exist(fullfile(pa,g.refIMG{1}))     ~=2;          disp(['refIMG does not exist in [' pa ']']);  return;     end
     if exist(fullfile(pa,g.sourceIMG{1}))  ~=2;       disp(['sourceIMG does not exist in [' pa ']']);  return;     end
         
         
    g=f_tube(pa,g);
    f_register(pa,g);
end

if isapp ==1
    f_applytrafo(pa,g);
end





%———————————————————————————————————————————————
%%   apply transformation
%———————————————————————————————————————————————

function f_applytrafo(pa,g);

%% elastix workingDir and trafofile
elxout=fullfile(pa,'elx_exvivo');
if exist(elxout)~=7; 
    disp(['[elastix folder ["elx_exvivo"] in [' pa '] does not exist]..register images first']);
    return; 
end

% k=dir(fullfile(elxout,'TransformParameters.*.txt'))
[files,~] = spm_select('FPList',elxout,'^TransformParameters.*.txt');
tfile=cellstr(files);
if isempty(tfile)
    disp(['[TransformParameters in elastix folder do not exist in [' pa ']]..register images first']); 
end

%% set trafoParameter
%set changed path in tfile
for k=1:length(tfile)
    ininame= get_ix(tfile{k},'InitialTransformParametersFileName');
    
%     rm_ix( tfile{k},'FixedInternalImagePixelType');
%     rm_ix( tfile{k},'MovingInternalImagePixelType');
    
    if strcmp(deblank(ininame),'NoInitialTransform')~=1
        [tpas tfi tex]=fileparts(ininame);
        ininameNew=fullfile(elxout,[tfi tex]);
        set_ix(tfile{k},'InitialTransformParametersFileName', ininameNew);
    end
end
   

%———————————————————————————————————————————————
%%   %% loop ofer images
%———————————————————————————————————————————————
for i=1:size(g.applyIMG,1)
    
    fapply=fullfile(pa,g.applyIMG{i});                                       %FILE TO TRANSFORM
    if exist(fapply)~=2
        disp([ ' ..not existing file ['  fapply ']']);
       continue 
    end
    
    %% INTERPORDE
    if g.InterpOrder==-1
        [ha a]=rgetnii(fapply);
        v=a(:);
        if length(find((round(v*10)/10==v)==1))==numel(v); %mask
            set_ix(tfile{end},'FinalBSplineInterpolationOrder',0);
        else
            set_ix(tfile{end},'FinalBSplineInterpolationOrder',3);
        end
    else
        set_ix(tfile{end},'FinalBSplineInterpolationOrder' ,g.InterpOrder);
    end
    
    % transform
    [infox,wim,wps] = evalc('run_transformix(fapply,[],tfile{end},elxout,'''')');
    %MOVE
    fiout = fullfile(pa,[ g.prefix '_' g.applyIMG{i}]);
    movefile(wim, fiout,'f');
    
    disp(['registered-IMG: ' ['[' g.prefix '_' g.applyIMG{i} ']'] ' <a href="matlab: explorerpreselect(''' fiout ''')">' pa '</a>']);
end









%———————————————————————————————————————————————
%%   get rid off tube
%———————————————————————————————————————————————
function g=f_tube(pa,g)
    if isfield(g,'tube')
        
        if g.tube==1
            exfi=fullfile(pa,g.sourceIMG{1});
            [ha a]=rgetnii(exfi);
            
            w=[];
            for i=1:size(a,3)
                a2=a(:,:,i);
                b=edge(a2,'canny');
                b2=imfill(b,'holes');
                b3=imerode(b2,ones(3));
                
                b4=a2.*double(b3);
                [be,sep] = otsu(b4,3);
                
                b5=double(be==3);
                ra=a2(b5(:)==1);
                si=size(b4);
                ra2=repmat(ra,  [ceil(prod(si)./[length(ra)]) 1]);
                
                b6=reshape(ra2(randperm(prod(si))),[si]);
                
                b7=imcomplement(b3).*b6+b3.*a2;
                
                %fg,imagesc(b7)
                w(:,:,i)=b7;
            end
            
            g.sourceIMG{1}  =stradd(g.sourceIMG{1},'_notube',2);
            exfiout=fullfile(pa,g.sourceIMG{1});
            rsavenii(exfiout,ha,w);
        end
    end
%———————————————————————————————————————————————
%%   register 
%———————————————————————————————————————————————
function f_register(pa,g)
 
 
 %% COPY PARAMETERFILES
% felastix2d='C:\Users\skoch\Desktop\parafiles2D'
felastix=fullfile(fileparts(fileparts(which('ant.m'))),['elastix' ],'paramfiles');
pfile00={...
    fullfile(felastix,'Par0033rigid.txt'   )
%     fullfile(felastix2d,'Par0034affine_2D.txt'  )
%     fullfile(felastix2d,'Par0034bspline_2D.txt' )
    };
pfile0=strrep(pfile00,felastix,pa);
pfile0=stradd(pfile0,'_exvivo' , 2);
copyfilem(pfile00,pfile0);


for i=1:size(pfile0)
    rm_ix( pfile0{i},'FixedInternalImagePixelType');
    rm_ix( pfile0{i},'MovingInternalImagePixelType');
end

%% elastix path paths
elxout=fullfile(pa,'elx_exvivo');
warning off;
mkdir(elxout);


%———————————————————————————————————————————————
%%   elastix
%———————————————————————————————————————————————
fix   = fullfile(pa,'ix_AVGT.nii');   %
mov   = fullfile(pa,g.sourceIMG{1});  %   fullfile(pa,'notube.nii');
out   = elxout;
pfiles=pfile0;% p1([1  5 ])

set_ix(pfiles{1},'MaximumNumberOfIterations', 2000);
% set_ix(p{1},'MaximumNumberOfIterations', 2000);
pause(.1);
% [img,tfile] = run_elastix(fix,mov,out,pfiles,[],[],[],[],[]);
[arg,img,tfile] = evalc('run_elastix(fix,mov,out,pfiles,[],[],[],[],[])');

fiout = fullfile(pa,[ g.prefix '_' g.sourceIMG{1}]);
movefile(img, fiout,'f');

disp(['registered-IMG: ' ['[' g.prefix '_' g.sourceIMG{1} ']'] ' <a href="matlab: explorerpreselect(''' fiout ''')">' pa '</a>']);


%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————



function muell

%———————————————————————————————————————————————
%%   inputParams
%———————————————————————————————————————————————

pas     = pa                            ; %'o:\data3\2d_Apply_otherImages\dat\test'
target  = fullfile(pas, g.refIMG{1})    ; %fullfile(pas,'t2.nii')
source  = fullfile(pas, g.sourceIMG{1}) ; %fullfile(pas,'avmag.nii')
appfi   = g.applyIMG      ;              %appfi={'c_map_Kopie.nii','phi_map.nii'}


% pas='o:\data3\2d_Apply_otherImages\dat\test'
% target=fullfile(pas,'t2.nii')
% source=fullfile(pas,'avmag.nii')
% appfi={'c_map_Kopie.nii','phi_map.nii'}
% g.InterpOrder      = 1;
% g.preserveIntensity= 0;
% g.prefix           = 'p';
% g.createMask       = 0;
% g.cleanup          =1;





%%  INTERNAL PARAMS ==========================
%elastix dir and subdir
elxpa=fullfile(pas,'ELX2d');
[~,elxdirs] = spm_select('List',elxpa,'.*');
elxdirs=cellstr(elxdirs);
elxdirs=elxdirs(regexpi2(elxdirs,'^i\d*_d*'));

%slice-assignment
snum=str2num(char(regexprep(elxdirs,{'i\d+_slice' '-'},{'' ' '})));
%==========================

% check existence of files
appfi=appfi(:);
app=stradd(appfi,[pas filesep],1);

%% check existence
if exist(target)~=2; return; end
if exist(source)~=2; return; end
app=app(find(existn(app)==2));

% if isempty(app); continue; end


g.applyIMG =cellstr(strrep(app,[pas filesep ],''));
g.applyIMGnew= stradd(g.applyIMG,g.prefix,1);

mdir=pas;
%———————————————————————————————————————————————
%%
%———————————————————————————————————————————————



[ha a]=rgetnii(target);
[hb b]=rgetnii(source);



%% for each slice and for each file
xd=[];
fprintf('..[slice]: ');
for i=1:size(snum,1)% slice
    fprintf([ ' ' num2str(i)]);

    a2=a(:,:,snum(i,1));
    b2=b(:,:,snum(i,1));
    
    ha2=ha;
    ha2.dim=[ha.dim(1:2) 1];
    ha2.mat=[...
        ha.mat([1:2],:)
        ha.mat([3:4],:)];
    %ha2.mat(3,3)=1;
    ftarget=fullfile(mdir,'target2D.nii');
    rsavenii(ftarget,ha2,a2);
    
    
    %      hb2=hb;
    %      hb2.dim=[hb.dim(1:2) 1];
    %      hb2.mat=[...
    %          hb.mat([1:2],:)
    %          ha.mat([3:4],:)];
    %      %hb2.mat(3,3)=1;
    %      fsource=fullfile(mdir,'source2D.nii');
    %      rsavenii(fsource,hb2,b2);
    
    outdir=fullfile(mdir,'ELX2d',['i' pnum(i,3) '_slice' num2str(snum(i,1)) '-' num2str(snum(i,2)) ]);
    [u,~] = spm_select('FPList',outdir,'^TransformParameters.*.txt');
    tfile=cellstr(u);
    set_ix(tfile{end},'FinalBSplineInterpolationOrder' ,g.InterpOrder);
    
    %set changed path in tfile
    for k=1:length(tfile)
        ininame= get_ix(tfile{k},'InitialTransformParametersFileName');
        if strcmp(deblank(ininame),'NoInitialTransform')~=1
            [tpas tfi tex]=fileparts(ininame);
            ininameNew=fullfile(outdir,[tfi tex]);
            set_ix(tfile{k},'InitialTransformParametersFileName', ininameNew);
        end
        
    end
    
    for j=1:size(app,1) %file
        %load file
        
        [hc c]=rgetnii(app{j});
        c2=c(:,:,snum(i,2));
        
        %save2dNIFT
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
        
        %         if ~isempty(pfile)
        [infox,wim,wps] = evalc('run_transformix(fapply,[],tfile{end},outdir,'''')');
        %         else
        %             wim = fapply;
        %         end
        
        [hd d]=rgetnii(wim);
        
        
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
        
    end% each volume
end %each slice
fprintf('..[done]\n ');

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
%%   cleanUP
%———————————————————————————————————————————————
% try;delete(fix);end  % DELETE TARGET-2d-NIFTI

if g.cleanup==1
    
    try;delete(ftarget);end  % DELETE TARGET-2d-NIFTI
    try;delete(fsource);end  % DELETE SIURCE-2d-NIFTI
    try;delete(fapply);end  % DELETE APLLY-2d-NIFTI
    
    
    
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


