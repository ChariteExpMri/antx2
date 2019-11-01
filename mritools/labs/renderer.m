
function renderer(varargin)
% render surface (neocortex & cerebellum)
% #yg    render surface
%##  *  10-Jun-2014_01-56-06
% • use shortcut [r] from SPM-graphic figure to open the default rendered image (labs-toolbox has to be activated)
%   otherwise type 'renderer'
% • the related command  is in ## [green text] ##
%___________________________________________________________________________________________________
%### type of background structure  ###  ## [type]  ##
% •  neocortex     [1]
% •  cerebellum-I  [2]
% •  cerebellum-II [3]
%
% ### view objects from midline cut  ## [showinside] ##  {0|1}
% ### define colorlimits ### ## [climit] ##  {2 values }
% ### define colormap ### ## [cmap] ##  {hot,summer..., r,rwb,..isummer... }
% • matlab builtins (not, summer,...), see colorbar/map
% • concatenation of color-defining strings 'gwy'--> gren-white-yellow
% • using prefix 'i' to invert colorbar : e.g. "ibwr"  invert colorbar to red--white-red
%                                         e.g. "ihot"  invert hot-colorbar
% ### label ### get label of selected 3d location
% %___________________________________________________________________________________________________
%
%##, SHORTCUTS 
% #### [leftarrow]       #### previous COLORMAP
% #### [rightarrow]      #### next        ||
%
% #### [uparrow]         #### increase UPPER COLORLIMIT
% #### [downarrow]       #### decrease    ||     ||
%
% #### [ctrl+uparrow]    #### increase LOWER COLORLIMIT
% #### [ctrl+downarrow]  #### decrease    ||     ||
%
% #### [b]               #### reverse [b]ackgroundcolor
% #### [c]               #### copy to [c]lipboard
% #### [l]               #### reorder panels to [L]ine View
% #### [a]               #### [a]nterior/posterior view
% #### [r]               #### [r]ight/left view
% ________________________________________________________________________
% ##, commandline options
% commands with prefix ## 'f' ## change behaviour in an existing figure (gcf)
%  example: 'fclimit' instead of 'climit' ; 'finflate' instead of 'inflate'
%
% MANIPULATE ...
% ..a new figure      ..an existing figure        explanation
% ## [inflate]       ## and  ## [finflate]      ## inflate structure
% ## [cmap]          ## and  ## [fcmap]         ## define colormap (see above)
% ## [climit]        ## and  ## [fclimit]       ## define color limit (see above)
% ## [type]          ##           -                define brain structure (see above)
% ## [showinside]    ##           -                view from midline (see above)
% ## [transparency]  ## and  ## [ftransparency] ## set transparency : see instruction in command window when command is called
%
%  MANIPUATION of a stored image (independent from current SPM-structure)
% ## [file]          ##           -                filename of a volume (nii/img&hdr) to read instead of parsing SPM's data
% ## [thresh]        ##           -                threshold value for the volume specified in filename ( as string with >,<=,>,>=..as prefix) ;
%                                                  e.g. '>3'--> all voxels considered with stat. values > 3
%##, examples
%  #### [1.] DEPENDENT ON CURRENT SPM SESSION
%   [a] NEW FIGURE..
% • use SPM-gui-data and default parameter, colorlimit is [1 33];
% ## renderer('fclimit',[1 33])
% • use cerebellum-II, with midline view and inflation, colormap is winter, climt is [3 4]
% ## renderer('type',3,'showinside',1,'inflate',0,'cmap',winter,'climit',[3 4])
% renderer('type',2,'showinside',0,'inflate',0)
%
%  [b] UPDATE A FIGURE..
% • figure update (same figure): set colormap to inversed jet-map  and colorlimit to [5 10]
% ##  renderer('fcmap',ijet, 'climit',[5 10])
% • figure update (same figure): inflate structures, green colormap
% ##  renderer('finflate',1,'fcmap','g')
% •  set my own 64x3 cmap-matrix
% renderer('fcmap',myOwnCmap)
%  
%  #### [2.]  SAVED IMG/HDR or NII-file
% • new figure: load file (independet from current SPM data/gui) , show neocortex, use all voxels with values >10
% ## renderer('file','spmF_0001.hdr','type',1,'thresh','>10')
%___________________________________________________________________________________________________
% #y   undocumented examples
%
% renderer('ftransparency',3)
%  renderer('fclimit',[1 33])
%  renderer('finflate',1)
%  renderer('fcmap',cool)
%  renderer('type',3,'showinside',1,'inflate',0,'cmap',winter,'climit',[3 4])
% renderer('type',2,'showinside',0,'inflate',0)
% renderer('type',3,'showinside',1,'inflate',0,'cmap',hot,'climit',[5 10])

% renderer('type',1,'showinside',0,'inflate',0,'cmap','wog')
% renderer('fcmap','irygb')
% renderer('fcmap','ijet')
% renderer('cmap','RwB')   vs   renderer('cmap','rwb')
% 
% renderer('file','poseffect_of_stimulation.hdr','thresh','>10')
% renderer('file','spmF_0001.hdr','type',1,'thresh','>10')
% 
% renderer('ftransparency',5)
% renderer('ftransparency',1)


%#yg NEW
% - small volume correction iteration over with multiple masks
% - stati


% renderer('ftransparency',3)
%  renderer('fclimit',[1 33])
%  renderer('finflate',1)
%  renderer('fcmap','mRrwcbB')
%  renderer('type',3,'showinside',1,'inflate',0,'cmap',winter,'climit',[3 4])
% renderer('type',2,'showinside',0,'inflate',0)
% renderer('type',3,'showinside',1,'inflate',0,'cmap',hot,'climit',[5 10])
% print -dmeta;

% renderer('type',1,'showinside',0,'inflate',0,'cmap','wog')
% renderer('fcmap','irygb')
% renderer('fcmap','ijet')

% renderer('file','poseffect_of_stimulation.hdr','thresh','>10')
% renderer('file','spmF_0001.hdr','type',1,'thresh','>10')
% renderer('file','beta_0005.hdr','thresh','>.1','cmap','mRrwcbB')
% 

% uhelp('renderer.m'); return


if nargin~=0
    for i=1:2:length(varargin)
        fi=varargin{i};
        va=varargin{i+1};
        eval([fi '=' 'va;']);
        if strcmp(fi,'cmap') ;
            cmap=cmap_check(cmap);
        end%close(gcf)
    end
end

loadfromfile=0;

