

% make barplot
% o=plot_mesdsc(x, mu,sd, sv,p0)
% 
% to make barplot-legend afterwards use:
% le=plot_mesdsc('legend', l);   where l is a struct with paramters..see below
% 
% 
% _INPUT___
% x:   x-position where bar is plotted; default: [1]
% mu:  data mean value or empty, if empty ME is calculated from singlevalues (sv) 
% sd: standad deviation or empty  if empty SD is calculated from singlevalues (sv) 
% sv: vector with single values, if empty, single data are not plotted
% p0: struct with additional parameters
%     p.xs       bar-width/extend in x-direction; default: .48, usefull if 1st bar is at position 1
%     p.sdalpha  bar-transparency; default: 0.5 [0-1]
%     p.mecol    mean-LINE color ,  default: [0 0 0]
%     p.mewidth  mean-linewidth; default: 2
%     p.sfacecol        single dots facecolor, default [.7 .7 .7]
%     p.sedgecol        single dots edgecolor, default [0 0 0]
%     p.smarkersize     single dots , markersize, default: 3
%     p.sstackbottom=0; single dots, stack in background/below bars; default: [0]
%     p.sjitter=1;      single dots, jitter dots horizontally, small value.. small jitter, default: [1]
% 
% _OUTPUT____
% hp: handle of bar-patch [1×1 Patch]
% hh: handle of mean-line [1×1 Line]
% hs: handle of singleData [1×1 Line]
% 
% ========================================================================
% MAKE BAR-PLOT-LEGEND
% ========================================================================
% -CREATE LEGEND IF BARPLOT IS COMPLETELY FINISHED
%  le=plot_mesdsc('legend', l); 
%    where l is a struct with legend-specific parameters  ..all legend-specific paramters can be used
%   example paramters: 
%    'string':  used labels in legend (as cell-array)
%               if 'string' is not provided, legend with icons without textlabels is created
%    'ItemTokenSize':  size of legend-icons, default: [10 10]
%    example:
%  le=plot_mesdsc('legend',struct('string',{{'blue','red'}},'Orientation','vertical','fontname','arial','fontsize',12));
%  where: le is the legend handle 
%  
% ========================================================================
% EXAMPLES
% ========================================================================% 
% 
% EXAMPLE:  SINGLE-BAR, USING SINGLE VALUES ONLY
%     sv1=[0.64707	0.48621	0.65033	0.56647	0.47039	0.67617	0.57054	0.58982	0.58403	0.62046	0.38555	0.53189	0.63364	0.66875	0.53838	0.60498];
%     fg;
%     o=plot_mesdsc([], [],[],sv1);
% 
% EXAMPLE:  SINGLE-BAR, WITH MEAN AND SD 
%      sv1=[0.64707	0.48621	0.65033	0.56647	0.47039	0.67617	0.57054	0.58982	0.58403	0.62046	0.38555	0.53189	0.63364	0.66875	0.53838	0.60498];
%      me1=mean(sv1);
%      sd1=std(sv1);
%      fg;
%      o=plot_mesdsc([], me1,sd1,sv1);
% 
% 
% EXAMPLE:  TWO-BARS 
%     sv1=[0.64707	0.48621	0.65033	0.56647	0.47039	0.67617	0.57054	0.58982	0.58403	0.62046	0.38555	0.53189	0.63364	0.66875	0.53838	0.60498];
%     sv2=[0.49076	0.19057	0.59410	0.39741	0.21747	0.62395	0.41552	0.31199	0.23766	0.21318	0.28261	0.25095	0.40325	0.47402	0.34691	0.29935];
%     fg;
%     o=plot_mesdsc(1, [],[],sv1); hold on;
%     p.sdcol   =[1 0 0];
%     o=plot_mesdsc(2, [],[],sv2,p); hold on;
% 
% EXAMPLE: TWO-BARS, costumized 
%     sv1=[0.64707	0.48621	0.65033	0.56647	0.47039	0.67617	0.57054	0.58982	0.58403	0.62046	0.38555	0.53189	0.63364	0.66875	0.53838	0.60498];
%     sv2=[0.49076	0.19057	0.59410	0.39741	0.21747	0.62395	0.41552	0.31199	0.23766	0.21318	0.28261	0.25095	0.40325	0.47402	0.34691	0.29935];
% 
%     p=struct();
%     p.xs      =.48  ; %bar-width/extend in x-direction; default: .48
%     p.sdalpha =[.5] ; %bar-transparency [0-1]
%     p.mecol   =[0 0 0]; % mean-linecolor; default: [0 0 0]
%     p.mewidth =2;       % mean-linewidth; default: 2
%     p.sfacecol=repmat([0.7],[1 3]); %single dots facecolor, default [.7 .7 .7]
%     p.sedgecol=repmat([0],[1 3]);   %single dots edgecolor, default [0 0 0]
%     p.smarkersize=3;  %single dots , markersize, default: 3
%     p.sstackbottom=0; %single dots, stack in background/below bars; default: [0]
%     p.sjitter=1;      %single dots, jitter dots horizontally, small value.. small jitter, default: [1]
% 
%     fg;
%     p.sdcol=[0 0 1];
%     plot_mesdsc(1, [],[],sv1,p);
%     p.sdcol=[1 0 0];
%     plot_mesdsc(2, [],[],sv2,p);
% 
% EXAMPLE: MULTIPLE-BARS, costumized
%     col=cbrewer('seq','YlOrRd', 9);
%     d=cellfun(@(a) {[  rand(a,1)+rand(1)*2  ]}, num2cell( randperm(50)));
%     d=d(1:9);
%     
%     p=struct();
%     p.xs      =.48  ; %bar-width/extend in x-direction; default: .48
%     p.sdalpha =[.5] ; %bar-transparency [0-1]
%     p.mecol   =[0 0 0]; % mean-linecolor; default: [0 0 0]
%     p.mewidth =2;       % mean-linewidth; default: 2
%     p.sfacecol=repmat([0.7],[1 3]); %single dots facecolor, default [.7 .7 .7]
%     p.sedgecol=repmat([0],[1 3]);   %single dots edgecolor, default [0 0 0]
%     p.smarkersize=3;  %single dots , markersize, default: 3
%     p.sstackbottom=0; %single dots, stack in background/below bars; default: [0]
%     p.sjitter=1;      %single dots, jitter dots horizontally, small value.. small jitter, default: [1]
%        
%     fg; hold on
%     for i=1:length(d)
%         p.sdcol=col(i,:);
%         plot_mesdsc(i, [],[],d{i},p);
%     end
%% ===============================================
% EXAMPLE: MAKE BARPLOT AND LEGEND ANS SAVE BOTH AS PNG-FILES
%     sv1=[0.64707	0.48621	0.65033	0.56647	0.47039	0.67617	0.57054	0.58982	0.58403	0.62046	0.38555	0.53189	0.63364	0.66875	0.53838	0.60498];
%     sv2=[0.49076	0.19057	0.59410	0.39741	0.21747	0.62395	0.41552	0.31199	0.23766	0.21318	0.28261	0.25095	0.40325	0.47402	0.34691	0.29935];
% 
%     p=struct();
%     p.xs      =.48  ; %bar-width/extend in x-direction; default: .48
%     p.sdalpha =[.5] ; %bar-transparency [0-1]
%     p.mecol   =[0 0 0]; % mean-linecolor; default: [0 0 0]
%     p.mewidth =2;       % mean-linewidth; default: 2
%     p.sfacecol=repmat([0.7],[1 3]); %single dots facecolor, default [.7 .7 .7]
%     p.sedgecol=repmat([0],[1 3]);   %single dots edgecolor, default [0 0 0]
%     p.smarkersize=3;  %single dots , markersize, default: 3
%     p.sstackbottom=0; %single dots, stack in background/below bars; default: [0]
%     p.sjitter=1;      %single dots, jitter dots horizontally, small value.. small jitter, default: [1]
% 
%     fg;
%     p.sdcol=[0 0 1];
%     plot_mesdsc(1, [],[],sv1,p);
%     p.sdcol=[1 0 0];
%     plot_mesdsc(2, [],[],sv2,p);
% 
%     set(gcf,'Units','centimeters');
%     set(gcf,'Position',[5 5 4 8]);   % [left bottom width height]
%     set(gca,'fontname','arial','fontsize',12);
%     set(gca,'xticklabels',[]);
%     xlim([0.45 2.45])
% 
%     % SAVE AS PNG, WITH 600dpi, DO NOT CROP
%     savePNG('test.png','saveres',600,'crop',0)
% 
%     % MAKE LEGEND
%     le=plot_mesdsc('legend',struct('string',{{'blue','red'}},'Orientation','vertical','fontname','arial','fontsize',12));
%     savePNG('test_legend.png','saveres',600,'crop',0)% SAVE legend AS PNG, WITH 600dpi, DO NOT CROP




