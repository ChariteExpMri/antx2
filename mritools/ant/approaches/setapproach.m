% #ko SELECT APPROACH FOR IMAGE REGISTRATION 
% Select an approach form the left box. Information for this approach 
% is given in the right box.
% #r Alternatively, use a costumized approach. 
% For this, select the [>>] button and assign the 
% respective function from path via UI.
% 
% The assigned approach will be displayed right to the 'Approach' label
% Note that the used reference for an approach from the left listbox and
% a costumized function differ: 
%   - reference for an approach from the left listbox is #b numeric
%   - reference for a costumized function is a #b fullpath-filename
% Hit [OK] to select this approach
%
% shortcuts: use [+/-] to change fontsize




function varargout=setapproach
varargout{1}=[]; %OUTPUT
% clc;
delete(findobj(0,'tag','Approach'));
% ro=approaches(0,0);



makeWindow;


uiwait(gcf);

hfig=findobj(0,'tag','Approach');
if isempty(hfig); return;end
us=get(hfig,'userdata');
varargout{1}=us.selection;
close(hfig);


% ==============================================
%% MAKEWINDOW
% ===============================================

function makeWindow()

[app] = spm_select('List',fileparts(which('setapproach.m')),'.m');
app=cellstr(app);
app=setdiff(app,'setapproach.m');


% regexprep(regexprep('sssjk_sss_10.m','.*_',''),'.m','')
idunsort=str2num(char(regexprep(regexprep(app,'.*_',''),'.m','')));
[~,isort]=sort(idunsort);

alist    =cellfun(@(a){[ repmat(' ',[1 4-length(num2str(a)) ]) num2str(a)]},  num2cell(idunsort(isort)));
alistfun =app(isort);
%% ===============================================

%----approaches with nonNumeric suffix
ir=find(ismember(app,alistfun)==0);
alistfun=[alistfun; app(ir)];
alist=[alist; regexprep(app(ir),{'^approach_','.m$'},'')];
%% ===============================================


% 
% alist    ={'1' '2' '3' '4'};
% alistfun ={'xcoreg.m' 'xbruker2nifti.m' 'xwarp3.m' 'mean'};

us.alist    =alist;
us.alistfun =alistfun;


%% ==============================================
%%   figure + approachLB
hf=figure; set(gcf,'color','w','units','normalized','menubar','none','name',[' set approach [' mfilename '.m' ']'],...
    'NumberTitle','off','tag','Approach','KeyPressFcn',@Key);

set(hf,'userdata',us);
hl=uicontrol('style','text','units','norm','position',[0.025 .9 .13 .04]);
set(hl,'string','Approach','HorizontalAlignment','left','fontsize',9,'backgroundcolor','w');

lb=uicontrol('style','listbox','units','norm','position',[.005 .3 .15 .6],'tag','approachlist');
set(lb,'string',alist,'callback',@selectthis,'tooltipstring','available approaches');
set(lb,'FontName','courier','fontweight','bold','fontsize',8);

lb=uicontrol('style','radio','units','norm','position',[.005 .3 .15 .6],'tag','radio_showfilecontent');
set(lb,'string','show content','callback',@radio_showfilecontent,'fontsize',7);
set(lb,'position',[.85 .25 .15 .05],'backgroundcolor','w','tooltipstring','show file content','value',0);

%% ==============================================
%% helpLB

hl=uicontrol('style','text','units','norm','position',[.4 .9 .3 .04]);
set(hl,'string','Approach Information','HorizontalAlignment','center','fontsize',9,'backgroundcolor','w');

hh=uicontrol('Style','listbox','units','norm','position',[.15 .3 .85 .6],'tag','approachhelp',...
    'String', '','tooltipstring','information about this approach','fontsize',8);

% msg={'<HTML><bgcolor="green">green background', ...
%     '<HTML><FONT color="red" size="+2">Large red font</FONT></HTML>', ...
%     '<HTML><bgcolor="#FF00FF"><PRE>fixed-width font'}
% set(hh,'string',msg);


%% ==============================================
%% OK/CANCEL/HELP

hbt=uicontrol('style','pushbutton','units','norm','position',[.67 .01 .15 .04]);
set(hbt,'string',['OK'], 'HorizontalAlignment','center','fontsize',9,'backgroundcolor','w',...
    'Callback',{@usethis,1});
set(hbt,'tooltipstring','ok,select this approach');
set(hbt,'units','pixels');

hbt=uicontrol('style','pushbutton','units','norm','position',[.82 .01 .15 .04]);
set(hbt,'string',['Cancel'],'HorizontalAlignment','center','fontsize',9,'backgroundcolor','w',...
    'Callback',{@usethis,2});
set(hbt,'tooltipstring','cancel .. do nothing');

set(hbt,'units','pixels');

hbt=uicontrol('style','pushbutton','units','norm','position',[.01 .01 .15 .04]);
set(hbt,'string',['Help'],'HorizontalAlignment','center','fontsize',9,'backgroundcolor','w',...
    'Callback',{@xhelp});
set(hbt,'tooltipstring','information about this gui');

set(hbt,'units','pixels');


