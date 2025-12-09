%% xrenamdir(parmeter) -function to rename directories (GUI)
% ==========================================================================================
% function without input calls the gui to select the rootdir
%% INPUTS : function uses pairwise inputs 
%  'dirs'  cellarray with fullpath-directories to be renamed
%   or
%   'rootdir'  string ..directory containing directories to be rename
%   
%   addit. parameters
%   'pat'  cell with matching and changing strings, this cell is of size 1 x 2n entries
%           each odd entry is a string to search, each even entry is a string to replace
%          example:  pat: {'124' 'AB' '4' 'C'};  will replace '124' with 'AB' and '4' with C
%   'pre'  prefix, string to add as prefix
%   'suf'  suffix, string to add as suffix
%% GUI
%## left side contains the directory table with 3 columns: 
%   1st. column indicates whether renaming chould be applied to all dirs [x] or not [] , default: rename all dirs [x]
%   2nd. column: old direcory names
%   3rd. column: new directory names. This column is editable and the files can be modified selectively
%## old/new pattern: here one can set 1-5 old patterns which if found will be replaced by new pattern
%    if new pattern is empty, the old pattern is replaced
%        example:    
%          |  '_123'    |  '_abs'    |
%          |  'argx'    |  ''        |
%          |  '.'       |  '_'       |
%          ..this relpaces the pattern '_123' with '_abs', deletes pattern 'argx', and replaces '_' with '.' 
% prefix:  string to add a prefix   
% suffix:  string to add a suffix   
%% OUTPUT:
%  cellarray with 2 columns: 
%          1st. column:  name of old fullpath-directories
%          2nd. column:  name of new fullpath-directories   (same order of 1st and 2nd column)
%% EXAMPLES
% xrenamedir   ;% using GUI to select the rootdir
% xrenamedir('O:\data3\hedermanip\dat');
% xrenamedir('O:\data3\hedermanip\dat',[],{'er' 'all' 'M' 'V'});
% xrenamedir('O:\data3\hedermanip\dat',[],{'er' 'all' 'M' 'V'},'p_','_s');
% xrenamedir('O:\data3\hedermanip\dat',[],{'er' 'all' 'M' 'V'},[],'_s');
% ==========================================================================================




 function fpdirs=xrenamedir(varargin)
% function fpdirs=xrenamedir(dirs,pattern,prefix,suffix)
%%———————————————————————————————————————————————
%%
%———————————————————————————————————————————————

if 0
    
    dirs=an.mdirs
    xrenamedir(dirs)
    
    xrenamedir('dirs',an.mdirs,'pat', {'a'  '1'},'pre','a1','suf','_a' )
    
    xrenamedir('rootdir','O:\data3\hedermanip\dat','pat', {'a'  '1' ,'Z','z2'},'pre','a1','suf','_a' )
    
end
%———————————————————————————————————————————————
%%
%———————————————————————————————————————————————

p = cell2struct(varargin(2:2:end),varargin(1:2:end),2);
if isfield(p,'pat'); pattern=p.pat;end
if isfield(p,'pre'); prefix=p.pre;end
if isfield(p,'suffix'); suffix=p.pre;end

if isfield(p,'dirs') && iscell(p.dirs); 
    pamain=fileparts(p.dirs{1});
    dirs  =strrep(p.dirs,[pamain filesep],'');
    dirs=dirs(:);
end

if isfield(p,'rootdir'); 
    pamain=p.pamain;
end





if exist('pamain')==0
    [pamain dirs]=selectmainpath();
    if pamain==0; return; end
end
if exist('dirs')==0 || isempty(dirs) 
     [pamain dirs]=selectmainpath(pamain);
end


fpdirs=stradd(dirs,[pamain filesep]);
fpdirs=[fpdirs fpdirs];
uw.out=fpdirs;

% di={k(:).name}';
% end



% global an
% lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');
% pamain=an.datpath
%  va=get(lb3,'value');
%
% for i=1:length(va)
%     dir0= an.mdirs{va(i)};
%     [r1 r2 ext]=fileparts(dir0);
%     di{i,1}=[r2 ext];
%     %system(['explorer ' dirx]);
% end





%% GUI
tb       = [num2cell(repmat(true,size(dirs,1),1)) dirs dirs ] ;
tbh      = {'apply' 'old DIR name' 'new DIR name'};
tbeditable=[1 0 1 ]; %EDITABLE


