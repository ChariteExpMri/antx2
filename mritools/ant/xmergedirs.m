

% function to merge the  contents of pairwise assigned directories 
% a dir-to-dir pre-assignend is done but must be visually inspected and corrected, otherwise ...big drama
% the merged date will be saved in a new target directory or the input directory
%
% #wo PARAMETER
% maindir1  : - select main folder-1 via gui. This dir contains subdirs that should be merged.
% maindir2  : - select main folder-2 via gui. This dir contains subdirs that should be merged.                
%  
% dirs1     : - use {'all'} to use all subdirs or select specific subdirs of folder-1 via gui
% dirs2     : - use {'all'} to use all subdirs or select specific subdirs of folder-2 via gui               
%     
% assigndirs: - here the dir-to-dir assignment is made-->this assignment is made via GUI, see help there 
% copyrest  : - [0|1]  copy all other,unassigned directories, if [1] additionally all other dirs will be copied (but see outdirName)
% copymode  : - specifies the target path: either 
%                '@1 - copy to outdirMain'  : copy to new targt directory..specified in outdirMain
%                '@2 - copy dirs1-to-dirs2' : copy folders of dirs1 to dirs2/or at the same level as dirs2 
%                or
%                '@3 - copy dirs2-to-dirs1' : copy folders of dirs2 to dirs1/or at the same level as dirs1
%             - selection is equivalent to '@1','@2' and '@3',respectively
% outdirMain: - specifies the output main folder, this is only valid if copymode is set to '@1' or '@1 - copy to outdirMain' (both equivalent)
%             - otherwise leave empty
% outdirName: - specifies the outdir-names: either : 
%                  '@1 - names of dirs-1'   : use names of dirs1         
%                  or 
%                  '@2 - names of dirs-2'    : use names of dirs2
%              - selection is equivalent to '@1' and '@2',respectively  
%              (1) if outdirMain is given and copymode is set to '@1'/'@1 - copy to outdirMain' the outdirName specifies whether 
%                  to take the dir-names of dir1 or dir2 as new dir-names
%              (2) additionally outdirName specifies the un-assigned dirs that should be copied (copyrest is set to [1])
%              (3) if copymode is set to @2 or @3 outdirName is not used!
%
% #wo RUN function 
% -runs without an open ANTX-project
% use
% xmergedirs  or xmergedirs(1); %      open gui
% xmergedirs(1,z); open gui with parameter settings
% xmergedirs(1,z,pa); %additionally with a path (pa) to some data to improve navigation
% xmergedirs(1,[],pa); % same but without parameters
% #wo History
%  after running type anth or char(anth) or uhelp(anth) to get the parameter
% ==============================================================================================================================               
% #wo EXAMPLES
%% EXAMPLE-1 : compare all dirs in maindir1 and maindir2
%% assigndirs is a table with the dir-to-dir assignment (separator between corresponding dirs is "@@" )
%% targetfolder is a new directoy (see z.outdirMain, z.copymode has to be selected properly)
%% [z.copyrest] is set to [1]: thus all other folders of dirs-1 (depending on z.outdirName)  will be additionally copied to the target folder
% z=[];                                                                                                          
% z.maindir1   = { 'O:\data4\test_mergeDirs\out' };                          % % select main folder-1            
% z.maindir2   = { 'O:\data4\test_mergeDirs\out_ct' };                       % % select main folder-2            
% z.dirs1      = { 'all' };                                                  % % select folders of folder-1      
% z.dirs2      = { 'all' };                                                  % % select folders of folder-2      
% z.assigndirs = { 'Max_SP18_075M_wt @@ SPECT_CT_0075_wt_original_BL'        % % assign directories              
%                  'Max_SP18_076M_wt @@ SPECT_CT_0076_wt_original_BL'                                            
%                  'Max_SP18_078M_tg @@ SPECT_CT_0078_tg_original_BL'                                            
%                  'Max_SP18_079M_tg @@ SPECT_CT_0079_tg_original_BL' };                                         
% z.copyrest   = [1];                                                        % % copy also unassigned directories
% z.copymode   = '@1 - copy to outdirMain';                                  % % select copy modus               
% z.outdirMain = 'O:\data4\test_mergeDirs\merge';                            % % output MAIN folder              
% z.outdirName = { '@1 - names of dirs-1' };                                 % % select output folder name,      
% xmergedirs(1,z);                                                                                                 
%     
%% EXAMPLE-2:  same as Example-1, but this time dirs will be written in "dirs-1": z.copymode is set to "@3 - copy dirs2-to-dirs1"
%
% z=[];                                                                                                          
% z.maindir1   = { 'O:\data4\test_mergeDirs\out' };                          % % select main folder-1            
% z.maindir2   = { 'O:\data4\test_mergeDirs\out_ct' };                       % % select main folder-2            
% z.dirs1      = { 'all' };                                                  % % select folders of folder-1      
% z.dirs2      = { 'all' };                                                  % % select folders of folder-2      
% z.assigndirs = { 'Max_SP18_075M_wt @@ SPECT_CT_0075_wt_original_BL'        % % assign directories              
%                  'Max_SP18_076M_wt @@ SPECT_CT_0076_wt_original_BL'                                            
%                  'Max_SP18_078M_tg @@ SPECT_CT_0078_tg_original_BL'                                            
%                  'Max_SP18_079M_tg @@ SPECT_CT_0079_tg_original_BL' };                                         
% z.copyrest   = [1];                                                        % % copy also unassigned directories
% z.copymode   = '@3 - copy dirs2-to-dirs1';                                 % % select copy modus               
% z.outdirMain = '';                                                        % % output MAIN folder              
% z.outdirName = { '@1 - names of dirs-1' };                                 % % select output folder name,      
% xmergedirs(1,z);     
%     
%% EXAMPLE-3: specify subdirs in maindir1/maindir2
% z=[];                                                                                                                                                     
% z.maindir1   = { 'O:\data4\test_mergeDirs\out_ct' };                                  % % select main folder-1 (this dir contains other dirs)             
% z.maindir2   = { 'O:\data4\test_mergeDirs\out' };                                     % % select main folder-2 (this dir contains other dirs)             
% z.dirs1      = { 'O:\data4\test_mergeDirs\out_ct\SPECT_CT_0075_wt_original_BL'        % % select m-folders of folder-1                                    
%                  'O:\data4\test_mergeDirs\out_ct\SPECT_CT_0076_wt_original_BL'                                                                            
%                  'O:\data4\test_mergeDirs\out_ct\SPECT_CT_0078_tg_original_BL'                                                                            
%                  'O:\data4\test_mergeDirs\out_ct\SPECT_CT_0079_tg_original_BL' };                                                                         
% z.dirs2      = { 'O:\data4\test_mergeDirs\out\Max_SP18_075M_wt'                       % % select m-folders of folder-2                                    
%                  'O:\data4\test_mergeDirs\out\Max_SP18_076M_wt'                                                                                           
%                  'O:\data4\test_mergeDirs\out\Max_SP18_077M_wt'                                                                                           
%                  'O:\data4\test_mergeDirs\out\Max_SP18_078M_tg'                                                                                           
%                  'O:\data4\test_mergeDirs\out\Max_SP18_079M_tg'                                                                                           
%                  'O:\data4\test_mergeDirs\out\Max_SP18_080M_wt'                                                                                           
%                  'O:\data4\test_mergeDirs\out\Max_SP18_081M_tg'                                                                                           
%                  'O:\data4\test_mergeDirs\out\Max_SP18_083M_tg' };                                                                                        
% z.assigndirs = { 'SPECT_CT_0075_wt_original_BL @@ Max_SP18_075M_wt'                   % % assign directories->using GUI                                   
%                  'SPECT_CT_0076_wt_original_BL @@ Max_SP18_076M_wt'                                                                                       
%                  'SPECT_CT_0078_tg_original_BL @@ Max_SP18_078M_tg'                                                                                       
%                  'SPECT_CT_0079_tg_original_BL @@ Max_SP18_079M_tg' };                                                                                    
% z.copyrest   = [1];                                                                   % % copy all other unassigned directories                           
% z.copymode   = '@1 - copy to outdirMain';                                             % % select TARGET copy mode {@1,@2,@3}                              
% z.outdirMain = 'O:\data4\test_mergeDirs\merge';                                       % % output MAIN folder                                              
% z.outdirName = '@2 - names of dirs-2';                                                % % select output folder name (only used if outdirMain is defined), 
% xmergedirs(1,z);  



