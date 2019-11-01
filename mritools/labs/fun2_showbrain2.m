function fun2_showbrain2


fig=findobj(0,'Tag','Graphics');
axtab=get(findobj(fig,'string','mm mm mm'),'parent');%table
hl=sort(findobj(axtab,'Tag','ListXYZ')) ;%mmText mm mm mm

if isempty(axtab)
    disp('there is no table');
    return
end
cords=str2num(char([get(hl,'string')]));
[labelx header labelcell]=pick_wrapper(cords, 'Noshow');%

%% get SPMdata
xSPM=evalin('base','xSPM');
xm=xSPM.XYZmm';

A         = spm_clusters(xSPM.XYZ);

[xyzmm,i] = spm_XYZreg('NearestXYZ',...
    spm_results_ui('GetCoords'),xSPM.XYZmm);
% spm_results_ui('SetCoords',xSPM.XYZmm(:,i));

%-Find selected cluster
%--------------------------------------------------------------
% A         = spm_clusters(SPM.XYZ);
curclust         = find(A == A(i));

if size(cords,1)<4
    A= A(curclust);
    xm=xm(curclust,:);
    x=[xSPM.XYZ(:,curclust)]';
else
    x=[xSPM.XYZ]';
end
%%

open(regexprep(which('labs.m'),'labs.m','brain4.fig')); hold on
% open(regexprep(which('labs.m'),'labs.m','brain3.fig')); hold on
ch=findobj(gca,'tag','brain2'); set(ch,'visible','off');
ch=findobj(gca,'tag','brainpart'); set(ch,'visible','off');
set(gcf,'KeyPressFcn',@keyboardx);
% fg; hold on
set(gca,'tag','ax1');
set(gcf,'tag','fig1');
 

if 0
    
    [sx,sy,sz]= sphere(4);
    X=xm(:,1);
    Y=xm(:,2);
    Z=xm(:,3);
    S= 3;
    for j=1:length(X)
        fr(j)=surf(sx*S+X(j), sy*S+Y(j), sz*S+Z(j));%,...
        %
        %     dp=[sx(:)*S+X(j) sy(:)*S+X(j)  sz(:)*S+X(j)  ];
        %    df=convhulln(dp);
        %
        %       fr(j) = patch('faces',df,'vertices',dp,...%isosurface(xs,.1) %##.2
        %         'FaceColor',[ 0.9804    0.7686    0.5647],	'EdgeColor','none');
        % 		'LineStyle','none',...
        % 		'AmbientStrength',0.4,...
        % 		'FaceColor',[1 0 0],...
        % 		'SpecularStrength',0.8,...
        % 		'DiffuseStrength',1,...
        % 		'FaceAlpha',0.65,...
        %         'markersize',S(1),...%PAUL %for AS USERDATA2
        % 		'SpecularExponent',2,...
        %         'tag','ö');
    end
    set(fr,'facecolor',[ 1 0 0]);
    set(fr,'FaceLighting','phong','edgecolor','none')
    lighting gouraud;
    axis equal;axis tight;
    %  set(fr,'LineStyle','none',...
    % 		'AmbientStrength',0.4,...
    % 		'SpecularStrength',0.1,...
    % 		'DiffuseStrength',1.4,...
    % 		'FaceAlpha',1,...
    % 		'SpecularExponent',20)
    set(fr,     'tag','dot');
    %
    % camlight;
    %% color activation-oriented
    if 0
        colz=xSPM.Z;
        colbar=flipud(hot);
        ix=round(norm01(colz,2)*63+1);
        for i=1:length(fr)
            set(fr(i), 'FaceColor',colbar(ix(i),:))
        end
    end
    %% color cluster-oriented
    uni=unique(A);
    colz=jet(length(uni));
    colz=rand(length(uni),3);
    cent=[];
    for i=1:length(uni)
        ix=find(A==uni(i));
        cent(i,:)= mean(xm(ix,:),1);
        set(fr(ix), 'FaceColor',colz(i,:));
    end
    
end