for i=2:size(tbh,2)
    addspace=size(char([tbh(i);tb(:,i)]),2)-size(char([tbh(i)]),2);
    tbh(i)=  { [' ' tbh{i} repmat('_',[1 addspace] )  '_'  ]};
end


defs={' ' ,'.' 'struct' 'nii' };

colformat ={'logical' 'char' 'char'};

try; delete(findobj(0,'tag','changedir')); end
f=figure;
set(f,'color','w','units','norm','menubar','none','position',[0.2639    0.4189    0.6892    0.4667],...
    'tag','changedir');

% % make figure
% f = fg; set(gcf,'menubar','none','units','normalized','position',[    0.3049    0.0867    0.6000    0.8428]);
% tx=uicontrol('style','text','units','norm','position',[0 .95 1 .05 ],...
%     'string',      '..rename/copy/delete/extract/expand NIFTIs, see [help]...',... % UPPER-TITLE
%     'fontweight','bold','backgroundcolor','w');


[~,MLvers] = version;
MatlabVersdate=str2num(char(regexpi(MLvers,'\d\d\d\d','match')));
if MatlabVersdate<=2014
    t = uitable('Parent', f,'units','norm', 'Position', [0 0.05 1 .93], 'Data', tb,'tag','table',...
        'ColumnName',tbh, 'ColumnEditable',logical(tbeditable),'columnformat',colformat);
else
    t = uitable('Parent', f,'units','norm', 'Position', [0 0.05 1 .93], 'Data', tb,'tag','table',...
        'ColumnWidth','auto','columnformat',colformat);
    t.ColumnName =tbh;
    
    %columnsize-auto
    % set(t,'units','pixels');
    % pixpos=get(t,'position')  ;
    % set(t,'ColumnWidth',{pixpos(3)/2});
    % set(t,'units','norm');
    t.ColumnEditable =logical(tbeditable ) ;% [false true  ];
    t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];
    
end

pos=[.75 .85 .1 .05];

hl=uicontrol('style','text','units','norm','position',[0 .7 .1 .05 ],'string','old pattern','fontweight','normal');
set(hl,'position',[pos(1)    pos(2)+pos(4) pos(3:end)],'backgroundcolor','w');
hl=uicontrol('style','text','units','norm','position',[0 .7 .1 .05 ],'string','new pattern','fontweight','normal');
set(hl,'position',[pos(1)+pos(3)     pos(2)+pos(4) pos(3:end)],'backgroundcolor','w');
for i=1:5
    hx(i)=uicontrol('style','edit','units','norm','position',[0 .7 .1 .05 ],'string','','fontweight','normal');
    set(hx(i),'position',[pos(1)    pos(2)-i.*pos(4)+pos(4) pos(3:4)],'callback', @changestr,'tag', ['dx(' num2str(i) ')'] );
    
    px(i)=uicontrol('style','popupmenu','units','norm','position',[.9 .85 .075 .05 ],'string',defs,'fontweight','bold');
    set(px(i),'position',[pos(1)-.015    pos(2)-i.*pos(4)+pos(4) .015 pos(4:end)],'callback',@setstr,'tag', ['px(' num2str(i) ')'] );
    
    hy(i)=uicontrol('style','edit','units','norm','position',[0 .7 .1 .05 ],'string','','fontweight','normal');
    set(hy(i),'position',[pos(1)+pos(3)    pos(2)-i.*pos(4)+pos(4) pos(3:end)],'callback', @changestr);
    
    py(i)=uicontrol('style','popupmenu','units','norm','position',[.9 .85 .075 .05 ],'string',{'ss','bb'},'fontweight','bold');
    set(py(i),'position',[pos(1)+pos(3)+pos(3)    pos(2)-i.*pos(4)+pos(4) 0.015 pos(4)],'callback',@setstr,'tag', ['py(' num2str(i) ')'] );
end


ht=uicontrol('style','text','units','norm','position',[0 .7 .1 .05 ],'string','prefix','fontweight','normal');
set(ht,'position',[pos(1)    .3 pos(3:end)],'backgroundcolor','w');
ht=uicontrol('style','text','units','norm','position',[0 .7 .1 .05 ],'string','suffix','fontweight','normal');
set(ht,'position',[pos(1)+pos(3)     .3 pos(3:end)],'backgroundcolor','w');

ha=uicontrol('style','edit','units','norm','position',[0 .7 .1 .05 ],'string','','fontweight','normal');
set(ha,'position',[pos(1)    .25 pos(3:end)],'backgroundcolor','w','tag','prefix','callback',@changestr);

