% assign new group-comparisons 
% create essential group-comparisons or manually via GUI
% input: excelfile with animal-ids and columns specifying the group-assignment for
% 1/2/3-factorial design
% OUTPUT: resulting excel-files with group-comparisons
% 
%% ===============================================================================
%%  PARAMETER
%% ===============================================================================
% 'groupfile'      -THE group-assignment file (EXCELFILE) with animal-IDs and group-assignment
%                  -this file can be created via "createGroupassignmentFile.m"
% 'sheetIdx'       -sheet number' of the excelfile; default: [1]
% 'col_animal'     -column index containing the ANIMAL-IDs; default: [1]
% 'col_group'      -column index/indices containing the groupsassignments/factors' ; default: [2]
%                  -for more than two factors use >1 column-index
% 'keepRowType'    -keep row Information from the input excel-file
%                   this information is stored in the new excel-files
%                     [1] no, do not keep/preserve information 
%                     [2] keep old factors: original factors/group-column(s) will be saves (for checks) 
%                     [3] keep all : keep all information
%                     [4] keep all except of old factors 
%                     default: [3]
% 'compType'        -group comparison type
%                    ["all"]: make all essenial comparisons,
%                    ["gui"]: specify comparisons via GIU
%                     default: "gui"
% 'simulate'         simulate output: 
%                    [1] just display the output (do not write excel-files) 
%                    [0] write Excelfiles
%                     default: [0]
% 'outputprefix'     -prefix string of resulting excelfile-names; 
%                    -default: 'ga_'
% 'addcounter'       -add a counter to the filename-prefix
%                    -can be usefull if you have lots of group-comparisons
%                     default: [1]
% 
%
%% ===============================================================================
%% example: input excel-file with 1 factor ("day") with 4 levels
%% ===============================================================================

%     'animal'                              'day'
%     '20200930MG_LAERMRT_MGR000023'        '7d' 
%     '20200930MG_LAERMRT_MGR000028'        '7d' 
%     '20200930MG_LAERMRT_MGR000029'        '7d' 
%     ....
%     '20210205MG_LAERMRT_MGR000078'        '84d'
%     '20210205MG_LAERMRT_MGR000079'        '84d'
%     '20210208MG_LAERMRT_MGR000080'        '84d'
%      ...
%     '20220112MG_LAERMRT_MGR000162'        '56d'
%     '20220112MG_LAERMRT_MGR000164'        '56d'
%     '20220124MG_LAERMRT_MGR000167'        '56d'
%     ...
%     '20220503MG_LAERMRT_MGR000230'        '1d' 
%     '20220503MG_LAERMRT_MGR000231'        '1d' 
%     '20220505MG_LAERMRT_MGR000233'        '1d' 
%     ...
%% ===============================================================================
%% example: input excel-file with 2 factor ("day","stress") with 4x3 levels
%% ===============================================================================
%     'animal'                'day'    'stress'
%     '20200930MG_LAERMR…'    '7d'     'Ctrl'  
%     '20200930MG_LAERMR…'    '7d'     '90dB'   
%     '20201001MG_LAERMR…'    '7d'     '115dB' 
%     ...
%     '20200930MG_LAERMR…'    '84d'     'Ctrl'  
%     '20200930MG_LAERMR…'    '84d'     '90dB'   
%     '20201001MG_LAERMR…'    '84d'     '115dB' 
%     ...
%     '20200930MG_LAERMR…'    '56d'     'Ctrl'  
%     '20200930MG_LAERMR…'    '56d'     '90dB'   
%     '20201001MG_LAERMR…'    '56d'     '115dB' 
%     ...
%     '20200930MG_LAERMR…'    '1d'     'Ctrl'  
%     '20200930MG_LAERMR…'    '1d'     '90dB'   
%     '20201001MG_LAERMR…'    '1d'     '115dB' 
%      ...
%% ===============================================================================
%% example: input excel-file with 2 factor ("day","stress","score") with 4x3x2 levels
%% ===============================================================================   
%     '20220405MG_LAERMR…'    '1d'     '115dB'    'am'   
%     '20220405MG_LAERMR…'    '1d'     '115dB'    'bm'
%     '20220405MG_LAERMR…'    '1d'     '85dB'     'am'
%     '20220405MG_LAERMR…'    '1d'     '85dB'     'bm'   
%     '20220405MG_LAERMR…'    '1d'     'Ctrl'     'am'
%     '20220405MG_LAERMR…'    '1d'     'Ctrl'     'bm'
%     ...
%     '20220405MG_LAERMR…'    '84d'    '115dB'    'am'   
%     '20220405MG_LAERMR…'    '84d'    '115dB'    'bm'
%     '20220405MG_LAERMR…'    '84d'    '85dB'     'am'
%     '20220405MG_LAERMR…'    '84d'    '85dB'     'bm'   
%     '20220405MG_LAERMR…'    '84d'    'Ctrl'     'am'
%     '20220405MG_LAERMR…'    '84d'    'Ctrl'     'bm'
%     ...
%     '20220405MG_LAERMR…'    '56d'    '115dB'    'am'   
%     '20220405MG_LAERMR…'    '56d'    '115dB'    'bm'
%     '20220405MG_LAERMR…'    '56d'    '85dB'     'am'
%     '20220405MG_LAERMR…'    '56d'    '85dB'     'bm'   
%     '20220405MG_LAERMR…'    '56d'    'Ctrl'     'am'
%     '20220405MG_LAERMR…'    '56d'    'Ctrl'     'bm'
%     ...
%     '20220405MG_LAERMR…'    '7d'     '115dB'    'am'   
%     '20220405MG_LAERMR…'    '7d'     '115dB'    'bm'
%     '20220405MG_LAERMR…'    '7d'     '85dB'     'am'
%     '20220405MG_LAERMR…'    '7d'     '85dB'     'bm'   
%     '20220405MG_LAERMR…'    '7d'     'Ctrl'     'am'
%     '20220405MG_LAERMR…'    '7d'     'Ctrl'     'bm'
%      ...
 % ==============================================
