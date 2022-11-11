%% import files or folder content from outside via folder-to-folder-correspondence
%
% 1. select the external folders (to copy files or content from)
% 2. assign directory-directory correspondence (i..e external dirs <--> ANTx animal-dirs)  via GUI
% 3. specify files to import or leave empty to import entire conten


function ximportdir2dir_new(showgui,x,mdirs)


%———————————————————————————————————————————————
%%   example
%———————————————————————————————————————————————
if 0
    %% example
    %============================================
    % BATCH:        [ximportdir2dir.m]
    % descr:  import files from outerdir to mouse-dir via mouse-dir-name-correspondence
    %============================================
    z.importIMG={ '2_T2_ax_mousebrain_1.nii'
        'MSME-T2-map_20slices_1.nii'
        'MSME-T2-map_20slicesmodified_1.nii'
        'nan_2.nii'
        'nan_3.nii' };
    ximportdir2dir(0,z)
    
    
end


global an
prefdir=fileparts(an.datpath);


%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                           ;    x=[]                     ;end
% if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end

% if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ; 
    x=[]          ;
end 

%———————————————————————————————————————————————
%%   ant-animal-dirs 
%———————————————————————————————————————————————
isExtPath=0; % external path
if exist('mdirs')==0      || isempty(mdirs)      ;   
    antcb('update')
    global an;
    pa=antcb('getallsubjects')  ;
    padat=an.datpath; %backup if dat-folde ris empty
else
    pa=cellstr(mdirs);
    isExtPath=1;
end


%———————————————————————————————————————————————
%%   get files to import
%———————————————————————————————————————————————
%     msg={'Folders With Files TO IMPORT'
%         'select those mouse-folder which contain files to import' 
%         ''};
msg2='select external folders, to import files or entire content of these folders';
disp(msg2); %MAC issue

%     [maskfi,sts] = cfg_getfile2(inf,'image',msg,[],prefdir,'img');
%[pa2imp,sts] = cfg_getfile2(inf,'dir',msg,[],prefdir,'.*');
[pa2imp,sts] = spm_select(inf,'dir',msg2,[],prefdir);
pa2imp=cellstr(pa2imp);
if isempty(char(pa2imp)); return ; end
pa2imp=regexprep(pa2imp,[ '\' filesep '$'],''); %remove trailing filesep

%%check whether first 2 dirs are upper-root-dirs
deldir(1)=sum(cell2mat(strfind(pa2imp,pa2imp{1})))>1;
try;deldir(2)=sum(cell2mat(strfind(pa2imp,pa2imp{2})))>1;end
pa2imp(find(deldir==1))=[];
       

% ==============================================
%%   get list of files to import
% ===============================================

fi2={};
for i=1:length(pa2imp)
    [files,~] = spm_select('FPListRec',pa2imp{i},['.*.*$']);
    if ischar(files); files=cellstr(files);   end;
    fis=strrep(files,[pa2imp{i} filesep],'');
    fi2=[fi2; fis];
end
li=unique(fi2);
lis=sortrows([li lower(li)],2); %sort ignoring Casesensitivity
li=li(:,1);
%lih={'files to import'};

%% get additional info from first PATH
ad=repmat({'-'},[size(li,1) 1]);
for i=1:size(li,1)
    [pax fix ext]=fileparts(li{i});
    ad(i,:)={ext};
    %         end
end
%
li =[li ad];
hli={'files-to-import' 'extention'};

% ==============================================
%%   assign folders
% ===============================================
[  indir_root  indir ]=fileparts2(pa2imp);
if ~isempty(pa)
    [ outdir_root outdir ]=fileparts2(pa);
else
    % dat-folder is empty ....create new dir
    outdir_root=padat;
    outdir     ={''};
end

o=gui_dir2dir(indir,outdir,'ndirs',5,'matchtype',1,'wait',1,...
    'figtitle','import: dir2dir-correspondence');

if isempty(o); disp('..no dir-to-dir corresponce assigned...abort');return ;end

% ==============================================
%%   
% ===============================================
%===========================================
%%   %% test SOME INPUT
%===========================================


%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
%% fileList
if 0
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
end


%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...
    'files'      {''}   'files to import, if empty import entire content of folder'  {@selector2,li,hli,'out',1,'selection','multi','position','auto','info','select files'}
    };


p=paramadd(p,x);%add/replace parameter
if showgui==1
    %hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[0.2687    0.3656    0.4625    0.2233],...
        'title',['import files [' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end




% ==============================================
%%   BATCH
% ===============================================
try
    isDesktop=usejava('desktop');
    % xmakebatch(z,p, mfilename,isDesktop)
    if isExtPath==0
        xmakebatch(z,p, mfilename,[ mfilename '(' num2str(isDesktop) ',z);' ]);
    else
        xmakebatch(z,p, mfilename,[ mfilename '(' num2str(isDesktop) ',z,mdirs);' ],pa);
    end
end

% ==============================================
%%   process
% ===============================================

z.indir_root  =indir_root;
z.outdir_root =outdir_root;
z.dirassign=o;
process(z);


function process(z)

%% ===============================================
indir_root=z.indir_root{1};
if ischar(z.outdir_root)
    outdir_root=z.outdir_root;
else
    outdir_root=z.outdir_root{1};
end


indir =stradd(z.dirassign(:,1),[ indir_root  filesep],1);
outdir=stradd(z.dirassign(:,2),[ outdir_root filesep],1);

% ___copy entire folder ____________________________
if isempty(char(z.files))
    for i=1:length(indir)
         S1=fullfile( indir{i});
         T1=fullfile(outdir{i});
         copyfile(S1,T1,'f');
         showinfo2('copied entire folder-content to ',T1,[],1,[' ... source: "' S1 '"']);
    end
else
    % ___copy specific files ____________________________
    for i=1:length(indir) 
      FS1=  cellfun(@(a){[  indir{i}  filesep a ]} ,z.files );
      FT1=  cellfun(@(a){[  outdir{i} filesep a ]} ,z.files );
        for j=1:length(FS1)
            if exist(FS1{j})==2
                subdir=fileparts(FT1{j});
                if exist(subdir)~=7
                mkdir(subdir); %make subdir if not exists
                end
                copyfile(FS1{j},FT1{j},'f'); 
            end
         end    
            showinfo2('copied specific files to ',outdir{i},[],1,[' ... source: "' indir{i}  '"']);  
    end
end










