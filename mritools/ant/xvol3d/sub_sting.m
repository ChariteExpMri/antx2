
% #ok create sting-view: node-related needles with numeric annotations (labels) for DTI-data
% - annotations are view-dependent and will be adjusted accordingly. 
% - labels appear at positions along a circle circumventing the brain.
% - labels can be manually repositioned
% - function is part of xvol3d.m/sub_plotconnections to display DTI-connection onto a 3D brain
% 
% #wg manual label reposition 
% * Needles sometimes cross each other. In this case, you can click and drag a label to a another
% position on a circle. The linked needle position is adjusted accordingly. 
% #g Use the right mouse key to drag the label to an arbitray position. I.e. the labels appear not
% along a circle. The linked needle position is adjusted accordingly. 
% Note that specific parameter reset the label positioning. These paramter changes are:
%  the view, circle radius, [radius], [rad.points], [rad.dist]. These parameters will reset the 
% label position, thus use manual label reposition as last step. Note that, label-fontsize &
% color, linestyle & color & width can be adjusted after manual repositioning .
% 
% #wg STING PRPERTIES/PARAMETER
% -Parameter can be changed via GUI,  available via [props]-(properties) button right to the [sting]-button
%  from the plot_connections GUI
% #b NEEDLE PROPS --------
% [line style] : change needle linestyle (options via pulldown)
% [line widht] : change needle linewidth (options via pulldown or edit field)
% [line color] : change needle color (options via color palette or edit field)
% #b LABEL POSITION --------
% [radius]     : defines circle radius around the brain to position the labels/anotations
%                (options via  pulldown or edit field) 
% [rad.points] : number of points on the  circle radius around the brain to position the labels/anotations
%               (options edit field) 
% [rad.dist]   : minimum distance between label position along the circle.
%                If distance is small, labels could overlap, if distance to large the neddles might cross
%                and labels appear at other positions  in the circle
%               (options edit field) 
% [3DvolCenter] :  circle  center is: [x] center of the 3D volume, [ ] center point of all DTI-connections
% #b LABEL PROPS--------
% [label font]  : change label fontsize  (options via pulldown or edit field)
% [label bold]  : label fontweight:  [x] bold ;  [ ] normal font
% [label color] : change label color (options via color palette or edit field)
% 
% #b OTHER--------
% [debug] : debug modus...additionally displays the circle
% [+]     : drag button, drag properties panel to another position 
% [?]     : help button, show this function help 
% [x]     : close button, close properties panel 
% 
% 
% #k assoc. functions: #n  [xvol3d.m][sub_plotconnections.m][sub_sting.m]
% 
function sub_sting()
% ==============================================
%%   
% ===============================================

hf=findobj(0,'tag','xvol3d');
ha=findobj(hf,'tag','ax0');
hp=findobj(ha,'tag','connectionlabel');




h2=findobj(0,'tag','plotconnections'); %gui-2
us2=get(h2,'userdata');
pp=us2.sting;


%% =========off-mode======================================
% disp(['modeSting: '  num2str(pp.stingview)]);
if pp.stingview==0
    delete(findobj(hf,'tag','nodelabels2'));
    delete(findobj(hf,'tag','circlelabel'));
    delete(findobj(hf,'tag','needle2'));
    
  
%     for i=1:100
%         
%         %         delete(findobj(hf,'userdata',['needletxt' num2str(i) 'a']));
%         %         delete(findobj(hf,'userdata',['needletxt' num2str(i) 'b']));
%         try
%             set(findobj(hf,'userdata',['needletxt' num2str(i) 'a']),'visible','on');
%         end
%         try
%             set(findobj(hf,'userdata',['needletxt' num2str(i) 'b']),'visible','on');
%         end
%     end
    
    set(hp,'visible','on');
     set(findobj(hf,'tag','needle1'),'visible','on');
     
     figure(hf)
     h = rotate3d;                 % Create rotate3d-handle
     h.ActionPostCallback = {@RotationCallback_sting,  pp.stingview}; % assign callback-function
     
     
    return
    