%%   
% ===============================================

    
% ==============================================
%%   1-factor: create essential group-comparisons
% ===============================================
% z=[];
% z.groupfile   = 'F:\data6\victor\_test_groupsplit\groupassignment_1factor.xlsx';     % % group-assignment file
% z.sheetIdx    = [1];                                                                             % % sheet number
% z.col_animal  = [1];                                                                             % % column index with ANIMAL-IDs
% z.col_group   = [2 ];                                                                          % % column inex/indices with groups/factors
% z.keepRowType = [3];                                                                             % % keep row Information: [1]no [2]keep old factors [3]keep all [4]keep all except of old factors
% z.compType     = 'all';                                                                         % % group comparison type ["all"]: make all essenial comparisons,["gui"]: specify via GIO        
% z.simulate     = [0];                                                                           % % simulate output: [1]just show output; [1] write excelfiles                                   
% z.outputprefix = 'ga_';                                                                         % % prefix of resulting excelfile(s)                                                             
% z.addcounter   = [1];                                                                           % % add a counter to the filename-prefix                                                         
% xgroupassigfactorial(1,z);
% ==============================================
%%   1-factor: select groups-comparisons via GUI
% ===============================================
% z=[];
% z.groupfile   = 'F:\data6\victor\_test_groupsplit\groupassignment_1factor.xlsx';     % % group-assignment file
% z.sheetIdx    = [1];                                                                             % % sheet number
% z.col_animal  = [1];                                                                             % % column index with ANIMAL-IDs
% z.col_group   = [2 ];                                                                          % % column inex/indices with groups/factors
% z.keepRowType = [3];                                                                             % % keep row Information: [1]no [2]keep old factors [3]keep all [4]keep all except of old factors
% z.compType     = 'gui';                                                                         % % group comparison type ["all"]: make all essenial comparisons,["gui"]: specify via GIO        
% z.simulate     = [0];                                                                           % % simulate output: [1]just show output; [1] write excelfiles                                   
% z.outputprefix = 'ga_';                                                                         % % prefix of resulting excelfile(s)                                                             
% z.addcounter   = [1];                                                                           % % add a counter to the filename-prefix                                                         
% xgroupassigfactorial(1,z);
% ==============================================
%%   2-factors: create essential group-comparisons 
% ===============================================
% z=[];
% z.groupfile   = 'F:\data6\victor\_test_groupsplit\groupassignmentFactorial_2factors.xlsx';     % % group-assignment file
% z.sheetIdx    = [1];                                                                             % % sheet number
% z.col_animal  = [1];                                                                             % % column index with ANIMAL-IDs
% z.col_group   = [2  3];                                                                          % % column inex/indices with groups/factors
% z.keepRowType = [3];                                                                             % % keep row Information: [1]no [2]keep old factors [3]keep all [4]keep all except of old factors
% z.compType     = 'all';                                                                         % % group comparison type ["all"]: make all essenial comparisons,["gui"]: specify via GIO        
% z.simulate     = [0];                                                                           % % simulate output: [1]just show output; [1] write excelfiles                                   
% z.outputprefix = 'ga_';                                                                         % % prefix of resulting excelfile(s)                                                             
% z.addcounter   = [1];                                                                           % % add a counter to the filename-prefix                                                         
% xgroupassigfactorial(1,z);  
% ==============================================
%%   2-factors: select groups-comparisons via GUI 
% ===============================================
% z=[];
% z.groupfile   = 'F:\data6\victor\_test_groupsplit\groupassignmentFactorial_2factors.xlsx';     % % group-assignment file
% z.sheetIdx    = [1];                                                                             % % sheet number
% z.col_animal  = [1];                                                                             % % column index with ANIMAL-IDs
% z.col_group   = [2  3];                                                                          % % column inex/indices with groups/factors
% z.keepRowType = [3];                                                                             % % keep row Information: [1]no [2]keep old factors [3]keep all [4]keep all except of old factors
% z.compType     = 'gui';                                                                         % % group comparison type ["all"]: make all essenial comparisons,["gui"]: specify via GIO        
% z.simulate     = [0];                                                                           % % simulate output: [1]just show output; [1] write excelfiles                                   
% z.outputprefix = 'ga_';                                                                         % % prefix of resulting excelfile(s)                                                             
% z.addcounter   = [1];                                                                           % % add a counter to the filename-prefix                                                         
% xgroupassigfactorial(1,z); 
% ==============================================
%%   3-factors: create essential group-comparisons 
% ===============================================
% z=[];                                                                                                                                                                                            
% z.groupfile    = 'F:\data6\victor\_test_groupsplit\groupassignmentFactorial_3factors.xlsx';     % % group-assignment file                                                                        
% z.sheetIdx     = [1];                                                                           % % sheet number                                                                                 
% z.col_animal   = [1];                                                                           % % column index with ANIMAL-IDs                                                                 
% z.col_group    = [2  3  4];                                                                     % % column inex/indices with groups/factors                                                      
% z.keepRowType  = [3];                                                                           % % keep row Information: [1]no [2]keep old factors [3]keep all [4]keep all except of old factors
% z.compType     = 'all';                                                                         % % group comparison type ["all"]: make all essenial comparisons,["gui"]: specify via GIO        
% z.simulate     = [0];                                                                           % % simulate output: [1]just show output; [1] write excelfiles                                   
% z.outputprefix = 'ga_';                                                                         % % prefix of resulting excelfile(s)                                                             
% z.addcounter   = [1];                                                                           % % add a counter to the filename-prefix                                                         
% xgroupassigfactorial(0,z);  
% ==============================================
%%   3-factors: select groups-comparisons via GUI 
% ===============================================
% z=[];                                                                                                                                                                                            
% z.groupfile    = 'F:\data6\victor\_test_groupsplit\groupassignmentFactorial_3factors.xlsx';     % % group-assignment file                                                                        
% z.sheetIdx     = [1];                                                                           % % sheet number                                                                                 
% z.col_animal   = [1];                                                                           % % column index with ANIMAL-IDs                                                                 
% z.col_group    = [2  3  4];                                                                     % % column inex/indices with groups/factors                                                      
% z.keepRowType  = [3];                                                                           % % keep row Information: [1]no [2]keep old factors [3]keep all [4]keep all except of old factors
% z.compType     = 'gui';                                                                         % % group comparison type ["all"]: make all essenial comparisons,["gui"]: specify via GIO        
% z.simulate     = [0];                                                                           % % simulate output: [1]just show output; [1] write excelfiles                                   
% z.outputprefix = 'ga_';                                                                         % % prefix of resulting excelfile(s)                                                             
% z.addcounter   = [1];                                                                           % % add a counter to the filename-prefix                                                         
% xgroupassigfactorial(1,z);  


