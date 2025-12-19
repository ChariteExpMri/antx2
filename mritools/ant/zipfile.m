
% function zipfile(varargin)
% gzip/gunzip file using OS-based gzip (unix) or git-based gzip
% The direction of compression/uncompression is defined by the file-extention in "flt"
%
% rec         find recursively in all subfolders of 'mdirs' {0,1}
%               - default: [0]
% mdirs       folders to search for NIFTI
%                     '' (<empty>): selected mdirs from ANTx-listbox are used
%                     'all'       : all mdirs from current ANTx-sutdy are used
%                     {several mdirs}: specify one/several DIrs
% flt         file filter ..found files will be zipped/unzipped
%                    -filter must contain the format '.nii'  or '.gz'
%                    -optional: '^' :starts with... '^mu_.*.nii' --> all niftis starting with 'mu_'
%                               '|' :to search for several images  ; example: 'img.nii|^svi.nii'
%
% keep        keep original file {0,1}
%               - default: [1]
% parallel    use parallel processing {0,1}
%               -default: [1]
% sim         simulate to show which file will be zipped/unzipped {0,1,2}
%               - sim: [2]: more compact view than sim [1]
%               - default: [0]
% gui        show/hide gui {0,1}
%               - default: [0], but will popup if 'flt' is not specified
%
%
%% EXAMPLES
% zipfile('flt','img.nii','sim',1)
% zipfile('flt','img.nii','sim',2)
% zipfile('flt','img.nii','keep',1,'parallel',1)
% zipfile('flt','img.nii|svi.nii')
% zipfile('flt','img.nii|^svi.nii')
%
%% simulate, over all animal-Dirs, show gui
% zipfile('flt','img.nii','sim',1,'mdirs','all','gui',1)
%% simulate, over all animal-Dirs, no gui
% zipfile('flt','img.nii','sim',1,'mdirs','all')  ;
%% sim: zip all nifti-files in all mdirs, recursively
% zipfile('flt',{'.nii'},'sim',1,'mdirs','all','rec',1)
%% sim: unzip all gz-files in all mdirs, recursively
% zipfile('flt',{'.gz'},'sim',1,'mdirs','all','rec',1)
%
%% zip all NIfti-files in all mdirs, recursively, don't keep original
% zipfile('flt',{'.nii'},'sim',0,'mdirs','all','rec',1,'keep',0)
%
%% unzip all .gz-files in all mdirs, recursively, don't keep original, use parallel process
% tic;  zipfile('flt',{'.gz'},'sim',0,'mdirs','all','rec',1,'keep',0,'parallel',1);  toc
% 
%% zip all .nii-files in all mdirs, recursively, don't keep original, use parallel process
% tic;  zipfile('flt',{'.nii'},'sim',0,'mdirs','all','rec',1,'keep',0,'parallel',1);  toc


function zipfile(varargin)

p.flt     =''; %file filter ..found files will be zipped/unzipped
p.mdirs   =''; %folders (1 or several) to search for
p.keep    =1 ; %keep original file {0,1}
p.rec     =0 ; %find recursively in all subfolders
p.parallel=0 ; %use parallel processinf {0,1}
p.sim     =0 ; %simulate to show which file will be zipped/unzipped {0,1,2}
p.gui     =0;
% =======[internal]========================================
p.abort=0; %abort ..guibased

if 0
    %% ===============================================
    
    z=[];
    z.flt      = { 'svimg.nii'       % % [SELECT] files to zipp/unzipp
        'vimg.nii' };
    z.keep     = [1];                % % keep original file {0,1}
    z.parallel = [0];                % % use parallel processinf {0,1}
    z.sim      = [0];                % % simulate to show which file will be zipped/unzipped {0,1,2}
    zipfile(1,z);
    %% ===============================================
    
    
end



if nargin>0
    if isnumeric(varargin{1})
        isshowgui=varargin{1};
        if nargin==2 && isstruct(varargin{2})
            pin=varargin{2};
            p=catstruct(p,pin);
        end
        if isshowgui==1
            pp=showgui(p) ;
            p=catstruct(p,pp);
        end
    else
        pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
        p=catstruct(p,pin);
    end
else
    %     pp=showgui(p) ;
    %     p=catstruct(p,pp);
end
% p.mdirs=cellstr(p.mdirs);
% if isempty(char(p.mdirs))
%     p.mdirs=antcb('getsubjects');
% end

if isempty(p.flt) || p.gui==1
    pp=showgui(p) ;
    p=catstruct(p,pp);
end

%% =======[checks]====================================
p.mdirs=cellstr(p.mdirs);
if isempty(char(p.mdirs));          p.mdirs=antcb('getsubjects');
elseif strcmp(char(p.mdirs),'all'); p.mdirs=antcb('getallsubjects');
end




if iscell(p.flt);     p.flt=strjoin(p.flt,'|'); end


if p.abort==1; return; end %abort

%% =======[run]========================================
if p.parallel==1
    parfor i=1:length(p.mdirs);         proc(p,i);    end
else
    for i=1:length(p.mdirs);           proc(p,i);    end
end
%% ===============================================


function proc(p,i)

mdir=p.mdirs{i};
if p.keep==1;     code='-k  -f  -v';
else              code=' -f  -v';
end