function o=plot_mesdsc(x, mu,sd, sv,p0)
    
    

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

%% ====parameter-legend ====================================

if ischar(x) && strcmp(x,'legend')
    
    
    p.labels={};
    p.ItemTokenSize=[10 10];
    
    
    
    
    if nargin==2
        warning off;
        p= catstruct(p,mu);
    end
    
   o=makelegend(p) ;
   return
end



%% ====[parameter-plot]===========================================
p.xs      =0.48;%1 ; %extend in x-direction
p.sdcol   =[0 0 1];
p.sdalpha =[0.3];
p.mecol   =[0 0 0];
p.mewidth =3;
p.sfacecol=repmat([0.7],[1 3]);
p.sedgecol=repmat([0.7],[1 3]);
p.smarkersize=6;
p.sstackbottom=1;
p.sjitter=1;%10;

% ==legend=============================================




if nargin==5
    warning off;
    p= catstruct(p,p0); 
end







if  isempty(x); x=1; end
if  isempty(mu); mu= mean(sv(:)); end
if  isempty(sd); sd= std(sv(:));  end



%% ===============================================
%  x=1;
%  mu=w.me_g1(1)
%  sd=w.sd_g1(1)


xs=p.xs;
u=mu+sd;
l=mu-sd;
le=x-xs;
ri=x+xs;