function xgroupassigfactorial(showgui,x)

% ==============================================
%%   PARAMETER-gui
% ===============================================

if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end

p={...
    'groupfile'      ''         'group-assignment file (Excel-file)'                                     'f'
    'sheetIdx'         [1]      'sheet number with animal-IDs and group-assignment/factors'              {1 2 3 4}
    'col_animal'       [1]      'column index with ANIMAL-IDs'                                           {1,2,3,4}
    'col_group'        [2]      'column index/indices with groups/factors'                               {2,'2 3','2 3 4'}
    'keepRowType'      [3]      'keep row Information: [1]no [2]keep old factors [3]keep all [4]keep all except of old factors'             {1 2 3 4}
    'compType'         'all'    'group comparison type ["all"]: make all essenial comparisons,["gui"]: specify comparisons via GIU'         {'all' 'gui'}
    'simulate'         [0]      'simulate output: [1]just show output, don''t write file; [1] write excelfiles '                            'b'
    'outputprefix'     'ga_'    'prefix of resulting excelfile(s)'                                      {'ga_' 'subgroups_' 'comps_'}
    'addcounter'       [1]      'add a numeric counter to the filename-prefix'                          'b'
    };


p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    %hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .5 .2 ],...
        'title',[mfilename],'info',{@uhelp, mfilename});
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%         if keepcolumnMode==1   % keep nothing else
%             cols=[];
%         elseif keepcolumnMode==2    % keep old factor-columns
%             cols=z.col_group;   
%         elseif keepcolumnMode==3    % everything
%             cols=setdiff(1:size(a,2),[z.col_animal  ]);
%         elseif keepcolumnMode==4    % everything but not old factor-columns
%             cols=setdiff(1:size(a,2),[z.col_animal z.col_group ]);
% ==============================================
%%
% ===============================================
% ==============================================
%%   BATCH
% ===============================================
% try
%     isDesktop=usejava('desktop');
% xmakebatch(z,p, mfilename,isDesktop)
%     if isExtPath==0
xmakebatch(z,p, mfilename);
%     else
%         xmakebatch(z,p, mfilename,['xcoreg' '(' num2str(isDesktop) ',z,mdirs);' ],pa);
%     end
% end

