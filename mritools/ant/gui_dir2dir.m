
% gui_dir2dir: directory-directory assignment
%  [o]=gui_dir2dir(indir,outdir,varargin);
% 
%% INPUTS:
% indir : {cell} list of shortnames* of input-dirs
% outdir: {cell} list of shortnames* of output-dirs
% optional: pariwise inputs:
%     wait           :debug mode..busy state/wait for user to press ok/cancel  (default: 0),{0|1} 
%     matchtype      :match-type filter: default: 4 ('let me decide'),{1|2|3|4} 
%     ndirs          :number of output-dirs to display (default: 5), a numeric value  
%     hdr_in         :header-name of the input-directories, a 'string'
%     hdr_out        :header-name of the output-directories, a 'string'
%     figtitle       :figure-title of the gui, a 'string'
%     figpos         :defines the figure position, 4-values ([x,y,w,h])  
%% OUTPUT: n-x-2 celltable with assigned inputdirs (column-1) and corresponding outputdirs (column-2)
%       not that the output again contains the directory as shortnames*!
%  *shortnames please do not use the fullpath names of the directories
% 
% 
% #ko __GUI__
% [input dirs]: listbox containing all input-directories ....select one input directory to jump to the 
%    correcponding 1st row of the assignment table
% [assignment table]: this table contains the following columns
%   [input directories]: input directories
%   [check]            : checkbox [0|1], check input-output-assignment here
%                      : only one output-dir can be assigned for the one input-dir!
%   [output directories]: output directories
%   [metric]: metric of correspeondence, 
%               [2]: perfect match ; 
%               [1]: match but output-dir contains also a prefix/suffix-string
%               [<1]: degree of matching 
%   [mismatch]: numeric value of mismatch of this inut-dir string and this output-dir string
%   [LCS]: largest common string of this inut-dir and this output-dir
% 
% [clear] : clear all assignments..set all checkboxes unchecked 
% [pulldown-matchfilter]: preselect checkboxes 
%                           'exact match'
%                           'match',     
%                           'closest match (max metric)'
%                           'let me decide!'
%   -except of 'let me decide' all other selected items will overwrite/delete previously made checks 
% 
% [show N-dirs] number of output-dirs to display (numeric value, or leave empty to show all output-dirs)
% 
% [OK]: ok ...proceed
% [cancel] ...abort
% ----------------------------------
% [reverse search]: radio (0|1), This option will reverse the search direction
%     [0] normal seach
%     [1] reverse search
%   -the reverse search direction will not change the indir-outdir assignment/direction
%   
%    [0] normal seach: the name of each input-dir is compared with the names of all output-dirs
%    -this is optimal when the input-dir-name is shorter/equal to the output-dir
%    -i.e the output-dir contain a prefix or sufix
%     example: input-dir is "myAnimal123"  ...output-dir is "subs_myAnimal123_10"
%    [1] reverse search: the name of each output-dir is compared with the names of all input-dirs
%    -this is optimal when the input-dir-name is longer/equal to the output-dir
%    -i.e the input-dir contain a prefix or sufix
%     example: input-dir is "sub_klaus"  ...output-dir is "klaus"


function [o]=gui_dir2dir(indir,outdir,varargin);
warning off
o=[];

%===================================================================================================
% ==============================================
%%   example
% ===============================================
if exist('indir')==0
    indir={
        'dir1234'
        'sub_klaus'
        'myAnimal123'
        'T2_266_20G_1_G_d195'
        'T2_309_40G_2_G_d195'
        'T2_362_20G_3_T_d45'};
    outdir={
        'dir1234'
        'klaus'
        'subs_myAnimal123_10'
        'sub_T2_362_20G_3_T_d45'};
    o=gui_dir2dir(indir,outdir,'ndirs','','matchtype',1,'wait',0);
    return
end




%% =========example======================================
if 0
    indir={
        'dir1234'
        'sub_klaus'
        'myAnimal123'
        'T2_266_20G_1_G_d195'
        'T2_309_40G_2_G_d195'
        'T2_362_20G_3_T_d45'
        'T2_362_40G_3_T_d22'
        'T2_377_20G_4_T_d22'
        'T3_266_40G_1_T_d45'};
    
    outdir={
        'dir1234'
        'klaus'
        'subs_myAnimal123_10'
        '1001_a1'
        '1001_a2'
        '20201118CH_Exp10_9258'
        'Devin_5apr22'
        'Kevin'
        'anna_issue'};
    
%     o=gui_dir2dir(indir,outdir);
    %o=gui_dir2dir(indir,outdir,'ndirs',2,'matchtype',1);
    o=gui_dir2dir(indir,outdir,'ndirs',2,'matchtype',1,'wait',0);
