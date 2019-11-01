

% show3d('createfig'); %createfigure (ha to be done only once)

function show3d(varargin)
warning off

list={'cmap'           'jet'          'colormap (jet,hot..)'
    'cmaplimits'      'auto'          'cmap limits (auto or [min max])'
    'showlabels'       'on'           'show labels (on,off)'
    'labelfontsize'    '6'            'labels-fontsize (4:10)'
    'shownodes'        'on'           'show nodes (on,off)'
    'nodesized'        '5'            'node size (1:10)'
    'nodestransparency' '1'           'node transparency (0-1)'
    
    'nodecolor'        '[1 1 0]'      'node color [r,g,b]'
    'showconnections'  'on'           'show connections (on,off)'
    'connectionthickness'   '1.5'     'connection thickness (.5-10)'
    'connectiontransparency' '1'      'connection transparency (0-1)'
    'showbrain'        'on'           'show brain (on,off)'
    'braintransparency' '0.05'        'brain transparency (0-1)'
    'showRegions'      'off'          'show brain regions (on,off)'
    };


% pa='O:\myTools\connectStat\atlas';
% addpath(pa);
pa=fileparts(which(mfilename));
% disp(['#todo : modify  path']);


if nargin>0
    if strcmp(varargin{1},'replot')
        plots;
        
        return
    end
    if strcmp(varargin{1},'createfig')
        createfig
        return
    end
end


ps.figcreate=0;
if ps.figcreate==1
    
    
    
    %     %
    %     % wAVGT2.nii                w__DTI23_mskRight.nii
    %     % w__DTI23_atlas.nii        x_t2.nii
    %     % dti_atlas_23_highRes.nii  w__DTI23_mskLeft.nii
    %
    %
    %     [ha a]=rgetnii(fullfile(pa,'wAVGT2.nii'));
    %     [hb b]=rgetnii(fullfile(pa,'w__DTI23_atlas.nii'));
    %     [hc c]=rgetnii(fullfile(pa,'w__DTI23_mskLeft.nii'));
    %     [hd d]=rgetnii(fullfile(pa,'w__DTI23_mskRight.nii'));
    %
    %
    %     % ds=load('mri.mat')
    %     % D = squeeze(D);
    %     d1=a;
    %     [x,y,z,d2] = reducevolume(d1,[1,1,1]);
    %     d2 = smooth3(d2);
    %     delete(findobj(0,'tag','fcon'));
    %
    %     %———————————————————————————————————————————————
    %     %%   figure
    %     %———————————————————————————————————————————————
    %     fg;
    %     set(gcf,'tag','fcon','units','norm');
    %     va=50
    %     p1 = patch(isosurface(x,y,z,d2,va),...
    %         'FaceColor','red','EdgeColor','none');
    %     set(p1,'tag','brain')
    %     % isonormals(x,y,z,d2,p1)
    %     % p2 = patch(isocaps(x,y,z,d2,va),...
    %     %     'FaceColor','interp','EdgeColor','none');
    %
    %     view(3);
    %     axis tight;
    %     daspect([1,1,.4]);
    %     colormap(gray(100));
    %     camlight;
    %     lighting gouraud;
    %     set(p1,'FaceAlpha',.05);
    %     hold on;
    %
    %     uni=[unique(b(:))]; uni(uni==0)=[];
    %     unis=[[uni.*0.+1 uni];[uni.*0.+2 uni]];
    %
    %     delete(findobj(gcf,'tag','region'));
    %     for i=1:size(unis,1)
    %         disp(i);
    %         if unis(i,1)==1
    %             msk=c; tag='L';
    %         else
    %             msk=d; tag='R';
    %         end
    %
    %         f=single((b==unis(i,2)).*msk);
    %         if sum(f(:))>30000
    %             [x,y,z,d2] = reducevolume(f,[5,5,5]);
    %         else
    %             [x,y,z,d2] = reducevolume(f,[1 1 1 ]);
    %         end
    %         d2 = smooth3(d2);
    %
    %         px = patch(isosurface(x,y,z,d2,.5),...
    %             'FaceColor','blue','EdgeColor','none');
    %         set(px,'tag','region')
    %         set(px,'facealpha',.1,'userdata',unis(i,:));
    %         set(px,'facecolor',rand(1,3));
    %
    %         %BLOBS
    %         rg=[x(:) y(:) z(:) d2(:)];
    %         xo=rg(find(rg(:,4)>.1),1:3);
    %         xo=mean(xo);
    %         ps=scatter3sph(xo(1),xo(2),xo(3),'size',5,'color',[0 1 0],'trans',1);
    %         set(ps,'tag','blob','userdata',unis(i,:));
    %         setappdata(ps,'location',[xo(1),xo(2),xo(3)]);
    %
    %
    %     end
    %
    %     % return
    %     axis vis3d;
    %     view(3);
    %     axis tight;
    %     daspect([1,1,1]);
    %     colormap(gray(100));
    %     camlight
    %     lighting gouraud
    %     set(p1,'FaceAlpha',.1);
    %
    %
    %     set(findobj(gcf,'tag','region'),'facealpha',.2)
    %     material metal
    %
    %
    %     % daspect([ratios(1), ratios(2), ratios(3)]);
    %     light('Position',[1 1 1],'Style','infinit','Color',[1 1 1]);
    %     lighting gouraud;
    %     % view(30,30)
    %
    %     %———————————————————————————————————————————————
    %     %%
    %     %———————————————————————————————————————————————
    %     %px='O:\myTools\connectStat'
    %     % filab=fullfile(px,'conmats','dti_atlas_46_dsiStudioLabelFile(1).txt');
    %     filab=fullfile(pa,'dti_atlas_labels.txt');
    %     labx=preadfile(filab);
    %     labx=labx.all;
    %     num=str2num(char(regexprep(labx,' \D.*','')));
    %     lab=regexprep(labx,'\d.* ','');
    %
    %
    %     set(gca,'tag','ax1');
    %
    %     uw.lab =lab;
    %     uw.unis=unis;
    %     set(gcf,'userdata',uw)
    %     savefig(fullfile(pa,'dtibrain.fig'));
    %     return