if 0
    %% ===============================================
    
    z=[];
    z.groupfile   = 'F:\data6\victor\_test_groupsplit\groupassignmentFactorial_121222_VGE.xlsx';     % % group-assignment file
    z.sheetIdx    = [1];                                                                             % % sheet number
    z.col_animal  = [1];                                                                             % % column index with ANIMAL-IDs
    z.col_group   = [2  3];                                                                          % % column inex/indices with groups/factors
    z.keepRowInfo = [1];                                                                             % % keep row Information
    xgroupassigfactorial(0,z);
    %% ===============================================
    
end

process(z);



% ==============================================
%%   process
% ===============================================
function process(z)

% ==============================================
%% check excelfile
% ===============================================
if exist(z.groupfile)~=2
    cprintf('*[1 0 .5]',['ERROR: groupfile does not exist ' '\n']);  
    return
end
[~,sheets]=xlsfinfo(z.groupfile);
try; sheets{z.sheetIdx};
catch
   cprintf('*[1 0 .5]',['ERROR: excel-sheet does not exist ' '\n']);  
end


[~,~,a0]=xlsread(z.groupfile);
ha=a0(1,:);
a =a0(2:end,:);
a=cellfun(@(a){[num2str(a)]} ,a ); %to string
idelrow=find(sum([strcmp(a(:,z.col_animal),'NaN') strcmp(a(:,z.col_group),'NaN')],2)>0);
a(idelrow,:)=[];%remove empty cells


%% ===============================================
q=struct();
% --get factors
q.factors =ha(z.col_group);
q.nfactors=length(q.factors);
%---get levels

ft=a(:,z.col_group);
ft=regexprep(ft,'[^a-zA-Z0-9_]',''); %remove special characters

levelnames={};
for i=1:size(ft,2)
    levelnames{1,i}=unique(ft(:,i),'stable');
end
if q.nfactors==1
    combs=levelnames{1};
elseif q.nfactors==2
    combs=allcomb(levelnames{1},levelnames{2});
elseif q.nfactors==3   ;
    combs=allcomb(levelnames{1},levelnames{2},levelnames{3});
else
    error('more than 3 factors currently not supported');
end