if 1
    % ################################################
    %     load xm
    %     A         = spm_clusters(xSPM.XYZ);
    uni=unique(A);
    %     open(regexprep(which('labs.m'),'labs.m','brain1.fig')); hold on
    colz=rand(length(uni),3);
    
    cordsClust=zeros(size(cords,1),1);
    for i=1:size(cords,1)
        iv= dsearchn(xm,cords(i,:));
        cordsClust(i)=A(iv);
    end
    
    
    for j=1:length(uni)
        ix=find(A==uni(j));
        w=zeros([xSPM.DIM]');
        wi=x(ix,:)';%xSPM.XYZ(:,ix);
        for i=1:size(wi,2)
            w(wi(1,i),wi(2,i),wi(3,i))=A(i);
        end
        %w2=smooth3(w,'box',[repmat(  9  ,[1 3])]);
        [f1,v1] =isosurface(w,.5 );%.1
        f1=single(f1); v1=single(v1);
        % nfv = reducepatch(double(f1),double(v1),.05,'fast'); %.3 is good but slow
        % v1=single(nfv.vertices);         % f1=single(nfv.faces);
        v11=vc2nc_spm([v1(:,2) v1(:,1) v1(:,3)],xSPM.M);% volumecoords to normalized cords
        e = patch('faces',f1,'vertices',v11,...%isosurface(xs,.1) %##.2
            'FaceColor',[ colz(j,:)],	'EdgeColor','none','ButtonDownFcn',@dotcallback);
        set(e, 'tag','dot');
        set(e,'FaceLighting','phong');
        
        %         tpl.cordsClust=uni(j);
        tpl.f1 =f1;
        tpl.v11=v11;
        tpl.col=colz(j,:);
        tpl.isexploded=0;
        set(e,'userdata',tpl);
        setappdata(e,'cordsClust',uni(j)) ;
    end
    
end

% 'a'
%% get coordinates
% fig=findobj(0,'Tag','Graphics');
% axtab=get(findobj(fig,'string','mm mm mm'),'parent');%table
% hl=sort(findobj(axtab,'Tag','ListXYZ')) ;%mmText mm mm mm
%
% if isempty(axtab)
%    disp('there is no table');
%     return
% end
% cords=str2num(char([get(hl,'string')]));
% [labelx header labelcell]=pick_wrapper(cords, 'Noshow');%
%  showtable3([0 0 1 1],[header;labelx],'fontsize',8);

labelz=cellfun(@(a,b) [a '[' b ']'],labelx(:,3),labelx(:,5),'uni',false);
labelz=strrep(labelz,'[]','n.a.');
%%    make labels
delete(findobj(gca,'tag','label'));
delete(findobj(gca,'tag','arrow'));
cent=cords;
cent2=cent.*1.3 ;
cent2(:,3)=abs(cent2(:,3).*.8);
% cent2=cent+sign(cent)*10;
hp=[];hl=[];
for i=1:size(cent,1)
    if ~isempty(labelz{i} )
        hp(end+1)=...
            plot3([cent(i,1) cent2(i,1)],[cent(i,2) cent2(i,2)],[cent(i,3) cent2(i,3)],'r-',...
            'tag','arrow','linewidth',1.5,'color','r'  );
        hl(end+1)=text(cent2(i,1),cent2(i,2),cent2(i,3), labelz{i}   , 'tag','label');
        us.cent      =cent(i,:);
        us.cent2     =cent2(i,:);
        us.isexploded=0;
        us.cordsClust=cordsClust(i);
        
        set(hl(end),'userdata',us);
        set(hp(end),'userdata',us);
        setappdata(hl(end),'cordsClust',cordsClust(i)) ;
        setappdata(hp(end),'cordsClust',cordsClust(i)) ;
    end
end
set(hl,'HorizontalAlignment','center','fontweight','bold','fontsize',7);

% if size(cords,1)<4
%       set(fr,'visible','off');
%       set(fr(curclust),'visible','on');
% end

%% colorize final
fb=findobj(gcf,'tag','brain');
% set(fb,'facealpha',.05);
axis vis3d;
set(gcf,'units','normalized');
set(gca,'position',[.05 .05 .8 .8]);
set(gca,'position',[-.1 0 1.2 1.2]);

% li=camlight('right');
% li=camlight('left');

% 'a'
% li=light(,'position',[-497        -666        1249]);
% li=light(,'position',[ 984   829  -700]);
% li=light(,'position',[  588       -1013         936]);

% fb=findobj(gcf,'tag','brain');
% set(fb,'facelighting','phong');
%%
axl=axis;
delete(findobj(gca,'tag','slic'));

hp=plot3([axl(1) axl(2) ],[0 0  ],[  0 0 ],'g','tag','slic');
hp=plot3([0 0],[axl(3) axl(4) ],[  0 0 ],'g','tag','slic');
hp=plot3([0 0],[0 0],[axl(5) axl(6) ],'g','tag','slic');
%%
if 0
    axl=axis;
    delete(findobj(gca,'tag','slic'));
    
    % hp=patch([axl(1) axl(2)  axl(2) axl(1) ],[0 0 0 0],[axl(5) axl(5)  axl(6) axl(6) ],'g');
    % set(hp,'facealpha',.1,'edgecolor','none','tag','slic')
    
    hp=patch([0 0 0 0],[axl(3) axl(4)  axl(4) axl(3) ],[axl(5) axl(5)  axl(6) axl(6) ],'g');
    set(hp,'facealpha',.1,'edgecolor','none','tag','slic')
    
    hp=patch([axl(1) axl(2)  axl(2) axl(1) ],[axl(3) axl(3)  axl(4) axl(4) ],[0 0 0 0 ],'g');
    set(hp,'facealpha',.1,'edgecolor','none','tag','slic')
end

   try
        warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
        jframe=get(gcf,'javaframe');
        icon=strrep(which('labs.m'),'labs.m','monkey.png');
        jIcon=javax.swing.ImageIcon(icon);
        jframe.setFigureIcon(jIcon);
    end
    


%% isocap
if 0
    
    fg
    
    ar='C:\thamar2\test_surfbrainplot\makebrain\spm_template\ch2bet.nii'
    %     ar='C:\thamar2\test_surfbrainplot\makebrain\spm_template\ch2.nii'
    
    hh=load_nii(ar);
    xs=single(hh.img);hh.img=[]; %HEAD
    xs(isnan(xs))=nanmedian(xs(:));
    
    %     xs=xs(:,:,1:90) ;
    %      xs(setdiff(1:181,1:2:181),:,:)=0;
    
    [f1,v1] =isosurface(xs) ;%,50);%50
    % clear xs;
    f1=single(f1);
    v1=single(v1);
    nfv = reducepatch(double(f1),double(v1),.1,'fast');%.05
    v1=single(nfv.vertices);
    f1=single(nfv.faces);
    v11=vc2nc([v1(:,2) v1(:,1) v1(:,3)],hh);% volumecoords to normalized cords
    e = patch('faces',f1,'vertices',v11,...%isosurface(xs,.1) %##.2
        'FaceColor',[ 0.9804    0.7686    0.5647],	'EdgeColor','none');
    set(e, 'tag','brain2');
    set(e,'FaceLighting','phong');
    
    %     #######################################
    
    load xm
    
    b=findobj(gcf,'tag','brain2');
    pa.faces= (get(b,'faces'));
    pa.vertices= (get(b,'vertices'));
    set(b,'facecolor',[1.0000    1    0.3922]);
    col00=repmat( [1 1 1], [size(pa.vertices,1) 1]);
    set(b,'FaceVertexCData',col00,'facecolor','interp', 'FaceLighting','phong');
    col0=get(b,'FaceVertexCData');
    col=col0.*1;
    %  col=col0;
    val=xm;
    vert=pa.vertices;
    disksize=5;
    r = disksize.^2;
    O = single( ones(1,size(vert,1)));% searchlite sphereSize
    XYZmm=vert';
    v2=[];
    for v=1:size(val,1)
        ix=dsearchn(vert,val(v,:));
        s = find((sum((XYZmm-XYZmm(:,ix)*O).^2) <=  r));
        v2=[v2;s(:)];
    end
    v2=unique(v2,'rows');
    coli=repmat([0 0 1], [length(v2) 1]);
    col(v2,:)=coli;
    set(b,'FaceVertexCData',col,'facecolor','interp', 'FaceLighting','phong');
    set(b,'facealpha',1)
    
  
    
