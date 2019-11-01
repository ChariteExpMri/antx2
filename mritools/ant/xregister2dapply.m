
%% apply slicewise register (2D) to other images 
% #ww
% #yk xregister2dapply.m
%% #b %% apply slicewise register (2D) to other images 
%% #r xregister2d has to be done before (keepFolder-parameter must be set to 1 to preserve transformation-paramteres )
% see xregister2d 
%
% ______________________________________________________________________________________________
%
%% #ky PARAMETER:
%
% x.refIMG  	- SELECT REFERENCE IMAGE (example: t2.nii)
% x.sourceIMG   - SELECT SOURCE IMAGE (the image  that was originally the sourceIMG in "xregister2d" )
% x.applyIMG    - SELECT IMAGE(S) to apply the 2D-registration
% __________________________________________
% x.InterpOrder       -  'InterpolationOrder: [0]nearest neighbor, [1]trilinear interpolation, [3]cubic' {0 1 3}(default: 0)
% x.preserveIntensity - keep original image intensity:
% x.createMask'        - create binary MaskImage    <boolean> [1] yes, [0] no    (default: 1)
%                      - mask name: filename: "newfilename+_mask"]'  'b'
%                      - rule: registered slices with "1"s, spacing dummy slices with "0"-elements
%                      - NOTE: maskImage can be later used to assist the atlas-based read out of
%                        values in native or allen space. For Allen space readout, the registered
%                        sourceIMG and corresponding mask has to be brought into Allen space
% __________________________________________
% x.cleanup           - remove unnecessary data afterwards, <boolean> [1] yes, [0] no (default: 1)
%
% ______________________________________________________________________________________________
%% #ky RUN-def:
% xregister2dapply(showgui,x)
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
%% Here, 'c_map_Kopie.nii' and 'phi_map.nii' are slice-wise 2d-registered using the transformation
%% parameters previously estimated via "xregister2.m". 
%% Note that z.refIMG and z.sourceIMG must be set similar as for "xregister2.m"
%
% z=[];                                                                                                                                                                                                        
% z.refIMG            = { 't2.nii' };            % % (<<) SELECT REFERENCE IMAGE (example: t2.nii)                                                                                                             
% z.sourceIMG         = { 'avmag.nii' };         % % (<<) SELECT SOURCE IMAGE (the image  that was originally the sourceIMG in "xregister2d" )                                                                                                       
% z.applyIMG          = { 'c_map_Kopie.nii'      % % (<<) SELECT 1/more IMAGES to apply transformation                                                                     
%                         'phi_map.nii' };                                                                                                                                                                     
% z.prefix            = 'p';                     % % this prefix is used for the output file(s) >>[prefix+ applyIMG ]                                                                                     
% z.InterpOrder       = [0];                     % % InterpolationOrder: [0]nearest neighbor, [1]trilinear interpolation, [3]cubic                                                                             
% z.preserveIntensity = [0];                     % % preserve intensity: [0] no, [1] preserve min-max-range [2] preserve mean+SD                                                                               
% z.createMask        = [1];                     % % create binary MaskImage  [ used slices contain "1"-elements; filename: "newfilename+_mask"]                                                               
% z.cleanup           = [1];                     % % remove unnecessary data                                                                                                                                   
% xregister2dapply(1,z);  
%
%% #r RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
%
%

function xregister2dapply(showgui,x)


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
    'inf0'      '*** Apply slicewise 2D-TRANSFORM  to other Images  ****     '         '' ''
    'inf1'      ['routine: [' mfilename '.m]']                         '' ''
    'inf7'     '====================================================================================================='        '' ''
    'refIMG'        {''}      '(<<) SELECT REFERENCE IMAGE (example: t2.nii)'  {@selectfile,v,'single'}
    'sourceIMG'     {''}      '(<<) SELECT IMAGE that was originally the sourceIMG in "xregister2s"      '  {@selectfile,v,'single'}
    'applyIMG'      {''}      '(<<) SELECT 1/more IMAGES to apply transformation               '  {@selectfile,v,'multi'}
    'inf77'     '====================================================================================================='        '' ''
    %     'renameIMG'     ''       '(optional) rename-string for the new file, otherwise the prefix "p"+sourceIMG-name is used'  {@renamefiles,[],[]}
    
    'prefix'     'p'       'prefix used for the output file(s) >>[prefix+ names of applyIMG(s)]'   {@renamefiles,[],[]}

    'InterpOrder'         0    'InterpolationOrder: [0]nearest neighbor, [1]trilinear interpolation, [3]cubic' {0 1 3}
    'preserveIntensity'   0    'preserve intensity: [0] no, [1] preserve min-max-range [2] preserve mean+SD' {0 1 2}
    'createMask'          1    'create binary MaskImage  [ used slices contain "1"-elements; filename: "newfilename+_mask"]'  'b'
    'cleanup'             1        'remove unnecessary data' 'b'
    
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .5 .35 ],...
        'title',['Parameters: ' mfilename '.m'],'info',{@uhelp, 'xregister2dapply.m'});
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
g.refIMG    =cellstr(g.refIMG);
g.sourceIMG =cellstr(g.sourceIMG);
g.applyIMG =cellstr(g.applyIMG);


%% prepare APPLYIMGS: sourceImage is added
g.applyIMG=unique([  g.applyIMG(:) ]);
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
disp('*** apply register2D to other images ***');
for i=1:size(pa,1)
    transformx(pa{i},g );
end



% makebatch(z,p);


btic=toc(atic);
disp(['.DONE!  FUNCTION: [' [mfilename '.m' ] ']; BATCH: see["anth"] in workspace']);
disp([sprintf('   elapsed time: %2.2f min', btic/60)]);



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% subs
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% function  transformx(ref,img,imgnew, g   );
function  transformx(pa,g   );




 

%———————————————————————————————————————————————
%%   inputParams
%———————————————————————————————————————————————

pas     = pa                            ; %'o:\data3\2d_Apply_otherImages\dat\test'
target  = fullfile(pas, g.refIMG{1})    ; %fullfile(pas,'t2.nii')
source  = fullfile(pas, g.sourceIMG{1}) ; %fullfile(pas,'avmag.nii')
appfi    = g.applyIMG      ;              %appfi={'c_map_Kopie.nii','phi_map.nii'}


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






