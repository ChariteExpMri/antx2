

% define specific group-comparisons from 1/2/3-factorial combinations (GUI)
% o=specificgroupsGUI(groupcombs)
% ==============================================
%%   GUI-description
% ===============================================
% From the listbox "input groups" several groups can be selected and send to the listboxes
% "new group-1" or "new group-2" via the buttons "group-1" and "group-2", respectively.
% The groups in "new group-1" and "new group-2" will be the new groups for group-comparison.
% Hit "submit"-button to accept the new group-comparison, which will be displayed in the lower
% listbox ("final group comparison").
% hit "clear new Groups"-button or hit the respective "clear" button to clear the listboxes
% "new group-1" and "new group-2". 
% Add this point you can create several new group-comparisons.
%
% use the '^1'/'^2'/'^3' buttons above the "input groups"-listbox to sort the input according to 
% their factors
% ise the [chk comps]-button to check the results
% The [clearSel]-button below "new group-1" or "new group-2" can be used to remove selected groups
% from the respective listbox.
% The [clearSel]-button below "final group comparison"-listbox removes selected group-comparisons
% from the "final group comparison"-listbox, while the [clear]-button below "final group comparison"
% clear all submitted group-comparisons. 
% When done, hit [OK] to obtain the new group-comparisons.
% 
% 
% ==============================================
%%   function: INPUT/OUTPUT
% ===============================================
% INPUT: see examples below
% OUTPUT: 
% [o] is an N x 2 cell-array, with N-group-comparisons
%   1st column: all old groups for new group-1
%   2nd column: all old groups for new group-2
% example: 2 new group comparisons were created:
% o = 
%     {2x1 cell}    {2x1 cell}
%     {1x1 cell}    {3x1 cell}
% comparison-1:   o(1,:):
%         with        o{1,1}    this is group-1 formed by the following old groups:
%                     ans = 
%                         '[1d]'
%                         '[56d]'
%                     o{1,2}    this is group-2 formed by the following old groups:
%                     ans = 
%                         '[7d]'
%                         '[84d]'
% 
% comparison-2:   o(2,:) :      
%         with        o{2,1} this is group-1 formed by the following old groups:
%                     ans = 
%                         '[1d]'
%                     o{2,2}    this is group-2 formed by the following old groups:
%                     ans = 
%                         '[56d]'
%                         '[7d]'
%                         '[84d]'
% 
%% ====================================================================
%%  example: group labels for 1-factor [time]
%% ====================================================================
% group={'[1d]'
%        '[56d]'
%        '[7d]'
%        '[84d]'};
% o=specificgroupsGUI(group)
%% ====================================================================
%%  example: group labels for 2-factors [time][stress] 
%% ====================================================================
% groupF2={   '[1d][115dB]'
%             '[1d][90dB]'
%             '[1d][Ctrl]'
%             '[56d][115dB]'
%             '[56d][90dB]'
%             '[56d][Ctrl]'
%             '[7d][115dB]'
%             '[7d][90dB]'
%             '[7d][Ctrl]'
%             '[84d][115dB]'
%             '[84d][90dB]'
%             '[84d][Ctrl]'};
% o=specificgroupsGUI(groupF2)
%% ====================================================================
%% example: group labels for 3-factors [time][stress][factorC]
%% ====================================================================
% groupF3={ '[1d][115dB][am]'
%         '[1d][115dB][bm]'
%         '[1d][90dB][am]'
%         '[1d][90dB][bm]'
%         '[1d][Ctrl][am]'
%         '[1d][Ctrl][bm]'
%         '[56d][115dB][am]'
%         '[56d][115dB][bm]'
%         '[56d][90dB][am]'
%         '[56d][90dB][bm]'
%         '[56d][Ctrl][am]'
%         '[56d][Ctrl][bm]'
%         '[7d][115dB][am]'
%         '[7d][115dB][bm]'
%         '[7d][90dB][am]'
%         '[7d][90dB][bm]'
%         '[7d][Ctrl][am]'
%         '[7d][Ctrl][bm]'
%         '[84d][115dB][am]'
%         '[84d][115dB][bm]'
%         '[84d][90dB][am]'
%         '[84d][90dB][bm]'
%         '[84d][Ctrl][am]'
%         '[84d][Ctrl][bm]'};
%  o=specificgroupsGUI(groupF3)
% 