end
%% isocaps
if 0


    delete(findobj(gca,'tag','slicer'));
    ar='C:\thamar2\test_surfbrainplot\makebrain\spm_template\ch2bet.nii'
    hh=load_nii(ar);
    xs=single(hh.img);hh.img=[]; %HEAD
    xs(isnan(xs))=nanmedian(xs(:));
    xs=xs(1:90,:,:) ;
    %      xs=xs(:,:,1:90) ;
    
    [fa,va,ca] = isocaps(xs, 50);
    v11=vc2nc([va(:,2) va(:,1) va(:,3)],hh);% volumecoords to normalized cords
    
    % fg
    p3=patch('vertices',v11,'faces',fa)
    set(p3,'FaceVertexCData',ca,'edgecolor','none')
    set(p3,'FaceColor','interp','tag','slicer');
    colormap copper
    set(p3,'facealpha',1);
    

    
    % delete(p3)
end


%%
if 1
    li=light('position',[-497        -666        1249]);
    li=light('position',[ 984   829  -700]);
    li=light('position',[  588       -1013         936]);
    li=light('position',[ -1123        -638         754]);
    li=light('position',[    -346        1094        1052]);
    
    li=light('position',[  -885.7375 -877.4843  829.4057]);
    %     set(findobj(gca,'type','light'),'color',[.7 .7 .7]);
end

fb=findobj(gcf,'tag','brain');
set(fb,'BackFaceLighting','unlit')
% set(fb,'facealpha',.04)
set(fb,'facealpha',.1,'hittest','off')

axis off
rotate3d;

ax=axis;
xlim([ax(1)-10 ax(2)+10]);
ylim([ax(3)-10 ax(4)+10]);

li=findobj(gcf,'type','light');
set(li,'color',[.6 .6 .6]);


w=findobj(gcf,'tag','dot');
set(w,'BackFaceLighting','unlit');
set(w,'AmbientStrength',0);
set(w,'DiffuseStrength',.6);
set(w,'SpecularStrength',0);
set(w,'BackFaceLighting','reverselit');

ch=findobj(gca,'tag','brain2');
set(ch,'visible','off');
set(li,'color',[1 1 1]);

ch=findobj(gca,'tag','brain');
set(ch,'facecolor',[1.000    0.541    0.00]);

us=[];
us.axlims =axis;
us.axlims2=[ -160.0000  160.0000 -160.0000  160.0000  -63.5000   91.4200];
us.material=0;

us.AmbientStrength=get(e,'AmbientStrength');
us.DiffuseStrength=get(e,'DiffuseStrength');
us.SpecularStrength=get(e,'SpecularStrength');
us.SpecularExponent=get(e,'SpecularExponent');
us.AmbientStrength=get(e,'AmbientStrength');
us.SpecularColorReflectance=get(e,'SpecularColorReflectance');

%----------------------------------
us.Z=xSPM.Z;
us.XYZmm=xSPM.XYZmm;
us.radius=30;

us.braincol=[0.9804    0.7686    0.5647];
us.map     ='hot' ;

% };
set(gcf,'userdata',us);

set(findobj(gca,'tag','label'),'hittest','off');
set(findobj(gca,'tag','arrow'),'hittest','off');
set(findobj(gca,'tag','slic'),'hittest','off');
set(findobj(gca,'tag','brainpart'),'hittest','off');
set(findobj(gca,'tag','brainpart2'),'hittest','off');
set(findobj(gca,'tag','brain2'),'hittest','off');
set(findobj(gcf,'tag','brain2'),'BackFaceLighting','lit');

lblist=getlist;

% lblist={};
% lblist(end+1,:)={'blobs transp' 'h' '' 'toggle blobs transparency'};
% 

us=[];
us.pb_pos=[.85 .5 .014 .1];
us.lb_pos=[.86 0 1-.86 1];
us.state=0;
us.rel={'<' '>' };
lb = uicontrol('Style', 'listbox', 'String', 'Clear','units','normalized',...
    'Position', us.lb_pos, 'Callback', @listboxtask,'tag','lb1','fontsize',7);
set(lb,'string',lblist(:,1),'userdata',lblist);

pb = uicontrol('Style', 'pushbutton', 'String', '<','units','normalized',...
    'Position', [us.pb_pos], 'Callback', ' ','tag','pb1','callback',@shiftbutton,'userdata',us,...
    'tooltip','hide/show menu');

jScrollPane = findjobj(lb);% Get the listbox's underlying Java control
try
    jListbox = jScrollPane.getViewport.getComponent(0);% We got the scrollpane container - get its actual contained listbox control
    jListbox = handle(jListbox, 'CallbackProperties');% Convert to a callback-able reference handle
     set(jListbox, 'MouseMovedCallback', {@mouseMovedCallback_lb1,lb});
%      setappdata(h,'userdata2',act); %set 2d data

catch
    jListbox=jScrollPane(2).getViewport.getComponent(0);
    jListbox = handle(jListbox, 'CallbackProperties');% Convert to a callback-able reference handle
     set(jListbox, 'MouseMovedCallback', {@mouseMovedCallback_lb1,lb});
%     setappdata(h,'userdata2',act); %set 2d data



end


view(0,90);
rotate3d off;


% Mouse-movement callback
function mouseMovedCallback_lb1(jListbox, jEventData, hListbox)
mousePos = java.awt.Point(jEventData.getX, jEventData.getY);
try
    hoverIndex = jListbox.locationToIndex(mousePos) + 1 ;
catch
    listValues = get(hListbox,'string') ;
    posbox= [get(jListbox,'Width')  get(jListbox,'Height')] ;
    pos=[jEventData.getX, jEventData.getY];
    md=mod(pos(2),get(jListbox,'FixedCellHeight')) ;
    hoverIndex= round((pos(2)-md)/get(jListbox,'FixedCellHeight') +1);
    if hoverIndex>size(listValues,1)
        hoverIndex=size(listValues,1);
    elseif hoverIndex<1
        hoverIndex=1;
    end
end

listValues = get(hListbox,'string');
hoverValue = listValues{hoverIndex} ;
dat=get(hListbox,'userdata');
dat=dat(hoverIndex,:);

tg=  dat{4} ;
if isempty(dat{3}) ;
 tg2=[ '[' dat{2} ']'];
else
   tg2=[ '[' dat{3} ' & ' dat{2} ']'] ; 
end
tg0=[ '<html><b>' '<font color="red">' tg2 '<font color="green">' tg  ];
set(hListbox, 'Tooltip',tg0);



function listboxtask(lb,evt)
list=get(lb,'userdata');
va=get(lb,'value');
event.Key      =list{va,2};
event.Modifier =list{va,3};
src='';
keyboardx(src,event);
mouse2axRobot;
% axes(gca);
% set(gcf,'CurrentObject',findobj(gcf,'tag','brain2'));



