
%% #b exportfiles - export files from any folder(s) (no ANT-'dat'-dir specific)
% _______________________________________________________________________________________________
%  - export with/without preserving hierarchy
%  - options: renaming/prefix/add mouse-folder name
% _______________________________________________________________________________________________
%% #by FUNCTION
% exportfiles(showgui,x )
%% #by INPUT
%    showgui               (optional) 0/1 : silent mode or GUI    ...default: GUI
%    x                     (optional) parameters OF THIS ROUTINE
% 
% 
% ________[PARAMETER]_______________
% 
% ___OPTION-1___: fullpath-file selection
% x.files                - select fullpath-files via gui
%
% ___OPTION-2___: specify of main source-folder and short filenames which are recoursively searched 
%    NOTE: ...___OPTION-2___ is an alternative for ___OPTION-1___ and vice versa
% x.sourcePath          - source path: this folder will be recursively checked  for files                                                               
% x.fileNames             - files (without path) ...will be searched in "x.sourcePath"
%                         - example: x.fileNames={'a1.txt','b2.nii', 'c2.doc'}
% 
% 
% 
% x.destinationPath       -destination path to export files , cellarray,
%                         -must be specified!!
%                         example: 'ABC'  --> this creates a folder "ABC" in the studies folder
%                          -path is created if it does not exist
% x.keepSubdirStructure    [0] flattened hierarchy (no subdirs),
%                          [1] the destination path contains a subfolder for each mouse
%                          default: 1
% 
% x.prefixDirName          adds mouse Dir/folder name as prefix to the new filename,
%                          default: ''
% x.renameString           new file name (without extention), this works if only one file is
%                          copied per directory
%                          default: ''
% x.addString              adds a string as suffix to the new file name
%                          default: ''
% x.writeLogfile'          'boolean, [1] write a logfile "export+timestamp.txt" [0] write no logfile' 'b'
%                           default: [1]
% ==============================================
%% #ko  EXAMPLES
% ===============================================
%                                                                                                                  
%% =====================================================     
%% ___OPTION-1___:  FULLPATH FILE-specification
%% export fullpath-file Names to "export3"-folder 
%% keep subdir-structure                                                                                                                                  
%% =====================================================                                                                                                                                          
% z=[];                                                                                                                                                                                              
% z.files               = { 'F:\data5\test_export\dat2\dx1\n1.nii'        % % files to export <required to fill> or use 'all' or 'dirs'                                                              
%                           'F:\data5\test_export\dat2\dx1\n2.nii'                                                                                                                                   
%                           'F:\data5\test_export\dat2\dx1\t1.txt'                                                                                                                                   
%                           'F:\data5\test_export\dat2\dx1\t2.txt'                                                                                                                                   
%                           'F:\data5\test_export\dat2\dx2\n1.nii'                                                                                                                                   
%                           'F:\data5\test_export\dat2\dx2\n2.nii'                                                                                                                                   
%                           'F:\data5\test_export\dat2\dx2\t1.txt'                                                                                                                                   
%                           'F:\data5\test_export\dat2\dx2\t2.txt' };                                                                                                                                
% z.destinationPath     = 'F:\data5\test_export\export1';                 % % destination path to export files <required to fill>                                                                    
% z.keepSubdirStructure = [1];                                            % % [0,1]: [0] flattened hierarchy (no subdirs), [1] the destination path contains the subfolders                          
% z.prefixDirName       = [0];                                            % % adds mouse Dir/folder name as prefix to the new filename                                                               
% z.renameString        = '';                                             % % replace file name with new file name (no file extention), !NOTE: files might be overwritten (same output name)         
% z.addString           = '';                                             % % add string as suffix to the output file name                                                                           
% z.writeLogfile        = [1];                                            % % boolean, [1] write a logfile "export+timestamp.txt" [0] write no logfile                                                  
% exportfiles(0,z);
% 
% 
%% =====================================================  
%% ___OPTION-2___:  specify sourcepath+files
%% export files ('n1.nii','n2.nii',''t1.nii'') found in "dat2" 
%% keep subdir-structure
%% =====================================================                                                                                                                            
% z=[];                                                                                                                                                                                
% z.files               = '';                                 % % fullpath-files to export                                                                                             
% z.sourcePath          = 'F:\data5\test_export\dat2';        % % source path: this folder will be recursively checked                                                                 
% z.fileNames           = { 'n1.nii'                          % % filenames recoursively searched in "sourcePath" to export                                                            
%                           'n2.nii'                                                                                                                                                   
%                           't1.txt' };                                                                                                                                                
% z.destinationPath     = 'F:\data5\test_export\export2';     % % destination path to export files <required to fill>                                                                  
% z.keepSubdirStructure = [1];                                % % [0,1]: [0] flattened hierarchy (no subdirs), [1] the destination path contains the subfolders                        
% z.prefixDirName       = [0];                                % % adds mouse Dir/folder name as prefix to the new filename                                                             
% z.renameString        = '';                                 % % replace file name with new file name (no file extention), !NOTE: files might be overwritten (same output name)       
% z.addString           = '';                                 % % add string as suffix to the output file name                                                                         
% z.writeLogfile        = [1];                                % % boolean, [1] write a logfile "export+timestamp.txt" [0] write no logfile                                                  
% exportfiles(0,z); 
% 
% 
%% ===================================================== 
%% ___OPTION-2___:  specify sourcepath+files
%% export files ('n1.nii','n2.nii',''t1.nii'') found in "dat2" 
%% remove subdir-structure, but add 'DIR'-name-to namestring and add a string to filename
%% =====================================================                                                                                                                            
% z=[];                                                                                                                                                                                
% z.files               = '';                                 % % fullpath-files to export                                                                                             
% z.sourcePath          = 'F:\data5\test_export\dat2';        % % source path: this folder will be recursively checked                                                                 
% z.fileNames           = { 'n1.nii'                          % % filenames recoursively searched in "sourcePath" to export                                                            
%                           'n2.nii'                                                                                                                                                   
%                           't1.txt' };                                                                                                                                                
% z.destinationPath     = 'F:\data5\test_export\export3';     % % destination path to export files <required to fill>                                                                  
% z.keepSubdirStructure = [0];                                % % [0,1]: [0] flattened hierarchy (no subdirs), [1] the destination path contains the subfolders                        
% z.prefixDirName       = [1];                                % % adds mouse Dir/folder name as prefix to the new filename                                                             
% z.renameString        = '';                                 % % replace file name with new file name (no file extention), !NOTE: files might be overwritten (same output name)       
% z.addString           = 'bla';                              % % add string as suffix to the output file name                                                                         
% z.writeLogfile        = [1];                                % % boolean, [1] write a logfile "export+timestamp.txt" [0] write no logfile                                                  
% exportfiles(0,z);              
%
% _______________________________________________________________________________________
%
%% #by RUN-def:
% exportfiles(1) or  xexport    ... open PARAMETER_GUI
% exportfiles(0,z)             ...NO-GUI,  z is the predefined struct
% exportfiles(1,z)             ...WITH-GUI z is the predefined struct
%
%% #by RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace





