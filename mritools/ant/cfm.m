

% cfm: case-file-matrix: visualize data (files x dirs), basic file-manipulation
% #lk ___GUI-CONTROLS___
% [?]          -button: get HELP
% [S]          -button: get shortcut-list
% [update]     -button: updates the display, if files in input-folders were removed/addded/changed
% [rd_axEqual] -radio: set axes ti image/square
% [METRIC]     -pulldown: displaying metric, displays files by date/extension/size 
% [reduce]     -radio: show all files with subdirs (full), or only directly located files (reduced)
% [FORMAT]     -pulldown: displays files selected by file-extension
% [INFO]       -pulldown: show file-information when hovering over file
% 
% [multisel]    -radio: single-/multiselect files
% [hide slider] -radio: show/hide slider 
% 
% [visAllFiles] -radio: show all files in the figure or a fraction defined by the slider
% [visAllDirs]  -radio: show all dirs in the figure or a fraction defined by the slider
% 
% #lk ___FILE-MANIPULATION___
% - via context-Menu
% - no file-preselection needed for options with this symbol: #m ***
% 
% 
%  #b [open DIRECTORY]            : #k open dirs of all selected folders 
%  #b [view/open selected files ] : #k viw or open selected files (format: jpg/tif/gi/nii/doc/pdf/xls/txt/csv/log; ".mat" not supported 
%  #b [get file information]      : #k obtain basic file information of selected files
% ________________________________ 
% #r [pre-select slices in BART]  : BART-ONLY... #k pre-select animal-dirs in BART-GUI  
% #r [pre-select animals in ANT]  : ANT-ONLY ... #k pre-select animal-dirs in ANT-GUI 
% _____________________________________
% #b [select column |]                 : #k de/select all files of a select column (dirs/animal), via current mouse-position #m ***
% #b [select row - ]                   : #k de/select all (dirs/animal) of a specific file (row), via current mouse-position #m ***
% #b [select range []]                 : #k de/select files/dirs via rectangle-UI-function #m ***
% #b [select DIRS and FILES from list] : #k select DIRS and FILES from list  #m ***
% % ____________________________
% #b [copy and rename files]  : #k copy and rename selected files (New-name/prefix/suffix) 
% #b [rename files]           : #k rename selected files 
% ____________________________
% #b [import Dir2DIR]         : #k import files from outside, dir-name must match, seleciton of input-dirs via GUI #m ***
% #b [export entire folder]   : #k export selected folders (select a file of the folder to export the folder)
% #b [export seleted files]   : #k export selected files 
% ____________________________
% #b [delete files]           : #k delete selected files 
% 
% 
% #lk ___FUNCTION___
% cfm(umode,maindir,dirmode)
% umode: %[1|2]
%     [1]show content of BART-project
%     [2]show content of any-dir or ANT-project
% maindir: if umode is [2] only...
%   either a) main-path (with subfolders) to visualize
%       or b) 'ant'-tag to use a currently loaded ANT-project
% dirmode: -only if umode is [2] and maindir is 'ant'...
%     'all' : show files and folders of all animals of a loaded ANT-project
%     'sel' : show files and folders of selected animals of a loaded ANT-project
%   
% 
% #lk ___EXAMPLES___
% cfm(1): open CFM for current loaded BART-project
% cfm(2,'F:\data4\ernst_10aug21_2\dat'); open CFM for this dat-folder
% cfm(2,'ant');       % open CFM of current ANT-project, show all animal-folders
% cfm(2,'ant','all'); % same as cfm(2,'ant');
% cfm(2,'ant','sel'); % open CFM of current ANT-project, show selected animal-folders only
% ---BART examples-----------
% cfm(1); % Bart-project is loaded: open CFM using all animals (folders)
% cfm(1,[],'all'); %same
% cfm(1,[],'sel');% Bart-project is loaded: open CFM using SELECTED animals (folders)
% #ba modified:  06 Dec 2021 (17:28:20)
% 
% .




function cfm(umode,maindir,dirmode)

%% =============[input]==================================
u.dirmode='';
u.useANT =0;
%% =============[parameter]==================================
% u.foldertype=2;  %[1]BART, [2] any-dir
% u.pathmain='F:\data4\ernst_10aug21_2\dat';
u.params='----------';
u.fs_label = 5;
u.metric= 1;
u.isreduceTable=1;
u.allcasesSelected=1;


if exist('umode')~=1
    return
else
    if isnumeric(umode) &&  ~isempty(find(ismember([1 2],umode)))
       u.foldertype=umode;
    else
        return
    end
end
%% =============[ BART ]==================================

if umode==1
    
    if exist('dirmode')==1
        if strcmp(dirmode,'all')
            u.allcasesSelected=1;
        elseif strcmp(dirmode,'sel')
            u.allcasesSelected=0;
        else
            u.allcasesSelected=1;
        end
            
    end
  
    
    
%% ===============================================

elseif umode==2
    if exist('maindir')~=1  
        return
    else
        if strcmp(maindir,'ant')
            global an
            if ~isempty(an) && isfield(an,'datpath')
            u.useANT  =1;
            u.pathmain='';
            if exist('dirmode')
               u.dirmode=dirmode;
            end
            else
                disp('no ANT-project loaded');
                return
            end
        elseif isdir(maindir)   
            u.pathmain=maindir;
        else
            return
        end
    end
end



% %% =============[parameter]==================================
% % u.foldertype=2;  %[1]BART, [2] any-dir
% % u.pathmain='F:\data4\ernst_10aug21_2\dat';
% u.params='----------';
% u.fs_label = 5;
% u.metric= 1;
% u.isreduceTable=1;
% u.allcasesSelected=1;




%% ===============================================

u=getfileNfolders(u);
if isfield(u,'v2')==1
    makefig(u,1); %new fig
end


% ==============================================
%%   update
% ===============================================

function rd_reduce(e,e2)
reduce=get(findobj(gcf,'tag','rd_reduce'),'value');
u=get(gcf,'userdata');
u.isreduceTable=reduce;
set(gcf,'userdata',u);

set(findobj(gcf,'tag','pop_metric'),'value',1);
pb_update([],[]);

function pop_format(e,e2)
hf=findobj(gcf,'tag','pop_format');
if hf.Value==1
    set(hf,'backgroundcolor','y');
else
    set(hf,'backgroundcolor',[0.9686    0.6784    0.6784]);
end
pb_update([],[]);

function pb_update(e,e2)
hp=findobj(gcf,'tag','pb_update');
str=get(hp,'string');          col=get(hp,'backgroundcolor');
set(hp,'string','..wait..');   set(hp,'backgroundcolor',[1 0 0]);
drawnow;
u=get(gcf,'userdata');
u=getfileNfolders(u);
makefig(u,0);%update
% pause(.1);
set(hp,'string',str);          set(hp,'backgroundcolor',col);


% ==============================================
%%  getfileNfolders
% ===============================================
function u=getfileNfolders(u)

if u.foldertype==1
    % fidi=bartcb('getsel');
    u=prep_bart(u);
elseif u.foldertype==2
    u=prep_dir(u);
end

% ==============================================
%%  prep other directory
% ===============================================
function u=prep_dir(u)

%% ===============================================
if u.useANT==1
    if strcmp(u.dirmode,'all') || isempty(u.dirmode)
        dirs= antcb('getallsubjects');
    else
        dirs=antcb('getsubjects');
    end
    pathmain=fileparts(dirs{1});
else
    pathmain=u.pathmain;%'F:\data4\ernst_10aug21_2\dat'
    [dirs] = spm_select('FPList',pathmain,'dir','.*');
    if isempty(dirs); return ;end
    dirs=cellstr(dirs);
end

[pas mdir ext]=fileparts2(dirs);

mdirFP=stradd(mdir,[ pathmain filesep],1);