function shiftbutton(pb,evt)
us=get(pb,'userdata');
set(pb,'string', us.rel{mod(us.state,2)+1});
if us.state==0
    set(findobj(gcf,'tag','lb1'),'visible','off');
    pos=us.pb_pos;
    pos(1)=1-pos(3)+.005;
    set(pb,'position',pos);
else
    set(findobj(gcf,'tag','lb1'),'visible','on');
     set(pb,'position',us.pb_pos);
end
us.state=mod(us.state+1,2);
set(pb,'userdata',us);

function keyboardx(src,event)
if strcmp(event.Key,'v') & strcmp(event.Modifier,'control')
    ch=findobj(gca,'tag','dot');
    if get(ch(1),'facealpha')==1
        set(ch,'facealpha',.3);
    else
        set(ch,'facealpha',1) ;
    end
elseif strcmp(event.Key,'v')
    ch=findobj(gca,'tag','dot');
    nch_on=(sum(strcmp(get(ch,'visible'),'on')));
    if nch_on>round(length(ch)/2);
        set(ch,'visible','off');
    else
        set(ch,'visible','on');
    end
    
elseif strcmp(event.Key,'p') & strcmp(event.Modifier,'shift')
      maps={'jet' 'hsv','hot','cool','autumn' 'summer' 'copper'};
    us=get(gcf,'userdata');
    map=find(cellfun('isempty',regexpi(maps,us.map))==0)+1;
    if map>length(maps)
        map=1;
    end
    us.map=maps{map};
    set(gcf,'userdata',us);
    
    us.map;
      vol2surface
    
elseif strcmp(event.Key,'p')

    vol2surface
    
elseif strcmp(event.Key,'i') & strcmp(event.Modifier,'control')
    li=findobj(gcf,'type','light');
    if mean(mean(cell2mat(get(li,'color')))) <.8
       set(li,'color',[1 1 1]) ;
    else
       set(li,'color',[.6 .6 .6])  ;
    end

elseif strcmp(event.Key,'i')
    li=findobj(gcf,'type','light');
    lis=randperm(length(li));
    ns=4;
    set(li(lis(1:ns)),'visible','on');
    set(li(lis(ns+1:end)),'visible','off');

    
elseif strcmp(event.Key,'a')    
    us=get(gcf,'userdata');
    ax=axis;
    if sum(us.axlims(1:4)==ax(1:4))==4
        axis(us.axlims2);
    else
        axis(us.axlims);
    end
% elseif strcmp(event.Key,'control')

elseif strcmp(event.Key,'r') 
    hl=findobj(gcf,'tag','helpline');
    if ~isempty(hl)
        vis=  get(hl,'visible');
        if strcmp(vis,'on')
            set(hl,'visible','off');
            dot=findobj(gca,'tag','dot');
            for i=1:length(dot)
                us=get(dot(i),'userdata');
                if us.isexploded==1
                     set(dot(i),'visible','off');
                end
            end
            lab=findobj(gca,'tag','label');
            for i=1:length(lab)
                us=get(lab(i),'userdata');
                if us.isexploded==1
                    set(lab(i),'visible','off');
                end
            end
            ar=findobj(gca,'tag','arrow');
            for i=1:length(ar)
                us=get(ar(i),'userdata');
                if us.isexploded==1
                    set(ar(i),'visible','off');
                end
            end
            
        else
            
            set(hl,'visible','on');
            dot=findobj(gca,'tag','dot');
            for i=1:length(dot)
                us=get(dot(i),'userdata');
                if us.isexploded==1
                    set(dot(i),'visible','on');
                end
            end
            lab=findobj(gca,'tag','label');
            for i=1:length(lab)
                us=get(lab(i),'userdata');
                if us.isexploded==1
                    set(lab(i),'visible','on');
                end
            end
             ar=findobj(gca,'tag','arrow');
            for i=1:length(ar)
                us=get(ar(i),'userdata');
                if us.isexploded==1
                    set(ar(i),'visible','off');
                end
            end
            
            
        end
        
    end
    
 
 elseif strcmp(event.Key,'t') & strcmp(event.Modifier,'control')
    ch=findobj(gca,'tag','label');
    if   strcmp(get(ch,'visible'),'on')
        set(ch,'visible','off');
    else
        set(ch,'visible','on');
    end   
    
 elseif strcmp(event.Key,'t')
     lab=findobj(gca,'tag','label');
     for i=1:length(lab)
         us=get(lab(i),'userdata');
         if us.isexploded==0
             if strcmp(get(lab(i),'visible'),'off'); set(lab(i),'visible','on');
             else set(lab(i),'visible','off');
             end
         end
     end
elseif strcmp(event.Key,'l') & strcmp(event.Modifier,'control')
    ar=findobj(gcf,'tag','arrow');
    if   strcmp(get(ar,'visible'),'on')
        set(ar,'visible','off');
    else
        set(ar,'visible','on');
    end
 
elseif strcmp(event.Key,'f12')
    [az el]=view;
    us=get(gcf,'userdata');
    us.view=[az el];
    set(gcf,'userdata',us);

elseif strcmp(event.Key,'s')
    a=getlist;
    a2={};
    for i=1:size(a,1);
        d1= a{i,2};
        d2= a{i,3};
        if isempty(d2)
            a2{i,1}=['#g ' d1 ' #n '];
        else
            a2{i,1}=['#g ' d2 '+' d1 ' #n '];
        end
    end
    [s hist]=plog({},{[] [] [a(:,1) a2 a(:,4)]  }, 1,' #n shortcuts #n ','s=0','d=0');
    uhelp(s);



elseif strcmp(event.Key,'l')
    lab=findobj(gca,'tag','arrow');
     for i=1:length(lab)
         us=get(lab(i),'userdata');
         if us.isexploded==0
             if strcmp(get(lab(i),'visible'),'off'); set(lab(i),'visible','on');
             else set(lab(i),'visible','off');
             end
         end
     end 
      


elseif strcmp(event.Key,'f1') | strcmp(event.Key,'f2') | strcmp(event.Key,'f3') |...
        strcmp(event.Key,'f4') | strcmp(event.Key,'f5') | strcmp(event.Key,'f6') | ...
        strcmp(event.Key,'f7') %| strcmp(event.Key,'f7')
  
      

 if strcmp(event.Key,'f1')
        
        us= get(gcf,'userdata');
        if ~isfield(us,'us.view')
           view(64,40); 
        else
        view(us.view(1),us.view(2));
        end
        
    elseif strcmp(event.Key,'f2')
        view(0,90);
    elseif strcmp(event.Key,'f3')
        view(-90,0);
    elseif strcmp(event.Key,'f4')
        view(90,0);
    elseif strcmp(event.Key,'f5')
        view(-180,0);
     elseif strcmp(event.Key,'f6')
        view(0,0);
    end
        
