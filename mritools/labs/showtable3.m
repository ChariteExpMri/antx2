

function showtable3(pos,tab,varargin)

if 0

    showtable3([0 0 1 1],tab,'fontsize',9,'fontweight','normal','backgroundcolor','w')


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
%         labely{j,i}=  [repmat(' ' ,[1 1+size(kn,2)-length(dum)])  dum  ' ' ];
        labely{j,i}=  [repmat(' ' ,[1  size(kn,2)-length(dum)])  dum  ' ' ];
    end
end
dx=labely;
dz={};dz2={};
for i=1:size(dx,1)
    dy='';dy2='';
    for j=1:size(dx,2)
        df=dx{i,j};
        
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
fig= findobj(0,'tag','tabelz2');
if ~isempty(fig);
    posfig=get(fig,'position') ;
    lb=findobj(fig,'tag','txt');
    set(lb,'string',dz);
else

    figure;set(gcf,'color','w',    'tag' ,'tabelz2'   );
    set(gcf,'units','normalized','menubar','none');
    set(gcf,'position',[0.7090    0.7911    0.1743    0.1767]);
    fig= findobj(0,'tag','tabelz2');
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

    if 1
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
    item2 = uimenu(cmenu, 'Label','save FULL TABLE (TXT & EXCEL)',          'Callback', {@gcontext, 4});%save
    item2 = uimenu(cmenu, 'Label','save table(only coordinates!!)',          'Callback', {@gcontext, 2});%save
    item3 = uimenu(cmenu, 'Label','save as HTML file',    'Callback',{@gcontext, 3});%save

end
% set(gcf,'WindowScrollWheelFcn',{@gwheel,1});
% -----------------------------------------------------------


% x.scroll   =findjobj(fig,'Class', 'UIScrollPane$1');%scroll
x.fontsize =fontsize;
x.evntModifier=0;
x.table    =dz2;
x.tablec   =tab;
set(fig,'userdata',x);


function clicked(hh,ss)
x=get(gcf,'userdata');
lb=findobj(gcf,'tag','txt');
val=get(lb,'value');
% cords=str2num(x.tablec{val,2});
columnMNI=find(cellfun('isempty',strfind(x.tablec(1,:),'xyzMNI'))==0);
cords=str2num(x.tablec{val,columnMNI});     
% disp(cords);
try
hMIPax = findobj('tag','hMIPax');
spm_mip_ui('SetCoords',cords,hMIPax);
% showbrodmann;
fun2_activateResults;
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
elseif mode==3
    fun2_makeHTMLtable;
 elseif mode==4
    fun2_makeTable; 
end



%----------------------------------
%           mousewheel
%----------------------------------
% function gwheel(obj, event, mode)
% 
% try
%     x=get(gcf,'userdata');
%     if  x.evntModifier==0 %[scroll text]
%         x=get(gcf,'userdata'); scroll=x.scroll;
%         try
% %             set(scroll,'value',   get(scroll,'value')  +event.VerticalScrollCount*25);
% %             set(scroll,'value',   get(scroll,'value')  +round(event.VerticalScrollCount*20));
%            class(get(scroll,'value') )
%            
% %            set(gcf,'units','characters')
% %            pos=get(gcf,'position')
%            step=round(event.VerticalScrollCount*40);
%            
%             set(scroll,'value',   get(scroll,'value')  +step);
%            
%         catch %after savibng Image
%             x.scroll=findjobj(gcf,'Class', 'UIScrollPane$1');%scroll
%             set(gcf,'userdata',x);
%         end
%    drawnow
%     else %define fontsize with mouse wheel
%         tx= findobj(gcf,'tag','txt');
% 
%         fs= get(tx,'fontsize');
%         fs2=fs+event.VerticalScrollCount;
%         if fs2>1
%             set(tx,'fontsize', fs2)  ;
%         end
%         x.evntModifier=0;
%         set(gcf,'userdata',x);
%     end
% end




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







