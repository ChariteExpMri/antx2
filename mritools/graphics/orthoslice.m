
% #yk orthogonal slice-view
% [varargout]=orthoslice(f, varargin )
% ===============================================
%% optional pairwise parameter
% ===============================================
% p.ce         =[0 0 0];      % coordinate to plot (in mm); default: [0 0 0]
%                             or use 'max' for max-location in 2nd image
%                             or use 'min' for min-location in 2nd image
%
% p.alpha      =0.5;          % transparency [0-1]; default: 0.5
% p.mode       ='ovl';        % mode to plot {'def','mask','ovl'}; default: 'ovl'
% p.cmap       ='spmhot';     % colormap (string, 'spmhot' is spms-colormap); default: 'spmhot'
% p.clim       =[];           % color limit [min max]; default: [] (i.e. use map's min max)
% p.blobthresh =[];           % lower image threshold -->produces blobs; default: [] (so no blobs)
% p.axcol      =[0 0 0];      % axes color; default: [0 0 1]
% p.maskcol    =[.7 .7 .7]    % color of the brainMaks (usefull when "blobthresh" is set)
% p.fs         =9;            % colorbar fontsize; default: 9
% p.cursorcol  =[1 1 1];      % cursorcolor; default: [0 0 1] (i.e spm cursor color)
% p.cursorwidth=0.5;          % cursor width; default: 0.5
% p.showparams =0;            % display parameter; {0,1}; default: 0
% 
% p.panel      =1;            % make one panel [0|1]
% p.fs         =10            % colorbar-fontsize
% p.cblabel    =''            % colorbar-label  (string or empty)
% ===============================================
%% examples
% ===============================================
% orthoslice({'AVGT.nii','JD.nii'});
% orthoslice({'AVGT.nii','JD.nii'},'alpha',[1 .5],'cmap',{'gray' 'hot'});
% orthoslice({'AVGT.nii','JD.nii'},'alpha',[1 .5],'cmap',{'gray' 'jet'},'clim',[nan nan; .5 1.5])
% orthoslice({'AVGT.nii','JD.nii'},'alpha',[1 .5],'cmap',{'gray' 'jet'},'clim',[nan nan; .5 1.5],'ce',[-1 2 0]);
% orthoslice({'AVGT.nii','JD.nii'},'alpha',[1 .5],'cmap',{'gray' 'jet'},'clim',[nan nan; .5 1.5],'ce',[0 0 0],'bgcol','w','labelcol','k','cursorcol','r');
%% set coordinate to max:
% orthoslice({'AVGT.nii','JD.nii'},'alpha',[1 .5],'cmap',{'gray' 'jet'},'ce','max')
%% set coordinate to min:
% orthoslice({'AVGT.nii','JD.nii'},'alpha',[1 .5],'cmap',{'gray' 'jet'},'ce','min')
%% mosaic/panel-2 with  'mm'-values from dimension-2
% q=orthoslice({'AVGT.nii','JD.nii'},'panel',2,'mdim',2,'mslicemm',[-0.39 0 ],'bgcol','w','labelcol','r','mroco',[1 nan],'mcbarfs',5,'alpha',[1 .5])
%% mosaic/panel-2 get 15 equally spaced sliced from dimension-2
% q=orthoslice({'AVGT.nii','JD.nii'},'panel',2,'mdim',2,'msliceidx','n15','bgcol','w','labelcol','r','mroco',[4 nan],'alpha',[1 .5]);
%% mosaic/panel-2 get 8 equally spaced sliced from dimension-2, arrange in two rows
% q=orthoslice({'AVGT.nii','JD.nii'},'panel',2,'mdim',2,'msliceidx','n8','bgcol','w','labelcol','r','mroco',[2 nan],'alpha',[1 .5]);
%% mosaic/panel-2 get 3 index-based slices from dimension-2, arrange in one row
% q=orthoslice({'AVGT.nii','JD.nii'},'panel',2,'mdim',3,'msliceidx',[50 100 120],'bgcol','w','mroco',[1 nan],'alpha',[1 .5],'labelcol','k');
%% orthoslice/panel-1: more complex example
% files =  { 'F:\data8\ortoslice_tests\AVGT.nii' 	
%     'F:\data8\ortoslice_tests\_b1grey.nii' 
%     'F:\data8\ortoslice_tests\_b2white.nii' 	
%     'F:\data8\ortoslice_tests\_b3csf.nii' };
% r=[];   
% r.ce=[-1 -1 -1.5]  ;%  center/cursor-location
% r.alpha       =  [0.5  0.5  0.5  0.7];  %transparency                                                                                                                                 
% r.axolperc    =  [7];   %overlapp ov axis in percent                                                                                                                                                  
% r.bgcol       =  '0.93725 0.86667 0.86667'; %background-color                                                                                                                             
% r.cbarvisible =  [0  1  1  1  1]; % colorbar-visibility                                                                                                                                       
% r.clim        =  [0     495.24 ;  0.7 1 ;0.7 1 ; 0.4  1 ];                                                                                                                                     
% r.cmap        =  { 'gray' 	'Oranges' 	'Greens' 	'@yellow' };  %colormaps                                                                                                           
% r.cursorcol   =  [1 1 1 ]; %cursor-color                                                                                                                                                
% r.cursorwidth =  [1];    %cursor-width                                                                                                                                                  
% r.figwidth    =  [780];  %figure width in pixels                                                                                                                                                
% r.mbarlabel   =  { '' 	'GM' 	'WM' 	'csf' };  %cbar-labels 
% r.labelcol    =  [1 0 1]; %cbar-color
% r.mcbarfs     =  [11];      %cbar-fontsize                                                                                                                                             
% r.mcbarpos    =  [-70  20  10  100];   % last c-bar-location relativ to right-fig-size (pixels)                                                                                                                                  
% r.visible     =  [1  1  1  1]; %bg/overlay-images-visible                                                                                                                                          
% orthoslice(files,r);
%% create hidden figure, save as png
% orthoslice({'AVGT.nii','JD.nii'},'alpha',[1 .5],'cmap',{'gray' 'jet'},'ce','max', 'hide',1,'saveas',fullfile(pwd,'test.png'),'dosave',1,'saveres',300)
% 
%
%% posthoc (after figure is created): save fig as png
% q=orthoslice('post','saveas',fullfile(pwd,'test.png'),'dosave',1)




% orthoslice('s.nii','fs',20,'cmap','parula');
% orthoslice({'AVGTmask.nii','s.nii'},'ce',[0.271 0.026 -3.567],'clim',[-14 18]);
% orthoslice({'AVGT.nii','s.nii'},'mode','ovl')
% orthoslice({'AVGTmask.nii','s.nii'},'mode','mask')
% orthoslice({'AVGTmask.nii','s.nii'},'mode','mask','axcol',[0 0 0],'blobthresh',5);
% orthoslice('s.nii','mode','def','axcol',[1 1 1]);
% orthoslice({'AVGT.nii','s.nii'},'mode','ovl','axcol',[0 0 0],'blobthresh',5,'alpha',1);
% ... spm-like
% orthoslice({'AVGTmask.nii','s.nii'},'mode','ovl','alpha',1);
% orthoslice({'AVGT.nii','s.nii'},'mode','mask');
% orthoslice({'AVGT.nii','s.nii'},'mode','ovl','alpha',.5);
% orthoslice({lab.template,'thresh_svimg__control_LT_mani__FWE0.05k1.nii'},'mode','ovl','alpha',.5,'blobthresh',0);
%% one panel mode
% q=orthoslice({bg, f3},'ce',ce(:)',   'mode','ovl','clim', [3 5] ,'cmap','hot', 'alpha',1,'cursorcol','w','fs',12);
% q=orthoslice({bg, f3},'ce',ce(:)',   'mode','ovl','clim', [3 5] ,'cmap','hot', 'alpha',1,'cursorcol','w','fs',12,'cblabel','t-value');
% q=orthoslice({bg, f3},'ce','origin', 'mode','ovl','clim', [3 5] ,'cmap','hot', 'alpha',.5,'cursorcol','w','fs',16,'cblabel','t-value');
% q=orthoslice({bg, f3},'ce','max',    'mode','ovl','clim', [3 5] ,'cmap','hot', 'alpha',1,'cursorcol','w','fs',16,'cblabel','t-value');
%% thrshold ovl-img
% q=orthoslice({fullfile(pwd,'AVGT.nii') fullfile(pwd,'JD.nii')},'mode','ovl' ,'cmap','jet', 'alpha',.5,'cursorcol','none','fs',16,'cblabel','t-value','blobthresh',1,'axolperc',5,'ce',[0 -2 -2]);
% q=orthoslice({fullfile(pwd,'AVGT.nii') fullfile(pwd,'JD.nii')},'mode','ovl' ,'cmap','jet', 'alpha',.5,'cursorwidth',0.1,'fs',16,'cblabel','t-value','blobthresh',1,'axolperc',5,'ce',[0 -2 -2]);
%% plot atlas
% q=orthoslice({fullfile(pwd,'AVGT.nii'),fullfile(pwd,'ANO.nii')},'mode','ovl' ,'cmap','jet', 'alpha',.5,'ce',[0 -2 -2],'clim',[1 1000]);
%% plot atlas,-save as png and close figure
% q=orthoslice({fullfile(pwd,'AVGT.nii'),fullfile(pwd,'ANO.nii')},'mode','ovl' ,'cmap','jet', 'alpha',.5,'ce',[0 -2 -2],'clim',[1 1000],'saveas',fullfile(pwd,'test.png'),'close',1);
%% plot atlas,-save as png, figure is hidden
% orthoslice({'AVGT.nii','JD.nii'},'alpha',[1 .5],'cmap',{'gray' 'jet'},'ce','max', 'hide',1,  'saveas',fullfile(pwd,'test.png'),'dosave',1,'saveres',300,'close',1)%
%% mosaic+save+hide
% q=orthoslice({fullfile(pwd,'AVGT.nii') fullfile(pwd,'ANO.nii')},'mode','ovl','clim', [0 1000] ,'cmap','jet', 'alpha',.5,'fs',14,'cblabel','t-value','panel',2,'hide',1,'saveas',fullfile(pwd,'this.png'),'bgcol','w','labelcol','b');
%
%% post-stuff
%% save image as png
%  q=orthoslice('post','saveas',fullfile(pwd,'test.png'))
%  q=orthoslice('post','saveas',fullfile(pwd,'test.png'),'saveres',300);
%
%


function [varargout]=orthoslice(f, varargin )
varargout{1}=[];
warning off;
% if nargin==0
%    orthoslice('s.nii');
%    % orthoslice({'AVGTmask.nii','s.nii'});
%    % orthoslice({'AVGT.nii','s.nii'});
%    % orthoslice('s.nii','fs',20,'cmap','parula');
%    %orthoslice({'AVGTmask.nii','s.nii'},'ce',[0.271 0.026 -3.567],'clim',[-14 18]);
%    %    orthoslice({'AVGT.nii','s.nii'},'mode','ovl')
%    %    orthoslice({'AVGTmask.nii','s.nii'},'mode','mask')
%    %  orthoslice({'AVGTmask.nii','s.nii'},'mode','mask','axcol',[0 0 0],'blobthresh',5);
%    %orthoslice('s.nii','mode','def','axcol',[1 1 1]);
%    %     orthoslice({'AVGT.nii','s.nii'},'mode','ovl','axcol',[0 0 0],'blobthresh',5,'alpha',1);
%    %spm-like
%    %
%    % orthoslice({'AVGTmask.nii','s.nii'},'mode','ovl','alpha',1);
%    % orthoslice({'AVGT.nii','s.nii'},'mode','mask');
%    % orthoslice({'AVGT.nii','s.nii'},'mode','ovl','alpha',.5);
%    %orthoslice({lab.template,'thresh_svimg__control_LT_mani__FWE0.05k1.nii'},'mode','ovl','alpha',.5,'blobthresh',0);
%
%     return
% end

% ==============================================
%% pairwise parameter
% ===============================================
p.ce         =[0 0 0];      % coordinate to plot; default: [0 0 0]
p.alpha      =0.5;          % transparency [0-1]; default: 0.5
p.mode       ='ovl';        % mode to plot {'def','mask','ovl'}; default: 'ovl'
% p.cmap       ='SPMhot';     % colormap (string, 'spmhot' is spms-colormap); default: 'spmhot'
p.cmap       ={'gray'  'jet' 'copper'  'hot'};
p.clim       =[];           % color limit [min max]; default: [] (i.e. use map's min max)
p.blobthresh =[];           % lower image threshold -->produces blobs; default: [] (so no blobs)
p.axcol      =[0 0 0];      % axes color; default: [0 0 1]
p.maskcol    =[.7 .7 .7];    % color of the brainMaks (usefull when "blobthresh" is set)
p.fs         =9;            % colorbar fontsize; default: 9
p.cursorcol=[1 1 1];      % cursorcol; default: [0 0 1] (i.e spm cursor color)
p.cursorwidth=0.1;          % cursor width; default: 0.5
p.showparams =0;            % display parameter; {0,1}; default: 0
p.panel      =1;            %make one panel
p.cblabel    ='' ;          %colorbar-label
p.saveres=300 ;            %imageResolution fpr saving figure
p.labelcol  ='w'      ;    %labelcolor
p.bgcol     =[0 0 0]  ;     %backgroundcolor

p.axolperc   =5   ;           %axoverlap in percent
p.legendgap = 0   ;       %gap to legend (default is -10)
p.bgremove=1             ;%remove background

p.maxsearchradius=2   ;% search radius in mm to obtain maximum
p.close          =0   ; %close figure afterwards [0|1]
p.hide           =0   ; %hide figure  [0|1]
p.saveas          =''  ;%fullpath name to save as png
p.dosave          =0;

p.mosaic_info    ='---mosaic----';
p.msliceidx  = 'n10'         ;%mosaic: sliceindices to plot: example  'n20', '5' ,[10:20] or '3 10 10
p.mslicemm   =[]             ;%mosaic: alternative: vec with mm-values  -->this slices will be plotted
p.mdim       =2              ;%mosaic: dimension to plot [1,2 or 3]
p.mroco      =[nan nan]      ;%mosaic: number of rows and columns (default: [nan nan]); example: [2 nan] or [nan 5]
p.mlabelshow =1              ;%mosaic: show mm-labels  {0,1}
p.mlabelfs   =8              ;%mosaic: mm-labels fontsize
p.mlabelfmt  ='%2.2f'        ;%mosaic: mm-labels format
p.mlabelcol  =repmat(.5,[1 3]);           ;%mosaic: color of mm-labels
p.mcbarpos   =[-60  20 10 100];%mosaic: cbar-positon (pixels), 1st value is a x-offset relative to figwidth
p.mcbargap=70                ;% gap between cbars
p.mcbarfs =10              ; %fontsize cbar
p.mcbaralign=0  ;%mosaic: align cbar
p.mplotwidth =0.89           ;%mosaic: width of plot to allow space for colorbar; default: 0.9 (normalized units)



p.thresh=[]; % imageTreshold (by value -->via transparency)
p.visible=1; %visible image
p.cbarvisible=[1 1 1 1 1]; %visible cbar
p.mbarlabel='';
p.figwidth=720; %orthoview figure-width (pixels)


%---tests
% p.axolperc   =-50   ;           %axoverlap in percent
p.bgadjust   =1;

p.bgtransp=0; %saving: transparent background: {0|1};   (1) transparent background; default: 0
p.crop    =0; %saving: crop image {0|1};   (1) crop image; default: 0



%% ========[varinpit]=======================================
% disp(nargin)
% return
if nargin>1
    if length(varargin)==1  && isstruct(varargin{1})
        pin=varargin{1};
    else
        pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    end
    if isfield(pin,'mslicemm') && ~isempty(pin.mslicemm)
        p.msliceidx='';
    end
    p=catstruct(p,pin);
end
if p.showparams==1
    cprintf([0 .5 .8],[ '...PARAMETER'   '"\n']);
    disp(p);
end

% ==============================================
%%   post-stuff
% ===============================================
if exist('f') && ischar(f)
    hf=findobj(0,'tag','orthoview');
    if strcmp(f,'post')
        if isfield(p,'saveas') && p.dosave==1
            u=get(hf,'userdata');
            if nargin>1
                pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
                u.p=catstruct(u.p,pin);
                set(hf,'userdata',u);
            end
            
            varargout{1}=saveimg([],[],p.saveas);
            
        end
        return
    elseif strcmp(f,'getdefaults')
        varargout{1}=p;
        return
    end

end

if exist('f')==0
    hs=findobj(0,'tag','specs_gui');
    delete(hs);
    specs_gui([],[],p);
    return
end

% ==============================================
%%
% ===============================================
delete(findobj(0,'tag','orthoview'));
if exist('f')==1
    f=cellstr(f);
    p.f=f;
else
    p.f=[];
end

%% ===============================================
[p errmsg]=sanitycheck(p);
if errmsg==1
  return 
end

% pbk=p;
update(p);
if p.panel==1
    makeOnePanel(p)
    change_bgcolor();
%     update();

    
elseif p.panel==2
    msosaic(p);
    %mosaic_update();
    %     change_bgcolor();
end

varargout{1}=gcf;





% f = uimenu(gcf,'colormap','misc');
uimenu(gcf,'Label','settings','callback',{@openSpecs});

f = uimenu(gcf,'Label','misc');
uimenu(f,'Label','go to maximum','callback',{@setcordinate,'max'});
uimenu(f,'Label','go to minimum','callback',{@setcordinate,'min'});
uimenu(f,'Label','go to origin','callback',{@setcordinate,'origin'});
uimenu(f,'Label','go to closest maximum','callback',{@setcordinate,'closestmax'});
uimenu(f,'Label','go to closest minimum','callback',{@setcordinate,'closestmin'});
uimenu(f,'Label','show overlays','callback',{@showOverlays});
uimenu(f,'Label','zoom on/off','callback',{@zooming});
uimenu(f,'Label','zoom reset','callback',{@zooming_reset});
% uimenu(f,'Label','save as png','callback',{@saveimg});

%% ===[save]============================================
k=dbstack;
if length(k)>1 && ~isempty(regexpi2({k.name},'specs'))
    
    
else
    if isfield(p,'saveas') && ~isempty(p.saveas)  && p.dosave==1
        varargout{1}=saveimg([],[],p.saveas);
    end
    if isfield(p,'close') && p.close==1
        hf=findobj(0,'tag','orthoview');
        close(hf)
    end
    
end

return

function zooming(e,e2)
hf=findobj(0,'tag','orthoview');
w=zoom;
if strcmp(w.enable,'on')
    w.enable='off';
else
    w.enable='on';
end
function zooming_reset(e,e2)
hf=findobj(0,'tag','orthoview');
for i=1:3
    ax= findobj(hf,'tag',['ax' num2str(i)]);
%     i
    if ~isempty(ax)
        set(hf,'CurrentAxes',ax);
        set(gca,'xlimmode','auto','ylimmode','auto');
        zoom off
    end
end


function msosaic(p);

sub_mosaic(p);



return
%% ===============================================
'a'

cf
nslice=5
dim=2;

g={};
for i=1:length(p.f)
    [d ds]=getslices(p.f{1},dim,['10'],[],0 );
    g(i).d=d;
    g(i).ds=ds;
    if i>1% length(p.f)==2
        [o os]=getslices(p.f([1 i])   ,dim,['10'],[],0 );
        g(i).d=o;
        g(i).ds=os;
    end
end
% ===============================================
for i=1:length(g)
    g(i).d=montageout(permute(g(i).d,[1 2 4 3 ]));
    if dim==2; g(i).d=flipdim(g(i).d,1); end
    
end



%% ===============================================



fg,imagesc(g(1).d)
fg,imagesc(g(2).d)

%% ===============================================
hf=findobj(0,'tag','orthoview');
if isempty(hf)
    figvisible='on';
    if p.hide~=0 ; figvisible='off';     end
    figure('visible',figvisible,'units','normalized','tag','orthoview','numbertitle','off','color','w')
    %     fg;  set(gcf,'units','normalized','tag','orthoview','numbertitle','off');
    fpos=get(gcf,'position');
    set(gcf,'position', [0.4  fpos(2:end)  ]);
    hf=gcf;
end




%% ===============================================




function changecolormap(e,e2)

hs=findobj(0,'tag','specs_gui');
hl=findobj(hs,'tag','colormaps');
maps=get(hl,'userdata');
cmapname=maps{hl.Value};
cmap=getCMAP(cmapname);
figure(findobj(0,'tag','orthoview'))
colormap(cmap);
figure(hs);
hf=findobj(0,'tag','orthoview');
u=get(hf,'userdata');
u.p.cmap=cmapname;
set(hf,'userdata',u);


function p=specs_getparameter

%% ===============================================

hs=findobj(0,'tag','specs_gui');

p=struct();

%=======parameter========================================
if 0
    p.clim     = str2num(get(findobj(hs,'tag','clims'),'string'));
    p.fs       = str2num(get(findobj(hs,'tag','fontsize'),'string'));
    p.cblabel  =       (get(findobj(hs,'tag','cbarlabel'),'string'));
    p.labelcol = str2num(get(findobj(hs,'tag','cbarlabelcolor'),'string'));
    if isempty(p.labelcol)
        p.labelcol = (get(findobj(hs,'tag','cbarlabelcolor'),'string'));
    end
    
    p.cursorwidth = str2num(get(findobj(hs,'tag','crosshairswidth'),'string'));
    p.cursorcol   = str2num(get(findobj(hs,'tag','crosshairscolor'),'string'));
    if isempty(p.cursorcol)
        p.cursorcol = (get(findobj(hs,'tag','crosshairscolor'),'string'));
    end
    
    p.alpha      =str2num(get(findobj(hs,'tag','alpha'),'string'));
    p.blobthresh =str2num(get(findobj(hs,'tag','blobthresh'),'string'));
    
    p.axolperc  = str2num(get(findobj(hs,'tag','axoverlapp'),'string'));
    p.legendgap = str2num(get(findobj(hs,'tag','legendgap'),'string'));
    p.bgcol =str2num(get(findobj(hs,'tag','bgcolor'),'string'));
    if isempty(p.bgcol)
        p.bgcol = (get(findobj(hs,'tag','bgcolor'),'string'));
    end
end
%=======colormap========================================
% hco=findobj(hs,'tag','colormaps');
% cmapnames=get(hco,'userdata');
% p.cmap= cmapnames{hco.Value};

function imageprops_guiupdate_loadimage(num)



hs=findobj(0,'tag','specs_gui');
namesfp={
    get(findobj(hs,'tag','select_bgimage'),'string')
    get(findobj(hs,'tag','select_fgimage1'),'string')
    get(findobj(hs,'tag','select_fgimage2'),'string')
    get(findobj(hs,'tag','select_fgimage3'),'string')
    get(findobj(hs,'tag','select_fgimage4'),'string')
    };
namesfp(find(cellfun(@isempty,namesfp)))=[];
names={};
for i=1:length(namesfp)
    [pax namx ext]=fileparts(namesfp{i});
    names{i,1}=[ namx ext];
end
hl=findobj(hs,'tag','prp_filename');
if isempty(names)
    names={'<empty>'};
end
set(hl,'string',names,'value',num+1);


hf=findobj(0,'tag','orthoview');
% if plot-image is empty --make structure

% if isempty(hf)
%% ===============================================

v=get(hs,'userdata');
if isempty(v); v=struct(); end
v.alpha(1, num+1)=1 ;
v.clim(num+1, :)=[nan nan] ;
v.clim(num+1, :)=[nan nan] ;
v.thresh(num+1, :)=[nan nan] ;
v.mbarlabel{1,num+1}='';

%      end
%     if isfield(v,'cmap')==0  ;
if num==0;       v.cmap(1,1)    ={'gray'}  ;
elseif num==1;       v.cmap(1,num+1)={'jet'}  ;
elseif num==2;       v.cmap(1,num+1)={'copper'}  ;
elseif num==3;       v.cmap(1,num+1)={'hot'}  ;
elseif num==4;       v.cmap(1,num+1)={'winter'}  ;
end


v.visible(1, num+1)=1 ;
v.cbarvisible(1, num+1)=1 ;

% v
%% ===============================================
% v
%     alpha
%     clim
%thresh
%     cmap%
% visible
set(hs,'userdata',v);
% v

% end


%% ===============================================
function imageprops_guiupdate

hf=findobj(0,'tag','orthoview');
hs=findobj(0,'tag','specs_gui');
u=get(hf,'userdata');
if isempty(u);
    
    p=get(hs,'userdata');
    if isempty(u) && isempty(p)
        return
    end
    hl=findobj(hs,'tag','prp_filename');
    i=hl.Value;
else
    p=u.p;
    
    v=get(hs,'userdata');
    if isempty(v)
        v.thresh      =p.thresh;
        v.clim        =p.clim;
        v.alpha       =p.alpha;
        v.visible     =p.visible;
        v.cbarvisible =p.cbarvisible;
        v.cmap        =p.cmap;
        v.mbarlabel   =p.mbarlabel;
        set(hs,'userdata',v);
    end
    
    
    hl=findobj(hs,'tag','prp_filename');
    hl.String{hl.Value};
    if strcmp(hl.String{hl.Value},'<empty>');
        names={};
        for i=1:length(p.f)
            [pax namx ext]=fileparts(p.f{i});
            names{i,1}=[ namx ext];
        end
        set(hl,'string',names,'value',1);
        i=1;
    else
        i=hl.Value;
    end
end


p=get(hs,'userdata');


%visible
hv=findobj(hs,'tag', 'prp_visible');
set(hv,'value', p.visible(i)) ;

%visible
hv=findobj(hs,'tag', 'prp_cbarvisible');
set(hv,'value', p.cbarvisible(i)) ;

%alpha
hv=findobj(hs,'tag', 'prp_alpha');
set(hv,'string', num2str(p.alpha(i))) ;
%clims
hv=findobj(hs,'tag', 'prp_clims');
set(hv,'string', num2str( p.clim(i,:)  )) ;
%thresh
hv=findobj(hs,'tag', 'prp_thresh');
set(hv,'string', num2str( p.thresh(i,:)  )) ;
%cmap
hv=findobj(hs,'tag', 'prp_cmap');
if isnumeric(p.cmap)
    set(hv,'value', p.cmap(i) );
elseif iscell(p.cmap)
    set(hv,'value', min(find(strcmp(get(hv,'userdata'), p.cmap{i}))) );
end

hv=findobj(hs,'tag', 'prp_label');
set(hv,'string', num2str( p.mbarlabel{i}  )) ;
%cmap

function imageprops(e,e2,imnum)
% imnum
hs=findobj(0,'tag','specs_gui');
hl=findobj(hs,'tag', 'prp_filename');

if imnum<=length(hl.String)
    set(hl,'value',imnum);
    imageprops_guiupdate();
end


function prp_cb(e,e2, task,item)

hf=findobj(0,'tag','orthoview');
hs=findobj(0,'tag','specs_gui');
u=get(hf,'userdata');
% task
if strcmp(task,'image')
    imageprops_guiupdate();
elseif strcmp(task,'update_pstruct')
    %% ===============================================
    
    hl=findobj(hs,'tag', 'prp_filename');
    i=hl.Value;
    v=get(hs,'userdata');
    
    
    %visible
    hv=findobj(hs,'tag', 'prp_visible');
    v.visible(i)=get(hv,'value');
    
    %cbarvisible
    hv=findobj(hs,'tag', 'prp_cbarvisible');
    v.cbarvisible(i)=get(hv,'value');
    %alpha
    hv=findobj(hs,'tag', 'prp_alpha');
    v.alpha(i)=str2num(get(hv,'string'));
    
    %clims
    hv=findobj(hs,'tag', 'prp_clims');
    try
        v.clim(i,:)=str2num(get(hv,'string'));
    catch
        v.clim(i,:)=[nan nan];
    end
    %thresh
    hv=findobj(hs,'tag', 'prp_thresh');
    try
        v.thresh(i,:)=str2num(get(hv,'string'));
    catch
        v.thresh(i,:)=[nan nan];
    end
    
    %cmap
    hv=findobj(hs,'tag', 'prp_cmap');
    if isnumeric(v.cmap)
        % set(hv,'value', p.cmap(i) );
        v.cmap(i)=get(hv,'value');
    elseif iscell(v.cmap)
        ox=get(hv,'userdata');
        v.cmap{i}=ox{hv.Value};
    end
    
    hv=findobj(hs,'tag', 'prp_label');
    v.mbarlabel{1,i}=(get(hv,'string'));
    
    %     disp(v);
    
    set(hs,'userdata',v);
    fast_update(item);
    %% ===============================================
    
end


function fast_update(item)
%% ===============================================
% disp(['fast_update: '  item]);
hf=findobj(0,'tag','orthoview');
hs=findobj(0,'tag','specs_gui');

v=get(hs,'userdata');
u=get(hf,'userdata');
u.p=catstruct(u.p,v);
set(hf,'userdata',u);

hl=findobj(hs,'tag', 'prp_filename');
no=hl.Value;





him2=findobj(hf,'tag',['im' num2str(no)]);

if strcmp(item,'bla')
    
elseif strcmp(item,'cbarlabel')
    hc=findobj(hf,'tag',['cbar' num2str(no)]);
    set(hc.YLabel,'string',  u.p.mbarlabel{no}  );
elseif strcmp(item,'####    alpha')
    %     figure(hf); update(u.p);
    for i=1:length(him2)
        a=get(him2(i),'AlphaData');
        uni=unique(a); uni(uni==0)=[];
        if isempty(uni);
            
        else
            a(a==uni)=u.p.alpha(no);
        end
        set(him2(i),'AlphaData',a);
    end
elseif strcmp(item,'visible')
    tx={0  'off'
        1  'on'};
    for i=1:length(him2)
        set(him2(i),'visible', tx{u.p.visible(no)+1,2});
        hc=findobj(hf,'tag',['cbar' num2str(no)]);
        hba=findobj(hc,'type','image');
        set(hc ,'visible',tx{u.p.visible(no)+1,2});
        set(hba,'visible',tx{u.p.visible(no)+1,2});
    end
elseif strcmp(item,'cbarvisible')
    tx={0  'off'
        1  'on'};
    for i=1:length(him2)
        hc=findobj(hf,'tag',['cbar' num2str(no)]);
        hba=findobj(hc,'type','image');
        set(hc ,'visible',tx{u.p.cbarvisible(no)+1,2});
        set(hba,'visible',tx{u.p.cbarvisible(no)+1,2});
    end
    
elseif strcmp(item,'cmap')   || strcmp(item,'clims')  || strcmp(item,'thresh') || strcmp(item,'alpha')
    if u.p.panel==1
        
            figure(hf); update(u.p);
        % %         return
        lims=u.p.clim(no,:);
         inan=isnan(lims);
        if sum(inan)>0
            w=[u.gx{no}(1).a(:); u.gx{no}(2).a(:) ;u.gx{no}(3).a(:)];
            lims3=[min(w) max(w)];
            if inan(1)==1; lims(1)=min(lims3(:)); end
            if inan(2)==1; lims(2)=max(lims3(:)); end
            if lims(1)==lims(2); lims(2)=lims(1)+eps; end
            if isnan(lims(1)); lims=[0 0+eps]; end
        end
       
        
      %% ===============================================
      
        
        lims3=[];
         for i=1:length(him2)
            himx=him2(i);
            set(hf,'CurrentAxes',get(himx,'parent'));
            axes(get(himx,'parent'));
            unfreezeColors(himx); 
             caxis(lims)
%              drawnow;
%             bb=himx.CData;
            if iscell(u.p.cmap)
                mapname=u.p.cmap{no};
                map=getCMAP(mapname);
            else
                map=getCMAP(u.p.cmap(no));
            end
            % colormap(jet);
            %colormap(map); drawnow;drawnow;
            hc=findobj(hf,'tag',['cbar' num2str(no)]);
%             b=himx.CData; b=b(:); b(isnan(b))=[];
%             curlim=[nan nan];
%             rmin=min(b);
%             rmax=max(b);
%             if ~isempty(rmin); curlim(1)=rmin; end
%             if ~isempty(rmax); curlim(2)=rmax; end
%             lims3(i,:)=curlim;
             colormap(map);    drawnow;
%              caxis(lims)
%             caxis(lims);
             freezeColors;
         end  
         %% ===============================================
         
         
%          lims=u.p.clim(no,:);
%          inan=isnan(lims);
%          if sum(inan)>0
%              
%              if inan(1)==1; lims(1)=min(lims3(:)); end
%              if inan(2)==1; lims(2)=max(lims3(:)); end
%              if lims(1)==lims(2); lims(2)=lims(1)+eps; end
%              if isnan(lims(1)); lims=[0 0+eps]; end
%          end
                 
            
            hba=findobj(hc,'type','image');
            map3=cat(3,map(:,1),map(:,2),map(:,3) );
            set(hba,'cdata', map3);
            set(hba,'ydata' ,lims);
            set(hc,'ylim'   ,lims);
         
        
        
        
        
        
        
    else
        
        
        for i=1:length(him2)
            himx=him2(i);
            axes(get(himx,'parent'));
            unfreezeColors(himx); drawnow;
            bb=himx.CData;
            if iscell(u.p.cmap)
                mapname=u.p.cmap{no};
                map=getCMAP(mapname);
            else
                map=getCMAP(u.p.cmap(no));
            end
            % colormap(jet);
            colormap(map); drawnow;drawnow;
            hc=findobj(hf,'tag',['cbar' num2str(no)]);
            lims=u.p.clim(no,:);
            inan=isnan(lims);
            if sum(inan)>0
                b=himx.CData; b=b(:); b(isnan(b))=[];
                if inan(1)==1; lims(1)=min(b); end
                if inan(2)==1; lims(2)=max(b); end
                if lims(1)==lims(2); lims(2)=lims(1)+eps; end
                if isnan(lims(1)); lims=[0 0+eps]; end
            end
            caxis(lims);
            freezeColors;
            
            hba=findobj(hc,'type','image');
            map3=cat(3,map(:,1),map(:,2),map(:,3) );
            set(hba,'cdata', map3);
            set(hba,'ydata' ,lims);
            set(hc,'ylim'   ,lims);
            
            thresh=u.p.thresh(no,:);
            w=get(himx,'userdata');
            if isempty(w)
                set(himx,'userdata',himx.AlphaData)
            end
            
            a=get(himx,'userdata') ;%him2.AlphaData;
            %% ===============================================
            
            %a=w;%get(him2(i),'AlphaData');
            uni=unique(a); uni(uni==0)=[];
            if isempty(uni);
                
            else
                a(a==uni)=u.p.alpha(no);
            end
            %set(him2(i),'AlphaData',a);
            %% ===============================================
            
            
            
            if ~isnan(thresh(1))
                a(bb<thresh(1))=0;
            end
            if ~isnan(thresh(2))
                a(bb>thresh(2))=0;
            end
            himx.AlphaData=a;
            
        end
    end
    %     figure(hf); update(u.p);
    
end
figure(hs);


%% ===============================================




function specs_gui(e,e2,p)
delete(findobj(0,'tag','specs_gui'));

if ~isempty(findobj(0,'tag','specs_gui'))
    specsUpdate();
    return
end
%% ===============================================

global oslice
if isempty(oslice)
    [o o2]=getCMAP;
    oslice.o =o;
    oslice.o2=o2;
else
    o=oslice.o;
    o2=oslice.o2;
    
end


% ===============================================
fg

set(gcf,'units','normalized','menubar','none','name','settings','numbertitle','off');
set(gcf,'tag','specs_gui');
set(gcf,'position',[0.1333    0.1889    0.19   0.6433]);

h = uitabgroup(gcf);
set(h,'tag','tabgroup')

% ________________________________________________________________________________________________
t0 = uitab(h, 'title', 'files');

% *** bgimage
hb=uicontrol(t0, 'style','pushbutton','units','norm',...
    'position', [0     0.9474 0.15 0.03],     'string','BG>>');
set(hb,'HorizontalAlignment','left','backgroundcolor','w');
set(hb,'callback',{@specs, 'pb_select_bgimage' });
set(hb,'tooltipstring','select background image');

hb=uicontrol(t0, 'style','edit','units','norm','tag','select_bgimage');
set(hb,'position',[0.15 0.9474 0.75 0.03]);
set(hb,'callback',{@specs, 'select_bgimage' });
set(hb,'HorizontalAlignment','right');

%push-props
hb=uicontrol(t0, 'style','pushbutton','units','norm','tag',['prop_image' num2str(1)] );
set(hb,'position',[0.9 .9474 0.05 0.03],'string','P');
set(hb,'tooltipstring','image properties');
set(hb,'callback',{@imageprops, 1},'backgroundcolor','w');
%push-delete
hb=uicontrol(t0, 'style','pushbutton','units','norm','tag',['del_image' num2str(1)] );
set(hb,'position',[0.95 .9474 0.05 0.03],'string','x','foregroundcolor','r');
set(hb,'callback',{@deleteimage, 1},'backgroundcolor','w');

% *** FGimage
down=0.0311;
for i=1:4
    hb=uicontrol(t0, 'style','pushbutton','units','norm',...
        'position', [0     0.9163-down*(i-1) 0.15 0.03],        'string',['Fg' num2str(i) '>>']);
    set(hb,'HorizontalAlignment','left','backgroundcolor','w');
    set(hb,'callback',{@specs, 'pb_select_fgimage' });
    set(hb,'tooltipstring',['select foreground image #' num2str(i)  ]);
    set(hb,'userdata', i);
    
    hb=uicontrol(t0, 'style','edit','units','norm','tag',['select_fgimage' num2str(i)] );
    set(hb,'position',[0.15 0.9163-down*(i-1) 0.75 0.03]);
    set(hb,'callback',{@specs, 'select_fgimage' });
    set(hb,'HorizontalAlignment','right');
    set(hb,'userdata', i);
    
    %push-props
    hb=uicontrol(t0, 'style','pushbutton','units','norm','tag',['prop_image' num2str(i+1)] );
    set(hb,'position',[0.9 0.9163-down*(i-1) 0.05 0.03],'string','P');
    set(hb,'callback',{@imageprops, i+1 },'backgroundcolor','w');
    set(hb,'tooltipstring','image properties');
    
    %push-delete
    hb=uicontrol(t0, 'style','pushbutton','units','norm','tag',['del_image' num2str(i+1)] );
    set(hb,'position',[0.95 0.9163-down*(i-1) 0.05 0.03],'string','x','foregroundcolor','r');
    set(hb,'callback',{@deleteimage, i+1},'backgroundcolor','w');
end

% =======image parameter========================================

% image
hb=uicontrol(t0, 'style','text','units','norm' );
set(hb,'string','image');
set(hb,'position',[0 0.75 0.25 0.025]);
set(hb,'horizontalalignment','left');

hb=uicontrol(t0, 'style','popupmenu','units','norm','tag',['prp_filename'] );
set(hb,'string',{'<empty>'});
set(hb,'position',[0.12 .75 .75 .025]);
set(hb,'tooltipstring','select file --> properties');
set(hb,'callback',{@prp_cb, 'image' })



% alpha
hb=uicontrol(t0, 'style','text','units','norm' );
set(hb,'string','alpha');
set(hb,'position',[0 0.715 0.25 0.025]);
set(hb,'horizontalalignment','right');
%-----------------
hb=uicontrol(t0, 'style','edit','units','norm','tag',['prp_alpha'] );
set(hb,'string','1');
set(hb,'position',[0.25 0.715 0.2 0.025]);
set(hb,'tooltipstring','transparency/alpha (0-1)');
set(hb,'callback',{@prp_cb,'update_pstruct','alpha'});


% clims
hb=uicontrol(t0, 'style','text','units','norm' );
set(hb,'string','clims');
set(hb,'position',[0     0.6900 0.25 0.025]);
set(hb,'tooltipstring','transparency/alpha (0-1)');
set(hb,'horizontalalignment','right')
%-----------------
hb=uicontrol(t0, 'style','edit','units','norm','tag',['prp_clims'] );
set(hb,'string','nan nan');
set(hb,'position',[0.25  0.6900 0.7 0.025]);
set(hb,'tooltipstring','color limit range [min max]');
set(hb,'callback',{@prp_cb,'update_pstruct','clims'});


%thresh
hb=uicontrol(t0, 'style','text','units','norm' );
set(hb,'string','range');
set(hb,'position',[0     0.6650 0.25 0.025]);
set(hb,'horizontalalignment','right');
%-----------------
hb=uicontrol(t0, 'style','edit','units','norm','tag',['prp_thresh'] );
set(hb,'string','nan nan');
set(hb,'position',[0.25  0.6650 0.7 0.025]);
set(hb,'tooltipstring','upper lower threshold [min max]');
set(hb,'callback',{@prp_cb,'update_pstruct','thresh'});



%cmap
hb=uicontrol(t0, 'style','text','units','norm' );
set(hb,'string','cmap');
set(hb,'position',[0     0.6400 0.25 0.025]);
set(hb,'horizontalalignment','right');
%-----------------
hb=uicontrol(t0, 'style','popupmenu','units','norm','tag',['prp_cmap'] );
set(hb,'string','nan nan');
set(hb,'position',[0.25  0.6400 0.75 0.025]);
set(hb,'tooltipstring','colormap');
set(hb,'string',o2,'value',1)
set(hb,'userdata',o);
set(hb,'callback',{@prp_cb,'update_pstruct','cmap'});


%cbarlabel
hb=uicontrol(t0, 'style','text','units','norm' );
set(hb,'string','label');
set(hb,'position',[0     0.60882 0.25 0.025]);
set(hb,'horizontalalignment','right');
%-----------------
hb=uicontrol(t0, 'style','edit','units','norm','tag',['prp_label'] );
set(hb,'string','');
set(hb,'position',[0.25  0.60882 0.7 0.025]);
set(hb,'tooltipstring','cbar-label');
set(hb,'callback',{@prp_cb,'update_pstruct','cbarlabel'});

%visible
hb=uicontrol(t0, 'style','radio','units','norm','tag',['prp_visible'] );
set(hb,'string','visible','value',1);
set(hb,'position',[0.16465 0.57082 0.5 0.025]);
set(hb,'tooltipstring','image visible');
set(hb,'callback',{@prp_cb,'update_pstruct','visible'});

%cbatvisible
hb=uicontrol(t0, 'style','radio','units','norm','tag',['prp_cbarvisible'] );
set(hb,'string','cbar-visible','value',1);
set(hb,'position',[0.43877 0.57082 0.5 0.025]);
set(hb,'tooltipstring','cbar visible');
set(hb,'callback',{@prp_cb,'update_pstruct','cbarvisible'});

% set(hb,'callback',@changecolormap);


% ===============================================


% hb=uicontrol(t0, 'style','pushbutton','units','norm','tag','pb_select_fgimage');
% set(hb,'position',[0.85 0.8078 0.06 0.03],'string','>>');
% set(hb,'callback',{@specs, 'pb_select_fgimage' });

% upper-separationLine
hb=uicontrol(t0, 'style','pushbutton','units','norm');
set(hb,'position',[0 0.8 1 0.005],'string','','backgroundcolor','r');

% middle-separationLine
% hb=uicontrol(t0, 'style','pushbutton','units','norm');
% set(hb,'position',[0 0.56219 1 0.005],'string','','backgroundcolor','r');

% lower-separationLine
hb=uicontrol(t0, 'style','pushbutton','units','norm');
set(hb,'position',[0 0.52592 1 0.005],'string','','backgroundcolor','r');

%plot orthoview
hb=uicontrol(t0, 'style','pushbutton','units','norm','tag','pb_loadimages');
set(hb,'position',[0.09886 0.5311 0.4 0.03],'string','plot orthoView');
set(hb,'fontweight','bold','foregroundcolor','b')
set(hb,'callback',{@specs, 'loadimages_ortho' });
set(hb,'tooltipstring','load images plot orthoview');
%plot mosiac
hb=uicontrol(t0, 'style','pushbutton','units','norm','tag','pb_loadimages');
set(hb,'position',[0.52284 0.5311 0.4 0.03],'string','plot mosaic');
set(hb,'fontweight','bold','foregroundcolor','b')
set(hb,'callback',{@specs, 'loadimages_mosaic' });
set(hb,'tooltipstring','load images plot mosaic');
% ==============================================
%   uitable general
% ===============================================

tb={'1'  3
    '2'  '3'};
tb=repmat(tb,[10,1]);
tbh={'  parameter                       ' '  value                         '};
shift=-0.08;
% shift=-0.12;
t = uitable('Parent', t0,'units','norm', 'Position', [shift 0.12 1-shift .4 ], 'Data', tb,...
    'tag','tb1',...
    'ColumnWidth','auto');
t.ColumnName =tbh;
t.ColumnEditable =logical([false true  ] ) ;% [false true  ];
t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];
set(t,'CellEditCallback'     , @table1_updatestruct);
set(t,'CellSelectionCallback', @table1_updatestructSelection);


% save image  ===============================
% pb-select png-file
hb=uicontrol(t0, 'style','pushbutton','units','norm',...
    'position', [0.0038304 0.073389 0.3 0.03],     'string','png-name >>');
set(hb,'HorizontalAlignment','left','backgroundcolor','w');
set(hb,'callback',{@specs, 'pb_saveName' });
set(hb,'tooltipstring','select  png-name');

% ed-png-name
hb=uicontrol(t0, 'style','edit','units','norm','tag','saveName');
set(hb,'position',[0.305 0.073389 0.69 0.03]);
set(hb,'callback',{@specs, 'saveName' });
set(hb,'HorizontalAlignment','right');

% string-resolution
hb=uicontrol(t0, 'style','text','units','norm','position', [-0.11313 0.042299 0.3 0.03],...
    'string','resolution');
set(hb,'HorizontalAlignment','right');
%edit-res
hb=uicontrol(t0, 'style','edit','units','norm','tag','resolution');
set(hb,'position',[0.2012 0.042299 0.3 0.03]);
set(hb,'callback',{@specs, 'resolution' });
set(hb,'tooltipstring','image resolution to save');

%pb-save png
hb=uicontrol(t0, 'style','pushbutton','units','norm',...
    'position', [0.1     0.001 0.4 0.03],     'string','save png-image');
set(hb,'HorizontalAlignment','left','backgroundcolor','w');
set(hb,'callback',{@specs, 'pb_saveImage' });
set(hb,'tooltipstring','save as png-image','foregroundcolor','b','fontweight','bold');



%pb-save png
hb=uicontrol(t0, 'style','pushbutton','units','norm',...
    'position', [0.6     0.001 0.4 0.03],     'string','get code');
set(hb,'HorizontalAlignment','left','backgroundcolor','w');
set(hb,'callback',{@getcode });
set(hb,'tooltipstring','get code to rerun','foregroundcolor','b','fontweight','bold');
% ________________________________________________________________________________________________


if 0
    
    t2 = uitab(h, 'title', 'paras');
    
    % hb=uicontrol(t2, 'style','text','units','norm','position', [0 0.92 0.3 0.03],'string','colorlimits');
    % set(hb,'HorizontalAlignment','right');
    % hb=uicontrol(t2, 'style','edit','units','norm','tag','clims');
    % set(hb,'position',[0.35 0.9241 0.3 0.03]);
    % set(hb,'callback',@setClims_cb);
    
    % ________________________________________________________________________________________________
    
    % fontsize
    hb=uicontrol(t2, 'style','text','units','norm','position', [0     0.8926 0.3 0.03],'string','fontsize');
    set(hb,'HorizontalAlignment','right');
    hb=uicontrol(t2, 'style','edit','units','norm','tag','fontsize');
    set(hb,'position',[0.35 0.8926 0.3 0.03]);
    set(hb,'callback',{@specs, 'fontsize' });
    set(hb,'tooltipstring','set fontsize');
    
    % *** cbar label-label
    % hb=uicontrol(t2, 'style','text','units','norm','position', [0     0.8652 0.3 0.03],'string','cbar-label');
    % set(hb,'HorizontalAlignment','right');
    % hb=uicontrol(t2, 'style','edit','units','norm','tag','cbarlabel');
    % set(hb,'position',[0.35 0.8652 0.3 0.03]);
    % set(hb,'callback',{@specs, 'cbarlabel' });
    % set(hb,'tooltipstring','define colorbar label');
    
    
    % *** cbar-color
    hb=uicontrol(t2, 'style','text','units','norm','position', [0     0.8378 0.3 0.03],'string','cbar-label-color');
    set(hb,'HorizontalAlignment','right');
    hb=uicontrol(t2, 'style','edit','units','norm','tag','cbarlabelcolor');
    set(hb,'position',[0.35 0.8378 0.5 0.03]);
    set(hb,'callback',{@specs, 'cbarlabelcolor' });
    set(hb,'tooltipstring','color of colorbar-label (rgb-tripple or k,w,g,b,r)');
    
    hb=uicontrol(t2, 'style','pushbutton','units','norm','tag','pb_cbarlabelcolor');
    set(hb,'position',[0.85 0.8378 0.06 0.03],'string','col');
    set(hb,'callback',{@specs, 'cbarlabelcolor_getcolor' });
    set(hb,'tooltipstring','select color of colorbar-label');
    
    
    % *** crosshaours-width
    hb=uicontrol(t2, 'style','text','units','norm','position', [0     0.7 0.3 0.03],'string','crosshairs-width');
    set(hb,'HorizontalAlignment','right');
    hb=uicontrol(t2, 'style','edit','units','norm','tag','crosshairswidth');
    set(hb,'position',[0.35 0.7 0.3 0.03]);
    set(hb,'callback',{@specs, 'crosshairswidth'});
    set(hb,'tooltipstring','set linewidth of crosshairs , use 0 to hide crosshairs');
    
    
    % *** crosshaours-color
    hb=uicontrol(t2, 'style','text','units','norm','position', [0     0.6726 0.3 0.03],'string','crosshairs-color');
    set(hb,'HorizontalAlignment','right');
    hb=uicontrol(t2, 'style','edit','units','norm','tag','crosshairscolor');
    set(hb,'position',[0.35 0.6726 0.5 0.03]);
    set(hb,'callback',{@specs, 'crosshairscolor' });
    set(hb,'tooltipstring','color of crosshairs (rgb-tripple or k,w,g,b,r)');
    
    hb=uicontrol(t2, 'style','pushbutton','units','norm','tag','pb_crosshairscolor');
    set(hb,'position',[0.85 0.6726 0.06 0.03],'string','col');
    set(hb,'callback',{@specs, 'pb_crosshairscolor' });
    set(hb,'tooltipstring','select color of crosshairs ');
    
    
    % % *** alpha
    % hb=uicontrol(t2, 'style','text','units','norm','position', [0  0.3 0.3 0.03],...
    %     'string','transparency');
    % set(hb,'HorizontalAlignment','right');
    % hb=uicontrol(t2, 'style','edit','units','norm','tag','alpha');
    % set(hb,'position',[0.35 0.3 0.3 0.03]);
    % set(hb,'callback',{@specs, 'alpha'});
    % set(hb,'tooltipstring','set transparency of overlay image, range: 0-1');
    %
    % % blobthresh
    % hb=uicontrol(t2, 'style','text','units','norm','position', [0  0.27 0.3 0.03],...
    %     'string','blobthresh');
    % set(hb,'HorizontalAlignment','right');
    % hb=uicontrol(t2, 'style','edit','units','norm','tag','blobthresh');
    % set(hb,'position',[0.35 0.27 0.3 0.03]);
    % set(hb,'callback',{@specs, 'blobthresh'});
    % set(hb,'tooltipstring','lower threshold of overlay image, default: empty');
    
    % ===============================================
    
    % *** axis-overlay
    hb=uicontrol(t2, 'style','text','units','norm','position', [0 0.09 0.3 0.03],'string','axis-overlapp');
    set(hb,'HorizontalAlignment','right');
    hb=uicontrol(t2, 'style','edit','units','norm','tag','axoverlapp');
    set(hb,'position',[0.35 0.09 0.5 0.03]);
    set(hb,'callback',{@specs, 'axoverlapp' });
    set(hb,'tooltipstring','operlapp of axes in percent (example, -10,0 or 10)');
    
    
    % *** legendgap
    hb=uicontrol(t2, 'style','text','units','norm','position', [0 0.06 0.3 0.03],'string','legend-gap');
    set(hb,'HorizontalAlignment','right');
    hb=uicontrol(t2, 'style','edit','units','norm','tag','legendgap');
    set(hb,'position',[0.35 0.06 0.5 0.03]);
    set(hb,'callback',{@specs, 'legendgap' });
    set(hb,'tooltipstring','gap between right axis and colorbar in pixels (example: 0,-10,20)');
    
    % *** background-color
    hb=uicontrol(t2, 'style','text','units','norm','position', [0  0.03 0.3 0.03],'string','bg-color');
    set(hb,'HorizontalAlignment','right');
    hb=uicontrol(t2, 'style','edit','units','norm','tag','bgcolor');
    set(hb,'position',[0.35 0.03 0.5 0.03]);
    set(hb,'callback',{@specs, 'bgcolor' });
    set(hb,'tooltipstring','background color (rgb-tripple or k,w,g,b,r)');
    
    hb=uicontrol(t2, 'style','pushbutton','units','norm','tag','pb_bgcolor');
    set(hb,'position',[0.85 0.03 0.06 0.03],'string','col');
    set(hb,'callback',{@specs, 'bgcolor_getcolor' });
    set(hb,'tooltipstring','select background color ');
    
    % *** remove background
    hb=uicontrol(t2, 'style','radio','units','norm','position', [0  0.0 0.5 0.03],...
        'string','remove background');
    set(hb,'HorizontalAlignment','right','tag','removebackground');
    set(hb,'callback',{@specs, 'removebackground' });
    
    
    % hb=uicontrol(t2, 'style','edit','units','norm','tag','bgcolor');
    
end

% =====MOSAIc==========================================
t4 = uitab(h, 'title', 'mosaic');

tb={'1'  3
    '2'  '3'};
tb=repmat(tb,[10,1]);
tbh={'  parameter                       ' '  value                         '};
shift=-0.08;
shift=-0.12;
t = uitable('Parent', t4,'units','norm', 'Position', [shift 0.2 1-shift .7 ], 'Data', tb,...
    'tag','mtable',...
    'ColumnWidth','auto');
t.ColumnName =tbh;
t.ColumnEditable =logical([false true  ] ) ;% [false true  ];
t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];

% set(t,'units','pixels')
%
% hTableExtent = get(t,'Extent');
% hTablePosition = get(t,'Position');
% set(t,'Position',[0 0 round(1.5*hTableExtent(3)) round(1.5*hTableExtent(4))]);
% % set(h,'position',[200 200 round(2*hTableExtent(3)) round(2*hTableExtent(4))]);

hb=uicontrol(t4, 'style','pushbutton','units','norm','tag','pb_loadimages');
set(hb,'position',[0.54477 0.93008 0.4 0.03],'string','plot mosaic');
set(hb,'fontweight','bold','foregroundcolor','b')
set(hb,'callback',{@specs, 'loadimages_mosaic' });
set(hb,'tooltipstring','load images plot mosaic');

set(t,'CellEditCallback', @mosaic_updatestruct);
% =======colormaps========================================
t3 = uitab(h, 'title', 'colormaps');
hb=uicontrol(t3, 'style','listbox','units','norm','position', [0 0 1 1],'tag','colormaps');
set(hb,'string',o2)
% set(hb,'callback',@changecolormap);
set(hb,'userdata',o);
% ===============================================


hs=findobj(0,'tag','specs_gui');
if length(hs)>1;  delete(hs(2:end)); hs=hs(1); end

hg=findobj(hs,'tag','tabgroup');
tabs=get(hg,'children');
% hg.SelectedTab=tabs(find(strcmp(get(tabs,'title'),'paras')));
% hg.SelectedTab=tabs(find(strcmp(get(tabs,'title'),'mosaic')));
hg.SelectedTab=tabs(find(strcmp(get(tabs,'title'),'files')));
%% ===============================================
hf=findobj(0,'tag','orthoview');
if isempty(hf)
    specsUpdate([],[],p) ;
else
    specsUpdate();
end
% id=selector2(b,{'colormap'},'iswait',1,'title','colormap')


function getcode(e,e2)
%% ===============================================

q=orthoslice('getdefaults');
hf=findobj(0,'tag','orthoview');
if isempty(hf);  disp('no images loaded ...abort'); return; end
u=get(hf,'userdata');
p=u.p;
files=p.f;
del={'f' 'qmm' 'val'};
for i=1:length(del)
   try; p=rmfield(p,del{i}); end
end
pn=fieldnames(p);

s=p;

for i=1:length(pn)
    pn{i};
    a=getfield(p,pn{i});
    b=getfield(q,pn{i});
    
    
    if size(a,1)==size(b,1) &&  size(a,2)==size(b,2) &&  strcmp(class(a),class(b))
%         if i==13
%            'a' 
%         end
       try % iscell(a)
            
     
            if double(a)==double(b)
                s=rmfield(s,pn{i});
            end
        end
    end
end

g.files=files;
r=struct2list2(g,'r');
t1=regexprep(r, 'r.files','files');
t2=struct2list2(s,'r');


c=[t1; 'r=[];' ; ;t2  ; 'orthoslice(files,r);' ];
disp('====================================================');
disp(char(c));

%% ===============================================





function deleteimage(e,e2,no)

hs=findobj(0,'tag','specs_gui');
imno=no-1;
if imno==0
    he=findobj(hs,'tag', ['select_bgimage'] );
else
    he=findobj(hs,'tag', ['select_fgimage' num2str(imno)] );
end
set(he,'string','');

imageprops_guiupdate_loadimage(0);
% imageprops_guiupdate();


function table1_updatestructSelection(e,e2)

if isempty(e2.Indices); return; end  % stop going inside again after modification

hs=findobj(0,'tag','specs_gui');
hf=findobj(0,'tag','orthoview');
ht=findobj(hs,'tag','tb1');
tbref=get(ht,'userdata');
tb=ht.Data;
idx=e2.Indices;
u=get(hf,'userdata');
vname=tbref{idx(1),3};
fname=tbref{idx(1),3};
chk={ 'labelcol' 'cursorcol' 'bgcol'};
if idx(2)>1; return; end
if isempty(find(strcmp(chk,fname))); return; end

col=uisetcolor;
col=regexprep(num2str(col),'\s+',' ');

tb=ht.Data;
tb{idx(1),2}=col;
ht.Data=tb;
u.p=setfield(u.p, vname,col);
set(hf,'userdata',u);
fastupdate_table1(idx(1));

function table1_updatestruct(e,e2)
hs=findobj(0,'tag','specs_gui');
hf=findobj(0,'tag','orthoview');
ht=findobj(hs,'tag','tb1');
tbref=get(ht,'userdata');
tb=ht.Data;
idx=e2.Indices;
u=get(hf,'userdata');
vname=tbref{idx(1),3};
val  =tb{idx(1),idx(2)};

tostring ={};%{'msliceidx' 'mlabelfmt'  };
undef    ={'mlabelcol' 'bgcol' 'cursorcol'};

if sum(sum(strcmp(tostring,vname)))>0
    % string here
elseif ~isempty(strcmp(undef,vname))
    dx=str2num(val);
    if ~isempty(dx);
        val=dx;
    end
else
    val=num2str(val);
end
u.p=setfield(u.p, vname,val);
set(hf,'userdata',u);

% getfield(u.p,vname)

fastupdate_table1(idx(1));


function fastupdate_table1(idx);
%% ===============================================

% idx
hs=findobj(0,'tag','specs_gui');
hf=findobj(0,'tag','orthoview');
ht=findobj(hs,'tag','tb1');
tbref=get(ht,'userdata');
u=get(hf,'userdata');
p=u.p;

fname=tbref{idx,3};
val=getfield(p,fname);

if strcmp(fname,'cursorwidth') || strcmp(fname,'cursorcol')
    hlin=findobj(hf,'type','line');
    if isempty(hlin); return; end
    if val>0.001
        set(hlin,'linewidth',p.cursorwidth,'visible','on','Color',p.cursorcol);
    else
        set(hlin,'visible','off','Color',p.cursorcol);
    end
elseif strcmp(fname,'mcbarfs') || strcmp(fname,'labelcol')
    hcs=findobj(hf,'userdata','cbar');
    set(hcs,'YColor',p.labelcol,'XColor',p.labelcol,'fontsize' , p.mcbarfs);
elseif strcmp(fname,'figwidth')
    if 1% p.panel==1
        unit=get(hf,'units');
        set(hf,'units','pixels');
        pos=get(hf,'position');
        pos(3)=p.figwidth;
        set(hf,'position',pos);
        set(hf,'units',unit);
        if p.panel==2
            newidx=find(strcmp(tbref(:,3),'mcbarpos'));
            fastupdate_table1(newidx);
        end
    end
elseif strcmp(fname,'bgcol')
    set(hf,'color',p.bgcol) ;
elseif strcmp(fname,'axolperc')
    %% ===============================================
    if p.panel==2; return; end
    hax=[
        findobj(hf,'tag','ax1');
        findobj(hf,'tag','ax2');
        findobj(hf,'tag','ax3')];
    for i=1:length(hax)
        set(hf,'CurrentAxes',hax(i));
        axpos(i,:)=get(hax(i),'position');
        %set(hax(i),'visible','on');
    end
    
    wid=axpos(:,3);
    overlepperc=p.axolperc;%20
    overlap=overlepperc/100;
    x0=[5 ;cumsum(round(wid-min(wid).*overlap))];
    
    % x0=[0 ;cumsum(round(wid-wid.*overlappix))]
    axpos2=axpos;
    axpos2(:,1)=x0(1:3);
    for i=1:length(hax)
        %axes(hax(i))
        set(hf,'CurrentAxes',hax(i));
        set(hax(i),'position',axpos2(i,:));
        %     set(gca,'visible','on')
    end
    %% ===============================================
    
    
    
elseif strcmp(fname,'mcbarpos') ||  strcmp(fname,'mcbargap')
    %% ===============================================
    fg_unit=get(hf,'units');
    set(hf,'units','pixels');
    figpos=get(hf,'position');
    set(hf,'units',fg_unit);
    xshift=p.mcbarpos(1);
    hcs=findobj(hf,'userdata','cbar');
    n=1;
    for i=length(hcs):-1:1
        hc= findobj(hf,'tag',['cbar' num2str(i)]);
        set(hc,'units','pixels');
        posb=[ figpos(3)+xshift-(p.mcbargap.*n)+p.mcbargap p.mcbarpos(2:end) ];
        set(hc,'position',posb);
        n=n+1;
        set(hc,'units','normalized');
        set(hc,'YColor',p.labelcol,'XColor',p.labelcol,'fontsize' , p.mcbarfs);
        %set([hc; get(hc,'children')],'visible','on')
        if ~isempty(p.mbarlabel{i})
            set(hc.YLabel,'string',p.mbarlabel{i});
        end
    end
    if 0 %p.panel==2
        hc= findobj(hf,'tag',['cbar1' ]);
        posb1=get(hc,'position');
        posf=get(ha,'position');
        set(ha,'position',[posf(1:2)  posb1(1)  posf(4) ]);
    end
    
end
%% ===============================================




function mosaic_updatestruct(e,e2)
%% ===============================================
hs=findobj(0,'tag','specs_gui');
hf=findobj(0,'tag','orthoview');
ht=findobj(hs,'tag','mtable');
tbref=get(ht,'userdata');
tb=ht.Data;
idx=e2.Indices;
u=get(hf,'userdata');
vname=tbref{idx(1),3};
val  =tb{idx(1),idx(2)};

tostring ={'msliceidx' 'mlabelfmt'  };
undef    ={'mlabelcol'};

if sum(sum(strcmp(tostring,vname)))>0
    % string here
elseif ~isempty(strcmp(undef,vname))
    dx=str2num(val);
    if ~isempty(dx);
        val=dx;
    end
    
else
    val=num2str(val);
end

u.p=setfield(u.p, vname,val);
set(hf,'userdata',u);

% disp(vname);
% disp(getfield(u.p, vname));


%% ===============================================

function specs(e,e2,task)
hf=findobj(0,'tag','orthoview');
hs=findobj(0,'tag','specs_gui');

% disp(task);
if strcmp(task,'cbarlabelcolor_getcolor');
    col=uisetcolor;
    u=get(hf,'userdata');
    u.p.labelcol=col;
    set(hf,'userdata',u);
    set(findobj(hs,'tag','cbarlabelcolor'), 'string',num2str(col) );
    cb=findobj(hf,'tag','cbar');
    set(cb,'color',col);
elseif strcmp(task,'alpha');
    val=str2num(get(findobj(hs,'tag','alpha'), 'string'));
    u=get(hf,'userdata');
    u.p.alpha=val;
    set(hf,'userdata',u);
    figure(hf);
    update(u.p)
elseif strcmp(task,'blobthresh');
    val=str2num(get(findobj(hs,'tag','blobthresh'), 'string'));
    u=get(hf,'userdata');
    u.p.blobthresh=val;
    set(hf,'userdata',u);
    figure(hf);
    update(u.p)
    
elseif strcmp(task,'pb_crosshairscolor');
    col=uisetcolor;
    set(findobj(hs,'tag','crosshairscolor'), 'string',num2str(col));
    u=get(hf,'userdata');
    u.p.cursorcol=col;
    set(hf,'userdata',u);
    hl=findobj(hf,'type','line');
    set(hl, 'color',u.p.cursorcol );
    
elseif strcmp(task,'crosshairscolor');
    col=get(findobj(hs,'tag','crosshairscolor'), 'string');
    u=get(hf,'userdata');
    u.p.cursorcol=col;
    set(hf,'userdata',u);
    hl=findobj(hf,'type','line');
    set(hl, 'color',u.p.cursorcol );
    
elseif strcmp(task,'crosshairswidth');
    he=findobj(hs,'tag','crosshairswidth');
    val=get(he,'string');
    val=str2num(val);
    if isempty(val); val=0.01; end
    if val<0.01; val=0.01; end
    u=get(hf,'userdata');
    u.p.cursorwidth=(val);
    set(hf,'userdata',u);
    
    hl=findobj(hf,'type','line');
    if u.p.cursorwidth>0.1
        set(hl,'visible','on','linewidth',u.p.cursorwidth );
    else
        set(hl,'visible','off' );
    end
    
    
elseif strcmp(task,'cbarlabelcolor');
    col=get(findobj(hs,'tag','cbarlabelcolor'), 'string');
    u=get(hf,'userdata');
    u.p.labelcol=col;
    set(hf,'userdata',u);
    cb=findobj(hf,'tag','cbar');
    set(cb,'color',col);
elseif strcmp(task,'bgcolor_getcolor');
    col=uisetcolor;
    set(findobj(hs,'tag','bgcolor'), 'string',num2str(col) );
    u=get(hf,'userdata');
    u.p.bgcol=col;
    set(hf,'userdata',u);
    change_bgcolor;
elseif strcmp(task,'bgcolor');
    col=get(findobj(hs,'tag','bgcolor'), 'string');
    col2=str2num(col);
    if ~isempty(col2); col=col2; end
    u=get(hf,'userdata');
    u.p.bgcol=col;
    set(hf,'userdata',u);
    change_bgcolor;
elseif strcmp(task,'removebackground');
    val=get(findobj(hs,'tag','removebackground'), 'value');
    u=get(hf,'userdata');
    u.p.bgremove=val;
    set(hf,'userdata',u);
    change_bgcolor;
    
    
    
elseif strcmp(task,'axoverlapp');
    u=get(hf,'userdata');
    u.p.axolperc=str2num(get(findobj(hs,'tag','axoverlapp'),'string'));
    set(hf,'userdata',u);
    panel_overlapp();
elseif strcmp(task,'legendgap');
    u=get(hf,'userdata');
    u.p.legendgap=str2num(get(findobj(hs,'tag','legendgap'),'string'));
    set(hf,'userdata',u);
    panel_overlapp();
elseif strcmp(task,'fontsize');
    u=get(hf,'userdata');
    u.p.fs=str2num(get(findobj(hs,'tag','fontsize'),'string'));
    set(hf,'userdata',u);
    cb=findobj(hf,'tag','cbar');
    set(cb,'fontsize',u.p.fs );
elseif strcmp(task,'cbarlabel');
    u=get(hf,'userdata');
    u.p.cblabel=(get(findobj(hs,'tag','cbarlabel'),'string'));
    set(hf,'userdata',u);
    cb=findobj(hf,'tag','cbar');
    set(cb.Label,'string', u.p.cblabel);
    
elseif strcmp(task,'select_bgimage');
    %loadimgages();
    hb=findobj(hs,'tag','select_bgimage');
    if isempty(get(hb,'string')); return; end
    hj = findjobj(hb);
    hj.setCaretPosition(hj.getDocument.getLength);
    imageprops_guiupdate_loadimage(0);
    imageprops_guiupdate();
    
elseif strcmp(task,'select_fgimage');
    num=get(e,'userdata');
    hb=findobj(hs,'tag',['select_fgimage' num2str(num) ]);
    if isempty(get(hb,'string')); return; end
    hj = findjobj(hb);
    hj.setCaretPosition(hj.getDocument.getLength);
    
    imageprops_guiupdate_loadimage(num);
    imageprops_guiupdate();
    
    
    
elseif strcmp(task,'pb_select_bgimage');
    %     [pa fi]=uigetfile({'*.nii;*.nii.gz'},'select Background-image')
    %    [t,sts] = spm_select(n,typ,  mesg,       sel,wd,filt,frames)
    [t,sts] = spm_select(1,'any','select BGimage','',pwd,'.*.nii|*.nii.gz',1);
    %[t,sts] = spm_select(1,'image','select BGimage','',pwd,'.*.nii|*.nii.gz',1);
    hb=findobj(hs,'tag','select_bgimage');
    set(hb,'string',t);
    hj = findjobj(hb);
    hj.setCaretPosition(hj.getDocument.getLength);
    
    imageprops_guiupdate_loadimage(0);
    imageprops_guiupdate();
    
elseif strcmp(task,'pb_select_fgimage');
    [t,sts] = spm_select(1,'any','select BGimage','',pwd,'.*.nii|*.nii.gz',1);
    %[t,sts] = spm_select(1,'image','select BGimage','',pwd,'.*.nii|*.nii.gz',1);
    num=get(e,'userdata');
    hb=findobj(hs,'tag',['select_fgimage' num2str(num) ]);
    set(hb,'string',t);
    hj = findjobj(hb);
    hj.setCaretPosition(hj.getDocument.getLength);
    
%    
    imageprops_guiupdate_loadimage(num);
    imageprops_guiupdate();
    if isempty(t); 
        hb=findobj(hs,'tag','prp_filename');
        hb.Value=length(hb.String);
        prp_cb([],[],'image');
    end
    
elseif strcmp(task,'loadimages_ortho');
    loadimgages('ortho');
elseif strcmp(task,'loadimages_mosaic');
    loadimgages('mosaic');
elseif strcmp(task,'resolution');
    u=get(hf,'userdata');
    u.p.saveres=str2num(get(findobj(hs,'tag','resolution'),'string'));
    set(hf,'userdata',u);
elseif strcmp(task,'pb_saveName');
    he=findobj(hs,'tag','saveName');
    file=get(he,'string');
    if isempty(file)
        [fi, pa] = uiputfile( ...
            {'*.png'},  'save as png');
    else
        [fi, pa] = uiputfile( ...
            {'*.png'},  'save as png',file);
    end
    file=fullfile(pa,fi);
    %
    set(he,'string',file);
    
    u=get(hf,'userdata');
    u.p.saveas=file;
    set(hf,'userdata',u);
    
elseif strcmp(task,'saveName');
    
    
    
    
    he=findobj(hs,'tag','saveName');
    file=get(he,'string');
    if ~isempty(file)
        [pax fi ext]=fileparts(file);
        if isempty(pax); pax=pwd; end
        file=fullfile(pax,[fi '.png']);
        set(he,'string',file);
    end
    
    u=get(hf,'userdata');
    u.p.saveas=file;
    set(hf,'userdata',u);
    
elseif strcmp(task,'pb_saveImage');
    %% ===============================================
    he=findobj(hs,'tag','saveName');
    file=get(he,'string');
    if ~isempty(file)
        
        
        q=saveimg([],[],file);
    end
    
    
    
    %% ===============================================
    
end
figure(hs);

%
% function setbarlabel_cb(e,e2)
% hf=findobj(0,'tag','orthoview');
% hs=findobj(0,'tag','specs_gui');
% hc=findobj(hf,'tag','cbar');
% set(hc.Label,'string', get(findobj(hs,'tag','cbarlabel'),'string') );
%
% function sefontsize_cb(e,e2)
% hf=findobj(0,'tag','orthoview');
% cb=findobj(hf,'tag','cbar');
% hs=findobj(0,'tag','specs_gui');
% he=findobj(hs,'tag','fontsize')
% set(cb,'fontsize',str2num(get(he,'string')) );

function loadimgages(task)

if strcmp(task,'ortho')
    px.panel=1;
else
    px.panel=2;
end


hs=findobj(0,'tag','specs_gui');
im1=get(findobj(hs,'tag','select_bgimage'),'string');
% im2=get(findobj(hs,'tag','select_fgimage'),'string');

im2={};
for i=1:4
    dv=get(findobj(hs,'tag',['select_fgimage' num2str(i)]),'string');
    if ~isempty(dv)
        im2(end+1,1)={dv};
    end
end

f=cellstr(im1);
if ~isempty(im2);
    f=[f; im2];
end
if isempty(char(f));  disp('no images loaded ...abort'); return; end

p2=specs_getparameter();
p2=catstruct(p2,px);

vp=get(hs,'userdata');
p2=catstruct(p2,vp);

hf=findobj(0,'tag','orthoview');
if isempty(hf)
    
    c = struct2cell(p2); fn = fieldnames(p2);
    c2=[fn  c]';
    orthoslice(f,c2{:});
    
    
else
    u=get(hf,'userdata');
    figpos=get(hf,'position');
    p=u.p;
    keepfigpos=0;
    if px.panel==p.panel
        keepfigpos=1;
    end
    p=catstruct(p,px);
    p=catstruct(p,vp);
    delvars={'f','qmm','val','def', 'ce'};
    for i=1:length(delvars)
        try; p=rmfield(p,delvars{i}); end
    end
    c = struct2cell(p); fn = fieldnames(p);
    c2=[fn  c]';
    
    
    delete(hf);
    
    orthoslice(f,c2{:});
%     if  u.p.panel==1
%         update(u.p);
%     end
    
    hf=findobj(0,'tag','orthoview');
    if keepfigpos==1
        figpos_old=get(hf,'position');
        set(hf,'position',[figpos(1:2) figpos_old(3:4)]);
    end
    
    
end
%% ===============================================



return
hf=findobj(0,'tag','orthoview');
u=get(hf,'userdata');u.p
p=u.p;
p.f=f;
% set(hf,'userdata',)
figure(hf);
update(p);


function change_bgcolor
%% ===============================================
% return

hf=findobj(0,'tag','orthoview');
u=get(hf,'userdata');
p=u.p;
set(hf,'color',p.bgcol)
hax=[
    findobj(hf,'tag','ax2');
    findobj(hf,'tag','ax1');
    findobj(hf,'tag','ax3')];
for i=1:length(hax)
    % axes(hax(i));
    set(hf,'CurrentAxes',hax(i));
    c=get(hax(i),'children');
    c2=findobj(c,'tag','im1');
    w2=get(c2,'cdata');
    
    siz=size(w2);
    if ndims(w2)==2
        wt=w2(:);
    else
        wt=reshape(w2, [ siz(1)*siz(2) 3 ]);
    end
    wtrans=sum(wt,2)~=0;
    wtrans=reshape(wtrans, [ siz(1) siz(2) 1 ]);
    
    set(gca,'color','none','visible','off');
    
    %% ===============================================
    
    if p.bgremove==1
        if ndims(w2)==3
            w2= rgb2gray(w2);
        end
        if 0
            %     disp('local entropy')
            %a=imadjust(mat2gray(double(w2)));
            a=w2;
            w=strel('disk',5); %radius 5 --> strel('disk',5)
            b=entropyfilt(a,w.Neighborhood);
            ms=b>(max(b(:))*.5);
            wtrans=double(imfill(ms,'holes'));
        end
        wtrans=otsu(w2,2)~=1;
        
    end
    
    %     ixbordvalue=find([wtrans(:,1); wtrans(:,end); wtrans(1)'; wtrans(end)']==1);
    %     if ~isempty(ixbordvalue) % otsu
    %         'using otsu'
    %        wtrans= imfill(otsu(w2,10)>1,'holes');
    %
    %     end
    %     uistack(gca,'bottom');
    
    
    if p.panel==2
        %set(c2,'AlphaData',wtrans*p.alpha(1));
    else
        if 0
        set(c2,'AlphaData',wtrans);
        end
        
    end
    % set(c2,'AlphaData',1)
    %% ===============================================
    
    
end

% cb=findobj(hf,'tag','cbar');
%  uistack(cb,'top');
haxcb=findobj(hf,'tag','axcb' );
set(hf,'CurrentAxes',haxcb);

%  axes(haxcb);
%  uistack(haxcb,'top');

%% ===============================================


%% ===============================================


%% ===============================================


% function pb_crosshairscolor(e,e2)
% hf=findobj(0,'tag','orthoview');
% hs=findobj(0,'tag','specs_gui');
% he=findobj(hs,'tag','crosshairscolor');
% set(he,'string', num2str(uisetcolor));
% crosshairscolor();
%
% function crosshairscolor(e,e2)
% hf=findobj(0,'tag','orthoview');
% hs=findobj(0,'tag','specs_gui');
% he=findobj(hs,'tag','crosshairscolor');
% val=get(he,'string');
% hl=findobj(hf,'type','line');
% set(hl,'Color',val)


% function crosshairswidth(e,e2)
% hf=findobj(0,'tag','orthoview');
% hs=findobj(0,'tag','specs_gui');
% he=findobj(hs,'tag','crosshairswidth');
% val=get(he,'string');
%
% val=str2num(val);
% if isempty(val); val=0; end
% hl=findobj(hf,'type','line');
% if val>0
%
%     set(hl,'visible','on','linewidth',val );
% else
%     set(hl,'visible','off' );
% end

function specsUpdate(e,e2,p)
hf=findobj(0,'tag','orthoview');
hs=findobj(0,'tag','specs_gui');
if ~isempty(hf)
    
    u=get(hf,'userdata');
    p=u.p;
end
set(findobj(hs,'tag','fontsize'),'string', num2str(p.fs));


%caxis
hax1=findobj(hf,'tag','ax1');
axes(hax1);
set(findobj(hs,'tag','clims'),'string', num2str(caxis));
%cbar-label
hc=findobj(hf,'tag','cbar');
% label=get(hc.Label,'string');
label=p.cblabel;
set(findobj(hs,'tag','cbarlabel'),'string', label);
%crosshairs-lw
set(findobj(hs,'tag','crosshairswidth'),'string', num2str(p.cursorwidth));

%crosshairs-col
set(findobj(hs,'tag','crosshairscolor'),'string', num2str(p.cursorcol));

%alpha
set(findobj(hs,'tag','alpha'),'string', num2str(p.alpha));
%blobthresh
set(findobj(hs,'tag','blobthresh'),'string', num2str(p.blobthresh));

%label-col
if ischar(p.labelcol)
    labelcol=p.labelcol;
else
    labelcol=num2str(p.labelcol);
end
set(findobj(hs,'tag','cbarlabelcolor'),'string', labelcol);

%bgcolor
if ischar(p.bgcol)
    bgcol=p.bgcol;
else
    bgcol=num2str(p.bgcol);
end
set(findobj(hs,'tag','bgcolor'),'string', bgcol);

set(findobj(hs,'tag','legendgap'),'string',  num2str(p.legendgap));
set(findobj(hs,'tag','axoverlapp'),'string', num2str(p.axolperc));
try
    hb=findobj(hs,'tag','select_bgimage');
    set(hb,'string', p.f{1});
    hj = findjobj(hb);
    hj.setCaretPosition(hj.getDocument.getLength);
end
for i=1:4
    hg= findobj(hs,'tag',['select_fgimage' num2str(i) ]);
    set(hg,'string','') ;
end
if isfield(p,'f')
    for i=2:length(p.f)
        try
            hb=findobj(hs,'tag',['select_fgimage' num2str(i-1) ]);
            if i<=length(p.f)
                set(hb,'string', p.f{i});
                hj = findjobj(hb);
                hj.setCaretPosition(hj.getDocument.getLength);
            end
        end
    end
end




set(findobj(hs,'tag','removebackground'),'value', p.bgremove);
set(findobj(hs,'tag','resolution'),'string', (p.saveres));
set(findobj(hs,'tag','saveName'),'string', (p.saveas));



%% ===image params============================================
imageprops_guiupdate();
% 'a'
% hl=findobj(hs,'tag','prp_filename')
% hl.String{hl.Value}
% if strcmp(hl.String{hl.Value},'<empty>')
%     names={};
%     for i=1:length(p.f)
%         [pax namx ext]=fileparts(p.f{i})
%         names{i,1}=[ namx ext];
%     end
%     set(hl,'string',names,'value',1);
%
%     i=1;
%     %visible
%     hv=findobj(hs,'tag', 'prp_visible');
%     set(hv,'value', p.visible(i)) ;
%     %alpha
%     hv=findobj(hs,'tag', 'prp_alpha');
%     set(hv,'string', num2str(p.alpha(i))) ;
%     %clims
%     hv=findobj(hs,'tag', 'prp_clims');
%     set(hv,'string', num2str( p.clim(i,:)  )) ;
%     %thresh
%     hv=findobj(hs,'tag', 'prp_thresh');
%     set(hv,'string', num2str( p.thresh(i,:)  )) ;
%     %cmap
%     hv=findobj(hs,'tag', 'prp_cmap');
%     if isnumeric(p.cmap)
%         set(hv,'value', p.cmap(i) );
%     end
% end
%% ===============================================



% colormaps
hc=findobj(hs,'tag','colormaps');
mapnames=get(hc,'userdata');
val=1;
try
    val=min(find(strcmp(mapnames,p.cmap)));
    if isempty(val);val=1; end
end
hc.Value=val;

%% ======update mosaic-params=========================================
tb={...
    'slices-indices'       ''   'msliceidx'
    'slices-mm'            ''   'mslicemm'
    'dimension'            ''   'mdim'
    'number rows&columns'  ''   'mroco'
    'mm-labels show(0,1)'  ''   'mlabelshow'
    'mm-labels fontsize'   ''   'mlabelfs'
    'mm-labels format'     ''   'mlabelfmt'
    'mm-labels color'      ''   'mlabelcol'
    'cbar-positon'         ''   'mcbarpos'
    'gab between bars'     ''   'mcbargap'
    'cbar-fontsize'        ''   'mcbarfs'
    'plot width'           ''   'mplotwidth'
    'cbar-aligm(0,1)'      ''   'mcbaralign'
    };

% p.msliceidx  = 'n10'         ;%mosaic: sliceindices to plot: example  'n20', '5' ,[10:20] or '3 10 10
% p.mslicemm   =[]             ;%mosaic: alternative: vec with mm-values  -->this slices will be plotted
% p.mdim       =2              ;%mosaic: dimension to plot [1,2 or 3]
% p.mroco      =[nan nan]      ;%mosaic: number of rows and columns (default: [nan nan]); example: [2 nan] or [nan 5]
% p.mlabelfs   =8              ;%mosaic: mm-labels fontsize
% p.mlabelfmt  ='%2.2f'        ;%mosaic: mm-labels format
% p.mlabelcol  ='r';           ;%mosaic: color of mm-labels
% p.mcbarpos   =[5   20 10 100];%mosaic: cbar-positon (pixels), 1st value is a x-offset relative to plot
% p.mplotwidth =0.89           ;%mosaic: width of plot to allow space for colorbar; default: 0.9 (normalized units)

for i=1:size(tb,1)
    v= getfield(p,tb{i,3});
    tb{i,2}=regexprep(num2str(v),'\s+',' ')  ;%num2str(v)
end
ht=findobj(hs,'tag','mtable');
ht.Data=tb(:,1:2);
set(ht,'userdata',tb);

%% ========[table general ]=======================================
% 'update table'
tb={...
    'cursor-width'         ''   'cursorwidth'
    'cursor-color'         ''   'cursorcol'
    
    % 'other fontsize'       ''   'fs'
    
    
    'cbar-fontsize'        ''   'mcbarfs'
    'cbar-color'           ''   'labelcol'
    'cbar-gap'             ''   'mcbargap'
    'cbar-positon'         ''   'mcbarpos'
    'axis-overlapp'        ''   'axolperc'
    'figure-width'          ''   'figwidth'
    'figure-color'          ''   'bgcol'
    
    };

for i=1:size(tb,1)
    if ~isempty(tb{i,3})
        v= getfield(p,tb{i,3});
        tb{i,2}=regexprep(num2str(v),'\s+',' ')  ;%num2str(v)
    end
end
ht=findobj(hs,'tag','tb1');
ht.Data=tb(:,1:2);
set(ht,'userdata',tb);



%% ===============================================

function openSpecs(e,e2)
specs_gui();
hs=findobj(0,'tag','specs_gui');
hg=findobj(hs,'tag','tabgroup');
tabs=get(hg,'children');
% hg.SelectedTab=tabs(find(strcmp(get(tabs,'title'),'paras')));


function setClims_cb(e,e2)
hf=findobj(0,'tag','orthoview');
hs=findobj(0,'tag','specs_gui');
he=findobj(hs,'tag','clims');
lims=str2num(get(he,'string'));
u=get(findobj(0,'tag','orthoview'),'userdata');
if isempty(lims)
    hax=[
        findobj(hf,'tag','ax1');
        findobj(hf,'tag','ax2');
        findobj(hf,'tag','ax3')];
    mima=[];
    for i=1:length(hax)
        axes(hax(i));
        c=get(hax(i),'children');
        c2=findobj(c,'tag','im2');
        if isempty(c2)
            c2=findobj(c,'tag','im1');
        end
        if isempty(c2)
            c2=findobj(c,'type','image');
        end
        
        dx=c2.CData(:);
        mima(i,:)=[min(dx) max(dx)];
    end
    lims=[min(mima(:)) max(mima(:))];
    set(he,'string', num2str(lims));
end

u=get(hf,'userdata');
u.p.clim=lims;
set(hf,'userdata',u);

setlims(lims);
figure(hs);


function setlims(lims)
% lims=[0 3]
hf=findobj(0,'tag','orthoview');
hax=[
    findobj(hf,'tag','ax2');
    findobj(hf,'tag','ax1');
    findobj(hf,'tag','ax3')];
for i=1:length(hax)
    axes(hax(i));
    caxis(lims);
end
% hc=findobj(gcf,'tag','cbar');
haxcb=findobj(hf,'tag','axcb' );
axes(haxcb);
caxis(lims);


function panel_overlapp()
%% ===============================================

hf=findobj(0,'tag','orthoview');
u=get(hf,'userdata');
p=u.p;
cb=findobj(hf,'tag','cbar');
cbarpos=get(cb,'position');
hax=[
    findobj(hf,'tag','ax1');
    findobj(hf,'tag','ax2');
    findobj(hf,'tag','ax3')];
for i=1:length(hax)
    set(hf,'CurrentAxes',hax(i));
    %axes(hax(i))
    axpos(i,:)=get(hax(i),'position');
    set(hax(i),'visible','on');
end
%% ===============================================

wid=axpos(:,3);
overlepperc=p.axolperc;%20
overlap=overlepperc/100;
x0=[5 ;cumsum(round(wid-min(wid).*overlap))];

% x0=[0 ;cumsum(round(wid-wid.*overlappix))]
axpos2=axpos;
axpos2(:,1)=x0(1:3);
legendgap=p.legendgap; %-10
% if legendgap<-100
%     legendgap=0;
% end
% legendgap=0
% shift2legend=cbarpos(1)-(axpos2(end,1)+axpos2(end,3))-legendgap;
% axpos2(:,1)=axpos2(:,1)+shift2legend;
for i=1:length(hax)
    %axes(hax(i))
    set(hf,'CurrentAxes',hax(i));
    set(hax(i),'position',axpos2(i,:));
    %     set(gca,'visible','on')
end

%% ===============================================
if 1
    legendgap=p.legendgap; %-10
    cb=findobj(hf,'tag','cbar');
    cbarpos=get(cb,'position');
    
    %shift2legend=cbarpos(1)-(axpos2(end,1)+axpos2(end,3))-legendgap
    zeropint=axpos2(end,1)+axpos2(end,3);
    cbarpos(1)=zeropint+p.legendgap;
    set(cb,'position',cbarpos);
end

%% =======[ cbar on top]========================================

axesorder();

% haxcb=findobj(hf,'tag','axcb' );

% posm=get(haxcb,'position')
% set(haxcb,'position',posm)
% uistack(haxcb,'top')
%% ===============================================

% uistack(haxcb,'top');
% %
%  set(hf,'CurrentAxes',haxcb);
%
%  ch=get(hf,'children')
% tags=get(ch,'tag')
% % iax=regexpi2(tags,'ax\d')
% icb=regexpi2(tags,'axcb')
% %  [haxcb;hax ]
% ioth=setdiff(1:length(ch),icb);
% ord=[icb; ioth(:)]
% ch2=ch(ord)
% set(hf,'children',ch2)
%
% % if p.hide==0
% %    axes(haxcb);
% % end
%
%% ===============================================
function axesorder();
return

hf=findobj(0,'tag','orthoview');
ch=get(hf,'children');
tags=get(ch,'tag');
ia=regexpi2(tags,'ax\d');
ib=regexpi2(tags,'axcb');
ic=regexpi2(tags,'cbar');

o=[ib(:); ic(:); ia(:)];
up=setdiff(1:length(ch),o);
ord=[up(:); o];
set(hf,'children', ch(ord));
% drawnow;


function setcordinate(e,e2,task)
hf=findobj(0,'tag','orthoview');
fld={'max' 'min' 'origin' 'closestmax','closestmin'};
if ~isempty(find(strcmp(fld,task)))
    u=get(hf,'userdata');
    u.p.ce=task;
    update(u.p);
end

return






function q=saveimg(e,e2,filename)
%% ===============================================
hf=findobj(0,'tag','orthoview');
q=[];
if isempty(hf);  disp('no images loaded ...abort'); return; end

u=get(hf,'userdata');
p=u.p;
if exist('filename')==0
    [fi pa]=uiputfile(fullfile(pwd,'*.png'),'save as png');
    filename=fullfile(pa,fi);
end
%% ===============================================
if p.bgtransp==1; set(gcf,'InvertHardcopy','on' );
else ;            set(gcf,'InvertHardcopy','off');
end
% set(gcf,'color',[1 0 1]); 
% set(findobj(gcf,'type','axes'),'color','none');

q=filename;
% set(hf,'InvertHardcopy','off');
% print(hf,filename,'-dpng',['-r'  num2str(p.saveres) ], '-painters');
print(hf,filename,'-dpng',['-r'  num2str(p.saveres) ]);


if p.bgtransp==1 || p.crop==1;
    [im hv]=imread(filename);
    if p.crop==1;
        v=mean(double(im),3);
        v=v==v(1,1);
        v1=mean(v,1);  mima1=find(v1~=1);
        v2=mean(v,2);  mima2=find(v2~=1);
        do=[mima2(1)-1 mima2(end)+1];
        ri=[mima1(1)-1 mima1(end)+1];
        if do(1)<=0; do(1)=1; end; if do(2)>size(im,1); do(2)=size(im,1); end
        if ri(1)<=0; ri(1)=1; end; if ri(2)>size(im,2); ri(2)=size(im,2); end
        im=im(do(1):do(2),ri(1):ri(2),:);
    end
    if p.bgtransp==1
        imwrite(im,filename,'png','transparency',[1 1  1],'xresolution',p.saveres,'yresolution',p.saveres);
        if 0
            imd=double(im);
            pix=squeeze(imd(1,1,:));
            m(:,:,1)=imd(:,:,1)==pix(1);
            m(:,:,2)=imd(:,:,2)==pix(2);
            m(:,:,3)=imd(:,:,3)==pix(3);
            m2=sum(m,3)~=3;
            imwrite(im,filename,'png','alpha',double(m2));
        end
%         showinfo2(['saved png(resolution:' num2str(p.saveres)  ')'],filename);
        
%             
    else
        imwrite(im,filename,'png');
    end
end



showinfo2(['saved png(resolution:' num2str(p.saveres)  ')'],filename);
%% ===============================================




%% ===============================================

function update(p)

if exist('p')==0
    hf=findobj(0,'tag','orthoview');
    u=get(gcf,'userdata');
    p=u.p;
end

if isstr(p.ce)
    
    if strcmp(p.ce,'max') %get max coordinate
        
%         [h0 a0 mu]=rgetnii(p.f{1});
%         a0=a0(:);
%         q= mu(:,max(find(a0==max(a0))))';
        
        [ha a mm]=rgetnii(p.f{end});
        a=a(:);
        p.ce= mm(:,max(find(a==max(a))))';
%         p.ce
%         cs=mm(:,max(find(a==max(a))));
%         ic=vecnearest2(sum((mu-repmat(cs,[1 size(mu,2)])).^2,1),0)
%         
%         mu(:,ic)
%         p.ce
        
    elseif strcmp(p.ce,'min') %get min coordinate
        [ha a mm]=rgetnii(p.f{end});
        a=a(:);
        p.ce= mm(:,max(find(a==min(a))))';
    elseif strcmp(p.ce,'origin') %
        p.ce=[0 0 0];
    elseif strcmp(p.ce,'closestmax') || strcmp(p.ce,'closestmin') %%
        hf=findobj(0,'tag','orthoview');
        u=get(hf,'userdata');
        ce_old=u.p.ce;
        [ha a mm]=rgetnii(p.f{end});
        a=a(:);
        mm=mm';
        ix=vecnearest2(sum(abs(mm-repmat(ce_old(:)',[size(mm,1)  1])),2), 0);
        
        %radius=2;
        radius=p.maxsearchradius;
        radsquared=radius^2;
        iv = find((sum((mm-repmat(mm(ix,:),[size(mm,1) 1])).^2,2) <= radsquared));
        if strcmp(p.ce,'closestmax')
            ival=max(find(a(iv,:)==max(a(iv,:))));
        else
            ival=min(find(a(iv,:)==min(a(iv,:))));
        end
        p.ce=mm(iv(ival),:);
    end
    
end

if p.panel==2
    mosaic_update();
    return
end

%% ===============================================

[gt p]=obtaintslices(p.f{1},p);
gx{1,1}=gt;

for i=2:length(p.f)
   [gt p]=obtaintslices(p.f([1 i]),p); 
   gx{1,i}=gt;
end


%% ===============================================
if 0
    
    gx={};
    for i=1:length(p.f)
        [gt p]=obtaintslices(p.f{i},p);
        gx{1,i}=gt;
    end
    % if isempty(gx)
    %     load('gx.mat')
    % end
end
%% ===============================================






makeimage(gx,p)
%  makeOnePanel(p)
% change_bgcolor();


function mosaic_update();

hf=findobj(0,'tag','orthoview');
if isempty(hf); return; end
u=get(hf,'userdata');
p=u.p;


ha=findobj(gcf,'type','axes','tag',['ax1']);
hb=findobj(ha,'tag','im1');
hf=findobj(ha,'tag','im2');
if isempty(hf); return; end
F=hf.CData;
B=hb.CData;
climF=p.clim;

%         Bv=[ref(1).a(:);ref(2).a(:);ref(3).a(:)];
%         climB = [min(Bv(:)), max(Bv(:))];
% Badj=mat2gray(double(B),double(climB));
Badj=mat2gray(double(B));
if length(unique(B(:)))==2
    Bm=B;
else
    Bm=imfill(otsu(B,50)>1,'holes');
end
alphadata = p.alpha.*(F >= climF(1));
if length(unique(Bm(:)))>1 %outer mask
    alphadata=alphadata.*Bm;
end
if ~isempty(p.blobthresh)
    alphadata=alphadata.*(F>p.blobthresh);
end
set(hf,'AlphaData',alphadata);




function makeOnePanel(p)
if p.panel ==0; return; end
drawnow
hf=findobj(0,'tag','orthoview');
u=get(hf,'userdata');
p=u.p;
% clc
hax=[
    findobj(hf,'tag','ax1');
    findobj(hf,'tag','ax2');
    findobj(hf,'tag','ax3')];


set(hf,'units','pixels');
posfg=get(hf,'position');

pix=[];
for i=1:length(hax)
    %axes(hax(i))
    set(hf,'CurrentAxes',hax(i));
    set(gca,'visible','off');
    set(gca,'units','pixels');
    get(gca,'position');
    axis image;
    ch=findobj(hax(i),'type','image');
    si= size(get(ch(1),'Cdata'));
    pix(i,:)=si;
    
end

extraspace=30;
panx=sum(pix(:,2)) + extraspace;
figwid=posfg(3);
rcfac=figwid/panx;
pix2=round(pix.*rcfac);
% ===============================================
downshift=(pix2(2,1)-pix2(3,1))/2;
ypos=abs(downshift)+15;
ygap=0;
xpos=[ygap ; ygap+cumsum(pix2(:,2)-1)];
yshift=[0 0 downshift];
for i=1:length(hax)
    %axes(hax(i));
    set(hf,'CurrentAxes',hax(i));
    set(hax(i),'position',[xpos(i) ypos+yshift(i)  pix2(i,[2 1])  ]);
    axis off;
end

% ==============================================
%   cmap
% ===============================================
% hc=findobj(gcf,'tag','cbar');
% set(hc,'units','pixels');
%
% cbarhigh  =round(pix2(i,[1 ])*.8);
% cbaroffset=round((pix2(i,[1 ])-cbarhigh)/2)-10;
%
% set(hc,'position', [xpos(4)+5 ypos+yshift(3)+cbaroffset 10  cbarhigh  ]  );
% set(hc,'color',p.labelcol,'fontsize',p.fs,'fontweight','bold')
% if ~isempty(p.cblabel)
%     ylabel(hc,p.cblabel) ;% ylabel(hc,'Power (db)')
% end

% haxcb=findobj(gcf,'tag','axcb' );
% uistack(haxcb,'top');

% ==============================================
%  adjust figsize
% ===============================================
set(hf,'units','pixels');
figpos=get(hf,'position');
% set(gcf,'position',[  440   378   560    max(pix2(:,1))+ypos]);
% set(hf,'position',[  figpos(1:2)     560    max(pix2(:,1))+ypos+10]);
% set(hf,'position',[  figpos(1:2)     720    max(pix2(:,1))+ypos+10]);
%  set(hf,'visible','on');
set(hf,'position',[  figpos(1:2)     p.figwidth    max(pix2(:,1))+ypos+10]);
set(hf,'menubar','none');
set(hf,'color',p.bgcol);



panel_overlapp();
if p.hide==0
    set(hf,'visible','on');
end

% ==============================================
%%   cbar-location
% ===============================================
fg_unit=get(hf,'units');
set(hf,'units','pixels');
figpos=get(hf,'position');
set(hf,'units',fg_unit);

% ===============================================



xshift=p.mcbarpos(1);
hcs=findobj(hf,'userdata','cbar');
n=1;
for i=length(hcs):-1:1
    hc= findobj(hf,'tag',['cbar' num2str(i)]);
    set(hc,'units','pixels');
    posb=[ figpos(3)+xshift-(p.mcbargap.*n)+p.mcbargap p.mcbarpos(2:end) ];
    set(hc,'position',posb);
    n=n+1;
    set(hc,'units','normalized');
    set(hc,'YColor',p.labelcol,'XColor',p.labelcol,'fontsize' , p.mcbarfs);
    %set([hc; get(hc,'children')],'visible','on')
    if ~isempty(p.mbarlabel{i})
        set(hc.YLabel,'string',p.mbarlabel{i});
    end
end
% hc= findobj(hf,'tag',['cbar1' ]);
% posb1=get(hc,'position');
% posf=get(ha,'position');
% set(ha,'position',[posf(1:2)  posb1(1)  posf(4) ]);








%% ===============[button down]================================
function btndown(e,e2)
u=get(gcf,'userdata');

if 0
    hf=findobj(0,'tag','orthoview');
    ax=findobj(hf,'tag','ax1');
    set(hf,'CurrentAxes',ax);
end


co=get(gca,'CurrentPoint');
co=round(co(1,[1 2]));
% get(gca,'tag')
val=[0];
valv=zeros(1,length(u.gx));
if strcmp(get(gca,'tag'),'ax1')
    w=u.gx{1}(3);
    lx=linspace(w.x(1),w.x(2),size(w.a,2));
    ly=linspace(w.y(1),w.y(2),size(w.a,1));
    ce=[    u.p.ce(1)     lx(co(1))   ly(co(2))  ];
    
%     val(1)=w.a(co(2),co(1));
%     if size(u.gx,2)>1
%         w2=u.gx{2}(3);
%         val(2)=w2.a(co(2),co(1));
%     end
    
    for i=1:length(u.gx)
      valv(1,i)= u.gx{i}(3).a(co(2),co(1));
    end
    
    
elseif strcmp(get(gca,'tag'),'ax2')
    w=u.gx{1}(1);
    lx=linspace(w.x(1),w.x(2),size(w.a,2));
    ly=linspace(w.y(1),w.y(2),size(w.a,1));
    ce=[lx(co(1)) u.p.ce(2)  ly(co(2))  ];
    
%     val(1)=w.a(co(2),co(1));f
%     if size(u.gx,2)>1
%         w2=u.gx{2}(1);
%         val(2)=w2.a(co(2),co(1));
%     end
     for i=1:length(u.gx)
      valv(1,i)= u.gx{i}(1).a(co(2),co(1));
    end
    
    
elseif strcmp(get(gca,'tag'),'ax3')
    w=u.gx{1}(2);
    lx=fliplr(linspace(w.x(1),w.x(2),size(w.a,2)));
    ly=linspace(w.y(1),w.y(2),size(w.a,1));
    ce=[lx(co(2))   ly(co(1)) u.p.ce(3) ];
    
%     val(1)=w.a(co(1),size(w.a,2)-co(2)+1);
%     if size(u.gx,2)>1
%         w2=u.gx{2}(2);
%         val(2)=w2.a(co(1),size(w2.a,2)-co(2)+1);
%     end
    
    for i=1:length(u.gx)
        w2=u.gx{i}(2);
        valv(1,i)= w2.a(co(1),size(w2.a,2)-co(2)+1);;
    end
    
    
end

% max(w2.a(:))

p=u.p;
p.ce=ce;
p.val=valv;
update(p);
% axesorder();
if p.bgremove==1% ( isnumeric(p.bgcol) && sum(p.bgcol)~=0)||(ischar(p.bgcol) && strcmp(p.bgcol,'k')==0)
    % change_bgcolor();
end

% val
return
%% ===============================================

function [p errmsg]=sanitycheck(p);
errmsg=0;
% ==============================================
%   colormaps
% ===============================================
if isnumeric(p.cmap)
    if length(p.f)>length((p.cmap))
        mapdefault=[1:5];
        if isempty(p.cmap)
            p.cmap=mapdefault ;
        else
            maps=p.cmap;
            nmaps=length(maps);
            maps=[maps  mapdefault(nmaps+1:end)];
            maps=maps(1:length(p.f))
            p.cmap=maps;
        end
    end
    o= getCMAP('names');
    p.cmap=o(p.cmap)';  %convert to names   
else
    %p.cmap={'bla','hot'};
    maps=p.cmap;
    if ischar(maps)
        maps=cellstr(maps);
    end
    o= getCMAP('names');
    ifound=[];
    for i=1:length(maps)
        if ~isempty(min(find(strcmp(o,maps{i}))))
            ifound(1,end+1)= i;
        end
    end
    maps=maps(ifound);
  
  if isempty(char(maps)); maps=[]; end
  nmaps=length(maps);
  mapdefault={  'gray' 'jet' 'copper'  'hot' 'summer'};
  maps=[maps  mapdefault(nmaps+1:end)];
  maps=maps(1:length(p.f));   
  p.cmap=maps;
end
%% ===============================================





% -----clim
if isempty(p.clim) || size(p.clim,1)<length(p.f) || size(p.clim,2)~=2
    dx=repmat(nan,[7 2]);
    if isempty(p.clim); p.clim=[nan nan]; end
    dy=[p.clim(:,1:2); dx  ];
    dz=dy(1:length(p.f),:);
    p.clim=dz;
end

% -----thresh
if isempty(p.thresh) || size(p.thresh,1)<length(p.f) || size(p.thresh,2)~=2
    dx=repmat(nan,[7 2]);
    if isempty(p.thresh); p.thresh=[nan nan]; end
    dy=[p.thresh(:,1:2); dx  ];
    dz=dy(1:length(p.f),:);
    p.thresh=dz;
end

% -----cbar-label
if ischar(p.mbarlabel);     p.mbarlabel=cellstr(p.mbarlabel); end
p.mbarlabel=p.mbarlabel(:)';
if length(p.mbarlabel)<length(p.f)
    dx={'' '' '' '' '' '' '' ''};
    dy=[p.mbarlabel dx(length(p.mbarlabel)+1:end)];
    dz=dy(1:length(p.f));
    p.mbarlabel=dz;
end
% -----plot-visible
if isempty(p.visible) || length(p.visible)<length(p.f)
    dx=[1 1 1 1 1 1 ];
    dy=[p.visible dx(length(p.visible)+1:end)];
    dz=dy(1:length(p.f));
    p.visible=dz;
end
% -----cbar-visible
if isempty(p.cbarvisible) || length(p.cbarvisible)<length(p.f)
    dx=[1 1 1 1 1 1 ];
    dy=[p.cbarvisible dx(length(p.cbarvisible)+1:end)];
    dz=dy(1:length(p.f));
    p.cbarvisible=dz;
end
% -----alpha
if isempty(p.alpha) || length(p.alpha)<length(p.f)
    dx=[1 1 1 1 1 1 ];
    dy=[p.alpha dx(length(p.alpha)+1:end)];
    dz=dy(1:length(p.f));
    p.alpha=dz;
end


%% =========[files]======================================
isexist=zeros(length(p.f),1);
for i=1:length(p.f)
    [pth,nam,ext,num] = spm_fileparts(p.f{i});
    fis=fullfile(pth,[nam,ext]);
    isexist(i,1)=exist(fis)==2;
end
if ~isempty(find(isexist==0))
    disp('##### files not found ######');
    disp(char(p.f(find(isexist==0))));
    disp('...aborted..');
    errmsg=1; %abort
end

%% ===============================================

function makeimage(g,p)
ce=p.ce;

% % ==============================================
% %   image props
% % ===============================================
% if isnumeric(p.cmap)
%     if length(g)>length((p.cmap))
%         mapdefault=[1:5];
%         if isempty(p.cmap)
%             p.cmap=mapdefault ;
%         else
%             maps=p.cmap;
%             nmaps=length(maps);
%             maps=[maps  mapdefault(nmaps+1:end)];
%             maps=maps(1:length(g))
%             p.cmap=maps;
%         end
%     end
%     o= getCMAP('names');
%     p.cmap=o(p.cmap)';  %convert to names   
% else
%     %p.cmap={'bla','hot'};
%     maps=p.cmap;
%     if ischar(maps)
%         maps=cellstr(maps);
%     end
%     o= getCMAP('names');
%     ifound=[];
%     for i=1:length(maps)
%         if ~isempty(min(find(strcmp(o,maps{i}))))
%             ifound(1,end+1)= i;
%         end
%     end
%     maps=maps(ifound);
%   
%   if isempty(char(maps)); maps=[]; end
%   nmaps=length(maps);
%   mapdefault={  'gray' 'jet' 'copper'  'hot' 'summer'};
%   maps=[maps  mapdefault(nmaps+1:end)];
%   maps=maps(1:length(g));   
%   p.cmap=maps;
% end
% %% ===============================================

    
% elseif iscell(p.cmap)
%     
%     if length(g)>length(cellstr(p.cmap))
%         
%         
%         p.cmap={  'gray' 'jet' 'copper'  'hot' 'summer'};
%         p.cmap=[1 2 3 4 5];
%     end
% elseif ischar(p.cmap)
%     if length(g)>length(cellstr(p.cmap))
%         
%     end


% if isempty(p.clim) || size(p.clim,1)<length(g) || size(p.clim,2)~=2
%     p.clim=nan(length(g), 2);
% end
% 
% alpha=p.alpha;
% if length(alpha)<length(g)
%     alpha=[  1   repmat(alpha,[ 1 length(g)-1 ] )  ] ;
%     p.alpha=alpha;
% end
% 
% thresh=p.thresh;
% if isempty(thresh)
%     p.thresh=nan(length(g), 2);
% end
% 
% if isempty(p.visible) || length(p.visible)~=length(p.f)
%     p.visible=repmat(1,  [1  length(p.f) ]  );
% end
% 
% if ischar(p.mbarlabel)
%     p.mbarlabel=cellstr(p.mbarlabel)
% end
% if length(p.mbarlabel)<length(p.f)
%     p.mbarlabel=repmat(p.mbarlabel, [1 length(p.f)]);
% end




%% ========check same size=======================================
q1={g{1}.a};
if length(g)>1
    for j=1:length(g)
        q2={g{j}.a};
        for i=1:length(q2)
            if all(  size(q1{i})==size(q2{i})  )==0
                dx=imresize(q2{i}, size(q1{i}),'nearest');
                g{j}(i).a=dx;
            end
        end
    end
    
end

% q1={gx{1}.a}
% q2={gx{2}.a}


%% ===============================================
if 1
    r=g{1};
    if size(g,2)==1
        p.mode='def';
    end
    % p.masktreshold=0.5
    if strcmp(p.mode,'mask') && size(g,2)>1 || strcmp(p.mode,'ovl') && size(g,2)>1 ...
            || strcmp(p.mode,'blob') && size(g,2)>1
        r=g{2};
        ref=g{1};
    end
    if isempty(p.clim)
        val=[r(1).a(:);r(2).a(:); r(3).a(:)];
        p.clim= [min(val) max(val)];
    end
end

%% ===============================================
lx=linspace(r(1).x(1),r(1).x(2),size(r(1).a,2));
cx=vecnearest2(lx,ce(1));

lz=linspace(r(1).y(1),r(1).y(2),size(r(1).a,1));
cz=vecnearest2(lz,ce(3));

ly=linspace(r(3).x(1),r(3).x(2),size(r(3).a,2));
cy=vecnearest2(ly,ce(2));

idx=[cx cy cz];
% idx=idx


%% ===============================================
% cf
hf=findobj(0,'tag','orthoview');
if isempty(hf)
    figvisible='off';
    if p.hide~=0 ; figvisible='off';     end
    
    figure('visible',figvisible,'units','normalized','tag','orthoview','numbertitle','off',...
        'menubar','none','color','w')
    set(gcf,'Resizefcn',@figresize)
    %     fg;  set(gcf,'units','normalized','tag','orthoview','numbertitle','off');
    fpos=get(gcf,'position');
    set(gcf,'position', [0.4  fpos(2:end)  ]);
    
    hf=gcf;
end
if sum(round(ce==round(ce)))==3;
    mmstr=sprintf('%d,%d,%d ',ce);
else;
    mmstr=sprintf('%2.3f,%2.3f,%2.3f ',ce);
end
% if isfield(p,'val')
%     valstr=num2str(p.val);
% else
%     valstr='';
% end
%% ===============================================

% for i=1:length(g)
%     w2=g{i}(2);
%     valv(1,i)= w2.a(co(1),size(w2.a,2)-co(2)+1);;
% end

%oslice: [mm]:0.030,-0.290,2.400    [idx]: 63,79,66   [val]:  1189.450 , 13.390 , 4.343

for i=1:length(g)
    p.val(i,1)=  g{i}(3).a(idx(3),idx(2));
end


valstr='';
try
    for i=1:length(p.val)
        if round(p.val(i))==p.val(i)
            valstr=[valstr ' , ' num2str(p.val(i))];
        else
            valstr=[valstr ' , ' sprintf('%2.3f' ,p.val(i))];
        end
    end
    
    % valstr(end+1)='|'
    valstr=[ valstr(3:end)];
end
set(hf,'name',['oslice: [mm]:' mmstr '   [idx]: ' sprintf('%d,%d,%d',idx) '   [val]: ' valstr ]);



%% ===============================================


ordspm=1;
if    ordspm==1;   ord=[ 3 1 2]; %ord spm
else;              ord=[1 3 2];
end
%         axposspm=[ % original SPM-ortho-position
%             [ 0.1378    0.2684    0.3984    0.2059]
%             [ 0.5504    0.2684    0.3082    0.2059]
%             [ 0.1378    0.0463    0.3984    0.2137]
%             ]
fc=1.8;
gap=0.01;

axposspm=[
    [ 0.12        0.2137*fc+0.12+gap     0.3984    0.2059*fc]
    [ 0.12+0.377    0.2137*fc+0.12+gap     0.3082    0.2059*fc]
    [ 0.12    0.12    0.3984    0.2137*fc]
    ];

axexist=0;
% ===============================================
cursorwidth=p.cursorwidth;
if cursorwidth<0.001 ; cursorwidth=0.001  ; end


for j=1:3
    % axes
    
    ha=findobj(gcf,'type','axes','tag',['ax' num2str(j)]);
    if isempty(ha)
        ha=axes('position',axposspm(j,:));
        set(ha,'tag',['ax' num2str(j)]);
    else
        %axes(ha);
        set(gcf,'CurrentAxes',ha);
        axexist=1;
    end
    delete(findobj(ha,'type','line'));
    %set(gca,'visible','off');
    %--------------------------
    for i=1:length(g)
        x=g{i} ;% nifti
        w=x(ord(j)); %image-struct
        F=w.a;
        F(F==0)=nan;
        
        climF=p.clim(i,:);
        %Fvec=F(:);
        Fvec=[x(1).a(:);x(2).a(:);x(3).a(:)];
        if isnan(climF(1))==1; climF(1)=min(Fvec)  ;end
        if isnan(climF(2))==1; climF(2)=max(Fvec)  ;end
        if climF(1)==climF(2); climF(2)=climF(2)+eps; end
        if isnan(climF(1))==1; climF(1)=0      ;end
        if isnan(climF(2))==1; climF(2)=0+eps  ;end
        p.clim(i,:)=climF;
        
        if ord(j)==2
            F=flipud(F');
        end
        
        if i==1
            Bm=imfill(otsu(F,50)>1,'holes');
        end
        
        
        him2=findobj(ha,'type','image','tag',['im'  num2str(i)]);
        if isempty(him2)
            him2 = imagesc(F);
        else
            unfreezeColors(him2)
            him2.CData=F;
        end
        hold on;
        set(him2,'tag',['im'  num2str(i)]);
        caxis(climF);
        
        % ### ALPHA #############
        %alphadata = p.alpha(i).*(F >= climF(1)); %prevous
        alphadata =ones(size(F))*p.alpha(i);
        if i>1
           alphadata=~isnan(F).*alphadata;    % issue with NAN --> become transparent
        end
        if length(unique(Bm(:)))>1 %outer mask
            alphadata=alphadata.*Bm;
        end
        % ### THRESHOLD ############
        athresh=(p.thresh(i,:));
        
        if any(athresh)==1
            if isnan(athresh(1))==0
                % alphadata=alphadata.*(F>athresh(1));
                alphadata(find(F<athresh(1)))=0;
            end
            if isnan(athresh(2))==0
                %alphadata=alphadata.*(F<athresh(2));
                alphadata(find(F>athresh(2)))=0;
                
            end
        end
        set(him2,'AlphaData',alphadata);
        
        
        %---CMAP -------------
        if isnumeric(p.cmap)
            cmap=getCMAP(p.cmap(i));
        else
            p.cmap{i};
            cmap=getCMAP(p.cmap{i});
        end
        colormap(cmap); drawnow;
        freezeColors;%(him2);
        
        
        if j==1
            hc=findobj(hf,'tag',['cbar' num2str(i)]);
            %delete(findobj(hf,'tag',['cbar' num2str(i)]));
            if isempty(hc)
                hc=jicolorbar('freeze');
                set(hc,'tag',['cbar' num2str(i)],'userdata','cbar');
                set(hc,'position',[.5+i*(0.1) 0.1 .02 .3]);
            end
                
                tx={0  'off'
                    1  'on'};
                hba=findobj(hc,'type','image');
                set(hc ,'visible',tx{p.cbarvisible(i)+1,2});
                set(hba,'visible',tx{p.cbarvisible(i)+1,2});
                
            
        end
        
        if  p.visible(i)==1;  set(him2,'visible','on');
        else ;                set(him2,'visible','off');
        end
        
        set(him2,'ButtonDownFcn',@btndown);
        
        
        
        
        
        if ord(j)==1
            hline(cz,'color',p.cursorcol,'linewidth',cursorwidth);
            vline(cx,'color',p.cursorcol,'linewidth',cursorwidth);
            
        elseif ord(j)==3
            hline(cz,'color',p.cursorcol,'linewidth',cursorwidth);
            vline(cy,'color',p.cursorcol,'linewidth',cursorwidth);
        elseif ord(j)==2
            if ordspm==0
                hline(cy,'color',p.cursorcol,'linewidth',cursorwidth);
                vline(cx,'color',p.cursorcol,'linewidth',cursorwidth);
            elseif ordspm==1
                if ord(j)==2
                    hline(size(w.a,2)-cx+1,'color',p.cursorcol,'linewidth',cursorwidth); %right panel
                    vline(cy,'color',p.cursorcol,'linewidth',cursorwidth);
                else
                    hline(cy,'color',p.cursorcol,'linewidth',cursorwidth);
                    vline(cx,'color',p.cursorcol,'linewidth',cursorwidth);
                end
            end
        end
        %set(findobj(gcf,'type','line'),'ButtonDownFcn',@btndown);
        
        set(ha,'tag',['ax' num2str(j)]);
        
        
    end
    %  axis normal
    set(ha,'YDir','normal');
    set(ha,'NextPlot','add')
    axis tight;     axis image;
    set(ha,'xticklabels',[],'yticklabels',[]);
    axis off
    %set(ha,'color',p.axcol);
    
    %
    %     set(ha, 'xlimmode','manual',...
    %         'ylimmode','manual',...
    %         'zlimmode','manual',...
    %         'climmode','manual',...
    %         'alimmode','manual');
    
    %     drawnow;
end
uistack(findobj(hf,'userdata','cbar'),'top');
drawnow;
set(hf,'doublebuffer','off');


hlin=findobj(gcf,'type','line');
set(hlin,'ButtonDownFcn',@btndown);
if cursorwidth<=0.001
    set(hlin,'visible','off');
else
    set(hlin,'visible','on');
end

%% ===============================================
% ==============================================
%%   cbar-location
% ===============================================
if 0
    fg_unit=get(hf,'units');
    set(hf,'units','pixels');
    figpos=get(hf,'position');
    set(hf,'units',fg_unit);
    
    %% ===============================================
    
    
    
    xshift=p.mcbarpos(1);
    hcs=findobj(hf,'userdata','cbar');
    n=1;
    for i=length(hcs):-1:1
        hc= findobj(hf,'tag',['cbar' num2str(i)]);
        set(hc,'units','pixels');
        posb=[ figpos(3)+xshift-(p.mcbargap.*n)+p.mcbargap p.mcbarpos(2:end) ];
        set(hc,'position',posb);
        n=n+1;
        set(hc,'units','normalized');
        set(hc,'YColor',p.labelcol,'XColor',p.labelcol,'fontsize' , p.mcbarfs);
        %set([hc; get(hc,'children')],'visible','on')
        if ~isempty(p.mbarlabel{i})
            set(hc.YLabel,'string',p.mbarlabel{i});
        end
    end
    hc= findobj(hf,'tag',['cbar1' ]);
    posb1=get(hc,'position');
    posf=get(ha,'position');
    set(ha,'position',[posf(1:2)  posb1(1)  posf(4) ]);
end
%% ===============================================



u.p  =p;
u.gx =g;
set(gcf,'userdata',u);
% update(p)
return






function [ g p]=obtaintslices(f,p);

ce=p.ce;

f = cellstr(f);
V = spm_vol(f{1});
BB=world_bb(V);

% V=V(volnum1);
% [~,~,qmm ]=rgetnii(f{1});
% qmm=qmm';



if isfield(p,'qmm')==0
    [R,C,P] = ndgrid(1:V(1).dim(1),1:V(1).dim(2),1:V(1).dim(3));
    RCP     = [R(:)';C(:)';P(:)';ones(1,numel(R))];
    p.qmm   = [V(1).mat(1:3,:)*RCP]';
    % else
    %     qmm
end

df=sum((p.qmm-repmat(ce(:)',[size(p.qmm,1) 1])).^2,2);
imin=find(df==min(df));


orientlabel={'coronal'  'axial'  'sagittal'};

ts  = [...
    0 0 0 pi/2 0 0 1 -1 1;...
    0 0 0 0 0 0 1 1 1;...
    0 0 0 pi/2 0 -pi/2 -1 1 1];
for kk=1:3
    orient=kk;
    if kk==1  ;   slicesmm=ce(2); end
    if kk==2  ;   slicesmm=ce(3); end
    if kk==3  ;   slicesmm=ce(1); end
    
    slicesnum=[];
    if isnumeric(orient);     orient=orientlabel{orient}; end
    ixorient  = strcmpi(orient,orientlabel);
    
    % Candidate transformations
    %     ts              = [0 0 0 0 0 0 1 1 1;...
    %         0 0 0 pi/2 0 0 1 -1 1;...
    %         0 0 0 pi/2 0 -pi/2 -1 1 1];
    
    
    transform       = spm_matrix(ts(ixorient,:));
    
    % Image dimensions
    D               = V.dim(1:3);
    % Image transformation matrix
    T               = transform * V.mat;
    % Image corners
    voxel_corners   = [1 1 1; ...
        D(1) 1 1; ...
        1 D(2) 1; ...
        D(1:2) 1; ...
        1 1 D(3); ...
        D(1) 1 D(3); ...
        1 D(2:3) ; ...
        D(1:3)]';
    corners         = T * [voxel_corners; ones(1,8)];
    sorted_corners  = sort(corners, 2);
    % Voxel size
    voxel_size      = sqrt(sum(T(1:3,1:3).^2));
    
    % Slice dimensions
    % - rows: x and y of slice image;
    % - cols: negative maximum dimension, slice separation, positive maximum dimenions
    slice_dims      = [sorted_corners(1,1) voxel_size(1) sorted_corners(1,8); ...
        sorted_corners(2,1) voxel_size(2) sorted_corners(2,8)];
    % Slices (in mm, world space):
    slices          = sorted_corners(3,1):voxel_size(3):sorted_corners(3,8);
    slicesix        =1:length(slices);
    
    
    
    
    
    % ===============================================
    
    
    if exist('slicesnum') && ~isempty(slicesnum)
        if isnumeric(slicesnum)
            slicesmm=slices(vecnearest2(slicesix,slicesnum)');
            nslices=length(slicesmm);
        else
            if ~isempty(strfind(slicesnum,'n'))
                nimg=str2num(strrep(slicesnum,'n',''));
                slicenum=round(linspace(slicesix(1),slicesix(end),nimg+2));
                slicenum=slicenum(2:end-1); %don't use 1 and last slice
                slicesmm=slices(slicenum);
                nslices=length(slicesmm);
            else
                str1=str2num(slicesnum); % stepwise
                if length(str1)==1
                    slicesnum=slicesix(1):str1:slicesix(end);
                    slicesmm=slices(vecnearest2(slicesix,slicesnum)');
                    nslices=length(slicesmm);
                elseif length(str1)>1
                    if isnan(str1(2))==1;
                        s1=1;
                    else
                        s1=str1(2);
                    end
                    
                    if length(str1)>2
                        if isnan(str1(3))==1;
                            s2=length(slicesix);
                        else
                            s2=length(slicesix)-str1(3)+1;
                        end
                    else
                        s2=length(slicesix);
                    end
                    slicesnum=s1:str1(1):s2;
                    slicesmm=slices(vecnearest2(slicesix,slicesnum)');
                    nslices=length(slicesmm);
                end
            end
        end
    else
        slicesnum=slicesix;
        nslices=size(slicesmm,1);
    end
    
    % Plane coordinates
    X               = 1;
    Y               = 2;
    Z               = 3;
    dims            = slice_dims;
    xmm             = dims(X,1):dims(X,2):dims(X,3);
    ymm             = dims(Y,1):dims(Y,2):dims(Y,3);
    
    
    % zmm             = slices(ismember(slices,slicesmm));
    zmm             = slices(vecnearest2(slices,slicesmm));
    
    
    [y, x]          = meshgrid(ymm,xmm');
    
    % Voxel and panel dimensions
    vdims           = [length(xmm),length(ymm),length(zmm)];
    pandims         = [vdims([2 1]) 3];
    
    
    
    nvox        = prod(vdims(1:2));
    
    hold=0;
    
    
    
    
    d=zeros([fliplr(vdims(1:2)) nslices ]);
    
    
    if length(f)==2
        V=spm_vol(f{2});
%         V=V(volnum2);
        if length(V)>1
            V=V(1);
        end
    end
    %  V=spm_vol(fullfile(pwd,'Rct.nii'));
    for is=1:nslices
        
        xyzmm = [x(:)';y(:)';ones(1,nvox)*zmm(is);ones(1,nvox)];
        
        vixyz = (transform*V.mat) \ xyzmm;
        % return voxel values from image volume
        
        slice             = spm_sample_vol(V,vixyz(1,:),vixyz(2,:),vixyz(3,:), hold);
        % transpose to reverse X and Y for figure
        slice = reshape(slice, vdims(1:2))';
        
        xs=xyzmm(1:3,:)';
        mima=[min(xs(:,1:3))
            max(xs(:,1:3))];
        xs=vixyz(1:3,:)';
        idxmima=[min(xs(:,1:3))
            max(xs(:,1:3))]  ;
        
        if strcmp(orient,'sagittal');
            %slice=flipud(fliplr(slice));
            slice=fliplr(slice);
            %             q.y=[mima(1,2) mima(2,2)]
            %             q.x=[mima(1,1) mima(2,1)]
            
            q.x=BB(:,2)';
            q.y=sort(BB(:,3)');
        elseif strcmp(orient,'coronal');
            % slice=flipud(slice);
            %             q.y=[mima(1,2) mima(2,2)]
            %             q.x=[mima(1,1) mima(2,1)]
            q.x=BB(:,1)';
            q.y=sort(BB(:,3)');
            
        elseif strcmp(orient,'axial');
            % slice=flipud(slice);
            %             q.y=[mima(1,2) mima(2,2)]
            %             q.x=[mima(1,1) mima(2,1)]
            
            q.x=BB(:,1)';
            q.y=BB(:,2)';
            
        end
        
        %      if is==1
        % %         d=zeros([size(slice) length(slicesmm) ]);
        %         d=zeros([fliplr(vdims(1:2)) length(slicesmm) ]);
        %     end
        slice(isnan(slice))=0;
        d(:,:,is) = slice;
        
        
    end
    
    
    
    q.a=d;
    g(kk)=q;
    %fg,imagesc(d);
end %



function map=getmap(cm)
if strcmp(cm,'hot')
    map=[  0.0417         0         0
        0.0833         0         0
        0.1250         0         0
        0.1667         0         0
        0.2083         0         0
        0.2500         0         0
        0.2917         0         0
        0.3333         0         0
        0.3750         0         0
        0.4167         0         0
        0.4583         0         0
        0.5000         0         0
        0.5417         0         0
        0.5833         0         0
        0.6250         0         0
        0.6667         0         0
        0.7083         0         0
        0.7500         0         0
        0.7917         0         0
        0.8333         0         0
        0.8750         0         0
        0.9167         0         0
        0.9583         0         0
        1.0000         0         0
        1.0000    0.0417         0
        1.0000    0.0833         0
        1.0000    0.1250         0
        1.0000    0.1667         0
        1.0000    0.2083         0
        1.0000    0.2500         0
        1.0000    0.2917         0
        1.0000    0.3333         0
        1.0000    0.3750         0
        1.0000    0.4167         0
        1.0000    0.4583         0
        1.0000    0.5000         0
        1.0000    0.5417         0
        1.0000    0.5833         0
        1.0000    0.6250         0
        1.0000    0.6667         0
        1.0000    0.7083         0
        1.0000    0.7500         0
        1.0000    0.7917         0
        1.0000    0.8333         0
        1.0000    0.8750         0
        1.0000    0.9167         0
        1.0000    0.9583         0
        1.0000    1.0000         0
        1.0000    1.0000    0.0625
        1.0000    1.0000    0.1250
        1.0000    1.0000    0.1875
        1.0000    1.0000    0.2500
        1.0000    1.0000    0.3125
        1.0000    1.0000    0.3750
        1.0000    1.0000    0.4375
        1.0000    1.0000    0.5000
        1.0000    1.0000    0.5625
        1.0000    1.0000    0.6250
        1.0000    1.0000    0.6875
        1.0000    1.0000    0.7500
        1.0000    1.0000    0.8125
        1.0000    1.0000    0.8750
        1.0000    1.0000    0.9375
        1.0000    1.0000    1.0000];
    
    map(1:12,:)=[];
end




function showOverlays(e,e2)



% ==============================================
%%   
% ===============================================


hf=findobj(0,'tag','orthoview');
u=get(hf,'userdata');
figure(hf)

ax=[findobj(hf,'tag','ax1');
    findobj(hf,'tag','ax2');
    findobj(hf,'tag','ax3')];

tag=sort(get(findobj(ax(1),'type','image'),'tag'));
nimg=length(tag);
for k=1:2
    for i=2:nimg
        for j=1:length(ax)
            hg=findobj(ax(j),'tag',['im' num2str(i)]);
            if ~isempty(hg)
                set(hg,'visible','on') ;
            end
            onum= setdiff(2:6,i);
            for k=1:length(onum)
                ho=findobj(ax(j),'tag',['im' num2str(onum(k))]);
                if ~isempty(ho)
                    set(ho,'visible','off') ;
                end
            end
            %         drawnow
        end
        
        drawnow;
        pause(.4);
    end
end

% ===============================================
for i=2:nimg
    for j=1:length(ax)
        hg=findobj(ax(j),'tag',['im' num2str(i)]);
        if ~isempty(hg)
            if u.p.visible(i)==1
            set(hg,'visible','on') ;
            else
                set(hg,'visible','off') ;
            end
        end
    end
    drawnow;
    pause(.2);
end


function figresize(e,e2)

% 'resize'
% 
% e2.EventName
% 
% b=dbstack
% subs={b.name}'
% 'a'
return

hf=findobj(0,'tag','orthoview');
set(findobj(hf,'tag','ax1'),'units','normalized');
set(findobj(hf,'tag','ax2'),'units','normalized');
set(findobj(hf,'tag','ax3'),'units','normalized');

% persistent blockCalls  % Reject calling this function again until it is finished
% if any(blockCalls),
%     '4'
%     set(findobj(hf,'tag','ax1'),'units','pixels');
% set(findobj(hf,'tag','ax2'),'units','pixels');
% set(findobj(hf,'tag','ax3'),'units','pixels');
%     
%     return;
% end
% blockCalls = true;
% doResize = true;
% '1'
% set(findobj(hf,'tag','ax1'),'units','normalized');
% set(findobj(hf,'tag','ax2'),'units','normalized');
% set(findobj(hf,'tag','ax3'),'units','normalized');
% drawnow
% while doResize   % Repeat until the figure does not change its size anymore
%     siz = get(hf, 'Position');
% %     pause(1.0);  % Of course here are some real calculations
%     %    set(AxesH, 'Position', [5, 5, siz(3:4)-10]);
%     drawnow;
%     '2'
%     
%     doResize = ~isequal(siz, get(hf, 'Position'));
% end
% blockCalls = false;  % Allow further calls again
% '3'
% 
% % pause(1); drawnow
% % set(findobj(hf,'tag','ax1'),'units','pixels');
% % set(findobj(hf,'tag','ax2'),'units','pixels');
% % set(findobj(hf,'tag','ax3'),'units','pixels');