%     outdir=['rrT2_ra,_265_20G_1_G_d195' ; outdir; 'T2_266_20G_1_G_d195' ; ];
    
    
    %% =======[reverse]========================================
    
    if 0
        dum=outdir;
        outdir=indir;
        indir=dum;
        
    end
end
% ==============================================
%%   input-parameter
% ===============================================
p.wait           =1;             %debug mode (default: 0)
p.matchtype      =4;             % match-type filter: default: 4 ('let me decide')
p.ndirs          =5;             % number of output-dirs to display (default: 5)
p.hdr_in         ='INPUT-DIRs';  % header-name of the input-directories
p.hdr_out        ='OUTPUT-DIRs'; % header-name of the output-directories
p.figtitle       =['match-dirs [' mfilename ']' ] ;%'figure-title of the gui
p.figpos         =[0.1729    0.1922    0.7410    0.7422]; % figure position


% ==============================================
%%   varargin
% ===============================================
if ~isempty(varargin)
    pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    p=catstruct(p,pin);
end

%% ===============================================
% p.mdirtitle='input Dirs';
p.isreversesearch=0;
p.indir  =indir;
p.outdir =outdir;
%% ===============================================
[s hs]=findDIRassignment(p.indir,p.outdir);





% ==============================================
%%
% ===============================================
p.i0='___inputdata____';
p.s0   = s;
p.hs0  = hs;
p.i1='___index of folder to find___';
% p.num=1;



makefig(p);
recodeTables(p.matchtype);
makeTable;

if p.wait==1
    
    uiwait(gcf);
   
    %----checkout------
   u=get(gcf,'userdata');
   if u.checkout==1
       as=obtainAssignment;
      o=as ;
   else
      o=[]; 
   end
   close(gcf);
end



function [s hs]=findDIRassignment(keys,list)

[s hs]=findkeys(keys,list,'show',0);
% ==============================================
%%  option to create a new directory
% ===============================================
u=get(gcf,'userdata');
hr=get(findobj(gcf,'tag','pb_reversesearch'),'value');
if isempty(hr) || hr==0 
    for i=1:size(s,1)
        key=s{i,1};
        tb=s{i,2};
        
        if tb{1,1}~=2
            cdir=[{0.99} {0} 'NEW DIR' [ 'create NEW-DIR: "' key '"'] key  {[]} ];
            met=cell2mat(tb(:,1)); %resorting
            i1=find(met>=1);
            i2=find(met<1);
            tb=[tb(i1,:); cdir; tb(i2,:)]; 
            %tb=[tb; cdir];
            s{i,2}=tb;
        end
    end
end


function call_reversesearch(e,e2)
hr=findobj(gcf,'tag','pb_reversesearch');
 u=get(gcf,'userdata');

if hr.Value==1 %reverse search
    [s hs]=findDIRassignment(u.outdir,u.indir);
else
   [s hs]=findDIRassignment(u.indir,u.outdir);
end
u.isreversesearch=hr.Value;

u.s0  =s;
u.hs0 =hs;
set(gcf,'userdata',u);
LB_inputdirs(u);
recodeTables(u.matchtype);
makeTable;

u.htb_reverse;
if u.isreversesearch==1
   u.t.ColumnName=u.htb_reverse;
   set(findobj(gcf,'tag','lb_keys_title'),'string', u.hdr_out);
else
   u.t.ColumnName=u.htb;
   set(findobj(gcf,'tag','lb_keys_title'),'string', u.hdr_in);
end
 

function as=obtainAssignment
makeTable();
 u=get(gcf,'userdata');
isel=find( cell2mat(u.tb(:,2)));

if u.isreversesearch==0
    as=[u.tb(isel,1)  u.tb(isel,3)];
else
   as=[u.tb(isel,3)  u.tb(isel,1) ]; 
end
% remove "new dir"-string
as=regexprep(as,{'create NEW-DIR: "' '"'},{''});


function okcancel(e,e2,arg)
u=get(gcf,'userdata');
u.checkout=arg;
set(gcf,'userdata',u);
uiresume;

% ==============================================
%%   make figure
% ===============================================
function LB_inputdirs(p)
hs0 = p.hs0;
s0  = p.s0;