function xmergedirs(showgui,x,pa)
  

if 0
    
 
    
%% EXAMPLE-1
z=[];                                                                                                          
z.maindir1   = { 'O:\data4\test_mergeDirs\out' };                          % % select main folder-1            
z.maindir2   = { 'O:\data4\test_mergeDirs\out_ct' };                       % % select main folder-2            
z.dirs1      = { 'all' };                                                  % % select folders of folder-1      
z.dirs2      = { 'all' };                                                  % % select folders of folder-2      
z.assigndirs = { 'Max_SP18_075M_wt @@ SPECT_CT_0075_wt_original_BL'        % % assign directories              
                 'Max_SP18_076M_wt @@ SPECT_CT_0076_wt_original_BL'                                            
                 'Max_SP18_078M_tg @@ SPECT_CT_0078_tg_original_BL'                                            
                 'Max_SP18_079M_tg @@ SPECT_CT_0079_tg_original_BL' };                                         
z.copyrest   = [1];                                                        % % copy also unassigned directories
z.copymode   = '@1 - copy to outdirMain';                                  % % select copy modus               
z.outdirMain = 'O:\data4\test_mergeDirs\merge';                            % % output MAIN folder              
z.outdirName = { '@1 - names of dirs-1' };                                 % % select output folder name,      
xmergedirs(1,z);                                                                                                 
    