if exist('file')

    try
        strct=spm_vol(file);
    catch
        strct=spm_vol(fullfile(pwd,file));
    end
    [a b]=fileparts('poseffect_of_stimulation.hdr');
    us.title=b;
    [M XYZmm]=spm_read_vols(strct);
    [x y z] = ind2sub(size(M),1:length(M(:)));
    XYZ=[x;y;z];
    yy.t=M(:);


    xx= struct( 'XYZ',    XYZ,    't',  M(:),        'mat',strct.mat,...
        'dim',  size(M)', 'XYZmm' ,XYZmm);


    if exist('thresh')
        ix=~eval(['xx.t' thresh]);
        xx.t(ix)=nan;
    end
    del=isnan(xx.t);
    xx.t(del)=[];
    xx.XYZ(:,del)=[];
    xx.XYZmm(:,del)=[];


    %     XYZ=XYZ(:,M(:)>0);
    % XYZmm=XYZmm(:,M(:)>0);

    loadfromfile=1;

    %     xx= struct( 'XYZ',    XYZ,    't',  xSPM.Z',        'mat',xSPM.M,...
    %     'dim',   xSPM.DIM, 'XYZmm' ,xSPM.XYZmm);

end



% renderer('type',3,'cmap',summer)
if exist('newfig')~=1; newfig  = 0;    end

if exist('finflate')
    inflate=finflate;
    call_inflateIters(inflate) ;
    return
end

if exist('fun_cmap')
    cmap=fun_cmap;
    if newfig==0 ;
        call_cmap(cmap) ;
        return
    end
end

if exist('ftransparency')
    val=ftransparency;
    transparency(val) ;
    return
end

if exist('fclimit')
    val=fclimit;
    colorlimit(val);
    return
end
if exist('fcmap')
    val=fcmap;
    val=cmap_check(val);
    call_cmap(val);
    return
end


%================================================================
%%  PARAS
viewx=[...
    90  0
    -90  0
    0 90]  ;

% inflate   = 0 ;
% climit         =[5 12]
% climit         ='auto';

% type        =  2
% showinside  =  1
%================================================================
viewx(4,:)=viewx(3,:);

%================================================================
if exist('cmap')~=1;         cmap          = hot;  end%else; eval(['cmap=' cmap ';']);   ;end
if exist('type')~=1;         type          = 1;    end
if exist('showinside')~=1;   showinside    = 1;    end
if exist('inflate')~=1; inflate  = 0;    end
if exist('climit')~=1; climit  = [];    end
%================================================================


if type==2
    %     inflate   = 0  ;
    % showinside=0 ;%& type==1
end



%  C:\spm8\rend
%%SPM-renderer
metapath=strrep(which('labs.m'),'labs.m','');
if type==1
    % file='C:\spm8\canonical\cortex_5124.surf.gii'
    file=strrep(which('spm.m'),'spm.m',['canonical' filesep 'cortex_5124.surf.gii']);%##
    % file=strrep(which('spm.m'),'spm.m','canonical\cortex_8196.surf.gii');%##
    % file=strrep(which('spm.m'),'spm.m','canonical\cortex_20484.surf.gii');%##
    %
    %    file='E:\codes\matcro\mni_icbm152_gm_tal_nlin_sym_09c.surf.gii'
    % %    file='E:\codes\matcro\mni_icbm152_gm_tal_nlin_sym_09c.surf_red1.gii'
elseif type==2
    % file='E:\codes\matcro\test9.gii';
    %  file='E:\codes\matcro\cerebellum_suit.gii';
    %   file='E:\codes\matcro\cerebellum_suit_110.gii';
    %       file='E:\codes\matcro\cerebellum_suit_120.gii';
    %       file ='E:\codes\matcro\cerebellum_suit_120.gii'         ;
    %       file2='E:\codes\matcro\cerebellum_suit_120_split_d1.gii' ;

    file =fullfile(metapath,'cerebellum_suit_120.gii');
    file2=fullfile(metapath,'cerebellum_suit_120_split_d1.gii');
elseif type==3
    %    file='E:\codes\matcro\cerebellum_suitMaxprob_5.gii';
    %file='E:\codes\matcro\cerebellum_suitMaxprob_6.gii';
    % file='E:\codes\matcro\cerebellum_suitMaxprob_65.gii';
    %file='E:\codes\matcro\cerebellum_suitMaxprob_7.gii';
    %file='E:\codes\matcro\cerebellum_suitMaxprob_7.gii';
    % %   file='E:\codes\matcro\cerebellum_suitMaxprob_75.gii';
    %       file='E:\codes\matcro\cerebellum_suitMaxprob_8.gii';

    %    file='E:\codes\matcro\cerebellum_suitMaxprob_65.gii';
    %    file2='E:\codes\matcro\cerebellum_suitMaxprob_65split_1.gii';

    file =fullfile(metapath,'cerebellum_suitMaxprob_65.gii');
    file2=fullfile(metapath,'cerebellum_suitMaxprob_65split_1.gii');


    viewx(1,:)=[79 22];
    viewx(2,:)=[ -79 22];
    %       viewx(1,:)=[90 0];
    %     viewx(2,:)=[ -90 0];

end

if loadfromfile==0
    xSPM=evalin('base','xSPM');
    %in SPM-line 1015
    xx= struct( 'XYZ',    xSPM.XYZ,    't',  xSPM.Z',        'mat',xSPM.M,...
        'dim',   xSPM.DIM, 'XYZmm' ,xSPM.XYZmm);
    us.title=xSPM.title;
end
us.xSPMzrange=[min(xx.t) max(xx.t)];
us.XYZmm=xx.XYZmm';
us.Z=xx.t;

%  spm_render( xx,nan,file )

% fig=findobj(0,'tag','Graphics');
% hp=findobj(fig,'tag','SPMMeshRender')
% spm_mesh_inflate(hp,Inf,1);
% axis(gca,'image');  %axis(H.axis,'image');
% %     evalin('base',CB)


sp=.02;
% fig=findobj(0,'tag','myrenderer');
% if isempty(fig); newfig=1;else;  fig=fig(1); end



fig=figure('color','w','units','normalized');
set(gcf,'toolbar','none');
set(gcf,'position',[0.2674    0.3944    0.4757    0.25]);
set(gcf,'KeyPressFcn',@keyboardx);
try
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe=get(gcf,'javaframe');
    icon=strrep(which('labs.m'),'labs.m','monkey.png');
    jIcon=javax.swing.ImageIcon(icon);
    jframe.setFigureIcon(jIcon);
end



pos=[    0.01   -0.0767    0.33     1.1705     ];
pos(2,:)=[pos(1,3)+sp             pos(1,2:4)   ];
pos(3,:)=[pos(1,3)+pos(2,3)+sp+sp/2   pos(1,2:4)   ];
% pos(4,:)=[pos(1,3)+pos(2,3)+sp+sp/2    pos(1,2:4)   ];
us.pos=pos;
if showinside==1 %& type==1
    pos(4,:)=pos(1,:) ;
    pos(5,:)=pos(2,:) ;

    si=1.0;
    pos(1:3,2)=si/2-.05;
    pos(1:3,4)=si/2;
    %     pos(3,2)=.3;
    pos(4:5,2)=0;
    pos(4:5,4)=si/2;


    viewx(4:5,:)=viewx(1:2,:);
    set(gcf,'position',[0.2917    0.1967    0.4958    0.4444]);
    us.pos2=pos;
end

if type==1
    pos(3,1)= 0.63;
end

if type==2
    pos =[
        -0.0250   -0.0989    0.3300    1.1705
        0.2872   -0.1034    0.3300    1.1705
        0.5893   -0.0234    0.3300    1.1705];
end

if type==1 & showinside==0
    pos=[    0.0100   -0.0767    0.3300    1.1705
        0.3500   -0.0767    0.3300    1.1705
        0.6461   -0.0723    0.3300    1.1705];
end

if type==1 & showinside==1
    pos=[
        -0.0012    0.3875    0.3861    0.5850
        0.3486    0.3875    0.3861    0.5850
        0.6176    0.3300    0.4853    0.5800
        -0.008   -0.0650    0.3861    0.5850
        0.35   -0.0650    0.3861    0.5850
        ];
    cbpos=[0.9118   -0.0025    0.0200    0.400];
end

if type==2 & showinside==0
    pos= [  -0.0220   -0.0811    0.3342    1.1852
        0.2740   -0.0812    0.3342    1.1852
        0.5863   -0.0901    0.3342    1.1852 ];
    cbpos= [  0.9300    0.0500    0.0183    0.3050];
end
if type==2 & showinside==1
    pos=[
        -0.0390    0.4300    0.3912    0.5928
        0.2268    0.4200    0.3912    0.5928
        0.5504    0.2650    0.4563    0.7020
        -0.0530   -0.0375    0.3912    0.5928
        0.2281   -0.0425    0.3912    0.5928];
    cbpos= [  0.9300    0.0500    0.0237    0.2964];
end



if type==3 & showinside==0
    pos= [
        -0.0016   -0.0100    0.2739    0.9715
        0.2609   -0.0190    0.2739    0.9715
        0.5951   -0.0412    0.2739    0.9715 ];
    cbpos= [0.9300    0.1000    0.0166    0.3320];
end
if type==3 & showinside==1
    pos=[
        -0.0250    0.4700    0.3300    0.5000
        0.2478    0.4625    0.3300    0.5000
        0.5794    0.2625    0.3300    0.5000
        -0.0306   -0.0175    0.3300    0.5000
        0.2211   -0.0250    0.3300    0.5000];
    cbpos= [ 0.9328   -0.0050    0.0200    0.4000];
end

% pax=[0.0228571428571429 0.519551495016611 0.458482954545455 0.467393023255814;0.525698051948052 0.519551495016611 0.458482954545455 0.467393023255814;0.0246428571428571 0.0219047619047619 0.458482954545455 0.467393023255814;0.523912337662338 0.0195238095238095 0.458482954545455 0.467393023255814];
for i=1:  size(pos,1)%size(pax,1)
    %     ax=subplot(1,3,i)
    ax=axes('position',pos(i,:));axis off;
    s.parent=ax;
    if type~=1 && i==4
        file=file2;
    end

    if  0
        %     %% SOME TESTS ########################################
        M = export(gifti(file),'patch')
        %     M.vertices(M.vertices(:,1)<-20,1)=nan;
        M.vertices= single(M.vertices*.85);

        sec=10;
        sec2=sec+10;

        ix=find(M.vertices(:,1)>=sec & M.vertices(:,1)<=sec2);
        co=M.vertices(ix,:);
        fo=M.faces(ix,:);

        %      ix2=find(M.vertices(:,1)<sec);%delete this
        %      co2=M.vertices(ix2,:);
        %      r=pdist(co(:,2:3));r2=squareform(r);[r3 si]=sort(r2(:,1))
        %      co=co(si,:)
        % fo=delaunay(co(:,2),co(:,3));

        % [ignore I] = sort(angle(complex(co(:,2)-mean(co(:,2)),co(:,3)-mean(co(:,3)))));
        % co(:,2) = co(I,2);
        % co(:,3) = co(I,3);
        %      ib= inpoly(co2(:,[2 3]), co(:,[2 3]));
        %      M.vertices(ix2,1)=sec;
        %      M.vertices(ix2(ib==0),:)=nan;

        M.vertices(M.vertices(:,1)<-sec,1)=nan;
        %      M.faces(ix2(ib)==0,:)=1;

        H = spm_mesh_render('Disp',M,s) ;
        %
        %     ############# end TESTS ###############################
        %
    end
    % %
    H = spm_mesh_render('Disp',file,s) ;   %   H = spm_mesh_render(file)
    H = spm_mesh_render('Overlay',ax,xx);



    hp=findobj(fig,'tag','SPMMeshRender');
    hp= (hp(1));
    for j=1:inflate
        spm_mesh_inflate(hp,Inf,10);
    end
    drawnow;

    %%% H = spm_mesh_render('ColourBar',ax,'on');
    spm_mesh_render('ColourMap',ax,cmap);
    view([viewx(i,:)]);


    %     if i==4
    %         set(H.patch,'visible','off');
    %         set(ax,'visible','off','hittest','off');
    %         cb=findobj(gcf,'location','eastoutside');
    %         cb=cb(1);
    %         pos2=get(cb,'position');
    %         set(cb,'position',[ pos2(1)-0.01 .05  .02 .4 ]);
    %         spm_mesh_render('ColourMap',ax,cmap);
    %         set(cb,'fontweight','bold');
    %         set(cb,'ButtonDownFcn',[],'HitTest','on','tag','cbar')
    % %         H = spm_mesh_render('clim',ax,[-10 10]);
    %     end

    if ~isempty(climit)
        H = spm_mesh_render('clim',ax,climit);
    end

    axis equal;axis vis3d;
    %       axis equal;axis vis3d;
    if type==2; axis equal;axis vis3d;end
    if type==3
        axis equal;axis vis3d;
        zoom(1.4);
    end

    pos3(i,:)=get(gca,'position');
end
us.pos3=pos3;

% h=rotate3d;
% cb=(get(h,'ActionPostCallback'));
% try;         feval(cb{1});
% catch
%     try ;         feval(cb{1},[],[],cb{2});        end
% end
% rotate3d off;

camlightupdate
set(gcf,'inverthardcopy','off');


cmenu = uicontextmenu;
ax2=findobj(gcf,'type','axes');
set(ax2,'UIContextMenu', cmenu);
if showinside==1 && type==1;      componentshow;  end
if showinside==1 && type>1;      componentshow2; end

r=get(H.patch,'UIContextMenu');
r2=get(r,'children');
cm=findobj(r2,'Label','Colormap');
ch=get(cm,'children');
cmaps=get(ch,'label');
uimenu(cmenu, 'Label', 'set ColorLimits', 'Callback', @colorlimit,'Separator','on');
for i=1:length(cmaps)
    rm=uimenu(cmenu, 'Label', cmaps{i}, 'Callback', @call_cmap);
    if i==1; set(rm,'Separator','on');end
end
% uimenu(cmenu, 'Label', 'red', 'Callback', {@cmap_define,'r'});

%menu


f = uimenu('Label','RENDER');
uimenu(f,'Label','cerebrum','Callback',@menuf,'accelerator','1');
uimenu(f,'Label','cerebellum-I','Callback',@menuf,'accelerator','2');
uimenu(f,'Label','cerebellum-II','Callback',@menuf,'accelerator','3');
uimenu(f,'Label','cerebrum & interhem','Callback',@menuf,'Separator','on','accelerator','4');
uimenu(f,'Label','cerebellum-I & interhem','Callback',@menuf,'accelerator','5');
uimenu(f,'Label','cerebellum-II & interhem','Callback',@menuf,'accelerator','6');

f = uimenu('Label','options');
%     uimenu(f,'Label','showinside',               'Callback',@optionsf);
uimenu(f,'Label','anterior/posterior view','Callback',@optionsf);
uimenu(f,'Label','right/left view','Callback',@optionsf);
uimenu(f,'Label','reorder panels [up-down]','Callback',@optionsf);
uimenu(f,'Label','reorder panels [line]','Callback',@optionsf);

uimenu(f,'Label','inflate',                'Callback',@optionsf,'Separator','on');
uimenu(f,'Label','transparency',            'Callback',@optionsf);
uimenu(f,'Label','zoom in',               'Callback',@optionsf,'Separator','on');
uimenu(f,'Label','zoom out'                 ,'Callback',@optionsf);
uimenu(f,'Label','reverse backgroundcolor'   ,'Callback',@optionsf);

f = uimenu('Label','color');
uimenu(f, 'Label', 'set ColorLimits', 'Callback', @colorlimit,'Separator','on');
for i=1:length(cmaps)
    rm=uimenu(f, 'Label', cmaps{i}, 'Callback', @call_cmap,'tag','cbardefined');
    if i==1; set(rm,'Separator','on');end
end
uimenu(f, 'Label', 'red', 'Callback', {@cmap_define,'r'},'tag','cbardefined','Separator','on');
uimenu(f, 'Label', 'green', 'Callback', {@cmap_define,'g'},'tag','cbardefined');
uimenu(f, 'Label', 'blue', 'Callback', {@cmap_define,'b'},'tag','cbardefined');
uimenu(f, 'Label', 'yellow', 'Callback', {@cmap_define,'y'},'tag','cbardefined','Separator','on');
uimenu(f, 'Label', 'orange', 'Callback', {@cmap_define,'o'},'tag','cbardefined');
uimenu(f, 'Label', 'magenta', 'Callback', {@cmap_define,'m'},'tag','cbardefined');
uimenu(f, 'Label', 'cyan', 'Callback', {@cmap_define,'c'},'tag','cbardefined');
uimenu(f, 'Label', 'white', 'Callback', {@cmap_define,'w'},'tag','cbardefined','Separator','on');
uimenu(f, 'Label', 'black', 'Callback', {@cmap_define,'k'},'tag','cbardefined');
uimenu(f, 'Label', '.define colormap', 'Callback', {@cmap_define},'Separator','on');

f = uimenu('Label','label','Callback',@labelf);
f = uimenu('Label','info','Callback',@info);
% ###################################################################

p=findobj(gcf,'tag','SPMMeshRender');
us.clim         = getappdata(p(1),'clim'); us.clim=us.clim([2 3]) ;
us.newfig       = newfig;
us.viewx        = viewx;
us.inflate=inflate;
us.showinside=showinside;
us.type =type;
us.cmap =cmap;
set(gcf,'userdata',us,'tag','myrenderer');

rotate3d off
% x=[];
% set (gcf, 'WindowButtonMotionFcn', []);
% set (gcf, 'WindowButtonDownFcn', {@gdown, x});
% set (gcf, 'WindowButtonUpFcn', {@gup, x});

set(gcf,'toolbar','figure');

addcolorbar(cmap,us.clim)

hs = uicontrol('Style', 'text', 'String', us.title ,'units','normalized' );
set(hs,'Position', [ .25 .93 .5 .07 ],'visible','off',...
    'fontsize',10,'fontweight','bold' ,'backgroundcolor','w','tag','title');
set(hs,'visible','on');
axshift3;

function addcolorbar(cmap,labl)
% cmap=hot
% labl=[3.1 4.3]
cb=findobj(gcf,'tag','cbar');
us=get(gcf,'userdata');
pos=[ .93 0.05  .02 .25 ];
if us.showinside==0
    pos(3)=0.015;
end

if ~isempty(cb)
    pos=get(cb,'position');
    %       delete(cb);
    delete(findobj(gcf,'tag','cbar'));
end

axes('position',[.3 0 .3 .5],'units','normalized');
% subplot(3,3,9);
nval=2;
yticks=linspace(0.5, [size(cmap,1)+.5],nval);
% yticks=linspace(1, [size(cmap,1)],nval);
labl2 =linspace(labl(1),labl(2),nval);
cmap2= flipud(cmap);
labl2=flipud(sort(labl2(:)));

% if      ( diff(labl))>10; str='%2.0f'
% elseif   (diff(labl))<10; str='%2.0f'

for i=1:length(labl2)
    dum{i}=sprintf(' %2.1f',labl2(i));
    if labl2(i)==round(labl2(i))
        dum{i}=sprintf(' %2.0f',labl2(i));
    end
end
labl3=dum;

% fg
imagesc(  repmat(permute(cmap2,[1 3 2]) ,[1 10  1])  );
set(gca,'YAxisLocation','right') %'ydir','reverse');%,
set(gca,'ytick',yticks,'yticklabel',labl3,'fontweight','bold','fontsize',9);
set(gca,'xtick',[]);  %axis image;
set(gca,'tag','cbar','position',pos);
% set(gca,'TickLength',[0 0],'linewidth',.1)
% xlim([2 8]);
set(gca,'TickLength',[0 2],'linewidth',1);
% xlim([0 12]);ylim([0 66])
% xlim([0 12]);%ylim([yticks(1) yticks(2)])
% ylim([0 ceil(yticks(2))+.5]);
% box on;
% % ylim([0.5 66]);