%     axis(us.axlims);
    
elseif strcmp(event.Key,'e')%textchange-location
    
    explodeshow('all');
    
elseif strcmp(event.Key,'m') 
    us=get(gcf,'userdata');
    mats= us.material+1;
     mats=mod(mats,4);
     
     if mats==1
         material metal;
     elseif mats==2
         material dull;
         elseif mats==3
         material shiny;
     elseif mats==0
        material([ us.AmbientStrength us.DiffuseStrength us.SpecularStrength us.SpecularExponent...
             us.SpecularColorReflectance]);
     end
    us.material=mats;
    set(gcf,'userdata',us);
    
    
    
elseif strcmp(event.Key,'b')
    ch=findobj(gca,'tag','brain2');
    li=findobj(gcf,'type','light');
    if   strcmp(get(ch,'visible'),'on')
        set(ch,'visible','off');
        set(li,'color',[1 1 1]);
    else
        set(ch,'visible','on');
        set(li,'color',[.6 .6 .6]);
    end
    
% elseif strcmp(event.Key,'q')
%     'q'
%     ch=findobj(gca,'tag','brain2');
%     v1=get(ch,'vertices');
%     %     f1=get(ch,'Faces');
%     % col=single(zeros(size(v1) ,3))+1;
%     col=repmat([0.9804 0.7686 0.5647],[size(v1,1) 1] );
%     % [0.9804 0.7686 0.5647]
%     ix=find(v1(:,1)<0);
%     col(ix,:)=nan;
%     set(ch,'FaceVertexCData',col,'facecolor','interp', 'FaceLighting','phong');
%     set(ch,'DiffuseStrength',.2);
    
elseif strcmp(event.Key,'1')  | strcmp(event.Key,'2') | strcmp(event.Key,'3') |...
        strcmp(event.Key,'4') | strcmp(event.Key,'5') | strcmp(event.Key,'6') | strcmp(event.Key,'7')
    
%     brain2transp(event.Key)
    
elseif strcmp(event.Key,'rightarrow')& strcmp(event.Modifier,'control');
    showbrainpart('switch','x','>')
elseif strcmp(event.Key,'leftarrow')& strcmp(event.Modifier,'control');
    showbrainpart('switch','x','<')
elseif strcmp(event.Key,'uparrow')& strcmp(event.Modifier,'control');
     showbrainpart('switch','y','>')
elseif strcmp(event.Key,'downarrow')& strcmp(event.Modifier,'control');
     showbrainpart('switch','y','<')  
    
    
elseif strcmp(event.Key,'rightarrow')
    [az el]=view; view(az-7,el);
elseif strcmp(event.Key,'leftarrow')
    [az el]=view; view(az+7,el);
elseif strcmp(event.Key,'uparrow')
    [az el]=view; view(az,el+7);
elseif strcmp(event.Key,'downarrow')
    [az el]=view; view(az,el-7);

elseif strcmp(event.Key,'x') & strcmp(event.Modifier,'alt');
    showisocaps('x','hide');
elseif strcmp(event.Key,'x') & strcmp(event.Modifier,'shift');
    showisocaps('x','down');
elseif strcmp(event.Key,'x')
    showisocaps('x','up');    
    
elseif strcmp(event.Key,'y') & strcmp(event.Modifier,'alt');
    showisocaps('y','hide');
elseif strcmp(event.Key,'y') & strcmp(event.Modifier,'shift');
    showisocaps('y','down');
elseif strcmp(event.Key,'y')
    showisocaps('y','up');
    
elseif strcmp(event.Key,'z') & strcmp(event.Modifier,'alt');
    showisocaps('z','hide');
elseif strcmp(event.Key,'z') & strcmp(event.Modifier,'shift');
    showisocaps('z','down');
elseif strcmp(event.Key,'z')
    showisocaps('z','up');
end


function showisocaps(dim,task)

if strcmp(task,'hide')
    ix= findobj(gca,'tag','brainpart2');
    ix=ix(find(cellfun('isempty',regexpi(get(ix,'userdata'),['b' dim] ))==0));
    set(ix,'visible','off');
    showbrainpart;
    return
end

ix= findobj(gca,'tag','brainpart2');
ix=ix(find(cellfun('isempty',regexpi(get(ix,'userdata'),['b' dim] ))==0));

num=find(cellfun('isempty',regexpi( get(ix,'visible'),'on' ))==0);
if isempty(num)
    set(findobj(ix,'userdata',['b' dim '5'] ),'visible','on');
else
    mo=str2num(regexprep( get(ix(num),'userdata') ,['b' dim],''));
    set(ix(num),'visible','off');
    if strcmp(task,'up')
        is=findobj(ix,'userdata',[['b' dim] num2str(mo+1)]);
    else
        is=findobj(ix,'userdata',[['b' dim] num2str(mo-1)]);
    end
    if ~isempty(is)
        set(is,'visible','on');
    else
        if strcmp(task,'up')
            set(findobj(ix,'userdata',[['b' dim] '1']) ,'visible','on');
        else
            imax=max(str2num(char(regexprep(get(ix,'userdata'),['b' dim],''))));
            set(findobj(ix,'userdata',[['b' dim] num2str(imax)]) ,'visible','on');
        end
    end
end
showbrainpart

function showbrainpart(task,dimx,rel)
b=findobj(gca,'tag','brain2');
bv=get(b,'vertices');
ix= findobj(gca,'tag','brainpart2','-and','visible','on');
col=repmat([0.9804 0.7686 0.5647],[size(bv,1) 1] );
if isempty(ix)
   set(b,'FaceVertexCData',col,'facecolor','interp', 'FaceLighting','phong');
set(b,'visible','on');
    return
end
    




us=get(gcf,'userdata');
if isfield(us,'brainnanmat')==0
    bmat={1 '>' nan ;...
        2 '>' nan ;...
        3  '>' nan ;...
        };
    us.brainnanmat=bmat;
    set(gcf,'userdata',us);
else
    bmat=us.brainnanmat;