%% EXAMPLE-2
z=[];                                                                                                          
z.maindir1   = { 'O:\data4\test_mergeDirs\out' };                          % % select main folder-1            
z.maindir2   = { 'O:\data4\test_mergeDirs\out_ct' };                       % % select main folder-2            
z.dirs1      = { 'all' };                                                  % % select folders of folder-1      
z.dirs2      = { 'all' };                                                  % % select folders of folder-2      
z.assigndirs = { 'Max_SP18_075M_wt @@ SPECT_CT_0075_wt_original_BL'        % % assign directories              
                 'Max_SP18_076M_wt @@ SPECT_CT_0076_wt_original_BL'                                            
                 'Max_SP18_078M_tg @@ SPECT_CT_0078_tg_original_BL'                                            
                 'Max_SP18_079M_tg @@ SPECT_CT_0079_tg_original_BL' };                                         
z.copyrest   = [1];                                                        % % copy also unassigned directories
z.copymode   = '@3 - copy dirs2-to-dirs1';                                 % % select copy modus               
z.outdirMain = '';                                                        % % output MAIN folder              
z.outdirName = { '@1 - names of dirs-1' };                                 % % select output folder name,      
xmergedirs(1,z);     
    
%% EXAMPLE-3
z=[];                                                                                                                                                     
z.maindir1   = { 'O:\data4\test_mergeDirs\out_ct' };                                  % % select main folder-1 (this dir contains other dirs)             
z.maindir2   = { 'O:\data4\test_mergeDirs\out' };                                     % % select main folder-2 (this dir contains other dirs)             
z.dirs1      = { 'O:\data4\test_mergeDirs\out_ct\SPECT_CT_0075_wt_original_BL'        % % select m-folders of folder-1                                    
                 'O:\data4\test_mergeDirs\out_ct\SPECT_CT_0076_wt_original_BL'                                                                            
                 'O:\data4\test_mergeDirs\out_ct\SPECT_CT_0078_tg_original_BL'                                                                            
                 'O:\data4\test_mergeDirs\out_ct\SPECT_CT_0079_tg_original_BL' };                                                                         
