
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
% [edit: 0.05]       : set transparency of selected and currently visualized regions  (range: 0-1)
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
%  #k There are two ways to visualize SI: intensity cluster #b ([plot-CL]) #k or via threshold #b ([plot-TR])
% [plot-CL]          : cluster an image into N-intensity cluster/classes. Use pulldow-menu to set 
%                      the number of classes. 
%                      Optional: Use left edit field [nan nan] to first set a lower and upper threshold
%                      before clustering into N classes: (examples: [nan nan]..no threshold; [0 nan]...only 
%                      lower threshold is used).
% [plot-TR]          : threshold SI based on a set threshold. The threshold can be changed in the left edit
%                      field ([90])
% #b Transpatency & colormap
% [parula]       : pulldownmenu to select the colormap for current SI
% [nan nan]      : optional, set lower/upper color range limits 
% [def]          : set default color range limits 
% [labm]         : radio, display either a 2-tick or N-tick colorbar
% [labs]         : radio, show/hide region labels
% [a1]           : pulldown, select different transparency settings
% [edit]         : edit field to set the transparency. For [plot-CL] you can chose as many transparency  values
%                  as classes/clusters (example:  3 classes:  "0.1 0.5 1.0" for incidency maps, with increasing
%                  transparency from inside to outside to display an intensity "core").
% #b Brain & materila & light
% [nodes & links] : display connections/connection strength --> see help there
% [arrow]         : shwo/hide orthogonal arrows
% [0.01]            :  set brain mask transparency (range: 0-1)
% [Bcol]            :  set brain mask color
% [Bdot]            :  radio, show brain mask as dotfield          
% [dull]            :  pulldown,select light-interacting material type
% [light]           :  set light. To obtain the light from the viewers location (headlight), select [light] btn twice.
% #b Movie
% [ROT]            : click [ROT] to rotate the volume; click again to stop rotation
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
% xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii')); %load brain mask
% xvol3d('loadatlas','ANO.nii');            % load atlas
% xvol3d('regions','myselection3.xlsx');    % (optional) load excel-file with preselect regions
% xvol3d('regions','plot');                 % opens regions selection table & plot preselected regions
% ------------------------------------------------
% #b Example: show preselected regions, use region IDs for preselection 
% cf
% xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii')); %load brain mask
% xvol3d('loadatlas','ANO.nii');            % load atlas
% xvol3d('regions',[672 320]);              %  preselect regions by ID (here "cauoputamne" and "prim. motor area, layer 1")
% xvol3d('regions','plot');                 % opens regions selection table; plot preselected regions
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
% xvol3d('set','material','dull'); %% set material to 'dull'
% xvol3d('set','showarrows',1); % show arrows
% xvol3d('set','light','on'); % show light
% xvol3d('set','braindot',1); % show brain as dot field
% xvol3d('set','braincolor',[1 0 1]); % set brain color
% xvol3d('set','brainalpha',1); % set alpha transparency
% xvol3d('set','material','metal','braincolor',[1 1 0]);  % example to combine parameter
% 
% #b Example: plot two intensity images
% cf
% xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii')); %load brain mask
% xvol3d('statimage','INCMAP_HR_n6.nii'); % load intensity image --> image1
% xvol3d('statimage','incmap_right.nii'); % load intensity image --> image2
% xvol3d('imagefocus',1); % set foucs to image-1
% xvol3d('plotthresh','transp',[1],'cmap','@blue','thresh',50); %display image1 via thresholding
% xvol3d('imagefocus',2); % set foucs to image-1
% xvol3d('plotclust','cmap','jet','nclasses',5,'transp',[.2],'thresh',[nan nan]);% %display image2 via clustering
% 
%  


function varargout=xvol3d(varargin)

addpath(genpath(fileparts(which('xvol3d.m'))));
if exist('smoothpatch.m')~=2
    addpath(fullfile(fileparts(which('xvol3d')),'smoothpatch_version1b'));
end

if 0
    cf
    xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii'))
    xvol3d('loadatlas','ANO.nii')
    xvol3d('statimage',fullfile(pwd,'ROI4_sm.nii'));
    
    xvol3d('regions','myselection.xlsx')
    
    xvol3d('regions','myselection2.xlsx')
    
    % ==============================================
    %%
    % ===============================================
    
    cf
    xvol3d('loadbrainmask',fullfile(pwd,'AVGThemi.nii')); %load brain mask
    xvol3d('loadatlas','ANO.nii');            % load atlas
    xvol3d('regions','myselection3.xlsx');    % (optional) load excel-file with preselect regions
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
set(hb,'position',[0.01 .75 .4 .05],'string','load selected regions');
set(hb,'callback',@cb_loadselectRegions,'fontsize',5);
set(hb,'tooltipstring','select external file (excel file) with preselected regions');