% check existence of these combinations
combname={};
ivalid=[];
for i=1:size(combs,1)
    thiscomb=combs(i,:);
    if length(thiscomb)==1
        ix=find(strcmp(ft(:,1),thiscomb(1)));
    elseif length(thiscomb)==2
        ix=find(strcmp(ft(:,1),thiscomb(1)) & strcmp(ft(:,2),thiscomb(2)));
    elseif length(thiscomb)==3
        ix=find(strcmp(ft(:,1),thiscomb(1)) & strcmp(ft(:,2),thiscomb(2)) & strcmp(ft(:,3),thiscomb(3)));
    end
    if ~isempty(ix)
        if length(thiscomb)==1
            combname(end+1,:)= {['[' strjoin(ft(ix(1),:), '][') ']']};%ft(ix(1),1)
        else
            combname(end+1,:) ={['[' strjoin(ft(ix(1),:), '][') ']']};% {strjoin(ft(ix(1),:), '-')};
        end
        ivalid(i,1)=i;
    end
end
combs=combs(ivalid,:);
levelnames={};
levelnum={};
for i=1:size(combs,2)
    levelnames{1,i}=unique(combs(:,i),'stable');
    levelnum{1,i}  =1:length(levelnames{1,i});
end

q.groupcombs =combname;
q.combs      =combs;
q.levelnames =levelnames;
q.levelnum   =levelnum;

% ---------
z.a  =a;
z.ha =ha;

if strcmp(z.compType,'all')
   [w]=getGroupComb_essential(z,q);
elseif strcmp(lower(z.compType),'gui')
   [w]=getGroupComb_viaGUI(z,q); 
end

if isempty(w);
    disp('...no selection was made...abort process...');
    return
end

%% ====simulate show results ==============================
if z.simulate==1
    cprintf('*[0 0 1]',['Simulate output only... ' '\n']);
    uhelp([w.log; repmat({' '},[5 1])],0,'name','new comparisons');
end
%% ==== Write excelfile ===========================================
if isempty(z.outputprefix)
    z.outputprefix='ga_';
end

 cnt=1;
try % update counter if path contains some files allready with counter-prefix
    [pa fis ext]=fileparts(z.groupfile);
    [files] = spm_select('List',pa,z.outputprefix);
    files=cellstr(files);
    if ~isempty(char(files))
        cnt=str2num(regexprep(files{end},{z.outputprefix, '#.*'},{''}))+1;
    else
        cnt=1;
    end
catch
    cnt=1;
end