end



if isempty(hp)
    msgbox('no connect-labels found');
    return
end
    
    



% ==============================================
%%   
% ===============================================

figure(hf)
h = rotate3d;                 % Create rotate3d-handle
h.ActionPostCallback = {@RotationCallback_sting,  pp.stingview}; % assign callback-function
% h.Enable = 'on';              % no need to click the UI-button

    
    


% ==============================================
%   get brain-patch
% ===============================================

hb=findobj(ha,'tag','brain');
if length(hp)>1
    ds=cell2mat(get(hp,'position'));
else
        ds=(get(hp(1),'position'));
end

% centerplot=1;
centerplot=pp.volcenter;

if centerplot==0
    ce=mean(ds,1);
    mn=min(ds,[],1);
    mx=max(ds,[],1);
    
    % ce=mean([mean(get(hb,'xdata'),2)    mean(get(hb,'ydata'),2)    mean(get(hb,'zdata'),2)],1);
    % mn=mean([ min(get(hb,'xdata'),[],2)  min(get(hb,'ydata'),[],2)  min(get(hb,'zdata'),[],2)],1);
    % mx=mean([ max(get(hb,'xdata'),[],2)  max(get(hb,'ydata'),[],2)  max(get(hb,'zdata'),[],2)],1);
    sizp=mx-mn;
elseif centerplot==1
    ce=getappdata(hb,'center');
    sizp=[repmat(100,[1 3])];
end

ceo  =getappdata(hb,'center');
sizp2 =[repmat(100,[1 3])];


% facresize=1.1;
facresize=us2.sting.radiusfac;

% if mode==1
% delete(findobj(ha,'tag','circle'));
% delete(findobj(ha,'tag','txlabel'));
% ----------
[az el]=view;
az=deg2rad(az); el=deg2rad(el);
[x,y,z] = sph2cart(az,el,10);
nx=[y x z];
% ce=[90 90 90];
% ce=[ 90   90   77.2875]
center=ce;