% ==============================================
%   older
% ===============================================
% x.animalsubdirs'       Preserve SUBFOLDERS WITHIN ANIMAL FOLDERS [1] or do not preserve [0].
%                       #r ONLY USEFUL CASE: Exporting files from subfolders within animal folders 
%                       # example: export the file my.txt from subfolders in animal007:  ../dat/animal007/subdir1/subdir2/my.txt
%                       [1] Preserve SUBFOLDERS WITHIN ANIMAL FOLDERS: Depending on "keepSubdirStructure" parameter
%                           the subfolder is preserved in the exporting folder structure (if "keepSubdirStructure" is [1])
%                           or if "keepSubdirStructure" is [0] the subfolder is  part of the exporting filename.
%                       [0] SUBFOLDERS WITHIN ANIMAL FOLDERS arenot preserved neither in export hierarchy nor

function xexport(showgui,x )


%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                   ;end
if exist('x')==0                           ;    x=[]                        ;end
if exist('pa')==0      || isempty(pa)      ;   
    %pa=antcb('getallsubjects')  ;
    pa=pwd;
end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end



% ==============================================
%% PARAMETER-gui
% ===============================================

if exist('x')~=1;        x=[]; end

%% import 4ddata
para={...
    'inf97'      '==================================='                          '' ''
    'inf98'      '*** EXPORT FILES FROM ANY SOURCE    '                         '' ''   %    'inf1'      '% PARAMETER         '                                    ''  ''
    'inf100'     '==================================='                          '' ''
    'inf101' '' '' '' 
    'inf102' '*** choose either MODE-1 ore MODE-2 ***' '' '' 
    
    'inf1' '___ MODE-1: Fullpath-File Mode ___' '' ''
    'files'                ''          'fullpath-files to export'  'mf'
    
    'inf2' '___ MODE-2: Recoursive Mode ___ (alternative to Mode-1)' '' ''
    'sourcePath'      ''          'source path: this folder will be recursively checked'  'd'
    'fileNames'       ''          'filenames recoursively searched in "sourcePath" to export '  {@getFilenames}
    
    'inf3' '' '' '' 
    'inf4' '___ Parameter ___' '' ''
    'destinationPath'      ''          'destination path to export files <required to fill>'  'd'
    'keepSubdirStructure'   1          '[0,1]: [0] flattened hierarchy (no subdirs), [1] the destination path contains the subfolders  '    'b'
    %'animalsubdirs'         1          '[0,1]: [1] preserve SUBFOLDERS WITHIN ANIMAL FOLDERS in either output name or folder hierarchy or [0] do not preserve' 'b'
    'prefixDirName'         0          'adds mouse Dir/folder name as prefix to the new filename'      'b'
    'renameString'         ''          'replace file name with new file name (no file extention), !NOTE: files might be overwritten (same output name)'  {'mask' 'raw' 'test'}
    'addString'            ''          'add string as suffix to the output file name'                                                            ''
    
    'inf5' '' '' '' 
    'inf6' '___ LOGFILE ___' '' ''
    'writeLogfile'          1          'boolean, [1] write a logfile "export+timestamp.txt" [0] write no logfile' 'b'
    };

