
function sub_plotregions(varargin)

% fg; 
% hs=gcf;
% set(hs,'units','norm','menubar','none','position',[0.1632    0.4178    0.1410    0.5211]);
% 
% 
%COMAND LINES
% sub_plotregions('clear')
% sub_plotregions('transp',0.5); %set region transparency

if nargin~=0
%     if length(varargin)==1
%         par=struct();
%         par=setfield(par,varargin{1},varargin{1});
%     else
%         par=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
%     end
    
    if mod(length(varargin),2)==0
        par=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    else % odd
        if length(varargin)==1
            par=struct();
            par=setfield(par,varargin{1}, varargin{1});
        else
            par=cell2struct(varargin(3:2:end),varargin(2:2:end),2);
            par.set='set';
        end
    end
    
    
    
    
    if isfield(par,'clear');      
          selectallregions([],[],'deselectAll');    
    end
    if isfield(par,'transp')
        %par.transp=0.1
        hc=findobj(findobj(0,'tag','regionselect'),'tag','alphaall');
        set(hc,'string',num2str(par.transp));
        hgfeval(get(hc,'callback'),hc);
    end
    

    return
end


delete(findobj(0,'tag','regionselect'));

hs=findobj(0,'tag','xvol3d'); u=get(hs,'userdata');


% ==============================================
%%   uitable
% ===============================================
hs=findobj(0,'tag','xvol3d'); 
u=get(hs,'userdata');
tv=[num2cell(logical(zeros(size(u.lu(:,1),1),1)))  u.lu(:,1)  ...
    cellfun(@(a){ [num2str(a)]}, u.lu(:,4)) ...
    repmat({'c'},[size(u.lu,1) 1]) ...
    u.lu(:,3)  ];
