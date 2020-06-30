
% #wb Display 3D-volumes such as atlas regions, ROIs, statistical images, nodes and links.
% #r _____________________________________________________________________________
% #r NOTE!: First load a mask such as "AVGThemi.nii" using [load brain mask] button.
% #r to define the reference space. In some cases "AVGT.nii" might also work.
% #r _____________________________________________________________________________
%
% #wg BUTTONS
% [load brain mask]: load brain mask (example "AVGThemi.nii") ... has to be done first
% [load atlas]     : load an atlas or a volume with rois to display. Example: "ANO.nii"
%                    If the atlas (example: "ANO.nii") is accompanied by a excelfile ("ANO.xlsx")
%                    with the same structure as used for the atlases of the tbx, region labels and
%                    colors will be used. If not, pseudo-region names and random colors will be used
%                    to display the regions.
% #r           NOTE: [load atlas] only loads the atlas/Rois. Use [plot regions] to display the regions.
% [plot regions]    : Displays the regions, previously loaded via [load atlas]
%                    Select the regions in the new table window to visualize them.
% [load selected regions]: an Excel file analoge to  'ANO.xlsx' with an additional column with name #b 'selection'
%                    The 'selection' column contains a '1' for regions that should be preselected, otherwise
%                    keep cells of 'selection' column empty!
%                    The selection file can be shortened to the the regions that should be preselected. The order
%                    of the regions can be arbitrary.
% [Reg vis]          : radio, show/hide selected regions
% [edit: 0.2]       : set transparency of selected and currently visualized regions  (range: 0-1)
%
% [by ID]            : userinput: vector of IDs (as contained in the atlas/Roivolume) for preselection
%                      example: for Allen Mouse Atlas: [985 672] to preselect "primary motor area" and
%                      "caudoputamen". These IDs will be preselected in the region table window opend
%                      via [plot regions]
% #b STAISTICAL IMAGE
% [load stat img]   : Load a statistical image (SI) via gui. Examples: volumes containing T-values,
%                     incidence maps etc.
% [pulldown menu]   : (located below [load stat img]). Select a previously loaded image.
%                      Several different SI can be loaded, selected from the pulldown menu and displayed.
% [remove img]      : remove visualization of the selected image
%
%  #k There are 3 ways to visualize SI:
%               #b  -intensity cluster #r [plot-CL] #k or 
%               #b  -threshold #r [plot-TR]  #k or 
%               #b  -via slice function #r [plot-SL]  
%% ________________________________________________________________________________________________
% #g [plot-CL]          : cluster an image into N-intensity cluster/classes. Use pulldow-menu to set
%                      the number of classes.
%                      Optional: Use left edit field [nan nan] to first set a lower and upper threshold
%                      before clustering into N classes: (examples: [nan nan]..no threshold; [0 nan]...only
%                      lower threshold is used).
%% ________________________________________________________________________________________________
% #g [plot-TR]          : threshold SI based on a set threshold. The threshold can be changed in the left edit
%                      field ([90])
% #b Transpatency & colormap
% [parula]       : pulldownmenu to select the colormap for current SI
% [nan nan]      : optional, set lower/upper color range limits
% [def]          : set default color range limits
% [Cbar]       : radio, show/hide region colorbar
% [c-ticks]      : radio, display colorbar with either 2-ticks or n-ticks
% [a1]           : pulldown, select different transparency settings
% [edit]         : edit field to set the transparency. For [plot-CL] you can chose as many transparency  values
%                  as classes/clusters (example:  3 classes:  "0.1 0.5 1.0" for incidency maps, with increasing
%                  transparency from inside to outside to display an intensity "core").
%% ________________________________________________________________________________________________
% #g [plot-SL]           : plot Intensity Image using slice function 
% [colormap]          : select colormap
% [transparent value] : this intensity value is set transparent (default 0: i.e. '0'-values become transparent)
% [nan nan]           : optional, set lower/upper color range limits 
% [transparency]      : set transparency value; {range 0-1}
%% ________________________________________________________________________________________________
% #b Brain & materila & light
% [nodes & links] : display connections/connection strength --> see help there
% [arrow]         : shwo/hide orthogonal arrows
% [0.01]            :  set brain mask transparency (range: 0-1)
% [Bcol]            :  set brain mask color
% [Bdot]            :  radio, show brain mask as dotfield
% [dull]            :  pulldown,select light-interacting material type
% [light]           :  set light. To obtain the light from the viewers location (headlight), select [light] btn twice.
% #b Movie
% [ROT]            :  click [ROT] to rotate the volume; click again to stop rotation or stop saving movie
% [iteration]      : (default value: 120) number of iterations to rotate (iteration>0 or inf )
% [azimut step]    : (default value: 3) azimuth step-size   (small/large: produces slow/fast rotations)
% [elevation step] : (default value: 0) elevation step-size (small/large: produces slow/fast rotations)
% [sleep]          : (default value: 0.1) sleeping time [secs] between rotation steps. This paramter
%                    has no effect when saving a movie
% [save]           : radio, save movie as *.mp4. If radio==1, press [ROT] btn to start, select the output name and wait.
%                    -use small azimut /elevation steps to obtain a movie with slow roations
%
% #wg Commandline Options
% xvol3d;                                               % opens the selection panel
% xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii'))  % load brain mask
% xvol3d('loadatlas','ANO.nii');                        % load atlas file
%------------------------------------------------
% #b Example: show preselected regions, use preselection from excelfile
% cf
% xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii')); % load brain mask
% xvol3d('loadatlas','ANO.nii');            % load atlas
% xvol3d('regions','myselection3.xlsx');    % (optional) load excel-file with preselect regions
% xvol3d('regions','plot');                 % opens regions selection table & plot preselected regions
% xvol3d('regionlabels','on')               % show labels
% ------------------------------------------------
% #b Example: show preselected regions, use region IDs for preselection
% cf
% xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii')); % load brain mask
% xvol3d('loadatlas','ANO.nii');            % load atlas
% xvol3d('regions',[672 320]);              %  preselect regions by ID (here "cauoputamne" and "prim. motor area, layer 1")
% xvol3d('regions','plot');                 % opens regions selection table; plot preselected regions
%
% #b Example: show regions by ID and display labels
% cf
% xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii'));   % load brain mask
% xvol3d('loadatlas','ANO.nii');                          % load atlas
% xvol3d('regions',[802   672   844   648   943   320]);  %  preselect regions by ID
% xvol3d('regions','plot');                               % opens regions selection table; plot preselected regions
% xvol3d('regionlabels','on');                            % show labels
%
% #b plot intensity volume via #r cluster method
% xvol3d('plotclust'); use default options
%% use 'plotclust' as first input followed by pairwise inputs
% xvol3d('plotclust','cmap','jet','nclasses',3,'transp',[.05 .2 1],'thresh',[nan nan]);
%
% #b plot intensity volume via #r threshold
% xvol3d('plotthresh');
%% use 'plotthresh' as first input followed by pairwise inputs
% xvol3d('plotthresh','transp',[1],'cmap','@red','thresh',10);
% #b OTHER
% sub_plotregions('clear') ;      % clear/remove displayed regions
% sub_plotregions('transp',0.5);  % set region transparency
%
% #b USING 'set' followed by pairwise parameters..pairwise paramters can be combined
% xvol3d('set','material','dull');  % set material to 'dull'
% xvol3d('set','showarrows',1);     % show arrows
% xvol3d('set','light','on');       % show light
% xvol3d('set','braindot',1);       % show brain as dot field
% xvol3d('set','braincolor',[1 0 1]); % set brain color
% xvol3d('set','brainalpha',1);     % set alpha transparency
% xvol3d('set','material','metal','braincolor',[1 1 0]);  % example to combine parameter
%
% #b Example: plot two intensity images
% cf
% xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii')); % load brain mask
% xvol3d('statimage','INCMAP_HR_n6.nii');               % load intensity image1
% xvol3d('statimage','incmap_right.nii');               % load intensity image2
% xvol3d('imagefocus',1);                               % set foucs to image-1
% xvol3d('plotthresh','transp',[1],'cmap','@blue','thresh',50); % display image1 via thresholding
% xvol3d('imagefocus',2);                               % set foucs to image-1
% xvol3d('plotclust','cmap','jet','nclasses',5,'transp',[.2],'thresh',[nan nan]); % display image2 via clustering
%
% #b Example: plot via slice-command (plot-SL)
% xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii'));  % load brain mask
% xvol3d('statimage','INCMAP_HR_n6.nii');                % load intensity image --> image1
% xvol3d('plotslice','cmap','hot','nanval',0,'transp',[.05],'thresh',[-2 120]); % plot via slice
%
% #b Example: plot two intensity images via slice-command (plot-SL) with two different colormaps
% cf
% xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii')); % load brain mask
% xvol3d('statimage','INCMAP_HR_n6.nii');               % load intensity image1
% xvol3d('statimage','incmap_right.nii');               % load intensity image2
% xvol3d('imagefocus',1);                               % set foucs to image-1
% xvol3d('plotslice','cmap','hot','nanval',0,'transp',[.05],'thresh',[-2 120]); % plot via slice
% xvol3d('imagefocus',2);                               % set foucs to image-2
% xvol3d('plotslice','cmap','jet','nanval',0,'transp',[.04],'thresh',[nan nan]); % plot via slice


function varargout=xvol3d(varargin)

format compact;
addpath(genpath(fileparts(which('xvol3d.m'))));
if exist('smoothpatch.m')~=2
    addpath(fullfile(fileparts(which('xvol3d')),'smoothpatch_version1b'));
end