% ===============================================
t2={};
for i=1:length(mdir)
    animal=mdir{i};
    pas=fullfile(pathmain, animal);
    if u.isreduceTable==1
        dirx={pas};
    else
        [~,dirx] = spm_select('FPListRec',pas,'.*');
        dirx=[pas; cellstr(dirx)];
    end
    
    
    t={};
    for jj=1:length(dirx)
        
        k=dir(dirx{jj});
        k([k(:).isdir])=[];
        if ~isempty(k)
            t=[t;
                [{k(:).name}' ...
                repmat(dirx(jj),[length(k) 1]) ...
                num2cell([k(:).bytes]'./1e6) ...
                {k(:).date}' ];
                ];
        end
    end
    if ~isempty(t)
        %length(k)
        s=regexprep(t(:,2),regexprep(pas,filesep,[filesep filesep filesep]),'');
        sub=regexprep(s,[ '^' filesep ],'');
        merge=cellfun(@(a,b){[a filesep b]},sub,t(:,1));
        idirect=cellfun(@isempty,sub);
        merge(idirect,1)  =regexprep(merge(idirect,1),[filesep],'');
        t=[t ...
            repmat({animal}    ,[ length(sub)  1]) ...
            repmat({'assigned'},[ length(sub)  1]) ...
            sub merge];
        t(:,2)=repmat({mdirFP{i}},[size(t,1)  1 ]);
        t2=[t2; t];
    end
end
ht2={'filename' 'path' 'size' 'date' 'animal' 'assigned' 'sub' 'merge'};

subs=unique(t2(:,regexpi2(ht2,'sub')));
% uhelp(plog([],[ht2;t2],0, '#lk INFO','s=4;al=1;'),1);
% unique(t2(:,5))

%% ======= FILES ========================================
[dv,ia ]=unique(t2(:,regexpi2(ht2,'merge')));
tf=t2(ia,[regexpi2(ht2,'filename') regexpi2(ht2,'sub') regexpi2(ht2,'assigned')  regexpi2(ht2,'merge')]);
tf=sortrows(tf,[2 1]);

unifiles=tf(:,1);
aux     =tf(:,[1 3 2 4 ]);
% {'Copy_of_a2_003m…'}    {'assigned'}    {0×0 char} {'Copy_of_a2_###m…'}
%% ===============================================
%% 1) obtain/filter using file-extension
%% ===============================================

[~,~,ext2]=fileparts2(unifiles);
format_all =unique(ext2);


hf=findobj(gcf,'tag','pop_format');
iv=regexpi2(unifiles,strjoin(format_all,'|'));
if ~isempty(hf)
    format_control=hf.String;
    value=hf.Value;
    thisformat=format_control{value};
    if strcmp(thisformat,'all files')==0
        iv=regexpi2(unifiles,thisformat );
    end
end
unifiles=unifiles(iv);
aux     =aux(iv,:);

u.format_all=['all files';format_all];
%% ===============================================

coltype={
    'Accent'
    'Dark2'
    'Paired'
    'Pastel1'
    'Pastel2'
    'Set1'
    'Set2'
    'Set3'
    };
% ======= FILES ========================================
mdirslice  =mdir;
mdir_slice_tb=mdirslice;

% ======= matrix ========================================
v=zeros(length(unifiles),length(mdirslice));
ncol=10;
col=cbrewer('qual',coltype{3},ncol,'spline');
col=repmat(col, [ ceil((size(v,1)/ncol))  1 ]);
v2=ones([size(v) 3 ]);
vinfo=repmat({''},[size(v)]);

t3=t2(:,[ 2 5 [8] 6 1 7   [3 4]  ]);
ht3={'path: ' 'animal: ' 'slice: ' 'slice-assigned: ' 'file: ' 'subdir: ' 'size(MB): ' 'date: '};

for j=1:length(mdirslice)
    for i=1:length(unifiles)
        
        str=aux(i,4);
        
        %
        ix=find(strcmp(  t3(:,2), mdir_slice_tb{j,1}) & strcmp(  t3(:,3), str    ) );
        %disp([ ix i j]);
        if ~isempty(ix)
            v(i,j)=1;
            v2(i,j,:)=col(i,:);
            
            vinfo(i,j)={t3(ix(1),:)};
            %             if ~isempty(t3{ix(1),6})
            %                 keyboard
            %             end
            
        end
    end
end


%===================================================================================================
% ==============================================
%%   struct
% ===============================================


%         params: '----------'
u.mdirslice2    =strrep(mdirslice, '_' ,'\_');
u.mdirslice     =mdirslice;
u.mdir_slice_tb =mdir_slice_tb;
u.unifiles      =unifiles;
u.aux           =aux;
u.col           =col;
u.coltype       =coltype;
u.ht3           =ht3;
u.t3            =t3;
u.v2            =v2;
u.v1            =v;
u.sel           =zeros(size(v));
u.vinfo         =vinfo;
u.subs          =subs;


%        mdir_slice_tb: {14×3 cell}
%             unifiles: {37×1 cell}
%                  aux: {37×4 cell}
%                  col: [40×3 double]
%              coltype: {8×1 cell}
%                  ht3: {1×8 cell}
%                   t3: {133×8 cell}
%                   v2: [37×14×3 double]
%                   v1: [37×14 double]
%                vinfo: {37×14 cell}
%           mdirslice2: {14×1 cell}

%% ===============================================
%         params: '----------'
%               metric: 1
%        isreduceTable: 1
%     allcasesSelected: 1
%           foldertype: 1
%            mdirslice: {14×1 cell}
%        mdir_slice_tb: {14×3 cell}
%             unifiles: {37×1 cell}
%                  aux: {37×4 cell}
%                  col: [40×3 double]
%              coltype: {8×1 cell}
%                  ht3: {1×8 cell}
%                   t3: {133×8 cell}
%                   v2: [37×14×3 double]
%                   v1: [37×14 double]
%                vinfo: {37×14 cell}
%           mdirslice2: {14×1 cell}

% ==============================================
%%  prep BART
% ===============================================
function u=prep_bart(u)
if u.allcasesSelected==1
    fidi=bartcb('getall');
else
    fidi=bartcb('getsel');
end
w.dirs  =fidi(strcmp(fidi(:,2),'dir'),1);
w.files =fidi(strcmp(fidi(:,2),'file'),1);

if isempty(w.files); return ;end
[pas slice ext]=fileparts2(w.files);
[~, mdir ]=fileparts2(pas);



% ==============================================
%%     get files
% ===============================================
% k=dir(pas{i});
mdirused={};
t2={};
if u.foldertype==1
    nmaxslice=20;
else
    nmaxslice=1;
end

for i=1:length(mdir)
    
    
    animal=mdir{i};
    thispa=pas{i};
    
    if isempty(find(strcmp(mdirused,animal)))==1
        mdirused=[mdirused; animal];
        
        
        
        dirx={'' 'fin'};
        t={};
        for jj=1:length(dirx)
            k=dir(fullfile(thispa,dirx{jj}));
            k([k(:).isdir])=[];
            if ~isempty(k)
                t=[t;
                    [{k(:).name}' ...
                    repmat(dirx(jj),[length(k) 1]) ...
                    num2cell([k(:).bytes]'./1e6) ...
                    {k(:).date}' ];
                    ];
            end
        end
        %===================================================================================================
        
        
        
        slicnums={};
        % t2={};
        for j=1:nmaxslice
            slicnums =  pnum(j,3);
            ix=regexpi2(t(:,1),slicnums);
            %tt=t(ix,:)
            tt=[repmat([ {thispa animal slicnums 'assigned'} ],[length(ix) 1]) t(ix,:)];
            if ~isempty(tt)
                t(ix,:)=[];
                t2=[t2; tt];
            end
        end
        % unassigned-mdir
        ix=find(cellfun('isempty',t(:,2)));
        tt=[repmat([ {thispa animal 'none' 'unassigned'} ],[length(ix) 1]) t(ix,:)];
        if ~isempty(tt)
            t(ix,:)=[];
            t2=[t2; tt];
        end
        
        % unassigned-finDir
        ix=regexpi2(t(:,2),'fin');
        tt=[repmat([ {thispa animal 'none' 'unassigned'} ],[length(ix) 1]) t(ix,:)];
        if ~isempty(tt)
            t(ix,:)=[];
            t2=[t2; tt];
        end
        
    end% mdir was allready used
end% over mdirs

% ==============================================
%%  keep selected slices
% ===============================================
slicesel=unique(regexprep(slice,'a1_',''));
slicesel(end+1,1)={'none'};
[~,ia ]=ismember(t2(:,3),slicesel);
t3=t2(ia>0,:);


% ==============================================
%%   unique filenames
coltype={
    'Accent'
    'Dark2'
    'Paired'
    'Pastel1'
    'Pastel2'
    'Set1'
    'Set2'
    'Set3'
    };
% ===============================================
[unifiles ia]=unique(t3(:,5));
% aux=t3(ia,[5 4 6 [6] 2 3]);
aux=t3(ia,[5 4 6 ]);
[unifiles ia]=unique(regexprep(unifiles,'\d\d\d','###'));
aux= aux(ia,:) ;
aux(:,4)=unifiles;
aux=sortrows(aux,[3 2 1]);
if u.isreduceTable==1
    aux(regexpi2(aux(:,2),'unassigned'),:)=[]; %remove unassigned
    aux(regexpi2(aux(:,1),'^_'),:)=[]  ;%remove files starting with '_'
end
unifiles=aux(:,4);

%% ===============================================
%% 1) obtain/filter using file-extension
%% ===============================================

[~,~,ext2]=fileparts2(unifiles);
format_all =unique(ext2);


hf=findobj(gcf,'tag','pop_format');
iv=regexpi2(unifiles,strjoin(format_all,'|'));
if ~isempty(hf)
    format_control=hf.String;
    value=hf.Value;
    thisformat=format_control{value};
    if strcmp(thisformat,'all files')==0
        iv=regexpi2(unifiles,thisformat );
    end
end
unifiles=unifiles(iv);
aux     =aux(iv,:);

u.format_all=['all files';format_all];
%% ===============================================





slices=unique(regexprep(slice,'a1_',''));

%% ======== DIRS =======================================

% mdir_slice_tb=allcomb(unique(mdir),slices);
% mdirslice=cellfun(@(a,b){[a '_a' b]},mdir_slice_tb(:,1),mdir_slice_tb(:,2));
mdir_slice_tb=t3(:,[2 3]);
mdirslice=cellfun(@(a,b){[a '_a' b]},mdir_slice_tb(:,1),mdir_slice_tb(:,2));
mdir_slice_tb=[mdir_slice_tb mdirslice];
mdir_slice_tb(regexpi2(mdir_slice_tb(:,2),'none$'),:)=[]; %remove 'none'-assingment

[dum,ib]=unique(mdir_slice_tb(:,3));
mdir_slice_tb=mdir_slice_tb(ib,:);
mdirslice=mdir_slice_tb(:,3);

%% ===============================================


v=zeros(length(unifiles),length(mdirslice));
ncol=10;
col=cbrewer('qual',coltype{3},ncol,'spline');
col=repmat(col, [ ceil((size(v,1)/ncol))  1 ]);
v2=ones([size(v) 3 ]);
vinfo=repmat({''},[size(v)]);
for j=1:length(mdirslice)
    for i=1:length(unifiles)
        %         ix=find(strcmp(t3(:,2), mdir_slice_tb{j,1}) & strcmp(t3(:,3), mdir_slice_tb{j,2} ) );
        %         td=t3(ix,:);
        %         ix=regexpi2(td(:,5), regexprep(unifiles{i},'###','.*'));
        
        str=regexprep(unifiles{i},'###', mdir_slice_tb{j,2});
        %
        ix=find(strcmp(  t3(:,2), mdir_slice_tb{j,1}) & strcmp(  t3(:,5), str    ) );
        td=t3(ix,:);
        ix=1;
        if ~isempty(td)
            v(i,j)=1;
            v2(i,j,:)=col(i,:);
            vinfo(i,j)={td(ix,:)};
        end
    end
end


%===================================================================================================
% ==============================================
%%   struct
% ===============================================

% u.mdirslice2=mdirslice2;
u.mdirslice =mdirslice;
u.mdir_slice_tb =mdir_slice_tb;
u.unifiles =unifiles;
u.aux=aux;
u.col=col;
u.coltype=coltype;
u.ht3={'path: ' 'animal: ' 'slice: ' 'slice-assigned: ' 'file: ' 'subdir: ' 'size(MB): ' 'date: '};
u.t3=t3;
u.v2=v2;
u.sel=zeros(size(v));
u.v1=v;
u.vinfo=vinfo;


% % end% temp
% % % set(gcf,'userdata',u);
% %
% % return


function pop_metric(e,e2)
u=get(gcf,'userdata');

hm=findobj(gcf,'tag','pop_metric');
% metric=get(hm,'value');
metric=hm.String{hm.Value};
delete(findobj(gcf,'tag','cbar'));
if strcmp(metric, 'normal')
    him=findobj(gcf,'type','image');
    set(him, 'Cdata',u.v2);
    set(him,'CDataMapping','direct');
    return
    
end
% metric
%
% return


%% ===============================================
clc

cbarlabelpos=[1 .5 0 ];

% metric=2
vi=u.vinfo(:);
v1=u.v1(:);
siz=size(u.v1);
is=find(v1==1);
if ~isempty(strfind(metric,'extension'))==1
    fis=cellfun(@(a){[a{5}   ]}, vi(is) );
    [~,~,ext]=fileparts2(fis);
    uniext=unique(ext);
    ix=regexpi2(uniext,{'.gif|.jpg|.tif'});
    uniext=[uniext(ix); uniext(setdiff([1:length(uniext)], ix)); ];
    ix=regexpi2(uniext,{'.mat|.txt|.log|.xls|xlsx'});
    uniext=[uniext(ix); uniext(setdiff([1:length(uniext)], ix)); ];
    ix=regexpi2(uniext,{'.nii'});
    uniext=[uniext(ix); uniext(setdiff([1:length(uniext)], ix)); ];
    
    [~,ia]=ismember(ext,uniext);
    met=ia;
    mb=zeros(size(v1));
    mb(is,1)=met;
    mb=reshape(mb,siz);
    clabel='Extension';
    
    xticklabel=[{'-none-'} ;uniext];
    %xtick=  [.5  [1:max(mb(:))] ]
    xtick=linspace(0.5,max(mb(:))-.5, length(xticklabel) );
    if length(unique(xtick))==1
        xtick=linspace(0+.3,max(mb(:))-.3, length(xticklabel) );
    end
    cbarlabelpos=[7 .5 0 ];
    
elseif ~isempty(strfind(metric,'size'))
    met=cell2mat(cellfun(@(a){[a{7}   ]}, vi(is) ));
    
    
    if strcmp(metric, 'size(rank)')
        [~,ii]=sort(met,'Ascend');
        [~,r]=sort(ii);
        met=r;
        clabel='Size';
        
    elseif strcmp(metric, 'size(MB)')
        minsize=max(met)/50;
        met(met<minsize)=minsize;
        clabel='Size(MB)';
    else
        tr=str2num(regexprep(metric,{'size(<' ,'MB)'},{''}));
        met(met>tr)=tr;
        met(met<tr/10)=tr/10;
        clabel=metric;
    end
    
    
    
    mb=zeros(size(v1));
    mb(is,1)=met;
    mb=reshape(mb,siz);
    
    xtick     =[round(min(mb(:)))  round(max(mb(:))) ];
    xticklabel={num2str(min(mb(:)))  ['>' num2str(round(max(mb(:))))] };
    if strcmp(metric, 'size(rank)')
        xticklabel=[{'small'} ;{'large'}];
    end
    
elseif ~isempty(strfind(metric,'date'))
    fsiz=(cellfun(@(a){[a{8}   ]}, vi(is) ));
    %dum=(cellfun(@(a){[a{1}   ]}, vi(is) ));
    try
        dn = cell2mat(datenum(fsiz, 'dd-mmm-yyyy  HH:MM:SS'));
    catch
        dn={};
        ier=[];
        for i=1:length(fsiz)
            try
                dn{i,1} = (datenum(fsiz{i}, 'dd-mmm-yyyy HH:MM:SS'));
            catch
                ier=[ier;i] ;
            end
        end
        tmed=median(cell2mat(dn));
        dn(ier)={tmed};
    end
    if iscell(dn); dn=cell2mat(dn); end
    
    
    tmax=max(dn);
    tmin=min(dn);
    % days=cell2mat(arrayfun(@(a){[ etime(datevec(a), datevec(tmax)  )./(3600*24)   ]}, dn ));
    days=cell2mat(arrayfun(@(a){[ etime(datevec(a), datevec(tmin)  )./(3600*24)   ]}, dn ));
    %      days=abs(days)
    %  [fsiz num2cell(days)]
    if strcmp(metric,'date(rank)')
        [~,ii]=sort(days,'Ascend');
        [~,r]=sort(ii);
        met=r;
        
        %         [~,isort]=sort(days);
        %         met=isort;
        xl={datestr(tmin,'dd.mmm.yy HH:MM') datestr(tmax,'dd.mmm.yy HH:MM')};
    elseif strcmp(metric,'date')
        tmed=median(dn);
        days=cell2mat(arrayfun(@(a){[ etime(datevec(a), datevec(tmed)  )./(3600*24)   ]}, dn ));
        TRminday=-20;
        days(find(days<TRminday))=TRminday;
        met=days;
        met(met==0)=.1;
        
        xl={datestr(tmin,'dd.mmm.yy HH:MM') datestr(tmax,'dd.mmm.yy HH:MM')};
    elseif strcmp(metric,'date(newest)')
        ts=flipud(sortrows([days [1:length(days)]'],1));
        ts(:,3)=1;
        if size(ts,1)>5;
            ts(1:5,3)=flipud([1:5]'+1);
        end
        ts=sortrows(ts,2);
        met=ts(:,3);
        xl={datestr(tmin,'dd.mmm.yy HH:MM') datestr(tmax,'dd.mmm.yy HH:MM')};
    else
        
        met=days;
        met(met==0)=.1;
        tr=0-str2num(regexprep(metric,'\D+',''));
        val=max(days)+tr;
        met(met<val)=1;
        
        time1=datestr(datevec(addtodate(tmax, tr, 'day')),'dd.mmm-yy');
        time2=datestr(datevec(tmax));
        xl={ ['<' time1] [time2]  };
        
        
    end
    
    
    %     tr=-15
    %     val=max(days)+tr
    %     met(met<val)=val
    %
    %     time1=datestr(datevec(addtodate(tmax, tr, 'day')),'dd.mmm-yy')
    %     time2=datestr(datevec(tmax))
    %     xl={ ['<' time1] [time2]  }
    
    
    mb=zeros(size(v1));
    mb(is,1)=met;
    mb=reshape(mb,siz);
    clabel=metric;
    xtick     =[(min(mb(:)))  (max(mb(:))) ];
    xticklabel=xl;
end


% ===============================================


%  fg;
%  him=imagesc(mb, [(min(mb(:))) (max(mb(:))) ]   ) ;
him=findobj(gcf,'type','image');
set(him, 'Cdata',mb);
set(him,'CDataMapping','scaled');

vnan=double(mb~=0);
%  vnan(vnan==0)=nan;
set(him,'AlphaData',vnan);


%  imAlpha(isnan(Data_Array))=0;

% map=hsv
delete(findobj(gcf,'tag','cbar'));
if ~isempty(strfind(metric,'extension'))
    %     map=flipud(cbrewer('qual','Set1',length(xticklabel),'spline'));
    
    Ncol=10;
    if length(xticklabel)<=Ncol
        %map=(cbrewer('qual','Set1',Ncol));
        map=distinguishable_colors(Ncol,{'w','k'});
    else
        %map=(cbrewer('qual','Accent',length(xticklabel)));
        map=distinguishable_colors(length(xticklabel),{'w','k'});
    end
    map=map(1:length(xticklabel),:);
    %     map(end+1,:)=(repmat(.7,[1 3]));
    map(1,:)=(repmat(1,[1 3]));
else
    map=flipud(cbrewer('div','Spectral',50,'spline'));
    %map(1,:)=(repmat(.7,[1 3]));
    
end
map(map>1)=1;
% caxis([0 round(max(mb(:))) ])
colormap(map);
hc=colorbar('west');
set(hc,'Position',[0.906 0.1 0.008 .23],'FontSize',5);
set(hc,'tag','cbar');

hc.Label.String = clabel;
set(hc,'xtick',xtick,'xticklabel',xticklabel);
% set(hc.Label,'Position',cbarlabelpos,'fontsize',5,'fontweight','bold');
set(hc,'FontSize',6);
% drawnow



% if strcmp(metric, 'size')
%     hc.Label.String = 'Size(MB)';
%     set(hc,'xtick',[round(min(mb(:)))  round(max(mb(:))) ]);
%     set(hc.Label,'Position',[1 .5 0 ],'fontsize',8,'fontweight','bold');
%     set(hc,'FontSize',6);
% elseif strcmp(metric, 'date')
%     hc.Label.String = 'Date';
%     set(hc,'xtick',[(min(mb(:)))  (max(mb(:))) ]);
%     set(hc,'xticklabel',{datestr(tmin,'dd.mmm.yy HH:MM') datestr(tmax,'dd.mmm.yy HH:MM')});
% end
set(hc.Label,'units','norm');
set(hc.Label,'Position',[1 .5 0 ],'fontsize',7,'fontweight','bold');
set(hc.Label,'Position',cbarlabelpos,'fontsize',6,'fontweight','bold');


% hot2=flipud(hot)
% mb2 = double2rgb(mb, hot2, [0  max(mb(:))]);
%  fg,image(mb2) ;
% colormap(hot2); colorbar




%% ===============================================


% ==============================================
%%   FIGURE
% ===============================================
function makefig(u,isnewfig)

% ==============================================
%%   make figure
% ===============================================
if isnewfig==1
    delete(findobj(0,'tag','cfmatrix'));
    fg;
    set(gcf,'units','norm','tag','cfmatrix','numbertitle','off','name',['cfm [' mfilename ']']);
    image(u.v2);
    set(gcf,'userdata',u);
else
    him=findobj(0,'Type','image');
    set(him,'AlphaData',1);
    set(him,'Cdata',u.v2);
end
ax=gca;
set(gca,'position',[0.1    0.15    0.8 0.75]);
set(gca,'ytick',[1: length(u.unifiles) ]);%,'yticklabels',unifiles)
% try
%     setFileSlider();
% catch
%     set(gca,'ytick',[1: length(u.unifiles) ]);%,'yticklabels',unifiles)
% end
set(gca,'xtick',[1: length(u.mdirslice) ]);%,'yticklabels',unifiles)
% drawnow;
%  set(gca,'XLimMode','auto','yLimMode','auto');

xlim([.5 length(u.mdirslice)+.5]); ylim([.5  length(u.unifiles)+.5]);
delete(findobj(gcf,'tag','cbar'));
% ==============================================
%%   lines
% ===============================================
delete(findobj(gcf,'tag','line'));
delete(findobj(gcf,'tag','sel'));
hittest='on';
h1=hline([.5:1:length(u.unifiles)],'color','k','HitTest',hittest,'LineWidth',0.1 ,'tag','line');
h2=vline([.5:1:length(u.mdirslice)],'color','k','HitTest',hittest,'LineWidth',0.1,'tag','line');

if u.foldertype==1
    try
        ix_unassigned=min(regexpi2(u.aux(:,2),'unassigned'));
        h2=hline([ix_unassigned-0.5],'color','k','HitTest',hittest,'LineWidth',2,'tag','line');
        h2=hline([ix_unassigned-0.5],'color',['y' ],'linestyle','--','HitTest','off','LineWidth',2,'tag','line');
    end
    try
        ix_fin=min(regexpi2(u.aux(:,3),'fin'));
        h2=hline([ix_fin-0.5],'color','k','HitTest',hittest,'LineWidth',2,'tag','line');
        h2=hline([ix_fin-0.5],'color',['m' ],'linestyle','--','HitTest','off','LineWidth',2,'tag','line');
    end
else
    for i=1:length(u.subs)
        try
            ix_fin=min(regexpi2(u.aux(:,3),u.subs{i}));
            h2=hline([ix_fin-0.5],'color','k','HitTest',hittest,'LineWidth',1.2,'tag','line');
            h2=hline([ix_fin-0.5],'color',['m' ],'linestyle','--','HitTest','off','LineWidth',1.2,'tag','line');
        end
    end
    
    
end


%% __ lines between different animal folders __
mdir2=regexprep(u.mdirslice,'_a\d\d\d$','');
[~,ia]=unique(mdir2);

if ~isempty(ia)
    try
        h3=vline([ia(2:end)]-.5,'color','k','HitTest',hittest,'LineWidth',2 ,'tag','line');
    end
end


% ==============================================
%%   limits, x/ylabel
% ===============================================

files=regexprep(u.unifiles, {'_','###'} ,{'\\_' '#'});
mdirslice2=strrep(u.mdirslice, '_' ,'\_');
set(gca,'xtick',[1: length(mdirslice2) ],'xticklabels',mdirslice2);
set(gca,'XTickLabelRotation',30,'fontsize',u.fs_label);
for i=1:length(files)
    ax.YTickLabel{i}=['\color[rgb]{' sprintf('%f,%f,%f',u.col(i,:) )  '}' files{i} ];
end



col2=cbrewer('qual',u.coltype{7},5,'spline');
col2=repmat(col2, [ ceil((size(u.v2,2)))  1 ]);
colcnt=1;
lastmdir=u.mdir_slice_tb{1,1};
for i=1:length(mdirslice2)
    if strcmp(lastmdir,u.mdir_slice_tb{i,1})~=1
        colcnt=colcnt+1;
    end
    lastmdir=u.mdir_slice_tb{i,1};
    ax.XTickLabel{i}=['\color[rgb]{' sprintf('%f,%f,%f',col2(colcnt,:) )  '}' mdirslice2{i} ];
end

set(gca,'TickLength',[0 0]);
set(gca,'fontweight','bold');

set(gcf,'menubar','none');
set(gcf,'WindowButtonMotionFcn',@motion);
set(gcf,'WindowButtonDownFcn',@mouseclick);
set(gcf,'WindowKeyPressFcn',@keys);
% ==============================================
%%   uicontrols
% ===============================================
if isnewfig==1
    
%     %% radio_info
%     hb=uicontrol('style','radio','units','norm','tag','rd_info','string','info');
%     set(hb,'backgroundcolor','w','fontsize',6);
%     set(hb,'position',[0.64107 0.9631 0.1 0.045]);
%     set(hb,'callback',@rd_info);
%     set(hb,'tooltipstring',['obtain file information when hovering']);
%     
%     %% radio_tooltip
%     hb=uicontrol('style','radio','units','norm','tag','rd_tt','string','TT');
%     set(hb,'backgroundcolor','w','fontsize',6);
%     set(hb,'position',[0.64107 0.93929 0.1 0.032]);
%     set(hb,'tooltipstring',['obtain file information next to mouse pointer']);
    
    
    popTTstr={'no info','info-corner' 'tooltip'};
    hb=uicontrol('style','popupmenu','units','norm','tag','pop_TT','string',popTTstr);
    set(hb,'backgroundcolor','w','fontsize',6,'value',1);
    set(hb,'position',[0.91071 0.64643 0.1 0.032]);
    set(hb,'callback',@popTT);
    set(hb,'tooltipstring',['show file information (no/corner/tooltip) when hovering over file']);
    
    
    %% txt-info
    hb=uicontrol('style','text','units','norm','tag','tx_info','string','');
    set(hb,'backgroundcolor','w');
    posInfo=[.7 .9 .3 .1];
    set(hb,'position',posInfo,'fontsize',5, 'userdata',posInfo);
    try;
        set(hb,'FontName','Consolas');
    catch
        set(hb,'FontName','Courier New');
    end
    set(hb,'HorizontalAlignment','left');
    
    q.FontName           =get(hb,'FontName');
    q.fontsize           =get(hb,'fontsize');
    q.HorizontalAlignment=get(hb,'HorizontalAlignment');
    
    
    %% dummy-text to obtain the width
    hb=uicontrol('style','text','units','norm','tag','tx_dummy','string','');
    set(hb,'fontsize',q.fontsize,'FontName',q.FontName,'HorizontalAlignment',q.HorizontalAlignment );
    set(hb,'visible','off');
    
     %% help
    hb=uicontrol('style','pushbutton','units','norm','tag','pb_help','string','?');
    set(hb,'backgroundcolor',[1 1 1],'fontsize',6);
    set(hb,'position',[0.95893 0.87262 0.03 0.03]);
    set(hb,'callback',@pb_help);
    set(hb,'tooltipstring',['get help']);
     %% shortcut
    hb=uicontrol('style','pushbutton','units','norm','tag','pb_help','string','S');
    set(hb,'backgroundcolor',[1 1 1],'fontsize',6);
    set(hb,'position',[0.93214 0.87262 0.03 0.03]);
    set(hb,'callback',@keylist_show);
    set(hb,'tooltipstring',['get shortcut-list']);
    
    
    %% update
    hb=uicontrol('style','pushbutton','units','norm','tag','pb_update','string','update');
    set(hb,'backgroundcolor',[1.0000    0.7333    0.1608],'fontsize',6);
    set(hb,'position',[0.90893 0.84228 0.08 0.032]);
    set(hb,'callback',@pb_update);
    set(hb,'tooltipstring',['update files/folders']);
    
    %% delselection
    hb=uicontrol('style','pushbutton','units','norm','tag','pb_delselection','string','deSel.');
    set(hb,'backgroundcolor',['w'],'fontsize',6);
    set(hb,'position',[0.90714 0.56548 0.05 0.032]);
    set(hb,'callback',@pb_delselection);
    set(hb,'tooltipstring',['deselect all']);
    
    %% radio_multiselect
    hb=uicontrol('style','radio','units','norm','tag','rd_multiSel','string','multiSel');
    set(hb,'backgroundcolor','w','fontsize',6);
    set(hb,'position',[0.90675 0.60169 0.1 0.032]);
    set(hb,'tooltipstring',['single-/multi-select files']);
    
    %% reduce table
    hb=uicontrol('style','radio','units','norm','tag','rd_reduce','string','reduce');
    set(hb,'backgroundcolor','w','fontsize',6,'value',1);
    set(hb,'position',[0.90714 0.74881 0.1 0.032]);
    set(hb,'callback',@rd_reduce);
    set(hb,'tooltipstring',...
        ['<html><b> show reduced dir-content </b><br>'...
        '[x] reduced table: show files from dir (level-1) <br>'...
        '[ ] full table: show all files from all subDirs' ]);
    
    %% metric
    metric={'normal'...
        'extension'...
        'size(MB)'...
        'size(rank)' ...
        'size(<1MB)' 'size(<10MB)' 'size(<20MB)' ...
        'size(<50MB)' 'size(<100MB)' 'size(<200MB)' 'size(<500MB)' 'size(<1000MB)' ...
        ...
        ...
        'date' 'date(rank)'...
        'date(newest)' ...
        'date(last 1 day)' 'date(last 5 days)' 'date(last 10 days)' 'date(last 20 days)'...
        };
    hb=uicontrol('style','popupmenu','units','norm','tag','pop_metric','string',metric);
    set(hb,'backgroundcolor','w','fontsize',6,'value',u.metric);
    set(hb,'position',[[0.90893 0.78214 0.1 0.032]]);
    set(hb,'callback',@pop_metric);
    set(hb,'tooltipstring',['displaying metric {normal/FileSize/Date} ']);
    
    hm=findobj(gcf,'tag','pop_metric');
    if strcmp(hm.String{hm.Value},'normal')==0
        pop_metric([],[]);
    end
    
    
    %% radio_info
    hb=uicontrol('style','radio','units','norm','tag','rd_axEqual','string','axEqual');
    set(hb,'backgroundcolor','w','fontsize',6);
    set(hb,'position',[0.91071 0.80833 0.1 0.031]);
    set(hb,'callback',@rd_axEqual);
    set(hb,'tooltipstring',['set axis [0] normal or [1] equal(image) ']);
    
    %% extenfion/format
    format=u.format_all;
    hb=uicontrol('style','popupmenu','units','norm','tag','pop_format','string',format);
    set(hb,'backgroundcolor','w','fontsize',6,'value',1);
    set(hb,'position',[0.90893 0.7131 0.1 0.032]);
    set(hb,'callback',@pop_format,'backgroundcolor','y');
    set(hb,'tooltipstring',['file filter based on extension  ']);
    
   
     %% radio_hideSliders
    hb=uicontrol('style','radio','units','norm','tag','rd_hideSliders','string','hide Sliders');
    set(hb,'backgroundcolor','w','fontsize',6);
    set(hb,'position',[0.90179 0.47976 0.1 0.032]);
    set(hb,'tooltipstring',['show/hide sliders']);
    set(hb,'value',0);
    set(hb,'callback',@rd_hideSliders);
    
    %% radio_file_Slider_showfullrange
    hb=uicontrol('style','radio','units','norm','tag','rd_visAllFiles','string','visAllFiles');
    set(hb,'backgroundcolor','w','fontsize',6);
    set(hb,'position',[0.90179 0.44881 0.1 0.032]);
    set(hb,'tooltipstring',['show  all files']);
    set(hb,'value',1);
    set(hb,'callback',@rd_visAllFiles);
% ==============================================
%% FILE-slider
% ===============================================
warning off
range=[1 length(u.unifiles)];
hj = com.jidesoft.swing.RangeSlider(range(1),range(2),range(1),range(2));  % min,max,low,high
[hj hb] = javacomponent(hj, [0,0,200,80], gcf);
set(hj, 'MajorTickSpacing',20, 'MinorTickSpacing',5, 'PaintTicks',true, 'PaintLabels',true, ...
    'Background',java.awt.Color.white, 'StateChangedCallback',@call_slider_files);
set(hj,'Orientation',1);% VERTICAL
set(hb,'units','norm');
set(hb,'position',[.905 .148 .07 .3]);
u.hj_sliderFiles=hj;
u.hb_sliderFiles=hb;
set(gcf,'userdata',u);
% ===============================================
setFileSlider(); % ###set values of fileslider
%% ===============================================

 %% radio_DIR-Slider_showfullrange
    hb=uicontrol('style','radio','units','norm','tag','rd_visAllDirs','string','visAllDirs');
    set(hb,'backgroundcolor','w','fontsize',6);
    set(hb,'position',[0.85536 0.070238 0.1 0.032]);
    set(hb,'tooltipstring',['show  all files']);
    set(hb,'value',1);
    set(hb,'callback',@rd_visAllDirs);
% ==============================================
%% DIR-slider
% ===============================================
warning off
range=[1 length(u.mdirslice)];
hj = com.jidesoft.swing.RangeSlider(range(1),range(2),range(1),range(2));  % min,max,low,high
[hj hb] = javacomponent(hj, [0,0,200,80], gcf);
set(hj, 'MajorTickSpacing',20, 'MinorTickSpacing',5, 'PaintTicks',true, 'PaintLabels',true, ...
    'Background',java.awt.Color.white, 'StateChangedCallback',@call_slider_dirs);
set(hj,'Orientation',0);% Horizontal
set(hb,'units','norm');
set(hb,'position',[.8 0 .2 .072]);
u.hj_sliderDirs=hj;
u.hb_sliderDirs=hb;
set(gcf,'userdata',u);
% ===============================================
setDirSlider(); % ###set values of DIRslider
%% ===============================================

u.figpos=get(gcf,'position');
    
end



% ==============================================
%%   contextMenu
% ===============================================
setcontextmenu();
% ==============================================
%%   struct
% ===============================================
u.mdirslice2=mdirslice2;

u.axpos=get(gca,'position');
set(gcf,'userdata',u);


dragbtn_ini();

% ==============================================
%%   file-slider update-range
% ===============================================
setFileSlider();
setDirSlider();
hr=findobj(gcf,'tag','pop_metric');
hr.Value=1;


function rd_visAllDirs(e,e2)
if get(findobj(gcf,'tag','rd_visAllDirs'),'value')==0
    u=get(gcf,'userdata');
    hj=u.hj_sliderDirs;
    range2=[1  length(u.mdirslice)];
    if range2(2)>20
        hj.setLowValue( 1);
        hj.setHighValue( length(u.mdirslice));
    end
    
end
setDirSlider();


function rd_visAllFiles(e,e2)
if get(findobj(gcf,'tag','rd_visAllFiles'),'value')==0
    u=get(gcf,'userdata');
    hj=u.hj_sliderFiles;
    range2=[1  length(u.unifiles)];
    
    if range2(2)>20
        hj.setHighValue( length(u.unifiles));
        hj.setLowValue( length(u.unifiles)-20+1);
    end
    
end
setFileSlider();


function setDirSlider() % ###set values of fileslider
u=get(gcf,'userdata');
hj=u.hj_sliderDirs;

range2=[1  length(u.mdirslice)];
hj.setMinimum(range2(1));
hj.setMaximum(range2(2));
if get(findobj(gcf,'tag','rd_visAllDirs'),'value')==1
    hj.setLowValue( range2(1));
    hj.setHighValue(range2(2));
    
end
% range2=[hj.getMinimum hj.getMaximum];
if range2(2)<10
    ticks=1:range2(2);
else
    ticks=round(linspace(range2(1),range2(2),4));
end
if length(unique(ticks))==1
  ticks=[1 1.2];  
end
ticklab=(cellstr(num2str(ticks(:))));
% ticklab={'OVL' 'SbS' 'fus' 'con1' 'con2'};
% ticknum=[0 33 66 99]
labelTable = java.util.Hashtable;
% font = java.awt.Font('Tahoma',java.awt.Font.PLAIN, 8);
for i=1:length(ticklab) 
    key=ticks(i);
    mLabel = ticklab{i}; %Matlab Char
    jLabel = javaObjectEDT('javax.swing.JLabel', mLabel); % Java JLabel
    font=jLabel.getFont;
    font2 = java.awt.Font(font.getName,font.getStyle,font.getSize.*.8  );
    set(jLabel,'font',font2);
    labelTable.put(int32(key), jLabel);
end
hj.setLabelTable(labelTable);



function setFileSlider() % ###set values of fileslider
u=get(gcf,'userdata');
hj=u.hj_sliderFiles;

range2=[1  length(u.unifiles)];
hj.setMinimum(range2(1));
hj.setMaximum(range2(2));
if get(findobj(gcf,'tag','rd_visAllFiles'),'value')==1
    hj.setHighValue(range2(2));
    hj.setLowValue( range2(1));
end
% range2=[hj.getMinimum hj.getMaximum];
if range2(2)<10
    ticks=1:range2(2);
else
    ticks=round(linspace(range2(1),range2(2),4));
end
if length(unique(ticks))==1
  ticks=[1 1.2];  
end
ticklab=flipud(cellstr(num2str(ticks(:))));
% ticklab={'OVL' 'SbS' 'fus' 'con1' 'con2'};
% ticknum=[0 33 66 99]
labelTable = java.util.Hashtable;
% font = java.awt.Font('Tahoma',java.awt.Font.PLAIN, 8);
for i=1:length(ticklab) 
    key=ticks(i);
    mLabel = ticklab{i}; %Matlab Char
    jLabel = javaObjectEDT('javax.swing.JLabel', mLabel); % Java JLabel
    font=jLabel.getFont;
    font2 = java.awt.Font(font.getName,font.getStyle,font.getSize.*.8  );
    set(jLabel,'font',font2);
    labelTable.put(int32(key), jLabel);
end
hj.setLabelTable(labelTable);
try; call_slider_dirs([],[]); end

%% ===============================================
function call_slider_dirs(e,e2)
% 'call_slider_dirs'

u=get(gcf,'userdata');
hj=u.hj_sliderDirs;
range=[hj.getMinimum hj.getMaximum];
vals =[hj.getLowValue hj.getHighValue];
l1= hj.getLowValue; 
l2= hj.getHighValue;
range2=[l1 l2];

if range2(2)>range2(1)
    xlim([ range2(1)-0.5  range2(2)+.5 ]);
% else
%     'no'
end

function call_slider_files(e,e2)
%% ===============================================

u=get(gcf,'userdata');
hj=u.hj_sliderFiles;
range=[hj.getMinimum hj.getMaximum];
vals =[hj.getLowValue hj.getHighValue];
l1= hj.getMaximum-hj.getHighValue+1;
l2=hj.getMaximum-hj.getLowValue+1;
range2=[l1 l2];

if range2(2)>range2(1);
    ylim([ range2(1)-0.5  range2(2)+.5 ]);
% else
%     'no'
end

%% ===============================================


function rd_axEqual(e,e2)
value=get(findall(gcf,'tag','rd_axEqual'),'value');
if value==0
    axis normal;
else
    %axis image;
    axis square;
end


function pb_delselection(e,e2)
u=get(gcf,'userdata');
u.sel=zeros(size(u.sel));
set(gcf,'userdata',u)
delete(findobj(gcf,'tag','sel'));

function co=getSelection()

u=get(gcf,'userdata');
cc=get(gca,'CurrentPoint');
cc=cc(1,1:2);
% co=ceil(cc-.5);

hp=findobj(gcf,'tag','sel');
co=([get(hp,'xdata') get(hp,'ydata')]);
if iscell(co)
    co=cell2mat(co);
end
if isempty(hp)
    co=ceil(cc-.5);
end



%===================================================================================================
function popTT(e,e2)
hr=findobj(gcf,'tag','tx_info');
hp=findobj(gcf,'tag','pop_TT');
if hp.Value==1
    set(hr,'visible','off');
else
    set(hr,'visible','on','position',hr.UserData);
end

function s=getSlectedFiles()
u=get(gcf,'userdata');
s0=u.vinfo(u.sel==1);
s={};
for i=1:length(s0);
    s(i,:)=s0{i};
end



function setcontextmenu()
u=get(gcf,'userdata');
% ha=[findobj(gcf,'tag','line'); findobj(gcf,'type','image'); gcf;gca; findobj(gcf,'tag','sel')];

ha=[ findobj(gcf,'type','image'); gcf;gca; ];
hb=findobj(gcf,'tag','sel');
hc=findobj(gcf,'tag','line');

cmenu = uicontextmenu;
uimenu(cmenu, 'Label', '<html><b><font color =green> open DIRECTORY', 'Callback'            , {@context, 'opdenDIR'});
uimenu(cmenu, 'Label', '<html><b><font color =green> view/open selected files', 'Callback', {@context, 'viewfiles'});
uimenu(cmenu, 'Label', '<html><b><font color =gray> get file information', 'Callback'       , {@context, 'getInfo'});
uimenu(cmenu, 'Label', '<html><b><font color =gray> get NIFTI-header information', 'Callback'       , {@context, 'getNiftiInfo'});

if u.foldertype==1
    uimenu(cmenu, 'Label', '<html><b><font color =orange> pre-select slices in BART', 'Callback'     , {@context, 'selectBart'},'separator','on');
elseif u.foldertype==2 && u.useANT==1
    uimenu(cmenu, 'Label', '<html><b><font color =orange> pre-select animals in ANT', 'Callback'     , {@context, 'selectAnt'},'separator','on');
end

uimenu(cmenu, 'Label', '<html><b><font color =black> select column |	',   'Callback'         , {@context, 'selectColumn'},'separator','on');
uimenu(cmenu, 'Label', '<html><b><font color =black> select row -'   ,       'Callback'             , {@context, 'selectRow'});
uimenu(cmenu, 'Label', '<html><b><font color =black> select range []'         , 'Callback'             , {@context, 'selectRange_call'});
uimenu(cmenu, 'Label', '<html><b><font color =black> select DIRS and FILES from list'   , 'Callback'    , {@context, 'selectFilesFromDirs_call'});


uimenu(cmenu, 'Label', '<html><b><font color =purple> copy and rename files', 'Callback'            , {@context, 'copyNrename'},'separator','on');
uimenu(cmenu, 'Label', '<html><b><font color =fuchsia> rename files ',          'Callback'           , {@context, 'renameFiles'},'separator','off');

uimenu(cmenu, 'Label', '<html><b><font color =blue>import Dir2DIR', 'Callback',         {@context, 'importDir2DIR'},'separator','on');
uimenu(cmenu, 'Label', '<html><b><font color =blue>export entire folder', 'Callback',   {@context, 'exportDirs'},'separator','on');
uimenu(cmenu, 'Label', '<html><b><font color =blue>export empty folder', 'Callback',    {@context, 'exportDirsEmpty'});
uimenu(cmenu, 'Label', '<html><b><font color =blue>export seleted files', 'Callback',   {@context, 'exportFiles'});

uimenu(cmenu, 'Label', '<html><b><font color =red>delete files', 'Callback', {@context, 'deleteFiles'},'separator','on');

try; set(ha,'ContextMenu',cmenu); catch; set(ha,'uicontextMenu',cmenu); end
try; set(hb,'ContextMenu',cmenu); catch; set(hb,'uicontextMenu',cmenu); end
try; set(hc,'ContextMenu',cmenu); catch; set(hc,'uicontextMenu',cmenu); end


% ==============================================
%%   context
% ===============================================

function context(e,e2,task)
hf=findobj(0,'tag','cfmatrix');
ax=findobj(hf,'type','axes');
u=get(hf,'userdata');
cc=get(ax,'CurrentPoint');
cc=cc(1,1:2);
% co=ceil(cc-.5);

hp=findobj(hf,'tag','sel');
xx=get(hp,'xdata');
yy=get(hp,'ydata');

co=([xx(:) yy(:)]);
if iscell(co)
    co=cell2mat(co);
end
if isempty(hp)
    co=ceil(cc-.5);
end

if strcmp(task, 'viewfiles')
    openfile('multi');
elseif strcmp(task, 'selectRow')
    selectRow();
elseif strcmp(task, 'selectColumn')
    selectColumn();
elseif strcmp(task, 'selectRange_call')
    selectRange();
elseif strcmp(task, 'selectFilesFromDirs_call')
    selectFilesFromDirs();    
elseif strcmp(task, 'opdenDIR')
    pax={};
    for i=1:size(co,1)
        t=u.vinfo{co(i,2),co(i,1)};
        if ~isempty(t)
            pax(end+1,1)=t(1);
        end
    end
    pax=unique(pax);
    if ~isempty(pax)
        for i=1:length(pax)
            explorer(pax{i});
        end
    end
elseif strcmp(task, 'selectBart')
    t={};
    for i=1:size(co,1)
        dx=u.vinfo{co(i,2),co(i,1)};
        %dx
        if ~isempty(dx)
            t(end+1,:)=dx;
        end
    end
    if ~isempty(t)
        f1=unique(cellfun(@(a,b){[a filesep 'a1_' b]},t(:,1),t(:,3)));
        bartcb('sel','filename',f1);
    end
elseif strcmp(task, 'selectAnt')
    s=getSlectedFiles();
    if isempty(s)
       s=u.vinfo{co(2),co(1)} ;
    end
    mdirsSel=unique(s(:,2));
    if isempty(mdirsSel); return; end
    antcb('selectdirs',mdirsSel);

elseif strcmp(task, 'getInfo')
    t={};
    for i=1:size(co,1)
        dx=u.vinfo{co(i,2),co(i,1)};
        if ~isempty(dx)
            t(end+1,:)=dx;
        end
    end
    set(hf,'WindowButtonMotionFcn',[]);
    set(hf,'WindowButtonDownFcn',[]);
    iord=[3 2  6  7 8 1] ;
    t2=t(:,[ iord ]);
    ht2=u.ht3(iord); ht2{1}='slice/image';
    uhelp(plog([],[ht2;t2],0, '#lk FILE-FOLDER-INFO #n','s=4;al=1;'),1,'name','CFMinfo');
    drawnow
    set(hf,'WindowButtonMotionFcn',@motion);
    set(hf,'WindowButtonDownFcn',@mouseclick);
elseif strcmp(task, 'getNiftiInfo')
    cprintf([1 0 1],'..read NIFTI-header..(wait!!!)...');
     set(hf,'WindowButtonMotionFcn',[]);
    set(hf,'WindowButtonDownFcn',[]);
    
    t={};
    for i=1:size(co,1)
        dx=u.vinfo{co(i,2),co(i,1)};
        if ~isempty(dx)
            t(end+1,:)=dx;
        end
    end
    t=t(regexpi2(t(:,3),'.nii$'),:);
    if isempty(t); return; end
   %% ---
   g={};
   sp=repmat({''},[3 1]);%empty space
   se=repmat({'|'},[4 1]);%separator
   c1={'--> #b '  ' #n ' ' #n ' ' #n ' }';
   c2={' #g '  ' #n ' ' #n ' ' #n ' }';
   c3={'  #k '  ' #k ' ' #k ' ' #k ' }';
   for i=1:size(t,1)
       f1=fullfile(t{i,1}, t{i,6}, t{i,5});
       h=spm_vol(f1);
       nvol=length(h);
       h=h(1);
       %g{end+1,:}=[' # File:  ']
       
       mdir   =[t{i,2} ];
       name   =t(i,5);
       subdir =t(i,6);
       mat    =num2cell(h.mat);
       
        dx=[ c1 [name;sp] c2 se [mdir;sp] se [subdir;sp]  [se c3] num2cell([h.dim nvol]') se mat ...
       se [num2cell(h.dt'); [{'';''}]] se [num2cell(h.pinfo); [{''}]] ...
           se [{h.descrip};{'';'';''}] se  [t{i,1};sp] ];
       sepline=cellfun(@(a){ repmat('',[1 length(num2str(a))]) },dx(1,:));
       sepline{1}='B1C2D3uvw';
       
       g=[g; dx; sepline];
   end
   E='|';
   ht2={' #ka ' 'name' '#ka' E 'dir' E 'sub' E '#ka' ' dim' E  'mat' '' '' '' ...
       E 'dT' E 'pinfo' E 'descrip'   E 'path'}  ;
   
   h3=plog([],[ht2;g],0, '#lk NIFTI-HEADER-INFO #n','s=1;al=1;');
   h3(regexpi2(h3,'B1C2D3uvw'))= {repmat('_',[size(h3{1})])};
   h3(end,1)={''};
   uhelp(h3,0,'name','NIFTI-HDR');
   cprintf([0 .7 0],'..Done!\n');
   %% ---
    
   
    
    set(hf,'WindowButtonMotionFcn',@motion);
    set(hf,'WindowButtonDownFcn',@mouseclick);
    
elseif strcmp(task, 'exportDirs') || strcmp(task, 'exportFiles') || strcmp(task, 'exportDirsEmpty')
    warning off;
    t={};
    for i=1:size(co,1)
        dx=u.vinfo{co(i,2),co(i,1)};
        if ~isempty(dx)
            t(end+1,:)=dx;
        end
    end
    
    pamainout=uigetdir(pwd,'select targe-folder');
    if isnumeric(pamainout); return, end
    
    if strcmp(task, 'exportDirs')
        mdirs=unique(t(:,1));
        if isempty(mdirs); return; end
        [~, animal]=fileparts2(mdirs);
        fprintf('..exporting dirs (with content)..');
        for i=1:length(mdirs)
            d1=fullfile(pamainout,animal{i});
            fprintf( [ '|' animal{i} '..' ]);
            mkdir(d1);
            copyfile(mdirs{i},d1,'f');
        end
        fprintf('\n');
        fprintf('..Done!\n');
        showinfo2('Export: ',pamainout);
    elseif strcmp(task, 'exportDirsEmpty')
        mdirs=unique(t(:,1));
        if isempty(mdirs); return; end
        [~, animal]=fileparts2(mdirs);
        fprintf('..exporting dirs (without content)..');
        for i=1:length(mdirs)
            d1=fullfile(pamainout,animal{i});
            fprintf( [ '|' animal{i} '..' ]);
            mkdir(d1);
            %copyfile(mdirs{i},d1,'f');
        end
        fprintf('\n');
        fprintf('..Done!\n');
        showinfo2('Export: ',pamainout);
    elseif strcmp(task, 'exportFiles')
        %% ===============================================
        
        fis=cellfun(@(a,b,c){[a filesep b filesep c]},t(:,1),t(:,6),t(:,5));
        fis=strrep(fis,[filesep filesep],filesep);
        t2=[t(:,1) t(:,6) fis];
        
        [~,ia]=unique(t2(:,3));
        if isempty(ia); return; end
        t2=t2(ia,:);
        
        [pam, animal]=fileparts2(t2(:,1));
        
        fprintf(['..exporting (' num2str(size(t2,1)) ' files)..']);
        for i=1:size(t2,1)
            f1=t2{i,3};
            fprintf( [ '|' animal{i} '..' ]);
            d1=fullfile(pamainout,animal{i});
            if ~isempty(t2{i,2})
                d1=fullfile(d1,t2{i,2});
            end
            mkdir(d1);
            copyfile(f1,d1,'f' );
        end
        fprintf('\n');
        fprintf('..Done!\n');
        showinfo2('Export: ',pamainout);
        %% ===============================================
    end
elseif strcmp(task, 'importDir2DIR')
  importDir2DIR();
elseif strcmp(task, 'copyNrename')    
  renameFiles('copyNrename');
 elseif strcmp(task, 'renameFiles')    
  renameFiles('renameFiles'); 
  
    
elseif strcmp(task, 'deleteFiles')
    warning off;
    t={};
    for i=1:size(co,1)
        dx=u.vinfo{co(i,2),co(i,1)};
        if ~isempty(dx)
            t(end+1,:)=dx;
        end
    end
    fis=cellfun(@(a,b,c){[a filesep b filesep c]},t(:,1),t(:,6),t(:,5));
    fis=strrep(fis,[filesep filesep],filesep);
    t2=[t(:,1) t(:,6) fis];
    
    [~,ia]=unique(t2(:,3));
    if isempty(ia); return; end
    t2=t2(ia,:);
    [pam, animal]=fileparts2(t2(:,1));
    
    q=questdlg('Delete the selected files?','Delete Files','YES','NO','NO');
    if strcmp(q,'NO'); return; end

    fprintf(['..delete files (' num2str(size(t2,1)) ' files)..']);
    for i=1:size(t2,1)
        f1=t2{i,3};
        fprintf( [ '|' animal{i} '..' ]);
        try;
            delete(f1);
        catch
            fprintf('\n');
            disp(['could not delete: ' f1]);
            
            
        end
    end
    fprintf('\n');
    fprintf('..Done!\n');
    
    pb_update([],[]);
    
    
    
end


function rd_hideSliders(e,e2)
hr=findobj(gcf,'tag','rd_hideSliders');
u=get(gcf,'userdata');

% statec=get(u.hb_sliderFiles,'visible');
if hr.Value==0
    statec='on';
else
    statec='off';
end
% if strcmp(statec,'off'); statec='on'; else; statec='off'; end
set(u.hb_sliderFiles,'visible',statec);
set(u.hb_sliderDirs,'visible',statec);
set(findobj(gcf,'tag','rd_visAllFiles'),'visible',statec);
set(findobj(gcf,'tag','rd_visAllDirs'),'visible',statec);



function keylist_show(e,e2)

a=preadfile(which('cfm.m'));
a=a.all;
ilist=[find(strcmp(a,'% __anker_keylist_on'))+1 find(strcmp(a,'% __anker_keylist_off'))-1];
uhelp(regexprep(a(ilist(1):ilist(2)), '^%','' ));

function keylist
% __anker_keylist_on
% #lk __SHORTCUTS___
% [1] cfm-window: left position + large size
% [2] cfm-window: center position + default window size
% [3] cfm-window: posisioned on left side next to ANT- or BART-window
% [4] cfm-window: full screen
% [5] cfm-window: minimize window
% __________________
% [+/-] in/decrease fontsize of axes labels
% [r]   de/select files/folders by range (rectangle ui-tool)
% [m]   toggle single-/multi-select files 
% [d]   delete file selection (remove i.e. "x"-tags)
% [s]   toggle: show/hide fileSlider & dirSlider
% __________________
% [ctrl or alt] & [left/right arrow] rotate x-labels
% [ctrl or alt] & [+/-] in/decrease fontsize of file information (tooltip/corner info)


% __anker_keylist_off


function keys(e,e2)
% e2


hf=findobj(0,'tag','cfmatrix');
u=get(gcf,'userdata');
if isempty(e2.Modifier)
    if strcmp(e2.Character,'1')
        set(gcf,'position',[0.0007    0.0728    0.6688    0.8939]); %large left
    elseif strcmp(e2.Character,'2')
        set(gcf,'position',[ 0.3056    0.4200    0.3889    0.4667]); %default
     elseif  strcmp(e2.Character,'3')    %left to ANT
         try
          h1=findobj(0,'tag','ant');
          pos1=get(h1,'position');
          pos2=[pos1(1)-pos1(3) pos1(2:end)];
          set(hf,'position',pos2);
         catch
           h1=findobj(0,'tag','bart');
          pos1=get(h1,'position');
          pos2=[pos1(1)-pos1(3) pos1(2:end)];
          set(hf,'position',pos2);  
         end
    elseif  strcmp(e2.Character,'4')
         set(gcf,'position',[ 0    0.0678    1.0000    0.9072]); %full screen
    elseif  strcmp(e2.Character,'5')
       try;  set(gcf,'WindowState', 'minimized');    end % works on R2021
           
    elseif strcmp(e2.Character,'+')
        hl=gca;
        %fs=get(hl,'fontsize');
        u.fs_label=u.fs_label+1;
        set(hl,'fontsize',u.fs_label);
        set(gcf,'userdata',u);
    elseif strcmp(e2.Character,'-')
        hl=gca;
        fs=get(hl,'fontsize');
        if fs<2; return; end
        u.fs_label=u.fs_label-1;
        set(hl,'fontsize',u.fs_label);
        set(gcf,'userdata',u);
        
        %set(hl,'fontsize',fs-1);
    elseif strcmp(e2.Character,'r')
        selectRange();
     elseif strcmp(e2.Character,'m'); %multiselect
         hb=findobj(hf,'tag','rd_multiSel');
         set(hb,'Value', ~get(hb,'Value'));
     elseif strcmp(e2.Character,'d'); %selecte selected   
         pb_delselection();
         
    elseif strcmp(e2.Character,'s')
        hr=findobj(hf,'tag','rd_hideSliders');
        set(hr,'value',~get(hr,'value'));
        rd_hideSliders();
        
    end
    
    


elseif strcmp(e2.Modifier,'control')|| strcmp(e2.Modifier,'alt')
    if strcmp(e2.Key,'rightarrow')
        set( gca, 'xTickLabelRotation', get(gca,'xTickLabelRotation')-1);
    elseif strcmp(e2.Key,'leftarrow')
        set( gca, 'xTickLabelRotation', get(gca,'xTickLabelRotation')+1);
        
        
    elseif strcmp(e2.Character,'+') || strcmp(e2.Character,'-')
        hl=[ [findall(gcf,'tag','tx_dummy') findall(gcf,'tag','tx_info')] ];
        fs=get(hl(1),'fontsize');
        if strcmp(e2.Character,'+')
            set(hl,'fontsize',fs+1);
        else
            if fs<2; return; end
            set(hl,'fontsize',fs-1);
        end
    end
end

function selectColumn() %SELECT DIRS
u=get(gcf,'userdata');
hmulti=findobj(gcf,'tag','rd_multiSel');
cc=get(gca,'CurrentPoint');
cc=cc(1,1:2);
co=ceil(cc-.5);
% -------------
%'select all files from this folder'
v=u.vinfo(:,co(1));
ifound=find(~cellfun(@isempty,v));

% some Selections allready made
isel=find(u.sel(ifound,co(:,1)));
if ~isempty(isel) %--> remove selection
    u.sel(ifound,co(:,1))=0;
else
    u.sel(ifound,co(:,1))=1;
end
% PLOT
set(gcf,'userdata',u);
clear x
[x(:,1) x(:,2)]=find(double(u.sel)==1);
delete(findobj(gcf,'tag','sel'));
if ~isempty(x)
    hold on
    hp=plot(x(:,2),x(:,1),'x','color','k','tag','sel','linewidth',2);
    setcontextmenu();
end



% cp=[ repmat(co(:,1),[ length(ifound)  1]) ifound(:)  ];
% hsel=findobj(gcf,'tag','sel');
% iSameExist=[];
% if ~isempty(hsel)
%     selpos=[[hsel.XData]' [hsel.YData]'];
%     for i=1:length(ifound)
%         is=find(selpos(:,1)==cp(i,1) & selpos(:,2)==cp(i,2));
%         iSameExist=[iSameExist; is(:)];
%     end
% end
% if isempty(iSameExist)
%     for i=1:length(ifound) %PLOT
%         hold on;
%         hp=plot(cp(i,1),cp(i,2),'x','color','k','tag','sel','linewidth',2);
%         setcontextmenu();
%     end
% else
%     if  ~isempty(hsel)%  DELETE FILES
%         for i=1:length(iSameExist)
%             delete(hsel(iSameExist));
%         end
%     end
% end



function selectRow() %files
u=get(gcf,'userdata');
hmulti=findobj(gcf,'tag','rd_multiSel');
cc=get(gca,'CurrentPoint');
cc=cc(1,1:2);
co=ceil(cc-.5);
% -------------
v=u.vinfo(co(2),:);
ifound=find(~cellfun(@isempty,v));
isel=find(u.sel(co(:,2),ifound));
if ~isempty(isel) %--> remove selection
    u.sel(co(2),ifound)=0;
else
    u.sel(co(2),ifound)=1;
end
set(gcf,'userdata',u);
% PLOT
clear x
[x(:,1) x(:,2)]=find(double(u.sel)==1);
delete(findobj(gcf,'tag','sel'));
if ~isempty(x)
    hold on
    hp=plot(x(:,2),x(:,1),'x','color','k','tag','sel','linewidth',2);
    setcontextmenu();
end









% 
% 
% cp=[ ifound(:) repmat(co(:,2),[ length(ifound)  1]) ];
% hsel=findobj(gcf,'tag','sel');
% iSameExist=[];
% if ~isempty(hsel)
%     selpos=[[hsel.XData]' [hsel.YData]'];
%     for i=1:length(ifound)
%         is=find(selpos(:,1)==cp(i,1) & selpos(:,2)==cp(i,2));
%         iSameExist=[iSameExist; is(:)];
%     end
% end
% if isempty(iSameExist)
%     for i=1:length(ifound) %PLOT
%         hold on;
%         hp=plot(cp(i,1),cp(i,2),'x','color','k','tag','sel','linewidth',2);
%         setcontextmenu();
%     end
% else
%     if  ~isempty(hsel)%  DELETE FILES
%         for i=1:length(iSameExist)
%             delete(hsel(iSameExist));
%         end
%     end
% end





%% ===============================================
function selectRange()
%% ===============================================
set(gcf,'WindowButtonMotionFcn',[]);
set(gcf,'WindowButtonDownFcn',[]);

if exist('drawrectangle.m')==2
    roi = drawrectangle(gca,'StripeColor','r','tag','selectRange');
    pos=get(roi,'position');
    delete(findobj(gcf,'tag','selectRange'));
else
    roi=imrect;
    pos=   roi.getPosition;
    roi.delete;
end
drawnow;
ri=ceil([pos(1) pos(1)+pos(3) ]-.5);
do=ceil([pos(2) pos(2)+pos(4) ]-.5);
u=get(gcf,'userdata');
%% ===============================================
% zo=zeros(size(u.v1));
% zo(do(1):do(2),ri(1):ri(2)   )=1;
cp=allcomb(ri(1):ri(2),do(1):do(2) );
idel=[];
for i=1:size(cp,1)
    if isempty(u.vinfo{cp(i,2),cp(i,1)})
        idel(end+1,1)=i;
    end
end
cp(idel,:)=[];
% -------------
ind = sub2ind(size(u.sel), cp(:,2),cp(:,1));
sel=u.sel(:);
if sum(sel(ind))==0
    sel(ind)=1;
else
    sel(ind)=0;
end
u.sel=reshape(sel,size(u.sel));
set(gcf,'userdata',u);
% PLOT
clear x
[x(:,1) x(:,2)]=find(double(u.sel)==1);
delete(findobj(gcf,'tag','sel'));
if ~isempty(x)
    hold on
    hp=plot(x(:,2),x(:,1),'x','color','k','tag','sel','linewidth',2);
    setcontextmenu();
end
set(gcf,'WindowButtonMotionFcn',@motion);
set(gcf,'WindowButtonDownFcn',@mouseclick);


function selectFilesFromDirs()
u=get(gcf,'userdata');
%% ===============================================
% set(findobj(0,'tag','cfmatrix'),'visible','off');
set(gcf,'WindowButtonMotionFcn',[]);
set(gcf,'WindowButtonDownFcn',[]);

drawnow
% u.ht3=
% {'path: '          }
% {'animal: '        }
% {'slice: '         }
% {'slice-assigned: '}
% {'file: '          }
% {'subdir: '        }
% {'size(MB): '      }
% {'date: '          }
t=[u.t3(:,2)  u.t3(:,6) u.t3(:,5)];
t(:,4)=cellfun(@(a,b){[fullfile(a, [b])]},t(:,2),t(:,3));
mdirs=unique(t(:,1));
unifile=unique(t(:,4));




id=selector2(mdirs ,{'filename (fileName+subDir)'},'iswait',1,'title','select DIRS & FILES: select DIRS');%,'iswait',1,'position',[0.0778  0.0772  0.3510  0.8644]);
if isempty(mdirs); return; end
is=find(ismember(t(:,1),mdirs(id)));
t2=t(is,:);
if isempty(t2); return; end

id=selector2(unifile ,{'filename (fileName+subDir)'},'iswait',1,'title','select DIRS & FILES: select DIRS');%,'iswait',1,'position',[0.0778  0.0772  0.3510  0.8644]);
if isempty(unifile); return; end
is=find(ismember(t2(:,4),unifile(id)));
t3=t2(is,:);
if isempty(t3); return; end

drawnow;
set(findobj(0,'tag','cfmatrix'),'visible','on');

%% =====find in vinfo3==========================================
v=u.vinfo;
wishFiles=cellfun(@(a,b,c){[fullfile(a,b,c)]},t3(:,1),t3(:,2),t3(:,3));
sel=zeros(size(u.sel));
for i=1:size(v,1)
    for j=1:size(v,2)
        v2=v{i,j}';
        if ~isempty(v2)
            v2file=fullfile(v2{2},v2{6},v2{5});
            if ~isempty(find(ismember(wishFiles,v2file)));
                %[i j]
                sel(i,j)=1;
            end
        end
    end
end
sel=double((double(u.sel)+sel)>0);
u.sel=sel;
% ---------
set(gcf,'userdata',u);
% PLOT
clear x
[x(:,1) x(:,2)]=find(double(u.sel)==1);
delete(findobj(gcf,'tag','sel'));
if ~isempty(x)
    hold on
    hp=plot(x(:,2),x(:,1),'x','color','k','tag','sel','linewidth',2);
    setcontextmenu();
end
set(gcf,'WindowButtonMotionFcn',@motion);
set(gcf,'WindowButtonDownFcn',@mouseclick);

% function cfm_error
% hf=findobj(0,'tag','cfmatrix');
% set(hf,'visible','on');

%% ===============================================
function openfile(task)
u=get(gcf,'userdata');
if strcmp(task,'single')
    drawpoint();% because of un/selection after normal-to-open-click
    
    
    cc=get(gca,'CurrentPoint');
    cc=cc(1,1:2);
    co=ceil(cc-.5);
    
    if co(1)>length(u.mdirslice) || co(2)>length(u.unifiles) ||...%'outside'
            co(1)<1 || co(2)<1
        return
    end
    cp=co;
elseif strcmp(task,'multi')
    u=get(gcf,'userdata');
    
    cp=getSelection();
    %% ===============================MANY FILES TO OPEN ================
    %cp=rand(101,1);
    if size(cp,1)>5
        q = questdlg({['Do you really want to open/view ' num2str(size(cp,1))  ' Files?' ],''}, ...
            'VIEW/OPEN FILES', ...
            'YES','NO','NO');
        if strcmp(q,'NO')==1;  return; end
    end
    %% ===============================================
    
    
end

%% ===============================================
if isempty(cp); return; end
for i=1:size(cp,1)
    co=cp(i,:);
    
    t=u.vinfo{co(2),co(1)}';
    if ~isempty(t)
        f1= fullfile(t{1},t{6},t{5});
        [~,~,fmt]=fileparts(f1);
        % image-data
        %         imfinfo(f1).Format;
        imfmt={'.jpg','.png','.gif'};
        txfmt={'.txt','.csv' '.dat' '.log'};
        explorerfmt={'.doc','.docx' '.xlsx' '.xls' '.ppt' '.pptx'};
        
        %imfmt={'.jpg','.png','.gif','.tif'};
        if  any(ismember(explorerfmt,fmt))
            if ispc
                system(['start ' f1 ]);
            elseif ismac
                system(['open ' f1 ]);
                %disp([msg ' [' name ']: <a href="matlab: explorerpreselect(''' im1 ''');">' 'Explorer' '</a>' ...
                %    ' or <a href="matlab: system(''open ' im1 ''');">' 'open' '</a>' ' '  msg2  ]);
            elseif isunix
                system(['xdg-open ' f1 ]);
                % disp([msg ' [' name ']: <a href="matlab: explorerpreselect(''' im1 ''');">' 'Explorer' '</a>' ...
                %     ' or <a href="matlab: system(''xdg-open ' im1 ''');">' 'open' '</a>'  ' '  msg2 ]);
                
                
            end
            
        elseif strcmp(fmt,'.nii')
            rmricron([],f1);
            
        elseif any(ismember(imfmt,fmt))
            %gif=imread(f1, 'Frames', 'all');
            %fg; implay(gif,1);
            web(f1,'-new');
        elseif any(ismember(txfmt,fmt))
            %gif=imread(f1, 'Frames', 'all');
            %fg; implay(gif,1);
            web(f1,'-new');
        elseif strcmp(fmt,'.tif')
            cprintf([1 0 1],'..reading/sparse-reading TIF..(wait!!!)...');
            in=imfinfo(f1);
            si=[in.Height in.Width];
            if max(si)>2000
                stp=round(si/1000);
                r2=imread(f1,'PixelRegion',{[1 stp(1) si(1)],[1 stp(2) si(2)]} );
            else
                r2=imread(f1);
            end
            fg; imagesc(r2);
            ti=title({f1; ['orig-size: ' sprintf('[%d x %d]',si(1),si(2))]});
            set(ti,'fontsize',6);
            cprintf([0 .7 0],'..Done!\n');
            
        elseif strcmp(fmt,'.mat')
            in=matfile(f1);
            vars=whos('-file',f1);
            varnames= {vars(:).name};
            iv=find(strcmp(varnames,'v'));
            if ~isempty(iv)%BART-mat
                if strcmp(vars(iv).class,'struct')
                    disp(in);
                else
                    si= vars(iv).size;
                    cprintf([1 0 1],'..reading BARTmat..(wait!!!)...');
                    tic;r2=load(f1);toc;
                    if max(max(si))>5000
                        im=imresize(r2.v,[1000 1000]);
                        fg; imagesc(im);
                    else
                        fg; imagesc(r2);
                    end
                    ti=title({f1; ['orig-size: ' sprintf('[%d x %d]',si(1),si(2))]});
                    set(ti,'fontsize',6);
                    cprintf([0 .7 0],'..Done!\n');
                end
            else
                disp(in);
            end
        end
        
        
    end
end

%% ===============================================
function mouseclick(e,e2)

mtype = get(gcf,'selectiontype');


% return
if strcmp(mtype,'alt') %normal/alt
    return
elseif strcmp(mtype,'extend')==1 %
    selectRange();
    return
elseif strcmp(mtype,'open')==1 %
    openfile('single');
    return
end


% return



u=get(gcf,'userdata');
hmulti=findobj(gcf,'tag','rd_multiSel');

cc=get(gca,'CurrentPoint');
cc=cc(1,1:2);
co=ceil(cc-.5);

%----------outside array-----------------
if co(1)>length(u.mdirslice) || co(2)>length(u.unifiles) ||...%'outside'
        co(1)<1 || co(2)<1
    
    if co(1)<length(u.mdirslice) && co(2)>=1 && co(2)<=length(u.unifiles) %FILES
        selectRow();
      
    end
    %-----------------
    if co(2)>length(u.unifiles) && co(1)>=1 && co(1)<=length(u.mdirslice) %FOLDERS
        selectColumn();
    end
    
    
    return
end

drawpoint();


function drawpoint()
u=get(gcf,'userdata');



hmulti=findobj(gcf,'tag','rd_multiSel');
cc=get(gca,'CurrentPoint');
cc=cc(1,1:2);
co=ceil(cc-.5);
if co(1)>length(u.mdirslice) || co(2)>length(u.unifiles) ||...%'outside'
        co(1)<1 || co(2)<1
    return
end

prevValue=u.sel(co(2),co(1));
if hmulti.Value==0
   u.sel=zeros(size(u.sel)) ;
end
   % ---- IF file does not exist ---> return ---------------
if isempty(   u.vinfo{co(2),co(1)}  ); return; end
if prevValue==1
    u.sel(co(2),co(1))=0;
    %'off'
else
    u.sel(co(2),co(1))=1;
    %'on'
end
    
% u.sel(co(2),co(1))=~u.sel(co(2),co(1));
% u.sel(co(2),co(1))
set(gcf,'userdata',u);

% [x(:,1) x(:,2)]=find(u.sel~=0)
clear x;
[x(:,1) x(:,2)]=find(double(u.sel)==1);
delete(findobj(gcf,'tag','sel'));
if ~isempty(x)
    hold on;
    hp=plot(x(:,2),x(:,1),'x','color','k','tag','sel','linewidth',2);
    setcontextmenu();
end



if 0
    % ---- IF EXIST at same POSTION ---> return ---------------
    hsel=findobj(gcf,'tag','sel');
    if ~isempty(hsel)
        selpos=[[hsel.XData]' [hsel.YData]'];
        iSameExist=find(selpos(:,1)==co(1) & selpos(:,2)==co(2));
        delete(hsel(iSameExist))
        if ~isempty(iSameExist); return; end
    end
    
    %----------------%delete all other selections-------
    if hmulti.Value==0
        delete(findobj(gcf,'tag','sel'));
    end
    
    
    % ---- IF file does not exist ---> return ---------------
    if isempty(u.vinfo{co(2),co(1)}); return; end
    
    % ------- plot point ----
    hold on;
    hp=plot(co(1),co(2),'x','color','k','tag','sel','linewidth',2);
    setcontextmenu();
end




function motion(e,e2)
%% ===============================================
hf=findobj(0,'tag','cfmatrix');
ax=findobj(hf,'type','axes');
axes(ax);
% 'www'

cc=get(ax,'CurrentPoint');
downadj=cc(1,2)-.5;
down= ceil(downadj);

rightadj=cc(1,1)-.5;
right= ceil(rightadj);
co=[right down];

u=get(hf,'userdata');
try
    
    %     try
    %         if co(2)>length(u.unifiles)
    %             fileStr='';
    %         else
    %             fileStr=regexprep(u.aux{co(2),1},'_', '\\_') ;
    %         end
    %     end
    try
        tb=u.vinfo{co(2),co(1)}';
        if isempty(tb)
            title('');
            set(findobj(hf,'tag','tx_info'),'visible','off');
            return
            
        end
        
        if co(1)<1
            sliceStr='';
        else
            sliceStr=u.mdirslice2{co(1)};
            hTT=findobj(hf,'tag','pop_TT');
            if hTT.Value==2  %;%get(findobj(hf,'tag','rd_info'),'value')==1
                % 'this'
                si=size(char(u.ht3(:)),2);
                %tb=u.vinfo{co(2),co(1)}';
                ts=cellfun(@(a,b){[a repmat(' ',[1 si-length(a)]) num2str(b)]},u.ht3(:),tb);
                ts([1 4 6],:)=[];
                %disp(char(tb));
                set(findobj(hf,'tag','tx_info'),'string',ts,'visible','on');
            elseif hTT.Value==3 %;get(findobj(hf,'tag','rd_tt'),'value')==1
                si=size(char(u.ht3(:)),2);
                %tb=u.vinfo{co(2),co(1)}';
                ts=cellfun(@(a,b){[a repmat(' ',[1 si-length(a)]) num2str(b)]},u.ht3(:),tb);
                ts([1 4 6],:)=[];
                %disp(char(tb));
                ht  =findobj(hf,'tag','tx_info');
                hdum=findobj(hf,'tag','tx_dummy');
                set(hdum,'string',ts);
                posext=get(hdum,'Extent');
                
                set(ht,'string',ts);
                postx=get(ht,'position');
                mp=get(hf,'CurrentPoint');
                %set(ht,'position',[ mp(1:2)  postx(3:4)],'visible','on','backgroundcolor',[0.9922    1.0000    0.8706]);
                if co(1)>(length(u.mdirslice)/2) % jump Tooltip to right
                    set(ht,'position',[ mp(1)-posext(3)  mp(2)  posext(3:4) ],'visible','on','backgroundcolor',[0.9922    1.0000    0.8706]);
                    
                else
                    set(ht,'position',[ mp(1:2)  posext(3:4) ],'visible','on','backgroundcolor',[0.9922    1.0000    0.8706]);
                end
                
                %[ mp(1:2)  postx(3:4)]
            end
        end
        
        
        
        fileStr=regexprep(tb{5},'_', '\\_') ;
        ti=title({sliceStr, fileStr },'fontsize',10,'fontweight','bold');
        
        set(ti,'units','norm');
        posti=get(ti,'position');
        set(ti,'position',[ 0.4 posti(2:end)]);
        drawnow;
        axpos=get(ax,'position');
    catch
        ht=findobj(hf,'tag','tx_info');
        set(ht,'string','','position',ht.UserData,'backgroundcolor','w');
    end
    
    
    %%-------- XTICKS-resize
    if co(1)>=1 && co(1)<=length(u.mdirslice)
        xtl=get(ax,'XTickLabel');
        %htmls='\color{red}';
        %htmls='\fontsize{8}';
        %xtl=strrep(xtl,htmls,'');
        %xtl{co(1)} = [htmls xtl{co(1)}];
        xtl=regexprep(xtl,['\\fontsize\{\d+}'],'');
        xtl{co(1)} = ['\fontsize{' num2str(get(ax,'fontsize')+3) '}' xtl{co(1)}];
        set(gca,'XTickLabel',xtl);
        
    end
    %%-------- YTICKS-resize
    if co(2)>=1 && co(2)<=length(u.unifiles)
        ytl=get(ax,'YTickLabel');
        %htmls='\color{red}';
        %ytl=strrep(ytl,htmls,'');htmls='\fontsize{8}';
        ytl=regexprep(ytl,['\\fontsize\{\d+}'],'');
        
        ytl{co(2)} = ['\fontsize{' num2str(get(ax,'fontsize')+3) '}' ytl{co(2)}];
        set(ax,'yTickLabel',ytl);
        
    end
    set(ax,'position',axpos);
    
    
    
catch
    %     title('');
end
% drawnow;
%% ===============================================


function dragbtn_ini(e,e2)
% sx=get(gcf,'userdata');

%% dragg
handicon=[...
    129	129	129	129	129	129	129	0	0	129	129	129	129	129	129	129
    129	129	129	0	0	129	0	215	215	0	0	0	129	129	129	129
    129	129	0	215	215	0	0	215	215	0	215	215	0	129	129	129
    129	129	0	215	215	0	0	215	215	0	215	215	0	129	0	129
    129	129	129	0	215	215	0	215	215	0	215	215	0	0	215	0
    129	129	129	0	215	215	0	215	215	0	215	215	0	215	215	0
    129	0	0	129	0	215	215	215	215	215	215	215	0	215	215	0
    0	215	215	0	0	215	215	215	215	215	215	215	215	215	215	0
    0	215	215	215	0	215	215	215	215	215	215	215	215	215	0	129
    129	0	215	215	215	215	215	215	215	215	215	215	215	215	0	129
    129	129	0	215	215	215	215	215	215	215	215	215	215	215	0	129
    129	129	0	215	215	215	215	215	215	215	215	215	215	0	129	129
    129	129	129	0	215	215	215	215	215	215	215	215	215	0	129	129
    129	129	129	129	0	215	215	215	215	215	215	215	0	129	129	129
    129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129
    129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129];

% handicon=[[255 255 255 255 255 255 255 182 182 255 255 255 255 255 255 255;255 255 255 255 255 255 197 34 34 197 255 255 255 255 255 255;255 255 255 255 255 213 78 161 161 78 213 255 255 255 255 255;255 255 255 255 255 152 238 171 171 238 153 255 255 255 255 255;255 255 255 255 255 255 255 171 171 255 255 255 255 255 255 255;255 255 213 152 255 255 255 171 171 255 255 255 152 213 255 255;255 197 78 238 255 255 255 171 171 255 255 255 238 78 197 255;182 34 161 170 170 170 170 114 114 170 170 170 170 161 34 182;183 34 162 171 171 171 171 114 114 171 171 171 171 162 34 183;255 198 78 238 255 255 255 171 171 255 255 255 238 77 198 255;255 255 214 153 255 255 255 171 171 255 255 255 153 214 255 255;255 255 255 255 255 255 255 171 171 255 255 255 255 255 255 255;255 255 255 255 255 152 238 171 171 238 152 255 255 255 255 255;255 255 255 255 255 214 78 161 161 78 214 255 255 255 255 255;255 255 255 255 255 255 198 34 34 198 255 255 255 255 255 255;255 255 255 255 255 255 255 183 183 255 255 255 255 255 255 255]];

handicon(handicon==handicon(1,1))=255;
% handicon=round(imresize(handicon,[10 10],'method','bilinear'));
if size(handicon,3)==1; handicon=repmat(handicon,[1 1 3]); end
handicon=double(handicon)/255;

delete(findobj(gcf,'tag','drag'));
h33=uicontrol('style','pushbutton','cdata',handicon,'backgroundcolor','w');
set(h33,'backgroundcolor','w');%,'callback',@slid_thresh)
set(h33,'units','pixels','position',[100 100 16 16]);
set(h33,'units','norm')

ax2=gca;%findobj(gcf,'tag','ax2');
axpos2=get(ax2,'position');

% ax3=findobj(gcf,'tag','ax3');
% axpos3=get(ax3,'position');

sx.dragicongap=0;

poshand=get(h33,'position');
set(h33,'position',[axpos2(1)-poshand(3) axpos2(2)-poshand(4) poshand(3:4)  ]);
set(h33,'string','','tooltipstring','drag hand icon to resize axes','tag','drag');
je = findjobj(h33); % hTable is the handle to the uitable object
set(je,'MouseDraggedCallback',@drag_icon  );

% c = uicontextmenu;
% h33.UIContextMenu = c;
% m1 = uimenu(c,'Label','dragIcon: distance to axes','Callback',{@dragIcon_context,'distance'});
% v.hdrag.UIContextMenu = c;



function drag_icon(e,e2)

set(gcf,'WindowButtonMotionFcn',[]);
set(gcf,'WindowButtonDownFcn',[]);


u=get(gcf,'userdata');
sx.dragicongap=0;
hf1=gcf;%findobj(0,'tag','dtifig1');
hp=findobj(hf1,'tag','drag');

cp=get(gcf,'CurrentPoint');
p1=get(hp,'position');
p2=[cp(1)-p1(3) cp(2)-p1(4) p1(3:4)];
set(hp,'position',p2);


p3=get(gca,'position');
p4=[cp(1) cp(2) p3(3:4)+(p3(1:2)-cp(1:2) )];
set(gca,'position',p4);

set(gcf,'WindowButtonMotionFcn',@motion);
set(gcf,'WindowButtonDownFcn',@mouseclick);
drawnow;


%% ===============================================
function importDir2DIR()
%% ===============================================
u=get(gcf,'userdata');

%  q = questdlg({'IMPORT DIR2DIR';...
%      ['use Main-' ],''}, ...
%             'VIEW/OPEN FILES', ...
%             'YES','NO','NO');
% if strcmp(q,'NO')==1;  return; end

ix=find(~cellfun(@isempty,u.vinfo(:)));

patar    =unique(cellfun(@(a){[a{1}]},u.vinfo(ix)));
patarmain=fileparts(patar{1});
[tpa tmdir]=fileparts2(patar);
%% --------------------------
msg='import-DIR2DIR: select animal-dir(s) from source to import';
[t,sts] = spm_select(inf,'dir',msg,'',patarmain,'[^.]');
if isempty(t); return; end
pasource=cellstr(t);
%% ===============================================
[spa smdir]=fileparts2(pasource);
iexist=find(ismember(tmdir,smdir)); % MDIR exist
if isempty(iexist)
    msgbox('NO corresponding animal-dirs (matching source & target mdir names) found');
    return
end
%obtain files from source
t={};
for i=1:length(pasource)
    [fi1] = spm_select('FPListRec',pasource{i},'.*');
    if ~isempty(fi1)
        fi1=cellstr(fi1);
        path2=fileparts2(fi1);
        
        subdirfile=strrep(fi1,[pasource{i}],'');
        %subdir    =strrep(fileparts2(subdirfile),filesep,'');
        subdir    =cellfun(@(a){[fullfile(smdir{i}, a   )]},fileparts2(subdirfile));
        t=[t;... 
            % FPfileName subdir  subdir+filename     animalName
            [fi1          subdir      subdirfile    repmat(smdir(i),[length(fi1) 1]) ];...
            ];
    end
end
ht2={'sourceFPfile' 'sourceFP' 'sourceSubfileName' 'mdir'};
%% ==========[file selection ]=====================================
unifile=unique(t(:,3));
if isempty(unifile); return; end
id=selector2(unifile ,{'filename (fileName+subDir)'},'title','import-DIR2DIR: select files to import');%,'iswait',1,'position',[0.0778  0.0772  0.3510  0.8644]);
if isempty(unifile); return; end

is=find(ismember(t(:,3),unifile(id)));
t2=t(is,:);
if isempty(t2); return; end
%% =================copy files ==============================
warning off;
cprintf([1 0 1],'..IMPORT DIR2DIR..(wait!!!)...\n');
thisanimal='';
for i=1:size(t2,1)
   
    w=t2(i,:)';
    
    if strcmp(w{4},thisanimal)==0
     disp(['  ..import data of [' w{4} ']...']);
    end
    thisanimal=w{4};
     
    F1=w{1};
    F2=fullfile(patarmain,w{4},w{3} );
    thisDir=fullfile( patarmain,  w{2});
    if exist(thisDir)~=7
     mkdir(thisDir);
    end
   copyfile(F1,F2,'f')    ;
end
cprintf([0 .7 0],'..Done!\n');
% showinfo2('bla',Fout);
pb_update([],[]);

function renameFiles(task)
%% ===============================================



u=get(gcf,'userdata');
s=getSlectedFiles();
%% ===============================================
fis=cellfun(@(a,b,c){[fullfile(a, b,c )]},s(:,1),s(:,6),s(:,3));
unifiles=unique(cellfun(@(a,b){[fullfile(a, b)]},s(:,6),s(:,3)));
% if length(unifiles)>1
%    msgbox({'files with different File-Names where selected'...
%        '...Please select files with identical names '});
%    return
% end
% unifiles{1}='_herr_man.nii'
%% ===============================================


    
if strcmp(task,'renameFiles')
    userootfile=1;
     tit='rename Files:';
    head=['\color{red}\bf RENAME SELECTED FILES\color{black}\rm' char(10)  ]; 
else % copyNrename
    userootfile=0;
    tit='copy & rename Files:';
    head=['\color{blue}\bf COPY AND RENAME SELECTED FILES\color{black}\rm' ...
        char(10) '\color{red}\rm - choose ONE option only \color{black}\rm' char(10)] ;
end




if length(unifiles)==1
    %% ===============================================
    
    name=[tit '"' unifiles{1} '"'];
    prompt={...
        [head char(10)    ...
        ' - do not enter file extension, the original file extension is used' char(10) char(10) ...
        'Enter a new fileName:'  ]
        ['Enter PREFIX (add a prefix to existing fileName: ' char(10) ' -if needed use underscore,  E.g.: "prefix\_" + OldFilename + FileExtension'  ]
        ['Enter SUFFIX (add a suffix to existing fileName: ' char(10) ' -if needed use underscore,  E.g.: OldFilename+"\_suffix" + FileExtension'  ]
        };
    numlines=[1 100];
    defaultanswer={''  '' ''};
    options.Resize='on';
    options.WindowStyle='modal';
    options.Interpreter='tex';
    if userootfile==1
        prompt       =prompt(1);
        defaultanswer=defaultanswer(1);
    end
    q=inputdlg(prompt,name,numlines,defaultanswer,options);
    %% ===============================================
    
    if isempty(q); return; end
    isel=find(~cellfun(@isempty,q));
    if isempty(isel) || length(isel)>1;
        warndlg('ONly one selecion allows...terminated');
        return
    end
else
    %% =====[ more than 1 different filename selected]==========================================
    unifiles_str=cellfun(@(a){[ 'old name: "'  a  '"' ]} ,unifiles(2:end));
     name=[tit ];
    prompt0={...
        [head char(10)    ...
        ' - do not enter file extension, the original file extension is used' char(10) ...
        'Enter a new fileName:'  char(10) ...
        'old name: "'  unifiles{1}  '"']};
    prompt=[prompt0; unifiles_str(:) ];
    numlines=[1 100];
    defaultanswer=unifiles(:)';
    options.Resize='on';
    options.WindowStyle='modal';
    options.Interpreter='tex';
    %if userootfile==1
%         prompt       =prompt(1);
%         defaultanswer=defaultanswer(1);
%     end
    q=inputdlg(prompt,name,numlines,defaultanswer,options);
    if isempty(strjoin(q,''))
       warndlg('no new filename obtained...terminated');
        return 
    end
    
    
    %% ===============================================
    
end
%% ===============================================
[pa nameold ext] =fileparts2(fis);
if length(unifiles)==1
    if isel==1
        [~,name]=fileparts(q{isel});
        fis2=cellfun(@(a,b){[fullfile(a, [name b])]},pa,ext);
    elseif isel==2
        pref=q{isel};
        fis2=cellfun(@(a,b,c){[fullfile(a, [pref   b c])]},pa,nameold,ext);
    elseif isel==3
        suff=q{isel};
        fis2=cellfun(@(a,b,c){[fullfile(a, [   b suff c])]},pa,nameold,ext);
    end
else % more than 1 files changed
    %% ===============================================
    
    nameorig=    cellfun(@(a,b){[a b]} ,nameold,ext );
    namenew =    q(:);
    fis2={};
    for i=1:length(unifiles)
        ix=find(strcmp(nameorig,unifiles{i}));
        [~,namenewshort,~]=fileparts(namenew{i});
        if ~isempty(namenewshort)
        dum=cellfun(@(a,b){[fullfile(a, [namenewshort b])]},pa(ix),ext(ix));
        fis2(ix,1)=dum;
        end
    end
    % remove file-from-list which have no new specified filename
    
    
    %% ===============================================
    idel=find(cellfun('isempty',fis2));
    fis2(idel,:)=[];
    fis(idel,:) =[];
    
end

%% ===============================================

if userootfile==1
    cprintf([1 0 1],'..renaming original files..(wait!!!)...');
    movefilem(fis,fis2);
else
    cprintf([1 0 1],'..copyNrename files..(wait!!!)...');
    copyfilem(fis,fis2);
    
end
cprintf([0 .7 0],'..Done!\n');
pb_update([],[]);
%% ===============================================
function pb_help(e,e2)
uhelp([mfilename '.m']);