function o=specificgroupsGUI(groupcombs,pin)
% clc
warning off;
o=[];
if 0
    z0=load('zmat.mat');
    z=struct();
    z.groupcombs=z0.z.q.groupcombs;
end
%% =============PARAMETER==================================

p.iswait=1;

%% ======internal =========================================
p.isOK=0;
%% ===============================================

if exist('pin')==1 && isstruct(pin)
    p=catstruct(p,pin);
end


z.groupcombs=groupcombs;
z=catstruct(z,p);
makefig(z);

if z.iswait==1
    uiwait( findobj(0,'tag','figsubgroup') );
end
%% ===============================================
z=get(gcf,'userdata');
drawnow;
if isempty(findobj(0,'tag','figsubgroup') )
    close(gcf)
end


if isstruct(z) && z.isOK==1
    drawnow;
    if isfield(z,'nrewcomp') && size(z.nrewcomp,1)>0
    o=z.nrewcomp;
    end
end
if z.iswait==1
    delete(  findobj(0,'tag','figsubgroup')   );
end



function makefig(z)
%% ===============================================
delete(  findobj(0,'tag','figsubgroup')   );
hf=figure('units','norm','color','w','tag','figsubgroup');
set(hf,'menubar','none','name',['make subgroups'],'NumberTitle','off');
set(hf,'position',[0.2451    0.1622    0.6312    0.7311]);
%% ===============================================

% ========listbox all input-group =======================================
hb=uicontrol('style','listbox','units','norm','tag','list_inputgroup');
set(hb,'position',[0.005    0.48 0.3    0.5],'max',1000);
% set(hb,'string',z.groupcombs);
v=colorizeInput(z.groupcombs);
set(hb,'string',v.out);
set(hb,'FontName','consolas');
set(hb,'tooltipstring',['<html><b>existing groups</b>  ']);
% ========butt: assign to group1=======================================
hb=uicontrol('style','pushbutton','units','norm','tag','pb_group1');
set(hb,'string','group-1');
set(hb,'position',[0.30812 0.86362 0.066012 0.030396]);
set(hb,'callback',{@cb_sg,'pb_group1'});
set(hb,'tooltipstring',['<html><b>assign selected "input groups" <br> to "new group-1"</b>  ']);
% ========butt: assign to group2=======================================
hb=uicontrol('style','pushbutton','units','norm','tag','pb_group2');
set(hb,'string','group-2');
set(hb,'position',[0.30812 0.66757 0.066012 0.030396]);
set(hb,'callback',{@cb_sg,'pb_group2'});
set(hb,'tooltipstring',['<html><b>assign selected "input groups" <br> to "new group-2"</b>  ']);
% ========listbox  group1 =======================================
hb=uicontrol('style','listbox','units','norm','tag','list_group1');
set(hb,'position',[0.38    0.48 0.3    0.5]);
set(hb,'string','','max',1000);
set(hb,'FontName','consolas');
set(hb,'tooltipstring',['<html><b>existing groups forming "new group-1"</b>  ']);
% ========listbox  group2 =======================================
hb=uicontrol('style','listbox','units','norm','tag','list_group2');
set(hb,'position',[0.69    0.48 0.3    0.5]);
set(hb,'string','','max',1000);
set(hb,'FontName','consolas');
set(hb,'tooltipstring',['<html><b>existing groups forming "new group-2"</b>  ']);

%% -----------HEADER----------------------
% ========header.txt: input-group  =======================================
hb=uicontrol('style','text','units','norm','backgroundcolor','w');
set(hb,'string','input groups','fontweight','bold');
set(hb,'position',[0.10238 0.97041 0.1 0.03]);
uistack(hb,'bottom');

% ========header.txt: group1  =======================================
hb=uicontrol('style','text','units','norm','backgroundcolor','w');
set(hb,'string','new group-1','fontweight','bold');
set(hb,'position',[0.46765 0.97041 0.1 0.03]);
uistack(hb,'bottom');
% ========header.txt: group2  =======================================
hb=uicontrol('style','text','units','norm','backgroundcolor','w');
set(hb,'string','new group-2','fontweight','bold');
set(hb,'position',[0.7823 0.97193 0.1 0.03]);
uistack(hb,'bottom');

