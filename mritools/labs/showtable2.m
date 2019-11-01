

function showtable2(pos,tab,varargin)

if 0

    showtable2([0 0 1 1],tab,'fontsize',9,'fontweight','normal','backgroundcolor','w')


    if ~exist('fontsize','var'); fontsize=8;end
    if ~exist('color','var');   color='k';end

end


colbg=[1 1 1; 1 1 .8;];
for i=1:size(colbg,1);
    colbghex(i,:)  = reshape(dec2hex(  round( colbg(i,:).*255))' ,[6 1])';
end
colbghead=    reshape(dec2hex(  round( [1 .7 .4] .*255))' ,[6 1])';
colfont=      reshape(dec2hex(  round( [0 0   1] .*255))' ,[6 1])';



for i=1:size(tab,2)
    kn=char([tab(:,i);  ]);
    for j=1:size(tab(:,i),1)
        dum= tab{j,i};
        if isempty(regexpi(dum,'#['))  
%         labely{j,i}=  [repmat(' ' ,[1 1+size(kn,2)-length(dum)])  dum  ' ' ];
        labely{j,i}=  [repmat(' ' ,[1  size(kn,2)-length(dum)])  dum  ' ' ];
        else  %color
           delcol=length(strfind(dum,'#[')  : strfind(dum,']')  );
            labely{j,i}=  [repmat(' ' ,[1  size(kn,2)-length(dum)+delcol])  dum  ' ' ]; 
        end
    end
end
dx=labely;
dz={};dz2={};
% colf=  'black';
for i=1:size(dx,1)
    dy='';dy2='';
    for j=1:size(dx,2)
        df=dx{i,j};
        
        if ~isempty(strfind(df,'#['));
            icol1 =strfind(df,'#[')+1;
            icol2=strfind(df,'] ');
            dfcol=df(icol1:icol2);
            df=df([1:icol1-2 icol2+1:end]);
            eval(['mycolor=' dfcol ';']);
            mycolor=reshape(dec2hex(  round( mycolor.*255))' ,[6 1])';
            doMycol=1;
        else
            doMycol=0; 
        end
        
        if i==1
            df=[ '<b><u><font color="black"   bgcolor="' colbghex(rem(j,2)+1,:) '">'  df  '</b>' '</font>'  ];
        else
            if j~=2
                 colf=  'black';
                bold='';
            else
                colf=  colfont;
                bold='<b>';
            end
           
%            if i==3%%i==3;
             if doMycol==1%%i==3;
               colf= mycolor;% 'FF00FF'; 
                 bold='<b>';
            end
            if rem(i-1,5)==0 | i==size(dx,1)
                underline='<u>';
            else
                underline='';
            end
            
                df=[underline bold '<font color="'  colf '" bgcolor="' colbghex(rem(j,2)+1,:) '">'  df  '</b>' '</font>'  ];
        end

        %     if rem(j,2)==0
        %          if j==2
        %             df=['<html>' vorl{2,2} df  vorl{2,3}]

        %         end
        dy =[dy df      ];%HTML
        dy2=[dy2 dx{i,j}];%RAW
    end
    dz{i,1} =dy;
    dz2{i,1}=dy2;
end

dz=cellfun(@(dz) {['<html><pre>' dz '</pre>']} ,dz);

fontsize=9;
fig= findobj(0,'tag','tabelz');
if ~isempty(fig);
    posfig=get(fig,'position') ;
    lb=findobj(fig,'tag','txt');
    set(lb,'string',dz);
else

    figure;set(gcf,'color','w',    'tag' ,'tabelz'   );
    set(gcf,'units','normalized','menubar','none');
    set(gcf,'position',[0.7090    0.7911    0.1743    0.1767]);
    fig= findobj(0,'tag','tabelz');
    set(gcf,'name','CURRENT LABEL');
 
    
    try
        warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
        jframe=get(fig,'javaframe');
        icon=strrep(which('labs.m'),'labs.m','monkey.png');
        jIcon=javax.swing.ImageIcon(icon);
        jframe.setFigureIcon(jIcon);
    end

    %     if ~isempty(fig);
    %         set(gcf,'position',posfig) ;
    %     end




    if isempty(pos)
        pos=[0 0 1 1];
    end
    % p =  get(hx,'position');
    h= uicontrol('tag','txt', 'units','normalized','Style', 'listbox', 'String', dz,...
        'position',pos,'backgroundcolor','w',...
        'foregroundcolor','k','fontsize',fontsize     );
    set(h,'FontName','courier new');
    set(h,'Callback',@clicked)

    if ~isempty(varargin)
        set(h,varargin{:});
    end

    if 0
        set(gcf,'units','characters');
        pos=get(gcf,'position');
        % pos(3)=pos(1)+length(dz2{1,:})-30
        pos(3)=length(dz2{1,:})+80;
        % pos(4)=size(dz2,1)+1
        set(gcf,'position',pos);
        set(gcf,'units','normalized');
        pos=get(gcf,'position');
        pos(1)=.1;
        set(gcf,'position',pos);
    end


    %----------------------------------
    %         context
    %----------------------------------
    cmenu = uicontextmenu;
    set(h,'UIContextMenu', cmenu);
    item1 = uimenu(cmenu, 'Label','table to workspace ', 'Callback', {@gcontext, 1});%ws
    item2 = uimenu(cmenu, 'Label','save table',          'Callback', {@gcontext, 2});%save
end
% set(gcf,'WindowScrollWheelFcn',{@gwheel,1});
% -----------------------------------------------------------


% x.scroll   =findjobj(fig,'Class', 'UIScrollPane$1');%scroll
x.fontsize =fontsize;
x.evntModifier=0;
x.table    =dz2;
x.tablec   =tab;
set(fig,'userdata',x);

if isempty(findobj(findobj('Tag','tabelz'),'tag','aot'))%ALWAYS ON TOP
    set(0,'currentfigure', findobj('Tag','tabelz') );
    b1 = uicontrol('Style', 'checkbox', 'String', '','fontsize',8,...%'pushbutton'
        'units','normalized','TooltipString','toggle: alway on top',...
        'Position', [0 0 .07 .07], 'Callback', @ontop,'backgroundcolor',[1 1 1],'tag','aot');


end

%  r=findobj(fig,'tag','aot');
%   set(r,'value',newstate);
% ontop;

function ontop(src,evnt)

us=get(gcf,'userdata');
if isfield(us,'aot')==0;
    us.aot=0;
end

try
    fig=findobj('Tag','tabelz');
newstate=abs(mod([us.aot],2)-1);
  jFrame = get(handle(fig),'JavaFrame');
  jFrame.fFigureClient.getWindow.setAlwaysOnTop(newstate);
  
  r=findobj(fig,'tag','aot');
  set(r,'value',newstate);
  
  us.aot=newstate;
  set(gcf,'userdata',us);
end
 
  

function clicked(hh,ss)
x=get(gcf,'userdata');
lb=findobj(gcf,'tag','txt');
val=get(lb,'value');
cords=str2num(x.tablec{val,2});
disp(cords);
try
hMIPax = findobj('tag','hMIPax');
spm_mip_ui('SetCoords',cords,hMIPax);
showbrodmann.m
end


%----------------------------------
%           contextmenu
%----------------------------------
function gcontext(obj, event, mode)
x= get(gcf,'userdata');
if mode==1
    label.table =x.table ;
    label.tablec=x.tablec;
    assignin('base','label' ,label);
    disp('struct "label" assigned to workspace');
elseif mode==2
    [fi pa]=uiputfile(pwd,'save table');
    if fi~=0
        pwrite2file(fullfile(pa,fi),x.table),
    end
    
end



%----------------------------------
%           mousewheel
%----------------------------------
function gwheel(obj, event, mode)

try
    x=get(gcf,'userdata');
    if  x.evntModifier==0 %[scroll text]
        x=get(gcf,'userdata'); scroll=x.scroll;
        try
%             set(scroll,'value',   get(scroll,'value')  +event.VerticalScrollCount*25);
%             set(scroll,'value',   get(scroll,'value')  +round(event.VerticalScrollCount*20));
           class(get(scroll,'value') )
           
%            set(gcf,'units','characters')
%            pos=get(gcf,'position')
           step=round(event.VerticalScrollCount*40);
           
            set(scroll,'value',   get(scroll,'value')  +step);
           
        catch %after savibng Image
            x.scroll=findjobj(gcf,'Class', 'UIScrollPane$1');%scroll
            set(gcf,'userdata',x);
        end
   drawnow
    else %define fontsize with mouse wheel
        tx= findobj(gcf,'tag','txt');

        fs= get(tx,'fontsize');
        fs2=fs+event.VerticalScrollCount;
        if fs2>1
            set(tx,'fontsize', fs2)  ;
        end
        x.evntModifier=0;
        set(gcf,'userdata',x);
    end
end




%----------------------------------
%           arrow keys
%----------------------------------
function fontsize(src,evnt)
x=get(gcf,'userdata');
if strcmp(evnt.Modifier,'control'); %[control]+mousewheel
    x.evntModifier=1; %if [control]-key is pressed..
    %code this for mousewheel-specifications
else
    x.evntModifier=0;
    tx= findobj(gcf,'tag','txt');
    if strcmp(evnt.Key,'leftarrow')
        set(tx,'fontsize', get(tx,'fontsize')-1)  ;
    elseif strcmp(evnt.Key, 'rightarrow')
        set(tx,'fontsize', get(tx,'fontsize')+1)  ;
    end
end
set(gcf,'userdata',x);