%% ===============================================
counterstr='';
if z.simulate==0
    cprintf('*[0 0 1]',['write Excel-files...wait... ' '\n']);
    [pa fis ext]=fileparts(z.groupfile);
    g=w.g;
    for i=1:size(g,1)
        newlab=unique(g{i,3}(:,2),'stable');
        name=strjoin(newlab,'__VS__');
        
        if z.addcounter==1
            %z.outputprefix=regexprep(z.outputprefix,'_$','');
            counterstr=['' pnum(cnt,2) '#'];
            cnt=cnt+1;
        end
        
        fname=[ z.outputprefix counterstr name  '.xlsx'];
        if 1
            F1=fullfile(pa,fname);
            pwrite2excel(F1,{1 'group'},g{i,4},{},g{i,3});
            %showinfo2('fileTXT: ',F1);
            %colorize groups
            igr1=find(strcmp(g{i,3}(:,2),newlab{1}))+1;
            xlscolorizeCells(F1,'group',['[' num2str(igr1(:)') '],[2]'],[0.8941    0.9412    0.9020] );
            igr2=find(strcmp(g{i,3}(:,2),newlab{2}))+1;
            xlscolorizeCells(F1,'group',['[' num2str(igr2(:)') '],[2]'],[1.0000    0.9490    0.8667] );
            showinfo2('fileTXT:',F1);
        end
    end
    cprintf('*[0 0 1]',['DONE! ' '\n']);
    
end


%% ===============================================


function w=getGroupComb_essential(z,q)
% ==============================================
%%   faactorwise comparisons (contrasts)
% ===============================================
cons={};
for i=1:size(q.levelnum,2)
    lev=q.levelnum{i};
    con=allcomb(lev,lev);
    con(con(:,2)<=con(:,1),:)=[];
    levs=q.levelnames{i};
    for j=1:size(con,1)
     cons(end+1,:) = [ {i}  levs(con(j,1)) levs(con(j,2))  ] ;   
    end
end
% cons

% ==============================================
%   full...all combinations
% ===============================================
% if 0
%     if size(q.levelnum,2)==2
%         comb=allcomb(q.levelnum{1},q.levelnum{2});
%     end
%     cons2={};
%     for i=1:size(comb,1)
%         thiscomb=comb(i,:);
%         combx={};
%         combx{1}=1:length(thiscomb);
%         for j=1:length(thiscomb)
%             combx{1,end+1}= q.levelnames{j}{thiscomb(j)};
%         end
%         cons2=[cons2; combx];
%         
%     end
%     
%     cons2
% end


% ==============================================
%%    obtain data
% ===============================================
a =z.a;
ha=z.ha;
% t=[cons;cons2];
t=cons;
lg={};
g2={};
for i=1:size(t,1)
    r=t(i,:);
    fcol=r{1};
    compstr=r(2:end);
    grpstr1=compstr{1};
    grpstr2=compstr{2};
    
    if length(fcol)~=length(compstr)
        fcol=repmat(fcol,[1 length(compstr)]);
    end
    v=[];
    v0=strcmp(  a(:, z.col_group(fcol(1)) )  ,  compstr{1}  );
    ix1=find(sum(v0,2)>0);
    v0=strcmp(  a(:, z.col_group(fcol(2)) )  ,  compstr{2}  );
    ix2=find(sum(v0,2)>0);
    
    conname=strjoin(compstr, '_');
    
    keepcolumnMode=3;  
    if keepcolumnMode==1   % keep nothing else
        cols=[];
    elseif keepcolumnMode==2    % keep old factor-columns
        cols=z.col_group;
        
    elseif keepcolumnMode==3    % everything
        cols=setdiff(1:size(a,2),[z.col_animal  ]);
        
    elseif keepcolumnMode==4    % everything but not old factor-columns
        cols=setdiff(1:size(a,2),[z.col_animal z.col_group ]);
    end
    
    
   % cols=setdiff([ z.col_animal z.col_group],[z.col_animal ]);
    c1=[  a(ix1,z.col_animal)  repmat({grpstr1},[length(ix1) 1])   a(ix1,cols)];
    c2=[  a(ix2,z.col_animal)  repmat({grpstr2},[length(ix2) 1])   a(ix2,cols)];
    hc=[  ha(z.col_animal)  'group'     ha(cols)];
    
    lg(end+1,:)={[ ' #gy ______comparison-[' num2str(i)  ']_________']};
     lg(end+1,:)={[ ' #km group-' num2str(1) ':' grpstr1 ]};
     lg(end+1,:)={[ ' #km group-' num2str(2) ':' grpstr2 ]};
        
     
     hd=hc;
     d=[c1;c2];
     %      lg=[lg; e(i).g{j}];
     dx=plog([],[hd;[d]],0,'e','al=1;plotlines=0' );
     lg=[lg; dx];
     
     %---excelfile------
     g2(i,:)=[grpstr1 grpstr2 {d} {hd}];
    
end

w.g  =g2;
w.log=lg;

% disp(char(lg));


function [w]=getGroupComb_viaGUI(z,q); 
w=[];
% ==============================================
%%   specific GUI
% ===============================================
groupcombs=q.groupcombs;
o=specificgroupsGUI(groupcombs,struct('iswait',1));
if isempty(o)
   return 
end
spec=o;
% ==============================================
%%   specific tests
% ===============================================

%% ============test ===================================

if 0
    spec={};
    if 1 % Tests
        if length(z.col_group)==1
            spec(1,:)={q.groupcombs(1:2) q.groupcombs(3:4)};
            spec(2,:)={q.groupcombs(4) q.groupcombs(1:3)};
        elseif length(z.col_group)==2
            spec(1,:)={q.groupcombs(1:3) q.groupcombs(4:6)};
            spec(1,:)={q.groupcombs(1:3) q.groupcombs(7:end)};
            
        elseif   length(z.col_group)==3
            spec(1,:)={q.groupcombs(1:3) q.groupcombs(7:8)};
            spec(2,:)={q.groupcombs(9) q.groupcombs(7:8)};
        end
    end
    
end
%% ============test-end ===================================
a =z.a;
ha=z.ha;

clear e
for i=1:size(spec,1) %each group-comparsion
    s=spec(i,:);
    
    lab={};
    for j=1:size(s,2) % for each group-combination A vs each group-combination-B
      s2=s{j};
      ixkeep=[];
      labc={};
      for k=1:size(s2,1) % for each combination/merging of groups
          s3=s2{k};
          ss=regexprep(s3,{'^[' ,']$'},{''});
          ss=strsplit(ss,'][');
          
          v=zeros( size(a,1) ,length(ss));
          for m=1:length(ss) %for each factor
             thislev=ss{m};
             faccol =z.col_group(m);
            v(:,m) =strcmp(a(:,faccol),thislev);
          end
          itemp=find(sum(v,2)==length(ss));
          ixkeep=[ixkeep; itemp];
          
          labc(k,:)=[ss];
      end
      lab{j}=labc;
      labnew='';
      for k=1:size(labc,2)
           unil=unique(labc(:,k));
           if length(unil)>1
              unil=strjoin(unil,'-');
           end
           labnew=[labnew '_' char(unil)];
      end
      labnew=labnew(2:end);
      
      e(i).lab{1,j} =labnew;
      e(i).g{1,j}   =s2;
      e(i).rows{1,j}=ixkeep;
      
    end%j
    %% ===============================================
    
    
    %----shorter labnames..remove redundancies
    l1=lab{1};
    l2=lab{2};
    
    if size(l1,1)>1 && size(l2,1)>1
        ln1={};
        ln2={};
        for kk=1:size(l1,2)
            res=setdiff(l1(:,kk),l2(:,kk));
            if ~isempty(res)
                ln1(1:length(res),end+1)=res;
            end
            res=setdiff(l2(:,kk),l1(:,kk));
            if ~isempty(res)
                ln2(1:length(res),end+1)=res;
            end
        end
        
        if 0
            disp('---l1---');
            disp(l1);
            disp('---l2---');
            disp(l2);
            disp('---ln1---');
            disp(ln1);
            disp('---l2---');
            disp(ln2);
        end
        if ~isempty(ln1) && ~isempty(ln2)
            lx1={};
            for kk=1:size(ln1,2)
                lx1{1,kk}=strjoin(ln1(:,kk),'-');
            end
            lx1=strjoin(lx1,'_');
            lx2={};
            for kk=1:size(ln2,2)
                lx2{1,kk}=strjoin(ln2(:,kk),'-');
            end
            lx2=strjoin(lx2,'_');
            
            e(i).lab{1,1} =   lx1;
            e(i).lab{1,2} =   lx2;
        end
    end
    
    if 0
        disp('---e---');
        disp(e(i).lab{1,1});
        disp('---e2---');
        disp(e(i).lab{1,2});
    end
%    'a'     
%   return
    %% ===============================================
    
    %-------------------
    
    
end

% a(ixkeep,[z.col_animal z.col_group])
% ==============[check]=================================
%% ===============================================

keepcolumnMode=2 ;
lg={};
g={};
for i=1:length(e)
    lg(end+1,:)={[ ' #gy ______comparison-[' num2str(i)  ']_________']};
    for j=1:2
        lg(end+1,:)={[ ' #km group-' num2str(j) ':' ]};
        lg=[lg; e(i).g{j}];
    end
    lg(end+1,:)={[ '   ']};
    da={}; grplabel={};
    for j=1:2
        lg(end+1,:)={[ ' #kc  DATA: group-' num2str(j) ':' ]};
        irows=e(i).rows{j};
        d1=a(irows,[z.col_animal   ]);
        d2=repmat(e(i).lab(j), [length(irows)  1]);
        
        
        if keepcolumnMode==1   % keep nothing else
            cols=[];
        elseif keepcolumnMode==2    % keep old factor-columns
            cols=z.col_group;   
        elseif keepcolumnMode==3    % everything
            cols=setdiff(1:size(a,2),[z.col_animal  ]);
        elseif keepcolumnMode==4    % everything but not old factor-columns
            cols=setdiff(1:size(a,2),[z.col_animal z.col_group ]);
        end
        
        d3=a(irows,[               cols]);
        d=[d1 d2 d3];
        
        hd1=ha([z.col_animal ]);
        hd2= 'group' ;
        hd3=ha(cols);
        hd=[hd1 hd2 hd3];
        
        
        dx=plog([],[hd;[d]],0,'e','al=1;plotlines=0' );
        lg=[lg; dx];
        % for excelfile ____
        da=[da; d];
        grplabel{1,j}=d{1,2};
    end
    g(i,:)=[grplabel {da} {hd}]; 
end

%  disp(char(lg))


%  uhelp(lg,1)
w.g  =g;
w.log=lg;