%% ========butt: submit=======================================
hb=uicontrol('style','pushbutton','units','norm','tag','submit');
set(hb,'string','submit','backgroundcolor',[1 .8 0]);
set(hb,'position',[[0.30922 0.44305 0.066012 0.030396]]);
set(hb,'callback',{@submit});
set(hb,'tooltipstring',['<html><b>submit new comparison from <br>'...
    ' "new group-2" & "new group-1"</b>  ']);

%% ========butt: clear/clearsel=======================================
% ========butt: grp1: clear-all =======================================
hb=uicontrol('style','pushbutton','units','norm','tag','clear_group1');
set(hb,'string','clear','backgroundcolor','w');
set(hb,'position',[[0.61287 0.44913 0.066012 0.030396]]);
set(hb,'callback',{@cb_sg,'clear_group1'});
set(hb,'tooltipstring',['<html><b>clear entire list</b>  ']);

% ========butt: grp2: clear-all =======================================
hb=uicontrol('style','pushbutton','units','norm','tag','clear_group2');
set(hb,'string','clear','backgroundcolor','w');
set(hb,'position',[0.92423 0.44913 0.066012 0.030396]);
set(hb,'callback',{@cb_sg,'clear_group2'});
set(hb,'tooltipstring',['<html><b>clear entire list</b>  ']);


% ========butt: grp1: clear-selection =======================================
hb=uicontrol('style','pushbutton','units','norm','tag','clearsel_group1');
set(hb,'string','clearSel','backgroundcolor','w');
set(hb,'position',[0.54466 0.44913 0.066012 0.030396]);
set(hb,'callback',{@cb_sg,'clearsel_group1'});
set(hb,'tooltipstring',['<html><b>clear selections from list</b>  ']);

% ========butt: grp2: clear-selection =======================================
hb=uicontrol('style','pushbutton','units','norm','tag','clearsel_group2');
set(hb,'string','clearSel','backgroundcolor','w');
set(hb,'position',[0.85601 0.44913 0.066012 0.030396]);
set(hb,'callback',{@cb_sg,'clearsel_group2'});
set(hb,'tooltipstring',['<html><b>clear selections from list</b>  ']);


%% =========clear multiple listboxes======================================

hb=uicontrol('style','pushbutton','units','norm','tag','clear_groups');
set(hb,'string','clear new Groups','backgroundcolor',[1 1 0.8]);
set(hb,'position',[0.65798 0.40049 0.1 0.030396]);
set(hb,'callback',{@cb_clear,'cleargroups'});
set(hb,'tooltipstring',['<html><b>clear "new group-1" & "new group-1"</b>  ']);

hb=uicontrol('style','pushbutton','units','norm','tag','clear_all');
set(hb,'string','clear all','backgroundcolor',[1 0.8 0.8]);
set(hb,'position',[0.51715 0.25763 0.066 0.030396]);
set(hb,'callback',{@cb_clear,'clearall'});
set(hb,'tooltipstring',['<html><b>clear all listboxes</b><br>"new group-1", "new group-1" & "final-group" ']);

%% =========FINAL-group======================================
% ========listbox  final-group =======================================
hb=uicontrol('style','listbox','units','norm','tag','list_finalgroup');
set(hb,'position',[0.005    0.05 0.5    0.38],'max',1000);
set(hb,'string','');
set(hb,'FontName','consolas');
set(hb,'tooltipstring',['<html><b>list with final group-comparisons</b>  ']);

% ========butt: finalgroup: clear-all =======================================
hb=uicontrol('style','pushbutton','units','norm','tag','clear_finalgroup');
set(hb,'string','clear','backgroundcolor','w');
set(hb,'position',[0.43904 0.017508 0.066012 0.030396]);
set(hb,'callback',{@cb_sg,'clear_finalgroup'});
set(hb,'tooltipstring',['<html><b>clear all group-comparisons </b>  ']);