else
    delete(findobj(gcf,'tag','fcon'));
    openfig(fullfile(pa,'dtibrain.fig'));
    set(gcf,'color' ,[1.0000    0.9686    0.9216]);
    uw=get(gcf,'userdata');
    lab=uw.lab;
    
    %## bug LEFT-RIGHThemispheres errornuously assigned
%     ihalf=size(uw.unis,1)/2;
%     uw.unis=[uw.unis(ihalf+1:end,:) ; uw.unis(1:ihalf,:)];
    
    %
    
    %     p.cmap='hot';
    
    
    %     list={'cmap'           'hot'          'colormap'
    %         'cmaplimits'      'auto'         'cmap limits'
    %         'showlabels'       'on'          'show labels'
    %         'labelfontsize'    '6'          'labels-fontsize'
    %         'shownodes'        'on'          'show nodes'
    %         'nodesized'        '5'          'node size'
    %         'nodecolor'        '[1 1 0]'    'node color'
    %         'showbrain'        'on'        'show brain'
    %         'showconnections'  'on'       'show connections'
    %         'connectiothickness'   '2'       'connection thickness'
    %         } % fieldname value displayname
    p=cell2struct(list(:,2)',list(:,1),2);
    uw.p=p;
    uw.plist=list;
    
    
    hu=uicontrol('style','text','units','norm');
    set(hu,'position',[ .8 .95 .2 .03],'string','Contrast','fontsize',6,'backgroundcolor','w');
    
    hu=uicontrol('style','listbox','units','norm');
    set(hu,'position',[ .8 .85 .2 .1],'string',{'erde:eee'; 'mouse:errr'},'callback',@lbcall,...
        'tooltipstring',' select a contrasts to plot');
    
    us=get(findobj(0,'tag','dtistat'),'userdata');
    set(hu,'string',{us.pw(:).str}');
    uw.r   =us.pw(1);
    uw.rall=us.pw;
    
    % properties
    h=uicontrol('style','pushbutton','units','norm');
    set(h,'position',[ .9 .55 .09 .05],'string','properties','callback',@showParameter,'fontsize',6,...
        'tooltipstring','show properties','backgroundcolor','w')
      % properties
    h=uicontrol('style','pushbutton','units','norm');
    set(h,'position',[ .9 .5  .09 .05],'string','BGcolor','callback',{@setBGcol,'pop'},'fontsize',6,...
        'tooltipstring','set background color','backgroundcolor','w')
    
    %PANEL
    hsp = uipanel('Title','Threshold','FontSize',7,'units','norm',...
        'Position',[.9 .75 .1 .1],'backgroundcolor','w');
    
    %FDR
    h1=uicontrol('parent',hsp, 'style','radio','units','norm','string','FDR','fontsize',7,...
        'backgroundcolor','w');
    set(h1,'position',[0     0.5  1 .5 ],'callback',{@thresh},'tag','threshFDR','value',1,...
        'tooltipstring',' type of threshold: FDR-correction (use q-level from DTI-stat)');
    
    %Pvalue
    h2=uicontrol('parent',hsp, 'style','radio','units','norm','string','p<','fontsize',7,...
        'backgroundcolor','w','tooltipstring',' type of threshold: pvalues below input value');
    set(h2,'position',[0     0  1 .5 ],'callback',{@thresh},'tag','threshP');
    
    %pvalue-value
    h=uicontrol('parent',hsp, 'style','edit','units','norm','string',num2str(0.05),...
        'HorizontalAlignment','left','backgroundcolor','w','fontsize',7,'tag','pvalue','tooltipstring','threshold');
    set(h,'position',[0.52 0.0 .5 .5 ]);
    
    uw.hthresh=[h1 h2];
    
    set(gcf,'userdata',uw);
end


plots();
setBGcol([],[],'fromBG');




% drawnow;
% paramsgui

function setBGcol(e,e2,pop)

hf=findobj(0,'tag','fcon');
if strcmp(pop,'pop')
    col=uisetcolor;
    set(hf,'color',col);
else
    col=get(hf,'color') ;
end
set(findobj(hf,'type','uicontrol'),'backgroundcolor',col);
set(findobj(hf,'type','uipanel'),'backgroundcolor',col);

hp=findobj(0,'tag','params');
set(hp,'color',col);
set(findobj(hp,'type','uicontrol'),'backgroundcolor',col);
set(findobj(hp,'type','uipanel'),'backgroundcolor',col);

ut=findobj(hp,'type','uitable');
tabcol=get(ut,'BackgroundColor'); tabcol(1,:)=col;
set(ut,'BackgroundColor',tabcol);

function thresh(e,e2)

us=get(gcf,'userdata');
set(setdiff(us.hthresh,e),'value',0);

function lbcall(e,e2)
va=get(e,'value');
li=get(e,'string');
uw=get(gcf,'userdata');
uw.r =uw.rall(va);
set(gcf,'userdata',uw);
plots();

function createfig
%
% wAVGT2.nii                w__DTI23_mskRight.nii
% w__DTI23_atlas.nii        x_t2.nii
% dti_atlas_23_highRes.nii  w__DTI23_mskLeft.nii

disp('create figure');
pa=fileparts(which(mfilename));

[ha a]=rgetnii(fullfile(pa,'wAVGT2.nii'));
[hb b]=rgetnii(fullfile(pa,'w__DTI23_atlas.nii'));
[hc c]=rgetnii(fullfile(pa,'w__DTI23_mskLeft.nii'));
[hd d]=rgetnii(fullfile(pa,'w__DTI23_mskRight.nii'));


% ds=load('mri.mat')
% D = squeeze(D);
d1=a;
[x,y,z,d2] = reducevolume(d1,[1,1,1]);
d2 = smooth3(d2);
delete(findobj(0,'tag','fcon'));

%———————————————————————————————————————————————
%%   figure
%———————————————————————————————————————————————
fg;
set(gcf,'tag','fcon','units','norm');
va=50
p1 = patch(isosurface(x,y,z,d2,va),...
    'FaceColor','red','EdgeColor','none');
set(p1,'tag','brain')
% isonormals(x,y,z,d2,p1)
% p2 = patch(isocaps(x,y,z,d2,va),...
%     'FaceColor','interp','EdgeColor','none');

view(3);
axis tight;
daspect([1,1,.4]);
colormap(gray(100));
camlight;
lighting gouraud;
set(p1,'FaceAlpha',.05);
hold on;

uni=[unique(b(:))]; uni(uni==0)=[];
unis=[[uni.*0.+1 uni];[uni.*0.+2 uni]];

delete(findobj(gcf,'tag','region'));
for i=1:size(unis,1)
    disp(i);
    if unis(i,1)==1
        msk=c; tag='L';
    else
        msk=d; tag='R';
    end
    
    f=single((b==unis(i,2)).*msk);
    if sum(f(:))>30000
        [x,y,z,d2] = reducevolume(f,[5,5,5]);
    else
        [x,y,z,d2] = reducevolume(f,[1 1 1 ]);
    end
    d2 = smooth3(d2);
    
    px = patch(isosurface(x,y,z,d2,.5),...
        'FaceColor','blue','EdgeColor','none');
    set(px,'tag','region')
    set(px,'facealpha',.1,'userdata',unis(i,:));
    set(px,'facecolor',rand(1,3));
    
    %BLOBS
    rg=[x(:) y(:) z(:) d2(:)];
    xo=rg(find(rg(:,4)>.1),1:3);
    xo=mean(xo);
    ps=scatter3sph(xo(1),xo(2),xo(3),'size',5,'color',[0 1 0],'trans',1);
    set(ps,'tag','blob','userdata',unis(i,:));
    setappdata(ps,'location',[xo(1),xo(2),xo(3)]);
    
    
end

% return
axis vis3d;
view(3);
axis tight;
daspect([1,1,1]);
colormap(gray(100));
camlight
lighting gouraud
set(p1,'FaceAlpha',.1);


set(findobj(gcf,'tag','region'),'facealpha',.2)
material metal


% daspect([ratios(1), ratios(2), ratios(3)]);
light('Position',[1 1 1],'Style','infinit','Color',[1 1 1]);
lighting gouraud;
% view(30,30)

%———————————————————————————————————————————————
%%
%———————————————————————————————————————————————
%px='O:\myTools\connectStat'
% filab=fullfile(px,'conmats','dti_atlas_46_dsiStudioLabelFile(1).txt');
filab=fullfile(pa,'dti_atlas_labels.txt');
labx=preadfile(filab);
labx=labx.all;
num=str2num(char(regexprep(labx,' \D.*','')));
lab=regexprep(labx,'\d.* ','');


set(gca,'tag','ax1');

uw.lab =lab;
uw.unis=unis;
set(gcf,'userdata',uw)
savefig(fullfile(pa,'dtibrain.fig'));
return


function plots()
% '##'

ha=findobj(0,'tag','fcon'); ha= ha(1);
figure(ha);
uw=get(gcf,'userdata');
lab=uw.lab;
%———————————————————————————————————————————————
%%   condition
%———————————————————————————————————————————————
% us=get(findobj(0,'tag','dtistat'),'userdata');
% r=us.pw(1);
r=uw.r;

axes(findobj(gcf,'tag','ax1'));
rotate3d off;

threshID=find(cell2mat(get(uw.hthresh,'value')));

if threshID==1 % FDR
    iuse   = find(r.fdr==1);        % FDR
    threshmeth='{FDR}';
    
%     iuse=35
    
    
elseif threshID==2 % PVALUE % P-VALUE BELOW ..
    pval=str2num(get(findobj(gcf,'tag','pvalue'),'string'));
    iuse   = find(r.tb(:,regexpi2(r.tbhead,'^p$|pval|pvalue'))<pval)  ;
    threshmeth=['{p<' num2str(pval) '}'];
    
end
labw   = r.lab(iuse);
val    = r.tb(iuse,2:3);

%-------clean up
delete(findobj(gcf,'tag','light2'));
hlig=light;
lightangle(hlig,-144,2)
lighting gouraud;
set(hlig,'tag','light2')

set(findobj(gcf,'tag','brain'),'facealpha',.05,'facecolor',[.5 .5 .5])
% set(gcf,'color','w');set(gca,'color','w')
material metal


% delete(findobj(gcf,'tag','conect'));

set(findobj(gcf,'tag','region'),'visible','off');
set(findobj(gcf,'tag','blob'),'visible','off');
set(findobj(gcf,'tag','conect'),'visible','off');
set(findobj(gcf,'tag','label'),'visible','off');

h1=findobj(gcf,'tag','region');
us1=cell2mat(get(h1,'userdata'));
h2=findobj(gcf,'tag','blob');
us2=cell2mat(get(h2,'userdata'));

axis off
set(gca,'position',[-.1 -.1 1.2 1.2]);

rotate3d on;

h=(findobj(gcf,'tag','title'));
if isempty(h)
    h=uicontrol('style','text','units','norm','tag','title');
    set(h,'position',[0 .95 .8,.05],'backgroundcolor','w','fontsize',7,'fontweight','bold');
end
msg=[ '#connections: ' num2str(length(iuse))  ' ' threshmeth];
set(h,'string',msg,'foregroundcolor',[0.8235    0.5961    0.0510]);

if isempty(iuse); return; end
%-------------



not={};
for i=1:size(labw,1);
    dum=labw{i};
    is=regexpi(dum,'--');
    dum2={dum(1:is-1) dum(is+2:end) };
    not(end+1,:) = [dum2 val(i,1) val(i,2)  [regexpi2(lab,['^' dum2{1} '$'])  regexpi2(lab,['^' dum2{2} '$'])] ];
end



if 0
    not=...
        {'motor_cortex_R'               'corpus_callosum_R'             9.348e-04  -2.726e+00  [45 ,25]
        'sensory_motor_cortex_R'         'superior_colliculus_R'         3.373e-03   3.287e+00  [46 ,32]
        'olfactory_bulb_R'               'superior_colliculus_R'         3.084e-03   3.659e+00  [39 ,32]
        'sensory_motor_cortex_R'         'motor_cortex_R'                2.821e-04   3.869e+00  [46 ,45]
        'internal_capsule_R'             'superior_colliculus_R'         1.769e-03   4.059e+00  [29 ,32]
        'corpus_callosum_R'              'reticular_nucleus_L'           1.227e-03   4.166e+00  [25 ,18]
        'thalamus_R'                     'superior_colliculus_R'         4.717e-03   4.546e+00  [30 ,32]
        'sensory_motor_cortex_L'         'motor_cortex_L'                1.443e-05   4.962e+00  [23 ,22]
        'superior_colliculus_L'          'globus_pallidus_L'             2.056e-05   5.255e+00  [ 9 , 5]}
end

if 0
    %    [cre/tg][sham] vs [wt/tg][sham] ### CONNECTIVITY ###
    % ===============================================================================================
    % LABEL1                             LABEL2                       PVALUE     STAT        matINDEX
    % ===============================================================================================
    not=...
        {'corpus_callosum_R'              'motor_cortex_R'                4.939e-03  -3.269e+00  [25 ,45]
        'hypothalamus_L'                 'anterior_commisure_R'          1.613e-03   2.471e+00  [11 ,27]
        'superior_colliculus_R'          'internal_capsule_R'            2.148e-03   3.066e+00  [32 ,29]
        'periaqueductal_gray_R'          'globus_pallidus_R'             1.507e-03   3.088e+00  [36 ,28]
        'internal_capsule_R'             'internal_capsule_L'            1.471e-03   3.332e+00  [29 , 6]
        'corpus_callosum_L'              'anterior_commisure_L'          2.531e-03   3.686e+00  [ 2 , 4]
        'reticular_nucleus_R'            'caudate_putamen_R'             9.111e-06   3.815e+00  [41 ,26]
        'corpus_callosum_R'              'reticular_nucleus_R'           2.000e-03   4.474e+00  [25 ,41]
        'sensory_motor_cortex_L'         'motor_cortex_L'                3.303e-03   4.544e+00  [23 ,22]
        'sensory_motor_cortex_R'         'motor_cortex_R'                1.501e-03   4.701e+00  [46 ,45]
        'olfactory_bulb_R'               'corpus_callosum_L'             9.999e-04   5.705e+00  [39 , 2]}
end
if 0
    %    [cre/tg][mcao] vs [wt/tg][mcao] ### CONNECTIVITY ###
    % ===============================================================================================
    % LABEL1                             LABEL2                       PVALUE     STAT        matINDEX
    % ===============================================================================================
    not=...
        {
        'nucleus_accumbens_R'            'cortex_R'                      1.585e-03  -2.850e+00  [42 ,37]
        'caudate_putamen_R'              'anterior_commisure_L'          1.894e-03   3.157e+00  [26 , 4]
        'periaqueductal_gray_R'          'cortex_R'                      3.469e-03   3.234e+00  [36 ,37]
        'cortex_R'                       'cerebellum_R'                  3.028e-04   3.963e+00  [37 ,31] }
    
    
end

p=uw.p; %PARAMETER

T=cell2mat(not(:,4));
Trad=abs(T);
Trad=Trad./max(Trad);
%fg,imagesc(T); caxis([-max(abs(T))  max(abs(T))]*1.2); colormap(jet);colorbar
% clim=[([-max(abs(T))  max(abs(T))]*.8)'];
% clim=[([ min( (T))  max( (T))]*.8)'];

if strcmp(p.cmaplimits,'auto')
    if length(unique(T))==1;
        clim=[T(1)-1 T(1)+1]'
    else
        clim=[([ min( (T))  max( (T))])'];
    end
else
    clim=str2num(p.cmaplimits)';
end
clim=[[T;clim]];
% cmap=jet;
try
    if strcmp(p.cmap(1),'-')
        eval(['cmap=' p.cmap(2:end) ';']);
        cmap=flipud(cmap);
    else
        eval(['cmap=' p.cmap ';']);
    end
catch
    eval(['cmap=' p.cmap(2:end) ';']);
    cmap=flipud(cmap);
end

ixclim=clim-min(clim); ixclim=ixclim./max(ixclim);
idcol=round(((size(cmap,1)-1).*ixclim)+1);

ids=[];
for i=1:size(not,1)
    ids(i,:)=[ (find(strcmp(lab,not(i,1))));
        (find(strcmp(lab,not(i,2))))];
end


%———————————————————————————————————————————————
%%   node: change size
%———————————————————————————————————————————————
blo=findobj(gcf,'tag','blob');
if str2num(p.nodesized)~=5
    for i=1:size(blo)
        usd=get(blo(i),'userdata');
        xo=getappdata(blo(i),'location');
        delete(blo(i));
        ps=scatter3sph(xo(1),xo(2),xo(3),'size',str2num(p.nodesized),'color',[0 1 0],'trans',1);
        set(ps,'tag','blob','userdata',usd);
        setappdata(ps,'location',[xo(1),xo(2),xo(3)]);
        set(ps,'FaceLighting','gouraud');
    end
    
end



%  ps=scatter3sph(xo(1),xo(2),xo(3),'size',5,'color',[0 1 0],'trans',1);
%         set(ps,'tag','blob','userdata',unis(i,:));
%         setappdata(ps,'location',[xo(1),xo(2),xo(3)]);

%———————————————————————————————————————————————
%%   draw LINES
%———————————————————————————————————————————————

% % % % % % % delete(findobj(gcf,'tag','conect'));
% % % % % % %
% % % % % % % set(findobj(gcf,'tag','region'),'visible','off');
% % % % % % % set(findobj(gcf,'tag','blob'),'visible','off');
% % % % % % %
% % % % % % % h1=findobj(gcf,'tag','region');
% % % % % % % us1=cell2mat(get(h1,'userdata'));
% % % % % % % h2=findobj(gcf,'tag','blob');
% % % % % % % us2=cell2mat(get(h2,'userdata'));
uw.unis(:,3)=uw.unis(:,1).*max(uw.unis(:,2))-max(uw.unis(:,2))+uw.unis(:,2);





h2=findobj(gcf,'tag','blob');
set(h2,'visible','off');
set(findobj(gcf,'tag','conect'),'visible','off');
set(findobj(gcf,'tag','label'),'visible','off');

% #######################################################
% ## interim
% ids =
%     44    30

if 0
    % for i=1:length(uw.lab)
    
    this=regexpi2(uw.lab,'^thalamus_R');
    uw.lab(this)
    
    
    po=uw.unis(this,1:2);
    h1po=cell2mat(get(h1,'userdata'));
    hix =find(h1po(:,1)==po(1) & h1po(:,2)==po(2) );
    set(h1(hix),'visible','on');
    drawnow;
    pause;
    set(h1(hix),'visible','off')
    % end
end


% #######################################################

h1po=cell2mat(get(h1,'userdata'));
h2po=cell2mat(get(h2,'userdata'));




txt={};
for i=1:size(ids,1)
    if 1
        po=uw.unis(ids(i, [1] ),  1:2);
        ix =find(h1po(:,1)==po(1) & h1po(:,2)==po(2) );
        
        if strcmp(uw.p.showRegions,'on')
            set(h1(ix),'visible','on');
        end
        setappdata(h1(ix),'used',1);
        
        po=uw.unis(ids(i, [2] ),  1:2);
        ix =find(h1po(:,1)==po(1) & h1po(:,2)==po(2) );
        if strcmp(uw.p.showRegions,'on')
            set(h1(ix),'visible','on');
        end
        setappdata(h1(ix),'used',1);
        
        
        %         se=uw.unis(find(uw.unis(:,3)==ids(i,1)),:);
        %         ix=find(us1(:,1)==se(1) & us1(:,2)==se(2) );
        %         set(h1(ix),'visible','off');
        %         setappdata(h1(ix),'used',1);
        %
        %         se=uw.unis(find(uw.unis(:,3)==ids(i,2)),:);
        %         ix=find(us1(:,1)==se(1) & us1(:,2)==se(2) );
        %         set(h1(ix),'visible','off');
        %         setappdata(h1(ix),'used',1);
    end
    
    %% SPHERE-1
    %     se=uw.unis(find(uw.unis(:,3)==ids(i,1)),:);
    %     ix=find(us2(:,1)==se(1) & us2(:,2)==se(2) );
    
    po=uw.unis(ids(i, [1] ),  1:2);
    ix =find(h2po(:,1)==po(1) & h2po(:,2)==po(2) );
    
    if strcmp(p.shownodes,'on')
        set(        h2(ix)  ,'visible','on');
        setappdata( h2(ix)  ,'used',1);
    end
    li(:,1)=[...
        mean(reshape( get(h2(ix),'xdata') ,[prod(size(get(h2(ix),'xdata'))) 1]))
        mean(reshape( get(h2(ix),'ydata') ,[prod(size(get(h2(ix),'ydata'))) 1]))
        mean(reshape( get(h2(ix),'zdata') ,[prod(size(get(h2(ix),'zdata'))) 1]))]';
    
    %% SPHERE-2
    %     se=uw.unis(find(uw.unis(:,3)==ids(i,2)),:);
    %     ix=find(us2(:,1)==se(1) & us2(:,2)==se(2) );
    
    po=uw.unis(ids(i, [2] ),  1:2);
    ix =find(h2po(:,1)==po(1) & h2po(:,2)==po(2) );
    if strcmp(p.shownodes,'on')
        set(h2(ix),'visible','on');
        setappdata(h2(ix),'used',1);
    end
    li(:,2)=[...
        mean(reshape( get(h2(ix),'xdata') ,[prod(size(get(h2(ix),'xdata'))) 1]))
        mean(reshape( get(h2(ix),'ydata') ,[prod(size(get(h2(ix),'ydata'))) 1]))
        mean(reshape( get(h2(ix),'zdata') ,[prod(size(get(h2(ix),'zdata'))) 1]))]';
    
    
    if 1
        [X, Y, Z] = cylinder2P( str2num(p.connectionthickness)  , 50,li(:,1)',li(:,2)');
        %         [X, Y, Z] = cylinder2P( Trad(i)*str2num(p.connectionthickness)  , 50,li(:,1)',li(:,2)');
        hl=surf(X, Y, Z);
        set(hl,'FaceColor','r','edgecolor','none','tag','conect');
        set(hl,'facecolor', cmap(idcol(i),:) );
        setappdata(hl,'used',1);
    end
    %     if 0
    %         hl=plot3(li(1,:),li(2,:),li(3,:),'b');
    %         set(hl,'color',cmap(idcol(i),:),'tag','conect','linewidth',Trad(i))
    %         setappdata(hl,'used',1);
    %     end
    li=double(li);
    txt(end+1,:)={li(:,1)' not{i,1}};
    txt(end+1,:)={li(:,2)' not{i,2}};
    if 0
        
        %         tx=text(li(1,1),li(2,1),li(3,1),'bla')
        %         set(tx,'HorizontalAlignment','left','string',['      ' 'bla'],'fontsize',6);
        %        set(tx,'verticalalignment','bottom','tag','label') ;
    end
    
end

if strcmp(p.showconnections,'off')
    set(findobj(gcf,'tag','conect'),'visible','off');
end


% % % % % % % % % % % % delete(findobj(gcf,'tag','light2'));
% % % % % % % % % % % % hlig=light;
% % % % % % % % % % % % lightangle(hlig,-144,2)
% % % % % % % % % % % % lighting gouraud;
% % % % % % % % % % % % set(hlig,'tag','light2')
% % % % % % % % % % % %
% % % % % % % % % % % % set(findobj(gcf,'tag','brain'),'facealpha',.05,'facecolor',[.5 .5 .5])
% % % % % % % % % % % % % set(gcf,'color','w');set(gca,'color','w')
% % % % % % % % % % % %
% % % % % % % % % % % % material metal
% set(findobj(gcf,'tag','blob'),'facecolor',[0 .48 0])
set(findobj(gcf,'tag','blob'),'facecolor',str2num(p.nodecolor))


%———————————————————————————————————————————————
%%   txt
%———————————————————————————————————————————————
txt2=txt(:,2);
txt2=regexprep(txt2,{'cortex' '_' 'superior' 'olfactory' 'globus' 'corpus' 'nucleus' 'sensory motor' 'motor' 'internal'},{'c.' ' ' 'sup.' 'olf.' 'glob.' 'c. ' 'nc' 's-m' 'm' 'int'});
% txt2=regexprep(txt2,{' R' ' L'},{'' ''});
txt2=regexprep(txt2,{'colliculus' 'pallidus'},{'coll.' 'pall'});
txt2=regexprep(txt2,{'capsule' 'hypothalamus'},{'caps' 'hypoth'});
txt2=regexprep(txt2,{'commisure' 'anterior' 'caudate'},{'commis' 'ant.' 'caud'});


delete(findobj(gcf,'tag','label'));
nspace=10;

for j=1:size(txt,1)
    loc =txt{j,1};
    tlab=txt2{j};
    if loc(2)<90
        str= [tlab ' ' repmat('_',1,nspace)]; tdir='right';
    else
        str= [ repmat('_',1,nspace) ' ' tlab];  tdir='left';
    end
    %    str= [   tlab];  tdir='center'
    
    
    tx=text(loc(1),loc(2),loc(3),str);
    set(tx,'HorizontalAlignment',tdir,'fontsize',6);
    set(tx,'verticalalignment','bottom','tag','label','interpreter','latex') ;
end
set(gca,'ydir','reverse');

if strcmp(p.showlabels,'off') ; set(findobj(gcf,'tag','label'),'visible','off') ;end  %VISBILITY  LABELS
set(findobj(gcf,'tag','label'),'fontsize',str2num(p.labelfontsize)) ;                 %FONTSIZE

% % % axis off
% % % rotate3d on;

if     strcmp(p.showbrain,'off') ; set(findobj(gcf,'tag','brain'),'visible','off') ; %VISBILITY
elseif strcmp(p.showbrain,'on') ; set(findobj(gcf,'tag','brain'),'visible','on')   ;
end

set(findobj(gcf,'tag','brain'),'facealpha', str2num(p.braintransparency));   %TRANSPARENCY
set(findobj(gcf,'tag','blob'),'facealpha',  str2num(p.nodestransparency));   %TRANSPARENCY
set(findobj(gcf,'tag','conect'),'facealpha',  str2num(p.connectiontransparency));   %TRANSPARENCY


%———————————————————————————————————————————————
%%   colorbar
%———————————————————————————————————————————————
try; delete(findobj(gcf,'tag','ax2' )); end
try; delete(findobj(gcf,'tag','cb' )); end
try; delete(findobj(gcf,'tag','imcb' )); end
ha2=axes('position',[.1 .9 .5 .05]);
set(ha2,'position',[.01 .01 .05 .5],'tag','ax2');
im=imagesc(clim);

colormap(cmap);
set(ha2,'position',[-.1 -.1 .005 .001]);

cb=colorbar;
set(cb,'tag','cb');

set(cb,'position',[0.01    0.1   0.0119    0.3000]);
set(im,'visible','on','tag','imcb');
axis on;
yl=ylabel(cb, [r.stattype '(' r.tbhead{3} ')'],'fontsize',7,'fontweight','bold');
set(yl,'VerticalAlignment','middle');
set(cb,'fontsize',6,'fontweight','bold');


caxis([clim(end-1) clim(end)]);


drawnow;

if isempty(findobj(0,'tag','params'))
    paramsgui
end



%———————————————————————————————————————————————
%%   parmaeter
%———————————————————————————————————————————————

function showParameter(e,e2)
paramsgui


function paramsgui

try; delete(findobj(0,'tag','params')); end
hp=figure;
set(gcf,'color','w','units','normalized','tag','params','menubar','none','toolbar','none');
ha=findobj(0,'tag','fcon'); ha= ha(1);
set(ha,'units','norm');
si=get(ha,'position');



siz=.25 ;
% set(hp,'position',[ si(1)-siz si(2) siz-.001 si(4)]);
set(hp,'position',[ si(1)+si(3)+.002 si(2) siz-.001 si(4)]);

h = uicontrol('style','pushbutton','units','norm', 'string','plot',...
    'position',[0.1 0.9 .2 .05],'tag','tab1','callback', @plotthis);
% return
% global an

w=get(ha,'userdata');

% pars={};
% pars(end+1,:)={ 'colormap'  w.cmap 'cmap' };

% s=cell2struct(d(:,2)',fmt,2);

plist=w.plist;
pars=w.plist(:,3);
for i=1:size(w.plist,1)
    pars{i,2}=getfield(w.p,w.plist{i,1});
end



% pars={...
% 'file'   'x_t2.nii'                                                                                             's'
% % 'rfile' 'O:\harms1\harms3_lesionfill\templates\ANOpcol.nii'                 's'
% 'rfile'  'sss'       's'
% 'imswap'   '1'                                                                                               'd'
% 'doresize'  '1'                                                                                               'd'
% 'slice'   '100'                                                                                                'd'
% 'cmap'  ''                                                                                                   's'
% 'alpha' '.5'                                                                                                   'd'
% 'nsb'  ''                                                                                                       'd'
% 'cut' ['0 0 0 0']                                                                                           'd'
% };
% F:\TOMsampleData\study4\templates
us.fs=9;
us.hp=hp;
us.pars=pars;
us.plist=plist;
us.editable=[0 1];
us.position=[0 0.1 1 .7];
set(gcf,'userdata',us);



% t = uitable('Parent',hp,'Data',pars(:,1:2),'units','norm',      'position',[0 0 .9 .9],'ColumnEditable',logical([0 1]),'columnname','','rowname','');
% set(t,'ColumnWidth',{70 180});
% set(t,'fontsize',9);
% us.hp=hp;
% us.t=t;
% us.pars=pars;
%
% set(hp,'userdata',us);

set(gcf,'resizefcn',@maketable)
maketable
setBGcol([],[],'fromBG');


function maketable(he,ho)
us=get(gcf,'userdata');
if isfield(us ,'t')
    data=us.t.Data;
    t=us.t;
else
    data=us.pars(:,1:2);
end
try;
    delete(t);
end


% t=us.t
% pars=get(us.t.data)
% pars=us.t.Data;
% delete(us.t)
% t = uitable('Parent',us.hp,'Data',us.pars(:,1:2),'units','norm',    ...
%     'position',[0 0 .9 .9],'ColumnEditable',logical([0 1]),'columnname','','rowname','',...
%     'columnwidth',{'auto','auto'});
%
% t = uitable('Parent',us.hp,'Data',us.pars(:,1:2),'units','norm')
%
%
% data=us.pars
dataSize = size(data);
% Create an array to store the max length of data for each column
maxLen = zeros(1,dataSize(2));
% Find out the max length of data for each column
% Iterate over each column
for i=1:dataSize(2)
    for j=1:dataSize(1)% Iterate over each row
        len = length(data{j,i});
        if(len > maxLen(1,i))% Store in maxLen only if its the data is of max length
            maxLen(1,i) = len;
        end
    end
end

% Some calibration needed as ColumnWidth is in pixels

cellMaxLen = num2cell(maxLen*7);

t = uitable('Parent',us.hp,'units','norm',      'position',us.position,...
    'ColumnEditable', logical(us.editable),'columnname','','rowname','');
set(t,'fontsize',us.fs);
set(t, 'Data', [data; repmat({''},5,2)]);
set(t,'units','pixels');
set(t, 'ColumnWidth', cellMaxLen(1:2));% Set ColumnWidth of UITABLE
set(t,'units','normalized');
set(t, 'ColumnWidth',{200 150});

us.t=t;
set(gcf,'userdata',us);

drawnow;
% pause(.5);
try
    table = findjobj(us.t); %findjobj is in the file exchange
    table1 = get(table,'Viewport');
    jtable = get(table1,'View');
    renderer = jtable.getCellRenderer(0,0);
    renderer.setHorizontalTextPosition(javax.swing.SwingConstants.LEFT);
    renderer.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
    % set(table,'HorizontalScrollBarPolicy',31)
end


%disable scrolling
try
    jScrollPane = table.getComponent(0);
    % catch
    %     us=get(gcf,'userdata');
    %     jTable = findjobj(us.t); % hTable is the handle to the uitable object
    %     jScrollPane = jTable.getComponent(0);
    %     javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
    %     currentViewPos = jScrollPane.getViewPosition; % save current position
    %     drawnow; % without this drawnow the following line appeared to do nothing
    %
    % end
    javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
    currentViewPos = jScrollPane.getViewPosition; % save current position
    set(us.t,'CellSelectionCallback',{@mCellSelectionCallback,jScrollPane,currentViewPos});
end



function mCellSelectionCallback(e,r,jScrollPane,currentViewPos)
jScrollPane.setViewPosition(currentViewPos);

% us=get(gcf,'userdata');
% jTable = findjobj(us.t); % hTable is the handle to the uitable object
% jScrollPane = jTable.getComponent(0);
% javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
% currentViewPos = jScrollPane.getViewPosition; % save current position
% set(hTable,'data',newData); % resets the vertical scroll to the top of the table
% drawnow; % without this drawnow the following line appeared to do nothing
% jScrollPane.setViewPosition(currentViewPos);



% return
%% calback
function plotthis(hx,hy)
pl=(findobj(0,'tag','params'));
if length(pl)>1
    pl=pl(1);
end

us=get(pl,'userdata');
d=get(us.t,'data');

fields=us.plist(:,1);
s=cell2struct(d(1:length(fields),2)',fields,2);


ha=findobj(0,'tag','fcon');
ha= ha(1);
w=get(ha,'userdata');

% fn=fieldnames(s);
% for i=1:size(s,1)
%    w= setfield(w,fn{i}, getfield(s,fn{i}) );
% end
w.p=s;

set(ha,'userdata',w);
% disp(w);
show3d('replot');













