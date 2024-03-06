%% import files or folder content from outside via folder-to-folder-correspondence
%
% 1. select the external folders (to copy files or content from)
% 2. assign directory-directory correspondence (i..e external dirs <--> ANTx animal-dirs)  via GUI
% 3. specify files to import or leave empty to import entire content

% ______________________________________________________________________________________________
%% #ky RUN-def:
% ximportdir2dir(showgui,x)
% with inputs:
% showgui: (optional)  :  0/1   :no gui/open gui
% x      : (optional)  : struct with one/more specified parameters from above:
%
% ximportdir2dir(1);     % ... open PARAMETER_GUI with defaults
% ximportdir2dir(0,z);   % ...run without GUI with specified parametes (z-struct)
% ximportdir2dir(1,z);   % ...run with opening GUI with specified parametes (z-struct)
% ______________________________________________________________________________________________
%% #ky EXAMPLES
%% ===============================================
%% import files from subfolders directly into animal-dirs (no subfolders)
%% For the outputfilenames a numeric index ( "ans" i.e. '_001','_002' etc') is APPENDED, ie. the
%% outputfiles are: 'XXX_043_001.nii' and 'XXX_044_002.nii' 
%% show and write logfile to 'checks'-folder
% z=[];                                                                                                                                                                                                        
% z.files       = { 'img\XXX_043.nii'        % % files to import, if empty import entire content of folder                                                                                                     
%                   'img\XXX_044.nii' };                                                                                                                                                                       
% z.add_affix   = 'ans';             % % add prefix or suffix to name of the imported file(s), if empty keep orig. filename. see options    {rlsans|ans|'}:                                            
% z.keepSubdirs = [0];                       % % keep subfolder structures of imported files:[0] flat herarchy,i.e import files directly into animalfolder, [1] files preserved in subdirs within animalfolder;
% z.logfile     = [3];                       % % logfile(LF): [0]no LF;[1]show LF;[2]write LF to "check"-dir [3]show and LF to "check"-dir (see options)                                                       
% ximportdir2dir(1,z);  
%% ===============================================
%% import files from subfolders directly into animal-dirs (no subfolders)
%% For the outputfilenames the last suffix is REPLACED by numeric index ( "rlsans"), ie. the
%% outputfiles are: 'XXX_001.nii' and 'XXX_002.nii' 
% z=[];                                                                                                                                                                                                        
% z.files       = { 'img\XXX_043.nii'        % % files to import, if empty import entire content of folder                                                                                                     
%                   'img\XXX_044.nii' };                                                                                                                                                                       
% z.addSuffix   = 'rlsans';                  % % add suffix to imported file {rlsans|ans|'}:                                                                                                                   
% z.keepSubdirs = [0];                       % % keep subfolder structures of imported files:[0] flat herarchy,i.e import files directly into animalfolder, [1] files preserved in subdirs within animalfolder;
% ximportdir2dir(1,z);  
%% ===============================================
%% import files from subfolders directly into animal-dirs (no subfolders)
%% For the outputfilenames a prefix ('p:imported_') is used, i.e. the
%% outputfiles are: 'imported_XXX_043.nii' and 'imported_XXX_044.nii' 
%% logfile is displayed
% z=[];                                                                                                                                                                                                        
% z.files       = { 'img\XXX_043.nii'        % % files to import, if empty import entire content of folder                                                                                                     
%                   'img\XXX_044.nii' };                                                                                                                                                                       
% z.add_affix   = 'p:imported_';             % % add prefix or suffix to name of the imported file(s), if empty keep orig. filename. see options    {rlsans|ans|'}:                                            
% z.keepSubdirs = [0];                       % % keep subfolder structures of imported files:[0] flat herarchy,i.e import files directly into animalfolder, [1] files preserved in subdirs within animalfolder;
% z.logfile     = [1];                       % % logfile(LF): [0]no LF;[1]show LF;[2]write LF to "check"-dir [3]show and LF to "check"-dir (see options)                                                       
% ximportdir2dir(1,z);  



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


%  mode='rlsans' ;%ReplacelastSuffixaddNumericSuffix; ['rlsans']
%  mode='ans'    ;%addNumericSuffix; ['ans']

opt_addsufix={...
    'do not change filename['''']'  ''
    'Replace last suffix & add numericSuffix; [''rlsans''] (eg. replace last suffix and add _001,_002,...)' 'rlsans';
    'add numericSuffix [''ans''] (eg. add suffix _001,_002,...) ' 'ans';
    'add prefix: [p:]   example: add prefix ''p:imported_''' 'p:imported_';
    'add suffix: [s:]   example: add suffix ''s:_imported''' 's:_imported';
    %     'specific: change individual filenames' @specificOutputfileNames
    };
opt_logfile={...
    'no logfile        '  0
    'show logfile [1]  '  1
    'save logfile to "checks"-folder [2]'  2
    'show logfile and save logfile to "checks"-folder [3]'  3
    };

p={...
    'files'              {''}   'files to import, if empty import entire content of folder'  {@selector2,li,hli,'out',1,'selection','multi','position','auto','info','select files'}
    'add_affix'           ''    'add prefix or suffix to name of the imported file(s), if empty keep orig. filename. see options    {rlsans|ans|''}: '         opt_addsufix
    'keepSubdirs'        0      'keep subfolder structures of imported files:[0] flat herarchy,i.e import files directly into animalfolder, [1] files preserved in subdirs within animalfolder;'  'b'
    'inf1' '' '' ''
    'logfile'            1      'logfile(LF): [0]no LF;[1]show LF;[2]write LF to "check"-dir [3]show and LF to "check"-dir (see options)' opt_logfile
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
    
    log={}; %logfile
    
    for i=1:length(indir)
        FS1=  cellfun(@(a){[  indir{i}  filesep a ]} ,z.files );
        FT1=  cellfun(@(a){[  outdir{i} filesep a ]} ,z.files );
        
        
        
        
        %flatHierarchy=1;
        if  z.keepSubdirs==0
            [pax namex extx]=fileparts2(z.files) ;
            flatfiles=cellfun(@(a,b){[ a b ]}, namex,extx);
            FT1=  cellfun(@(a){[  outdir{i} filesep a ]} ,flatfiles );
        end
        %% ===============================================
        
        %renaming file: replace suffix and add numeric suffix
        %mode='rlsans' ;%ReplacelastSuffixaddNumericSuffix; ['rlsans']
        %mode='ans'    ;%addNumericSuffix; ['ans']
        mode=char(z.add_affix);
        if ~isempty(mode)
            [pax namex extx]=fileparts2(FT1) ;
            
            nametemp=namex;
            
            for j=1:length(namex)
                if strcmp(mode,'rlsans')
                    try
                        nametemp{j,1}=namex{j}(1:max(strfind(namex{j},'_')-1));
                        nametemp{j,1}=[ nametemp{j,1} '_' pnum(j,3)];
                    end
                end
                if strcmp(mode,'ans')
                    try
                        nametemp{j,1}=namex{j};
                        nametemp{j,1}=[ nametemp{j,1} '_' pnum(j,3)];
                    end
                end
                if ~isempty(strfind(mode,'p:'))
                    affix=strrep(mode,'p:','');
                    nametemp{j,1}=[affix  nametemp{j,1}  ];
                end
                if ~isempty(strfind(mode,'s:'))
                    affix=strrep(mode,'s:','');
                    nametemp{j,1}=[ nametemp{j,1} affix  ];
                end
            end
            
            FT1= cellfun(@(a,b,c){[ fullfile(a,[b c])]} ,pax,nametemp,extx );
            %disp(char(FT1));
        end
        
        
        %% ===============================================
        
        
        for j=1:length(FS1)
            if exist(FS1{j})==2
                subdir=fileparts(FT1{j});
                if exist(subdir)~=7
                    mkdir(subdir); %make subdir if not exists
                end
                [success mess]=copyfile(FS1{j},FT1{j},'f');
                %[success mess]=copyfile(stradd(FS1{j},'bla',2),FT1{j},'f'); %file not found
                %===============================================
                if z.logfile~=0
                    
                    [pain  namein extin]   =fileparts(FS1{j});   namein = [namein  extin];
                    [paout nameout extout] =fileparts(FT1{j});   nameout= [nameout extout];
                    
                    if success==1; mess='file copied'; end
                    log(end+1,:)= ...
                        {pnum(i,3) pnum(j,3) mess  namein nameout pain paout};
                    
                end
                % ===============================================
                
            end
        end
        showinfo2('copied specific files to ',outdir{i},[],1,[' ... source: "' indir{i}  '"']);
    end
end

%% =======logfile========================================

if z.logfile~=0
    
    %% ===============================================
    gettime1=datestr(now);
    gettime2=datestr(now,'yyyy-mm-dd__HH_MM_SS');
    
    hlog={' #lk animalNo' 'fileNo'  'message' 'File_IN'  'File_OUT' 'path_IN' 'path_OUT'};
    mlog=plog([],[hlog;log],0,'logfile','al=1');
    mlog=[...
        ['log:          '  mfilename  ' ' gettime1]  ;
        ['copied files: '  [num2str(length(regexpi2(log(:,3),'file copied'))) '/' num2str(size(log,1))] ' files']  ;
        ['failures    : '  [num2str(size(log,1)-length(regexpi2(log(:,3),'file copied'))) '/' num2str(size(log,1))] ' files']  ;
        mlog;
        ];
    
    if z.logfile==1 || z.logfile==3
        if usejava('desktop')==1
            uhelp(mlog,1,'name',['log: '  mfilename]);
        else
            disp(char(mlog));
        end
    end
    if z.logfile>1
        logpath=fullfile(fileparts(z.outdir_root{1}),'checks');
        if exist(logpath)~=7; mkdir(logpath); end
        logfile=fullfile(logpath, ['log_' mfilename '_' gettime2 '.txt']);
        pwrite2file(logfile, mlog );
        showinfo2(['logfile'], logfile );
    end
    %% ===============================================
    
end


function specificOutputfileNames(e,e2)

hallo