% ========butt: finalgroup: clear-selection =======================================
hb=uicontrol('style','pushbutton','units','norm','tag','clearsel_finalgroup');
set(hb,'string','clearSel','backgroundcolor','w');
set(hb,'position',[0.37193 0.017508 0.066012 0.030396]);
set(hb,'callback',{@cb_sg,'clearsel_finalgroup'});
set(hb,'tooltipstring',['<html><b>clear selected group-comparison</b>  ']);

% ========header.txt: final group  =======================================
hb=uicontrol('style','text','units','norm','backgroundcolor','w');
set(hb,'string','final group comparison','fontweight','bold');
set(hb,'position',[0.044069 0.42025 0.25 0.03]);
uistack(hb,'bottom');

%% =========OK/cancel/help======================================
% ======== but: ok  =======================================
hb=uicontrol('style','pushbutton','units','norm','tag','OK');
set(hb,'string','OK','backgroundcolor', [ 0.8941    0.9412    0.9020],'fontweight','bold');
set(hb,'position',[0.84721 0.0023101 0.066012 0.030396]);
set(hb,'callback',{@cb_sg,'ok'});
set(hb,'tooltipstring',['<html><b>OK..accept</b>  ']);

% ======== but: Cancel  =======================================
hb=uicontrol('style','pushbutton','units','norm','tag','cancel');
set(hb,'string','Cancel','backgroundcolor',[0.9333    0.9333    0.9333],'fontweight','bold');
set(hb,'position',[0.91543 0.0023101 0.066012 0.030396]);
set(hb,'callback',{@cb_sg,'cancel'});
set(hb,'tooltipstring',['<html><b>Cancel..abort...</b>  ']);

% ======== but: help  =======================================
hb=uicontrol('style','pushbutton','units','norm','tag','help');
set(hb,'string','Help','backgroundcolor',[1.0000    0.9686    0.9216],'fontweight','bold');
set(hb,'position',[0.7779 0.0023101 0.066012 0.030396]);
set(hb,'callback',{@cb_sg,'help'});
set(hb,'tooltipstring',['<html><b>get help...</b>  ']);

%% ==============sort input =================================

% ========butt: sort1 =======================================
hb=uicontrol('style','togglebutton','units','norm','tag','pb_sort1');
set(hb,'string','^1','backgroundcolor','w','fontsize',7);
set(hb,'position',[0.0088632 0.98105 0.02 0.022]);
set(hb,'callback',{@cb_sg,'pb_sort1'});
set(hb,'tooltipstring',['<html><b>sort input-group along factor-1...</b>  ']);

% ========butt: sort2 =======================================
hb=uicontrol('style','togglebutton','units','norm','tag','pb_sort2');
set(hb,'string','^2','backgroundcolor','w','fontsize',7);
set(hb,'position',[0.041869 0.98105 0.02 0.022]);
set(hb,'callback',{@cb_sg,'pb_sort2'});
if size(v.c,2)<2
   set(hb,'visible','off' );
end
set(hb,'tooltipstring',['<html><b>sort input-group along factor-2...</b>  ']);

% ========butt: sort3 =======================================
hb=uicontrol('style','togglebutton','units','norm','tag','pb_sort3');
set(hb,'string','^3','backgroundcolor','w','fontsize',7);
set(hb,'position',[0.089178 0.97801 0.02 0.022]);
set(hb,'callback',{@cb_sg,'pb_sort3'});
if size(v.c,2)<3
   set(hb,'visible','off') ;
end
set(hb,'tooltipstring',['<html><b>sort input-group along factor-3...</b>  ']);


% ========butt: check comps =======================================
hb=uicontrol('style','pushbutton','units','norm','tag','check_comps');
set(hb,'string','chk comps','backgroundcolor',[ 0.8392    0.9098    0.8510]);
set(hb,'position',[0.0033622 0.017508 0.066012 0.030396]);
set(hb,'callback',{@cb_sg,'check_comps'});
set(hb,'tooltipstring',['<html><b> check group comparison..</b>  ']);


% ==============================================
%%   userdata
% ===============================================
set(hf,'userdata',z);

function out=recode(in)
c={};
for i=1:size(in,1)
   c(i,:)=regexprep(strsplit(in{i},']['),{']' '['},{''}); 