if 0
    cf
    xvol3d('loadbrainmask',fullfile(pwd,'AVGT.nii'))
    xvol3d('loadatlas','ROI4_sm.nii')
    xvol3d('regions',[7 8]);
    xvol3d('regions','plot');
    
    xvol3d('statimage',fullfile(pwd,'ROI4_sm.nii'));
    
    xvol3d('regions','_testNodes2.xlsx')
    
    %xvol3d('regions','myselection2.xlsx')
    
    % ==============================================
    %%
    % ===============================================
    
    cf
    xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii')); %load brain mask
    xvol3d('loadatlas','ANO.nii');            % load atlas
    xvol3d('regions','myselection3.xlsx');    % (optional) load excel-file with preselect regions
    xvol3d('regions','plot');                 % opens regions selection table; plot preselected regions
    
    
    cf
    xvol3d('loadbrainmask',fullfile(pwd,'AVGT.nii')); %load brain mask
    xvol3d('loadatlas','ROI4_sm.nii');            % load atlas
    xvol3d('regions',[7 8]);                  %  preselect regions by ID (here "cauoputamne" and "prim. motor area, layer 1")
    xvol3d('regions','plot');                 % opens regions selection table; plot preselected regions
    
    
    
    cf
    xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii')); %load brain mask
    xvol3d('loadatlas','ANO.nii');            % load atlas
    xvol3d('regions',[672 320]);                  %  preselect regions by ID (here "cauoputamne" and "prim. motor area, layer 1")
    xvol3d('regions','plot');                 % opens regions selection table; plot preselected regions
    %    % ==============================================
    cf
    xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii')); %load brain mask
    xvol3d('statimage','INCMAP_HR_n6.nii'); % load intensity image --> image1
    xvol3d('statimage','incmap_right.nii'); % load intensity image --> image2
    xvol3d('imagefocus',1); % set foucs to image-1
    xvol3d('plotthresh','transp',[1],'cmap','@blue','thresh',50); %display image1 via thresholding
    xvol3d('imagefocus',2); % set foucs to image-1
    xvol3d('plotclust','cmap','jet','nclasses',5,'transp',[.2],'thresh',[nan nan]);% %display image2 via clustering
    
    %%
    % ===============================================
    
    xvol3d('plottr',.3);%plot-TR at threshold .3
    xvol3d('arrows','on');%show hide arrows
    
    
    xvol3d('light','on');%light on /off
    xvol3d('brainalpha',.5); %set transparency
    
    xvol3d('updateIMGparams',4)
    xvol3d('set','material','shiny');
    xvol3d('regionlabels','on');%show/hide labels
    
end

% ==============================================
%%   IN-OUT WITHOUT CLOSING THIS WIN
% ===============================================
if nargin==0
    buttonwindow;
end


if nargin~=0;
    
    if mod(length(varargin),2)==0
        par=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    else % odd
        if length(varargin)==1
            par=struct();
            par=setfield(par,varargin{1}, varargin{1});
        else
            par=cell2struct(varargin(3:2:end),varargin(2:2:end),2);
            par=setfield(par,varargin{1}, varargin{1});
        end
    end
    
    
    
    
end
% ==============================================
%%  function after reclosing CLOSING THIS WIN
% ===============================================
if nargin~=0;
    
    
    if isfield(par,'regionlabels');
        showlabel_ext(par);
    end
    
    if isfield(par,'updateIMGparams');
        updateIMGparams(      par.updateIMGparams);
        return
    end
    
    if isfield(par,'imagefocus');
        setimageFocus(par.imagefocus);
    end
    
    if isfield(par,'loadbrainmask');
        buttonwindow
        loadbrainmask(par.loadbrainmask);
    end
    if isfield(par,'loadatlas');
        buttonwindow
        loadatlas(    par.loadatlas);
    end
    
    if isfield(par,'regions');
        if isnumeric(par.regions)
            cb_selectbyID([],[],par.regions); %select by IDs
        else
            if strcmp(par.regions,'plot')==1  %plot regions
                selectRegions();
            elseif strcmp(par.regions,'clear')==1  %deselect all regions
                sub_plotregions('clear')
                
            else
                buttonwindow               %select using Excel
                regions(      par.regions);
            end
        end
    end
    
    
    
    if isfield(par,'set');         setparameter(par) ;  end
    if isfield(par,'plotclust');   plotclust(par) ;     end
    if isfield(par,'plotthresh');  plotthresh(par) ;    end
    if isfield(par,'plotslice');   plotslice(par) ;    end
    
    
    
    if isfield(par,'updateIMGparams');
        buttonwindow
        updateIMGparams(      par.updateIMGparams);
    end
    if isfield(par,'statimage');
        % buttonwindow
        statimage(      par.statimage);
    end
    
    
    if isfield(par,'plottr');
        plottr(      par);
    end
    
    if isfield(par,'arrows');
        showarrows(      par);
    end
    
    if isfield(par,'light');
        slight(      par);
    end
    
    if isfield(par,'brainalpha');
        brainalpha(      par);
    end
    
end


function setimageFocus(par)
hw=findobj(0,'tag','winselection');
hc=findobj(hw,'tag','currentimg');
li=get(hc,'string');
if isnumeric(par)
    if par(1)<=length(li) && par(1)>=1
        set(hc,'value',par);
    end
    
end




function plotthresh(par)
hw=findobj(0,'tag','winselection');


if isfield(par,'thresh')
    %% xvol3d('plotthresh','transp',[.1 .5 1]);
    hc=findobj(hw,'tag','cthresh2');
    set(hc,'string',num2str(par.thresh));
end
if isfield(par,'cmap')
    %% xvol3d('plotthresh','cmap','jet');
    hc=findobj(hw,'tag','scmap');
    li=get(hc,'string');
    set(hc,'value',find(strcmp(li,num2str(par.cmap))));
end
if isfield(par,'transp')
    %% xvol3d('plotthresh','transp',[1]);
    hc=findobj(hw,'tag','salpha');
    set(hc,'string',num2str(par.transp));
end

cb_plotimg ([],[],2);


function plotclust(par)
hw=findobj(0,'tag','winselection');
if isfield(par,'nclasses')
    %% xvol3d('plotclust','nclasses',5);
    hc=findobj(hw,'tag','cnclasses');
    li=get(hc,'string');
    set(hc,'value',find(strcmp(li,num2str(par.nclasses))));
end
if isfield(par,'thresh')
    %% xvol3d('plotclust','thresh',[1 50]);
    hc=findobj(hw,'tag','cthresh1');
    set(hc,'string', num2str(par.thresh) );
end
if isfield(par,'cmap')
    %% xvol3d('plotclust','cmap','jet');
    hc=findobj(hw,'tag','scmap');
    li=get(hc,'string');
    set(hc,'value',find(strcmp(li,num2str(par.cmap))));
end
if isfield(par,'transp')
    %% xvol3d('plotclust','transp',[.1 .5 1]);
    hc=findobj(hw,'tag','salpha');
    set(hc,'string',num2str(par.transp));
end

cb_plotimg ([],[],1);

return


function setparameter(par)
hw=findobj(0,'tag','winselection');
if isfield(par,'material')
    %% xvol3d('set','material','shiny'); %set material
    hc=findobj(hw,'tag','material');
    li=get(hc,'string');
    set(hc,'value',find(strcmp(li,par.material)));
    hgfeval(get(hc,'callback'),hc);
end
if isfield(par,'showarrows')
    %%  xvol3d('set','showarrows',1); % show arrows
    %par.showarrows=0
    hc=findobj(hw,'tag','showarrows');
    set(hc,'value',par.showarrows);
    hgfeval(get(hc,'callback'),hc);
end
if isfield(par,'light')
    %%  xvol3d('set','light','on'); % show light
    %par.light='on'
    hc=findobj(hw,'tag','rblight');
    if strcmp(par.light,'on')
        set(hc,'value',1);
        hgfeval(get(hc,'callback'),hc);
    elseif strcmp(par.light,'off')
        set(hc,'value',0);
        hgfeval(get(hc,'callback'),hc);
    end
end

if isfield(par,'braindot')
    %%  xvol3d('set','braindot',1); % show brain as dot field
    %par.braindot=1
    hc=findobj(hw,'tag','braindot');
    set(hc,'value',par.braindot);
    hgfeval(get(hc,'callback'),hc);
end
if isfield(par,'braincolor')
    %%  xvol3d('set','braincolor',[1 0 1]); % set brain color
    hc=findobj(hw,'tag','braincolor');
    brainparam([],[],'color',par.braincolor);
end
if isfield(par,'brainalpha')
    %%  xvol3d('set','brainalpha',1); % set alpha transparency
    hc=findobj(hw,'tag','brainalpha');
    set(hc,'value',par.brainalpha);
    brainparam(hc,[],'alpha');
end


function buttonwindow

delete(findobj(0,'tag','winselection'));
fg;
hs=gcf;
set(hs,'units','norm','menubar','none','position',[0.1632    0.4178    0.1410    0.5211]);
set(hs,'tag','winselection','NumberTitle','off','name','xvol3d-selection');

%% __________________________________________________________________________________________________
% brainMASK
hb=uicontrol(hs,'style','pushbutton','units','norm');
set(hb,'position',[0.01 .9 .8 .05],'string','load brain mask');
set(hb,'callback',@cb_loadbrainmask);
set(hb,'tooltipstring','load brain mask ("AVGThemi.nii")');

%% __________________________________________________________________________________________________
% help
hb=uicontrol(hs,'style','pushbutton','units','norm');
set(hb,'position',[0.81 .9 .19 .05],'string','help');
set(hb,'callback',@cb_help);
set(hb,'tooltipstring','get some help');

%% __________________________________________________________________________________________________
% ATLAS
hb=uicontrol(hs,'style','pushbutton','units','norm');
set(hb,'position',[0.01 .8 .5 .05],'string','load atlas');
set(hb,'callback',@cb_loadatlas);
set(hb,'tooltipstring','load ATLAS ("ANO.nii")');

hb=uicontrol(hs,'style','pushbutton','units','norm');
set(hb,'position',[0.55 .8 .35 .05],'string','plot regions');
set(hb,'callback',@cb_selectRegions);
set(hb,'tooltipstring','opens a gui to select regions to display');

hb=uicontrol(hs,'style','pushbutton','units','norm');
set(hb,'position',[0.01 .75 .5 .05],'string','load selection');
set(hb,'callback',@cb_loadselectRegions,'fontsize',8);
set(hb,'tooltipstring','select external file (excel file) with preselected regions');

hb=uicontrol(hs,'style','pushbutton','units','norm');
set(hb,'position',[0.7 .75 .2 .05],'string','by IDs','tag','preselectByID');
set(hb,'callback',@cb_selectbyID  ,'fontsize',8);
set(hb,'tooltipstring','preselected regions by ID');



%% __________________________________________________________________________________________________
% REGIONS visible
hb=uicontrol(gcf,'style','radio','units','norm');
set(hb,'position',[0.01 .7 .3 .05],'string','Reg vis','backgroundcolor','w');
set(hb,'tooltipstring','regions on');
set(hb,'callback',{@regionpara,'visible'},'fontsize',8);
hp=findobj(findobj(0,'tag','xvol3d'),'tag','region');
if ~isempty(hp)
    if strcmp(get(hp(1),'visible'),'on'); set(hb,'value',1);
    else;                                 set(hb,'value',0);
    end