ha=uicontrol('style','edit','units','norm','position',[0 .7 .1 .05 ],'string','','fontweight','normal');
set(ha,'position',[pos(1)+pos(3)     .25 pos(3:end)],'backgroundcolor','w','tag','suffix','callback',@changestr);


pb=uicontrol('style','pushbutton','units','norm','position',[.05 0.0 .15 .05 ],'string','OK','fontweight','bold','backgroundcolor','w',...
    'callback',   @xok          );
pb=uicontrol('style','pushbutton','units','norm','position',[.8 0.0 .15 .05 ],'string','CANCEL','fontweight','bold','backgroundcolor','w',...
    'callback',   @xcancel          );%

pb=uicontrol('style','pushbutton','units','norm','position',[.4 0.0 .15 .05 ],'string','HELP','fontweight','bold','backgroundcolor','w',...
    'callback',   @xhelp         );%



uw.pamain=pamain;
uw.hx=hx;
uw.hy=hy;
uw.t=t;
uw.tb=tb;
set(gcf,'userdata',uw);

if exist('pattern')==1 && ~isempty(pattern) && iscell(pattern)
    if mod(length(pattern),2)==0
        pattern=[pattern(1:2:end)' pattern(2:2:end)'];
    end
    for i=1:size(pattern,1)
        set(hx(i),'string',pattern{i,1});
        set(hy(i),'string',pattern{i,2});
        hgfeval(get(hy(i),'callback'));
    end
end

if exist('prefix') && ~isempty(prefix)
    hpref=findobj(0,'tag','prefix');
    set(hpref,'string',prefix);
    hgfeval(get(hpref,'callback'));
end

if exist('suffix') && ~isempty(suffix)
    hsuff=findobj(0,'tag','suffix');
    set(hsuff,'string',suffix);
    hgfeval(get(hsuff,'callback'));
end


uiwait(gcf)
uw=get(gcf,'userdata');
fpdirs=uw.out;
close(gcf);



function changestr(e,e2)
uw=get(gcf,'userdata');
li={};
for i=1:length(uw.hx)
    d= {get(uw.hx(i),'string') get(uw.hy(i),'string')};
    if ~isempty(d{1})
        li=[li; d];
    end
end
d2=uw.tb(:,2);
for i=1:size(li,1)
    d2=strrep(d2,li{i,1},li{i,2});
end

prefix=get(findobj(0,'tag','prefix'),'string');
suffix=get(findobj(0,'tag','suffix'),'string');
d2=cellfun(@(a){[prefix a suffix]},d2);


dx=get(uw.t,'data');
iuse=find([dx{:,1}]==1);
dx(iuse,3)=d2(iuse);

set(uw.t,'data',dx);

% function reset(e,e2)
% help(mfilename);



function xhelp(e,e2)
help(mfilename);


function setstr(e,e2)
str=get(e,'string');
str=str(get(e,'value'));
hed=findobj(gcf,'tag',strrep(get(e,'tag'),'px','dx'));
set(hed,'string',str);
hgfeval(get(hed,'callback'));



function xcancel(e,e2)
disp(['..terminated [' mfilename '.m]' ]);
% close(gcf);
uiresume(gcf);

function xok(e,e2)
disp('ok');

uw=get(gcf,'userdata');
dx=get(uw.t,'data');
dir1=dx(:,2);
dir2=dx(:,3);

fpdir1=stradd(dir1,[uw.pamain filesep],1);
fpdir2=stradd(dir2,[uw.pamain filesep],1);
for i=1:size(dir1,1)
    if dx{i,1}==1
        try
            movefile(fpdir1{i},fpdir2{i},'f');
            disp(['renamed DIR.: [' dir1{i} '] ----> [' dir2{i} ']']);
        end
    end
end
% close(gcf);
uw.out=[fpdir1 fpdir2];
set(gcf,'userdata',uw);
uiresume(gcf);

 
 


function [pamain di]=selectmainpath(pamain);

if exist('pamain')==0 || exist(pamain)~=7
    pamain=uigetdir(pwd,'select main directory with directories to rename');
    if pamain==0; 
        di=0;
        
        return; end
end

k=dir(pamain);
k=k(find([k(:).isdir]));
k(regexpi2({k(:).name},'^\.$|^\..$'))=[];

di={k(:).name}';































