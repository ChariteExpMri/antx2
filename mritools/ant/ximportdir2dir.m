%% import files or folder content from outside via dir2dir-correspondence
% #r name of source-directory (to copy from) and target-directory (to copy to)
% #r must match (directory-directory-correspondence)
% 'importIMG' : > select file(s) here from GUI
%             : or type 'all' to copy the entire content of source
%             directory

function ximportdir2dir(showgui,x)


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
%%   get files to import
%———————————————————————————————————————————————
%     msg={'Folders With Files TO IMPORT'
%         'select those mouse-folder which contain files to import' 
%         ''};
    msg2='select folders to import files or content';
    disp(msg2); %MAC issue
    
    %     [maskfi,sts] = cfg_getfile2(inf,'image',msg,[],prefdir,'img');
    %[pa2imp,sts] = cfg_getfile2(inf,'dir',msg,[],prefdir,'.*');
    [pa2imp,sts] = spm_select(inf,'dir',msg2,[],prefdir,'.*');
    pa2imp=cellstr(pa2imp);
    if isempty(char(pa2imp)); return ; end
       pa2imp=regexprep(pa2imp,[ '\' filesep '$'],''); %remove trailing filesep
       
       %%check whether first 2 dirs are upper-root-dirs
    deldir(1)=sum(cell2mat(strfind(pa2imp,pa2imp{1})))>1;
    try;deldir(2)=sum(cell2mat(strfind(pa2imp,pa2imp{2})))>1;end
    pa2imp(find(deldir==1))=[];
       
%———————————————————————————————————————————————
%%   over mousepaths 
%———————————————————————————————————————————————
if exist('pa')==0      || isempty(pa)      ;   
    pa=antcb('getallsubjects')  ;
end

%———————————————————————————————————————————————
%%   get list of files to import
%———————————————————————————————————————————————
if 1
    fi2={};
    for i=1:length(pa2imp)
        [files,~] = spm_select('FPList',pa2imp{i},['.*.*$']);
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
        %
        %         try
        %          hh=spm_vol(fullfile(pa{1}, li{i} ));
        %         hh=hh(1);
        %
        %         vmat=spm_imatrix(hh.mat);
        %         ori=regexprep(num2str(vmat(1:3)),' +',' ');
        %         res=regexprep(num2str(vmat(7:9)),' +',' ');
        %         dim=regexprep(num2str(hh.dim),['\W*'],'-');
        %         dt=regexprep(num2str(hh.dt),['\W*'],' ');
        
        ad(i,:)={ext};
        %         end
    end
%     
      li2 =[li ad];
      li2h={'files-to-import' 'extention'};
end

%% zuordnen
tb=zurodnen(pa2imp , pa);

if isempty(tb); disp('..nothing selected');return ;end

% id=selector2(tb,{'pa' 'fi' 'ext' 'TargetPath'})
% return


    

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end


p={...
    'inf98'      '*** IMPORT Files from Folders                 '                         '' ''
    'inf100'     '-------------------------------'                          '' ''
    'importIMG'     ''    'import selected files or us "all" to import entire folder-content'        {@selector2,li2,li2h,'out','col-1','selection','multi'}
    %'renamestring'   ''    'renamefile to (without extention)'             '' 
    };

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI

if showgui==1
     hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .8 .3 ],...
    'title',[mfilename],'info',hlp);
    if isempty(z); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

if isempty(char(z.importIMG));%no files selected
    disp('no files selected');
    return
end


%———————————————————————————————————————————————
%%   ok-import files
%———————————————————————————————————————————————
if ischar(z.importIMG)
    z.importIMG=cellstr(z.importIMG)
end