% center=[0 0 0]
normal=nx;
% sizp=1
radius=mean(sizp).*facresize;
theta=0:0.01:2*pi;
v=null(normal);
% center of connections
pointslin=repmat(center',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
%center of plot
pointslin2=repmat(ceo',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));

if 1
    %     fg
    delete(findobj(hf,'tag','circlelabel'));
    pl=plot3(pointslin(1,:),pointslin(2,:),pointslin(3,:),'r-');
    set(pl,'tag','circlelabel');
    
    pl=plot3(pointslin2(1,:),pointslin2(2,:),pointslin2(3,:),'m-');
    set(pl,'tag','circlelabel');
end


if 0
    % ==============================================
    %%   test-projection
    % ===============================================
    hn=findobj(hf,'tag','node');
    
    nodelab={};
    nodepos=[];
    for i=1:length(hn)
        nodelab{i,1} = getappdata(hn(i),'label');
        nodepos(i,:)  = [mean(hn(i).XData(:)) mean(hn(i).YData(:)) mean(hn(i).ZData(:))];
    end
    
    td=us2.t.Data(:,[2 4]);
    pairs={};
    pairpos=[];{};
    for i=1:size(td,1)
        
        ix1=find(strcmp(nodelab, td{i,1}));
        ix2=find(strcmp(nodelab, td{i,2}));
        
        pairs{i,1}=[nodelab{ix1(1)} ' ## '  nodelab{ix2(1)}];
        pairpos=[pairpos;  [nodepos(ix1(1),:) ; nodepos(ix2(1),:)] ]; %every 1st and 2nd are pairs
        
    end
    
    
    % ==============================================
    %
    % ===============================================
    
    ax=findobj(hf,'tag','ax0');
    u1=cell2mat(get(hp,'position'));
    v1=project2d(u1,ax);
    v3=project2d(pointslin2',ax);
    
    hl=findobj(hf,'tag','link');
    figure(1000);
    cla;
    hold on
    pl=plot(v1(:,1),v1(:,2),'or','markerfacecolor','r','tag','test');
    pl=plot(v3(:,1),v3(:,2),'.m-','tag','test');
    set(gca,'xdir','reverse');
    
    v2=project2d(pairpos,ax);
    
    for i=1:2:size(v2,1)
        pl=plot(v2(i:i+1,1),v2(i:i+1,2),'k-','tag','test');
    end
    
    % for i=1:length(hl)
    %
    %     q1=get(hl(i),'xdata');
    %     q2=get(hl(i),'ydata');
    %     q3=get(hl(i),'zdata');
    %     pw=[q1(:)  q2(:) q3(:)];
    %     v2=project2d(pw,ax);
    %
    %     % fg
    %     % pl=plot(v1(:,1),v1(:,2),'or','markerfacecolor','r','tag','test');
    %     hold on
    %     pl=plot(v2(:,1),v2(:,2),'k-','tag','test');
    % end
    
    %% min circle-distance
    delete(findobj(gcf,'tag','test2'));
    delete(findobj(gcf,'tag','test3'));
    
    minc=[  ];
    ts=[v2(1:2:end,:) v2(2:2:end,:)];
    
    for i=1:size(v1,1)
        doisect=0;
        dis=sum((v3-repmat(v1(i,:),[size(v3,1) 1 ])).^2,2);
        imin=find(dis==min(dis))
        minc(i,:)=[ imin  min(dis)];
        
        bo=[  v1(i,:) ;  v3(imin,:)]
        
        
        lin1=[v1(i,:) ; v3(imin,:)];
        
        for j=1:size(ts,1)
            lin2=[ts(j,1:2); ts(j,3:4)];
            [is pos]=curvintersect( lin1(:,1),lin1(:,2),lin2(:,1),lin2(:,2) ,0);
            disp([j is]);
            if is==1
                pl=plot(pos(1),pos(2),'ms','tag','test3');
                imax=find(dis==max(dis))
                lin3=[v1(i,:) ; v3(imax,:)];
                pl=plot(lin3(:,1),lin3(:,2),'g--','tag','test3');
                
                doisect=1;
                
            end
            
        end
        
        if doisect==0
            pl=plot(bo(:,1),bo(:,2),'b--','tag','test2');
        end
        %         [is pos]=curvintersect( x1,y1,x2,y2 ,1);
        %         drawnow,
        %         pause
        
    end
    
    %%
    
    lins=[];  %v3(minc(i,1),:)
    for i=1:size(v1,1)
         lins=[lins  ;[  v1(i,:)   v3(minc(i,1),:)] ];
    end
    
    
    [so isort]=sort(minc(:,2))
    delete(findobj(gcf,'tag','test2'));
    for i=1:length(isort)
        is=isort(i)
        pl=plot(lins(is,[ 1 3 ]),lins(is,[ 2 4 ]),'b--','tag','test2');
        
%         %% dd
%         x=lins(is,[ 1 3  3 1])
%         y=lins(is,[ 2 2  [4 4] ])
%         fg; plot(x,y,'r')
%         %% dd
%         
%         xx=[  xx  [xx]+.01  ];xx=xx([1 3 2 4 ])
%         yy=[  yy  [yy]+.01  ]; 
%         pl=plot(xx,yy,'m--','tag','test2');
        
%         drawnow, pause(1);
    end
    
    %% ----
    
    
    
    figure(hf);
    
end

% ==============================================
%%   
% ===============================================

% ==============================================
%%   test
% ===============================================
if 0
    poslab=cell2mat(get(hp,'position'))
    
    dum=v(:,1)*poslab(:,1)'+v(:,2)*poslab(:,2)'
    ps=plot3(dum(1,:),dum(2,:),dum(3,:),'or','markerfacecolor','r');
    set(ps,'tag','test')
end
% ==============================================
%%   
% ===============================================



% ==============================================
%%   
% ===============================================

% sepmax=10;
% pointsfac=250;
pointsfac=pp.pointsfac;
sepmax   =pp.sepmax;
% sepmax=2;
% pointsfac=150;

np=length(hp)*pointsfac;
theta=linspace(0,2*pi,np+1);%0:0.01:2*pi;
theta=theta(1:np);
v=null(normal);
points=repmat(center',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));

txradius=mean(sizp).*facresize;
txpoints=repmat(center',1,size(theta,2))+txradius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));

ticradius=mean(sizp).*(facresize-.1);
ticpoints=repmat(center',1,size(theta,2))+ticradius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));

% ##########
points_ce   =repmat(ceo',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
ticpoints_ce=repmat(ceo',1,size(theta,2))+ticradius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));

%  pl=plot3(points_ce(1,:),points_ce(2,:),points_ce(3,:),'m-');
%     set(pl,'tag','circlelabel');
%  pl=plot3(ticpoints_ce(1,:),ticpoints_ce(2,:),ticpoints_ce(3,:),'b-');
%     set(pl,'tag','circlelabel');
% end

% ==============================================
%%   search
% ===============================================
txpoints2=txpoints';
% txpoints2=points'
dev=[];
is=[];
newplist=[];
for i=1:size(ds,1)
   sq=sum((txpoints2-repmat(ds(i,:),[size(txpoints2,1) 1])).^2,2);
    %sq=sum((ds-repmat(txpoints2(i,:),[size(ds,1) 1])).^2,2);
    sq=[ones(length(sq),1).*i sq  [1:size(txpoints2,1)]'];
    %sq=[[1:size(ds,1)]' sq];
   
     idx=find(sq(:,2)==min(sq(:,2)));
     newp= txpoints2(idx,:);
     dev=[dev; sq];
     if isempty(newplist)
        is(i,1)      =idx;
        newplist(i,:)=newp;
         
     else
        
         % ==============================================
         %
         % ===============================================
         
         ssort=sort(sq(:,2));
         dorun=1;
         j=0;
         while dorun==1
             j=j+1;
             %          for j=1:10
             idx=find(sq(:,2)==ssort(j));
             newp= txpoints2(idx,:);
            
             sep=min(sqrt(sum((newplist-repmat(newp,[size(newplist,1) 1])).^2,2)));
             %disp(sep);
             if sep>sepmax
                 dorun=0;
                 
                 is(i,1)      =idx;
                 newplist(i,:)=newp;
                 
                 
             end
         end
         % ==============================================
         %
         % ===============================================

         
         
     end
     
     
%      if i==length(ds) || i==length(ds)-2
%          fg,plot(sq(:,2),'-r.'); title(i)
%      end
    
end

txpoints2=txpoints2';

% ==============================================
%%  plot labels
% ===============================================


% %%  
% clc
% is=[];
% for i=1:size(ds,1)
%     ix=find(dev(:,2)==min(dev(:,2)));
%     is(i,1)=dev(ix,3);
%     dev(dev(:,3)==dev(ix,3),:)=[];
% end
% ==============================================
%%   % ----- label to close
% ===============================================

is1=is;

[w isort]=sort(is1);

df=diff(w);
tr=[w [df;nan]];
iw=find(tr(:,2)<=70);
if ~isempty(iw)
    go=1;
    stp=1;
    
    while go==1
        if iw(1)==1
            
        else
            w(iw(1),1)=  round( mean([tr(iw(1)-1,1)     tr(iw(1)+1,1)]))   ;
        end
        df=diff(w);
        tr=[w [df;nan]];
        iw=find(tr(:,2)<=60);
        stp=stp+1;
        if isempty(iw) || stp>100
            go=0;
        end
    end
    is2=zeros(size(is));
    is2(isort )=w;
    % [is is2  ]
    is=is2;
end


% ==============================================
%%   
% ===============================================


%----------------------


txpoints3 =txpoints2(:,is)';
ticpoints3=ticpoints(:,is)';

if 0
    txpoints3 =points_ce(:,is)';
    ticpoints3=ticpoints_ce(:,is)';
end

if 0
[ poi idx ]=snip_algo_intersect3(pointslin2,1);
txpoints3  =pointslin2(:,idx)';
ticpoints3 =txpoints3;
end

figure(hf);

u.txpoints2   =txpoints2;  %for callback clicked draged
u.ticpoints   =ticpoints;
% ==============================================
%
% ===============================================
% px=txpoints3;
% px=txpoints2;
% px=ds;
mode=0;

delete(findobj(hf,'tag','nodelabels2'));
for i=1:length(hp);
    %     ub=getappdata(hp(i),'store') ;
    %     modi(i,1)=ub.mode;
    %     if ub.mode==1
    %----label
    %         label=getappdata(hp(i),'label');
    %         te=text(txpoints(1,i),txpoints(2,i),txpoints(3,i),label);
    
%     if mode==1
%         hp(i).Position=txpoints2(i,:);
%     else
%         hp(i).Position=ds(i,:);
%     end
    
    te=text(txpoints3(i,1),txpoints3(i,2),txpoints3(i,3),get(hp(i),'String'));
    %te=text(px(i,1),px(i,2),px(i,3),num2str(i));
    
    set(te,'fontsize', pp.fs  ,'interpreter','none','color', pp.fontcol);
    set(te,'HorizontalAlignment','center','tag','nodelabels2', 'VerticalAlignment', 'middle');
    
    
    u.ticpoints3=ticpoints3(i,:);
    u.px        =txpoints3(i,:);
    set(te,'userdata',u) ;
    %     ,'callback', @draglabels);
    %     end
end
% return
% ==============================================
%%   plot needles2
% ===============================================
% hn=findobj(hf,'tag','node');
% strlist=regexprep(get(hn,'userdata'),{'node','a' 'b'},{''})
strlist=get(hp,'string');
he=findobj(hf,'tag','nodelabels2');
if pp.fontbold==1
   set(he,'fontweight','bold');
else
   set(he,'fontweight','normal'); 
end

delete(findobj(hf,'tag','needle2'));
for i=1:length(he);
    str=get(he(i),'string');
    ix=find(strcmp(strlist,str));
    %pos1=he(i).Position
    u=get(he(i),'userdata');
    pos1=u.ticpoints3;
    pos2=hp(ix(1)).Position;
    
    hl=plot3([pos1(1) pos2(1)],[pos1(2) pos2(2)],[pos1(3) pos2(3)],'r' );
    set(hl,'tag','needle2');
    setappdata(hl,'needlelabel',str)
%     cc=[];
%     for j=1:length(ix)
%         xn=get(hn(ix(j)),'Xdata'); 
%         yn=get(hn(ix(j)),'ydata'); 
%         zn=get(hn(ix(j)),'zdata'); 
%         cc(j,:)=[mean(xn(:)) mean(yn(:)) mean(zn(:))];
%     end
    
end
hn=findobj(hf,'tag','needle2');
set(hn,'color',pp.linecol);
set(hn,'linestyle',pp.linestyle,'linewidth',pp.linewidth)

set(he,'color',pp.fontcol);

% ==============================================
%%   debug mode
% ===============================================

if pp.isdebug==0
    set(findobj(hf,'tag','circlelabel'),'visible','off');
    set(hp,'visible','off');
else
    set(findobj(hf,'tag','circlelabel'),'visible','on');
    set(hp,'visible','on');
end

% tic;ww=snip_algo_intersect3(pointslin2,1);toc
% figure(hf);

% set(gcf,'WindowButtonMotionFcn',@draglabels)
hrot=rotate3d;
rotationstatus=strcmp(hrot.enable,'on');
if rotationstatus==1
    rotate3d off;
end
set(hf,'WindowButtonDownFcn',@clickedlabels);
set(hf,'WindowButtonUpFcn',@unclickedlabels);

if rotationstatus==1
    rotate3d on;
end
% ==============================================
%%   check intersection
% ===============================================
return
% ==============================================
%%   
% ===============================================

hn=findobj(hf,'tag','needle2');
clc
sec=zeros(length(hn));
ninterp=100;
for j=1:length(hn)
    for i=1:length(hn)
        if i~=j
            %msec= intersect(hn(j),hn(i));
            p1x= round(hn(i).XData);
            p1y= round(hn(i).YData) ;
            p1z= round(hn(i).ZData) ;
            
            p2x= round(hn(j).XData);
            p2y= round(hn(j).YData) ;
            p2z= round(hn(j).ZData) ;
            
            lab1=getappdata(hn(i),'needlelabel');
            lab2=getappdata(hn(j),'needlelabel');
            
%             s1=[p1x(1) p1y(1) p1z(1); p2x(1) p2y(1) p2z(1); ];
%             s2=[p1x(2) p1y(2) p1z(2); p2x(2) p2y(2) p2z(2); ];
%             [P_intersect,distances] = lineIntersect3D(s1,s2);
% %             disp([ i j min(distances)])
%             mindis=min(distances);
            p1=interparc(ninterp,p1x,p1y,p1z,'linear');
            p2=interparc(ninterp,p2x,p2y,p2z,'linear');
            %         msec=intersect(p1,p2);
            
            [ix,dis]=dsearchn(p1,p2);
            cp=    p1(min(find(dis==min(dis))),:);
             %p1(min(find(ix==min(ix))),:);
            dev=sqrt(sum((repmat(cp,[size(p2,1) 1])-p2).^2,2));
            ic2=find(dev==min(dev));
            mindis=min(dev);
            
           
            
%            %     mindis=min(dis);
%                  disp(mindis);
            if mindis<10;
             disp([i j mindis  str2num(lab1) str2num(lab2)]);
            end
        end
    end
end


% ==============================================
%%   
% ===============================================

return

% ==============================================
%%
% ===============================================
mode=1; % explode mode [0]back to orig data [1]explode mode

for i=1:length(hp)
    hi=hp(i);
    
    %     disp(i);
    uv.pos=get(hp(i),'position')
%     uv.xdata   =get(hi,'xdata');
%     uv.ydata   =get(hi,'ydata');
%     uv.zdata   =get(hi,'zdata');
    
    %     uv.vertices=get(hi,'vertices');
    
    field='store';
    if isappdata(hi,field)==0
        uv.mode=0;
        setappdata(hi,field,uv)
    end
    
    if isappdata(hi,'exlodemode')==0
        setappdata(hi,'exlodemode',mode);
    end
    
    if mode==0 %back to original position
        if do(i)==1
            uv=getappdata(hi,field);
            set(hi,'xdata'   ,uv.xdata);
            set(hi,'ydata'   ,uv.ydata);
            set(hi,'zdata'   ,uv.zdata);
            
            ub=getappdata(hi,'store');
            ub.mode=0;
            setappdata(hi,'store',ub);
        end
        delete(findobj(ha,'tag','circle'));
        delete(findobj(ha,'tag','txlabel'));
        
        
        %         set(hi,'vertices',uv.vertices);
    else
        
        
        uv=getappdata(hi,field);
        
        %     mx=mean(uv.xdata,2);
        %     my=mean(uv.ydata,2);
        %     mz=mean(uv.zdata,2);
       
        if 0
            mx=mean(uv.xdata(:)); mx=repmat(mx,[3 1]);
            my=mean(uv.ydata(:)); my=repmat(my,[3 1]);
            mz=mean(uv.zdata(:)); mz=repmat(mz,[3 1]);
            
            
            uv.xdata   =uv.xdata-repmat(mx,[1 size(uv.xdata,2)  ] );%demean
            uv.ydata   =uv.ydata-repmat(my,[1 size(uv.xdata,2)  ] );
            uv.zdata   = uv.zdata-repmat(mz,[1 size(uv.xdata,2)  ] );
            %     uv.vertices= repmat(mean(uv.vertices,1),[size(uv.vertices,1) 1]);
        end
        % ----------
        [az el]=view;
        az=deg2rad(az); el=deg2rad(el);
        [x,y,z] = sph2cart(az,el,10);
        %  vNorm = sqrt(x^2+y^2+z^2);
        %     x2=x/vNorm;
        %     y2=y/vNorm;
        %     z2=z/vNorm;
        %   nx=  [x2 y2 z2]
        nx=[y x z];
        
        % vw=view
        % nx=vw(1:3,3)';
        % q=spm_imatrix(vw), nx= q(7:9)
        
        % pl=plotCircle3D(ce,nx,mean(sizp));
        
        
  
        
        points2=points(:,i);
%         uv.xdata=uv.xdata+points2(1);
%         uv.ydata=uv.ydata+points2(2);
%         uv.zdata=uv.zdata+points2(3);

        %     uv.vertices = uv.vertices+repmat(points2(:)',[size(uv.vertices,1) 1]);
        % -------------
        if do(i)==1
            set(hi,'xdata',uv.xdata);
            set(hi,'ydata',uv.ydata);
            set(hi,'zdata',uv.zdata);
            
            ub=getappdata(hi,'store');
            ub.mode=1;
            setappdata(hi,'store',ub);
        end
        
        
        
        
        %          %----label
        %             label=getappdata(hi,'label');
        %             te=text(txpoints(1,i),txpoints(2,i),txpoints(3,i),label);
        %             set(te,'fontsize',4,'interpreter','none');
        %             set(te,'HorizontalAlignment','center','tag','txlabel');
        
        
    end%mode
    
    %      ut=getappdata(hi,'store');
    %      disp(['ut-mode: ' num2str(ut.mode)]);
    %      disp(['radio  : ' num2str(mode)]);
end %hp

% TEXT
modi=[];
delete(findobj(ha,'tag','txlabel'));
for i=1:length(hp);
    ub=getappdata(hp(i),'store') ;
    modi(i,1)=ub.mode;
    if ub.mode==1
        %----label
        label=getappdata(hp(i),'label');
        te=text(txpoints(1,i),txpoints(2,i),txpoints(3,i),label);
        set(te,'fontsize',4,'interpreter','none');
        set(te,'HorizontalAlignment','center','tag','txlabel');
    end
end
% disp('modi');
% modi

% circle
delete(findobj(ha,'tag','circle'));
if sum(modi)>0
    pl=plot3(pointslin(1,:),pointslin(2,:),pointslin(3,:),'r-');
    set(pl,'tag','circle');
end


function RotationCallback_sting(~,~,stingview)
c=findobj(findobj(0,'tag','xvol3d'),'tag','camlight');
c = camlight(c,'headlight');    % Create light 
if stingview==1
  eval(mfilename);
%   'evals'
end


function clickedlabels(e,e2)
hf=findobj(0,'tag','xvol3d');
figure(hf);
set(gca,'XLimMode','manual');
set(gca,'YLimMode','manual');
set(gca,'ZLimMode','manual');
xlim(xlim);
ylim(ylim);
zlim(zlim);
set(gcf,'WindowButtonMotionFcn',@draglabels);

if strcmp(get(gco,'tag'), 'nodelabels2')==0; return; end
te=gco;
if ischar(get(te,'backgroundcolor'))==1  %(all(get(te,'backgroundcolor')==[1 1 0]))==0
    set(te,'backgroundcolor','y');
    drawnow;
end


function unclickedlabels(e,e2)
set(gcf,'WindowButtonMotionFcn',[]);
% set(findobj(gcf,'tag','brain'),'visible','on');

% u=get(gcf,'userdata');
% xlim(u.xlim);
% ylim(u.ylim);
% zlim(u.zlim);
set(gca,'XLimMode','auto');
set(gca,'YLimMode','auto');
set(gca,'ZLimMode','auto');

if strcmp(get(gco,'tag'), 'nodelabels2')==0; return; end
te=gco;
if ischar(get(te,'backgroundcolor'))==0  %(all(get(te,'backgroundcolor')==[1 1 0]))==0
    set(te,'backgroundcolor','none');
%     drawnow;
end
 
function draglabels(e,e2)


if strcmp(get(gco,'tag'), 'nodelabels2')==0; return; end


cp=get(gca,'currentpoint');
% cpx=cp(1,:);
cpx=mean(cp,1);
% disp('--1-');
% disp(cp);
% disp('--2-');
% get(gco,'position')

te=gco;
% get(te,'')
% colbk=get(te,'color');
% set(te,'color','m');
% if ischar(get(te,'backgroundcolor'))==1  %(all(get(te,'backgroundcolor')==[1 1 0]))==0
%     set(te,'backgroundcolor','y');
%     drawnow;
% end

clicktype=get(gcf,'selectiontype') ;%alt/normal
isnormal=0;
if strcmp(clicktype,'normal');
    isnormal=1;
end
u=get(gco,'userdata');

if isnormal==0
    % -------------whereverer
     pos0=get(te,'position');
     set(te,'position',cpx);
else % -------------%A LONG-CIRCLE
%     dis=sum(abs((u.txpoints2'-repmat(cpx,[length(u.txpoints2) 1]))),2);
%     is=min(find(dis==min(dis)));
    
    pos0=get(te,'position');
    set(te,'position',cpx);
    cpx=get(te,'position');
    dis=sum(abs((u.txpoints2'-repmat(cpx,[length(u.txpoints2) 1]))),2);
    is=min(find(dis==min(dis)));
    
    
    set(te,'position',u.txpoints2(:,is));
    u.ticpoints3 =u.ticpoints(:,is)';
    u.px         =u.txpoints2(:,is)';
    set(te,'userdata',u);
end

%%------NEEDLES
str=get(te,'string');
hl=findobj(gca,'tag','needle2');
for i=1:length(hl)
   if strcmp( getappdata(hl(i),'needlelabel') ,str);
       pos=[get(hl(i),'xdata'); get(hl(i),'ydata'); get(hl(i),'zdata')];
       if isnormal==0
           % -------------whereverer
           dis=sum(abs((u.txpoints2'-repmat(pos0,[length(u.txpoints2) 1]))),2) ;
           is=min(find(dis==min(dis)));
           df=u.txpoints2(:,is)-u.ticpoints(:,is);
            %pos(:,1)=cp(2,:)'-df;
            %        pos(:,1)=cp(2,:)';
            %             pos(:,1)=mean(cp(2,:),1)'-df;
            
            px=[cpx' pos(:,2) ];
            
            v=px(:,2)-px(:,1);
            no=norm(v);
            ndf=norm(df);
            %            gap=.0;
            uv=v/no;
            %plot(p(1,1)+(uv(1)*no*gap),p(1,2)+(uv(2)*no*gap),'go')
            %           px(:,1)=px(:,1)+(uv*no*gap );% relational
           px(:,1)= px(:,2)-(uv*(no-ndf));
             %px(:,1)= px(:,2)-(uv*(no)) ;%+(  (no/ndf)*uv );
      
            % if 0
%           %           px(:,1)=px(:,1)+(uv*no*gap);
%           px(:,1)=px(:,1)+(uv*no*gap)+(uv.*(ndf));
%           norm((uv.*(ndf)))
%           % px(:,1)=px(:,1)+(uv*10);
% end
%           
          
           
           pos=px;
         
           
       else
           % -------------%A LONG-CIRCLE
           pos(:,1)=u.ticpoints(:,is);
       end
       set(hl(i),'xdata', pos(1,:) ,'ydata', pos(2,:) ,'zdata', pos(3,:) );
       break
   end
end

% if ischar(get(te,'backgroundcolor'))==0  ;%(all(get(te,'backgroundcolor')==[1 1 0]))==1
%     set(te,'backgroundcolor','none');
% end