p=paramadd(para,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[0.1306    0.5111    0.6535    0.3578 ],...
        'title',[mfilename '.m'],'pb1string','OK','info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

disp('..exporting..');
xmakebatch(z,p, mfilename); % ## BATCH


% ==============================================
%%   posthoc add paramter
% ===============================================

z.animalsubdirs=1;

% ==============================================
%%  obtain recoursively the files if exist
% ===============================================

if exist(z.sourcePath)==7 && ~isempty(char(z.fileNames))
    
    parec=z.sourcePath;
    fileNames=cellstr(z.fileNames);
    filt=cellfun(@(a){['^' a '$' ]} ,fileNames);
    filt=strjoin(fileNames,'|');
    
    [files2,~] = spm_select('FPListRec',parec,filt);
    files2=cellstr(files2);
else
    files2={};
end




% ==============================================
%%   start here
% ===============================================
files1=z.files;
if ischar(files1); files1=cellstr(files1); end
z.files=[files1(:);files2(:)];
z.files(find(cellfun(@isempty,z.files)))=[];

if isempty(char(z.files)); return; end


%=========unklar ==========================================================================================

 
copydirsonly=0;
if strcmp(z.files,'dirs')   %% COPY ONLY DIRECTORIES
    z.files    = antcb('getsubjects');
    copydirsonly=1;
    z.prefixDirName=0; %no prefixes
end
copyall=0;
if strcmp(z.files,'all')   %% COPY DIRECTORIES and all files 
    z.files    = antcb('getsubjects');
    copyall=1;
end

if strcmp(z.files,'dirs') | strcmp(z.files,'all')
    z.keepSubdirStructure=1;
end
%===================================================================================================
% ==============================================
%%   MSG
% ===============================================
if z.keepSubdirStructure==0
    disp(' !!! this might overwrite files ...subdir-structure is nullified (z.keepSubdirStructure=0)');
end

% ==============================================
%%   obtain basic common_path
% ===============================================
commonpath=[];
if ~isempty(char(z.sourcePath))
    commonpath=char(z.sourcePath);
else
    filex=z.files;
    %filex={'c:\dum\ore\aa1.txt' 'c:\dum\ore\aa2.txt'}
        
    if length(filex)>1
        len=min(cell2mat(cellfun(@(a){[length(a) ]} ,filex)));
        dv=cell2mat(cellfun(@(a){[double(a(1:len)) ]} ,filex));
        sae=sum(abs(dv-repmat(dv(1,:),[size(dv,1) 1])),1);
        ilast=min(find(sae~=0))-1;
        commonpath=fileparts(filex{1}(1:ilast));
    end
end



% ==============================================
%%   
% ===============================================
logfile={};
warning off;
for i=1:length(z.files)
    f1=z.files{i};
    [pa fi ext]=fileparts(f1);
    pa2=pa;
    
     [pas fis exs]=fileparts(z.destinationPath);
     
     % ==============================================
     %% Destination path
     % ===============================================
     if isempty(z.destinationPath)
         error('no exporting/output folder specified...canceled'); return
     end
     if isempty(pas)==1;%short destination path is given
         error('full destination path is required');
     else
         padest=z.destinationPath;
     end
%      if strcmp(an.datpath,padest)==1
%         error('can''t copy into studie''s dat folder...canceled'); return 
%      end
     
 
    filename=[fi ext];
    [~, subdir]=fileparts(pa);
    
    % the subDir-ISSUE
    studyDir=pwd;%fileparts(an.datpath);
    splitdirs=strsplit(strrep(pa,studyDir,''),filesep );
    splitdirs=cellstr(splitdirs);
    splitdirs(cellfun(@isempty,splitdirs))=[];
    
    % SUBFOLDERS IN animal dirs
    if z.animalsubdirs==0 % [0]:no subdirs in animalDirs,[1] keep subdirs in animalDirs
        if strcmp(splitdirs{1},'dat')
            splitdirs(3:end)=[];
        end
    end
    
            % KEEP STRUCTURE
    if z.keepSubdirStructure==1
        subdir=strjoin(splitdirs,filesep);
        parest=strrep(pa,commonpath,'');
        if strcmp(parest(1),filesep)%remove first char if this is a filesep
           parest(1)=[]; 
        end
        subdir=parest;
    else % no ...do not keep it
       
       
       try
           splitcompath=strsplit(commonpath,filesep);
           idel_subdir=find(ismember(splitdirs, splitcompath));
           splitdirs2=splitdirs;
           splitdirs2(idel_subdir)=[];
           subdir=strjoin(splitdirs2,'_'); 
       catch
        subdir=strjoin(splitdirs,'_');   
       end
    end
    
    
    %% fileNamestring
    if ~isempty(z.renameString)
        filename=[z.renameString ext];
    end
    
    %% add addString as suffix to filename
    if ~isempty(z.addString)
        [~, fip ext ]=fileparts(filename);
        filename=[fip z.addString ext];
    end
    
    %% add subdir as prefix to filename
    if z.prefixDirName==1
        filename=[ subdir '_' filename];
    end
    
    
    
    
    %% keepSubdirStructure
    if z.keepSubdirStructure==1 && copydirsonly==0 && copyall==0
        padest=fullfile(padest, subdir);
        mkdir(padest);
    end
%     mkdir(padest);
    
    %% concat new filename & make folder
    f2=fullfile(padest,filename);
    if exist(padest)~=7
        mkdir(padest)
    end
    
    
    taskstr='exported';
    if copydirsonly==0
        %% copyfile
        if exist(f2)==2
            taskstr='export(overwrite)';
        end
        copyfile(f1, f2,'f');
        %disp(f2)
    elseif copydirsonly==1
        mkdir(f2);
    end
    
    

    
    
    %% MSG
    [pa3 fi3 ext3]=fileparts(f2);
    
    if copydirsonly==0 && copyall==0 
        msg=[taskstr ' file: '];
    elseif copydirsonly==1 && copyall==0
        msg=[taskstr ' folder without files: '];
    elseif copydirsonly==0 && copyall==1
         msg=[taskstr ' folder with files: '];    
    end
    
    try
        %['[' fullfile( pa3,[ fi3 ext3]) '] in']
        disp([msg   ' <a href="matlab: explorer('' ' f2 '  '')">' f2 '</a>' '; source: ' ['[' fullfile(pa,[fi, ext]) ']' ]  ]);% show h<perlink
    catch
        %['[' fullfile( pa3,[ fi3 ext3]) ']' ]
        disp([msg   f2 ' from:  '  ['[' fullfile(pa,[fi, ext])  ']']  '' ]);
    end
    
    %% logfile
    logfile=[logfile;
    ['[' regexprep(msg,'\s+$','') '] '  f1 ' [TARGET:] '  f2]
    ];
    
end


if copydirsonly==1 
    z.files='dirs';
end
if copyall==1 
    z.files='all';
end

% %% copy BATCH
% if copyall==0 && copydirsonly==0
%     xbat=which('xfiles2subfolders.bat');
%     copyfile( xbat,replacefilepath( xbat, z.destinationPath) );
% end

% makebatch(z);
% ==============================================
%%   write logfile
% ===============================================

if z.writeLogfile==1
  File_logfile=fullfile(z.destinationPath, ['log_exportfile_' regexprep(datestr(now),{':' ' '},'_') '.txt'   ]);
  pwrite2file(File_logfile, logfile )
    showinfo2('..logfile created ',File_logfile);
end


% ==============================================
%%   subs
% ===============================================

 
function makebatch(z)
try
    hlp=help(mfilename);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end

hh={};
hh{end+1,1}=('% ==============================================');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=[ '% #b descr:' hlp];
hh{end+1,1}=('% ==============================================');
hh=[hh; 'z=[];' ];
hh=[hh; struct2list(z)];
hh(end+1,1)={[mfilename '(' '1',  ',z' ');' ]};
% uhelp(hh,1);
try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '};{'                '}];
assignin('base','anth',v);
disp(['BATCH: <a href="matlab: uhelp(anth,1,''cursor'',''end'')">' 'show history' '</a>'  ]);

% ==============================================






function o=getFilenames(e,e2)
o=[];
[x1,x2]= paramgui('getdata');
pa=char(x2.sourcePath);
if isempty(pa); 
        addNote(gcf,'text',{'"x.sourcePath" must be defined first' 'Then, select files..'},...
            'state',2, 'pos',[.45 .5 .3 .3],'fs',25,'mode','single');
    return;
end

%% ==============[get recoursively all files and select files]=================================
pa=x2.sourcePath;
fi2={};
[files,~] = spm_select('FPListRec',pa,['.*.$']);
if ischar(files); files=cellstr(files);   end;
[px fix ext]=fileparts2(files);
fi2=cellfun(@(a,b){[a b ]} ,fix, ext);

%counting:https://de.mathworks.com/matlabcentral/answers/115838-count-occurrences-of-string-in-a-single-cell-array-how-many-times-a-string-appear
a=unique(fi2,'stable');
b=cellfun(@(x) sum(ismember(fi2,x)),a,'un',0);
tb=[a b];

tb(:,2)=cellfun(@(a){[num2str(a) ]},tb(:,2));
tb=sortrows(tb,1);
id=selector2(tb,{'file' 'counts'},'out','list','selection','multi');
o=id(:,1);
% if o==1;
%     return
% end
%% ===============================================