xl=xlim;
yl=ylim;

abc=axis;
lw=1.5;
if sum(get(gcf,'color'))==3 ;    col='k'; else col='w';end
box off
if 1
    % % vline
    r=line( [xl(1)+.5 xl(1)+.5],[abc(3:4)],'color',col,'tag','cbarline','linewidth',lw);%V
    r=line( [xl(2)-.5 xl(2)-.5],[abc(3:4)],'color',col,'tag','cbarline','linewidth',lw);

    % % hline
    r=line([abc(1:2)], [yl(1) yl(1)],'color',col,'tag','cbarline','linewidth',lw);%H
    r=line([abc(1:2)], [yl(2)-.5 yl(2)-.5],'color',col','tag','cbarline','linewidth',lw);%H
end



% r=vline(.8,'color',col,'linewidth',lw,'tag','cbarline');
% r=vline(11,'color',col,'linewidth',lw,'tag','cbarline');
% r=hline(ceil(yticks(2)) ,'color',col,'linewidth',lw,'tag','cbarline');%64.8
% r=hline(0,'color',col,'linewidth',lw,'tag','cbarline');

%   delete(r)
try;
    set(gca,'ycolor',us.fgcol);
end


function labelf(obj,ro)
set(gcf,'windowButtonDownFcn',@getlabel)

function getlabel(ra,ro)
hp=gco;
if strcmp(get(hp,'Tag'),'SPMMeshRender')~=1
    return
end
[p v vi face facei] = m_select3d;
% labs(p)


fvd=get(hp,'FaceVertexCData');
thiscol=fvd(vi,:);
%  fv=get(p,'FaceVertexCData');
us=get(gcf,'userdata');
cmap=us.cmap;

if us.type==2
    %     return
    %     p=p([ 3     1 2]);
end

icol=find([cmap(:,1)==thiscol(1) & cmap(:,2)==thiscol(2) & cmap(:,3)==thiscol(3)]);
if isempty(icol);
    %    icol= dsearchn(cmap,thiscol);
end
step=(diff(us.clim)/  (length(cmap)+0)  );
%  step=(diff(us.xSPMzrange)/(length(cmap)+0)  );%% TODO

val=step*icol+step  ;
if us.clim(1)~=0
    val=val+ us.xSPMzrange(1);
end

% val
%
% co=p';
% ic= dsearchn(us.XYZmm,co)
%  us.Z(ic)
%
%  b=get(gco,'VertexNormals');
%  b(vi,:)
%
%  b=get(gco,'FaceVertexCData');
% b(vi,:)

% us.XYZmm=xx.XYZmm';
% us.Z=xx.z;

% p=findobj(gcf,'tag','SPMMeshRender')
% min(getappdata(p(1),'data'))
% min(getappdata(p(1),'clim'))
% disp([val ]);
% thiscol
if isempty(val);val=nan;end
try
    [labelx header labelcell]=pick_wrapper(p', 'Noshow');
    showtable2([0 0 1 1],[ ['STAT' header ];[ num2str(val) labelx ]]','fontsize',8);
end



function optionsf(obj,ro)
us=get(gcf,'userdata');
p=sort(findobj(gcf,'tag','SPMMeshRender'));
ax= (cell2mat(get(p,'parent')));

if strcmp(get(obj,'label'),'showinside');
    if us.type==2; return; end

    %     us=get(gcf,'userdata');

    if strcmp(get(p(end),'visible'),'on')
        pos=us.pos;
        set(p(end-1:end),'visible','off');
    else
        pos=us.pos2;
        set(p(end-1:end),'visible','on');
    end

    %     for i=1:3; set(ax(i),'position',pos(i,:));  end


elseif strcmp(get(obj,'label'),'anterior/posterior view');

    newview=[-180 12;  0 12   ];
    panel=[1 2];
    %     if us.showinside==0; panel=[1 2]; else  panel=[4 5];end
    for i=1:length(panel)
        if i==1
            [a b]=view(ax(panel(i)));
            if newview(1,1)==a
                newview=us.viewx(panel,:);


            end
        end
        view(ax(panel(i)),newview(i,:));
    end
    camlightupdate
elseif strcmp(get(obj,'label'),'right/left view');

    if us.showinside==0; panel=[1 2]; else  panel=[4 5];end
    for i=1:length(panel)
        %         view(ax(panel(i)),us.viewx(i,:));
        [a b]=view(ax(panel(i)));
        if abs(a)==180 | a==0 %| abs(a)==90;
            a=a+90;
        else
            a=-a;
        end
        view(ax(panel(i)),  [a b]   );
    end
    camlightupdate

elseif strcmp(get(obj,'label'),'reorder panels [up-down]');
    if us.showinside==0; disp('not available for this'); return;end
    if isfield(us, 'panelreorder_ud') ==0
        us.panelreorder_ud=0;
        set(gcf,'userdata',us);
        us=get(gcf,'userdata');
    end
    p=sort(findobj(gcf,'tag','SPMMeshRender'));
    pos=us.pos3;
    if us.panelreorder_ud==0
        pos=pos([ 4 5 3 1:2  ],:);
        us.panelreorder_ud=1;
    else
        us.panelreorder_ud=0;
    end

    for i=1:length(p)
        set( get(p(i),'parent'),'position', pos(i,:) );
    end
    set(gcf,'userdata',us);
elseif strcmp(get(obj,'label'),'reorder panels [line]');
    if us.showinside==0; disp('not available for this'); return;end
    if isfield(us, 'panelreorder_line') ==0
        us.panelreorder_line=0;
        set(gcf,'userdata',us);
        us=get(gcf,'userdata');
    end
    p=sort(findobj(gcf,'tag','SPMMeshRender'));
    pos=us.pos3;
    if us.panelreorder_line==0
        %pos=pos([ 4 5 3 1:2  ],:);
        us.panelreorder_line=1;
    else
        us.panelreorder_line=0;
    end

    if 1
        if us.panelreorder_line==1
            fc=.83;
            if us.type==1;
                pos=[0.2571    0.0075    0.3861   fc
                    0.0667    0.0100    0.3861   fc
                    -0.145    0.0225    0.4853    fc
                    0.6361    0.0150    0.3861    fc
                    0.4476    0.0100    0.3861   fc];
                cbar= findobj(gcf,'tag','cbar');
                cbpos=get(cbar,'position');
                cbpos(3)=.01;%0.02
                set(cbar,'position',cbpos);

            else %if us.type==2
                pos=[ 0.3949    0.1223    0.3861    0.8300
                    0.2321    0.1026    0.3861    0.8300
                    -0.0686    0.0781    0.4853    0.8300
                    0.6967    0.1113    0.3861    0.8300
                    0.5531    0.1100    0.3861    0.8300
                    0.9300    0.0500    0.0200    0.2500];
            end


            cbar=findobj(gcf,'tag','cbar'); delete(cbar(2:end));
            poscb=get(cbar,'position'); poscb(3)=0.01;
            set(cbar,'position',poscb);

            set(gcf,'position',[ 0.1028    0.1967    0.8819    0.3]);
            set(obj,'checked','on');
        else


            cbar=findobj(gcf,'tag','cbar'); delete(cbar(2:end));
            poscb=get(cbar,'position'); poscb(3)=0.02;
            set(cbar,'position',poscb);

            set(gcf,'position',[ 0.2917    0.1967    0.4958    0.4444]);
            set(obj,'checked','off');
        end
    end

    for i=1:length(p)
        set( get(p(i),'parent'),'position', pos(i,:) );
    end
    set(gcf,'userdata',us);

elseif strcmp(get(obj,'label'),'inflate');
    call_inflateIters(1);


elseif strcmp(get(obj,'label'),'transparency');
    % value=input('value ([1,2,3,4 or 5] for [0,20,40,60 or 80%]transparency]):  ' ,'s');
    transparency([]);

elseif strcmp(get(obj,'label'),'zoom in');
    for i=1:length(ax)
        set(gcf,'currentaxes',ax(i));
        zoom(1.1);
    end
elseif strcmp(get(obj,'label'),'zoom out');
    ax=cell2mat(get(findobj(gcf,'tag','SPMMeshRender'),'parent' ));
    for i=1:length(ax)
        set(gcf,'currentaxes',ax(i));
%         pause(.1);drawnow;
        zoom(.9);
    end
%     length(ax)

elseif strcmp(get(obj,'label'),'reverse backgroundcolor');

    cb=findobj(gcf,'tag','cbar');
    ti=findobj(gcf,'tag','title');
    ycol=get(cb,'ycolor');
    if sum(ycol)==3
        set(cb,'ycolor',[0 0 0]);
        set(gcf,'color','w');
        set(ti,'backgroundcolor','w','foregroundcolor','k');
        try; set(findobj(gcf,'tag','cbarline'),'color','k'); end
        us.bgcol='w';  us.fgcol='k';
    else
        set(cb,'ycolor',[1 1 1]);
        set(gcf,'color','k');
        set(ti,'backgroundcolor',[0 0 0],'foregroundcolor','w');
        try; set(findobj(gcf,'tag','cbarline'),'color','w'); end
        us.bgcol='k';  us.fgcol='w';
    end

end

set(gcf,'userdata',us);


function menuf(obj,ro)
if strcmp(get(obj,'label'),'cerebrum')
    renderer('type',1,'showinside',0);
elseif strcmp(get(obj,'label'),'cerebellum-I')
    renderer('type',2,'showinside',0);
elseif strcmp(get(obj,'label'),'cerebellum-II')
    renderer('type',3,'showinside',0);
elseif strcmp(get(obj,'label'),'cerebrum & interhem')
    renderer('type',1,'showinside',1);
elseif strcmp(get(obj,'label'),'cerebellum-I & interhem')
    renderer('type',2,'showinside',1);
elseif strcmp(get(obj,'label'),'cerebellum-II & interhem')
    renderer('type',3,'showinside',1);
end



function colorlimit(ra,ro)
us=get(gcf,'userdata');
p=findobj(gcf,'tag','SPMMeshRender');
axi=cell2mat(get(p,'parent'));


if isnumeric(ra) & length(ra)==2
    climit=ra;
else
    climit=str2num(input('set colorlimits (2 values) :  ' ,'s'));
end
if isempty(climit)
    climit     = getappdata(p(1),'clim'); climit=climit([2 3]) ;
end
for i=1:length(axi);
    try
        H = spm_mesh_render('clim',axi(i),climit);
    end
end

cmap=spm_mesh_render('ColourMap',get(p(1),'parent'));
addcolorbar(cmap,climit);
us.clim=climit;
set(gcf,'userdata',us);

function call_cmap(ra,ro)

if numel(ra)==1
    cmap=get(ra,'label');
    eval([ 'cmap=' cmap ';' ]);
else
    eval([ 'cmap=' 'ra' ';' ]);
end


us=get(gcf,'userdata');
climit=us.clim;

p=findobj(gcf,'tag','SPMMeshRender');
axi=cell2mat(get(p,'parent'));
% axi=findobj(gcf,'type','axes');
for i=1:length(axi);
    try
        spm_mesh_render('ColourMap',axi(i) ,cmap);
        H = spm_mesh_render('clim',axi(i),climit);
    end
end
p=findobj(gcf,'tag','SPMMeshRender');
% climit         = getappdata(p(1),'clim'); climit=climit([2 3]) ;
us.cmap=cmap;
set(gcf,'userdata',us);
addcolorbar(cmap,climit);

function transparency(value)
if isempty(value)
    value=str2num(input('value ([1,2,3,4 or 5] for [0,20,40,60 or 80%]transparency]):  ' ,'s'));
end
ps=findobj(gcf,'tag','SPMMeshRender');

if value>0 && value<6
    for i=1:length(ps)
        r=get(ps(i),'UIContextMenu');
        r2=get(r,'children');
        r3=findobj(r2,'label','Transparency');
        r4=sort(get(r3,'children'));

        r5=get(r4(value),'callback');
        r5{1}(r4(value),[],r5{2:end});
    end
end


function componentshow
ps=sort(findobj(gcf,'type','patch'));
ps=ps(end-1:end);
for comp=1:2
    %     comp=2
    i=comp;
    r=get(ps(i),'UIContextMenu');
    r2=get(r,'children');
    r3=findobj(r2,'label','Connected Components');
    r4=get(r3,'children');
    r5=get(r4(comp),'callback');
    r5{1}(r4(comp),[],r5{2:end});

    ax=get(ps(i),'parent');
    if comp==1
        view(ax,[90 0]);
    elseif comp==2
        view(ax,[-90 0]);
    end

end
h=rotate3d;
cb=(get(h,'ActionPostCallback'));
try;  feval(cb{1}); catch
    try         feval(cb{1},[],[],cb{2});   end
end


function componentshow2

hp=sort(findobj(gcf,'tag','SPMMeshRender'));
hp= ((hp(end-1:end)));


% H.patch=gco;

for i=1:2
    H.patch=hp(i);
    % C   = getappdata(H.patch,'cclabel');
    % ind = sscanf(get(obj,'Label'),'Component %d');
    F   = get(H.patch,'Faces');
    V   = get(H.patch,'FaceVertexAlphaData');
    Fa  = get(H.patch,'FaceAlpha');
    % v   = get(H.patch,'vertices');
    v   = get(H.patch,'xdata')';
    v   =median(v,2);
    c=v(:,1)*0;
    c(find(v(:,1)<=0))=1;
    c(find(v(:,1)>=0))=2;
    C=c;
    ind=i;
    setappdata(H.patch,'cclabel',C);
    r=get(H.patch,'UIContextMenu');
    r2=get(r,'children');
    r3=findobj(r2,'label','Connected Components');
    r4=get(r3,'children');
    %     r5=get(r4(1),'callback');
    %     r5{1}(r4(comp),[],r5{2:end})
    r4=sort(r4);
    set(r4(1),'label','Component 1');
    set(r4(2),'label','Component 2');
    delete(r4(3:end));
    % get(obj,'label')
    if ~isnumeric(Fa)
        if ~isempty(V), Fa = max(V); else Fa = 1; end
        if Fa == 0, Fa = 1; end
    end
    if isempty(V) || numel(V) == 1
        Ve = get(H.patch,'Vertices');
        if isempty(V) || V == 1
            V = Fa * ones(size(Ve,1),1);
        else
            V = zeros(size(Ve,1),1);
        end
    end

    V(reshape(F(C==ind,:),[],1)) = 0;
    set(H.patch, 'FaceVertexAlphaData', V);
    set(H.patch, 'FaceAlpha', 'interp');
    ax=get(hp(i),'parent');
    if i==1
        view(ax,[-90 5]);
    else
        view(ax,[90 5]);
    end
end

% h=rotate3d;
% cb=(get(h,'ActionPostCallback'));
% try;  feval(cb{1}); catch
%     try         feval(cb{1},[],[],cb{2});   end
% end
camlightupdate
%% ff

% fig2=fg,
% hs=subplot(2,2,1)
% new_handle = copyobj(AX,fig2);

%  H = spm_mesh_render('clim',AX,[-10 10])

function camlightupdate
h=rotate3d;
cb=(get(h,'ActionPostCallback'));
try;  feval(cb{1}); catch
    try         feval(cb{1},[],[],cb{2});   end
end

function call_inflateIters(inflate)
hp=sort(findobj(gcf,'tag','SPMMeshRender'));

for i=1:length(hp)
    for j=1:inflate
        xl=xlim(get(hp(i),'parent'));
        spm_mesh_inflate(hp(i),Inf,100);
        xl2=xlim(get(hp(i),'parent'));
        set(gcf,'currentaxes',get(hp(i),'parent'))
        %          zoom(diff(xl2)/diff(xl));
        %          zoom(.75);
    end
end


% function finflate(cmap)
% hp=sort(findobj(gcf,'tag','SPMMeshRender'));
% hp(4)=[];
% for i=1:length(hp)
%     for j=1:inflate
%         spm_mesh_inflate(hp(i),Inf,100);
%     end
% end
%
function cmap_define(ra,ro,cmap)

if ~exist('cmap')
    disp('[A] Define colormap using string of color-specific letters (without " or '')');
    disp('   example1: "wog"   --> generates colormap with "white-orange-green"');
    disp('   example2: "mrwcb" --> generates colormap with "magenta-red-white-cyan-blue"');
    disp('[B]invert colormap using "i" as prefix "');
    disp('   example1: "ijet"   --> inverted colormap of jet-colormap"');
    disp('   example2: "ibwr"   --> generates an inverted colormap with "blue-white-red"');
    cmap=input(' string of color-specific letters: ' ,'s');
end
cmap=cmap_check(cmap);
call_cmap(cmap);

function cmap=cmap_check(cmap)
invert=0;
if ischar(cmap)
    if strcmp(cmap(1),'i')
        cmap=cmap(2:end);
        invert=1;%invert colorbar
    end
end

try
    cmap= eval(cmap);
catch
    if ischar(cmap)
        if strcmp(cmap(1),'i' )
            try
                cmap= eval(cmap(2:end));
                cmap=flipud(cmap);
            end
        else
            if strcmp(cmap,'french')
                cmap=[0.0784313753247261 0.168627455830574 0.549019634723663;0.0705882385373116 0.160855621099472 0.594117641448975;0.062745101749897 0.15308378636837 0.639215707778931;0.0549019612371922 0.145311951637268 0.684313774108887;0.0470588244497776 0.137540116906166 0.729411780834198;0.0392156876623631 0.129768282175064 0.774509787559509;0.0313725508749485 0.121996439993382 0.819607853889465;0.0235294122248888 0.11422460526228 0.864705920219421;0.0156862754374743 0.106452763080597 0.909803926944733;0.00784313771873713 0.0986809283494949 0.954901933670044;0 0.0909090936183929 1;0 0.173553720116615 1;0 0.256198346614838 1;0 0.338842988014221 1;0 0.421487599611282 1;0 0.504132211208344 1;0 0.586776852607727 1;0 0.669421494007111 1;0 0.752066135406494 1;0 0.834710717201233 1;0 0.917355358600616 1;0 1 1;0.101851850748062 1 1;0.203703701496124 1 1;0.305555552244186 1 1;0.407407402992249 1 1;0.509259283542633 1 1;0.611111104488373 1 1;0.712962985038757 1 1;0.814814805984497 1 1;0.916666686534882 1 1;0.9375 1 1;0.958333373069763 1 1;0.979166686534882 1 1;1 1 1;1 0.972222208976746 0.972222208976746;1 0.944444477558136 0.944444477558136;1 0.916666686534882 0.916666686534882;1 0.881410300731659 0.881410300731659;1 0.846153855323792 0.846153855323792;1 0.810897469520569 0.810897469520569;1 0.775641083717346 0.775641083717346;1 0.740384638309479 0.740384638309479;1 0.705128252506256 0.705128252506256;1 0.669871807098389 0.669871807098389;1 0.634615421295166 0.634615421295166;1 0.528846204280853 0.528846204280853;1 0.423076957464218 0.423076957464218;1 0.317307710647583 0.317307710647583;1 0.211538478732109 0.211538478732109;1 0.105769239366055 0.105769239366055;1 0 0;0.966666698455811 0 0;0.933333337306976 0 0;0.899999976158142 0 0;0.866666674613953 0 0;0.833333373069763 0 0;0.800000011920929 0 0;0.766666650772095 0 0;0.733333349227905 0 0;0.700000047683716 0 0;0.666666686534882 0 0;0.633333325386047 0 0;0.600000023841858 0 0];
                %             elseif length(cmap)==1
                %                 vmap=zeros(64,3);
                %                 if strcmp(cmap,'r'); vmap(:,1)=1;
                %                 elseif strcmp(cmap,'b'); vmap(:,3)=1;
                %                 elseif strcmp(cmap,'o'); vmap=repmat([ 1.0000    0.6941    0.3922],[64 1]);
                %                 elseif strcmp(cmap,'m'); vmap(:,[1 3 ])=1;
                %                 elseif strcmp(cmap,'g'); vmap(:,[2   ])=.8;
                %                 elseif strcmp(cmap,'c'); vmap=repmat([ 1.0000    0.6941    0.3922],[64 1]);
                %                 elseif strcmp(cmap,'y'); vmap=repmat([ 1 1 0],[64 1]);
                %                 end
                %                 cmap=vmap;
            else%if length(cmap)=2

                b=[0 0 1];
                w=[1 1 1];
                k=[0 0 0];
                r=[1 0 0];
                m=[1 0 1];
                o=[ 1.0000    0.6941    0.3922];
                g=[0 1 0];
                y=[1 1 0];
                c=[0 1 1];

                B=[ 0.0784    0.1686    0.5490];
                W=[1 1 1];
                K=[0 0 0];
                R=[0.5000         0         0];
                M=[.6 0 .6];
                O=[0.9843    0.4941    0.0118];
                G=[0.0078    0.3137    0.1608];
                Y=[ 0.4039    0.2784    0.0118];
                C=[0.6824    0.4667         0];

                %                 t1=cmap(1);
                %                 t2=cmap(2);

                ww=[];
                for i=1:length(cmap)
                    ww(i,:)=eval([cmap(i) ';']);
                end
                if size(ww,1)==1; ww=[ww;ww];end

                k=round(linspace(1,64,size(ww,1))) ;
                vv=zeros(64,3);
                for i=1:length(k)-1
                    ix=k(i):k(i+1);
                    len=length(ix);
                    vv(ix,1) = linspace(ww( i, 1), ww( i+1, 1),len);
                    vv(ix,2) = linspace(ww( i, 2), ww( i+1, 2),len);
                    vv(ix,3) = linspace(ww( i, 3), ww( i+1, 3),len);
                end

                cmap=vv;

                %                 d1=eval(t1);
                %                 d2=eval(t2);
                %
                %                 cmap=[linspace(d1(1),d2(1),64);
                %                     linspace(d1(2),d2(2),64);
                %                     linspace(d1(3),d2(3),64)]';
                %                 'a'

            end




        end
    end

end

if invert==1
    cmap=flipud(cmap);
end


% #############################################################################
function info(ra,ro);
warning off
uhelp([mfilename '.m'])
fig=findobj(0,'tag','uhelp');
try
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe=get(fig,'javaframe');
    icon=strrep(which('labs.m'),'labs.m','monkey.png');
    jIcon=javax.swing.ImageIcon(icon);
    jframe.setFigureIcon(jIcon);
end
function key_climit(cut,val);
us=get(gcf,'userdata');
clim=us.clim;
clim(cut)=clim(cut)+val;
if clim(1)>=clim(2); return; end
colorlimit(clim,[]);


function keyboardx(src,event)
if length(event.Modifier) == 1 & strcmp(event.Modifier{:}, 'control')
    switch event.Key
        case {'downarrow'}
            key_climit(1,-1 );
        case {'uparrow'}
            key_climit(1,+1 );
        case {'leftarrow'}
            hcbar=sort(findobj(gcf,'tag','cbardefined'));
            us=get(gcf,'userdata');
            if ~isfield(us,'cmapID');              us.cmapID=1;  else
                us.cmapID=us.cmapID-1;
                if us.cmapID >length(hcbar); us.cmapID=length(hcbar);end
                if us.cmapID <1;             us.cmapID=1;end
            end
            set(gcf,'userdata',us)  ;
            call=get(hcbar(us.cmapID),'callback');
            try
                feval(call,hcbar(us.cmapID));
            catch
                feval(call{1},[],[],call{2});
            end
        case {'rightarrow'}
            hcbar=sort(findobj(gcf,'tag','cbardefined'));
            us=get(gcf,'userdata');
            if ~isfield(us,'cmapID');              us.cmapID=1;  else
                us.cmapID=us.cmapID+1;
                if us.cmapID >length(hcbar); us.cmapID=length(hcbar);end
                if us.cmapID <1;             us.cmapID=1;end
            end
            set(gcf,'userdata',us)  ;
            call=get(hcbar(us.cmapID),'callback');
            try
                feval(call,hcbar(us.cmapID));
            catch
                feval(call{1},[],[],call{2});
            end
        case {'z'}
            h=findobj(gcf,'label','zoom out');
            optionsf(h,[]);
    end

    %  elseif strcmp(event.Key,'control')
    %   set(gcf,'WindowScrollWheelFcn',{@mousewheel,2});
% --------------end control-comby----------------------

elseif strcmp(event.Key,'leftarrow')
    hcbar=sort(findobj(gcf,'tag','cbardefined'));
    us=get(gcf,'userdata');
    if ~isfield(us,'cmapID');              us.cmapID=1;  else
        us.cmapID=us.cmapID-1;
        if us.cmapID >length(hcbar); us.cmapID=length(hcbar);end
        if us.cmapID <1;             us.cmapID=1;end
    end
    set(gcf,'userdata',us)  ;
    call=get(hcbar(us.cmapID),'callback');
    try
        feval(call,hcbar(us.cmapID));
    catch
        feval(call{1},[],[],call{2});
    end
elseif strcmp(event.Key,'rightarrow')
    hcbar=sort(findobj(gcf,'tag','cbardefined'));
    us=get(gcf,'userdata');
    if ~isfield(us,'cmapID');              us.cmapID=1;  else
        us.cmapID=us.cmapID+1;
        if us.cmapID >length(hcbar); us.cmapID=length(hcbar);end
        if us.cmapID <1;             us.cmapID=1;end
    end
    set(gcf,'userdata',us)  ;
    call=get(hcbar(us.cmapID),'callback');
    try
        feval(call,hcbar(us.cmapID));
    catch
        feval(call{1},[],[],call{2});
    end
elseif strcmp(event.Key,'space')
    %     shiftbutton([],[]);
elseif strcmp(event.Key,'downarrow')
    key_climit(2,-1 );
elseif strcmp(event.Key,'uparrow')
    key_climit(2,+1 );
elseif strcmp(event.Key,'b')
    h=findobj(gcf,'label','reverse backgroundcolor');
    optionsf(h,[]);
elseif strcmp(event.Key,'l')
    h=findobj(gcf,'label','reorder panels [line]');
    optionsf(h,[]);
elseif strcmp(event.Key,'c')
    print -dmeta;
elseif strcmp(event.Key,'a')
    h=findobj(gcf,'label','anterior/posterior view');
    optionsf(h,[]);
elseif strcmp(event.Key,'r')
    h=findobj(gcf,'label','right/left view');
    optionsf(h,[]);
elseif strcmp(event.Key,'z') 
     h=findobj(gcf,'label','zoom in');
    optionsf(h,[]);
end