end
out=cellfun(@(a){[ '[' a ']' ]} ,c);


function v=colorizeInput(in)
out=[];
hb=findobj(gcf,'tag','list_inputgroup' );
% set(hb,'string',{'oma';['<html><p style="background-color: red;">KLAZS']})
% set(hb,'string',{'oma';['<html><p style="background-color: rgb(0,0,255);">KLAZS']})
%% ===============================================
% c={};
% for i=1:size(in,1)
%    c(i,:)=regexprep(strsplit(in{i},']['),{']' '['},{''}); 
% end
% c=cellfun(@(a){[ '[' a ']' ]} ,c);

c=recode(in);

d=repmat({'<html>'},size(in));
for i=1:size(c,2)
    uni=unique(c(:,i));
    if i==1
        col= cbrewer('seq','Greens',length(uni)+3);
    elseif i==2
        col= cbrewer('seq','Blues',length(uni)+3);
    elseif i==3
        col= cbrewer('seq','Oranges',length(uni)+3);
    end
    scol=cellfun(@(a){[ num2str(a) ]} ,num2cell(round(col*255)));
    scol(1,:)=[];
    for j=1:length(uni)
        ix=find(strcmp(c(:,i),uni{j}));
        for k=1:length(ix)
            w=['<span style="background-color: rgb(' scol{j,1} ',' scol{j,2} ',' scol{j,3}  ');">' c{ix(k),i} ' ' ];
            d{ix(k)}=[d{ix(k)} w];
        end
    end     
end
% set(hb,'string',d);
v.out=d;
v.c=  c;

%% ===============================================

function submit(e,e2)
%% ===============================================


hf= findobj(0,'tag','figsubgroup');
h1=findobj(hf,'tag','list_group1' );
h2=findobj(hf,'tag','list_group2' );
h3=findobj(hf,'tag','list_finalgroup' );
z=get(hf,'userdata');


s1=h1.String;
s2=h2.String;
s3=h3.String;

if isempty(s1) || isempty(s2)
    msgbox(['either newgroup1 or newgroup2 is empty...please fill those listboxes first! ']);
    return
end

col=[0.8549    0.7020    1.0000
    0.8549    0.7020    1.0000];
cols=round((col*255));
ch=round(([1 .84 0]*255));%colheader






%% ===============================================
nchar=size(char(z.groupcombs),2);
sp1=0;
space=5;
g1={[ '<html><span style="background-color: rgb(' ...
    num2str(cols(1,1)) ',' num2str(cols(1,2)) ',' num2str(cols(1,3)) ');">' 'GROUP-1: '...
   '<span style="background-color: rgb(255,255,255);">' ...
   repmat( '&nbsp;',[1 nchar-10+space])  ]};
g2={[ '<html><span style="background-color: rgb(' ...
    num2str(cols(2,1)) ',' num2str(cols(2,2)) ',' num2str(cols(2,3)) ');">' 'GROUP-2: ' ...
    '<span style="background-color: rgb(255,255,255);">'...
    repmat( '&nbsp;',[1 nchar-10+space])  ]};

g1=[g1; s1];
g2=[g2; s2];
siz=[size(g1,1) size(g2,1)];
if siz(1)<siz(2)
  %   q=regexprep( s1{1}, '<.*?>', '' )
    q=regexprep( s1{1}, {'<.*?>' '\s+'} ,{''} );
    %add=repmat(s1(end),[ siz(2)-siz(1) 1 ]);
    add=repmat({['<html>   '  repmat( '&nbsp;',[1 length(q)+space+1 ])  ]},[ siz(2)-siz(1) 1 ]);
    g1=[g1;add];
end

% dum=[ '<html><span style="background-color: rgb(255,255,255);">'  'klaus'  ];
dum='';
r=repmat({dum},max([size(g1,1) size(g2,1)]), 2);
r(1:size(g1,1),1)=g1;



for i=1:size(g2,1)
    len=length(regexprep(g1{i},{'<.*?>'},''));
    fill=[ '<span style="background-color: rgb(255,255,255);">'  repmat( '&nbsp;',[1 space+nchar-len])  ];
    r{i,2}=[fill regexprep(g2{i},{'<html>'},{''})  ];
    %  r{i,2}=[fill   ];