%% ===========[SD-path]====================================

% fg;

hold on
hp=patch([x-xs, x+xs, x+xs, x-xs],...
    [l,l,u,u], 0);
set(hp,'edgecolor',p.sdcol*0.8,'facecolor',p.sdcol);
set(hp,'facealpha',p.sdalpha);
%% ===========[ME-LINE]====================================
hh=plot([le ri ],[mu mu ],'color', p.mecol, 'linewidth',p.mewidth );
drawnow;
o.hp=hp;
o.hh=hh;
%% ===========[single data]====================================

if exist('sv')==1
    Y=sv;
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
    X=X+x;
    
    hs=plot(X,Y,'o','MarkerFaceColor',p.sfacecol,'MarkerEdgeColor',p.sedgecol,...
        'markersize',p.smarkersize);
    if p.sstackbottom==1;
        uistack(hs,'bottom');
    end
    
    o.hs=hs;
end



function le=makelegend(p) 

pos=get(gca,'position');
set(gca,'position',[ -1 pos(2:end)] );

l=flip(findobj(gca,'type','patch'));   %LABELS
try     lab=p.labels(1:length(l));
catch   lab=repmat({' '},[1 length(l) ]);  %EMPTY LABELS IF LABELS NOT GIVEN
end

if isfield(p,'string') && length(p.string)~=length(l)
   p.string=lab 
end


le=legend(l,lab,'box','off');
posl=get(le,'position');
% set(le,'position', [  pos(1:2) posl(3:4)])
set(le,'position', [  0.2 1-posl(4)-.1 posl(3:4)]);
le.ItemTokenSize=p.ItemTokenSize; %[10 10];
%% ===============================================
p2=rmfield(p,{'labels','ItemTokenSize' });
if ~isempty(fieldnames(p2))
    %set(le, p2);
    fn = fieldnames(p2);
    for k = 1:numel(fn)
        if isprop(le,fn{k})
            %le.(fn{k}) = p2.(fn{k});
            set(le,fn{k},p2.(fn{k}));
        end
    end
    
end