z.dirs2      = { 'O:\data4\test_mergeDirs\out\Max_SP18_075M_wt'                       % % select m-folders of folder-2                                    
                 'O:\data4\test_mergeDirs\out\Max_SP18_076M_wt'                                                                                           
                 'O:\data4\test_mergeDirs\out\Max_SP18_077M_wt'                                                                                           
                 'O:\data4\test_mergeDirs\out\Max_SP18_078M_tg'                                                                                           
                 'O:\data4\test_mergeDirs\out\Max_SP18_079M_tg'                                                                                           
                 'O:\data4\test_mergeDirs\out\Max_SP18_080M_wt'                                                                                           
                 'O:\data4\test_mergeDirs\out\Max_SP18_081M_tg'                                                                                           
                 'O:\data4\test_mergeDirs\out\Max_SP18_083M_tg' };                                                                                        
z.assigndirs = { 'SPECT_CT_0075_wt_original_BL @@ Max_SP18_075M_wt'                   % % assign directories->using GUI                                   
                 'SPECT_CT_0076_wt_original_BL @@ Max_SP18_076M_wt'                                                                                       
                 'SPECT_CT_0078_tg_original_BL @@ Max_SP18_078M_tg'                                                                                       
                 'SPECT_CT_0079_tg_original_BL @@ Max_SP18_079M_tg' };                                                                                    
z.copyrest   = [1];                                                                   % % copy all other unassigned directories                           
z.copymode   = '@1 - copy to outdirMain';                                             % % select TARGET copy mode {@1,@2,@3}                              
z.outdirMain = 'O:\data4\test_mergeDirs\merge';                                       % % output MAIN folder                                              
z.outdirName = '@2 - names of dirs-2';                                                % % select output folder name (only used if outdirMain is defined), 
xmergedirs(1,z);  

end


%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=[]  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end

p={...
    'inf1'      '••• mergedirs     •••             '                         '' ''
    'maindir1'      {''}                     'select main folder-1 (this dir contains other dirs)'         {@selectDir,pa}
    'maindir2'      {''}                     'select main folder-2 (this dir contains other dirs)'         {@selectDir,pa}                   
 
    'dirs1'      {'all'}                     'select m-folders of folder-1'    {@selectDir2,1}
    'dirs2'       {'all'}                    'select m-folders of folder-2'   {@selectDir2,2}
    
    
    'assigndirs'    {''}                     'assign directories->using GUI'      {@assignDirs}  
    'copyrest'      1                        'copy all other unassigned directories'    'b'
    'copymode'      '@1 - copy to outdirMain'      'select TARGET copy mode {@1,@2,@3}'   {'@1 - copy to outdirMain' '@2 - copy dirs1-to-dirs2' '@3 - copy dirs2-to-dirs1'}
    'outdirMain'    {''}                'output MAIN folder'   {@selectoutdirMain,pa}
    'outdirName'    {'@1 - names of dirs-1'}                'select output folder name (only used if outdirMain is defined), '   {'@1 - names of dirs-1','@2 - names of dirs-2'}
    };

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .5 .3 ],...
        'title',['***'  mfilename '***'],'info',{@uhelp,[ mfilename '.m']});
    try
    fn=fieldnames(z);
    catch
       return 
    end
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

xmakebatch(z,p, mfilename);
process(z);



function assignDirs( e)
 out='';
 [v v2]=paramgui('getdata');
 dir1=char(v2.maindir1 );
 dir2=char(v2.maindir2 );
 
% dir1='I:\Oelschlegel\antx_ct\out_ct'
% dir2='I:\Oelschlegel\antx_ct\out'