if size( z.importIMG,1)==1 && strcmp(z.importIMG{1},'all')
  %COPY FOLDER WITH ALL CONTENTS
   for i=1:size(tb,1)
       pafrom=fullfile(tb{i,1},tb{i,2})
       k=dir(pafrom);
       content={k(:).name}';
       content(find(strcmp(content,'.')))=[];
       content(find(strcmp(content,'..')))=[]; %remove upperDirs
       
       
        for j=1:size(content,1)
            
            %check existence of this file in this folder
            f1=fullfile(tb{i,1},tb{i,2} , content{j} );
            f2=fullfile(tb{i,4}        , content{j}  );
            
            if exist(f1)~=0
                copyfile(f1,f2,'f');
                disp([pnum(i,4) '] imported file <a href="matlab: explorer('' ' fileparts(f2) '  '')">' f2 '</a>' '; SOURCE: ' '<a href="matlab: explorer('' ' fileparts(f1) '  '')">' f1  '</a>']);% show h<perlink
            end
        end
    end
  
  
    
else
    %COPY SELECTED FILES
    for i=1:size(tb,1)
        for j=1:size(z.importIMG,1)
            
            %check existence of this file in this folder
            f1=fullfile(tb{i,1},tb{i,2} , z.importIMG{j} );
            f2=fullfile(tb{i,4}       , z.importIMG{j}  );
            
            if exist(f1)==2
                copyfile(f1,f2,'f');
                disp([pnum(i,4) '] imported file <a href="matlab: explorer('' ' fileparts(f2) '  '')">' f2 '</a>' '; SOURCE: ' '<a href="matlab: explorer('' ' fileparts(f1) '  '')">' f1  '</a>']);% show h<perlink
            end
        end
    end
end



makebatch(z);



% ============================================
%% subs
% ============================================

function makebatch(z)

 

try
hlp=help(mfilename);
hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
  hlp='';  
end

hh={};
hh{end+1,1}=('% ============================================');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=[ '% descr:' hlp];
hh{end+1,1}=('% ============================================');
hh=[hh; struct2list(z)];
hh(end+1,1)={[mfilename '(' '1',  ',z' ')' ]};
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




%———————————————————————————————————————————————
%%   zuordnung
%———————————————————————————————————————————————

function tb=zurodnen(pa2imp , pa)
tb={};
for i=1:size(pa2imp,1)
    [pas fis ext]=fileparts(pa2imp{i});
    tb(i,:)={pas fis ext};
end


tb2={};
for i=1:size(pa,1);
    [pas fis ext]=fileparts(pa{i});
    tb2(i,:)={pas fis };
end

tb3={};
for i=1:size(tb,1)
    
    [ix,d]=strnearest([   tb{i,2}  ],tb2(:,2)) ;
    dum=tb(i,1:3);
    n=1;
    dum2={};
    for j=1:length(ix)
        dum2(j,:)=[dum  fullfile(tb2{ix(j),1},tb2{ix(j),2})   {num2str(n)}];
        n=n+1;
    end
    tb3=[tb3; dum2];
end

hlp={};
hlp{end+1,1}=' #yg CHECK FOLDER-TO-FOLDER CORRESPONDENCE';
hlp{end+1,1}='  -check rough matching of "IMPORT-DIR" and "Target-DIR"';
hlp{end+1,1}='  -if "Nth-DIR-assignment" >1 the  "IMPORT-DIR"  is assigned to more than ONE "Target-DIR" ';
hlp{end+1,1}='    ..than you have to decide whether is is ok or not ';
hlp{end+1,1}='select all files to import';

nfileseps=findstr(tb3{1},filesep); % path to long
if length(nfileseps)>6
    tb3short=tb3;
    nDirs2keep=4;
    for i=1:size(tb3short,1)
        shortpath=tb3short{i,1};
        tb3short{i,1}=['..' shortpath(nfileseps(length(nfileseps)-nDirs2keep+1):end)];
    end
    id=selector2(tb3short,{'IMPORT-ROOT-DIR(abbrev.)' '' 'IMPORT-DIR' 'Target-DIR' ,'Nth-DIR-assignment'},...
    'iswait',1,'help',hlp);
    
else
id=selector2(tb3,{'IMPORT-ROOT-DIR' '' 'IMPORT-DIR' 'Target-DIR' ,'Nth-DIR-assignment'},...
    'iswait',1,'help',hlp);
end



if isempty(id)  
    tb=[];
else
    try
    tb=tb3(id,:);
    catch
    tb=[];
    end
end