end

r2=plog([],[r],0,'e','al=1;plotlines=0' );

compNum=1 ; % ADD COMPARION-HEADER
w={['<html><hr>']};
w(end+1,1)={[ '<html><span style="background-color: rgb(' ...
    num2str(ch(1,1)) ',' num2str(ch(1,2)) ',' num2str(ch(1,3)) ');"><b>' ['COMPARISON:[' num2str(compNum) ']'...
    repmat( '&nbsp;',[1 100]) ] ]};
w2=[w;r2];

s3=[s3; w2];
% ix=regexpi2(s3,'COMPARISON:['); % renew comp-num
% for i=1:length(ix)
%   s3(ix(i),1) = {[ '<html><span style="background-color: rgb(' ...
%     num2str(ch(1,1)) ',' num2str(ch(1,2)) ',' num2str(ch(1,3)) ');"><b>' ['COMPARISON:[' num2str(i) ']'...
%     repmat( '&nbsp;',[1 100]) ] ]};
% end
s3=update_grpcomparisonHDR(s3);

set(h3,'String',s3);
if h3.Value==0
    h3.Value=1;
end


%% ============== log result =================================
v1=regexprep( s1, {'<.*?>' '\s+'} ,{''} );
v2=regexprep( s2, {'<.*?>' '\s+'} ,{''} );

if isfield(z,'nrewcomp')==0
   z.nrewcomp=[{v1} {v2}];
else
    z.nrewcomp(end+1,:)=[{v1} {v2}];
end

set(hf,'userdata',z);



%% ===============================================

%% ===============================================

function s3=update_grpcomparisonHDR(s3)

ch=round(([1 .84 0]*255));%colheader

if isempty(s3)
   return 
end
ix=regexpi2(s3,'COMPARISON:['); % renew comp-num
for i=1:length(ix)
  s3(ix(i),1) = {[ '<html><span style="background-color: rgb(' ...
    num2str(ch(1,1)) ',' num2str(ch(1,2)) ',' num2str(ch(1,3)) ');"><b>' ['COMPARISON:[' num2str(i) ']'...
    repmat( '&nbsp;',[1 100]) ] ]};
end

function cb_clear(e,e2,arg1)

if strcmp(arg1,'cleargroups')
    cb_sg([],[],'clear_group1');
    cb_sg([],[],'clear_group2');
elseif strcmp(arg1,'clearall') 
    cb_sg([],[],'clear_group1');
    cb_sg([],[],'clear_group2');
    cb_sg([],[],'clear_finalgroup');
end


function cb_sg(e,e2,arg1)

% disp(arg1);
hf= findobj(0,'tag','figsubgroup');


if strcmp(arg1,'ok') ||  strcmp(arg1,'cancel')
    z=get(hf,'userdata');
    if strcmp(arg1,'ok')
        z.isOK=1;
    else
        z.isOK=0;
    end
    set(hf,'userdata',z);
    uiresume(hf);   
elseif strcmp(arg1,'help')
    uhelp(mfilename);
elseif strcmp(arg1,'pb_group1') ||  strcmp(arg1,'pb_group2')
    h1=findobj(hf,'tag','list_inputgroup' );
    s1=h1.String(h1.Value);
    h2=findobj(hf,'tag',strrep(arg1,'pb','list'));
    s2=h2.String;
    if isempty(s2);
        s2=s1; 
    else
        s2=unique([s1;s2]);
    end
    set(h2,'string',s2);
    if h2.Value>size(h2.String,1)
       h2.Value=size(h2.String,1);
    end
    
elseif strcmp(arg1,'clear_group1') ||  strcmp(arg1,'clear_group2') || strcmp(arg1,'clear_finalgroup')
    h2=findobj(hf,'tag',strrep(arg1,'clear','list')  );
    set(h2,'value',1,'string','');
    
    if  strcmp(arg1,'clear_finalgroup')
         %-----------------
        z=get(hf,'userdata');  %update COMPARISONS
        z.nrewcomp={};
        set(hf,'userdata',z);
    end
    
