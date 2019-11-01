function jadic
warning off;
rendertyp=2;
if rendertyp==1;
    Renderer='zbuffer';nt=50;  no=5;urs=22;
    nt=1000;
    %      ri=findobrj(gca,'type','surface');

else
    Renderer='opengl';nt=400; no=33;urs=12;
    nt=1000;
    %     ri=findobj(gca,'type','surface');

    Renderer='zbuffer';
    %      set(ri ,'visible','off');
end



X= urs+5*rand(no,1); Y= urs+5*rand(no,1); Z= urs+5*rand(no,1);
% X=X+10;
%Colors: 3 blue, 3 red and 3 green
C= ones(3,1)*[0 0 1];
C= [C;ones(3,1)*[1 0 0]];
C= [C;ones(3,1)*[0 1 0]];
C= [C;ones(3,1)*[1 0 0]];
C= [C;ones(3,1)*[0 1 0]];
C= [C;ones(22,1)*[0 1 0]];
C=C*0;C(:,1)=1;
C=rand(no,3);
% set(hp(1),'FaceColor','g')
% set(hp(2),'FaceColor','m')


%Spheres sizes
S= 10*rand(no,1);



RENDERER = 'painters';       %# painters,zbuffer,opengl
ERASEMODE = 'normal';        %# normal,xor

figure;set(gcf,'color','w');
% ee=load('mandrill');
% figure('color','k');
% image( (ee.X(1:10,1:10)));colormap(ee.map)
try
    pause(1);
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe=get(gcf,'javaframe');
    icon=strrep(which('labs.m'),'labs.m','monkey.png');
    jIcon=javax.swing.ImageIcon(icon);
    jframe.setFigureIcon(jIcon);
end


earths=0;
if earths==1
    load topo;
    [x y z] = sphere(45);
    x=x+1 ;
    y=y+1; 
    z=z+1;
    s = surface(x*10,y*10,z*10,'facecolor','texturemap','cdata',topo);
    set(s,'edgecolor','none','facealpha','texture','alphadata',topo);
    set(s,'backfacelighting','unlit');
    colormap(topomap1);
    alpha('direct');
    alphamap([.1;1])
    % axis off vis3d;
    % campos([2 13 10]);
    %     camlight;
    lighting gouraud;
end
hold on

set(gcf, 'menubar','none');
set(gcf, 'DoubleBuffer','on', 'Renderer',RENDERER);
hp=p_scatter3sph(X,Y,Z,'size',S,'color',C);
tx0=text(60,90,0,'JADIC','fontsize',70);
tx0=text(60,76,0,'JUST ANOTHER DAY IN CHARITE´','fontsize',12,'fontweight','bold');

a1=1;
a2=1;
a3=1;
fcol=[ 0    0        0];
text(60,70,0,'[q]uit','fontsize',10,'color',                     fcol,'backgroundcolor',[a1 a2 a3]);
text(60,65,0,'[w] change transparency (3modi)','fontsize',10,'color',  fcol);
text(60,60,0,'[e] fullscreen                 ','fontsize',10,'color', fcol);
text(60,55,0,'[t]red,[z]green,[u]blue,[i]naja','fontsize',10,'color',fcol);

text(0,105,0,'SMALL VOLUME CORRECTION> ','fontsize',20,'color',fcol,'fontweight','bold');
text(20,100,0,'hit bobbles to minimize <watchout!> ','fontsize',15,'color',fcol)


tx1=text(65,20,0,datestr(now,'dd.mmm.yyyy') ,'fontsize',40);
tx2=text(65,5,0,datestr(now,'HH:MM:SS') ,'fontsize',40);


axis off;
tx=sort(findobj(gcf,'type','text'));
us.txt=[tx  cell2mat(get(tx,'fontsize'))  ];
us.transparentmode=1;

% set(hp,'FaceColor','g');
%  set(hp(1),'FaceColor','r')
set(hp,'FaceLighting','phong');
%   axis equal
% axis tight
% view(125,20);
% grid ON
camlight('right');
set(gca,'units','normalized','position',[0 0  1 1]);
% shading interp
% lightangle(-45,30)

set(gcf,'Renderer',Renderer);