%% ==============================================
%% Assign pb/tx/edit
hx=uicontrol('style','pushbutton','units','norm','position',[0 0 .04 .04]);
set(hx,'string',['>>'], 'HorizontalAlignment','left','fontsize',8,'backgroundcolor',[ 1.0000    0.8431         0]);
set(hx,'position',[0.02 .15 .04 .04],'tag','pbassign','fontweight','bold');
set(hx,'tooltipstr','select button to assign a costumized approach (function) from path','callback',@selectfunction);
% set(hx,'units','pixels')


hx=uicontrol('style','text','units','norm');
set(hx,'string',['selected Approach: '],'fontsize',8,'backgroundcolor','w','fontweight','bold');
set(hx,'position',[0.07 0.15 .89 .04],'HorizontalAlignment','left','tag','txassigned','fontsize',8);
set(hx,'tooltipstr','this approach will be used');
set(hx,'backgroundcolor',[0.8941    0.9412    0.9020]);
% set(hx,'units','pixels');


hx=uicontrol('style','text','units','norm','position',[0 0.15 .18 .04]);
set(hx,'string',['<empty>'], 'HorizontalAlignment','left','fontsize',10,'backgroundcolor',[0.8941    0.9412    0.9020]);
set(hx,'position',[.07 0.12 .89 .04],'tag','assigned','fontweight','bold','foregroundcolor',[0 .5 0]);
set(hx,'tooltipstr','this approach will be used');
% set(hx,'units','pixels');


selectthis(0,0);drawnow; 
makeGraySelection(hh);

set(get(gcf,'children'),'KeyPressFcn',@Key);


% ==============================================
%%   
% ===============================================

function radio_showfilecontent(e,e2)
selectthis(0,0);drawnow



function usethis(e,e2,par)
us=get(gcf,'userdata');

if par==2%cancel
    us.selection=[]; 
elseif par==1 %OK
    ap=get(findobj(gcf,'tag','assigned'), 'string');
    if length(ap)<3 %intern approach
        ap=str2num(ap);
    end
    us.selection=ap;
end
set(gcf,'userdata',us);
 uiresume(gcf);

%% ________________________________________________________________________________________________

function selectthis(e,e2)
us=get(gcf,'userdata');
hl=findobj(gcf,'tag','approachlist');
va=get(hl,'value');
fun=us.alistfun{va};


hr=findobj(gcf, 'tag','radio_showfilecontent');
if get(hr,'value')==1
  r=preadfile(which(fun)); 
  rr=r.all;
else
   r=help(fun); 
   r=strsplit(r,char(10))';
   rr=uhelp(r,[],'export',1);
   if isempty(char(rr))
      rr={[' <html> #m there is no help for "' fun '"']
          [' #m there is no help for "' fun '"']} ;
   end
end


set(findobj(gcf,'tag','approachhelp'),'value',1);
set(findobj(gcf,'tag','approachhelp'),'string',rr);
set(findobj(gcf,'tag','assigned'), 'string', regexprep(us.alist{va},'\s*',''),...
    'tooltipstring',['this approach will be used: ' char(10) [ us.alist{va} ' ..which is ' us.alistfun{va}  ]]);



function selectfunction(e,e2)

[t,sts] = spm_select(1,'any','select an approach (function) ','',pwd,'.*.m','');
if isempty(t); return;end
set(findobj(gcf,'tag','assigned'), 'string',t,'tooltipstring',...
    ['this approach will be used: ' char(10) t]);



function makeGraySelection(hh)

if ispc
    funits =get(gcf,'units');
    set(gcf,'units','pixels');
    fpos   =get(gcf,'position');
    % set(0,'PointerLocation',[1000 500]);
    set(0,'PointerLocation',[fpos(1)+100 fpos(2)+100]);
    set(gcf,'units',funits);
    
    import java.awt.*;
    import java.awt.event.*;
    %Create a Robot-object to do the key-pressing
    
    rob=Robot;
    rob.mousePress(InputEvent.BUTTON1_MASK );
    rob.mouseRelease(InputEvent.BUTTON1_MASK );
    
    % rob.mouseMove(1105,309);
    rob.keyPress(KeyEvent.VK_TAB); rob.keyPress(KeyEvent.VK_TAB);
    %  pause(.1)
    rob.keyPress(KeyEvent.VK_TAB); rob.keyPress(KeyEvent.VK_TAB);
    %   pause(.1)
    %  rob.keyPress(KeyEvent.VK_TAB); rob.keyPress(KeyEvent.VK_TAB)
    % drawnow
    % % uicontrol(lb)
    % drawnow;pause(.3)
    jListbox = findjobj(hh);
    % drawnow;pause(.3)
    jListbox=jListbox.getViewport.getComponent(0);
    % drawnow;pause(.3)
    jListbox.setSelectionAppearanceReflectsFocus(0);
    % drawnow;pause(.3)
end


function xhelp(e,e2)


uhelp(mfilename)
makeGraySelection(findobj(0,'tag','txt'))


function Key(e,e2)


if strcmp(e2.Character, '+')
    
    h(1)=findobj(gcf,'tag','approachhelp');
    fs=get(h(1),'fontsize');
    set(h(1),'fontsize',fs+1);
 
elseif strcmp(e2.Character, '-')
    h(1)=findobj(gcf,'tag','approachhelp');
    fs=get(h(1),'fontsize');
    if fs>3
        set(h(1),'fontsize',fs-1);
    end
end

    