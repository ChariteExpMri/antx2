
% #gw 
% #gw 
% #wg **********   CONTACT     ******************************** #k 
% #gw   
% #gw   Dr. Philipp Boehm-Sturm  or                                          #k 
% #gw   Dr. Stefan Paul Koch                                                 #k 
% #gw   Charité - University Medicine Berlin                                 #k 
% #gw   Campus Mitte                                                         #k 
% #gw   Department of Experimental Neurology                                 #k 
% #gw   Center for Stroke Research Berlin (CSB)                              #k 
% #gw   Neuroforschungshaus, Hufelandweg 14                                  #k 
% #gw   Raum: E1 019\n                                                       #k 
% #gw   Chariteplatz 1\n                                                     #k 
% #gw   10117 Berlin                                                         #k 
% #gw   phone:  +49 30 450 -560416/-560129/-560236/-539047                   #k 
% #gw   fax:            +49 30 450 -560915                                   #k 
% #gw   philipp.boehm-sturm@charite.de                                       #k 
% #gw   
% #wg ********************************************************* #k 

function antintro(force)


keeprunning=0;
persistent antintroshowed

if exist('force')==1
  antintroshowed=0;
  keeprunning=1;
  
end

if isempty(antintroshowed)
    antintroshowed=0;
end


if antintroshowed==1;
    return
end



if 0
    % fi=which('AVGT.nii')
    % [ha a]   =rgetnii(fi);
    
    [ha a]   =rgetnii('O:\data\karina\templates\ANOpcol.nii');
    
    D=a;
    % [x,y,z,D] = reducevolume(D,[repmat(5,1,3)]);
    % D = smooth3(D);
    
    
    D(:,100:end,:)=[];
    map='bone';
    
end

if 0
    %%
    cf
    figure;
    set(gcf,'units','norm');
    % axes('Position',[.6 .6 .2 .2]);
    colormap(map)
    Ds = smooth3(D);
    hiso = patch(isosurface(Ds,5),...
        'FaceColor',[1,.75,.65],...
        'EdgeColor','none');
    isonormals(Ds,hiso)
    
    hcap = patch(isocaps(D,5),...
        'FaceColor','interp',...
        'EdgeColor','none');
    colormap jet
    
    view(35,30)
    axis tight
    daspect([1,1,1])
    
    h1=lightangle(45,30);
    lighting gouraud;
    
    h2=lightangle(-119,0);
    lighting gouraud;
    
    
    hcap.AmbientStrength = 0.6;
    hiso.SpecularColorReflectance = 0;
    hiso.SpecularExponent = 50;
    set(gca,'color','none')
    set(gcf,'color','w')
    axis off
    % set(gcf,'menubar','none')
    
    
    set(gcf,'units','normalized')
    set(gcf,'position',[ 0.7135    0.6683    0.1913    0.2567])
    set(gcf,'units','pixels')
    pix=get(gcf,'position')
    set(gcf,'menubar','none');
end


FigH=open(which('antintrofig.fig'));
set(FigH,'units','normalized');

posant=get(findobj(0,'tag','ant'),'position');
set(FigH,'position',[ posant(1)+.1 posant(2)+.2    0.15    0.2]);%[ 0.7135    0.6683    0.1913    0.2567])


% set(FigH,'position',[ 0.6090    0.3578    0.15    0.2]);%[ 0.7135    0.6683    0.1913    0.2567])
set(FigH,'units','pixels');
pix=get(FigH,'position');
set(FigH,'menubar','none');
set(findobj(FigH,'type','axes'),'tag','axintro');
%% transparent
drawnow;
FigPos = round(get(FigH, 'Position'));
sc=get(0,'ScreenSize');
if sc(3)<1900
    WindowAPI(FigH, 'Clip', [70 50 FigPos(3)*2-100 FigPos(4)*2-50]);
    % WindowAPI(FigH, 'Clip', [70 50 FigPos(3)*2-00 FigPos(4)*2-300]);
else
    % WindowAPI(FigH, 'Clip', [10 10 FigPos(3)-100 FigPos(4)-80 ]);
    WindowAPI(FigH, 'Clip', [10 10 FigPos(3)-20  FigPos(4)-10]);
    
end
% WindowAPI(FigH, 'Clip', [70 50 FigPos(3) FigPos(4) ]);
 

WindowAPI(FigH, 'Alpha', 1, uint8([255 255 255]));

set(FigH,'units','norm');
hp=uicontrol('style','pushbutton','tag','introtxt','units','normalized','position',[.35 .1 .3 .08],...
    'backgroundcolor','w','callback',@infox,'fontsize',7);
set(hp,'string','CLOSE__|x|','foregroundcolor',[1 1 1],'fontweight','bold','fontsize',6,...
    'backgroundcolor',[.8 0 0],'tooltip','get contact information, can''t see it anymore->close this');
set(FigH,'units','pixels');


msg={'Department of Experimental Neurology'
'Center for Stroke Research Berlin (CSB)'
'Charité-Berlin'};
ti=title(msg,'color',[.8 0 0],'fontweight','bold','fontsize',6);