% rownames=cellfun(@(a){ [num2str(a)]},num2cell(1:size(u.lu(:,1),1),1)');
if isfield(u,'selectedRegion')
    tv(:,1)=num2cell(logical(u.selectedRegion));
    
end

fg;
hk=gcf;
set(hk,'units','normalized','menubar','none'); 
set(hk,'position',[0.2986    0.4000    0.5611    0.4667]);
set(hk,'tag','regionselect','NumberTitle','off','name','regions');

hv=uicontrol('Style', 'text','string','');
mxlen=[];
for i=1:size(tv,2)
    i2len=cell2mat(cellfun(@(a){ [length(a)]},tv(:,i)));
    str=tv{max(find(i2len==max(i2len))),i};
    if isnumeric(str); str=num2str(str); 
    elseif islogical(str); str=num2str(str); end
    set(hv,'string',str);
    ext=get(hv,'Extent');
    mxlen(1,i)=ext(3);
   % disp(mxlen);
end
ColumnWidth=['auto' num2cell(mxlen(2:end)+10)];
delete(hv);

columnname   ={'select'  'name'  'ID'   'c'   'color'};
columnformat ={'logical' 'char'  'char' 'char' 'char'};
editable=logical([1 0 0 1 1]);



% Create the uitable
t = uitable;
%  jTabGroup = findjobj(t); 
% jtable = jTabGroup.getViewport.getView; 
% 
% %Now turn the JIDE sorting on 
% jtable.setSortable(true);      % or: set(jtable,'Sortable','on'); 
% jtable.setAutoResort(true); 
% jtable.setMultiColumnSortable(true); 
% jtable.setPreserveSelectionsAfterSorting(true);        
        


set(t,'Data', tv,... 
            'ColumnName', columnname,...
            'ColumnFormat', columnformat,...
            'ColumnEditable', editable,...
            'ColumnWidth',    ColumnWidth,...
            'RowName',[]);
        


drawnow;
        
set(t,'units','normalized','position',[0 0 1 .9])        
 set(t,'CellSelectionCallback',@CellSelectionCallback)
set(t,'CellEditCallback',@CellSelectionCallback)
u.t=t;
set(gcf,'userdata',u);
% ==============================================
%%   sort
% ===============================================

delete(findobj(gcf,'tag','sortx'));
for i=1:size(tv,2)
    hw=uicontrol('style','pushbutton','units','norm',...
        'string',['sort-' columnname{i}],'fontsize',7);
    set(hw,'tag','sortx','position',[  [i]*0.15-.15 .9 .15 .05 ]);
    set(hw,'callback',@sortx,'userdata',i)
end

u.tsort=zeros(1,size(tv,2));
u.tv=tv;
set(gcf,'userdata',u);

% ==============================================
%%   facealpha
% ===============================================
try
    transdefault=get(findobj(findobj(0,'tag','winselection'),'tag','regiontransparency'),'string');
catch
    transdefault='0.2' ;
end

hw=uicontrol('style','edit','units','norm','string',transdefault,'fontsize',8);
set(hw,'tag','alpha','position',[  [6]*0.15-.15 .9 .05 .03 ]);
set(hw,'tooltipstr','region transparency used when selected');

hw=uicontrol('style','edit','units','norm','string',transdefault,'fontsize',8);
set(hw,'tag','alphaall','position',[  [6]*0.15-.15+.05 .9 .05 .03 ]);
set(hw,'tooltipstr','set region transparency for all regions','callback',@settransparencyAllregs);

% ==============================================
%%   select all
% ===============================================

hw=uicontrol('style','radio','units','norm');
set(hw,'tag','selectallregions','position',[  .9 .9 .15 .03 ],...
    'fontsize',8,'string','all regs');
set(hw,'tooltipstr','select/unselect all regions','backgroundcolor','w');%,
set(hw,'callback',{@selectallregions});

hw=uicontrol('style','pushbutton','units','norm');
set(hw,'tag','deselectallregions','position',[  .9 .94 .08 .04 ],...
    'fontsize',8,'string','deselect all');
set(hw,'tooltipstr','deselect all regions','backgroundcolor','w');%,
set(hw,'callback',{@selectallregions,'deselectAll'});

% LABEL
%Label 
hw=uicontrol('style','togglebutton','units','norm');
set(hw,'tag','lab','position',[  .76 .94 .04 .04 ],...
    'fontsize',7,'string','Lab');
set(hw,'tooltipstr','show region labels','backgroundcolor','w');%,
set(hw,'callback',{@showlabel});
try
    val=get(findobj(findobj(0,'tag','xvol3d'),'tag','showlabel'),'value');
    set(hw,'value',val);
end


%Label prop
hw=uicontrol('style','pushbutton','units','norm');
set(hw,'tag','labelprop','position',[  .8 .94 .04 .04 ],...
    'fontsize',7,'string','Lprop');
set(hw,'tooltipstr','set region label properties','backgroundcolor','w');%,
set(hw,'callback',{@labelprop});


% ==============================================
%%   OS-dependency
% ===============================================
if isunix==1 && ismac==0
    set(findobj(findobj(0,'tag','regionselect'),'type','uicontrol'),'fontsize',7);
end

% ==============================================
%%   color pre-selected regions
% ===============================================

ix=find(cell2mat(u.tv(:,1))==1);
for i=1:length(ix)
    regID  =str2num(u.tv{ix(i),3});
    label  =        u.tv{ix(i),2};
    regcol =str2num(u.tv{ix(i),5});
    
    
    cprintf([ 0.8510    0.3294    0.1020],['..painting: ' label]);
    task=1;
    paintregion(task,regID,label,regcol)
end



labeldefaults();


% ==============================================
%%   showlabels
% ===============================================
function showlabel(e,e2)
hf=findobj(0,'tag','xvol3d');
figure(hf);
hr=findobj(0,'tag','regionselect');
if get(findobj(hr,'tag','lab'),'value')==1
    xvol3d('regionlabels','on')
else
    xvol3d('regionlabels','off');
end
% figure(hr);

% ==============================================
%%   label properties
% ===============================================

function labeldefaults()
hf=findobj(0,'tag','xvol3d');
u=get(hf,'userdata');

if isfield(u,'lab'); 
    return; 
end

if isfield(u,'lab')==0; u.lab.dummi=1; end
if isfield(u.lab,'fs')           ==0;  u.lab.fs=7        ; end
if isfield(u.lab,'fcol')         ==0;  u.lab.fcol=[0 0 0]  ; end
if isfield(u.lab,'fhorzal')      ==0;  u.lab.fhorzal=2  ; end

if isfield(u.lab,'needlevisible')==0;  u.lab.needlevisible=1; end
if isfield(u.lab,'needlelength')==0;   u.lab.needlelength=20; end
if isfield(u.lab,'needlecol')   ==0;   u.lab.needlecol=[0 0 0]  ; end
set(hf,'userdata',u);

function labelprop(e,e2)
hf=findobj(0,'tag','xvol3d');
u=get(hf,'userdata');


% ==============================================
%%   GUI
% ===============================================

prompt = {'fontsize (numeric)',        'font color [R,G,B]'...
    'Horizontal Alignment (1)left,(2)center,(3)right' ...
    'needle visible [0]no,[1]yes' 'needle length' ,'needle color  [R,G,B]'};
dlg_title = 'label properties';
num_lines = 1;
defaultans = {...
    num2str(u.lab.fs), ...
    num2str(u.lab.fcol), ....
    num2str(u.lab.fhorzal), ...
    num2str(u.lab.needlevisible), ...
    num2str(u.lab.needlelength),...
    num2str(u.lab.needlecol),...
    };
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
if isempty(answer); return; end
u.lab.fs            =str2num(answer{1});
u.lab.fcol          =str2num(answer{2});
u.lab.fhorzal       =str2num(answer{3});
u.lab.needlevisible =str2num(answer{4});
u.lab.needlelength  =str2num(answer{5});
u.lab.needlecol     =str2num(answer{6});

set(hf,'userdata',u);


%select([],[],'nodelabel');






% ==============================================
%%   
% ===============================================
function sortx(e,e2)
% 'a'
col=get(e,'userdata');
u=get(gcf,'userdata');

dat=u.t.Data;

if u.tsort(col)==0
    if col==1
       dx=[ dat num2cell(double(cell2mat(dat(:,col))))];
       dat2=sortrows(dx,size(dx,2)); dat2(:,end)=[];
    elseif col==3    
       dx=[ dat  num2cell(str2num(char(dat(:,col))))];
       dat2=sortrows(dx,size(dx,2)); dat2(:,end)=[];
    else
        dat2=sortrows(dat,col);
    end
    u.t.Data=dat2;
    u.tsort(col)=1;
    set(gcf,'userdata',u);
    set(e,'backgroundcolor',[1 0 0]);
elseif u.tsort(col)==1
      if col==1
       dx=[ dat num2cell(double(cell2mat(dat(:,col))))];
       dat2=flipud(sortrows(dx,size(dx,2))); dat2(:,end)=[];
    elseif col==3    
       dx=[ dat  num2cell(str2num(char(dat(:,col))))];
       dat2=flipud(sortrows(dx,size(dx,2))); dat2(:,end)=[]; 
    else
        dat2=flipud(sortrows(dat,col));
    end
    u.t.Data=dat2;
    u.tsort(col)=2;
    set(gcf,'userdata',u)   ;
    set(e,'backgroundcolor',[0 0 1]);
elseif u.tsort(col)==2
    soll=u.tv(:,2);
    
    [~,ia,ib]=intersect(soll,dat(:,2),'stable');
    %[dat(ib,2) soll]
    dat2=dat(ib,:);
    u.t.Data=dat2;
    u.tsort(col)=0;
    set(gcf,'userdata',u)   ;
    set(e,'backgroundcolor',[0.9400    0.9400    0.9400]);
    
end


function settransparencyAllregs(e,e2);

regs=findobj(findobj(0,'tag','xvol3d'),'tag','region');
set(regs,'facealpha',str2num(get(e,'string')));

set(findobj(findobj(0,'tag','winselection'),'tag','regiontransparency'),...
    'string',get(e,'string'));


function CellSelectionCallback(e,e2)


ic=e2.Indices;

try
    if ic(2)==1;
        stat=e2.Source.Data{ic(1),ic(2)};
        dat=e2.Source.Data;
        
        regID=str2num(dat{ic(1),3});
        label=dat{ic(1),2};
        % datvec=dat(ic(1),:);
        regcol=str2num(dat{ic(1),5});%./255;
        
        if stat==1
              %disp(['..painting: ' label]);
              cprintf([ 0.8510    0.3294    0.1020],['..painting: ' label ' [ID: ' num2str(regID) ']' ]);
            task=1;
            paintregion(task,regID,label,regcol)
        else
            %disp(['..unpainting: ' label]);
            cprintf([ 0.8510    0.3294    0.1020],['..unpainting: ' label  ' [ID: ' num2str(regID) ']' ]);
            task=0;
            paintregion(task,regID,label,regcol)
        end
    elseif ic(2)==4 || ic(2)==5;
        setcolor(ic);
    end
end
cprintf([ 0.8510    0.3294    0.1020],['\n']);
% ==============================================
%% SETCOLOR
% ==============================================
function setcolor(ic);
    hf=findobj(0,'tag','regionselect');
    u=get(hf,'userdata');
    dx=u.t.Data;
    
if ic(2)==4;  
     newcol=uisetcolor;
    dx{ic(1),ic(2)+1}=regexprep(num2str(newcol),'\s+',' ');
    
    if 0
        jScrollpane = findjobj(u.t);                % get the handle of the table
        scroll = jScrollpane.getVerticalScrollBar.getValue;  % get the current position of the scroll
        %set(handles.myuitable, 'Data', out);
        u.t.Data=dx;
      drawnow
        jScrollpane.getVerticalScrollBar.setValue(scroll);     % set scroll position to the end
        %jScrollpane.getVerticalScrollBar.setValue(scroll);
    end
    
    if 1
        newcolStr=regexprep(num2str(newcol),'\s+',' ');
        jscroll = findjobj(u.t);
        jtable = jscroll.getViewport.getComponent(0);
        %jtable.setValueAt(java.lang.String('This value will be inserted'),0,0); % to insert this value in cell (1,1)
        jtable.setValueAt(java.lang.String(newcolStr),ic(1)-1,5-1); % to insert this value in cell (1,1)
    end
        
    
%     jscrollpane = javaObjectEDT(findjobj(u.t));
%     viewport    = javaObjectEDT(jscrollpane.getViewport);
%     jtable      = javaObjectEDT( viewport.getView );
%     scroll=jscrollpane.getVerticalScrollBar.getValue;  % get the current position of the scroll
%        u.t.Data=dx;
% %     drawnow
% %     scroll
%     jtable.scrollRowToVisible(ic(1));
% %     jscrollpane.getVerticalScrollBar.setValue(ic(1));  
    
  
end
    
    regID=str2num(dx{ic(1),3});
    hp=findobj(findobj(0,'tag','xvol3d'),'userdata',regID);
    set(hp,'facecolor',str2num(dx{ic(1),5}));
    
 updateLUtable(regID)   
 
 
function selectallregions (e,e2,deselect)
hf=findobj(0,'tag','regionselect');
u2=get(hf,'userdata');
 dx=u2.t.Data;


 
 if exist('deselect'); %DESELECT ALL
     if strcmp(deselect,'deselectAll');  
         set(findobj(hf,'tag','selectallregions'),'value',0);
         e=findobj(hf,'tag','selectallregions');
     end
 end
%  return
%  jscroll = findjobj(u2.t);
%  jtable = jscroll.getViewport.getComponent(0);
%  %jtable.setValueAt(java.lang.String('This value will be inserted'),0,0); % to insert this value in cell (1,1)
%  jtable.setValueAt(java.lang.String(1),6,0)

u=get(hf,'userdata');
if get(e,'value')==1
    u.tv(:,1)={1};
    task=1;
    ix=find(cell2mat(u.tv(:,1))==1);
    msg='painting ';
     dx(:,1)={true};

else
    
    dt=u.t.Data;  % cuurently displaed data
    selectedIDs =dt(find(cell2mat(dt(:,1))==1),3);
    u.tv(:,1)={0};
    task=0;
    %ix=1:size(u.tv,1);
     msg='unpainting ';
     dx(:,1)={false};
     ix=find(ismember(u.tv(:,3),selectedIDs));
end
set(u2.t,'Data',dx);
set(hf,'userdata',u);  


for i=1:length(ix)
    regID  =str2num(u.tv{ix(i),3});
    label  =        u.tv{ix(i),2};
    regcol =str2num(u.tv{ix(i),5});
    
    
%     disp([msg label]);
% ' [ID: ' num2str(regID) ']' 
cprintf([ 0.8510    0.3294    0.1020],[msg label ' [ID: ' num2str(regID) '] \n']);

    paintregion(task,regID,label,regcol);
end


 % ==============================================
%%   updateLUtable ...to reopen regselection window
% ===============================================
function updateLUtable(regID) 
% update lu and selectedRegion
hf=findobj(0,'tag','xvol3d');       u =get(hf,'userdata');
hr=findobj(0,'tag','regionselect'); ur=get(hr,'userdata');

tb=ur.t.Data; %tableData
if ~isfield(u,'selectedRegion') %if not exist
    u.selectedRegion=double(zeros(size(u.lu,1),1));
    set(hf,'userdata',u);
end
% u.t can be sorted !!!! not index rathner ID-comparison
itb =find(str2num(char(tb(:,3)))==regID);
ilu =find(cell2mat((u.lu(:,4)))==regID);

tbsel =double(cell2mat(tb(itb,1)));
lusel =u.selectedRegion(ilu,1);

% if tbsel~=lusel
%    disp('different');
   
   u.selectedRegion(ilu)  =tbsel; %update un/selection
   u.lu{ilu,3}             = char(tb(itb,5)); %update color
   set(hf,'userdata',u);
% u.lu(ilu,:)
% ans = 
%   Columns 1 through 3
%     'Primary somatosen�'    [188064]    '0.094118 0.50196 �'
%   Columns 4 through 5
%     [329]    '981;201;1047;1070�'
% tb(itb,:)
% ans = 
%   Columns 1 through 4
%     [1]    'Primary somatosen�'    '329'    'c'
%   Column 5
%     '0.094118 0.50196 �'
% else
%     disp('same');
% end



% ==============================================
%%   paint
% ===============================================

function paintregion(task,regID,label,regcol)

hs=findobj(0,'tag','xvol3d'); u=get(hs,'userdata');

hlu=u.hlu;
lu=u.lu;

iID=find(strcmp(hlu,'ID'));
ich=find(strcmp(hlu,'Children'));

idvec=cell2mat(lu(:,iID));
ix=find(idvec==regID);
ch=lu{ix,ich};
if isnumeric(ch)==0
   ch= str2num(char(ch));
end
ch(isnan(ch))=[];

nodes=unique([regID; ch]);

if task==1
    delete(findobj(findobj(0,'tag','xvol3d'),'userdata',regID));
    
    hp=[];
    r=zeros(size(u.atl)); 
    for i=1:length(nodes)
       r((u.atl==nodes(i)))=1; 
    end
    disp(sum(r(:)));
    if sum(r(:))>1130000;%1000 ;%
        [x,y,z,d2] = reducevolume(r,[2 2 2]);
    else
        [x,y,z,d2] = reducevolume(r,[1 1 1 ]);
    end
    d2 = smooth3(d2);
       
    if unique(r(:))==0
         cprintf([ 0.8510    0.3294    0.1020],['..not FOUND IN ATLAS']);
       return
    end
    
    figure(findobj(0,'tag','xvol3d'));
    
    FV=isosurface(x,y,z,d2,.001);
    FV2=smoothpatch(FV,1,10); 
    
    px = patch(FV2,...
        'FaceColor','blue','EdgeColor','none');
    set(px,'tag','region');
   % set(px,'facealpha',.1,'userdata',unis(i,:));
    set(px,'facecolor',regcol);
    set(px,'userdata',regID);
    
    halpha=findobj(findobj(0,'tag','regionselect'),'tag','alpha');
    set(px,'facealpha',str2num(get(halpha,'string')));
    
    set(px,'ButtonDownFcn',['disp('''  label ''')']);
    setappdata(px,'label',label);
    
elseif task==0
    
   % findobj(findobj(0,'tag','xvol3d'),'tag','region')
   thisreg=findobj(findobj(0,'tag','xvol3d'),'userdata',regID);
   delete(thisreg);
    
end

updateLUtable(regID)