end


    
for i=1:length(ix)
    v=get(ix(i),'vertices');
    mx=max(v);
    mn=min(v);
    dim=find([mx-mn]==0);
    dimn(i)=dim;
    bmat{dim,3}=mn(dim);
end
misslev=setdiff(1:3,dimn);
if ~isempty(misslev)
    for i=1:length(misslev)
        bmat{misslev(i),3}=nan;
    end
end
if exist('task')
    if strcmp(task,'switch')
        if     strcmp(dimx,'x'); bmat{1,2}=rel;
        elseif strcmp(dimx,'y'); bmat{2,2}=rel;
        elseif strcmp(dimx,'z'); bmat{3,2}=rel;
        end
        us.brainnanmat=bmat;
        set(gcf,'userdata',us);
    end
end
    


bmat(isnan(cell2mat(bmat(:,3))),:)=[];
tg='ic=find(';
for i=1:size(bmat)
    if i>1 ;add=' &  ';else add=' ';end
    tg=[tg  add ' bv(:,' num2str(bmat{i,1}) ')'  bmat{i,2}    num2str(bmat{i,3}) ] ;
end
tg=[tg ') ;' ];
  ic=[];
  eval(tg);
if ~isempty(ic)
    col(ic,:)=nan;
end
set(b,'FaceVertexCData',col,'facecolor','interp', 'FaceLighting','phong');
set(b,'visible','on');
% colormap gray

% freezeColors


function brain2transp(eve)

if 0
        open(regexprep(which('labs.m'),'labs.m','brain2.fig')); hold on
    delete(findobj(gca,'tag','brainpart'));
    % h=spm_vol('C:\thamar2\test_surfbrainplot\makebrain\spm_template\ch2bet.nii')
    ar='C:\thamar2\test_surfbrainplot\makebrain\spm_template\ch2bet.nii'
    hh=load_nii(ar);
    xs=single(hh.img);hh.img=[]; %HEAD
    xs(isnan(xs))=nanmedian(xs(:));
    siz= size(xs);
    sih=size(xs)/2 ;
    
    sx=[hh.hdr.hist.srow_x(4) hh.hdr.hist.srow_y(4) hh.hdr.hist.srow_z(4)]
    lin=[0 0 0]+abs(sx)
    
    
    tresh=50;
    
    
    for j=1:3
        for i=1
            if j==1      xs2=xs(1:lin(j),:,:) ; tg='bx';
            elseif j==2; xs2=xs(:,       1:lin(j),:,:) ;tg='by';
            elseif j==3; xs2=xs(:,:,1:lin(j)) ;    tg='bz';
            end
            %     delete(findobj(gca,'tag','brainpart'))
            [fa,va,ca] = isocaps(single(xs2),tresh );
            v11=vc2nc([va(:,2) va(:,1) va(:,3)],hh);% volumecoords to normalized cords
            p3=patch('vertices',v11,'faces',fa)
            set(p3,'FaceVertexCData',ca,'edgecolor','none')
            set(p3,'FaceColor','interp','tag','brainpart','userdata',tg);
            colormap gray
            drawnow
        end
    end
    
    ch=findobj(gca,'tag','brain2'); set(ch,'visible','off')
    ch=findobj(gca,'tag','brainpart'); set(ch,'visible','off')
    
%     ------------ add more slices--------------------------------
delete(findobj(gca,'tag','brainpart2'));
    tresh=20;
for j=1:3
    if j==1
        n=9;
        ns=35;
       lin= round(linspace(ns,size(xs,1)-ns+1, n));
       f='xs2=xs(1:lin(i),:,:);';  tg='bx';
    elseif j==2; 
         n=9;
        ns=25;
        lin= round(linspace(ns,size(xs,2)-ns+1, n));
        f='xs2=xs(:,1:lin(i),:);';  tg='by';
        xs2=xs(1:lin(j),:,:) ;
    elseif j==3; 
         n=9;
        ns=30;
        lin= round(linspace(ns,size(xs,3)-ns+1, n));
        f='xs2=xs(:,:,1:lin(i));';  tg='bz';
        xs2=xs(1:lin(j),:,:) ;
%         xs2=xs(:,:,1:lin(j)) ;    tg='bz';
    end
    for i=1:length(lin)
         eval(f);
        %     delete(findobj(gca,'tag','brainpart2'))
        [fa,va,ca] = isocaps(single(xs2),tresh );
        v11=vc2nc([va(:,2) va(:,1) va(:,3)],hh);% volumecoords to normalized cords
        p3=patch('vertices',v11,'faces',fa)
        set(p3,'FaceVertexCData',ca,'edgecolor','none')
        set(p3,'FaceColor','interp','tag','brainpart2','userdata',[tg num2str(i) ]);
        colormap gray
        drawnow
    end
end
    
ch=findobj(gca,'tag','brain2'); set(ch,'visible','off')
ch=findobj(gca,'tag','brainpart2'); set(ch,'visible','off')


    
end




%
% axl=round(axis)
% delete(findobj(gca,'tag','slic'));
%
% x=linspace(0,0,100 )
% y=linspace(axl(3),axl(4),100 )
% z=linspace(axl(5),axl(6),100 )
% [x y z]=meshgrid(x,y,z);
%
%  tx=squeeze(xs(90,:,:));
% %  tx(tx<1)=nan
% tx2=ind2rgb(tx,gray)
% % tx = imread('autumn.tif');
% %  tx(tx>40)=nan;
% % tx2(1:50,1:50,:)=nan;
% fg
% h=surf(x,y,z,tx2,'facecolor','texturemap','edgecolor','none');
%
% fg
%   hp=patch([0 0 0 0],[axl(3) axl(4)  axl(4) axl(3) ],[axl(5) axl(5)  axl(6) axl(6) ],'g');
%     set(hp,'facealpha',1,'edgecolor','none','tag','slic')
%
%
%   t=load('clown')
%   patchTexture(hp,t.X)
%   set(hp,'facecolor','texturmap')
%
ch=findobj(gca,'tag','brain2');
v1=get(ch,'vertices');
%
% bor=[min(v1);max(v1)];

ac={'ix=[]'  'ca=[]'
    'ix=find(v1(:,1)<0)' 'ca=''bx'''
    'ix=find(v1(:,1)>0)' 'ca=''bx'''
    'ix=find(v1(:,2)<0)' 'ca=''by'''
    'ix=find(v1(:,2)>0)' 'ca=''by'''
    'ix=find(v1(:,3)<0)' 'ca=''bz'''
    'ix=find(v1(:,3)>0)' 'ca=''bz'''
    };