if 1
    mdirsLB=[cellfun(@(a){[num2str(a)]} ,num2cell([1:length(s0(:,1))]') )];
    mdirsLB=cellfun(@(a,b){['[' a '] ' b]},mdirsLB ,s0(:,1) );
    bgcol=round(cbrewer('qual','Pastel1',size(mdirsLB,1)).*255);
    
    
    for i=1:size(mdirsLB,1)
        colstr=sprintf('%d,%d,%d',bgcol(i,1),bgcol(i,2),bgcol(i,3));
        mdirsLB{i}=['<html><h1 style="background-color:rgb(' colstr ');">' mdirsLB{i}] ;
        %    if i==1
        %       tb(is(i),2)={logical(1)} ;
        %    end
    end
    
    
    %% =============[input dirs]=====================
    delete(findobj(gcf,'tag','lb_keys'));
    hb=uicontrol('style','listbox','units','norm','tag','lb_keys');
    set(hb,'position',[0 .8 .6 .2]);%,'fontsize',6);
    
    set(hb,'string',mdirsLB,'value',1);
    set(hb,'callback',@call_lbkeys);
    set(hb,'KeyPressFcn',@keysTable);
    set(hb,'tooltipstring',['<html><b>input-directories</b><br> select directory to jump to list ']);
    
end


function makefig(p);

hs0 = p.hs0;
s0  = p.s0;

delete(findobj(0,'tag','findkeys'));
fg;
f=gcf;
set(f,'units','norm','menubar','none','numbertitle','off','tag','findkeys');
set(f,'name',p.figtitle);
set(f,'position',p.figpos);
%% ==============listbox=================================

LB_inputdirs(p);

%% ===============================================
if 0
    
    mdirsLB=[cellfun(@(a){[num2str(a)]} ,num2cell([1:length(s0(:,1))]') )];
    mdirsLB=cellfun(@(a,b){['[' a '] ' b]},mdirsLB ,s0(:,1) );
    bgcol=round(cbrewer('qual','Pastel1',size(mdirsLB,1)).*255);
    
    
    for i=1:size(mdirsLB,1)
        colstr=sprintf('%d,%d,%d',bgcol(i,1),bgcol(i,2),bgcol(i,3));
        mdirsLB{i}=['<html><h1 style="background-color:rgb(' colstr ');">' mdirsLB{i}] ;
        %    if i==1
        %       tb(is(i),2)={logical(1)} ;
        %    end
    end
    
    
    %% =============[input dirs]=====================
    hb=uicontrol('style','listbox','units','norm','tag','lb_keys');
    set(hb,'position',[0 .8 .6 .2]);%,'fontsize',6);
    
    set(hb,'string',mdirsLB);
    set(hb,'callback',@call_lbkeys);
    set(hb,'KeyPressFcn',@keysTable);
    set(hb,'tooltipstring',['<html><b>input-directories</b><br> select directory to jump to list ']);
    
end
% ==============listbox-title=================================
if 1
    hb=uicontrol('style','text','units','norm','tag','lb_keys_title');
    set(hb,'position',[0.60356 0.96937 0.15 0.03]);
    set(hb,'string',p.hdr_in,'backgroundcolor','w');
    set(hb,'HorizontalAlignment','left');
end
% set(gcf,'SizeChangedFcn', @resizefig);

if 0
    % ==============radio-match-1=================================
    hb=uicontrol('style','radio','units','norm','tag','rd_match1');
    set(hb,'string','exact match','backgroundcolor','r');
    set(hb,'position',[0.6 0.9 0.1 0.02]);
    set(hb,'callback',{@call_match,1});
    if p.matchtype==1; hb.Value=1; end
    % ==============radio-match-2=================================
    hb=uicontrol('style','radio','units','norm','tag','rd_match2');
    set(hb,'string','match','backgroundcolor','w');
    set(hb,'position',[0.60717 0.86479 0.18 0.050251]);
    set(hb,'callback',{@call_match,2});
    if p.matchtype==2; hb.Value=1; end
    % ==============radio-match-3=================================
    hb=uicontrol('style','radio','units','norm','tag','rd_match3');
    set(hb,'string','closest match','backgroundcolor','w');
    set(hb,'position',[0.60717 0.82205 0.18 0.050251]);
    set(hb,'callback',{@call_match,3});
    if p.matchtype==3; hb.Value=1; end
    % ==============radio-match-4 ...I decide=================================
    hb=uicontrol('style','radio','units','norm','tag','rd_match4');
    set(hb,'string','let me decide!','backgroundcolor','w');
    set(hb,'position',[[0.60717 0.77932 0.18 0.050251]]);
    set(hb,'callback',{@call_match,4});
    if p.matchtype==4; hb.Value=1; end
end

%% ======[matchselection]=========================================
ms={...
    'exact match'
    'match'
    'closest match (max metric)'
    'let me decide!'
    'closest match (max metric), no new DIR'
    };
hb=uicontrol('style','pop','units','norm','tag','pop_match');
set(hb,'string',ms,'backgroundcolor','w');
set(hb,'position',[0.28492 0.0082637 0.1 0.02]);
set(hb,'callback',{@pop_match});
set(hb,'tooltipstring','selection type');
hb.Value=p.matchtype;
set(hb,'tooltipstring',['<html><b>chose selection type</b><br> ...change this will discard previous selections']);

%% ======[number of dirs to display]=========================================
%===================TXT============================
ht=uicontrol('style','text','units','norm');
set(ht,'string','show N-dirs','backgroundcolor','w','fontsize',8);
set(ht,'position',[0.40113 -0.0067068 0.06 0.03]);
ht.HorizontalAlignment='right';
%===================EDIT===========================
hb=uicontrol('style','edit','units','norm','tag','ed_ndirs');
set(hb,'string',p.ndirs,'backgroundcolor','w');
set(hb,'position',[0.46392 0.002 0.03 0.03]);
set(hb,'callback',{@ed_ndirs});
set(hb,'tooltipstring','number of ndirs to display');
set(hb,'tooltipstring',['<html><b>number of output-dirs to display</b><br> example:'...
    '<br> [2] to show two closest output dirs'...
    '<br> leave empty to show all possible output dirs']);

%% ===============================================

% ==============[show match]=================================
hb=uicontrol('style','pushbutton','units','norm','tag','pb_showmatch');
set(hb,'string','show match','backgroundcolor','w');
set(hb,'callback',@call_showmatch);
set(hb,'position',[0.60169 0.002 0.08 0.03]);
set(hb,'tooltipstring',['<html><b>display selected input-output dirs</b>'...
    '<br> you have to select an output-dir']);
% ==============[clear]=================================
hb=uicontrol('style','pushbutton','units','norm','tag','pb_clear');
set(hb,'string','clear','backgroundcolor','w');
set(hb,'callback',@call_clear);
set(hb,'position',[0.19 0.002 0.06 0.025]);
set(hb,'tooltipstring',['<html><b>clear selection (uncheck all checkboxes)</b>']);
% ==============OK=================================
hb=uicontrol('style','pushbutton','units','norm','tag','pb_ok');
set(hb,'string','OK','backgroundcolor','w','fontweight','bold');
set(hb,'callback',{@okcancel,1});
set(hb,'position',[0.86691 0.002 0.06 0.03]);
set(hb,'tooltipstring',['<html><b>OK ...proceed']);
% ==============Cancel=================================
hb=uicontrol('style','pushbutton','units','norm','tag','pb_cancel');
set(hb,'string','Cancel','backgroundcolor','w','fontweight','bold');
set(hb,'callback',{@okcancel,2});
set(hb,'position',[0.93345 0.002 0.06 0.03]);
set(hb,'tooltipstring',['<html><b>cancel ...abort process']);
% ==============[help]=================================
hb=uicontrol('style','pushbutton','units','norm','tag','pb_help');
set(hb,'string','help','backgroundcolor','w','fontweight','bold');
set(hb,'callback',@call_help);
set(hb,'position',[0.0047084 0.002 0.06 0.03]);
set(hb,'tooltipstring',['<html><b>get some help']);

% ==============[reverse search]=================================
hb=uicontrol('style','radio','units','norm','tag','pb_reversesearch');
set(hb,'string','reverse search','backgroundcolor','w','fontweight','bold');
set(hb,'callback',@call_reversesearch,'value',p.isreversesearch);
set(hb,'position',[0.078745 -0.00071858 0.1 0.03]);
set(hb,'tooltipstring',['<html><b>reverse search <br>']);

%% ===============================================
set(gcf,'KeyPressFcn',@keysTable);
u=p;
set(gcf,'userdata',u);




function call_help(e,e2)
uhelp([mfilename '.m']);

function call_clear(e,e2)
u=get(gcf,'userdata');
% mdir=u.lut(row,1);
% iall=find(u.lut(:,1)==mdir);
% u.tb(u.lut(iall,2),2)={logical(0)}; %set all  DBentries of this mdir to 0
u.tb(:,2)={logical(0)};
% u.tb(row,2)={logical(0)}; % set value of just check/uncked row
set(gcf,'userdata',u);
makeTable();

function ed_ndirs(e,e2)

u=get(gcf,'userdata');
u.ndirs=str2num(get(findobj(gcf,'tag','ed_ndirs'),'string'));
set(gcf,'userdata',u);
makeTable();

%% ===============================================
function call_showmatch(e,e2)
%% ===============================================
figure(findobj(0,'tag','findkeys'));
u=get(gcf,'userdata');

%% ===============================================
ndirs=unique(u.lut(:,1));
bf={};

for i=1:length(ndirs)
    ix=find(u.lut(:,1)==ndirs(i));
    bf{i,1}=u.tb(ix,:);
end

%% ===============================================
v={};
n_assigned=0;
for i=1:size(bf,1)
    b=bf{i};
    is=find(cell2mat(b(:,2))==1);
    if ~isempty(is)
        n_assigned=n_assigned+1;
    end
    
    if isempty(is)
        r=[  ['[' num2str(i) ']']  b{1}  {nan} ' #r -not specified- #n ' {nan} {nan} {nan}] ;
        r{1}=[ ' #kw ' r{1} ' #n '];
        v(end+1,:)=r;
    else
        r=[ ['[' num2str(i) ']']  b(is,:)  ];
        if r{5}==2
            r{1}=[ ' #kl ' r{1} ' #n '];
        elseif r{5}==1
            r{1}=[ ' #ky ' r{1} ' #n '];
         elseif r{5}==0.99
            r{1}=[ ' #km ' r{1} ' #n '];   
        elseif r{5}>=.5 &&  r{5}<0.99
            r{1}=[ ' #ko ' r{1} ' #n '];
        else
            r{1}=[ ' #kr ' r{1} ' #n '];
        end
        r{2}=[ ' #k '  r{2} ' #n '];
        
        if 1
            ix=u.s0{i,2}{is,6};
            w=r{4};
            w2={};
            for j=1:length(w)
                w2{j,1}=w(j) ;
            end;
            for j=1:length(ix)
                w2{ix(j)} = [ '<b><u><font color=green>' w2{ix(j)}  '</font></b></u>'];
                %w2{ix(j)} = [ ' #g ' w2{ix(j)}  '</font></b></u>'];
            end;
            r{4}=[ '"' strjoin(w2,'') '"'];
        end
        v(end+1,:)=r;
    end
end

v2=v(:,[1 2 4 5] );
v2(:,4)=cellfun(@(a){[num2str(a)]} ,v2(:,4) );
v2(:,4)=strrep(v2(:,4),'NaN','-');

v2=v2(:,[ 1 4 2 3]);

% hv2={' #ba idx' '_____IN______' '_____OUT___' '__Metric________'};
if u.isreversesearch==0
  hv2={' #ba idx' 'Metric' ['_____' u.hdr_in '______'] ['_____' u.hdr_out '___'] };  
else
  hv2={' #ba idx' 'Metric' ['_____' u.hdr_out '______'] ['_____' u.hdr_in '___'] };   
end
drawnow;
% ===============================================

 h=plog([],[hv2;v2],0,'e','al=1;plotlines=0;' );
% 
% e1=plog([],[hv2(:,1); v2(:,1)],0,'e','al=1,plotlines=0' )
% e2=plog([],[hv2(:,2); v2(:,2)],0,'e','al=1,plotlines=0' ); 
% e3=plog([],[hv2(:,3); v2(:,3)],0,'e','al=1,plotlines=0' );%e3=regexprep(e3,' #k ','        #k ');
% e4=plog([],[hv2(:,4); v2(:,4)],0,'e','al=1,plotlines=0' )
% 
% h=cellfun(@(a,b,c,d){[a b c d]} ,e1,e2,e3,e4 );
h{end+1,1} =' ';
h{end+1,1}=[  ' #GA <u> ASSIGNMENTS:</u> #b  '  [   num2str(n_assigned) '/'  num2str(size(bf,1))  ] ];
% h{end+1,1}=[ [   num2str(n_assigned) '/'  num2str(size(bf,1))  ]  ];

h{end+1,1}=[ [ ' #G <u> COLOR LEGEND:</u>  ' ]  ];
h{end+1,1}=[ [ ' #kl [#] #n  exact match' ]  ];
h{end+1,1}=[ [ ' #ky [#] #n  string match ...string found ...potentially prefix/suffix-strings' ]  ];
h{end+1,1}=[ [ ' #ko [#] #n  low match' ]  ];
h{end+1,1}=[ [ ' #kr [#] #n  really low match' ]  ];
h{end+1,1}=[ [ ' #km [#] #n  create new Directory' ]  ];
h{end+1,1}=[ [ ' #kw [#] #n  NOT SPECIFIED' ]  ];


uhelp(h,1,'name','show match');

%% ===============================================


%% ===============================================


function pop_match(e,e2,type)

hp=findobj(gcf,'tag','pop_match');
matchtype=hp.Value;
if matchtype~=4
    recodeTables(matchtype)
end
makeTable();

% u=get(gcf,'userdata');
% i_unset=setdiff([1:4],type);
% hr=[...
%     findobj(gcf,'tag','rd_match1')
%     findobj(gcf,'tag','rd_match2')
%     findobj(gcf,'tag','rd_match3')
%     findobj(gcf,'tag','rd_match4')];
% set(hr(i_unset),'value',0);
%
% u.matchtype=type;
% set(gcf,'userdata',u);
%
% if get(e,'value')==1


% end

% function updateDB()
% u=get(gcf,'userdata');




function call_lbkeys(e,e2)
%% ===============================================

u=get(gcf,'userdata');

hb=findobj(gcf,'tag','lb_keys');
va=get(hb,'value');
li=get(hb,'string');
key=li{va};
lis=u.t.Data(:,1);
irow=min(find(strcmp(lis,key)));

%solution: https://www.math-forums.com/threads/selecting-cells-in-uitable.175523/
jtable = u.jt;
jtable.setRowSelectionAllowed(0)
jtable.setColumnSelectionAllowed(0);
jtable.changeSelection(irow+50,0, false, false);
jtable.changeSelection(irow-1,0, false, false);


%% ===============================================
return
crect=jtable.getCellRect(irow-1,0,true)
jtable.scrollRectToVisible(crect)

%% ===============================================



return
updateDB();
u=get(gcf,'userdata');
% b=u.t.Data;
hl=findobj(0,'tag','lb_keys');
icase=hl.Value;
mdir=hl.String{icase}
% ck=cell2mat(b(:,2));% store checked-vector
% b1=u.tb{u.num};
% b1(:,2)=b(:,2);
% u.tb{u.num}=b1;
if 0
    db=u.t.Data(:,1);
    ifirst=min(find(strcmp(db,regexprep(mdir,['^[\d+\]\s+'],''))));
    
    
    ht=findobj(gcf,'tag','table');
    jscrollpane = javaObjectEDT(findjobj(ht));
    %     jvp    = javaObjectEDT(jscrollpane.getViewport);
end
% ==============================================
%%   RECODE ALL TABLES
% ===============================================
function recodeTables(matchtype)
u=get(gcf,'userdata');
%% ===============================================
u.i2='___recodeTable___';

s =u.s0;
hs=u.hs0;
u.tb={};
for i=1:size(s,1)
    b  =s{i,2}(:,1:5);
    hb =hs.ht(1:5);
    
    
    met=cell2mat(b(:,1));
    if matchtype==1
        ic=find(met==2);
    elseif matchtype==2
        ic=min(find(met>=1));
    elseif matchtype==3
        ic=min(find(met==max(met)))  ;
    elseif matchtype==4
        ic=[];
    elseif matchtype==5
        inewdir=regexpi2(b(:,4),'create NEW')
        met2=met;
        met2(inewdir)=0;
        ic=min(find(met2==max(met2)))  ;
    end
    check=repmat({logical(0)},[size(b,1) 1] );
    check(ic)={logical(1)};

    
    htb=[hb([5 ])   'CHECK'   hb(  [ 4 1 2 3])];
    tb =[b(:,[5 ])  check      b(:,[ 4 1 2 3])];
    %u.tb{i,1}=tb;
    u.tb=[u.tb; tb];
end
space=5;
fac=2;
htb{1}=[ u.hdr_in   repmat('_',[1 round(fac*size(char(tb(:,1)),2)+space) ])];
htb{2}=[ 'CHECK' ];
htb{3}=[ u.hdr_out  repmat('_',[1 round(fac*size(char(tb(:,3)),2)+space) ]) ];
htb{4}=[ 'Metric' ];
htb{5}=[ 'missMatch' ];
htb{6}=[ 'LCS' repmat('_',[1 size(char(tb(:,6)),2)+space ])];

u.htb=htb;

htb_reverse=htb;
htb_reverse{1}=[ u.hdr_out   repmat('_',[1 round(fac*size(char(tb(:,1)),2)+space) ])];
htb_reverse{3}=[ u.hdr_in  repmat('_',[1 round(fac*size(char(tb(:,3)),2)+space) ]) ];

u.htb_reverse=htb_reverse;


%% ===============================================
set(gcf,'userdata',u);






% ==============================================
%%   make TABLES
% ===============================================
function makeTable

% if exist('matchtype')~=1
%    matchtype=4;
% end

% ==============================================
%%   maketable
% ===============================================
u=get(gcf,'userdata');
% num=u.num;
htb=u.htb;
tb =u.tb;
%===============================================
% find perfect match
%===============================================
met=cell2mat(tb(:,4));
is=find(met==2);
col1=round([0.4667    0.6745    0.1882]*255);
colstr=sprintf('%d,%d,%d',col1(1),col1(2),col1(3));
for i=1:length(is)
    %    tb{1,3}=['<html><font color=rgb(' sprintf('%d,%d,%d',col1(1),col1(2),col1(3)) ')><b>' tb{1,3}]
    tb{is(i),3}=['<html><h1 style="background-color:rgb(' colstr ');">' tb{is(i),3}] ;
    %    if i==1
    %       tb(is(i),2)={logical(1)} ;
    %    end
end
%===============================================
% find match
%===============================================
is=find(met==1);
col1=round([1    1         0]*255);
colstr=sprintf('%d,%d,%d',col1(1),col1(2),col1(3));
for i=1:length(is)
    %    tb{1,3}=['<html><font color=rgb(' sprintf('%d,%d,%d',col1(1),col1(2),col1(3)) ')><b>' tb{1,3}]
    tb{is(i),3}=['<html><h1 style="background-color:rgb(' colstr ');">' tb{is(i),3}] ;
end

%===============================================
% find: create new folder match
%===============================================
is=find(met==0.99);
col1=round([1 0 1]*255);
colstr=sprintf('%d,%d,%d',col1(1),col1(2),col1(3));
for i=1:length(is)
    %    tb{1,3}=['<html><font color=rgb(' sprintf('%d,%d,%d',col1(1),col1(2),col1(3)) ')><b>' tb{1,3}]
    tb{is(i),3}=['<html><h1 style="background-color:rgb(' colstr ');">' tb{is(i),3}] ;
end

% ==============================================
%%   autocheck a field
% ===============================================
% if matchtype==1
%     is=min(find(met==2))        ;%exact
% elseif matchtype==2
%     is=min(find(met==2|met==1)) ;%exact or match
% elseif matchtype==3
%     is=min(find(met==max(met))) ;%closed match
% elseif matchtype==4
%     is=[];
% end
% ischecked=find(cell2mat(tb(:,2))==1);
% if isempty(ischecked)
%     for i=1:length(is)
%         if i==1
%             tb(is(i),2)={logical(1)} ;
%             'modified'
%         end
%     end
% end


%% =======colorcode mdirs ========================================
%colorcode columne-1
ht=findobj(gcf,'tag','lb_keys');
mdirsGui=ht.String;
mdirsall=u.tb(:,1);
% mdirs=unique(mdirsall);
mdirs=unique(mdirsall,'rows','stable');
% mdirs(regexpi2(mdirs,'create_NEW-DIR:'))=[];
for i=1:length(mdirs)
    ix=find(strcmp(mdirsall,mdirs{i})==1);
    tb(ix,1)=mdirsGui(i);
end


%% ========[define how many mdirs ro show]=======================================
tbred={};
lut=[];
ncount=0;
for i=1:length(mdirs)
    ix=find(strcmp(mdirsall,mdirs{i})==1);
    
    keep=min([length(ix) u.ndirs]);
    tbred=[tbred; tb(ix([1:keep]),:)];
    
    vec1=([ones([keep],1) ;zeros(length(ix)-keep,1)]) ;
    vec2=(cumsum((vec1))+ncount).*vec1;
    ncount=max(vec2);
    lut0=[repmat(i,[length(ix) 1])  ix  vec1 vec2 ];
    lut=[lut; lut0];
end
tb=tbred;
u.lut=lut;
set(gcf,'userdata',u);
% ===============================================
ht=(findobj(0,'tag','table'));

if isempty(ht)
    tbeditable=[ 0 1 zeros(1,size(tb,2)-2) ]; %EDITABLE
    t = uitable('Parent', gcf,'units','norm', 'Position', [0 0.035 1 .765], 'Data', tb,'tag','table',...
        'ColumnWidth','auto');
    t.ColumnName =htb;
    t.ColumnEditable =logical(tbeditable ) ;% [false true  ];
    t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];
    
    
    % waitspin(1,'wait...');
    drawnow;
    
    ht=findobj(gcf,'tag','table');
    jscrollpane = javaObjectEDT(findjobj(ht));
    viewport    = javaObjectEDT(jscrollpane.getViewport);
    jtable      = javaObjectEDT( viewport.getView );
    % set(jtable,'MouseClickedCallback',@selID)
    % set(jtable,'MousemovedCallback',@mousemovedTable);
    
    set(jtable,'MouseClickedCallback',@mouseclickedTable);
    jtable.setAutoResizeMode(jtable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
    
%     jScroll = findjobj(hTable);
%     jTable = jScroll.getViewport.getView;
%     jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
    
    set(t,'KeyPressFcn',@keysTable)
    % =======userdata ========================================
    u=get(gcf,'userdata');
    u.t   =t;
    u.jt  =jtable;
    % u.tb  =tb;
    % u.htb =htb;
    
    set(gcf,'userdata',u);
else
    ht.Data=tb;
    
end



function keysTable(e,e2)

u=get(gcf,'userdata');
% if strcmp(e2.Modifier,'alt')
%     if strcmp(e2.Key,'uparrow')
%         if u.num-1>0
%             u=get(gcf,'userdata');
%             b=u.t.Data;
%             hb=findobj(0,'tag','lb_keys');
%             ck=cell2mat(b(:,2));% store checked-vector
%             b1=u.tb{u.num};
%             b1(:,2)=b(:,2);
%             u.tb{u.num}=b1;
%             % ----------
%             u.num=                [u.num-1];
%             set(hb,'value',u.num);
%             set(gcf,'userdata',u);
%             makeTable();
%         end
%     elseif strcmp(e2.Key,'downarrow')
%         if u.num+1<=size(u.tb,1)
%              u=get(gcf,'userdata');
%             b=u.t.Data;
%             hb=findobj(0,'tag','lb_keys');
%             ck=cell2mat(b(:,2));% store checked-vector
%             b1=u.tb{u.num};
%             b1(:,2)=b(:,2);
%             u.tb{u.num}=b1;
%             % ----------
%             u.num=                [u.num+1];
%             set(hb,'value',u.num);
%             set(gcf,'userdata',u);
%             makeTable();
%         end
%     end
% end

% ==============================================
%%
% ===============================================
function mouseclickedTable(e,e2)
u=get(gcf,'userdata');
% e2.getPoint;
% index = jtable.convertColumnIndexToModel(e2.columnAtPoint(e2.getPoint())) + 1
co=[e.rowAtPoint(e2.getPoint())+1 e.columnAtPoint(e2.getPoint())+1];
cj=co-1; %java

b=u.t.Data;

u=get(gcf,'userdata');
if get(e2,'Button')==1
    if co(2)==2
        drawnow;
        val=u.jt.getValueAt(co(1)-1,2-1); %value (un/checked)
        drawnow;
        %disp(['---value: ' num2str(val)]);
        iselDB  =find(u.lut(:,4)==co(1,1)) ; %in GUI-table
        mddir =u.lut(iselDB,1)             ;%mdirIDX (1 or 2...)
        imdirDB= find(u.lut(:,1)==mddir) ; %index all all animals of "mdir" in DB
        iallrowsG=unique(u.lut(imdirDB,4)); % all rows in in GUI-table of "mdir"
        iallrowsG(iallrowsG==0)=[]; %remove 0
        
        %----de-select all rows of "mdir"
        cursel=(cell2mat(b(iallrowsG,2))==1);
        cursel(iselDB)=0; % remove just madecselection
        idx2zero=find(cursel==1);
        
        rows2zero=iallrowsG(idx2zero);
        rows2zero( find(rows2zero==u.lut(iselDB,4)))=[];
        if ~isempty(rows2zero) %something was already checked...remove it..
            for i=1:length(rows2zero)
                u.jt.setValueAt(logical(0),rows2zero(i)-1,2-1);
            end
        end
        %
        
        
        %u.jt.setValueAt(logical(val),cj(1),1);
        %jtable.setValueAt(java.lang.String('This value will be inserted'),0,0);
        % return
        updateDB(iselDB,val);
    end
end





function updateDB(row,val)
u=get(gcf,'userdata');
mdir=u.lut(row,1);
iall=find(u.lut(:,1)==mdir);
u.tb(u.lut(iall,2),2)={logical(0)}; %set all  DBentries of this mdir to 0
u.tb(row,2)={logical(val)}; % set value of just check/uncked row
set(gcf,'userdata',u);


return





ht=findobj(gcf,'tag','lb_keys');
mdirsGui=ht.String;
mdirsall=u.tb(:,1);
mdirs=unique(mdirsall);
%% ========[show n-mdirs]=======================================
b= u.t.Data;
b0=u.tb;%{u.num};

tbred={};
for i=1:length(mdirs)
    ix=find(strcmp(mdirsall,mdirs{i})==1)
    keep=min([length(ix) u.ndirs]);
    
end
tb=tbred;



% hl=findobj(0,'tag','lb_keys');
ck=(b(:,2));% store checked-vector
bur(:,2)=ck;
u.tb=bur;
set(gcf,'userdata',u);


function resizefig(e,e2)
% ht=findobj(gcf,'tag','table'); %table
% hb=findobj(gcf,'tag','ok');   %OK-btn
%
% hm=findobj(gcf,'tag','msg'); %message
%
% ht_pos=get(ht,'position');
% hm_pos=get(hm,'position');
%
% hbunit=get(hb,'units');
% set(hb,'units','norm');
% hb_pos=get(hb,'position');
% set(hb,'units','pixels');
%
%
% ht_pos2=[ht_pos(1)  hb_pos(2)+hb_pos(4)  ht_pos(3)   1-(hb_pos(2)+hb_pos(4)+hb_pos(4)/2  )  ];
%
% if ht_pos2(4)<.2
%     %     ht_pos2=[ht_pos(1)  hb_pos(2)+hb_pos(4)  ht_pos(3)   1-(hb_pos(2)+hb_pos(4)+hb_pos(4)/2  )  ];
%
%     return
% end
%
%
% set(ht,'position',ht_pos2)