hb=uicontrol(hs,'style','pushbutton','units','norm');
set(hb,'position',[0.4 .75 .2 .05],'string','by IDs','tag','preselectByID');
set(hb,'callback',@cb_selectbyID  ,'fontsize',5);
set(hb,'tooltipstring','preselected regions by ID');



%% __________________________________________________________________________________________________
% REGIONS visible
hb=uicontrol(gcf,'style','radio','units','norm');
set(hb,'position',[0.01 .7 .25 .05],'string','Reg vis','backgroundcolor','w');
set(hb,'tooltipstring','regions visible on/off');
set(hb,'callback',{@regionpara,'visible'},'fontsize',6);
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
set(hb,'position',[0.26 .7 .15 .04],'string','','backgroundcolor','w');
set(hb,'tooltipstring','transparency');
set(hb,'callback',{@regionpara,'alpha'},'fontsize',6);
hp=findobj(findobj(0,'tag','xvol3d'),'tag','region');
if ~isempty(hp)
    set(hb,'string', num2str(get(hp(1),'facealpha'))  );
else
    set(hb,'string',.05);
end
%% ____INTENS IMAGE______________________________________________________________________________________________

hb=uicontrol(gcf,'style','pushbutton','units','norm');
set(hb,'position',[0.01 .6 .5 .035],'string','load stat img');
set(hb,'callback',@cb_loadstatimg);
set(hb,'tooltipstring','load an image=NIFTI-file (incidence map/statisit)');

hb=uicontrol(gcf,'style','pushbutton','units','norm');
set(hb,'position',[0.7 .6 .3 .035],'string','remove img');
set(hb,'callback',@cb_deletestatimg);
set(hb,'tooltipstring','remove image from from figure');