[fi1,di1] = spm_select('list',dir1,'.*')    ;
[fi2,di2] = spm_select('list',dir2,'.*')    ;
di1=cellstr(di1);
di2=cellstr(di2);

if strcmp(char(v2.dirs1),'all')==0
    dum=cellstr(v2.dirs1);
    di1={};
    for i=1:length(dum)
        [p0 mdir]=fileparts(dum{i});
        di1(i,1)={mdir};
    end
end
if strcmp(char(v2.dirs2),'all')==0
    dum=cellstr(v2.dirs2);
    di2={};
    for i=1:length(dum)
        [p0 mdir]=fileparts(dum{i});
        di2(i,1)={mdir};
    end
end



mx=  [ size(di1,1) size(di2,1) ] ;
imx=find(mx==max(mx));

flip=0;
if length(imx)==2
    d1=di1; d2=di2;     dp1=dir1; dp2=dir2;
else
  if imx==1
       d1=di2; d2=di1;     dp1=dir2; dp2=dir1;
       flip=1;
  else
       d1=di1; d2=di2;     dp1=dir1; dp2=dir2;
  end
end


%% xxx
ID=1:length(d2);

tb={};
for i=1:size(d1)
   %disp('--------------------------');
    [id,dis]=strnearest(d1{i},d2);
%     disp([id dis]);
  
   % disp(['mach: ' d1{i} ' with: ']);
    for j=1%:length(id)
       % disp(d2(id(j)));
        if j==1
            tb(end+1,:)={    d1{i}  d2{id(j)}     logical(1) id(j)  '-' };
        else
            tb(end+1,:)={     ''    d2{id(j)}   logical(0)    id(j)  '' };
        end
    end

end

% imis=setdiff(ID,cell2mat(tb(:,4)))
% tb(end+1,:)={   ''  ' *** other files in Dir-2 ***'       []   []  [] }
% for i=1:length(imis)
%    tb(end+1,:)={     ''    d2{imis(i)}   'rr'    imis(i)  [] } 
% end






%%  run
 close(findobj(0,'tag','dirassign'));
f=figure;
set(gcf,'units','norm','tag','dirassign');
set(gcf,'position',[ 0.1714    0.5157    0.4740    0.3889]);
set(gcf,'menubar' ,'none');