eval([(ac{str2num(eve),1}) ';']);
eval([(ac{str2num(eve),2}) ';']);
bp=findobj(gca,'tag','brainpart'); set(bp,'visible','off')
if ~isempty(ca)
    bp=findobj(gca,'tag','brainpart','-and','userdata',ca); set(bp,'visible','on')
end

%     f1=get(ch,'Faces');
% col=single(zeros(size(v1) ,3))+1;
col=repmat([0.9804 0.7686 0.5647],[size(v1,1) 1] );
% [0.9804 0.7686 0.5647]


% ix=find(v1(:,1)<0);
col(ix,:)=nan;
set(ch,'FaceVertexCData',col,'facecolor','interp', 'FaceLighting','phong');
set(ch,'DiffuseStrength',.2);


% #####################
function dotcallback(dum,dum2)
% 
explodeshow('single');


function   explodeshow(do)




lab=findobj(gca,'tag','label');
lin=findobj(gca,'tag','arrow');
dot=sort(findobj(gcf,'tag','dot'));
us=get(gcf,'userdata');

for i=1:length(lab)
    labclust(i)=getappdata(lab(i),'cordsClust');
end
for i=1:length(dot)
    dotclust(i)=getappdata(dot(i),'cordsClust');
end

bord3=120;
no=length(dot);
bordz=70;
t=linspace(0,2*pi,no+1); %t=t(1:no);
xc=cos(t)*bord3;
yc=sin(t)*bord3-20;

if strcmp(do,'single')
    if strcmp(get(gco,'tag'),'dot')
        us= get(gco,'userdata');
        thisclust=getappdata(gco,'cordsClust');
        ix= find(dotclust==thisclust);
        ixv=dotclust(ix);
        dotclust=dotclust.*nan;
        dotclust(ix)=ixv;
        
         ix= find(dot==gco);
        ixv=dot(ix);
        dot=dot.*nan;
        dot(ix)=ixv;
    end
else %all
   
    
end



helpline=findobj(gca,'tag','helpline');

if   strcmp(do,'single') && us.isexploded==0
    helpline=[];
elseif strcmp(do,'single') && us.isexploded==1
%     if isempty(findobj(gca,'tag','helpline'))
        
%     hx=plot3(xc,yc,yc.*0+bordz,'-r','tag','helpline','color',[.7 .7 .7]);
    
end

if isempty(helpline)
    delete(findobj(gca,'tag','helpline'))
    
    if ~strcmp(do,'single')
        us=get(gcf,'userdata');
        [az el]=view;     us.view=[az el];     set(gcf,'userdata',us);
        view(0,90);
    end
    
    hx=plot3(xc,yc,yc.*0+bordz,'-r','tag','helpline','color',[.7 .7 .7],'hittest','off');
    % 
  
    xl=xlim;
    yl=ylim;
    xlim([-160 160]);
    ylim([-160 160]);
    bord0=110;
    us=get(gcf,'userdata');
%     us.axlims2=axis;
    
    for i=1:length(dot)
        if isnan(dot(i))
            continue
        end
        
        if mod(i,2)==0
            addy=0;
        else
            addy=0;
        end
        dotclust2=getappdata(dot(i),'cordsClust');
        v1= get(dot(i),'vertices');
        %     v1(:,1)=v1(:,1)+ (bord-mean(v1(:,1)));
        v1(:,1)=v1(:,1)+ (xc(i)-mean(v1(:,1)));
        v1(:,2)=v1(:,2)+ (yc(i)-mean(v1(:,2)));
        v1(:,3)=v1(:,3)+ (bordz-mean(v1(:,3)));
        set(dot(i),'vertices',v1);
        us=get(dot(i),'userdata'); us.isexploded=1; set(dot(i),'userdata',us);
        
        n0=0;
        nstep=-6;
        ix=find(labclust==dotclust2) ;
        for j=1:length(ix)
            la=lab(ix(j));
            pos=get(la,'Position');
            pos= mean(v1,1)  ;
            pos(1)=pos(1)+sign(pos(1))*30;
            pos(2)=pos(2)+n0+addy;
            pos(3)=pos(3)+30;
            n0=n0+nstep;
            set(la,'Position',pos);
            us=get(la,'userdata'); us.isexploded=1; set(la,'userdata',us);
            set(lin(ix(j)),'visible','off');
            us=get(lin(ix(j)),'userdata'); us.isexploded=1; set(lin(ix(j)),'userdata',us);
             
        end
    end
    %     set(dot,'facealpha',.3);
     if ~strcmp(do,'single')
        us=get(gcf,'userdata');
        us.axlims2=[xlim ylim zlim];
        set(gcf,'userdata',us);
        delete(helpline);
    end
    
    
else
    if ~strcmp(do,'single')
        us=get(gcf,'userdata');
        try
        view(us.view);
        catch
        view(90,0);    
        end
    end
    
    for i=1:length(dot)
        if isnan(dot(i))
            continue
        end
        dotclust2=getappdata(dot(i),'cordsClust');
        us= get(dot(i),'userdata');
        set(dot(i),'vertices',us.v11);
        us=get(dot(i),'userdata'); us.isexploded=0; set(dot(i),'userdata',us);
        
        ix=find(labclust==dotclust2) ;
        for j=1:length(ix)
            la=lab(ix(j));
            us=get(la,'userdata');
            set(la,'position',us.cent2);
            us=get(la,'userdata'); us.isexploded=0; set(la,'userdata',us);
            set(lin(ix(j)),'visible','on');
            us=get(lin(ix(j)),'userdata'); us.isexploded=0; set(lin(ix(j)),'userdata',us);

        end
        set(dot(i),'facealpha',1);
    end
    
    
    
    
    if ~strcmp(do,'single')
        us=get(gcf,'userdata');
        axis(us.axlims);
        delete(helpline);
    end
end



function vol2surface

set(findobj(gcf,'tag','brain2'),'visible','on');
% set(findobj(gcf,'tag','brain'),'visible','on');

disp('...wait a moment...');
% braincol=[0.9804    0.7686    0.5647];
% map =hot ;

us= get(gcf,'userdata');
b=  findobj(gcf,'tag','brain2');
v1=single(get(b,'vertices'));

% map      =us.map;
eval(['map=' us.map ';'])
% map=cool;
braincol =us.braincol;