set(findobj(gca,'type','surface'),...
    'FaceLighting','phong',...
    'AmbientStrength',.3,'DiffuseStrength',.8,...
    'SpecularStrength',.9,'SpecularExponent',25,...
    'BackFaceLighting','unlit');

set(hp,'facecolor',[0 .6 0]);
if earths==1
    no=no+1;
    hp=[hp  s];
end

% axis equal
mn=[-80 120];
xlim([mn]);
ylim(xlim);
zlim(xlim);

% set(gca,'color',[.5 .5 .5]);
set(gca, 'DrawMode','fast');
%# data

for i=1:no
    t = (i/5*pi)+linspace(0,(i+2)*pi,1000)';   %'# adjust number of points here
    d(:,:,i) = [cos(t) -sin(t)];
end
% d2=(bsxfun(@minus, d, min(d))/2)*sum(mn)-mn(1)
% d2=d*20

set(hp, 'EraseMode',ERASEMODE);
d=d*2;
multi=100;
nt=nt*multi;
d=repmat(d,[multi 1 1]);
 

if 1
    ri=findobj(gcf,'type','surface');ri=ri(:);
    bo=16;
    ra=sortrows([randperm(length(ri))' ri(:)],1);
    ri=ra(:,2);
    set(ri(1:bo),'visible','on');
    set(ri(bo+1:end),'visible','off');
   
    %      set(ri ,'visible','off');
end
set(gcf,'KeyPressFcn',{@key} );
set(gcf,'WindowButtonDownFcn',{@click} );
ri=findobj(gcf,'type','surface');
set(ri,'visible','on');
% ##################################################################
FigH=gcf;
try
    r=WindowAPI(gcf,'GetStatus');
    WindowAPI(FigH, 'FullScreen');  % Enables On-Top also
    %     WindowAPI(FigH, 'Alpha', 0.8, uint8([255, 255, 255]));

    % WindowAPI(FigH, 'Alpha', 0.7, uint8([255, 0, 0]));

    % set(gcf,'WindowButtonDownFcn','close');
    WindowAPI(gcf, 'Alpha', 1, uint8([255 255 255]));
    us.fullscreen=1;

catch
    jFigPeer = get(gcf,'JavaFrame');
    pause(.3);
    jWindow = jFigPeer.fFigureClient.getWindow;
    
    try
         com.sun.awt.AWTUtilities.setWindowOpacity(jWindow,.995);
%      com.sun.awt.AWTUtilities.setWindowOpacity(jWindow,1);
    end
    screenSize = get(0,'ScreenSize');  %# Get the screen size from the root object
    jWindow.setLocation(1,1);
    jWindow.setSize(screenSize(3),screenSize(4)/1+50);
    set(jWindow,'AlwaysOnTop','On');
    us.fullscreen=1;
end
set(gcf,   'Renderer','OpenGL');




% ##################################################################

set(gcf,'userdata',us);
% t = timer('TimerFcn',{@move,hp,t,d}, 'ExecutionMode', 'singleshot',...
%    'StopFcn', {@stop,[],[]}); %%'Period',4,'TasksToExecute',1,

t = timer('TimerFcn',{@move,hp,[],d}, 'ExecutionMode', 'fixedRate', 'Period',.001,...
    'TasksToExecute',nt,'StopFcn', {@stop,[],[]},'tag','tim1'); %%'Period',4,'TasksToExecute',1,

t2 = timer('TimerFcn',{@timex,tx2}, 'ExecutionMode', 'fixedRate', 'Period',1,...
    'TasksToExecute',nt); %%'Period',4,'TasksToExecute',1,
start(t2);
start(t);


function key(ra,ru)
us=get(gcf,'userdata');
if    strcmp(ru.Key,'q')
    clf;
elseif  strcmp(ru.Key,'e')
%     us=get(gcf,'userdata');

    if  us.fullscreen==1 %NORMAL
        try
            WindowAPI(gcf, 'Screen');
        end
        %            'ass'
        %            pause(.3);
        set(gcf,'units','normalized','position',[0.3049    0.4189    0.3889    0.4667]);
        try
            WindowAPI(gcf, 'Alpha', 1);
        catch
            try
                jFigPeer = get(handle(gcf),'JavaFrame');
                jWindow = jFigPeer.fFigureClient.getWindow;
                com.sun.awt.AWTUtilities.setWindowOpacity(jWindow,  1  );
            end
        end
        txt= us.txt;
        for i=1:size(us.txt,1)
            if us.txt(i,2)>30
                set(us.txt(i,1),'fontsize', (us.txt(i,2)/2));
            else
                set(us.txt(i,1),'fontsize', (us.txt(i,2)/1.5));
            end
        end
        %        
    else %FULLSCREEN
        try
            set(gcf,'units','normalized','position',[0 0 1 1]);
            set(gcf,'units','pixels');
            try
                r=WindowAPI(gcf,'GetStatus');
            WindowAPI(gcf, 'FullScreen');
            WindowAPI(gcf, 'Alpha', 1, uint8([255 255 255]));
            catch
                try
                    jFigPeer = get(handle(gcf),'JavaFrame');
                    jWindow = jFigPeer.fFigureClient.getWindow;
                    com.sun.awt.AWTUtilities.setWindowOpacity(jWindow,   1 );
                end
            end
            
            for i=1:size(us.txt,1)
                set(us.txt(i,1),'fontsize',us.txt(i,2));
            end
        end
    end
    us.fullscreen=abs(mod([  us.fullscreen],2)-1);
    set(gcf,'userdata',us);

elseif  strcmp(ru.Key,'w')

    mode=  mod( us.transparentmode,3)+1;



    if  mode==2
        %     if strcmp( get(gcf,   'Renderer'),'zbuffer');
        %         set(gcf,   'Renderer','OpenGL');
        %        q WindowAPI(gcf, 'Alpha', 1);
        %     else


        %         WindowAPI(gcf, 'Alpha', 0.9);
        %          set(gcf,   'Renderer','OpenGL');
        ri=findobj(gcf,'type','surface');
        bo=15;
        set(ri(1:bo),'visible','on');
        set(ri(bo+1:end),'visible','off');
        %        set(ri,'vistttible','off');
        %     WindowAPI(gcf, 'Alpha', 0.7, uint8([255 255 255]));
        try
            r=WindowAPI(gcf,'GetStatus');
            WindowAPI(gcf, 'Alpha', 0.7, uint8([255 255 255]));
        catch
               try
                    jFigPeer = get(handle(gcf),'JavaFrame');
                    jWindow = jFigPeer.fFigureClient.getWindow;
                    com.sun.awt.AWTUtilities.setWindowOpacity(jWindow,  .2 );
               end
                
        end
        set(gcf,   'Renderer','OpenGL');
        plot3(0,0,0,'r*');
    elseif  mode==1
        %     if strcmp( get(gcf,   'Renderer'),'zbuffer');r
        
        ri=findobj(gcf,'type','surface');
        set(ri,'visible','on');
        try
            r=WindowAPI(gcf,'GetStatus');
            WindowAPI(gcf, 'Alpha', 1, uint8([255 255 255]));
        catch
            try
                jFigPeer = get(handle(gcf),'JavaFrame');
                jWindow = jFigPeer.fFigureClient.getWindow;
                com.sun.awt.AWTUtilities.setWindowOpacity(jWindow,  .8 );
            end
        end
        set(gcf,   'Renderer','OpenGL');
    elseif   mode==3
%          WindowAPI(gcf, 'Screen');
try
    r=WindowAPI(gcf,'GetStatus');
    WindowAPI(gcf, 'Alpha', 1);
catch
    try
        jFigPeer = get(handle(gcf),'JavaFrame');
        jWindow = jFigPeer.fFigureClient.getWindow;
        com.sun.awt.AWTUtilities.setWindowOpacity(jWindow,  1 );
    end
end

    end
    us.transparentmode=mode;
%     mode
    set(gcf,'userdata',us);










% elseif  strcmp(ru.Key,'t')
%     %     if strcmp( get(gcf,   'Renderer'),'zbuffer');
%     %         set(gcf,   'Renderer','OpenGL');
%     %        q WindowAPI(gcf, 'Alpha', 1);
%     %     else
% 
% 
%     %         WindowAPI(gcf, 'Alpha', 0.9);
%     %          set(gcf,   'Renderer','OpenGL');
%     ri=findobj(gcf,'type','surface');
%     bo=15;
%     set(ri(1:bo),'visible','on');
%     set(ri(bo+1:end),'visible','off');
%     %        set(ri,'vistttible','off');
%     %     WindowAPI(gcf, 'Alpha', 0.7, uint8([255 255 255]));
%     try
%         WindowAPI(gcf, 'Alpha', 0.7, uint8([255 255 255]));
%     end
%     set(gcf,   'Renderer','OpenGL');
%     plot3(0,0,0,'r*');
% elseif  strcmp(ru.Key,'r')
%     %     if strcmp( get(gcf,   'Renderer'),'zbuffer');r
%     ri=findobj(gcf,'type','surface');
% 
%     set(ri,'visible','on');
%     try
%         WindowAPI(gcf, 'Alpha', 1, uint8([255 255 255]));
%     end
%     set(gcf,   'Renderer','OpenGL');


% [t]red, [z] green, [u]blue,[i]magenta]'

elseif  strcmp(ru.Key,'t')
    ri=findobj(gcf,'type','surface');
    set(ri,'facecolor',[1 0 0]);
elseif  strcmp(ru.Key,'z')
    ri=findobj(gcf,'type','surface');
    set(ri,'facecolor',[0 .6 0]);
elseif  strcmp(ru.Key,'u')
    ri=findobj(gcf,'type','surface');
    set(ri,'facecolor',[0 0 1]);
elseif  strcmp(ru.Key,'i')
    ri=findobj(gcf,'type','surface');
    set(ri,'facecolor',[1.0000    0.8000    1.0000]);

    %     WindowqAPI(gcf, 'Alpha', 1);
    %     else
    %         set(gcf,   'Renderer','zbuffer');
    %          WindowAPI(gcf, 'Alpha', 0.7, uint8([255 255 255]));

    %         WindowAPI(gcf, 'Alpha', 0.9);
    %          set(gcf,   'Renderer','OpenGL');
    % 'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww'
    %     end



    %     r=timerfindall
    %    stop(r(1))
    %    delete(r);
    %    pause(.3)
    %    clf;
end

function click(tim,ru)
% 'a'
% set(gco,'visible','off');
if strcmp(get(gco,'type'),'surface')


    b=gco;
    x=get(gco,'xdata');
    y=get(gco,'ydata');
    z=get(gco,'zdata');
    col=get(gco,'facecolor');
    %     rf=sign(rand(1)-.5);
    %     if col(1)==1
    %         fc=2;
    %     else
    %
    %         fc=.511;
    % %      else
    % %         fc=.5
    %     end
    fc=.511;
    set(gco,'FaceColor','r');


    xm=mean(x(:));  x=x-xm ;x=x*fc+xm;
    ym=mean(y(:));  y=y-ym ;y=y*fc+ym;
    zm=mean(z(:));  z=z-zm ;z=z*fc+zm;

    set(gco,'xdata', x);
    set(gco,'ydata',y );
    set(gco,'zdata',z  );


    if strcmp( get(gcf,   'Renderer'),'zbuffer');
        %         set(gcf,   'Renderer','OpenGL');
        %         WindowAPI(gcf, 'Alpha', 1);rq
    else
        %         set(gcf,   'Renderer','zbuffer');
        %          WindowAPI(gcf, 'Alpha', 0.7, uint8([255 255 255]));
        %
        %         WindowAPI(gcf, 'Alpha', 0.9);
        %          set(gcf,   'Renderer','OpenGL');
    end

end
% 'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww'qqqqqq

function timex(tim,ru,tx)
set(tx,'string',datestr(now,'HH:MM:SS'));
% tim.TasksExecuted

%%
% *BOLD TEXT*
function move(tim,ru, hp,t,d)

i=tim.TasksExecuted;


for j=1:length(hp)
    x2=get(hp(j),'Xdata');    y2=get(hp(j),'ydata');   % z2=get(hp(j),'zdata');
    set(hp(j),'Xdata',x2+d(i,1,j)*1,'ydata',y2+d(i,2,j)*1);
end

drawnow;




% for i=1:length(t)
%     for j=1:length(hp)
%         x2=get(hp(j),'Xdata');    y2=get(hp(j),'ydata');   % z2=get(hp(j),'zdata');
%         set(hp(j),'Xdata',x2+d(i,1,j)*1,'ydata',y2+d(i,2,j)*1);
%     end
%
%     drawnow
% end


function stop(tim,ru,frame,screenSize)
pause(.1);
% WindowAPI(gcf, 'Minimize');
close(gcf);
% delete(tim)
warning off;
delete(timerfindall);
% pause(2);
% % WindowAPI(FigH, 'Minimize');







function ch=p_scatter3sph(X,Y,Z,varargin)
%p_scatter3sph (X,Y,Z) Plots a 3d scatter plot with 3D spheres
%	p_scatter3sph is like scatter3 only drawing spheres with volume, instead
%	of flat circles, at coordinates specified by vectors X, Y, Z. All three
%	vectors have to be of the same length.
%	p_scatter3sph(X,Y,Z) draws the spheres with the default size and color.
%	p_scatter3sph(X,Y,Z,'size',S) draws the spheres with sizes S. If length(S)= 1
%	the same size is used for all spheres.
%	p_scatter3sph(X,Y,Z,'color',C) draws the spheres with colors speciffied in a
%	N-by-3 matrix C as RGB values.
%
% Example
% %Coordinates
%  X= 100*rand(9,1); Y= 100*rand(9,1); Z= 100*rand(9,1);
%
% %Colors: 3 blue, 3 red and 3 green
% C= ones(3,1)*[0 0 1];
% C= [C;ones(3,1)*[1 0 0]];
% C= [C;ones(3,1)*[0 1 0]];
%
% %Spheres sizes
% S= 5+10*rand(9,1);
%
% figure(1);
% scatter3nice(X,Y,Z,'size',S,'color',C);
% axis equal
% axis tight
% view(125,20);
% grid ON

tg={};%tag
for i=1:size(X,1)
    tg{end+1}='sph';
end

%-- Some checking...
if nargin < 3 error('Need at least three arguments'); return; end
if mean([length(X),length(Y),length(Z)]) ~= length(X) error ('Imput vectors X, Y, Z are of different lengths'); return; end

%-- Defaults
C= ones(length(X),1)*[0 0 1];
S=  max([X;Y;Z])*ones(length(X),1);

%-- Extract optional arguments
for j= 1:2:length(varargin)
    switch varargin{j}
        case 'size'
            S= varargin{j+1};
            if length(S) == 1
                S= ones(length(X),1)*S;
            elseif length(S) < length(X)
                error('The vector of sizes must be of the same length as coordinate vectors (or 1)');
                return
            end

        case 'color'
            C= varargin{j+1};
            if size(C,2) < 3	error('Colors matrix must have 3 columns'); return; end
            if size(C,1) == 1
                C= ones(length(X),1)*C(1:3);
            elseif size(C,1) < length(X)
                error('Colors matrix must have the same number of rows as length of coordinate vectors (or 1)');
                return
            end
        case 'tag'
            tg=varargin{j+1};
        otherwise
            error('Unknown parameter name. Allowed names: ''size'', ''color'' ');
    end
end

%-- Sphere facets
fac=1;
[sx,sy,sz]= sphere(20);
sx=sx./fac;
sy=sy./fac;
sz=sz./fac;

%-- Plot spheres
hold on
for j= 1:length(X)
    ch(j)=surf(sx*S(j)+X(j), sy*S(j)+Y(j), sz*S(j)+Z(j),...
        'LineStyle','none',...
        'AmbientStrength',0.4,...
        'FaceColor',C(j,:),...
        'SpecularStrength',0.8,...
        'DiffuseStrength',1,...
        'FaceAlpha',0.65,...
        'markersize',S(1),...%PAUL %for AS USERDATA2
        'SpecularExponent',2,...
        'tag',tg{j});

    %     pause
end
% light('Position',[0 0 1],'Style','infinit','Color',[1 1 1]);
% lighting gouraud
% view(30,15)


