else
    set(hb,'value',1);
end
% REGIONS alpha
hb=uicontrol(gcf,'style','edit','units','norm');
set(hb,'position',[0.4 .7 .15 .04],'string','','backgroundcolor','w');
set(hb,'tooltipstring','region transparency','tag','regiontransparency');
set(hb,'callback',{@regionpara,'alpha'},'fontsize',8);
hp=findobj(findobj(0,'tag','xvol3d'),'tag','region');
if ~isempty(hp)
    set(hb,'string', num2str(get(hp(1),'facealpha'))  );
else
    set(hb,'string',.2);
end
%% ____INTENS IMAGE______________________________________________________________________________________________

hb=uicontrol(gcf,'style','pushbutton','units','norm');
set(hb,'position',[0.01 .61 .5 .035],'string','load stat img');
set(hb,'callback',@cb_loadstatimg);
set(hb,'tooltipstring','load an image=NIFTI-file (incidence map/statisit)');

hb=uicontrol(gcf,'style','pushbutton','units','norm','fontsize',8);
set(hb,'position',[0.7 .61 .3 .035],'string','remove img');
set(hb,'callback',@cb_deletestatimg);
set(hb,'tooltipstring','remove image from from figure');



hb=uicontrol(gcf,'style','popupmenu','units','norm');
set(hb,'position',[.001 .58 .65 .03],'string',{'empty'},'tag','currentimg');
set(hb,'tooltipstring','currently selected ..','fontsize',8);
set(hb,'callback',@cb_currentimg);
updateImagelist();

% ----------------------METH1
hb=uicontrol(gcf,'style','pushbutton','units','norm');
set(hb,'position',[.7 .52 .3 .03],'string','plot-CL');
set(hb,'callback',{@cb_plotimg,1});
set(hb,'tooltipstring','plot via cluster (otsu) method; number of classes must be defined');


hb=uicontrol(gcf,'style','edit','units','norm');
set(hb,'position',[.0 .52 .3 .03],'string','nan nan');
set(hb,'tooltipstring','threshold (2 values), not necessary','tag','cthresh1');