col00=get(b,'FaceVertexCData');
try
    ix=find(~isnan(col00(:,1)));
    col00(ix,:)=repmat( braincol, [size(ix,1) 1]);
end
 col00=repmat( braincol, [size(v1,1) 1]);
set(b,'FaceVertexCData',col00,'facecolor','interp', 'FaceLighting','phong');
% col0=get(b,'FaceVertexCData');
% col=col0.*1;

 


z0=us.Z;
z=us.Z-min(us.Z);
z=round(63*(z/max(z))+1);
tab=single(sortrows([z0' z'  us.XYZmm'   ],1));
 
col=col00;
disksize=6;
r = disksize.^2;
O = single( ones(1,size(v1,1)));% searchlite sphereSize
XYZmm=v1';

% v2=[];
% for v=1:size(tab,1)
%     ix=dsearchn(v1,tab(v,3:5));
%     s=[];
%     s = find((sum((XYZmm-XYZmm(:,ix)*O).^2) <=  r))';
%     s(:,2)=tab(v,2);
%     v2=[v2;s];
% end
if isfield(us ,'projsiz')
  v2=us.projv2;
else
    v2=[];
    for v=1:size(tab,1)
        s=[];
        s = find((sum((XYZmm-[tab(v,3:5)]'*O).^2) <=  r))';
        s(:,2)=tab(v,2);
        v2=[v2;s];
    end
    disp('...');
    v2=unique(v2,'rows');
end
% coli=repmat([0 0 1], [length(v2) 1]);
% col(v2,:)=coli;
for i=1:size(v2,1)
    col(v2(i,1),: )=map(v2(i,2),:);
end
set(b,'FaceVertexCData',col,'facecolor','interp', 'FaceLighting','phong');
set(b,'facealpha',1);

 
us.projsiz=disksize;
us.projv2  =v2;
set(gcf,'userdata',us);

% 'a'
if 1


 delete(findobj(gcf,'tag','cbar'));  
 delete(findobj(gcf,'tag','Colorbar')); 
 delete(findobj(gcf,'tag','cbarimage'));  
 delete(findobj(gcf,'tag','ax2'));  
ax=axes('position',[.05 .05 .05 .3],'tag','ax2','visible','on','hittest','off') ;

map2=[];
map2(:,1,1)=map(:,1);
map2(:,1,2)=map(:,2);
map2(:,1,3)=map(:,3);
% map2=repmat(map2,[1 10 1])
im=image(map2,'tag','cbarimage','hittest','off');
set(gca,'YAxisLocation','right');
set(gca,'ytick',[1 64]);
set(gca,'yticklabel',{sprintf('%2.2f',min(z0)) sprintf('%2.2f',max(z0))}');
set(gca,'ydir','normal','fontsize',8,'fontweight','bold');
set(gca,'xtick',[]);
set(gca,'position',[.02 .05 .02 .2]);
set(gca,'tag','ax2','hittest','off');

% im=imagesc(z0,'tag','cbarimage','visible','off','hittest','off');
% colormap(map);
% freezeColors;
% cb=colorbar('hittest','off');;
% set(ax,'visible','on');
% set(im,'visible','off');
%   set(cb,'ytick',[0 1],'fontsize',8,'fontweight','bold');
% set(im,'tag','cbarimage')

%  set(ax,'position',[[-.08 .05 .05 .2]])
 
set(ax,'hittest','off');
% set(cb,'hittest','off');
set(im,'hittest','off');


% %   lim=sprintf('%2.2f\n',[min(z0) max(z0)]) 
% % set(cb,'xtick',[0 1])
% set(cb,'ytick',[0 1])
% % pause(.01)
%  set(cb,'ytick',[0 1],'yticklabel',{sprintf('%2.2f',min(z0)) sprintf('%2.2f',max(z0))}');
% %set(cb,'ytick',[0 1],'yticklabel',[2 4]);
% % set(cb,'ytick',[0 1]);
% set(cb,'ytick',[0 1])
% % set(cb,'ytick',[1 64]);
set(gcf,'currentaxes',findobj(gcf,'tag','ax1'));

end

%     ar='C:\thamar2\test_surfbrainplot\makebrain\spm_template\ch2bet.nii'
%     %     ar='C:\thamar2\test_surfbrainplot\makebrain\spm_template\ch2.nii'
%     
%     hh=load_nii(ar);
%     xs=single(hh.img);hh.img=[]; %HEAD
%     xs(isnan(xs))=nanmedian(xs(:));
%     [f1,v1] =isosurface(xs) ;%,50);%50
%     % clear xs;
%     f1=single(f1);
%     v1=single(v1);
%     nfv = reducepatch(double(f1),double(v1),.1,'fast');%.05
%     v1=single(nfv.vertices);
%     f1=single(nfv.faces);
%     v11=vc2nc([v1(:,2) v1(:,1) v1(:,3)],hh);% volumecoords to normalized cords
%     e = patch('faces',f1,'vertices',v11,...%isosurface(xs,.1) %##.2
%         'FaceColor',[ 0.9804    0.7686    0.5647],	'EdgeColor','none');
%     set(e, 'tag','brain2');
%     set(e,'FaceLighting','phong');
    
    %     #######################################
    
%     load xm
%     
%     b=findobj(gcf,'tag','brain2');
%     pa.faces= (get(b,'faces'));
%     pa.vertices= (get(b,'vertices'));
%     set(b,'facecolor',[1.0000    1    0.3922]);
%     col00=repmat( [1 1 1], [size(pa.vertices,1) 1]);
%     set(b,'FaceVertexCData',col00,'facecolor','interp', 'FaceLighting','phong');
%     col0=get(b,'FaceVertexCData');
%     col=col0.*1;
%     %  col=col0;
%     val=xm;
%     vert=pa.vertices;
%     disksize=5;
%     r = disksize.^2;
%     O = single( ones(1,size(vert,1)));% searchlite sphereSize
%     XYZmm=vert';
%     v2=[];
%     for v=1:size(val,1)
%         ix=dsearchn(vert,val(v,:));
%         s = find((sum((XYZmm-XYZmm(:,ix)*O).^2) <=  r));
%         v2=[v2;s(:)];
%     end
%     v2=unique(v2,'rows');
%     coli=repmat([0 0 1], [length(v2) 1]);
%     col(v2,:)=coli;
%     set(b,'FaceVertexCData',col,'facecolor','interp', 'FaceLighting','phong');
%     set(b,'facealpha',1)