hb=uicontrol(gcf,'style','popupmenu','units','norm');
set(hb,'position',[0.01 .565 .5 .035],'string',{'empty'},'tag','currentimg');
set(hb,'tooltipstring','currently selected ..');
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
set(hb,'position',[.3 .52 .2 .03],'string',cellfun(@(a){ [ num2str(a) ]}, [num2cell([1:20]) 'user'] )');
% set(hb,'callback',{@cb_plotimg,1});
set(hb,'tooltipstring','number of classes (otsu method)','tag','cnclasses','value',3);

% ----------------------METH2
hb=uicontrol(gcf,'style','pushbutton','units','norm');
set(hb,'position',[.7 .48 .3 .03],'string','plot-TR');
set(hb,'callback',{@cb_plotimg,2});
set(hb,'tooltipstring','plot via thresholding method');


hb=uicontrol(gcf,'style','edit','units','norm');
set(hb,'position',[0 .48 .3 .03],'string','90');
set(hb,'tooltipstring','threshold (1 value) for "plot-TR"','tag','cthresh2');



% ----------------------
% CMAP
hb=uicontrol(gcf,'style','popupmenu','units','norm');
set(hb,'position',[0.0 .43 .3 .035],'string','plot');
set(hb,'tag','scmap');
set(hb,'string',sub_intensimg('getcmap'));
set(hb,'value',1);
set(hb,'tooltipstring','colormap');
set(hb,'callback',{@setIMG,'scmap'});

% cmap-range
hb=uicontrol(gcf,'style','edit','units','norm');
set(hb,'position',[.3 .43 .3 .035],'string','nan nan','fontsize',6);
set(hb,'tooltipstring','set color-range (min,max); otherwise "nan nan" for default');
set(hb,'tag','setCrange');
set(hb,'callback',{@setCrange});

% cmap-Bzttondefault
hb=uicontrol(gcf,'style','pushbutton','units','norm');
set(hb,'position',[.6 .43 .07 .035],'string','def','fontsize',6);
set(hb,'tooltipstring','set default color-range');
% set(hb,'tag','nan nan');
set(hb,'callback',{@setCrangedefault});

% cmap-Bzttondefault
hb=uicontrol(gcf,'style','radio','units','norm');
set(hb,'position',[.67 .43 .17 .035],'string','labm','fontsize',5);
set(hb,'tooltipstring','set cbar-labelmode (2 ticks or n-ticks)','backgroundcolor','w');
set(hb,'tag','cbarlabelmode','value',0);
set(hb,'callback',{@cbarlabelmode});

% cmap-Bzttondefault
hb=uicontrol(gcf,'style','radio','units','norm');
set(hb,'position',[.84 .43 .17 .035],'string','labshow','fontsize',5);
set(hb,'tooltipstring','show/hide label','backgroundcolor','w');
set(hb,'tag','cbarlabelshow','value',1);
set(hb,'callback',{@cbarlabelshow});

% ALPHA
hb=uicontrol(gcf,'style','edit','units','norm');
set(hb,'position',[.31 .395 .69 .035],'string','.02','fontsize',6);
set(hb,'tooltipstring','transparency');
set(hb,'tag','salpha');
set(hb,'callback',{@setIMG,'alpha'});


% ALPHA-'popup'
hb=uicontrol(gcf,'style','popup','units','norm');
set(hb,'position',[0 .395 .3 .035],'string',{'a','b'},'fontsize',6);
set(hb,'tooltipstring','transparency values');
set(hb,'tag','spdalpha');
set(hb,'callback',{@setIMGviaPulldown});
rr=sub_intensimg('getalpha');
set(hb,'string',rr);


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
hb=uicontrol(hs,'style','radio','units','norm','string','arrow','value',1);
set(hb,'position',[0    0.14 .2 .04],'tooltipstring','show/hide axis arrows');
set(hb,'callback',{@showarrows},'tag','showarrows','fontsize',5,'backgroundcolor','w');

%% __________________________________________________________________________________________________
%BRAIN
hb=uicontrol(hs,'style','edit','units','norm','string','0.01');
set(hb,'position',[0    0.1 .15 .04],'tooltipstring','brain alpha/transparency');
set(hb,'callback',{@brainparam,'alpha'},'fontsize',8,'tag','brainalpha');

hb=uicontrol(hs,'style','pushbutton','units','norm','string','Bcol');
set(hb,'position',[0.15 0.1 .15 .04],'tooltipstring','brain color');
set(hb,'callback',{@brainparam,'color'},'fontsize',7,'tag','braincolor');

% braindot
hb=uicontrol(hs,'style','radio','units','norm','string','Bdot');
set(hb,'position',[0.30 0.1 .15 .04],'tooltipstring','brain using dots');
set(hb,'callback',{@braindot},'fontsize',5,'backgroundcolor','w');
set(hb,'tag','braindot');
set(hb,'value',0);
bd=findobj(findobj(0,'tag','xvol3d'),'tag','braindot');
if ~isempty(bd)
    set(hb,'value',1);
end


% mATERIAL
hb=uicontrol(hs,'style','popupmenu','units','norm','string',{'dull' 'shiny' 'metal'});
set(hb,'position',[0 0.04 .3 .04],'tooltipstring','material (dull|shiny|metal)','tag' ,'material');
set(hb,'callback',{@materialparam,''},'fontsize',8);



% LIGHT
hb=uicontrol(gcf,'style','radio','units','norm','string','light');
set(hb,'position',[0.3 0.04 .25 .04],'tooltipstring','light ON/OFF');
set(hb,'callback',{@setLight},'fontsize',6,'backgroundcolor','w','tag','rblight');

setLight([],[],'updateRadio');


%rotate
hb=uicontrol(gcf,'style','togglebutton','units','norm','string','ROT','value',0);
set(hb,'position',[0 0 .15 .04],'tooltipstring','rotate now');
set(hb,'callback',{@autorot},'fontsize',7);

hb=uicontrol(gcf,'style','edit','units','norm','string','120');
set(hb,'position',[.15 0 .15 .04],'tooltipstring','iteration','tag','rotdur');
set(hb,'fontsize',7);
%AZIMUT-STP
hb=uicontrol(gcf,'style','edit','units','norm','string','3');
set(hb,'position',[.3 0 .15 .04],'tooltipstring','azimuth step','tag','rotazstep');
set(hb,'fontsize',7);
%AZIMUT-STP
hb=uicontrol(gcf,'style','edit','units','norm','string','0');
set(hb,'position',[.45 0 .15 .04],'tooltipstring','elevation step','tag','rotelstep');
set(hb,'fontsize',7);
%pause
hb=uicontrol(gcf,'style','edit','units','norm','string','.1');
set(hb,'position',[.6 0 .15 .04],'tooltipstring','sleep between rotations','tag','rotsleep');
set(hb,'fontsize',7);
%save movie
hb=uicontrol(gcf,'style','radio','units','norm','string','save','value',0);
set(hb,'position',[.75 0 .2 .04],'tooltipstring','save as movie','tag','rotsave');
set(hb,'fontsize',7);

% NODES AND CONNECTIONS
hb=uicontrol(gcf,'style','pushbutton','units','norm','string','nodes&links');
set(hb,'position',[.0 .2 .4 .04],'tooltipstring','plot nodes & links','tag','nodesandlinks');
set(hb,'fontsize',7,'callback', @nodesandlinks);


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
if get(hr,'value')==1
    hl=findobj(findobj(0,'tag','xvol3d'),'type','light');
    delete(hl);
    axes(findobj(findobj(0,'tag','xvol3d'),'tag','ax0'));
    camlight('headlight');
else
    delete(findobj(findobj(0,'tag','xvol3d'),'type','light'));
end


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

function cb_plotimg (e,e2,meth)

num=getIMGnum();
v.meth=meth;
v.num =num;

hs=findobj(0, 'tag','winselection');
hr=findobj(hs, 'tag','currentimg');
li=get(hr,'string');va=get(hr,'value');
c=li{va};
% file=regexprep({'1]     F:\da'} , '\d{1,10}]\s*','')
v.file=regexprep(c , '\d{1,10}]\s*','');



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
    v.alpha='rampup'
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
end


hco=findobj(hs,'tag','scmap');  % colormap
va=get(hco,'value'); li=get(hco,'string');
v.cmap= (li{va});



disp(v);
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
    trans=cellfun(@(a){ [ sprintf('%.3f',a) ]}, msg );
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
end

function autorot(e,e2)
warning off
hf=findobj(0,'tag','xvol3d');
figure(hf);
% delete(findobj(hf,'type','light
hl=findobj(hf,'type','light');
hw=findobj(0,'tag','winselection');
hl2=[];
if length(hl)>1; hl2=hl(1); ; else; hl2=hl; end

azstep     =str2num(get(findobj('tag','rotazstep'),'string'));
elstep     =str2num(get(findobj('tag','rotelstep'),'string'));
sleeptime  =str2num(get(findobj('tag','rotsleep'),'string'));
dosave     =       (get(findobj('tag','rotsave'),'value'));
if dosave==1
    outname= uiputfile('*.mp4','select Name');
    try
        fprintf('..wait..saving movie');
        v = VideoWriter([outname   ],'MPEG-4');
        open(v);
    catch
        fprintf('..error..cancelled\n');
        dosave=0;
    end
end

% if ~isempty(hl2)
%     % h = camlight('left');
%     camlight(hl2,'left');
% end
for i = 1:str2num(get(findobj('tag','rotdur'),'string'));
    %    figure(findobj(0,'tag','xvol3d'));
    camorbit(azstep,elstep,'data',[   0 0 1]);
    
%     if ~isempty(hl2);   
%         camlight(hl2,'left');
%     end
    if get(findobj(hw,'tag','rblight'),'value')==1
        hl=findobj(findobj(0,'tag','xvol3d'),'type','light');
        delete(hl);
        camlight('headlight');  
    end
    
    
    pause(sleeptime) ;
    if dosave==1
        axis tight
        posx(i,:)=get(gca,'position');
        frame = getframe(gcf);
        %         drawnow;
        if i==1
            siz=size(frame.cdata);
        else
            frame.cdata= imresize(frame.cdata,[siz(1:2)]);
        end
        writeVideo(v,frame);
    end
    
    
    if get(e,'value')==0
        drawnow
        delete(findobj(findobj(0,'tag','winselection'),'type','axes'));
        if dosave==1;     
            close(v) ;  
             fprintf('..finished.\n');
             showinfo2('new movie',outname);
        end
        break
    end
end
set(e,'value',0);
if dosave==1;   
    close(v) ; 
    fprintf('..finished.\n');
    showinfo2('new movie',outname);
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


function loadatlas(file)
prepareWindow;
if exist('file')==0; file=[]; end
hs=findobj(0,'tag','xvol3d'); u=get(hs,'userdata');
if isfield(u,'atlas')==0  || ~isempty(file)
    fprintf('..loading atlas');
    
    if exist(file)==0
        [fi pa]=uigetfile(fullfile(pwd,'*.nii'),'select "ANO.nii"');
        if isnumeric(pa); return; end
        file=fullfile(pa,fi);
        
    end
    u.atlas=fullfile(file);
    [ha a]=rgetnii(u.atlas);
    u.atl =a;
    u.hatl=ha;
    
    u.lut =strrep(file,'.nii','.xlsx');
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
    ids= input('select IDs : ', 's');
    ids=str2num(ids)'
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
u.selectedRegion=zeros(size(u.lu,1),1);
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
if exist('file')==0; file=[]; end
hs=findobj(0,'tag','xvol3d'); u=get(hs,'userdata');
if isfield(u,'atlas')==1  %|| ~isempty(file)
    fprintf('..loading selected regions');
    
    if exist(file)==0
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

function loadbrainmask(file)
prepareWindow
if exist('file')==0; file=[]; end
hs=findobj(0,'tag','xvol3d'); u=get(hs,'userdata');
if isfield(u,'mask')==0  || ~isempty(file)
    fprintf('..loading brain mask');
    
    if exist(file)==0
        [fi pa]=uigetfile(fullfile(pwd,'*.nii'),'select "AVGTmask.nii"');
        if isnumeric(pa); return; end
        file=fullfile(pa,fi);
    end
    u.mask=fullfile(file);
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
camlight;
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
set(hb,'string','explode','tooltipstring',' show region in explode view');
set(hb,'callback',@explodeview);
hb=uicontrol('style','pushbutton','value',0,'units','norm','tag','exploderenew');
set(hb,'position',[0.075 0.005 .05 .035],'backgroundcolor','w','fontsize',5);
set(hb,'string','renew','tooltipstring',' renew explode view in another perspective');
set(hb,'callback',@exploderenew);
hb=uicontrol('style','togglebutton','value',1,'units','norm','tag','showbrain');
set(hb,'position',[0.075+.05 0.005 .05 .035],'backgroundcolor','w','fontsize',5);
set(hb,'string','brain','tooltipstring',' show/hide brain');
set(hb,'callback',@showbrain);

hb=uicontrol('style','togglebutton','value',0,'units','norm','tag','showlabel');
set(hb,'position',[0.075+2*.05 0.005 .05 .035],'backgroundcolor','w','fontsize',5);
set(hb,'string','label','tooltipstring',' show/hide labels');
set(hb,'callback',@showlabel);



    % ==============================================
    %%   show labels
    % ===============================================
    
function showlabel(e,e2)
hf=findobj(0,'tag','xvol3d');
hr=findobj(hf,'tag','showlabel');
ha=findobj(hf,'tag','ax0');

delete(findobj(ha,'tag','txline'));
delete(findobj(ha,'tag','txlabel2')),
    
if get(hr,'value')==1
    % ==============================================
    %   get brain-patch
    % ===============================================
    hb=findobj(ha,'tag','brain');
    ce=mean([mean(get(hb,'xdata'),2)    mean(get(hb,'ydata'),2)    mean(get(hb,'zdata'),2)],1);
    mn=mean([ min(get(hb,'xdata'),[],2)  min(get(hb,'ydata'),[],2)  min(get(hb,'zdata'),[],2)],1);
    mx=mean([ max(get(hb,'xdata'),[],2)  max(get(hb,'ydata'),[],2)  max(get(hb,'zdata'),[],2)],1);
    sizp=mx-mn;
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
        x=get(hi,'xdata');
        y=get(hi,'ydata');
        z=get(hi,'zdata');
        co=[mean(x(:))  mean(y(:))  mean(z(:)) ];
        
        df=(co-ce);
        %ds=(mean(abs(df)./((mx-mn)./2)*1));
        spacefac=1;
        
        txfac=spacefac+.1;
        tp =co+df*spacefac;
        tx=co+df*txfac;
        
        hl=plot3([tp(1) co(1) ],[tp(2)  co(2) ],[tp(3)  co(3)],'k-');
        set(hl,'tag','txline');
        
        label=getappdata(hi,'label');
        te=text(tx(1),tx(2),tx(3),label);
        set(te,'fontsize',4,'interpreter','none');
        set(te,'HorizontalAlignment','center','tag','txlabel2');
        
%         perc=mean(co./ce*100);
%         disp(label);
%         disp(1./(mean(abs(df)./((mx-mn)./2)*1)));
    end
    set(findobj(ha,'tag','txline'),'linewidth',.1);
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
    modi(i,1)=ub.mode;
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