hb=uicontrol(gcf,'style','popupmenu','units','norm'); %CLASSes
set(hb,'position',[.3 .53 .3 .03],'string',cellfun(@(a){ [ num2str(a) ]}, [num2cell([1:20]) 'user'] )');
% set(hb,'callback',{@cb_plotimg,1});
set(hb,'tooltipstring','number of classes (otsu method)','tag','cnclasses','value',3);

hb=uicontrol(gcf,'style','frame','units','norm');
set(hb,'position',[0.0 .5085 1 .005],'foregroundcolor',[0    0.4510    0.7412]);

% ----------------------METH2
hb=uicontrol(gcf,'style','pushbutton','units','norm');
set(hb,'position',[.7 .475 .3 .03],'string','plot-TR');
set(hb,'callback',{@cb_plotimg,2});
set(hb,'tooltipstring','plot via thresholding method');


hb=uicontrol(gcf,'style','edit','units','norm');
set(hb,'position',[0 .475 .3 .03],'string','90');
set(hb,'tooltipstring','threshold (1 value) for "plot-TR"','tag','cthresh2');



% ----------------------
% CMAP
hb=uicontrol(gcf,'style','popupmenu','units','norm');
set(hb,'position',[0.01 .44 .45 .03],'string','plot');
set(hb,'tag','scmap','fontsize',8);
set(hb,'string',sub_intensimg('getcmap'));
set(hb,'value',1);
set(hb,'tooltipstring','colormap');
set(hb,'callback',{@setIMG,'scmap'});

% cmap-range
hb=uicontrol(gcf,'style','edit','units','norm');
set(hb,'position',[.5 .43 .3 .035],'string','nan nan','fontsize',8);
set(hb,'tooltipstring','set color-range (min,max); otherwise "nan nan" for default');
set(hb,'tag','setCrange');
set(hb,'callback',{@setCrange});

% cmap-Bztton-default
hb=uicontrol(gcf,'style','pushbutton','units','norm');
set(hb,'position',[.8 .43 .15 .035],'string','def','fontsize',8);
set(hb,'tooltipstring','set default color-range');
% set(hb,'tag','nan nan');
set(hb,'callback',{@setCrangedefault});




% ALPHA-'popup'
hb=uicontrol(gcf,'style','popup','units','norm');
set(hb,'position',[.01 .39 .35 .04],'string',{'a','b'},'fontsize',8);
set(hb,'tooltipstring','transparency values');
set(hb,'tag','spdalpha');
set(hb,'callback',{@setIMGviaPulldown});
rr=sub_intensimg('getalpha');
set(hb,'string',rr);

% ALPHA
hb=uicontrol(gcf,'style','edit','units','norm');
set(hb,'position',[.365 .39 .63 .035],'string','.02','fontsize',8);
set(hb,'tooltipstring','transparency');
set(hb,'tag','salpha');
set(hb,'callback',{@setIMG,'alpha'});

%frame
hb=uicontrol(gcf,'style','frame','units','norm');
uistack(hb,'bottom');
set(hb,'position',[0 .38 1 .185],'foregroundcolor',[0.2314    0.4431    0.3373],...
    'backgroundcolor',[ 0.8941    0.9412    0.9020]);
% ================= method-3 slice

%PB --------------
hb=uicontrol(gcf,'style','pushbutton','units','norm');
set(hb,'position',[.7 .345 .3 .03],'string','plot-SL');
set(hb,'callback',{@cb_plotslice,'plot-SL'},'tag','plot-SL');
set(hb,'tooltipstring','plot via slice-function',    'fontsize',8);
% CMAP --------------
hb=uicontrol(gcf,'style','popupmenu','units','norm');
set(hb,'position',[0.01 .345 .45 .03],'string','plot');
set(hb,'callback',{@cb_plotslice,'sliceCmap'},'tag','sliceCmap'); %@slice_cmap,...
set(hb,'string' ,sub_intensimg('getcmap'), 'value',1);
set(hb,'tooltipstring','colormap slice');
set(hb, 'fontsize',8);
%nan-value--------------
hb=uicontrol(gcf,'style','edit','units','norm');
set(hb,'position',[.454 .345 .12 .03],'string','0');
set(hb,'callback',{@cb_plotslice,'sliceNaN'},'tag','sliceNaN');
set(hb,'tooltipstring','this value becomes transparent (NaN) in slice mode; default 0',...
    'fontsize',8);
% LIMITS--------------
hb=uicontrol(gcf,'style','edit','units','norm');
set(hb,'position',[.0 .305 .3 .03],'string','nan nan');
set(hb,'callback',{@cb_plotslice,'sliceThresh'},'tag','sliceThresh');
set(hb,'tooltipstring','intensity threshold (2 values), not necessary', 'fontsize',8);
% transparency--------------
hb=uicontrol(gcf,'style','edit','units','norm');
set(hb,'position',[.35 .305 .12 .03],'string','0.05');
set(hb,'callback',{@cb_plotslice,'sliceTrans'},'tag','sliceTrans');
set(hb,'tooltipstring','transparency/alpha','fontsize',8);

%cb_plotslice: 'plot-SL' 'sliceCmap' 'sliceNaN' 'sliceThresh' 'sliceTrans'

%frame
hb=uicontrol(gcf,'style','frame','units','norm');
uistack(hb,'bottom');
set(hb,'position',[0 .3 1 .08],'foregroundcolor',[0.2314    0.4431    0.3373],...
    'backgroundcolor',[ 0.8706    0.9216    0.9804]);



% hb=uicontrol(gcf,'style','edit','units','norm');
% set(hb,'position',[.0 .52 .3 .03],'string','nan nan');
% set(hb,'tooltipstring','threshold (2 values), not necessary','tag','cthresh1');
%
% hb=uicontrol(gcf,'style','popupmenu','units','norm'); %CLASSes
% set(hb,'position',[.3 .53 .3 .03],'string',cellfun(@(a){ [ num2str(a) ]}, [num2cell([1:20]) 'user'] )');
% % set(hb,'callback',{@cb_plotimg,1});
% set(hb,'tooltipstring','number of classes (otsu method)','tag','cnclasses','value',3);


% ================


% ==============================================
%%
% ===============================================


% label show
hb=uicontrol(gcf,'style','radio','units','norm');
set(hb,'position',[.0 .25 .3 .035],'string','Cbar','fontsize',8);
set(hb,'tooltipstring','show/hide colorbar','backgroundcolor','w');
set(hb,'tag','cbarlabelshow','value',1);
set(hb,'callback',{@cbarlabelshow});

% cbar-labelmode
hb=uicontrol(gcf,'style','radio','units','norm');
set(hb,'position',[.3 .25 .3 .035],'string','c-ticks','fontsize',8);
set(hb,'tooltipstring','set cbar-labelmode (2 ticks or n-ticks)','backgroundcolor','w');
set(hb,'tag','cbarlabelmode','value',0);
set(hb,'callback',{@cbarlabelmode});



updateIMGparams();
if 0
    v.num=1
    v.cmap =jet;
    % tresh =[50 90]
    % tresh=[80 nan]
    v.tresh=[nan nan];
    v.thresh2=90
    v.nclass=7
    v.meth=1
    v.file=fullfile(pwd,'incmap_right.nii');
    sub_intensimg('show',v)
end



%show hide ARROW
hb=uicontrol(hs,'style','radio','units','norm','string','arrows','value',1);
set(hb,'position',[0    0.14 .3 .04],'tooltipstring','show/hide axis arrows');
set(hb,'callback',{@showarrows},'tag','showarrows','fontsize',8,'backgroundcolor','w');

%% __________________________________________________________________________________________________
%BRAIN
hb=uicontrol(hs,'style','edit','units','norm','string','0.01');
set(hb,'position',[0    0.1 .15 .04],'tooltipstring','brain alpha/transparency');
set(hb,'callback',{@brainparam,'alpha'},'fontsize',8,'tag','brainalpha');

hb=uicontrol(hs,'style','pushbutton','units','norm','string','Bcol');
set(hb,'position',[0.15 0.1 .15 .04],'tooltipstring','set brain color');
set(hb,'callback',{@brainparam,'color'},'fontsize',8,'tag','braincolor');

% braindot
hb=uicontrol(hs,'style','radio','units','norm','string','Bdot');
set(hb,'position',[0.30 0.1 .3 .04],'tooltipstring',...
    'show brain using dots field');
set(hb,'callback',{@braindot},'fontsize',8,'backgroundcolor','w');
set(hb,'tag','braindot');
set(hb,'value',0);
bd=findobj(findobj(0,'tag','xvol3d'),'tag','braindot');
if ~isempty(bd)
    set(hb,'value',1);
end


% MATERIAL
hb=uicontrol(hs,'style','popupmenu','units','norm','string',{'dull' 'shiny' 'metal'});
set(hb,'position',[0.01 0.05 .4 .035],'tooltipstring','material (dull|shiny|metal)',...
    'tag' ,'material','value',2);
set(hb,'callback',{@materialparam,''},'fontsize',8);



% LIGHT
hb=uicontrol(gcf,'style','radio','units','norm','string','light');
set(hb,'position',[0.45 0.04 .25 .04],'tooltipstring','light ON/OFF');
set(hb,'callback',{@setLight},'fontsize',8,'backgroundcolor','w','tag','rblight');

setLight([],[],'updateRadio');

% --------------------------------------
%Rotate
hb=uicontrol(gcf,'style','togglebutton','units','norm','string','ROT','value',0);
set(hb,'position',[0 0 .15 .04],'tooltipstring','start/stop rotation/saving movie');
set(hb,'callback',{@autorot},'fontsize',8);

hb=uicontrol(gcf,'style','edit','units','norm','string','120');
set(hb,'position',[.15 0 .15 .04],'tooltipstring','iteration','tag','rotdur');
set(hb,'fontsize',8);
%AZIMUT-STP
hb=uicontrol(gcf,'style','edit','units','norm','string','3');
set(hb,'position',[.3 0 .15 .04],'tooltipstring','azimuth step','tag','rotazstep');
set(hb,'fontsize',8);
%AZIMUT-STP
hb=uicontrol(gcf,'style','edit','units','norm','string','0');
set(hb,'position',[.45 0 .15 .04],'tooltipstring','elevation step','tag','rotelstep');
set(hb,'fontsize',8);
%pause
hb=uicontrol(gcf,'style','edit','units','norm','string','.1');
set(hb,'position',[.6 0 .15 .04],'tooltipstring','sleep between rotations','tag','rotsleep');
set(hb,'fontsize',8);
%save movie
hb=uicontrol(gcf,'style','radio','units','norm','string','save','value',0);
set(hb,'position',[.75 0 .5 .04],'tooltipstring','save as movie','tag','rotsave');
set(hb,'fontsize',8,'backgroundcolor','w');

% NODES AND CONNECTIONS
hb=uicontrol(gcf,'style','pushbutton','units','norm','string','nodes&links');
set(hb,'position',[.0 .2 .4 .04],'tooltipstring','plot nodes & links','tag','nodesandlinks');
set(hb,'fontsize',8,'callback', @nodesandlinks);


% ==============================================
%%   OS-dependency
% ===============================================
if isunix==1 && ismac==0
    set(findobj(findobj(0,'tag','winselection'),'type','uicontrol'),'fontsize',7);
end

%MENU
set(gcf,'DockControls','off');
f = uimenu('Label','Aux');
f2= uimenu(f,'Label','display available colormaps','Callback',@Colormaps_showAll);



   
    
function Colormaps_showAll(e,e2)
% show available colormaps
hw=findobj(0,'tag','winselection');
hc=findobj(hw,'tag','scmap');
li=get(hc,'string');
li(regexpi2(li,'user'))=[];
maps=ones([ length(li)  64 3 ]);
for i=1:length(li)
    cm=sub_intensimg('getcolor',li{i});
    cm2=permute(cm,[3 1 2]);
    if size(cm2,2)~=64
        cm2=imresize(cm2,[1 64]);
    end
    maps(i,:,:)=cm2;
    %disp([i size(cm,1)]);
end
% ==============================================
%%   
% ===============================================
nb(2)=[ 3];
nb(1)=ceil(size(maps,1)./nb(2));
fg;
set(gcf,'menubar','none','NumberTitle','off','name','available ColorMaps');
for i=1:size(maps,1)
    subplot(nb(1),nb(2),i);
    image(maps(i,:,:));
    t=text(1,0.5,li{i});
    set(t,'position',[34 1],'horizontalAlignment','center','fontsize',8);
    set(gca,'xtick',[],'ytick',[]);
end
hb=uicontrol(gcf,'style','pushbutton','units','norm');
set(hb,'position',[.3 .95 .4 .05]);
set(hb,'string','Colormaps','fontsize',9,'fontweight','bold','backgroundcolor','w');


% ==============================================
%%   
% ===============================================


        
        
function cb_help(e,e2);
uhelp([mfilename '.m']);

function nodesandlinks(e,e2)

hf=findobj(0,'tag','xvol3d');
if isempty(hf);
    h = msgbox(['ERROR' char(10) 'please load a mask before plotting nodes & links']);
    return
end

sub_plotconnections();


function slight(e,e2)
% show arrows
if isfield(e,'light')
    if strcmp(e.light,'on'); val=1; else; val=0; end
    set(findobj(findobj(0,'tag','winselection'),'tag','rblight'),'value',val);
    ht=findobj(findobj(0,'tag','winselection'),'tag','rblight');
    hgfeval(get(ht,'callback'));
end


function showarrows(e,e2)
% show arrows
if isfield(e,'arrows')
    if strcmp(e.arrows,'on'); val=1; else; val=0; end
    set(findobj(findobj(0,'tag','winselection'),'tag','showarrows'),'value',val);
end


if get(findobj(findobj(0,'tag','winselection'),'tag','showarrows'),'value')==1
    do='on';
else
    do='off' ;
end
set(findobj(findobj(0,'tag','xvol3d'),'tag','arrow'),'visible',do);
set(findobj(findobj(0,'tag','xvol3d'),'tag','arrowtxt'),'visible',do);


function braindot(e,e2)
p1=findobj(findobj(0,'tag','xvol3d'),'tag','brain');
if isempty(p1); return; end
ro=get(p1,'vertices');
p2=findobj(findobj(0,'tag','xvol3d'),'tag','braindot');
delete(p2);
if get(e,'value')==1
    stp=10;
    vc=1:stp:length(ro);
    axes(findobj(findobj(0,'tag','xvol3d'),'tag','ax0'));
    pl=plot3(ro(vc,1),ro(vc,2),ro(vc,3),'k.');
    set(pl,'MarkerSize',.001,'tag','braindot');
end


function cbarlabelmode(e,e2)
hs=findobj(0, 'tag','winselection');
ev=findobj(hs,'tag','setCrange');
str=str2num(get(ev,'string'));
if isempty(str); set(ev,'string','nan nan');end
sub_intensimg('setcolorrange',str);


function cbarlabelshow(e,e2)
hs=findobj(0, 'tag','winselection');
hb=findobj(hs,'tag','cbarlabelshow');
hw=findobj(0,'tag','xvol3d');
axt=get(findobj(hw,'-regexp','tag','ax\d'),'tag');
axt(strcmp(axt,'ax0'))=[];

if get(hb,'value')==1
    dox='on';
else
    dox='off';
end
for i=1:length(axt)
    v=findobj(hw,'tag',axt{i});
    set(  [allchild(v) v],'visible',dox);
end

function setCrangedefault(e,e2)
hs=findobj(0, 'tag','winselection');
hr=findobj(hs,'tag','setCrange');
str='nan nan';
set(hr,'string',str);
sub_intensimg('setcolorrange',str2num(str));

function setCrange(e,e2)
str=str2num(get(e,'string'));
if isempty(str); set(e,'string','nan nan');end
sub_intensimg('setcolorrange',str);

function setLight(e,e2, param);
hs=findobj(0, 'tag','winselection');
hr=findobj(hs, 'tag','rblight');
if isempty(hs) ; return; end
if exist('param') && strcmp(param,'updateRadio')
    hl=findobj(findobj(0,'tag','xvol3d'),'type','light');
    if isempty(hl);      set(hr,'value',0) ;
    else;                set(hr,'value',1) ;
    end
    return
end
if ~isempty(e) && ischar(e) && strcmp(e,'on')  ;%  setLight('on')
    set(hr,'value',1) ;
elseif ~isempty(e) && ischar(e) && strcmp(e,'off')%  setLight('off')
    set(hr,'value',0) ;
end


if get(hr,'value')==1
    %     hl=findobj(findobj(0,'tag','xvol3d'),'type','light');
    %     delete(hl);
    axes(findobj(findobj(0,'tag','xvol3d'),'tag','ax0'));
    %camlight('headlight');
    c=findobj(findobj(0,'tag','xvol3d'),'tag','camlight');
    if isempty(c)
        c = camlight('headlight');    % Create light
        set(c,'style','infinite','tag','camlight');    % Set style
        h = rotate3d;                 % Create rotate3d-handle
        h.ActionPostCallback = @RotationCallback; % assign callback-function
        h.Enable = 'on';              % no need to click the UI-button
    else
        set(c,'visible','on');
    end
else
    %delete(findobj(findobj(0,'tag','xvol3d'),'type','light'));
    c=findobj(findobj(0,'tag','xvol3d'),'tag','camlight');
    set(c,'visible','off');
    h = rotate3d;
    h.ActionPostCallback =[];
end

function RotationCallback(~,~)
c=findobj(findobj(0,'tag','xvol3d'),'tag','camlight');
c = camlight(c,'headlight');    % Create light


function plottr(par)
if isfield(par,'plottr');
    hs=findobj(0, 'tag','winselection');
    ht=findobj(hs,'tag','cthresh2');
    %tr=str2num(get(ht,'string'));
    set(ht,'string',par.plottr);%set threshold
    
    cb_plotimg ([],[],2);
    if isfield(par,'alpha')==1
        ht=findobj(hs,'tag','salpha');
        set(ht,'string', (par.alpha));
        hgfeval(ht.Callback,ht,'alpha');
    end
    
    
    
    
end

function plotslice (v)

% xvol3d('plotslice','cmap','cool','transp',[.2],'thresh',[0 100],'nanval',0);
hs=findobj(0, 'tag','winselection');
if isfield(v,'cmap')
    hc=findobj(hs,'tag','sliceCmap');
    li=get(hc,'string');
    va=find(strcmp(li,v.cmap));
    if va>1 & va<=length(li)
        set(hc,'value',va);
    else
        set(hc,'value',1);
        disp('colormap must be of string-tybe e.g. "jet")');
    end
end
if isfield(v,'transp')
    set(findobj(hs,'tag','sliceTrans'),       'string',num2str(v.transp));
end
if isfield(v,'thresh')
    set(findobj(hs,'tag','sliceThresh'),       'string',num2str(v.thresh));
end
if isfield(v,'nanval')
    set(findobj(hs,'tag','sliceNaN'),       'string',num2str(v.nanval));
end
cb_plotslice();



function cb_plotslice (e,e2,setpara)
num=getIMGnum();%: 1
hf=findobj(0,'tag','xvol3d');
hs=findobj(0, 'tag','winselection');
h3=findobj(hf,'tag',['img' num2str(num) ],'-and','type','surface');
if exist('setpara')==1
    if ~isempty(h3) && strcmp(setpara,'sliceTrans')
        val=str2num(get(findobj(hs,'tag','sliceTrans'),'string'));
        set(h3,'facealpha',val);
        return
    end
    %      if ~isempty(h3) && strcmp(meth,'sliceCmap')
    %          hc=findobj(hs,'tag','sliceCmap');
    %          va=get(hc,'value');li=get(hc,'string');    cmap=li{va};
    %          axes(findobj(hf,'tag','ax0'));
    %          cmap2=sub_intensimg('getcolor',cmap);
    %          colormap(cmap2);
    %
    %
    %        return
    %     end
end

hr=findobj(hs, 'tag','currentimg');
li=get(hr,'string');  va=get(hr,'value');    c=li{va};

hc=findobj(hs,'tag','sliceCmap');
va=get(hc,'value');li=get(hc,'string');    cmap=li{va};

v=struct();
v.meth   =3;%: 3
v.num    =num;
v.file   =regexprep(c , '\d{1,10}]\s*','');
v.cmap   =cmap;%: [64x3 double]
v.tresh  =str2num(get(findobj(hs,'tag','sliceThresh'),'string'));%: [NaN NaN]
v.nanval =str2num(get(findobj(hs,'tag','sliceNaN'),'string'));% 0
v.alpha  =str2num(get(findobj(hs,'tag','sliceTrans'),'string'));%0.0500

if exist('setpara')==1
    v.set=setpara;
else
    v.set='plot-SL';
end
% disp(setpara);
% return
sub_intensimg('show',v);

% sliceCmap, sliceThresh,sliceNaN,plot-SL


function cb_plotimg (e,e2,meth)

num=getIMGnum();
v.meth=meth;
v.num =num;

hs=findobj(0, 'tag','winselection');
hr=findobj(hs, 'tag','currentimg');
li=get(hr,'string');va=get(hr,'value');
c=li{va};
v.file=regexprep(c , '\d{1,10}]\s*','');

sub_intensimg('delete',num);

%    v.num=2
%     v.cmap =summer;
%     % tresh =[50 90]
%     % tresh=[80 nan]
%     v.tresh=[nan nan];
%     v.thresh2=90
%     v.nclass=7
%     v.meth=1
%     v.file=fullfile(pwd,'incmap_right.nii');
%     sub_intensimg('show',v)
%
%     sub_intensimg('delete',2)


if meth==1
    ht=findobj(hs,'tag','cthresh1');
    tr=str2num(get(ht,'string'));
    if isempty(tr); tr=[nan nan]; end
    
    hc=findobj(hs,'tag','cnclasses');
    va=get(hc,'value'); li=get(hc,'string');
    nclass=str2num(li{va});
    
    v.nclass= nclass;
    v.tresh= tr;
    v.alpha='rampup';
elseif meth==2
    ht=findobj(hs,'tag','cthresh2');
    tr=str2num(get(ht,'string'));
    if isempty(tr); tr=[0 ]; end
    v.tresh2= tr;
    
    hal=findobj(hs,'tag','salpha'); %alpha
    v.alpha=str2num(get(hal,'string'));
    if length(v.alpha)>1
        v.alpha=max(v.alpha);
        set(hal,'string', num2str(v.alpha));
    end
elseif meth==3 %SLICE
    %     keyboard;
    
    ht=findobj(hs,'tag','cthresh2');
    tr=str2num(get(ht,'string'));
    if isempty(tr); tr=[0 ]; end
    v.tresh3= tr;
    hal=findobj(hs,'tag','salpha'); %alpha
    v.alpha=str2num(get(hal,'string'));
    if isnumeric( v.alpha)
        if length(v.alpha)>1;
            v.alpha=v.alpha(1);
            set(hal,'string',num2str(v.alpha));
        end
    end
    if isempty(v.alpha)
        v.alpha=0.05;
        set(hal,'string',num2str(v.alpha));
    end
    
end


hco=findobj(hs,'tag','scmap');  % colormap
va=get(hco,'value'); li=get(hco,'string');
v.cmap= (li{va});



% disp(v);
% return
sub_intensimg('delete',num);
sub_intensimg('show',v);


function numx=getIMGnum()
hs=findobj(0, 'tag','winselection');
hr=findobj(hs, 'tag','currentimg');
li=get(hr,'string');
va=get(hr,'value');
c=li{va};
if strcmp(c,'empty'); return; end
numx=str2num(regexprep(c,'].*',''));

function cb_currentimg(e,e2)
updateIMGparams();

function updateIMGparams(num)
hs=findobj(0, 'tag','winselection');
hr=findobj(hs, 'tag','currentimg');
li=get(hr,'string');
va=get(hr,'value');
c=li{va};
if strcmp(c,'empty'); return; end
numx=str2num(regexprep(c,'].*',''));
if exist('num')==0; num=numx; end %here force that the number is used

if numx~=num; return; end

hf=findobj(0,'tag','xvol3d');
ax=findobj(findobj(0,'tag','xvol3d'),'tag',['ax' num2str(numx)]);

if isempty(ax); return; end

num=numx;

h3=findobj(hf,'tag',['img' num2str(num) ],'-and','type','surface');  %PLOT-SLICE
if ~isempty(h3); return; end

% update'alpha'-----------------------------
% set(hb,'tag','salpha');
hp=findobj(findobj(0,'tag','xvol3d'),'tag',['img' num2str(num)]);
try
    [~,isort]=sort(cell2mat(get(hp,'userdata')));
    hp(isort);
    msg=get(hp(isort),'facealpha');
    trans=cellfun(@(a){ [ sprintf('%.3f',a) ]}, msg );
catch
    msg={get(hp,'facealpha')};
    try
        trans=cellfun(@(a){ [ sprintf('%.3f',a) ]}, msg );
    catch
        trans=cellfun(@(a){ [ sprintf('%.3f',a) ]}, msg{1} );
    end
end
trans=regexprep(trans,'0\.','.');
trans=strjoin(trans,' ');
hx=findobj(hs, 'tag','salpha');
set(hx,'string',trans);

cmap=getappdata(ax,'cmap');%update cmap-----------------------------
if isnumeric(cmap); return; end
hv=findobj(hs,  'tag','scmap');
li2=get(hv,'string');
va=regexpi2(li2,['^' cmap '$']);
set(hv,'value',va);


function setIMGviaPulldown(e,e2)
hs=findobj(0, 'tag','winselection');
li=get(e,'string');
va=get(e,'value');
val=li{va};
e=findobj(hs,'tag','salpha');
set(e,'string',val);
setIMG(e,[],'alpha')  ; %eval here
uicontrol(findobj(hs,'tag','spdalpha'));


function setIMG(e,e2,par)
num=getIMGnum();
if strcmp(par,'scmap')
    va=get(e,'value'); li=get(e,'string');
    cmap=li{va};
    
    sub_intensimg('applychangecolor',{num,cmap});
    uicontrol(e);
    
elseif strcmp(par,'alpha')
    %     va=str2num(get(e,'string'));
    va= (get(e,'string'));
    
    hp2=findobj(findobj(0,'tag','xvol3d'),'tag',['img' num2str(num) ],'type','surface') ;
    if ~isempty(hp2) %slice/surface
        va2=str2num(va);
        if length(va2)>1; va2=va2(1); set(e,'string',num2str(va2));end
        if isempty(va2); va2=0.05; set(e,'string',num2str(va2));end
        set(hp2,'FaceAlpha',(va2));
        uicontrol(e);
        return
    end
    
    sub_intensimg('setalpha',struct('num',num,'alpha',va));
    uicontrol(e);
end

function cb_deletestatimg(e,e2)
num=getIMGnum();
if isempty(num); return; end

hax=findobj(findobj(0,'tag','xvol3d'),'tag',['ax' num2str(num)]);
hp2=findobj(findobj(0,'tag','xvol3d'),'tag',['img' num2str(num) ]) ;

delete(hax);
delete(hp2);


function statimage(par)
cb_loadstatimg([],[],par);


function cb_loadstatimg(e,e2,par)
% plotintensimage()


% 'tag','currentimg'
% loadstatimg

% if exist(file)==0
if exist('par')==0
    [fi pa]=uigetfile(fullfile(pwd,'*.nii'),'select stat image');
    if isnumeric(pa); return; end
    file=fullfile(pa,fi);
else
    [pw name ext]=fileparts(par);
    if isempty(pw); pw=pwd; end
    file=fullfile(pw,[name ext]);
end


hw=findobj(0,'tag','winselection');
hr=findobj(hw, 'tag','currentimg');

li=get(hr,'string');
va=get(hr,'value');
if sum(strcmp(li,'empty'))==1 | isempty(li)
    newnum=1;
    li={[ num2str(newnum) ']' file]};
else
    newnum=min(setdiff([1:1e4], str2num(char(regexprep(li,'].*','')))));
    linew={[ num2str(newnum) ']' file]};
    li=[li; linew];
end


set(hr,'string',li );
set(hr,'value',length(li));


%
% hf=findobj(0,'tag','xvol3d');           u=get(hf,'userdata');
%
% if ~isfield(u,'img')
%     u.img={};
%     set(hf,'userdata',u);
% end
%
% axt=get(findobj(findobj(0,'tag','xvol3d'),'-regexp','tag','ax\d'),'tag');
% axnum=str2num(cell2mat(regexprep(axt,'ax','')));
% axnum(axnum==0)=[];
% newnum=length(axnum)+1;
%
% u.img=[u.img; { newnum fullfile(pa,fi) fi}];
%
% hr=findobj(gcf, 'tag','currentimg');
% li=cellstr(get(hr,'string'));
% va=get(hr,'value');
%
% if strcmp(li,'empty')
%     set(hr,'string',{u.img{3}} );
%     set(hr,'value',1);
% else
%     set(hr,'string',[li; {u.img{3}} ]);
%     set(hr,'value',va+1);
% end
% set(hf,'userdata',u);


function updateImagelist
axt=get(findobj(findobj(0,'tag','xvol3d'),'-regexp','tag','ax\d'),'tag');
if isempty(axt); return; end
axt=cellstr(axt);
axt(regexpi2(axt,'ax0'))=[];
li={};
if isempty(axt)
    li={'empty'}  ;
else
    axnum=sort(str2num(cell2mat(regexprep(axt,'ax',''))));
    for i=1:length(axnum)
        ax=findobj(findobj(0,'tag','xvol3d'),'tag',['ax' num2str(axnum(i))]);
        fpfile=getappdata(ax,'file');
        [pa file]=fileparts(fpfile);
        lis={[ num2str(axnum(i)) '] ' fpfile ]};
        li=[li; lis];
    end
end
hr=findobj(gcf, 'tag','currentimg');
set(hr,'string',li );
set(hr,'value',1);



%
% li=cellstr(get(hr,'string'));
% va=get(hr,'value');
% hf=findobj(0,'tag','xvol3d');           u=get(hf,'userdata');
% if strcmp(li,'empty')
% %     set(hr,'string',{u.img{3}} );
% %     set(hr,'value',1);
%
%    try
%      set(hr,'string', u.img(:,3) );
%       set(hr,'value',1);
%    end
%
% else
%
% end





function regionpara(e,e2,para)
hp=findobj(findobj(0,'tag','xvol3d'),'tag','region');
if strcmp(para,'visible')
    if    get(e,'value')==1;         set(hp,'visible','on');
    else                             set(hp,'visible','off');
    end
elseif strcmp(para,'alpha')
    set(hp,'facealpha',str2num(get(e,'string')));
    
    %set alpha in regionTable
    try %if exist
        set(findobj(findobj(0,'tag','regionselect'),'tag','alphaall'),'string',get(e,'string'))
    end
    
end



function autorot(e,e2)
warning off
hf=findobj(0,'tag','xvol3d');
hw=findobj(0,'tag','winselection');

if get(e,'value')==0
    set(e,'backgroundcolor',[0.9400    0.9400    0.9400]);drawnow;
else
    if get(findobj(hw,'tag','rotsave'),'value')==1
        set(e,'backgroundcolor',[1 0 0]); drawnow;
           rotHideControls(1);
    else
        set(e,'backgroundcolor',[1 1 0]);drawnow;
    end
end



azstep     =str2num(get(findobj(hw,'tag','rotazstep'),'string'));
elstep     =str2num(get(findobj(hw,'tag','rotelstep'),'string'));
sleeptime  =str2num(get(findobj(hw,'tag','rotsleep'),'string'));
dosave     =       (get(findobj(hw,'tag','rotsave'),'value'));
u=get(hf,'userdata');
if ~isfield(u,'hmovie'); u.hmovie=[];   set(hf,'userdata',u); end


figure(hf);
ax0=findobj(hf,'tag','ax0');

% ==============================================
%%  OFF-setting..stop movie
% ===============================================

if get(e,'value')==0
    if isfield(u,'hmovie')
        drawnow
        delete(findobj(findobj(0,'tag','winselection'),'type','axes'));
        if dosave==1
            close(u.hmovie) ;
            outname=fullfile(u.hmovie.Path,u.hmovie.Filename);
            u=get(hf,'userdata');         u.hmovie=[];         set(hf,'userdata',u);
%             fprintf('..finished.\n');
%             showinfo2('new movie',outname);
        end
    end
    set(e,'backgroundcolor',[0.9400    0.9400    0.9400]);
    rotHideControls(0);
    %disp('stop-1');
    return
end



% ==============================================
%%
% ===============================================
if get(e,'value')==1
    if dosave==1 && isempty(u.hmovie)==1
        %filter = {'*.mp4';'*.avi';'*.*'};
        [fi pa]= uiputfile('*.*','select movie Name');
        if isnumeric(fi); 
            set(e,'value',0); 
            return; 
        end
        outname=fullfile(pa,fi);
        [pa fi ext]=fileparts(outname);
        outname=fullfile(pa,[fi]);
        
        try
            fprintf('..wait..saving movie');
            try % WIN/MAC
                v = VideoWriter([outname   ],'MPEG-4');
            catch %linux
                v = VideoWriter([outname   ],'Motion JPEG AVI');
            end
            open(v);
            u=get(hf,'userdata');         u.hmovie=v;         set(hf,'userdata',u);
        catch
            fprintf('..error..cancelled\n');
            set(e,'backgroundcolor',[0.9400    0.9400    0.9400]);
            dosave=0;
            u=get(hf,'userdata');         u.hmovie=[];         set(hf,'userdata',u);
            disp('stop-2');
        end
    end
    
    
    if  get(e,'value')==1
        iterat= str2num(get(findobj('tag','rotdur'),'string'));
    else
        iterat=0;
    end
    
    for i = 1:iterat
        %disp(i);
        camorbit(azstep,elstep,'data',[   0 0 1]);
        if get(findobj(hw,'tag','rblight'),'value')==1
            c=findobj(findobj(0,'tag','xvol3d'),'tag','camlight');
            camlight(c,'headlight');
        end
        
        pause(sleeptime) ;
        if dosave==1
            axis tight
            posx(i,:)=get(gca,'position');
            frame = getframe(hf);
            %         drawnow;
            if i==1
                siz=size(frame.cdata);
            else
                frame.cdata= imresize(frame.cdata,[siz(1:2)]);
            end
            try
                writeVideo(u.hmovie,frame);
            catch
                set(e,'value',0);
                break
            end
            
        end
        
        
        if get(e,'value')==0  % end movie
            drawnow
            delete(findobj(findobj(0,'tag','winselection'),'type','axes'));
            if dosave==1;
                close(u.hmovie) ;
                outname=fullfile(u.hmovie.Path,u.hmovie.Filename);
                u=get(hf,'userdata');         u.hmovie=[];         set(hf,'userdata',u);
                fprintf('..finished.\n');
                showinfo2('new movie',outname);
                rotHideControls(0);
            end
            break
        end
    end
    set(e,'value',0);
    
    if get(e,'value')==0  % end movie
        drawnow
        delete(findobj(findobj(0,'tag','winselection'),'type','axes'));
        set(e,'backgroundcolor',[0.9400    0.9400    0.9400]);
        %disp('stop-3');
        if dosave==1;
            close(u.hmovie) ;
            outname=fullfile(u.hmovie.Path,u.hmovie.Filename);
            u=get(hf,'userdata');         u.hmovie=[];         set(hf,'userdata',u);
            fprintf('..finished.\n');
            showinfo2('new movie',outname);
            rotHideControls(0);
        end
        return
    end
    
end

function rotHideControls(mode)
hf=findobj(0,'tag','xvol3d');
tags={'explodeview' 'exploderenew'  'showbrain'  'showlabel'};
if mode==1;     do='off'; else;  do='on';  end
for i=1:length(tags); 
    set(findobj(hf,'tag',tags{i}),'visible',do);
end


function brainalpha(par)

ht=findobj(findobj(0,'tag','winselection'),'tag','brainalpha');
set(ht,'string',num2str(par.brainalpha));
hgfeval(get(ht,'callback'),ht,'alpha');

function materialparam(e,e2,par)
li=get(e,'string');
va=get(e,'value');
figure(findobj(0,'tag','xvol3d'));
material(li{va});

function brainparam(e,e2,par,par2)
p1=findobj(findobj(0,'tag','xvol3d'),'tag','brain');
if isempty(p1); return; end
if strcmp(par,'alpha')
    set(p1,'facealpha',str2num(get(e,'string')));
elseif strcmp(par,'color')
    if exist('par2')==1
        set(p1,'facecolor',par2);
    else
        set(p1,'facecolor',uisetcolor);
    end
end


function cb_loadatlas(e,e2)
prepareWindow;
loadatlas();


function loadatlas(atlasfile)
prepareWindow;
if exist('atlasfile')==0; atlasfile=[]; end
hs=findobj(0,'tag','xvol3d'); u=get(hs,'userdata');
if isfield(u,'atlas')==0  || ~isempty(atlasfile)
    fprintf('..loading atlas');
    
    if exist(atlasfile)==0
        [fi pa]=uigetfile(fullfile(pwd,'*.nii'),'select "ANO.nii"');
        if isnumeric(pa); return; end
        atlasfile=fullfile(pa,fi);
        
    end
    u.atlas=fullfile(atlasfile);
    [ha a]=rgetnii(u.atlas);
    u.atl =a;
    u.hatl=ha;
    
    u.lut =strrep(atlasfile,'.nii','.xlsx');
    fprintf('..loading LUT(excelfile)');
    if exist(u.lut)
        [~,~,lu]=xlsread(u.lut);
    else
        lu=atlasWithoutExcel(u.atlas);
    end
    lu(strcmp(cellfun(@(a){ [num2str(a) ]},lu(:,1)),'NaN'),:)=[]; %del-NANrow
    lu(:,strcmp(cellfun(@(a){ [num2str(a) ]},lu(1,:)),'NaN'))=[]; %del-NANcol
    u.hlu =lu(1,:);
    u.lu  =lu(2:end,:);
    
    ich=find(strcmp(u.hlu,'colRGB'));
    u.lu(:,ich)=...%convert to 0-1-range
        regexprep(cellfun(@(a){ [num2str(str2num(a)./255)]},   u.lu(:,ich)),'\s+',' ');
    
    set(hs,'userdata',u);
    disp('..saving atlas');
end

function  lu=atlasWithoutExcel(atlas)

[ha a]=rgetnii(atlas);
uni=unique(a(:)); uni(uni==0)=[];
rgb = round(distinguishable_colors(length(uni),[1 1 1; 0 0 0])*255);

hd={'Region'	'colHex'	'colRGB'	'ID'	'Children'};
region=cellfun(@(a){['region' num2str(a)]}, num2cell(uni));
hexcol=cellstr(reshape(sprintf('%02X',rgb.'),6,[]).');
rgbcol=cellfun(@(a,b,c){[ num2str(a) ' ' num2str(b)  ' ' num2str(c) ]}, num2cell(rgb(:,1)),num2cell(rgb(:,2)),num2cell(rgb(:,3)));
child=repmat({[]},[length(uni) 1]);
d=[region hexcol rgbcol num2cell(uni) child];
lu=[hd; d];



function cb_selectRegions(e,e2)
selectRegions;

function cb_loadselectRegions(e,e2)
regions()

function cb_selectbyID(e,e2,IDs)

prepareWindow;
hs=findobj(0,'tag','xvol3d'); u=get(hs,'userdata');

if exist('IDs')==0
    %ids= input('select IDs : ', 's');
    
    prompt = {'Enter IDs/ROI-indices to preselect'};
    title = 'Preselect Regions';
    definput = {''};
    answer = inputdlg(prompt,title,[1 40],definput);
    ids    = str2num(char(answer));
else
    ids= IDs;
end

idall=cell2mat(u.lu(:,regexpi2(u.hlu,'ID')));
ixID=zeros(length(ids),1);
for i=1:length(ids)
    ixID(i,1)= find(idall==ids(i));
end
iuse=find(ixID~=0);
ids =ids(iuse);
isel=ixID(iuse);

% isel=find(cell2mat(cellfun(@(a){ [str2num(num2str(a))]}, reg(:,isel1) ))==1); %selected rows
if ~isfield(u,'selectedRegion')
    u.selectedRegion=zeros(size(u.lu,1),1);
end
u.selectedRegion(isel)=1;


%
% if ~isempty(icol2)  %UPDATE COLOR IN LU-table
%     for i=1:length(isel)
%         id   =cell2mat(reg(isel(i)   ,iID1 ));
%         col  =cell2mat(reg(isel(i)   ,icol1));
%         ix=find(IDvec2==id);
%         if ~isempty(ix) %update color
%             u.lu{ix, icol2} = regexprep(num2str(str2num(col)/255),'\s+',' ');
%         end
%     end
% end
set(hs,'userdata',u);
disp('..saving selected regions');




% ==============================================
%%
% ===============================================

function regions(file)
prepareWindow;
if exist('file')~=1; file=[]; end
hs=findobj(0,'tag','xvol3d'); u=get(hs,'userdata');
if isfield(u,'atlas')==1  %|| ~isempty(file)
    fprintf('..loading selected regions');
    
    if exist('file')~=1 || isempty(file)
        [fi pa]=uigetfile(fullfile(pwd,'*.xlsx'),'select "your selected region file"');
        if isnumeric(pa); return; end
        file=fullfile(pa,fi);
        
    end
    u.regions=fullfile(file);
    [~,~,reg]=xlsread(u.regions);
    
    
    reg(strcmp(cellfun(@(a){ [num2str(a) ]},reg(:,1)),'NaN'),:)=[]; %del-NANrow
    reg(:,strcmp(cellfun(@(a){ [num2str(a) ]},reg(1,:)),'NaN'))=[]; %del-NANcol
    hreg=reg(1,:);
    reg=reg(2:end,:);
    
    isel1=find(strcmp(hreg,'selection')); % in selecttion
    if isempty(isel1)
        g=input('select column-idx of selected regions (0/1-values) in xls-file: '); %USER INPUT
        isel1=g;
    end
    iID1=find(strcmp(hreg,'ID'));
    icol1=find(strcmp(hreg,'colRGB'));
    
    iID2   =find(strcmp(u.hlu,'ID'));   % IN LU
    icol2  =find(strcmp(u.hlu,'colRGB'));
    IDvec2 =cell2mat(u.lu(:,iID2));
    
    isel=find(cell2mat(cellfun(@(a){ [str2num(num2str(a))]}, reg(:,isel1) ))==1); %selected rows
    u.selectedRegion=zeros(size(u.lu,1),1);
    u.selectedRegion(isel)=1;
    
    if ~isempty(icol2)  %UPDATE COLOR IN LU-table
        for i=1:length(isel)
            id   =cell2mat(reg(isel(i)   ,iID1 ));
            col  =cell2mat(reg(isel(i)   ,icol1));
            ix=find(IDvec2==id);
            if ~isempty(ix) %update color
                u.lu{ix, icol2} = regexprep(num2str(str2num(col)/255),'\s+',' ');
            end
        end
    end
    set(hs,'userdata',u);
    disp('..saving selected regions');
    disp('..click "plot regions to see regions"');
end

function selectRegions()


% fg;
% hs=gcf;
% set(hs,'units','norm','menubar','none','position',[0.1632    0.4178    0.1410    0.5211]);
% set(hs,'tag','regionselect','NumberTitle','off','name','regions');

sub_plotregions;


function cb_loadbrainmask(e,e2)
loadbrainmask();

function loadbrainmask(maskfile)
prepareWindow
if exist('maskfile')~=1; maskfile=[]; end
hs=findobj(0,'tag','xvol3d'); u=get(hs,'userdata');
if isfield(u,'mask')==0  || ~isempty(maskfile)
    fprintf('..loading brain mask');
    
    if exist('maskfile')~=1 || isempty(maskfile)
        [fi pa]=uigetfile(fullfile(pwd,'*.nii'),'select "AVGTmask.nii"');
        if isnumeric(pa); return; end
        maskfile=fullfile(pa,fi);
    end
    u.mask=fullfile(maskfile);
    set(hs,'userdata',u);
    disp('..saving mask');
end


hbrain=findobj(hs,'tag','brain');
if ~isempty(hbrain)
    fprintf('..deleting old brain mask');
    delete(hbrain);
end
[ha a]=rgetnii(u.mask);
[x,y,z,d2] = reducevolume(a,[1,1,1]);
d2 = smooth3(d2);

figure(findobj(0,'tag','xvol3d'))
p1 = patch(isosurface(x,y,z,d2,  [.5]   ),...
    'FaceColor','red','EdgeColor','none');
set(p1,'tag','brain','hittest','off');
set(gca,'tag','ax0');
% isonormals(x,y,z,d2,p1)
% p2 = patch(isocaps(x,y,z,d2,va),...
%     'FaceColor','interp','EdgeColor','none');
set(gca,'ydir','reverse');
view(3);
axis tight;
% daspect([1,1,.4]);
daspect([1,1,1]);
% colormap(gray(100));
% camlight;
setLight('on');
lighting gouraud;
set(p1,'FaceAlpha',.05);
hold on;
axis vis3d;
rotate3d on
axis off

material dull
set(p1,'facealpha',.05);
set(p1,'facecolor',[0.9333    0.9333    0.9333]);

MAKEARROW;
fprintf('..done\n');


function MAKEARROW
% ==============================================
%%
% ===============================================
aroffset =.1;
arlength =.15;
lims=[xlim; ylim; zlim];
%start 10% from left side
arStart=(lims(:,2)-lims(:,1)).*aroffset+lims(:,1);
arStop=(lims(:,2)-lims(:,1)).*arlength+arStart;
% ==============================================

% disp('astartstop');
% disp(lims);
% disp('astartstop');
% disp([arStart arStop]);
delete(findobj(gcf,'tag','arrow'));
delete(findobj(gcf,'tag','arrowtxt'));
artx={'A' 'R' 'S'};
for i=1:3
    ar=[arStart arStart];
    ar(i,2)=arStop(i);
    h = mArrow3(ar(:,1),ar(:,2),'color','red','stemWidth',.5,'facealpha',0.5);
    set(h,'tag','arrow');
    
    ht=text(ar(1,2),ar(2,2),ar(3,2),artx{i});
    set(ht,'fontsize',6,'tag','arrowtxt');
    set(ht,'VerticalAlignment','baseline');
end
axis off


function prepareWindow
if ~isempty(findobj(0,'tag','xvol3d'))
    return
end

opengl hardwarebasic
fg;
hs=gcf;
set(hs,'units','norm','NumberTitle','off');
set(hs,'tag','xvol3d','name','xvol3d');

v.dummy=1;
set(hs,'userdata',v);


hb=uicontrol('style','radio','value',0,'units','norm','tag','explodeview');
set(hb,'position',[0 0 .1 .05],'backgroundcolor','w','fontsize',5);
set(hb,'string','Explode','tooltipstring', [ 'show regions in explode view' char(10) '..atlas regions must be loaded and displayed before']);
set(hb,'callback',@explodeview);
hb=uicontrol('style','pushbutton','value',0,'units','norm','tag','exploderenew');
set(hb,'position',[0.075 0.005 .05 .035],'backgroundcolor','w','fontsize',5);
set(hb,'string','Renew','tooltipstring', ['renew "explode view" from another perspective' char(10) '..atlas regions must be loaded and displayed before']);
set(hb,'callback',@exploderenew);
hb=uicontrol('style','togglebutton','value',1,'units','norm','tag','showbrain');
set(hb,'position',[0.075+.05 0.005 .05 .035],'backgroundcolor','w','fontsize',5);
set(hb,'string','Brain','tooltipstring', [' show/hide brain mask' char(10) '..brain/brainmask must be loaded and displayed before']);
set(hb,'callback',@showbrain);

hb=uicontrol('style','togglebutton','value',0,'units','norm','tag','showlabel');
set(hb,'position',[0.075+2*.05 0.005 .05 .035],'backgroundcolor','w','fontsize',5);
set(hb,'string','Label','tooltipstring',['show/hide atlas region labels' char(10) '..atlas regions must be loaded and displayed before']);
set(hb,'callback',@showlabel);



function showlabel_ext(par)
hf=findobj(0,'tag','xvol3d');
hr=findobj(hf,'tag','showlabel');
if strcmp(par.regionlabels,'on')==1; 
    val=1;
else
    val=0;
end
set(hr,'value',val);
showlabel([],[]);

% ==============================================
%%   show labels
% ===============================================

function showlabel(e,e2)
hf=findobj(0,'tag','xvol3d');
hr=findobj(hf,'tag','showlabel');
ha=findobj(hf,'tag','ax0');

delete(findobj(ha,'tag','txline'));
delete(findobj(ha,'tag','txlabel2')),

try
    hreg=findobj(0,'tag','regionselect');
    set(findobj(hreg,'tag','lab'),'value',get(hr,'value'));
end


labelhorzal={'left','center','right'};
u=get(hf,'userdata');
%  if plotlabel==1
%             
%             df=c1-ce;
%             dfn=df./(sqrt(sum(df.^2)));
%             ct=c1+dfn*(u.lab.needlelength)    ;%
%             cn=c1+dfn*(u.lab.needlelength+2)  ;%
%             
%             %             ct=c1-(sign(ce-c1)*u.lab.needlelength)    ;%
%             %             cn=c1-(sign(ce-c1)*(u.lab.needlelength+2));%
%             te=text(cn(:,1),cn(:,2),cn(:,3), d{i,regexpi2(cname,'label1')},'fontsize',u.lab.fs,'Color',u.lab.fcol);
%             set(te,'userdata',['nodetxt' num2str(i) 'a'],'HorizontalAlignment',labelhorzal{u.lab.fhorzal});
%             if u.lab.needlevisible==1
%                 hp=plot3([c1(1) ct(1)],[c1(2) ct(2)],[c1(3) ct(3)],'k','color',u.lab.needlecol);
%                 set(hp,'userdata',['needletxt' num2str(i) 'a']);
%             end
%         end

if get(hr,'value')==1
    % ==============================================
    %   get brain-patch
    % ===============================================
    hb=findobj(ha,'tag','brain');
    ce=mean([mean(get(hb,'xdata'),2)    mean(get(hb,'ydata'),2)    mean(get(hb,'zdata'),2)],1);
    mn=mean([ min(get(hb,'xdata'),[],2)  min(get(hb,'ydata'),[],2)  min(get(hb,'zdata'),[],2)],1);
    mx=mean([ max(get(hb,'xdata'),[],2)  max(get(hb,'ydata'),[],2)  max(get(hb,'zdata'),[],2)],1);
    sizp=mx-mn;
    cent=sizp/2;
    % ==============================================
    %%
    % ===============================================
    hp=findobj(ha,'tag','region');
    modi=[];
    for i=1:length(hp);
        try
            ub=getappdata(hp(i),'store') ;
            modi(i,1)=ub.mode;
        catch
            modi(i,1)=0;
        end
        if strcmp(get(hp(i),'visible'),'off')==1;
            modi(i,1)=1;
        end
    end
    hp=hp(find(modi==0));
    
    
    for i=1:length(hp)
        
        hi=hp(i);
        
%         x=get(hi,'xdata');
%         y=get(hi,'ydata');
%         z=get(hi,'zdata');
%         co=[mean(x(:))  mean(y(:))  mean(z(:)) ];
%         co=[mean(x(:))  max(y(:))  mean(z(:)) ];
        
        
        cv=get(hi,'vertices');
        il=find(cv(:,2)< sizp(2)/2);
        ir=find(cv(:,2)>=sizp(2)/2);
        nlr=[length(il) length(ir)];% # left/right
        imax=find(nlr==max(nlr));
        if imax==1
            cv=cv(il,:);
            co=mean( cv(find(cv(:,2)==min(cv(:,2))),:),1); %external left
        else
            cv=cv(ir,:);
            co=mean( cv(find(cv(:,2)==max(cv(:,2))),:),1); %external right
        end
%         cn=mean(cv,1);% mean coordinate , but not neccessary inside object
%         dist=sum((cv-repmat(cn,[size(cv,1) 1])).^2,2);
%         imindist=min(find(dist==min(dist)));
%         co=cv(imindist,:);
      dist=sqrt(sum((cv-repmat(co,[size(cv,1) 1])).^2,2  ));
      iball=find(dist<10);
      c1=mean(cv(iball,:)); %within spherePath

%         c1=co;
        df=(c1-cent);
        
        
        %df=c1-ce;
        dfn=df./(sqrt(sum(df.^2)));
        ct=c1+dfn*(u.lab.needlelength)    ;%
        cn=c1+dfn*(u.lab.needlelength+5)  ;%
        
        label=getappdata(hi,'label');
        te=text(cn(:,1),cn(:,2),cn(:,3), label,...
            'fontsize',u.lab.fs,'Color',u.lab.fcol);
        set(te,'HorizontalAlignment',labelhorzal{u.lab.fhorzal});
        set(te,'tag','txlabel2','interpreter','none');
        if u.lab.needlevisible==1
            hl=plot3([c1(1) ct(1)],[c1(2) ct(2)],[c1(3) ct(3)],'k','color',u.lab.needlecol);
            set(hl,'linewidth',.1,'tag','txline');
        end

        
        
        
        
%         %ds=(mean(abs(df)./((mx-mn)./2)*1));
%         spacefac=1;
%         
%         txfac=spacefac+.1;
%         tp =co+df*spacefac;
%         tx=co+df*txfac;
%         
%         hl=plot3([tp(1) co(1) ],[tp(2)  co(2) ],[tp(3)  co(3)],'k-');
%         set(hl,'tag','txline');
%         
%         label=getappdata(hi,'label');
%         te=text(tx(1),tx(2),tx(3),label);
%         set(te,'fontsize',4,'interpreter','none');
%         set(te,'HorizontalAlignment','center','tag','txlabel2');
        
        %         perc=mean(co./ce*100);
        %         disp(label);
        %         disp(1./(mean(abs(df)./((mx-mn)./2)*1)));
    end
%     set(findobj(ha,'tag','txline'),'linewidth',.1);
end






function showbrain(e,e2)
hf=findobj(0,'tag','xvol3d');
hr=findobj(hf,'tag','showbrain');
if get(hr,'value')==1
    set(findobj(hf,'tag','brain'),'visible','on');
else
    set(findobj(hf,'tag','brain'),'visible','off');
end

function exploderenew(e,e2)
hf=findobj(0,'tag','xvol3d');
hr=findobj(hf,'tag','explodeview');
set(hr,'value',1);

ha=findobj(hf,'tag','ax0');
hp=findobj(ha,'tag','region');

modi=[];
for i=1:length(hp);
    ub=getappdata(hp(i),'store') ;
    try
    modi(i,1)=ub.mode;
    catch
        return
    end
end
hpx=hp(find(modi==1));

explodeview([],[],hpx);


function explodeview(e,e2,thishp)

hf=findobj(0,'tag','xvol3d');
hr=findobj(hf,'tag','explodeview');
mode=get(hr,'value');

ha=findobj(hf,'tag','ax0');
hp=findobj(ha,'tag','region');

% if length(hp)==1; hp={hp}; end
if length(hp)==1
    set(hp,'ButtonDownFcn',{@explodeview,hp}) ;
else
    for i=1:length(hp)
        set(hp(i),'ButtonDownFcn',{@explodeview,hp(i)}) ;
    end
end





% ==============================================
%
% ===============================================


if exist('thishp')==1
    
    do=zeros(length(hp),1);
    labs={};
    for i=1:length(hp)
        labs{end+1,1}=getappdata(hp(i),'label');
    end
    
    if length(thishp)==1
        do(strcmp(labs,getappdata(thishp,'label')))=1;
    else
        labs2={};
        for i=1:length(thishp)
            labs2{end+1,1}=getappdata(thishp(i),'label');
        end
        [ra ri]=ismember(labs,labs2);
        do(find(ra),1)=1;
    end
    
    
    if length(thishp)==1
        %     ub=getappdata(hp(find(do)),'store')
        ub=getappdata(hp(min(find(do))),'store') ;
        mode=~ub.mode;
    else
        mode=1;
    end
    
else
    do=ones(length(hp),1);
end

% ==============================================
%   get brain-patch
% ===============================================

hb=findobj(ha,'tag','brain');
ce=mean([mean(get(hb,'xdata'),2)    mean(get(hb,'ydata'),2)    mean(get(hb,'zdata'),2)],1);
mn=mean([ min(get(hb,'xdata'),[],2)  min(get(hb,'ydata'),[],2)  min(get(hb,'zdata'),[],2)],1);
mx=mean([ max(get(hb,'xdata'),[],2)  max(get(hb,'ydata'),[],2)  max(get(hb,'zdata'),[],2)],1);
sizp=mx-mn;
facresize=1.1;
% if mode==1
delete(findobj(ha,'tag','circle'));
delete(findobj(ha,'tag','txlabel'));
% ----------
[az el]=view;
az=deg2rad(az); el=deg2rad(el);
[x,y,z] = sph2cart(az,el,10);
nx=[y x z];
center=ce;
normal=nx;
radius=mean(sizp).*facresize;
theta=0:0.01:2*pi;
v=null(normal);
pointslin=repmat(center',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
%     pl=plot3(pointslin(1,:),pointslin(2,:),pointslin(3,:),'r-');
%     set(pl,'tag','circle');


np=length(hp);
theta=linspace(0,2*pi,np+1);%0:0.01:2*pi;
theta=theta(1:np);
v=null(normal);
points=repmat(center',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));

txradius=mean(sizp).*facresize*1.5;
txpoints=repmat(center',1,size(theta,2))+txradius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
% end

% ==============================================
%
% ===============================================
% mode=2;

for i=1:length(hp)
    hi=hp(i);
    
    %     disp(i);
    
    uv.xdata   =get(hi,'xdata');
    uv.ydata   =get(hi,'ydata');
    uv.zdata   =get(hi,'zdata');
    
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
        
        mx=mean(uv.xdata(:)); mx=repmat(mx,[3 1]);
        my=mean(uv.ydata(:)); my=repmat(my,[3 1]);
        mz=mean(uv.zdata(:)); mz=repmat(mz,[3 1]);
        
        
        uv.xdata   =uv.xdata-repmat(mx,[1 size(uv.xdata,2)  ] );%demean
        uv.ydata   =uv.ydata-repmat(my,[1 size(uv.xdata,2)  ] );
        uv.zdata   = uv.zdata-repmat(mz,[1 size(uv.xdata,2)  ] );
        %     uv.vertices= repmat(mean(uv.vertices,1),[size(uv.vertices,1) 1]);
        
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
        
        
        
        %     if i==1
        %         delete(findobj(ha,'tag','circle'));
        %         delete(findobj(ha,'tag','txlabel'));
        %         center=ce;
        %         normal=nx;
        %         radius=mean(sizp).*facresize;
        %         theta=0:0.01:2*pi;
        %         v=null(normal);
        %         points=repmat(center',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
        %         pl=plot3(points(1,:),points(2,:),points(3,:),'r-');
        %         set(pl,'tag','circle');
        %
        %
        %         np=length(hp);
        %         theta=linspace(0,2*pi,np+1);%0:0.01:2*pi;
        %         theta=theta(1:np);
        %         v=null(normal);
        %         points=repmat(center',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
        %
        %         txradius=mean(sizp).*facresize*1.5
        %         txpoints=repmat(center',1,size(theta,2))+txradius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
        %     end
        % pl=plot3(points(1,:),points(2,:),points(3,:),'ko');
        % set(pl,'tag','circle');
        
        points2=points(:,i);
        uv.xdata=uv.xdata+points2(1);
        uv.ydata=uv.ydata+points2(2);
        uv.zdata=uv.zdata+points2(3);
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
