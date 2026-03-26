

function o=plot_mesdsc(xp, mu,sd, val,p0)

if 0
   %% ===============================================
   
    p=struct();
    
    p.xs      =0.5 ; %extend in x-direction
    p.sdcol   =[0 0 1];
    p.sdalpha =[0.3];
    p.mecol   =[0 0 0];
    p.mewidth =2;
    p.sfacecol=repmat([0.7],[1 3]);
    p.sedgecol=repmat([0.7],[1 3]);
    p.smarkersize=6;
    p.sstackbottom=1;
    p.sjitter=5;
    
    fg;
    o1=plot_mesdsc(1,w.me_g1(1),w.sd_g1(1), w.s_g1(:,1),p  ) 
     p.sdcol   =repmat([0.5],[1 3]);
    o2=plot_mesdsc(2,w.me_g2(1),w.sd_g2(1), w.s_g2(:,1),p  ) 
    
    xlim([.4 2.6])
    %% ===============================================
    
end

%% ===============================================
p.xs      =1 ; %extend in x-direction
p.sdcol   =[0 0 1];
p.sdalpha =[0.3];
p.mecol   =[0 0 1];
p.mewidth =3;
p.sfacecol=repmat([0.7],[1 3]);
p.sedgecol=repmat([0.7],[1 3]);
p.smarkersize=6;
p.sstackbottom=1;
p.sjitter=10;
%% ===============================================

if nargin==5
    warning off;
    p= catstruct(p,p0); 
end



%% ===============================================
%  xp=1;
%  mu=w.me_g1(1)
%  sd=w.sd_g1(1)


xs=p.xs;
u=mu+sd;
l=mu-sd;
le=xp-xs;
ri=xp+xs;

%% ===========[SD-path]====================================

% fg;

hold on
hp=patch([xp-xs, xp+xs, xp+xs, xp-xs],...
    [l,l,u,u], 0);
set(hp,'edgecolor',p.sdcol*0.8,'facecolor',p.sdcol);
set(hp,'facealpha',p.sdalpha);
%% ===========[ME-LINE]====================================
hh=plot([le ri ],[mu mu ],'color', p.mecol, 'linewidth',p.mewidth );
drawnow;
%% ===========[single data]====================================



Y=val;
X=zeros(size(Y));


[counts,~,bins] = histcounts(Y,10);
inds = find(counts~=0);
counts = counts(inds);

Xr = X;
for jj=1:length(inds)
    tWidth = p.sjitter * (1-exp(-0.1 * (counts(jj)-1)));
    xpoints = linspace(-tWidth*0.8, tWidth*0.8, counts(jj));
    Xr(bins==inds(jj)) = xpoints;
end
X = X+Xr;
X=X+xp;

hs=plot(X,Y,'o','MarkerFaceColor',p.sfacecol,'MarkerEdgeColor',p.sedgecol,...
    'markersize',p.smarkersize);
if p.sstackbottom==1;
    uistack(hs,'bottom');
end
o.hp=hp;
o.hh=hh;
o.hs=hs;