% Column names and column format
space=repmat(' ',[1 50]);
columnname = {  [ 'DIR-1' space], ['DIR-2' space ]    ['assign'  ]   'ID'  };
columnformat = { 'char'  ['-';d2]'    'logical',  'char'   };

% Define the data
 

% Create the uitable
t = uitable('Data', tb(:,1:4),... 
            'ColumnName', columnname,...
            'ColumnFormat', columnformat,...
            'ColumnEditable', [false true  true false    ],...
            'RowName',[]);

% Set width and height
t.Position(3) = t.Extent(3);
t.Position(4) = t.Extent(4);    

set(t,'units','norm')
set(t,'position',[0 0.05  1 .9]);

%% other

h=uicontrol('style','pushbutton','units','norm');
set(h,'position',[0 0 .1 .05],'string','ok','tag','xok','callback',@xok);

h=uicontrol('style','pushbutton','units','norm');
set(h,'position',[0.1 0 .1 .05],'string','cancel','tag','xcancel','callback',@xcancel);

h=uicontrol('style','pushbutton','units','norm');
set(h,'position',[0.2 0 .1 .05],'string','help','tag','xhelp','callback',@xhelp);


us.dummy=1;
us.t=t;
us.dp1=dp1;
us.dp2=dp2;
us.dir1=dir1;
us.dir2=dir2;
us.d1=d1;
us.d2=d2;
us.flip=flip;

 set(gcf,'userdata',us);
uiwait(gcf);

function xhelp(e,e2)
% uhelp([mfilename '.m']);
%% help
l={''};
l{end+1,1}=[' #by select dir-to-dir assignment here'];
l{end+1,1}=[''];
l{end+1,1}=[' #b EXPLANATION'];
l{end+1,1}=[' - folders of [DIR-1] should match folders of [DIR-2]'];
l{end+1,1}=[' - use pulldown menu from respective cell of [DIR-2] column in case of a mismatch'];
l{end+1,1}=[' - use checkbox [assign]-column: - [x] for considering this directory of [DIR-1] as merging directories'];
l{end+1,1}=['                                 - [ ] to exclude this directory of [DIR-1] from merging'];
l{end+1,1}=['  #r NOTE: Only folders with [x] in the assign-column will be considered.'];
l{end+1,1}=['  #wr NOTE-2: THECK DIRECTORY CORRESPONDENCE CAREFULLY !!!'];

uhelp(l);
%% bla

function xok(e,e2)
uiresume(gcf);
us=get(gcf,'userdata');

d=get(us.t,'data');

im=regexpi2(cellfun(@(a){[num2str(a)]}, d(:,3) ),'1');


% id2=cell2mat(d(im,4));
% id2nonna=cell2mat(d(im,5));
% id2(find(~isnan(id2nonna)))   = id2nonna(find(~isnan(id2nonna)));
% d2=us.d2(id2);
d2=d(im,2);

d1={};
for i=1:length(im)
    w='';
    n=0;
    while isempty(w)
        w=d{im(i)-n,1};
        n=n+1;
    end
    d1{i,1}=w;
end

dm={};
sep=' @@ ';
for i=1:size(d1)
    if us.flip == 0
    dm{i,1}=[ d1{i}  sep  d2{i} ];
    else
     dm{i,1}=[ d2{i} sep  d1{i} ];   
    end
end

figure(findobj(0,'tag','paramgui'));

% close()
close(findobj(0,'tag','dirassign'));
paramgui('setdata','x.assigndirs',[dm]');

function xcancel(e,e2)
uiresume(gcf);
close(findobj(0,'tag','dirassign'));

return;



function out=selectoutdirMain(pa)
out='';

[v v2]=paramgui('getdata');
if ~isempty( (char(v2.maindir1)))
    px=fileparts(v2.maindir1{1});
else
    if isempty(pa)
        px=pwd;
    else
        px=char(pa);
    end
end
out=uigetdir(px, 'Pick a Directory for output');

function out=selectDir(pa)
out='';

% return
if isempty(pa)
    px=pwd;
else
    px=char(pa);
end
% px='I:\Oelschlegel\antx_ct\MRs_Bruker_original';
[t,sts] = spm_select(inf,'dir','select folders with dicoms','', px,'.*','');
if isempty(t);out=''; return; end

t=cellstr(t);
% for i=1:length(t)
%     [pa fi ext]=fileparts(t{i});
%     t{i}=pa;
% end
out=t;
return
% paramgui('setdata','x.dirs',t)

function out=selectDir2(pa)
out='';
[v v2]=paramgui('getdata');
if pa==1
    px=char(v2.maindir1);
else
    px=char(v2.maindir2);
end
    [t,sts] = spm_select(inf,'dir','select mouse folders','', px,'.*','');
%  return    
t=cellstr(t);
% for i=1:length(t)
%     [pa fi ext]=fileparts(t{i});
%     t{i}=pa;
% end
out=t;

 

 
 


%=========================================================================

function process(z)

% keyboard
warning off
if isempty(z.assigndirs)
    disp('no dirs assigned..process canceled');
    return
end

    
for i=1:size(z.assigndirs,1)
    [dv(i,:) ]=strsplit(z.assigndirs{i},' @@ '); %mdirs
end



fp(:,1)=cellfun(@(a){[char(z.maindir1) filesep a]},  dv(:,1));%fullpath
fp(:,2)=cellfun(@(a){[char(z.maindir2) filesep a]},  dv(:,2));

if ~isempty(regexpi(z.copymode,'@1'))
    outdir=char(z.outdirMain); mkdir(outdir);
    mode=1;
     if ~isempty(regexpi(z.outdirName,'@1'))
        mdirname=1;
    else
        mdirname=2;
     end
     fp(:,3)=strrep( fp(:,mdirname), fileparts(fp{1,mdirname})  ,outdir);
     dv(:,3)=dv(:,mdirname);
    modetag='copy to new main directory';
     
elseif ~isempty(regexpi(z.copymode,'@2'))
    outdir=  char(z.maindir2);
    mode=2;
    mdirname=1;
    fp(:,3)=fp(:,2);
    dv(:,3)=dv(:,2);
    modetag='dirs1-to-dirs2';
elseif ~isempty(regexpi(z.copymode,'@3'))
    outdir=  char(z.maindir1);
    mode=3;
    mdirname=2;
    fp(:,3)=fp(:,1);
    dv(:,3)=dv(:,1);
    modetag='dirs2-to-dirs1';
end

 
%% copyign files

disp(['## merging assigned DIRS: [MODE]: ' modetag, ' [copyunassigned DIRS]: ' num2str(z.copyrest) ]);
for i=1:size(dv,1)
    
    mdir=dv{i,3} ;
    if exist(fp{i,3})~=7
        mkdir(fp{i,3});
    end
    
    lg={};
    
    disp([ '.. copying ' num2str(i) '/' num2str(size(dv,1)) ' ...' ]);
    
    if mode~=3
        dum=fp{i,1};
        [f,d] = spm_select('FPListRec',dum,'.*');
        f=cellstr(f);
        d=cellstr(d);
        
        if ~isempty(d);
            dn=strrep(d,  dum, fp{i,3});
            for j=1:length(dn)
                mkdir(dn{j});
            end
        end
        fn=strrep(f,  dum, fp{i,3});
        copyfilem(f,fn);
        lg(end+1,1)={['source: ' dum]};
    end
    
    
    if mode~=2
        dum=fp{i,2};
        [f,d] = spm_select('FPListRec',dum,'.*');
        f=cellstr(f);
        d=cellstr(d);
        
        if ~isempty(d);
            dn=strrep(d,  dum, fp{i,3});
            for j=1:length(dn)
                mkdir(dn{j});
            end
        end
        fn=strrep(f,  dum, fp{i,3});
        copyfilem(f,fn);
        lg(end+1,1)={['source: ' dum]};
    end
    
    pwrite2file(fullfile(fp{i,3},'_source.txt'), lg  );
    
    disp(char(lg));
    disp(['target: ' fp{i,3}]);
    
end

disp('### see info in "_source.txt"-file in target-folder');

 


%% copying unassigned directoriest
if z.copyrest==1
    fpdone=fp(:,mdirname);
    done=strrep(fpdone,[fileparts(fpdone{1}) filesep],'');
    
    if mdirname==1
       fx=z.dirs1;
       dm=char(z.maindir1);
    else
       fx=z.dirs2 ;
       dm=char(z.maindir2);
    end
    
   fx=cellstr(fx);
    if length(fx)==1 && strcmp(fx{1},'all')
        [f,d] = spm_select('List',dm,'.*');
        all=cellstr(d);
    else
        all=fx;
        all=strrep(all,[fileparts(all{1}) filesep],'');
    end
    undone=setdiff(all,done);
    
    disp(['##  copying unassigned directories to ['  outdir  ']']);
    if size(undone,1)==0
        disp(' ..no unassigned directories found');
    else
        for i=1:size(undone,1)
            disp([num2str(i) '/' num2str(size(undone,1)) '..copying unassigned dir: ' undone{i} ]);
            dm1=fullfile(  dm,undone{i});
            dm2=fullfile(  outdir,undone{i});
            copyfile(dm1,dm2,'f')
            
        end
    end
    
    
end
disp('[done]');





