elseif strcmp(arg1,'clearsel_group1') ||  strcmp(arg1,'clearsel_group2') 
    h2=findobj(hf,'tag',strrep(arg1,'clearsel','list')  );
    try
        valFirst=min(h2.Value);
        h2.String(h2.Value)=[];
        h2.Value=size( h2.String,1)   ;
        if size(h2.String,1)>=valFirst
            h2.Value=valFirst;
        else
            h2.Value=size( h2.String,1)   ;
        end
        
    catch
        h2.String=''; h2.Value=1;
    end
elseif strcmp(arg1,'pb_sort1') ||  strcmp(arg1,'pb_sort2') || strcmp(arg1,'pb_sort3')
    z=get(hf,'userdata');
    v=colorizeInput(z.groupcombs);
    to(1,1)=get(findobj(hf,'tag','pb_sort1'),'value');
    to(1,2)=get(findobj(hf,'tag','pb_sort2'),'value');
    to(1,3)=get(findobj(hf,'tag','pb_sort3'),'value');
    it=find(to==1);
    for i=1:length(to)
        if to(i)==1
            set(findobj(hf,'tag',['pb_sort' num2str(i)]),'backgroundcolor',[1 1 0] );
        else
            set(findobj(hf,'tag',['pb_sort' num2str(i)]),'backgroundcolor',[1 1 1] );
        end
    end
    if length(it)==1 && it(1)==1
        it(1)=-1;
    end
    
    [c2,idx]=sortrows(v.c,it);
    out=v.out(idx,:);
    hb=findobj(hf,'tag','list_inputgroup');
    set(hb,'string',out);
elseif strcmp(arg1,'clearsel_finalgroup')  
    hb=findobj(hf,'tag','list_finalgroup');
    s=get(hb,'string');
    ix=hb.Value;
    if  isempty(char(s))
       hb.Value=1;
       return
    end
    
    i1=regexpi2(s,{'COMPARISON:['});
    try
        if isempty(i1(max(find(i1<ix))))
            del(1)=1;
        else
            del(1)=i1(max(find(i1<ix)));
        end
        
        
        if isempty(i1(min(find(i1>ix)))) %last item
            del(2)=size(s,1);
        else
            del(2)=[i1(min(find(i1>ix)))-1];
        end
        compNum=str2num(regexprep(char(s(del(1))),{'.*.COMPARISON:[' '].*'},''));
        s3=s;
        s3(del(1):del(2))=[];
        %-----------------
        z=get(hf,'userdata');  %update COMPARISONS
        z.nrewcomp(compNum,:)=[];
        set(hf,'userdata',z);
        
    catch
        s3='';
    end
    if size(s3,1)>=ix
        hb.Value=ix;
    else
        hb.Value=size(s3,1);
    end
    s3=update_grpcomparisonHDR(s3);
    set(hb,'string',s3);
    
 elseif strcmp(arg1,'check_comps')     
    z=get(hf,'userdata');
    if isfield(z,'nrewcomp' )==0; 
        msgbox('no comparisons submitted');
        return;
    end
    %% ===============================================
    w2={};
    for  i=1:size(z.nrewcomp,1)
        
        g1=[z.nrewcomp{i,1}];
        g2=[z.nrewcomp{i,2}];
        g1=[  ' #kc  group-1'  ; g1 ];
        g2=[  ' #kl  group-2'  ; g2 ];
        r2=plog([],[g1; g2],0,'e','al=1;plotlines=0' );
        w1=[' #ko          NEW GGROUP COMPARISON [' num2str(i) '] ' repmat(' ',[1 10])];
        w1=[w1; r2];
        w2=[w2; w1];
    end
    drawnow;
    uhelp(w2,0,'name' ,'new group comparisons');
    %% ===============================================
    
end

% ==============================================
%%   helper
% ===============================================

return
get(get(gcf,'children'),'tag')

    'help'
    'cancel'
    'OK'
    'clearsel_finalgroup'
    'clear_finalgroup'
    'list_finalgroup'
    'clearsel_group2'
    'clearsel_group1'
    'clear_group2'
    'clear_group1'
    'submit'
    'list_group2'
    'list_group1'
    'pb_group2'
    'pb_group1'
    'list_inputgroup'
    ''
    ''
    ''
    ''