% WindowAPI(FigH, 'Clip', [0 0 FigPos(3)+300 FigPos(2)+FigPos(4)-50]);


%  FigH=gcf
%  WindowAPI(FigH, 'Position', 'gwrk')
%  WindowAPI(FigH, 'Alpha', 1, uint8([255 255 255]));

%% MAKE TEXT
delete(findobj(FigH,'tag','tver'));
s=1.5;%  shift=1.5
xl=xlim;
te=text(min(xl)+s+s,mean(ylim),max(zlim)+20,'ANT','HorizontalAlignment','left','FontSize',8,'tag','tver');
set(te,'color',[0 .5 0],'fontsize',24,'fontweight','bold');
set(te,'string','ANTx2','ButtonDownFcn',@rotat);
te=text(min(xl)+s+s,mean(ylim)+s,max(zlim)+20+s,'ANT','HorizontalAlignment','left','FontSize',8,'tag','tver');
set(te,'color',[ 0.0275    0.6863    0.0275],'fontsize',24,'fontweight','bold');
set(te,'string','ANTx2','ButtonDownFcn',@rotat);

% return

% return
%% play ligting
hlight=findobj(FigH,'type','light');
h1=hlight(2);
set(gca,'position',[0.1300    0.1100    0.7750    0.70])
    rotate3d on;

axis vis3d;
isthere=1;
set(gcf,'tag','antintro');
h=h1;
for az = -50:10:50
    if isempty(findobj(0,'tag','antintro')); 
        isthere=0;
        break
    end
    lightangle(h,az,30);
    if strcmp(get(gco,'type'),'patch')==1
        close(get(get(gco,'parent'),'parent'));
        isthere=0;
        break
    end
    pause(.2);
end
if isthere==0
    keeprunning=-1;
end

%  return
drawnow;

if keeprunning==0
    %% play rotation
    % view(38.83,-0.199)
    [az,el] = view;
    isthere=1;
    for i=1:5:100%360+100
        if isempty(findobj(0,'tag','antintro'));
            isthere=0;
            break
        end
    
        view(az+i,el);%-0.199
%         i
        if strcmp(get(gco,'type'),'patch')==1
            close(get(get(gco,'parent'),'parent'));
            isthere=0;
            break
        end
        drawnow;
        pause(.1);
    end
    if isthere==1;
        rotate3d;
    end
end

% close(FigH)
% %   camorbit(4,0,'data',[0 0 1])
% for i=1:150 ;   camorbit(5,0,'data',[0 0 1]);    drawnow;end


antintroshowed = 1;

if 0
    cf
    return
end

if keeprunning==1
    rotate3d on;
    try
        
        for i=1:10000
            for az = -50:10:50
                lightangle(h,az,30);
                pause(.2);
   
                
            end
        end
    end
else
  close(FigH)  
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

%  ##
return
pos = round(get(TextH, 'Extent')) + [-12, -11, 22, 22];
WindowAPI(FigH, 'Clip', pos);

% Clip visible region:
disp('  Clip window border ("splash screen"):');
WindowAPI(FigH, 'Position', FigPos);
WindowAPI(FigH, 'Clip');

TextH = text(0.5, 0.5, ' Demo: WindowAPI ', ...
    'Units',    'normalized', ...
    'FontSize', 20, ...
    'HorizontalAlignment', 'center', ...
    'BackgroundColor',     [0.4, 0.9, 0.0], ...
    'Margin',   12);

disp('  Clip specified rectangle:');
set(TextH, 'Units', 'pixels', ...
    'String',    ' Click to escape! ', ...
    'Margin',    10, ...
    'EdgeColor', [0.2, 0.7, 0.0], ...
    'LineWidth', 2);
pos = round(get(TextH, 'Extent')) + [-12, -11, 22, 22];
WindowAPI(FigH, 'Clip', pos);







WindowAPI(gcf, 'Clip', 1)
set(hf,'menubar','none')
WindowAPI(hf, 'Alpha', 1, uint8([255 255 255]));

function rotat(h,e)
 rotate3d


function infox(h,e)

col='*[0 .5 0]';
cprintf(col,['**********   CONTACT     ******************\n']);
cprintf(col,['Dr. Philipp Boehm-Sturm  or\n']);
cprintf(col,['Dr. Stefan Paul Koch\n']);
cprintf(col,['Charité - University Medicine Berlin\n']);
cprintf(col,['Campus Mitte\n']);
cprintf(col,['Department of Experimental Neurology\n']);
cprintf(col,['Center for Stroke Research Berlin (CSB)\n']);
cprintf(col,['Neuroforschungshaus, Hufelandweg 14\n']);
cprintf(col,['Raum: E1 019\n']);
cprintf(col,['Chariteplatz 1\n']);
cprintf(col,['10117 Berlin\n']);
cprintf(col,['phone:  +49 30 450 -560416/-560129/-560236/-539047\n']);
cprintf(col,['fax:            +49 30 450 -560915\n']);
cprintf(col,['philipp.boehm-sturm@charite.de\n']);
cprintf(col,['*******************************************\n']);

close(gcf); close()
drawnow
try; close(findobj(0,'tag','axintro')); end