flt2=strsplit(p.flt,'|');
[pa na ext]=fileparts2(flt2);
is=regexpi2(ext,'.nii|.gz');
if length(is)~=length(flt2)
    disp('...file format not specified in "flt"');
    return
end


% p.flt=regexprep(p.flt,'\|','$|^');
p.flt=[ strjoin(flt2,'$|') '$'];
if ~isempty(strfind(p.flt,'.gz'))
    p.flt= regexprep(p.flt,'.gz','.gz$');
    code=[code ' -d'];
elseif ~isempty(strfind(p.flt,'.nii'))
    p.flt= regexprep(p.flt,'.nii','.nii$');
end
p.flt=regexprep(p.flt,'\$+','$');
if p.rec==1
    [fis] = spm_select('FPListRec',mdir,p.flt); fis=cellstr(fis);
else
    [fis] = spm_select('FPList',mdir,p.flt); fis=cellstr(fis);
end


if isempty(char(fis)); return; end

params=[ ' ' code ' '  ];


tsk='zipping';
if ~isempty(strfind(code, '-d'))
    tsk='unzipping'  ;
end


if ispc==1 && p.sim==0
    [e path2exe]=system('where git.exe');
    path2exe=regexprep(path2exe,char(10),'');
    if exist(path2exe)~=2;
        error('git is not installed');
    end
end




if p.sim==2
    [pam,names,ext]=fileparts2(fis);
    fisstr=strjoin(cellfun(@(a,b){[a b]}, names,ext),'|');
    disp(['#path:' pam{1} ]);
    disp([' sim_' tsk ': '  fisstr]);
    return
end


for j=1:length(fis)
    s1=fis{j};
    if p.sim==1
        disp(['<sim:' tsk '>'  s1]);
        continue
    end
    
    if ispc==1
        pa_gzip=(fullfile(fileparts(fileparts(path2exe)),'usr','bin'));
        c=['"'  fullfile(pa_gzip,'gzip.exe' ) '"'   params '"' s1 '"' ];
    else
        c=['gzip' params '"' s1 '"' ];
    end
    
    [e1 e2]=system(c);
    if isempty(strfind(code, '-d'))
        s2=[s1 '.gz'];
        [~,namx ext]=fileparts(s2);
        s3=[namx ext];
        if ~isempty(strfind(e2,s3));        showinfo2('zipped:',s2);            end
    else
        s2=regexprep(s1,'.nii.gz$','.nii');
         [~,namx ext]=fileparts(s2);
        s3=[namx ext];
        if ~isempty(strfind(e2,s3));        showinfo2('unzipped:',s2);            end
    end
end





function pp=showgui(x)
pp=x;
if exist('x')~=1;        x=[]; end
p={...
    'inf1'    'NOTE:'  'The direction of compression/uncompression is defined by the file-extention in "flt" ' ''
    'rec'          [0]          'find recursively in all subfolders {0,1}' 'b'
    'mdirs'        ''           'DIRs to search (keep empty to use selected from listbox)'     {'selected in listbox' ''; 'allAnimals' 'all' ; 'other' {@getdirs}}
    
    'flt'          x.flt        '[SELECT] files to zipp/unzipp'   {@getfiles }
    'keep'         x.keep       'keep original file {0,1}'   'b'
    'parallel'     x.parallel   'use parallel processinf {0,1}' 'b'
    'sim'          x.sim        'simulate to show which file will be zipped/unzipped {0,1,2}' {0 1 2 }
    };
p=paramadd(p,x);%add/replace parameter
% %% show GUI
% if showgui==1
hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
[m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
    'figpos',[0.1729    0.3500    0.5486    0.1778],...
    'title',['gzip/gunzip NIFTIs ('  mfilename '.m)' ],'info',hlp);
if isempty(m);
    z.abort=1;
    pp=z;
    return;
end
fn=fieldnames(z);
z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
%===========================================
%%   history
%===========================================
xmakebatch(z,p, mfilename);
pp=z;
pp.flt=strjoin(cellstr(pp.flt),'|');


function getfiles(e,e2)
%% ===============================================
% [u, x]=paramgui('get' ,'rec', 'flt');
[u, x]=paramgui('getdata');

if isempty(char(x.mdirs))
    pa=antcb('getsubjects');
elseif strcmp(char(x.mdirs),'all')
    pa=  antcb('getallsubjects');
else
    pa=x.mdirs;
end


if x.rec==0% fileList
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$|.*.nii.gz$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
else % fileListRec
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPListRec',pa{i},['.*.nii$|.*.nii.gz$']);
        if ischar(files); files=cellstr(files);   end;
        fis = cellfun(@(f) f(max([find(f=='\' ,1,'last') 0])+1:end), files, 'uni', 0);
        fi2=[fi2; fis];
    end
    li=unique(fi2);
end
dx= selector2(li,{'Image'},'out','list','selection','multi');
if ~isempty(dx) && ~isnumeric(dx)
    paramgui('setdata','x.flt',strjoin(dx,'|'))
end


%% ===============================================
function getdirs(e,e2,w1)
[t,sts] = spm_select(inf,'dir','select dir(s)',[],pwd);
if isempty(t); return; end
t=cellstr(t);
paramgui('setdata' ,'x.mdirs', t);

