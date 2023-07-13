% #ok xdraw (xdraw.m)
% draw mask manually
% The mask can contain several ROIs with different numeric values (IDs).
% Input: a background file and optional a mask file (or unfinished mask).
% #r: please avoid to load a mask with more than 150 different IDs
% #b for more information see coltrol's tooltips
% ________________________________________________________________________________
% #lk *** [1] HOW TO DRAW A ROI ***
% #ka *** Draw ROI ***
% --> deselect [unpaint]-button (gray color)
% * Keep the left mouse-button pressed to draw .. colorize pixels below pointer.
% * Double-click to fill a region (boundaries of region must be closed)
% #ka *** REMOVE ROI ***
% --> select [unpaint]-button (orange color)
% * Keep the left mouse-button pressed to unpaint .. remove colorized pixels below pointer.
% * Single click right mouse button to remove region below pointer
% * [c] shortcut to clear slice or use clear-pulldown menu
% ________________________________________________________________________________
% #lk *** [2] UI CONTROLS ***
%
% #kl *** CONTROL ROW-1 ***
% #x [control] [shortcut]  explanation
% #x -----------------------------------------
% #b [otsu][o]        #n  2D-otsu segmentation using the current slice. This will open another figure
%                     #r see below for more details
% #b [otsu3D]         #n  3D-otsu segmentation. This will open another figure.
%                     #r see below for more details
% #b [contour][-]     #n  Draw contours. You can use the contours for segmentation
%                     #r see below for more details
%                     -only available if [vis] checkbox in in contour-panel(bottom) is disabled
% #b [contourlines]   #n  number of contour lines to draw.
% #b [Thresh tool]    #n use Thresh-tool to segment regions (2D)
%                     #r see below for more details
%                     -works best in combination with drawng tools ("rectangle") to preselect an area
%                     -This area can be recalled and used for other slices (for the samme dim) via shortcut [#]
%                     #m not really tested with with multiple IDs
% ________________________________________________________________________________
% #b [ax normal]     #n  axis layout. [0] normal [1] image, 
%                    - use [1] to obtain realistic wide height ratio of the slice
% ________________________________________________________________________________
% #b [show legend][l] #n show/hide legend with drawn IDs
%                       -shows for each drawn ID the respective color, number of voxels and volume
% #b [i] [i]          #n  show information:
%                                   File-information,
%                                   drawn IDs (+color, number of voxels and volume)
%                                   slice-wise information
% #b [m] [m]          #n show montage of slices.
%                     -show semi-transparent overlay of bg-image and (multi-ID) mask for all slices
%                     -click top slice-label to work with this slice (This slice appears in the  main window)
% ________________________________________________________________________________
% #kl *** CONTROL ROW-2 ***
% #b [brush type] [b]              #n change brush type, {dot,square, vertical/horizontal line}
% #b [brush size] [up/down arrow]  #n change brush size
% #b [dim] [d]                     #n change viewing dimension {1,2,3}
% #b [left arrow] [left arrow]     #n show previous slice
% #b [slice number]                #n edit and show this slice number
% #b [right arrow][right arrow]    #n show next slice
%
% #b [transpose]  #n transpose (rotate 90�) current slice
% #b [flipud]     #n flip upside-down current slice
%
% #b [transparency]  #n set transparency  of the mask range 0-1
% ________________________________________________________________________________
% #kl *** Right-side CONTROLS ***
% #b [hand-icon]  #n drag panel to another position
% #b [config]  #n change configuration
%                   -change some of the parameters
%                   * auto-focus windo below mouse (might be of help for otsu-operations)
%                   * show/hide toolbar
% #b [help]    #n open help window
%
% #b [contrast][s]    #n adjust contrast; If enabled, use default contrast enhancement
%                     'auto' from the right pulldown-menu
%                     -change contrast values in right pull-down menu ('auto')
% #b [auto]          #n puldown with min/max values for low and high cotrast enhancing values
%                    -changes apply only if [contrast] is enabled
%                    -you can also edit two values (min max value in range between 0 and 1)
% #b [clear]         #n remove all ROIs from current slice/all slices
%                    #r shortcut [c] remove all ROIs from current slice
%                    #r shortcut [ctrl+c] remove all ROIs from all slices
% #b [XYZ]          #n show xyz-coordinates and value below mouse pointer
% #b [fillNB]       #n filling-option, use next neighbouring ID (via double click)
%                       [0] fills ROI with currently defined ID ( defined in edit field [ID])
%                       [1] fills ROI with ID  thas is closest to the mouse pointer
% #b [newID]        #n change ID of a ROI
%                    - click this button, than click onto a ROI and type the new ID in the messagebox 
% #b [fill_loc]    #n filling-option, fill local/all holes
%                       [0] fill all holes of the ROI 
%                       [1] fill only local ROI, in case there are several holes
% #b [clifi]        #n close a region/combine disconnected lines/points and fill them
%                    - THIS DEALS WITH DISCONNECTED SHAPES
%                    - click this button,than move mouse pointer to the location to close and fill area
%                    - THE filling ID is determined by nearest neighbouring ID  
%                    - currently works by iteration and stops when first local fill elements was found
%% #r  ________________________________________________________________________________
% #r [special drawing tools]
% #b [freehand]  [1] #n freehand drawing
% #b [rectangle] [2] #n draw rectangle
% #b [ellipse]   [3] #n draw ellipse/circle
% #b [polygon]   [4] #n draw polygon
% #b [line]      [5] #n draw line
% #g After selecting a drawing tool (for instance 'freehand') you can draw on the image as long
% #g as the left mouse button is pressed. After button release the user decides (via icons)
% #g what to do with the drawn region: fill region, use regions border only, remove IDs below
% #g region or dismiss region.
% #g Note that the filling and region border options put the current ID in the respective voxels
% #g The drawing icon is deselected afterwards!
% #g Use shortcut to re-evoke action.
% #r  ________________________________________________________________________________
% #r [ID] region value #n Region value. This numeric region value is used for drawing.
%              -edit another numeric value (2,3,4..etc). This value will be used in the
%               next drawing operation
%              -default drawing ID: 1
% #g To recap, first define the ID (numeric value), than draw something.
% #r [ID list]   #n list of all IDs (numeric values) found in the 3D-mask
%                -select one of the IDs in the list to use selected ID as current ID
%
%% #r  ________________________________________________________________________________
%
% #b [ROI OPERATION][r]   #n This tool allows to move, rotate and replicate ROIS
%        - you can replicate a ROI in the same slice or copy it to other/all slices
%        - First click this button, than click onto ROI:
%            A patch object is overlayed over the ROI. Here you can use:
%             [x] to close the patch/ROI Operation 
%             [hand icon]  to drag the patch
%             [slider]  -to rotate the patch
%                       -the contextmenu allso allows to:
%                            * rotate patch by fixed angle (45    90   135   180   -45   -90  -135  -180 degrees)
%                            * rotate to origin
%                            * flip patch horizontally
%                            * flip patch vertically
% The patch-context menu allows to:
%        -COPY ROI:   ..i.e. the patch on the same slice
%            - The translated/rotated/flipped patch will be copied!!!
%            - you can specify the ID
%        -REPLACE ROI ...first ranslate/rotate/flip patch to see a result
%        -DELETE ROI mother  deletes the original ROI (not the patch)
%        -COPY ROI TO OTHER SLICES: allows to copy the patch object to all/defined slices
%           #r Currently, the history works only on the current slice. Whenn copying a ROI to
%           #r other slices the history does not update the changes on the other slices
%
% #b [measure distance][ctrl+m] #n measure distance tool: mm, pixels and angle between
%                        two points (squares). Move the two squares to the respective position.
%                      click [x] button or, [q]-shortcut or [measure distance] btn to quit
% ________________________________________________________________________________
% #wb __UNDO & __REDO
% [undo] [<]      undo last step(s)
%                       -go back to a previous step as long as the slice-number/dimension is not changed.
% [redo] [>]      redo last step(s)
%                       -..as long as the slice-number/dimension is not changed.
%    -  "hist x/y"  #n shows current step x of y-history steps
% ________________________________________________________________________________
% #b [unpaint][u]     #n  remove drawn location, toggle between drawing and unpainting mode
%                       -If 'on': the 'unpainting' mode erases all IDs in voxels below the moved
%                        brush-pointer when left mouse button is down.
%                       -If 'off': the 'drawing' mode is enabled and voxels below the moved
%                        brush-pointer obtain the current ID when left mouse button is down
% #b [hide mask] [h] #n show/hide mask
%                    - when the mask is hidden, the button changes the color
% ________________________________________________________________________________
% #b [WinFocu][a]  #n If 'on' the window below mouse pointer (hover effect) becomes focused/active.
%               -This option is usefull for otsu-segmentation (two windows are open). By default ('off'),
%                one has to select the other non-active window to use it's functions. Using the auto-
%                focus, we can avoid the extra selection step.
% #g Example: transmit a region from otsu-segmentation window to main window (left click)
% #g and fill it in the main window just by hoving the mouse over the main window and left
% #g double-click to fill the region.
%
%
% #b [saving options] #n select the type of image to saved (mask, masked image)
%                   * mask only
%               #r  * use  "Advanced saving options (mskman.m)" to combine the mask with other images
%                       -theshold mask, combine mask with another mask or other images 
%                       -apply mask with background image
%                   
%                   * (older): different types of masking the background image. See pull-down menu.
% #b [save]  #n save the image ...saving mode depends on [saving options] pulldown menu
%
% #lk ***  [3.1] SLICEWISE (2D) OTSU Segmentation ***
% Clicking the otsu button opens a new window with otsu segmentation of the current slice
% Here, you can change the median-filter length (default: 3) to 'smooth' the intensities and
% change then number of otsu classes. Both paramter have imidiate effect on the otsu image.
% #b [classes]  #n number of otsu-classes/clusters, {2...n}
%        #b [arrow up/down] shortcuts to decrease/increase the number of otsu-classes
% #b [medfilt]  #n filter length of the 2d median filter, {1...n}
%        #b [ctrl+arrow up/down] shortcuts to decrease/increase filter length (smoothness)
% #b [cut cluser][x]  if enabled, Draw a line through cluster to separate cluster
%                     -[cut cluser] can be used to parcelate a cluster. A cutted part of a cluster
%                      can than transmitted to the main window
%                     use shortcut [x] to toggle enable/disable [cut cluser] function
% #r LEFT MOUSE-BUTON #g  click onto a region to transmit this region to the main window.
% #g                      The transmitted region obtains the ID (value) of the currently selected
% #g                      ID.
% #x The otsu-window preserves some of the keyboard shortcuts from the main window.
% #x Thus, it's possible to keep the otsu-winow focused and 'scroll' through the slices
% #x (left/right arrow keys), transmit a selected otsu region (left mouse button),
% #x change the otsu-classes (up/down arrows) and median filter (ctrl+up/down arrows),
% #x undo/redo steps (ctrl+x/y) or clear the slice (c).
% #x Try the window auto-focus mode (enabled via configuration settings)
%
% #lk *** [3.2] 3D-OTSU Segmentation ***
% Available via button [Otsu3D]. This option can be used to transmit ostu-segments (regions) for
% the entire volume (compared to [Otsu2D] which works on a slice-by-slice basis).
% Provide a sufficient contrast ([contrast]) before clicking this button.
% The auto-contrast option seems to be ok.
% In the OTSU-3D figure you can change the number of classes for otsu-segmentation and whether to
% median filter [0,1] the data and with with pixel-length
% - For better visualization use the #b [crop slices] #n button, which removes unneccessary bordering
%   (background) colomns/rows.
% - Decide whether to see a fused image  #b [fuse bg/fg]-radio #n or the background and otsu clusters
%   separately via #b [BG or FG] radio.
% - #b [contour] #n adds a contour-plot
% - #b [transparency] change transparency of the overlay
% #g Cick onto a cluster to select this cluster. For instance a cluster denoting a lesion.
% #g Now, a new figure opens showing all spacially segregated sub-clusters of the selected otsu-cluster.
% #g If you select the respective subcluster, this subcluster will be transmitted as roi in the main
% #g The transmitted region obtains the ID (value) of the currently selected ID.
% #g window.
% #g you can now close the subcluster-window or select another subcluster.
% =======================================================================================
% #r: History undo/redo steps currently not supported for [Otsu3D]
% =======================================================================================
%
% #lk *** [3.3] SINGLE-CONTOUR Segmentation ***  ()
% --> see lower panel
% This is a 2D (slice-wise)-method using a single contourline.
% [hand icon]  - shift the contour panel to another position
% [vis]       - show/hide contourline
%                * context menu allows to change the color of the contour line
% [slider]    -change contourline by changing the intensity threshold
%        #b shortcut:  [shift+left/right arrow keys]
% #b [shift+left mouse click] #n will fill the area within the contour line
% [F] apply median filter; default 'true', using the filter length defined in the right edit field 
%

% #lk *** [3.4] MULTI-CONTOUR Segmentation ***  (this is the panel below image)
% This is a 2D (slice-wise)-method using multiple contourlines.
% Activate #b [contour] #n radio and a proper number of contour lines
% #g 1.) Move the pointer (brush) to a location that is surounded  by a contour line
% #g 2.) [shift]+left mouse-click to transmit this region
% #g The transmitted region obtains the ID (value) of the currently selected ID.

%
% #lk *** [3.5] Threshold Tool for Segmentation ***
% -Here an interactive intensity threshold can be used to segment a region
% -The default uses the enire image (slice). Alternatively you can select for instance the
%  #b [rectangle] icon #n from the drawing tool to select a subregion of interest.
%  -Press #b [t]-icon to mark this region as subregion to investigate via thresh-tool
% #r This selected area can be recalled and used for other slices (for the samme dimension)
% #g -use #r [rectangle] #g and the  #r icon [t] #g to change the selected region
% #g use [TreshT.] or shortcut #r [t]  #g to open the threshTool.
% #g In the threshtool move green slider to adjust the intensity cut-off.
% #g If the thesholded mask is ok, click onto the respective region in panel-2 to bring
% #g this region to the output-panel (right). In this way several regions can be
% #g brought in the output-panel
% #g select [OK] to transmit this mask to the main window
% #g The transmitted region obtains the ID (value) of the currently selected ID.
% #g window.

% ====================================================================================
% #lk COMMANDLINE
% xdraw(fullfile(pwd,'AVGT.nii'),[]);  % #g load bg-image, load no mask
% xdraw(fullfile(pwd,'AVGT.nii'),fullfile(pwd,'AVGThemi.nii'));  % #g load bg-image, load existing mask
% xdraw(fullfile(pwd,'t2.nii'),fullfile(pwd,'masklesion.nii'));
%
% xdraw   % start gui, user is asked for BG-image and optional a mask-file (the mask can be modified)
% xdraw('t2.nii')   ; % open BGimage "t2.nii" from local path
% xdraw('t2.nii','mask.nii') ; % open "t2.nii" and mask "mask.nii" from local path
% xdraw('t2.nii','mask.nii',struct('tr',1,'fl',1,'con',1)); % ..also transpose/flipUD image and enhance contrast
% 
% xdraw('?',[],struct('tr',1)) ;% user has to provide the BG-image, image will be transposed
% xdraw('?','?',struct('tr',1))% user has to provide the BG and mask-image
% 

function xdraw(file,maskfile,varargin)
warning off;
disp('..please wait..');
try; delete(findobj(0,'tag','otsu'));end
clear global SLICE
% ==============================================
%%   file
% ===============================================
if exist('file')~=1 || isempty(file) || strcmp(file,'?')==1
    msg='select background file (NIFTI) ...mandatory';
    disp(msg);
    [fi pa]=uigetfile(fullfile(pwd,'*.nii'),msg);
    if isnumeric(fi);
        return;
    end
    file=fullfile(pa,fi);
end
u.f1=file;
[ha a amm]=rgetnii(u.f1);

% ==============================================
%%   maskfile
% ===============================================
if exist('maskfile')~=1 || strcmp(maskfile,'?')==1
    msg='select mask file (NIFTI) or hit "cancel" ...optional';
    disp(msg);
    disp('The mask file be in register with the background image (similar w.r.t voxel-size,dims,orientation)');
    [fi pa]=uigetfile(fullfile(pwd,'*.nii'),msg);
    if isnumeric(fi)
        maskfile=[];
    else
        maskfile=fullfile(pa,fi);
    end
end
maskmode=1;
if isempty(maskfile)
    u.f2=[];
    hb=ha;
    b=zeros(size(a));
    
else
    
    u.f2=maskfile;
    [hb b]=rgetnii(u.f2);
    nvalues=length(unique(b));
    
    if nvalues>100
        % ==============================================
        %%   input-dlg
        % ===============================================
        filestr=regexprep(u.f2,{['\' filesep] ,'_'},{['\' filesep filesep] '\\_' });
        prompt = {
            ['\color{blue} FILE: \color{black} \bf ' '"' filestr '"'  '\rm' char(10) ...
            'The selected mask contain \color{magenta}' num2str(nvalues) '\color{black} different values.' char(10) ...
            'This seems to be a lot for a mask. ' char 10 ...
            char(10) ...
            '\bf HOW TO PROCEED?'  '\rm' char(10)  ...
            '  [1] Proceed and try it ' char(10) ...
            '  [2] Reduce  number of values in mask volume ' char(10) ...
            '  [3] Proceed without using the selected mask'  char(10) ...
            ],'\bf For [2] only: Enter number of values to use for the mask (Otsu-approach).'};
        dlg_title = ['MASKfile: issue' repmat(' ',[1 150])];
        num_lines = 1;
        defaultans = {'1','32'};
        answer = inputdlg2(prompt,dlg_title,num_lines,defaultans,struct('Interpreter','tex'));
        
        %% procees
        if isempty(answer); return; end
        maskmode=str2num(answer{1});
        if maskmode==2
            nclassesOtsu=str2num(answer{2});
            b= reshape(otsu(b(:),nclassesOtsu), hb.dim);
        elseif maskmode==3
            u.f2=[];
            hb=ha;
            b=zeros(size(a));
        end
        
        
        % ==============================================
        %%   end
        % ===============================================
        % ok, try it
        
        % otsu-reduce intensity values
        
        % no, abort mask
        
        
    end
    
    if maskmode==1
        [h,d ]=rreslice2target(u.f2, u.f1, [], 0);
        hb=h;
        b =d;
        
        uni=unique(b);
        if median(double(round(uni*10)/10==uni ))==0
            b=double(b>0);
        end
    end
    
end

% ==============================================
%%  parameter-1
% ===============================================
pp.autofocus                =   0  ;
pp.toolbar                  =   0  ;
pp.otsu_numClasses          =   3  ;
pp.otsu_medianFltLength     =   3  ;
pp.numColors                =   30 ;
pp.bgcolor                  =   repmat(.3,[1 3]) ;

u.config={
    'autofocus'         pp.autofocus           'autofocus figure under mouse{0,1}...no/yes' 'b'
    'toolbar'           pp.toolbar             'show toolbar {0,1}...no/yes' 'b'
    'inf1'             [' OTSU ' repmat('=',[1 20])  ]               '' ''
    'otsu_numClasses'        pp.otsu_numClasses          'number of otsu classes'   ''
    'otsu_medianFltLength'   pp.otsu_medianFltLength     'length of otsu median-filter'   ''
    'inf2'  '' '' ''
    'inf3'             [' Mich. ' repmat('=',[1 20])  ]               '' ''
    'numColors'          pp.numColors          'number of used ID colors '   ''
    'bgcolor'          pp.bgcolor          'set figure background color '  'col'
    };
u.set=pp;
%===================================================================================================

%% FIGURE...params-2
%===================================================================================================

delete(findobj(0,'tag','xpainter'));
fg;
% hf1=gcf;
set(gcf,'units','norm','menubar','none','name','xdraw','NumberTitle','off','tag','xpainter');
makegui;
set(gcf,'color', pp.bgcolor);
% set(findobj(gcf,'tag','waitnow'),'visible','on','string','..wait..');  

[pax namex ext]=fileparts(u.f1);
if isempty(pax); pax=pwd; end
[~,updir]=(fileparts(pax));
set(gcf,'name',[ 'xdraw: [' updir ']: "' [namex ext] '"' ]);

u.dummy=1;
set(gcf,'userdata',u);

% return
% return
u.him=[];
u.usedim =3;
% u.pensi  =10;
u.alpha  =.4;
u.dotsize=3;
u.dotsizes=([1:200]);
u.a=a; u.ha=ha;

u.ax=reshape(single(amm(1,:)'),[size(a)]);
u.ay=reshape(single(amm(2,:)'),[size(a)]);
u.az=reshape(single(amm(3,:)'),[size(a)]);

u.b=b; u.hb=hb;
u.dim=u.ha.dim;
u.lastslices=round(size(u.a)/2);
u.useslice=u.lastslices(u.usedim) ;%round(u.dim(u.usedim)/2);
u.contour=0;
u.contourlines=10;
% thresh via controus ------
% u.threshcolor=[0     1     0];
u.threshcolor=[0 0.4471 0.7412];
u.contourThresh=0.22;
u.threshLineWidth=1;
u.ini_transpose=1;
u.ini_flipud   =0;
u.ini_contrast =1;

u.isboundarySet=0;
u.boundary=[];
u.boundarycolor=[1 0 1];

set(findobj(gcf,'tag','rd_transpose'),'value',u.ini_transpose);
set(findobj(gcf,'tag','rd_flipud')   ,'value',u.ini_flipud);
set(findobj(gcf,'tag','cb_adjustIntensity')   ,'value',u.ini_contrast);

% ==============================================
%%   aux inputs
% ===============================================
isddparam=0;
if ~isempty(varargin)
    if isstruct(varargin{1})
        p=varargin{1};
        isddparam=1;
    elseif ~isempty(varargin) &&  mod(length(varargin),2)==0
        p=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
        isddparam=1;
    end
    
    if isddparam==1;
        if isfield(p,'tr')
            set(findobj(gcf,'tag','rd_transpose'),'value',p.tr);
        end
        if isfield(p,'fl')
            set(findobj(gcf,'tag','rd_flipud'),'value',p.fl);
        end
        if isfield(p,'con')
            set(findobj(gcf,'tag','cb_adjustIntensity'),'value',p.con);
        end
        %         if isfield(p,'dim')
        %             hx=findobj(gcf,'tag','rd_changedim');
        %             set(hx,'value',p.dim);
        %             hgfeval(hx,get(hx,'Callback'));
        %         end
    end
end


% global lastmovecords
% lastmovecords=[];

global lastclicktime;
lastclicktime.obj=tic;
lastclicktime.time=toc(lastclicktime.obj);
% lastclicktime

set(gcf,'userdata',u);

def_colors();
set(findobj(gcf,'tag','dotsize'),'string',num2cell(u.dotsizes),'value',u.dotsize);
setslice();
set(gcf,'WindowButtonMotionFcn', {@motion,1})
set(gcf,'WindowButtonDownFcn', {@buttondown,[]});
set(gcf,'WindowButtonUpFcn'     ,@selstop);
set(gcf,'WindowKeyPressFcn',@keys);
set(gcf,'SizeChangedFcn', @resizefig);
set_idlist;
edvalue([],[]);



hs=findobj(gcf,'tag','slid_thresh');
set(hs,'value',u.contourThresh);
slid_thresh();


set(findobj(gcf,'tag','waitnow'),'visible','off');  



if isddparam==1;
    if isfield(p,'dim')
        hx=findobj(gcf,'tag','rd_changedim');
        set(hx,'value',p.dim);
        hgfeval(get(hx,'Callback'));
    end
end

% ==============================================
%%   timer
% ===============================================
timercheck();
% ==============================================
%%   END
% ===============================================

% %===================================================================================================
% function resizefig(e,e2)
% return
% %
% % hf1=findobj(0,'tag','xpainter');
% % u=get(hf1,'userdata');
% % if isfield(u,'controls')==0
% %     u.controls=findobj(gcf,'Type','uicontrol');
% %     set(u.controls,'units','pixels');
% %     u.controls_pospix=get(u.controls,'position');
% %     set(u.controls,'units','norm');
% %     u.controls_posnorm=get(u.controls,'position');
% %     set(hf1,'userdata',u);
% % end
% %
% % set(u.controls,'units','pixels');
% % for i=1:length(u.controls)
% %     pos=get(u.controls(i),'position');
% %     pos(3:4)=u.controls_pospix{i}(3:4);
% %     set(u.controls(i),'position',pos);
% % end
% % set(u.controls,'units','norm');

function rd_contourdraw(e,e2)
hf1=findobj(0,'tag','xpainter');
hb=findobj(hf1,'tag','rd_contourdraw');
set(findobj(gcf,'tag','thresh_visible'),'value',0);
u=get(hf1,'userdata');
u.contour=get(hb,'value');
set(hf1,'userdata',u);
setslice([],1);

function rd_contournumlines(e,e2)
hf1=findobj(0,'tag','xpainter');
hed=findobj(hf1,'tag','rd_contournumlines');
hb=findobj(hf1,'tag','rd_contourdraw');
u=get(hf1,'userdata');

numlines=str2num(get(hed,'string'));
if numlines>0
    u.contourlines=numlines;
end
set(hf1,'userdata',u);

if get(hb,'value')==1
    setslice([],1);
end


function def_colors()
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
colmat = distinguishable_colors(u.set.numColors,[1 1 1; 0 0 0]);

% 1st color is red
ired=find(colmat(:,1)==1 & colmat(:,2)==0 & colmat(:,3)==0 );
colmat=[ colmat(ired,:); colmat( setdiff(1:size(colmat,1),ired) ,:) ];

% colmat=[colmat([2 1 13:end],:)];
% figure; image(reshape(c,[1 size(colmat)]));
u.colmat=colmat;
set(hf1,'userdata',u);

function timercheck()
hf1=findobj(0,'tag','xpainter');
us=get(gcf,'userdata');
if us.set.autofocus==1
    set(findobj(hf1,'tag','rd_autofocus'),'value',1, 'backgroundcolor',[1 0.8431 0]);
    timerstart;
else
    delete(timerfindall);
    set(findobj(hf1,'tag','rd_autofocus'),'value',0, 'backgroundcolor','w');
end

% ==============================================
%%   timer for focus
% ===============================================
function timerstart
delete(timerfindall);
t = timer('ExecutionMode', 'FixedRate', ...
    'Period', .5, ...
    'TimerFcn', {@timerCallback});
start(t)
set(gcf, 'CloseRequestFcn', 'disp(''closing figure...''); delete(timerfindall);closereq');

function timerCallback(e,e2)
fig = matlab.ui.internal.getPointerWindow();
%     disp(fig);
if fig==0; return; end
figure(fig);


function cb_configuration(e,e2)
delete(timerfindall);
configuration();
drawnow;
timercheck();


function configuration
u=get(gcf,'userdata');
x=u.set;
p=u.config;
p=paramadd(p,x);%add/replace parameter
% hlp=help(); hlp=strsplit2(hlp,char(10))';
[m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[0.1500    0.4011    0.3625    0.2000 ],...
    'title','***xdraw config***','info',{'--'});
if isempty(m); return; end
fn=fieldnames(z);
z=rmfield(z,fn(regexpi2(fn,'^inf\d')));

u.set=z;
set(gcf,'userdata',u);
hf1=findobj(0,'tag','xpainter');
if z.toolbar==1;                  %menubar
    set(hf1,'toolbar','figure');
else
    set(hf1,'toolbar','none');
end

if  u.set.numColors~=x.numColors   %COLORS
    def_colors();
    setslice();
    set_idlist;
    edvalue([],[]);
end

try
set(hf1,'color', u.set.bgcolor);
end

% ==============================================
%% callback autofocus
% ===============================================
function rd_autofocus(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
u.set.autofocus=get(findobj(hf1,'tag','rd_autofocus'),'value');
set(gcf,'userdata',u);

timercheck();


% ==============================================
%% otsu key
% ===============================================
function keys_otsu(e,e2)
hf2=findobj(0,'tag','otsu');
hf1=findobj(0,'tag','xpainter');

if isempty(e2.Modifier)==1
    if strcmp(e2.Key,'uparrow') || strcmp(e2.Key,'downarrow')
        hb=findobj(hf2,'tag','ed_otsu');
        nclasses=str2num(get(hb,'string'));
        if strcmp(e2.Key,'uparrow');
            nclasses=nclasses-1;
            if nclasses<2;              nclasses=2  ;      end
        else
            nclasses=nclasses+1;
        end
        set(hb,'string',num2str(nclasses));
        hgfeval(get(hb,'callback'),[],1);
    elseif strcmp(e2.Key,'leftarrow') || strcmp(e2.Key,'rightarrow')
        if strcmp(e2.Key,'leftarrow');
            hb=findobj(hf1,'tag','prev');
            figure(hf1);
            hgfeval(get(hb,'callback'),[],-1);
            figure(hf2);
        else
            hb=findobj(hf1,'tag','next');
            figure(hf1);
            hgfeval(get(hb,'callback'),[],+1);
            figure(hf2);
        end
    elseif strcmp(e2.Key,'s');        %saturate contrast
        hf1=findobj(0,'tag','xpainter');
        hb=findobj(hf1,'tag','cb_adjustIntensity');
        set(hb,'value', ~get(hb,'value') );
        cb_adjustIntensity([],[]);
        %hgfeval(get( hb ,'callback'),[], 1);
    elseif strcmp(e2.Key,'h')
        figure(hf1);
        hb=findobj(hf1,'tag','preview');
        set(hb,'value',~get(hb,'value'));
        cb_preview();
        figure(hf2);
%     elseif strcmp(e2.Key,'space')
%         figure(hf1);
%         hide_mask();
%         figure(hf2);
    elseif strcmp(e2.Key,'c')    %clear slice
        figure(hf1);
        hf1=findobj(0,'tag','xpainter');
        hb=findobj(hf1,'tag','clear mask');
        set(hb,'value',1);
        hgfeval(get(hb,'callback'),[],[])
        figure(hf2);
    elseif strcmp(e2.Key,'u'); % unpaint
        figure(hf1);
        o=findobj(gcf,'tag','undo');
        if get(o,'value')==0; set(o,'value',1); else; set(o,'value',0); end
        undo();
        figure(hf2);
        % elseif strcmp(e2.Key,'t'); % zoom
        %        'a'
    elseif strcmp(e2.Key,'v'); % cut cluster
        hb= findobj(hf2,'tag','pb_otsucut');
        set(hb,'value',~get(hb,'value'));
        hgfeval(get( hb ,'callback'));
    end
else
    figure(hf1);
    if strcmp(e2.Modifier,'control')
        if strcmp(e2.Key,'x')           % # undo
            pb_undoredo([],[],-1);
        elseif strcmp(e2.Key,'y')      % # redo
            pb_undoredo([],[],+1);
        end
        
        if strcmp(e2.Key,'uparrow') || strcmp(e2.Key,'downarrow')
            hb=findobj(hf2,'tag','otsu_medfilt_val');
            medfiltlength=str2num(get(hb,'string'));
            if strcmp(e2.Key,'uparrow');
                medfiltlength=medfiltlength-1;
                if medfiltlength<1;              medfiltlength=1  ;      end
            else
                medfiltlength=medfiltlength+1;
            end
            set(hb,'string',num2str(medfiltlength));
            hgfeval(get(hb,'callback'),[],1);
        end
    end
end

figure(hf2);

function slid_thresh_set(stepsize)
hp3 =findobj(gcf,'tag','panel3'); %panel3
hvis=findobj(hp3,'tag','thresh_visible'); %visible
if get(hvis,'value')==1
    hs=findobj(hp3,'tag','slid_thresh');
    val=get(hs,'value');
    val=get(hs,'value')+stepsize;
    if val<=0; val=0; end
    if val>1; val=1; end
    
    set(hs,'value',val);
    slid_thresh();
end
% ==============================================
%%   
% ===============================================
function boundary_set()
% boundary_set_option1();

boundary_set_option2()


function boundary_set_option2()
global SLICE
SLICE.r2BK=SLICE.r2;
u=get(gcf,'userdata');
set(findobj(gcf,'tag','addBorder'),'BackgroundColor',u.boundarycolor);
u.isboundarySet=1;
set(gcf,'userdata',u);
set(gcf,'WindowButtonMotionFcn',[]);
set(gcf,'WindowButtonUpFcn',[]);
% set(gcf,'WindowButtonUpFcn',@boundary_setMousrRelease);
set(gcf,'Pointer','arrow');
pos=[];
[hg,x,y] = freehanddraw(gca,'color',u.boundarycolor,'linewidth',1);
if ~isempty(x)
    pos(:,1)=x;
    pos(:,2)=y;
    
    % delete(hg);
    set(hg,'tag','border2','hittest','off');
    u.boundarypos=pos;
    u.isboundarySet=0;
    set(findobj(gcf,'tag','addBorder'),'BackgroundColor',[1 1 1]);
    set(gcf,'userdata',u);
    % if ~isempty(pos)
    %     g=plot(pos(:,1),pos(:,2),'-r','tag','border2','linewidth',1,'hittest','off','color',u.boundarycolor);
    % end
    
    % function boundary_setMousrRelease(e,e2)
    % u=get(gcf,'userdata');
    %
    % u.isboundarySet=0;
    % set(gcf,'userdata',u);
end
set(gcf,'WindowButtonMotionFcn', {@motion,1})
set(gcf,'WindowButtonDownFcn', {@buttondown,[]});
set(gcf,'WindowButtonUpFcn'     ,@selstop);


function boundary_set_option1()
global SLICE
SLICE.r2BK=SLICE.r2;
u=get(gcf,'userdata');
set(findobj(gcf,'tag','addBorder'),'BackgroundColor',u.boundarycolor);
u.isboundarySet=1;
set(gcf,'userdata',u);
set(gcf,'WindowButtonMotionFcn',[]);
% set(gcf,'WindowButtonUpFcn',[]);
set(gcf,'WindowButtonUpFcn',@boundary_setMousrRelease);

set(gcf,'Pointer','arrow');
pos=[];
    delete(findobj(gcf,'tag','imfreehand'));
    h = imfreehand(gca,'Closed',0);
    pos=h.getPosition;
    delete(findobj(gcf,'tag','imfreehand'));
% if 0
%     
%     [lineobj,pos(:,1),pos(:,2)] = freehanddraw(gca);
%     delete(lineobj);
% end
u.boundarypos=pos;
u.isboundarySet=0;
set(gcf,'userdata',u);
if ~isempty(pos)
    g=plot(pos(:,1),pos(:,2),'-r','tag','border2','linewidth',1,'hittest','off','color',u.boundarycolor);
end

function boundary_setMousrRelease(e,e2)
u=get(gcf,'userdata');
set(findobj(gcf,'tag','addBorder'),'BackgroundColor',[1 1 1]);
u.isboundarySet=0;
set(gcf,'userdata',u);
set(gcf,'WindowButtonMotionFcn', {@motion,1})
set(gcf,'WindowButtonDownFcn', {@buttondown,[]});
set(gcf,'WindowButtonUpFcn'     ,@selstop);


% ==============================================
%% main fig key
% ===============================================
function keys(e,e2)
try
    if strcmp(get(gco,'style'),'edit')
        return
    end
end
hf1=findobj(0,'tag','xpainter');


% ==============================================
%%   fig-shortcuts: shift
% ===============================================

if strcmp(e2.Modifier,'shift')
    hp3 =findobj(gcf,'tag','panel3'); %panel3
    %disp('shift-not defined');
    if  strcmp(e2.Key,'leftarrow')                        %slider contour -L
        
        hvis=findobj(hp3,'tag','thresh_visible'); %visible
        if get(hvis,'value')==1
            slid_thresh_set(-.01);
        end
    elseif strcmp(e2.Key,'rightarrow')                     %slider contour -R
        
        hvis=findobj(hp3,'tag','thresh_visible'); 
        if get(hvis,'value')==1
            slid_thresh_set(+.01);
        end
    elseif strcmp(e2.Key,'c')                                 % visible contour
        hc=findobj(hp3,'tag','thresh_visible');
        set(hc,'value', ~get(hc,'value'));
       slid_thresh();
    elseif strcmp(e2.Key,'b')       
        borderDel();
   elseif strcmp(e2.Character,'>')
     %'+'
     pb_undoredo([],[],+1);
    elseif strcmp(e2.Key,'space')  % unpaint/paint
        hb=findobj(gcf,'tag','undo');
        if ~isempty(hb)
            hb.Value=~hb.Value;
            hgfeval(get(hb,'callback'),[],[]);
            return
        end
        
        
        
    end
    return
end

if strcmp(e2.Character,'<')
   % '-'
    pb_undoredo([],[],-1);
    return
end

% ==============================================
%%   fig-shortcuts: CTRL
% ===============================================
if strcmp(e2.Modifier,'control')
    if strcmp(e2.Key,'x')
        pb_undoredo([],[],-1);         % #undo
    elseif strcmp(e2.Key,'y')
        pb_undoredo([],[],+1);         % #redo
     elseif strcmp(e2.Key,'c')  %delete all  
         hf1=findobj(0,'tag','xpainter');
         hb=findobj(hf1,'tag','clear mask');
         
          BTN = questdlg('Clear all ROI''s from all slices?', 'CLEAR ROIs', 'Yes', 'No', 'Yes');
          if strcmp(BTN,'No'); return; end
           
         ix_curr=get(hb,'value');
         ix_clearAll=find(~cellfun('isempty',strfind(hb.String,'all slices')));
         set(hb,'value',ix_clearAll);
         drawnow
         %hgfeval(get(hb,'callback'),[],[]);
        cb_clear()
         set(hb,'value',ix_curr);
      elseif strcmp(e2.Key,'m')  % distance measure 
          hb=findobj(gcf,'tag','pb_measureDistance');
          set(hb,'value',~get(hb,'value'));
          pb_measureDistance();
          %     elseif strcmp(e2.Key,'leftarrow')
          %         hp3 =findobj(gcf,'tag','panel3'); %panel3
%         hvis=findobj(hp3,'tag','thresh_visible'); %visible
%         if get(hvis,'value')==1
%             slid_thresh_set(-.01);
%         end
%     elseif strcmp(e2.Key,'rightarrow')
%         hp3 =findobj(gcf,'tag','panel3'); %panel3
%         hvis=findobj(hp3,'tag','thresh_visible'); %visible
%         if get(hvis,'value')==1
%             slid_thresh_set(+.01);
%         end
        
    end
    return
end

%  e2
if strcmp(e2.Key,'escape')
    hb=findobj(gcf,'tag','pb_im_break');
    if ~isempty(hb)
        hgfeval(get(hb,'callback'),[],[]);  % QUIT IMDRAWTOOLS-DECISSION-STATE
        return
    end
    hb=findobj(gcf,'tag','patch_remove');
    if ~isempty(hb)
        hgfeval(get(hb,'callback'),[],[]);  % QUIT ROI operation tool
        return
    end
    hb=findobj(gcf,'tag','pb_deldistfun'); %quit distance tool
    if ~isempty(hb)
        hgfeval(get(hb,'callback'),[],[]);  % QUIT ROI operation tool
        return
    end
 elseif strcmp(e2.Key,'space')  % toggle hide
    hb=findobj(gcf,'tag','preview'); 
    if ~isempty(hb)
        hb.Value=~hb.Value;
        hgfeval(get(hb,'callback'),[],[]);  
        return
    end
     
elseif strcmp(e2.Key,'leftarrow')
    cb_setslice([],[],'-1');
elseif strcmp(e2.Key,'rightarrow')
    cb_setslice([],[],'+1');
elseif strcmp(e2.Key,'uparrow') || strcmp(e2.Key,'downarrow')
    o=findobj(gcf,'tag','dotsize');
    li=get(o,'string');
    va=get(o,'value');
    %oldsize=str2num(li{va});
    if strcmp(e2.Key,'uparrow')
        va=va-1;
    elseif strcmp(e2.Key,'downarrow')
        va=va+1;
    end
    if     va>length(li);     va=length(li);
    elseif va<1;              va=1;
    end
    set(o,'value',va);
    definedot([],[]);
elseif strcmp(e2.Key,'v'); % keep clusterslice table 
    keepclusterinSlice();
elseif strcmp(e2.Key,'f');
    cb_fill();
elseif strcmp(e2.Key,'b');
     boundary_set();
elseif strcmp(e2.Key,'r')
        pb_patch();
elseif strcmp(e2.Key,'s');        %saturate contrast
    hf1=findobj(0,'tag','xpainter');
    hb=findobj(hf1,'tag','cb_adjustIntensity');
    set(hb,'value', ~get(hb,'value') );
    cb_adjustIntensity([],[]);
    %hgfeval(get( hb ,'callback'),[], 1);
    
elseif strcmp(e2.Key,'t'); % zoom
    hf1=findobj(0,'tag','xpainter');
    u=get(hf1,'userdata');
    if u.set.toolbar==1
        u.set.toolbar=0;
        set(gcf,'toolbar','none');
    else
        u.set.toolbar=1;
        set(gcf,'toolbar','figure');
    end
    set(hf1,'userdata',u);
elseif  strcmp(e2.Key,'a');              % AUTOFOCUS
    hf1=findobj(0,'tag','xpainter');
    hb=findobj(hf1,'tag','rd_autofocus');
    set(hb,'value' , ~get(hb,'value') );
    rd_autofocus([],[]);
elseif strcmp(e2.Key,'l');
    o=findobj(gcf,'tag','pb_legend');
    set(o,'value',~get(o,'value'));
    pb_legend([],[]);
elseif strcmp(e2.Key,'i');
    pb_slicewiseInfo([],[]);
    
elseif strcmp(e2.Key,'d')|| strcmp(e2.Key,'6') ;%strcmp(e2.Key,'uparrow') || strcmp(e2.Key,'downarrow')
    %     e=findobj(gcf,'tag','rd_changedim');
    %     li=get(e,'string'); va=get(e,'value');
    %     olddim=str2num(li{va});
    %     %     if strcmp(e2.Key,'uparrow')
    %     newdim=olddim+1;
    %     %     else
    %     %         newdim=olddim-1;
    %     %     end
    %     if newdim>3;     newdim=1;
    %     elseif newdim<1; newdim=3;end
    %     set(e,'value',newdim);
    %     pop_changedim();
    %     % elseif regexpi(e2.Key,['^\d$'])
    %     %    o=findobj(gcf,'tag','edvalue');
    %     %    set(o,'string',e2.Key);
    
    
    hb=findobj(hf1,'tag','imdrawSimple');
    set(hb,'value',1);
    hgfeval(get(hb,'callback'),[],[]);
    
elseif strcmp(e2.Key,'u')
    o=findobj(gcf,'tag','undo');
    if get(o,'value')==0; set(o,'value',1); else; set(o,'value',0); end
    undo();
elseif strcmp(e2.Key,'h')
    hb=findobj(hf1,'tag','preview');
    set(hb,'value',~get(hb,'value'));
    cb_preview();
elseif strcmp(e2.Key,'space')
     hide_mask();
%     return
    
    
elseif strcmp(e2.Key,'p')
    e=findobj(gcf,'tag','rd_dottype');
    li=get(e,'string'); va=get(e,'value');
    va=va+1;
    if va>4; va=1; end
    set(e,'value',va);
    definedot([],[]);
    % elseif strcmp(e2.Key,'c')
    %     hf1=findobj(0,'tag','xpainter');
    %     hf2=findobj(0,'tag','otsu');
    %     if isempty(hf2); return; end
    %     figure(hf2);
    %     pb_otsouse(e,e2)
    %     figure(hf1);
elseif strcmp(e2.Key,'c')    %clear slice
    hf1=findobj(0,'tag','xpainter');
    hb=findobj(hf1,'tag','clear mask');
    set(hb,'value',1);
    hgfeval(get(hb,'callback'),[],[]);
    
    
elseif strcmp(e2.Key,'o')
    hf1=findobj(0,'tag','xpainter');
    hb=findobj(hf1,'tag','pb_otsu');
    set(hb,'value',~get(hb,'value') );
    pb_otsu([],[],1);
    
elseif strcmp(e2.Key,'x')   % # undo
    pb_undoredo([],[],-1);
elseif strcmp(e2.Key,'y')   % # redo
    pb_undoredo([],[],+1);
elseif strcmp(e2.Key,'m')
    show_allslices()
elseif strcmp(e2.Character,'-')
    hb=findobj(hf1,'tag','rd_contourdraw');
    set(hb,'value', ~get(hb,'value'));
    rd_contourdraw([],[]);
elseif strcmp(e2.Character,'#')
    threshtoolprep();
    % elseif strcmp(e2.Character,'+')
    %     hf1=findobj(0,'tag','xpainter');
    %     hf2=findobj(0,'tag','otsu');
    %     he=findobj(hf2,'tag','ed_otsu');
    %     str=num2str(str2num((get(he,'string')))+1);
    %     set(he,'string',str);
    %     hgfeval(get(he,'callback'),he);
    %     figure(hf1);
    % elseif strcmp(e2.Character,'-')
    %      hf1=findobj(0,'tag','xpainter');
    %     hf2=findobj(0,'tag','otsu');
    %     he=findobj(hf2,'tag','ed_otsu');
    %     str=str2num((get(he,'string')))-1;
    %     if str<2; return; end
    %
    %     set(he,'string',num2str(str));
    %     hgfeval(get(he,'callback'),he);
    %     figure(hf1);
    % elseif strcmp(e2.Key,'z'); % zoom
    %     z=zoom;
    %     if strcmp( get(z,'enable'),'on')
    %         %             set(z,'enable','off');
    %         zoom off
    %         'zoom off'
    %     else
    %         set(z,'enable','on');
    %         'zoom on'
    %
    %
    %     end
elseif strcmp(e2.Key,'1') || strcmp(e2.Key,'2') || strcmp(e2.Key,'3')|| strcmp(e2.Key,'4')||  strcmp(e2.Key,'5')
    num=str2num(e2.Key);
    hf1=findobj(0,'tag','xpainter');
    hb=findobj(hf1,'userdata','imtoolsbutton');
    hc=hb(end-num+1);
    type=getappdata(hc,'toolnr');
    set(hc,'value', ~get(hc,'value') );
    imdrawtool_prep(hc,[],type);
    uicontrol(findobj(hf1,'tag','undo'));
end




%�����������������������������������������������
%%
%�����������������������������������������������

function pb_Treshtool(e,e2);
threshtoolprep();

function threshtoolprep()

hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');

a=u.bg2d;
% b=getslice2d(u.b);
% b=ones(size(b));

b=[];
if isfield(u,'tempmask')
    b=u.tempmask;
end

if isempty(b) ||  any(size(b)==size(a)==0)
    b=getslice2d(u.b);
    b=ones(size(b));
    
    % ----------------------------------------------------
    % transpose
    
    if get(findobj(hf1,'tag','rd_transpose'),'value')==1
        %x=permute(r2, [2 1 3]);
        b=b';
    end
    if get(findobj(hf1,'tag','rd_flipud'),'value')==1
        b=flipud(b);
    end
    
end
% ----------------------------------------------------
%   h=imrect();
if 1
    bm=b;
    % bn=bwlabeln(b);
    % bm=bn==bn(co(2),co(1));
    ile=find(sum(bm,1)>0);
    ido=find(sum(bm,2)>0);
    %
    sm=bm(ido,ile);
    sa=a(ido,ile);
    % sa(sm==0)=median(sa(sm==1));
    % fg,imagesc(sa)
    % [m]=threshtool(sa,struct('medfilt',1,'msk',msk));
    [m]=threshtool(sa,struct('medfilt',1,'msk',[]));
    drawnow;
end

if isempty(m); return; end

m2=zeros(size(a));
m2(ido,ile)=m;
bw = m2;

% #################

hf1=findobj(0,'tag','xpainter');
figure(hf1);

u=get(hf1,'userdata');


dims=u.dim(setdiff(1:3,u.usedim));

r1=getslice2d(u.a);
r2=getslice2d(u.b);
r1=adjustIntensity(r1);

if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    r1=r1';
    r2=r2';
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r1=flipud(r1);
    r2=flipud(r2);
end

si=size(r2);
r2=r2(:);
r2(bw==1)  =  str2num(get(findobj(hf1,'tag','edvalue'),'string'))  ;
r2=reshape(r2,si);

%===== update history
r2n=r2;
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r2n=flipud(r2n);
end
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    r2n=r2n';
end

if sum(any(u.hist(:,:,u.histpointer)-r2n))==0; return; end
u.histpointer=u.histpointer+1;
u.hist(:,:,u.histpointer)=r2n;

alp=u.alpha;% .8
% val=unique(u.b); val(val==0)=[];
r2v=r2(:);
r1=mat2gray(r1);
ra=repmat(r1,[1 1 3]);

rb=reshape(zeros(size(ra)), [ size(ra,1)*size(ra,2) 3 ]);
val=unique(r2); val(val==0)=[];
for i=1:length(val)
    ix=find(r2v==val(i));
    rb( ix ,:)  = repmat(u.colmat(val(i),:), [length(ix) 1] );
end
% rb=reshape(rb,size(ra));
s1=reshape(ra,[ size(ra,1)*size(ra,2) 3 ]);
rm=sum(rb,2);
im=find(rm~=0);
% s1(im,:)= (s1(im,:)*alp)+(rb(im,:)*(1-alp)) ;
s1(im,:)= (s1(im,:)*(1-alp))+(rb(im,:)*(alp)) ;
x=reshape(s1,size(ra));

set(u.him,'cdata',   x  );


% u=putsliceinto3d(u,r2,'b');
r2n=r2;
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r2n=flipud(r2n);
end
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    r2n=r2n';
end
u=putsliceinto3d(u,r2n,'b');
set(gcf,'userdata',u);
undo_redolabel_update();


him=findobj(gcf,'tag','image');

hb=findobj(gcf,'tag','pb_nextstep');
hgfeval(get( hb ,'callback'),[], 1);
drawnow;




% if sum(m(:))==0; return; end



return

% [level,bw] = thresh_tool(sa,jet);

%�����������������������������������������������
%%
%�����������������������������������������������
fg;
h1=axes('position',[0 .4 .4 .4])
set(h1,'position',[0 .45 .5 .5],'tag','ax1');; axis off;
h2=axes('position',[0 .4 .4 .4])
set(h2,'position',[.5 .45 .5 .5],'tag','ax2'); axis off;
h3=axes('position',[0 .2 1 .2])
set(h3,'position',[0.05 .24 .9 .2],'tag','ax3'); axis on;

cmap=parula;
tr  =0.5;
s=ind2rgb(round(sa.*size(cmap,1)),cmap);
axes(h1); image(s); title('input')
%colormap(cmap);
axes(h2); imagesc(sa>tr);colormap(gray); title('segmented');

axes(h3); imhist(sa);
%�����������������������������������������������
%%
%�����������������������������������������������
return
%�����������������������������������������������
%%
%�����������������������������������������������
v=round(sa*255);
% m1=cat(3,v,v,v);
m1=ind2rgb(  round((imadjust(sa))*64),parula);
m2=rgb2hsv(m1);
% fg,imagesc(otsu(medfilt2(m2(:,:,1)./m2(:,:,2),[2 2],'symmetric'),3))

% fg,imagesc(otsu(imadjust(mat2gray(medfilt2((m2(:,:,3)+m2(:,:,2))./m2(:,:,1),[2 2]))),3))

so=otsu(imadjust(mat2gray(medfilt2((m2(:,:,3)+m2(:,:,2))./m2(:,:,1),[2 2],'symmetric'))),3);
imoverlay(sa,so);



%�����������������������������������������������
%%
%����������������������������������������������

function v2=getslice2d(v3)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
if u.usedim==1
    v2=squeeze(v3(u.useslice,:,:));
elseif u.usedim==2
    v2=squeeze(v3(:,u.useslice,:));
elseif u.usedim==3
    v2=squeeze(v3(:,:,u.useslice));
end

% r1=imadjust(r1);
% disp('adjustIM');


function cb_preview(e,e2)
hf1=findobj(0,'tag','xpainter');
hcon=findobj(hf1,'tag','rd_contourdraw');
hb=findobj(hf1,'tag','preview');
alpha        =1;
useoldHistory=1;

if get(hb,'value')==1
    % transparent ...no mask
    setslice(alpha,useoldHistory);
    set(findobj(hf1,'tag','preview'),'backgroundcolor',[ 1.0000    0.8431         0]);
    % if get(hcon,'value')==1
%     try;  set(findobj(gca,'type','contour'),'visible','off'); end
    % end
    drawnow;
else
    setslice([],useoldHistory);
    set(findobj(hf1,'tag','preview'),'backgroundcolor',[repmat(.94,[1 3])]);
%     try;  set(findobj(gca,'type','contour'),'visible','on'); end
end

function hide_mask();
u=get(gcf,'userdata');
if isfield(u,'ispreview')==0
    u.ispreview=0;
end
u.ispreview=~u.ispreview;
set(gcf,'userdata',u);
hf1=findobj(0,'tag','xpainter');

alpha        =1;
useoldHistory=1;
if u.ispreview==1
    setslice(alpha,useoldHistory); %hide mask
    set(findobj(hf1,'tag','preview'),'backgroundcolor',[ 1.0000    0.8431         0]);
    try;  set(findobj(gca,'type','contour'),'visible','off'); end
else
    setslice([],useoldHistory); %show mask
    set(findobj(hf1,'tag','preview'),'backgroundcolor',[repmat(.94,[1 3])]);
    try;  set(findobj(gca,'type','contour'),'visible','on'); end
end



function pb_otsu(e,e2,par)

hf1=findobj(0,'tag','xpainter');
figure(hf1);

hb=findobj(hf1,'tag','pb_otsu'); %otsu-button
if get(hb,'value')==0;
    delete(findobj(0,'tag','otsu'));
    return
end



hf2=findobj(0,'tag','otsu');
u=get(hf1,'userdata');




try
    u.set.otsu_numClasses=str2num(get(findobj(hf2,'tag','ed_otsu'),'string'));
    % catch
    %     u.set.otsu_numClasses=3;
end

try
    u.set.otsu_medianFltLength=str2num(get(findobj(hf2,'tag','otsuMedfilt'),'string'));
    % catch
    %     u.otsuMedfilt=3;
end
set(hf1,'userdata',u);


r1=getslice2d(u.a);
r1=adjustIntensity(r1);
r2=getslice2d(u.b);

if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    %x=permute(r2, [2 1 3]);
    r1=r1';
    r2=r2';
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r1=flipud(r1);
    r2=flipud(r2);
end
% ----------------------------------------------------
hf2=findobj(0,'tag','otsu');
if isempty(hf2)
    %     'ri'
    fg;
    set(gcf,'units','norm','menubar','none','name','otsu','NumberTitle','off','tag','otsu');
    pos1=get(hf1,'position');
    pos2=pos1;
    pos2(1)=(pos2(1)-pos2(3)/2)-.016; pos2(3)=pos2(2)/2;
    set(gcf,'position',pos2);
    hf2=gcf;
    %     pointer=nan(16,16); pointer(:,8)=1; pointer(8,:)=1;
    %     drawnow
    %     set(gcf,'Pointer','custom');drawnow
    %     pointer=ones(16,16)*2; pointer(:,8)=1; pointer(8,:)=1;drawnow
    %     set(gcf,'PointerShapeCData',pointer);drawnow
    %     pointer=nan(16,16)*2; pointer(:,8)=1; pointer(8,:)=1;drawnow
    %     set(gcf,'PointerShapeCData',pointer);drawnow
    
    hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_otsouse');
    set(hb,'position',[ .1 .9 .5 .05],'string','select class for all slices', 'callback',{@pb_otsouse,3});
    set(hb,'fontsize',7,'backgroundcolor','w');
    set(hb,'tooltipstring',['select class for all slices' char(10) ' ']);
    
    hb=uicontrol('style','radio','units','norm', 'tag'  ,'pb_otsucut');
    set(hb,'position',[ .7 .9 .2 .05],'string','cut cluster', 'callback',{@pb_otsucut,1});
    set(hb,'fontsize',7,'backgroundcolor','w','value',0);
    set(hb,'tooltipstring',['cut cluster' char(10) 'shortcut [v] ']);
    
    % ========classes=======================================================
    %otsu -number of classes-label
    hb=uicontrol('style','text','units','norm', 'string' ,'classes');
    set(hb,'fontsize',7,'backgroundcolor',[0.8392    0.9098    0.8510],'fontweight','normal');
    set(hb,'position',[0 .95 .15 .04]);
    set(hb,'tooltipstring',['otsu define number of classes/clusters' char(10) '[arrow up/down]']);
    
    
    %otsu -number of classes
    hb=uicontrol('style','edit','units','norm', 'tag'  ,'ed_otsu','value',0);
    set(hb,'position',[ .15 .95 .1 .04],'string',num2str(u.set.otsu_numClasses), 'callback',{@pb_otsu,1});
    set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
    set(hb,'tooltipstring',['otsu define number of classes/clusters' char(10) '[arrow up/down]']);
    
    % =========median-filter======================================================
    
    %medianfilter-radio
    hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu_medfilt_rd','value',1);
    set(hb,'position',[ .3 .95 .18 .04],'string','medfilt', 'callback',{@pb_otsu,1});
    set(hb,'fontsize',7,'backgroundcolor',[0.8392    0.9098    0.8510],'fontweight','normal');
    set(hb,'tooltipstring',['median filter image prior otsu-ing' char(10) '-']);
    
    
    %medianfilter-filtervalue
    hb=uicontrol('style','edit','units','norm', 'tag'  ,'otsu_medfilt_val');
    set(hb,'position',[ .48 .95 .08 .04],'string',num2str(u.set.otsu_medianFltLength), 'callback',{@pb_otsu,1});
    set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
    set(hb,'tooltipstring',['median filter length' char(10) '-']);
    
    % ========= OTSU-3d-panel-pushbutton======================================================
    
    %      hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_otsu3Dmontage');
    %     set(hb,'position',[ .1 .001 .25 .05],'string','show 3D-otsu', 'callback',@pb_otsu3Dmontage);
    %     set(hb,'fontsize',7,'backgroundcolor','w');
    %     set(hb,'tooltipstring',['3D-Otsu - show all slices ' char(10) ' ']);
    %
    
    % ===============================================================
    
    set(gcf,'WindowKeyPressFcn',@keys_otsu);
else
    figure(hf2);
    %     'ro'
end

medfltval   =str2num(get(findobj(hf2,'tag','otsu_medfilt_val'),'string'));
numcluster  =str2num(get(findobj(hf2,'tag','ed_otsu'),'string'));
do3d=get(findobj(hf1,'tag','rd_otsu3d'),'value');

if isempty(numcluster); return; end

% OTSU 2D/3D
if do3d==1                                         %3d
    %     if isfield(u,'otsu')==0 || numcluster~= u.set.otsu_numClasses
    %         v=reshape(  otsu(u.a(:),numcluster),[ size(u.a) ]);
    %         u.otsu=v;
    %         u.set.otsu_numClasses=numcluster;
    %         set(hf1,'userdata',u);
    %     end
    
    %--------------
    
    
    if isfield(u,'otsu')==0 ||  isfield(u,'otsu3D_numClasses')==0 ||  numcluster~= u.set.otsu3D_numClasses
        disp('otsu3d');
        hf1=findobj(0,'tag','xpainter');
        u=get(hf1,'userdata');
        a=u.a;
        b=u.b;
        %      a=permute(u.a,[setdiff([1:3],u.usedim) u.usedim]);
        %      b=permute(u.b,[setdiff([1:3],u.usedim) u.usedim]);
        
        %med-filter
        if get(findobj(hf2,'tag','otsu_medfilt_rd'),'value')==1
            [a] = ordfilt3D(a,medfltval);
        end
        
        %ot=getslice2d();
        ot3=reshape(  otsu(a(:),numcluster),[ size(a)]);
        
        u.otsu=ot3;
        u.set.otsu3D_numClasses=numcluster;
        set(hf1,'userdata',u);
    end
    
    ot3=permute(u.otsu,[setdiff([1:3],u.usedim) u.usedim]);
    ot=ot3(:,:,u.useslice);
    
    
    %--------------
    
    
    %ot=getslice2d(u.otsu);
    
    if get(findobj(hf1,'tag','rd_transpose'),'value')==1
        %x=permute(r2, [2 1 3]);
        ot=ot';
        %ot3=permute(ot3,[2 1 3]);
    end
    if get(findobj(hf1,'tag','rd_flipud'),'value')==1
        ot =flipud(ot);
        %ot3=flipdim(ot,2);
    end
    
    
else%2d
    
    %med-filter
    if get(findobj(hf2,'tag','otsu_medfilt_rd'),'value')==1
        r1=medfilt2(r1,[medfltval medfltval],'symmetric');
    end
    
    
    ot=otsu(r1,numcluster);
end


% ----------
if 0
    ox=ot;
    ox(ox==1)=0;
    ma=double(label2rgb(ox,'jet'));
    bg=repmat( (imadjust(mat2gray(r1))),[1 1 3]);
    
    fg,imshow(bg.*.9+ma.*0.1)
end
% ----------


hp=findobj(hf2,'tag','pb_otsouse');
if do3d==1
    set(hp,'enable','on');
else
    set(hp,'enable','off');
end

if sum(~isnan(unique(ot(:))))==0
    set(findobj(hf2,'type','image'),'visible','off');
    return
else
    
    try
        set(findobj(hf2,'type','image'),'visible','on');
    end
end

him2=imagesc(ot);
caxis([0 max(ot(:))]);
ax2=get(him2,'parent');
set(him2,'ButtonDownFcn',{@pb_otsouse,1})
set(ax2,'units','norm','position',[0 0 1 1]);
axis off

axis image;
drawnow;
set(hf2,'Pointer','arrow');
drawnow;
% pause(1);
% drawnow
% get(hf2,'tag')

% for i=1:100; set(hf2,'Pointer','arrow'); drawnow; end

% return
pb_otsucut([],[],[]);

% drawnow
% set(gcf,'Pointer','custom');drawnow
% % pointer=ones(16,16)*2; pointer(:,8)=1; pointer(8,:)=1;drawnow
% % set(gcf,'PointerShapeCData',pointer);drawnow
% % pointer=nan(16,16)*2; pointer(:,8)=1; pointer(8,:)=1;drawnow
% set(gcf,'PointerShapeCData',pointer);drawnow
% set(gcf,'PointerShapeCData',pointer);drawnow
% set(gcf,'pointer','cross');



%�����������������������������������������������
%%   make 3d-otsu-fig
%�����������������������������������������������
function otsu3Dmontage_mkfig();
fg;
set(gcf,'name','OTSU-3D','NumberTitle','off','tag','otsu3d');
% him=image(uint8(cat(3,0,0,255)));
% axis off
% set(gca,'position',[0.2 .1 .8 .9]);
v.him=[];
set(gcf,'userdata',v);


% 3d-OTSU                                           3d-OTSU
% ========classes=======================================================
%otsu -number of classes-label
hb=uicontrol('style','text','units','norm', 'string' ,'classes');
set(hb,'fontsize',7,'backgroundcolor',[0.8392    0.9098    0.8510],'fontweight','normal');
set(hb,'position',[0 .95 .12 .04],'HorizontalAlignment','left');
set(hb,'tooltipstring',['otsu define number of classes/clusters' char(10) '--']);
%otsu -number of classes
hb=uicontrol('style','edit','units','norm', 'tag'  ,'otsu3_numclasses','value',0);
set(hb,'position',[ .12 .95 .05 .04],'string','3', 'callback',@otsu3Dmontage_plot);
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['otsu3D: define number of classes/clusters' char(10) '--']);
% =========median-filter======================================================
%medianfilter-radio
hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu3_medfilt_rd','value',1);
set(hb,'position',[0 .91 .12 .04],'string','medfilt', 'callback',@otsu3Dmontage_plot);
set(hb,'fontsize',7,'backgroundcolor',[0.8392    0.9098    0.8510],'fontweight','normal');
set(hb,'tooltipstring',['median filter image prior otsu3D' char(10) '-']);
%medianfilter-filtervalue
hb=uicontrol('style','edit','units','norm', 'tag'  ,'otsu3_medfilt_ed');
set(hb,'position',[.12 .91 .05 .04],'string','3', 'callback',@otsu3Dmontage_plot);
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['median filter length' char(10) '-']);

% =========crop======================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu3_crop','value',1);
set(hb,'position',[0 .78 .12 .04],'string','crop slices', 'callback',@otsu3Dmontage_plot);
set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
set(hb,'tooltipstring',['crop slices for better montage' char(10) '-']);

% =========contour======================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu3Dmontage_contour','value',0);
set(hb,'position',[0 .74 .12 .04],'string','contour', 'callback',@otsu3Dmontage_post);
set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
set(hb,'tooltipstring',['show contour' char(10) '-']);

% =========alpha======================================================

hb=uicontrol('style','text','units','norm');
set(hb,'position',[0 .7 .12 .04],'string','transparency');
set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
set(hb,'tooltipstring',['transparency/alpha: [0-1] range' char(10) '-']);

hb=uicontrol('style','edit','units','norm', 'tag'  ,'otsu3D_alpha','value',0);
set(hb,'position',[0.12 .7 .05 .04],'string','.4', 'callback',@otsu3Dmontage_post);
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','normal');
set(hb,'tooltipstring',['transparency/alpha: [0-1] range' char(10) '-']);



% =========fuse image======================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu3_bgfgfuse','value',1);
set(hb,'position',[0 .6 .14 .04],'string','fuse BG+FG', 'callback',@otsu3Dmontage_post);
set(hb,'fontsize',7,'backgroundcolor',[ 0.9373    0.8667    0.8667],'fontweight','normal');
set(hb,'tooltipstring',['show background /foreground image' char(10) '-']);
% =========BG/FG======================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu3_bgfg','value',0);
set(hb,'position',[0 .56 .14 .045],'string','BG or FG', 'callback',@otsu3Dmontage_post);
set(hb,'fontsize',7,'backgroundcolor',[ 0.9373    0.8667    0.8667],'fontweight','normal');
set(hb,'tooltipstring',['show [0] background image or [1]foreground image' char(10) '-']);



% =========all slices======================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'otsu3_applyAllSlices','value',1);
set(hb,'position',[0 .4 .12 .04],'string','all slices', 'callback',@otsu3Dmontage_plot);
set(hb,'fontsize',7,'backgroundcolor',[1 0.83 0],'fontweight','normal');
set(hb,'tooltipstring',['[1] apply selection on all slices' char(10) '[0] apply only on current slice' char(10) '-']);

set(gcf,'WindowButtonDownFcn',@pb_otsu3D_transmit);



% ==============================================
%%    main caller for 3d-otsu
% ===============================================
function pb_otsu3D(e,e2)
hf=findobj(0,'tag','otsu3d');
delete(hf);
if get(e,'value')==0
    return
end
otsu3Dmontage_mkfig();
otsu3Dmontage_plot([],[]);
% pb_otsu3Dmontage();


% ==============================================
%%    prep otsu
% ===============================================
function otsu3Dmontage_plot(e,e2)
% disp('otsu3d');
% 'aaa'
hf1=findobj(0,'tag','xpainter');
hf3=findobj(0,'tag','otsu3d');
u=get(hf1,'userdata');
numcluster  =str2num(get(findobj(hf3,'tag','otsu3_numclasses'),'string'));
medfltval   =str2num(get(findobj(hf3,'tag','otsu3_medfilt_ed'),'string'));
medfltdo    =get(findobj(hf3,'tag','otsu3_medfilt_rd'),'value');
docrop      =get(findobj(hf3,'tag','otsu3_crop'),'value');
alpha       =str2num(get(findobj(hf3,'tag','otsu3D_alpha'),'string'));

a=u.a;
b=u.b;
%med-filter
if medfltdo==1
    for i=1:size(a,3)
        %a(:,:,i)=adjustIntensity(a(:,:,i))
        a(:,:,i)=medfilt2(a(:,:,i),[medfltval medfltval]);
    end
    %[a] = ordfilt3D(a,medfltval);
end
% ==============================================
%%    % ADJUST IMAGE
% ===============================================
% disp('adjust 3d-volume');
[as hs]=montageout(permute(a,[1 2 4 3]));
as=adjustIntensity(as);
si=size(as)./hs;
as2=zeros(size(a));
n=1;
for i=1:hs(1)
    for j=1:hs(2)
        mi=i*si(1)-si(1)+1:i*si(1)-si(1)+si(1) ;
        mj=j*si(2)-si(2)+1:j*si(2)-si(2)+si(2);
        if n<=size(a,3)
            as2(:,:,n)=as(mi,mj);
            n=n+1;
            %disp(n);
        end
    end
end
a=as2;

ot3=reshape(  otsu(a(:),numcluster),[ size(a)]);
v=get(hf3,'userdata');
o=ot3 ;%u.otsu;
a=u.a;
TX=repmat(permute([1:size(a,3) ]',[3 2 1]),[size(a,1)  size(a,2)  1]); %for slicewise-reversing
o =permute( o,[setdiff([1:3],u.usedim) u.usedim]);
a =permute( a,[setdiff([1:3],u.usedim) u.usedim]);
TX=permute(TX,[setdiff([1:3],u.usedim) u.usedim]);
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    o=permute(o,[2 1 3]);
    a=permute(a,[2 1 3]);
    TX=permute(TX,[2 1 3]);
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    o=flipdim(o,1);
    a=flipdim(a,1);
    TX=flipdim(TX,1);
end

v.a=a;
v.o=o;

% for i=1:size(TX,3)
%     TX(:,:,i)=i;
% end
v.TX=TX;






if docrop==1        %------------------------- CROP
    cm=mean(o,3)==1 ;%crop
    cm=imdilate(cm,strel('square',[7]));
    v.ins_lr=find(mean(cm,1)~=1);
    v.ins_ud=find(mean(cm,2)~=1);
    o  =o(v.ins_ud, v.ins_lr,:);
    a  =a(v.ins_ud, v.ins_lr,:);
    TX =TX(v.ins_ud, v.ins_lr,:);
else
    v.ins_lr=[1:size(o,2)];
    v.ins_ud=[1:size(o,1)];
    
%     if u.usedim~=3
%         
%                 flipdimens=[setdiff([1:3],u.usedim) 2];
%                 otemp=permute(o,flipdimens);
%                 v.ins_lr=[1:size(otemp,2)];
%                 v.ins_ud=[1:size(otemp,1)];
%     end
    
end

v.o1=o; %after cropping
v.a1=a;
v.TX1=TX;

o2 =montageout(permute(o ,[1 2 4 3]));
a2 =montageout(permute(a ,[1 2 4 3]));
TX2=montageout(permute(TX,[1 2 4 3]));

%________________________________________________colorize
numcols=unique(o);
numcols(numcols==0)=[];
colmat = distinguishable_colors(max(numcols),[1 1 1; 0 0 0]);
ra=reshape( o            , [ size(o,1)*size(o,2)*size(o,3)   1 ]);
rb=repmat(ra.*0,[1 3]);
for i=1:length(numcols)
    ix=find(ra==numcols(i));
    rb( ix ,:)  = repmat(colmat(numcols(i),:), [length(ix) 1] );
end
rb=reshape(rb,[ size(o,1) size(o,2) size(o,3)  3]);
clear ma
ma(:,:,1)=montageout(permute(rb(:,:,:,1),[1 2 4 3]));
ma(:,:,2)=montageout(permute(rb(:,:,:,2),[1 2 4 3]));
ma(:,:,3)=montageout(permute(rb(:,:,:,3),[1 2 4 3]));

bg=imadjust(mat2gray(a2));
bg=round(bg.*255);
bg=im2double(uint8(cat(3,bg,bg,bg)));
% bg=double(ind2rgb( round(mat2gray(a2).*255) ,gray));
% ma=im2double(label2rgb(o2,'jet'));
% fg,image(bg)
fus3=(bg.*(1-alpha)+ma.*(alpha)  );
v.him=findobj(gca,'type','image');
if ~isempty(v.him) ; set(v.him,'cdata',fus3); else;     v.him=image(fus3); end
% fg,
% image(bg.*(1-alp)+ma.*(alp)  );
% % fg,image(ma.*(alp)  )
axis off
set(gca,'position',[0.2 .1 .75 .9]);
xlim([.5 size(fus3,2)+.5]);       ylim([.5 size(fus3,1)+.5]);
% --------------
v.numcols=numcols;
v.colmat=colmat;
v.bg=bg;
v.ma=ma;
v.fus3=fus3;
v.o2=o2; %2d otsu montage
v.ot3=ot3;
v.TX2=TX2;
set(gcf,'userdata',v);

set(gca,'position',[0.175 .0 .825 1]);
set(gcf,'WindowButtonMotionFcn',@otsu3d_motion);


axis off;

hs=uicontrol('style','text','units','normalized','string','current cluster');
set(hs,'backgroundcolor','k','foregroundcolor',[1 .85 0],'tag','tx_selected_cluster');
set(hs,'position',[0.001 0 .173 .08],'fontweight','bold','fontsize',9,'string',{'current cluster' '--'});

function otsu3d_motion(e,e2);

%      return

co=get(gca,'CurrentPoint');
co=round(co(1,[1 2])); %right-down
% disp(co)
xl=xlim; yl=ylim();
if co(1)<0 || co(1)>xl(2)      ||    co(2)<0 || co(2)>yl(2)
    %'out'
    return ;
else ;%     'in'
end

hf1=findobj(0,'tag','xpainter');
hf3=findobj(0,'tag','otsu3d');
u=get(hf1,'userdata');
v=get(hf3,'userdata');
try
    val=v.o2(co(2),co(1));
    % disp(val);
    hs=findobj(gcf,'tag','tx_selected_cluster');
    if val==0
        valstr=' - ';
    else
        valstr=num2str(val);
    end
    set(hs,'string',{'current cluster' valstr});
    
end

% ==============================================
%%    otsu_transmit 3d
% ===============================================
function pb_otsu3D_transmit(e,e2);
co=get(gca,'CurrentPoint');
co=round(co(1,[1 2])) ;%right-down

xl=xlim; yl=ylim();
if co(1)<0 || co(1)>xl(2)      ||    co(2)<0 || co(2)>yl(2)
    return ;%'out'
    % else ;%     'in'
end



hf1=findobj(0,'tag','xpainter');
hf3=findobj(0,'tag','otsu3d');
u=get(hf1,'userdata');

% disp(co)
v=get(hf3,'userdata');
val=v.o2(co(2),co(1));
mp=v.o2==val;

reg=v.o1==val;
[cl numsubslust] =bwlabeln(reg);
tb=[[1:numsubslust]' histc(cl(:),1:numsubslust)];
dum1 =cl(:);
dum2=dum1(:)*0;
tb=tb(tb(:,2)>100,:);
for i=1:size(tb,1)
    dum2(dum1==tb(i,1))=i;
end
cl=reshape(dum2, size(reg));
numsubslust=size(tb,1);

cl2 =montageout(permute(cl,[1 2 4 3]));

% clrgb=im2double(label2rgb(cl2,'jet'));

%________________________________________________colorize
numcols=unique(cl);
numcols(numcols==0)=[];
colmat = distinguishable_colors(max(numcols),[1 1 1; 0 0 0]);
ra=reshape( cl           , [ numel(cl) 1 ]);
rb=repmat(ra.*0,[1 3]);
for i=1:length(numcols)
    ix=find(ra==numcols(i));
    rb( ix ,:)  = repmat(colmat(numcols(i),:), [length(ix) 1] );
end
rb=reshape(rb,[ size(cl)  3]);
clear ma
clrgb(:,:,1)=montageout(permute(rb(:,:,:,1),[1 2 4 3]));
clrgb(:,:,2)=montageout(permute(rb(:,:,:,2),[1 2 4 3]));
clrgb(:,:,3)=montageout(permute(rb(:,:,:,3),[1 2 4 3]));



alpha=.6;
fus4=(v.bg.*(1-alpha)+clrgb.*(alpha)  );
fg,imagesc( fus4);
set(gcf,'WindowButtonDownFcn',@otsu3d_selectsubcluster);
set(gcf,'WindowButtonMotionFcn',@otsu3d_subclustermotion);
v.inf3='*** sub-cluster-selection ***';
v.cl =cl;
v.cl2=cl2;

v.index3d=reshape([1:prod(size(cl))]',[size(cl) ]);
v.index2d=montageout(permute(v.index3d,[1 2 4 3]));

% title({['#clusters: ' num2str(numsubslust)];['\fontsize{16}black {\color{magenta}magenta click cluster']})
% ==============================================
%%    title subcluster
% ===============================================
ti=title(['\fontsize{10}  -->  { ' ...
    '\color[rgb]{0 0 1} Cluster-' num2str(val) ...
    '\color[rgb]{0 0 0} contains  '  ...
    '\color[rgb]{1 0 0} '  num2str(numsubslust)  ' Subclusters'  char(10)...
    '\color[rgb]{0 .5 .5} Click onto cluster to submit this cluster.}  '...
    ]);
pos=get(ti,'position');
set(ti,'position',[ 100 pos(2) 0],'HorizontalAlignment','left');
set(hf3,'userdata',v);

axis off;
set(gca,'position',[.097 .005 .9 .9]);
hs=uicontrol('style','text','units','normalized','string','current cluster');
set(hs,'backgroundcolor','k','foregroundcolor',[1 .85 0],'tag','tx_selected_subcluster');
set(hs,'position',[0.7 0.905 .297 .04],'fontweight','bold','fontsize',10);

function otsu3d_subclustermotion(e,e2)
co=get(gca,'CurrentPoint');
co=round(co(1,[1 2])); %right-down
% disp(co)
xl=xlim; yl=ylim();
if co(1)<0 || co(1)>xl(2)      ||    co(2)<0 || co(2)>yl(2)
    %'out'
    return ;
else ;%     'in'
end

try
    hf1=findobj(0,'tag','xpainter');
    hf3=findobj(0,'tag','otsu3d');
    u=get(hf1,'userdata');
    v=get(hf3,'userdata');
    val=v.cl2(co(2),co(1));
    % disp(val);
    hs=findobj(gcf,'tag','tx_selected_subcluster');
    if val==0
        valstr=' - ';
    else
        valstr=num2str(val);
    end
    set(hs,'string',[ 'current cluster: ' valstr ]);
end

function otsu3d_selectsubcluster(e,e2)
co=get(gca,'CurrentPoint');
co=round(co(1,[1 2])); %right-down
% disp(co)
xl=xlim; yl=ylim();
if co(1)<0 || co(1)>xl(2)      ||    co(2)<0 || co(2)>yl(2)
    %'out'
    return ;
else ;%     'in'
end

hf1=findobj(0,'tag','xpainter');
hf3=findobj(0,'tag','otsu3d');
u=get(hf1,'userdata');
v=get(hf3,'userdata');
if isempty(v)
    warndlg('otsu3d main window was closed...can''t proceed ');
    return
end
val=v.cl2(co(2),co(1));
mp=v.cl2==val;
if val==0; return; end

%% ===============================================
idx=v.index2d(co(2),co(1));

b1=v.cl==val;
% s=v.a1.*(b1==1);
%% ===============================================
% prune cluster-slicewise
%% ===============================================

[xa xb xc ]=ind2sub(size(b1), idx);
c1=squeeze(b1(:,:,xc));
cr=bwlabeln(c1);
cref=cr==cr(xa,xb);
ivec   =[ xc+1:size(b1,3)  xc-1:1   ];
ivecref=[ xc:size(b1,3)-1   xc:2   ];
isl=[ivec' ivecref'];

bm=zeros(size(b1));
bm(:,:,xc)=cref;
for i=1:size(isl,1)  
    r1=bwlabeln(b1(:,:,isl(i,1)));
    r2=bm(:,:,isl(i,2))~=0;
    q=(r2(:).*r1(:));
    uni=unique(q); uni(uni==0)=[];
    t=[uni(:) histc(q,uni)];
    t=flipud(sortrows(t,2));
     
    uni=0;
    t(find(t(:,2)<50),:)=[];
    if~isempty(t)
        t=t(1,:);
        uni=t(:,1);
        %     disp([i length(uni)  ]);
        q2=zeros(size(r1));
        for j=1:length(uni)
            q2(r1==uni(j))=1;
        end
        bm(:,:,isl(i,1))=q2;
    end
%     figure(10);
%     subplot(2,2,1); imagesc(r1);
%     subplot(2,2,2); imagesc(r2) ;title('ref');
%     subplot(2,2,3); imagesc(bm(:,:,isl(i,1))); title([i length(uni)  ])
%     drawnow; pause
end
b1=bm;


%% ===============================================



% ==============================================
%%   
% ===============================================

b2=zeros(size(v.o));
% fill background image if image is croped and subcluster is at the border
if get(findobj(hf3,'tag','otsu3_crop'),'value')==1 %croped image
    bord=mp([1 end],:,:);bord=bord(:);
    bord=mp(:,[1 end],:);bord=[bord(:); bord(:)];
    if [sum(bord>0)./length(bord)>.5]
        b2=ones(size(b2));
    end
end
b2(v.ins_ud, v.ins_lr,:)=b1;

disp(['size b1:' num2str( size(b1))])
disp(['size b2:' num2str( size(b2))])

% ------flipdim
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    b2=flipdim(b2,1);
end
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
     b2=permute(b2,[2 1 3]);
end

b3=b2;
if u.usedim==2
        b3=   permute(b2,[setdiff([1:3],u.usedim) u.usedim]);
elseif u.usedim==1
        b3=   permute(b2,[ 3 1 2]);
end
%  size(u.a):   164   212   158
% ------------ update mask
inmaskVal=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
b3(b3==1)=inmaskVal;


disp(['size b1:' num2str( size(b1))]);
disp(['size b2:' num2str( size(b2))]);
disp(['size b3:' num2str( size(b3))]);
disp(['size a:' num2str( size(u.a))]);
% montage2(u.a)
% montage2(b3)
%% ===============================================



u.b=b3;
set(hf1,'userdata',u);
figure(hf1);
setslice();



return
%% ===============================================

% global SLICE
% fg,imagesc(SLICE.r1)

%% ===============================================

%--------backtrafo
 b1=zeros(size(v.o1));

 if u.usedim~=3
     
     b1=zeros(size(v.o1));
     size(b1)
     
%        158   164   212
     
%      flipdimens=[setdiff([1:3],u.usedim) u.usedim]
%      b1=zeros(size(v.o1));
%      b1=permute(b1,flipdimens);
%      size(b1)
%         
%      % end
%     dimv=[size(v.o1,flipdimens(1)) size(v.o1,flipdimens(2))  size(v.o1,flipdimens(3)) ] ;
%     b1=zeros(dimv);
 
    for i=1:size(b1,1)
        ix=find(v.TX2==i);
        if ~isempty(ix)
            [length(mp(ix))   prod([size(b1,u.usedim) size(b1,3)])]
            tt=squeeze(reshape(  mp(ix), [size(b1,u.usedim) size(b1,3)] ));
            b1(i,:,:)=tt;
        end
    end
%     b1=permute(b1,[setdiff([1:3],u.usedim) u.usedim]);
    
 else
      b1=zeros(size(v.o1));
     for i=1:size(b1,3)
         ix=find(v.TX2==i);
         if ~isempty(ix)
             tt=reshape(  mp(ix), [length(v.ins_ud) length(v.ins_lr)] );
             b1(:,:,i)=tt;
         end
     end
     
     
 end




% ------deCrop
%get(findobj(hf3,'tag','otsu3_crop'),'value')
% if ~isempty(v.ins_lr) || ~isempty(v.ins_ud)
b2=zeros(size(v.o));



% fill background image if image is croped and subcluster is at the border
if get(findobj(hf3,'tag','otsu3_crop'),'value')==1 %croped image
    bord=mp([1 end],:,:);bord=bord(:);
    bord=mp(:,[1 end],:);bord=[bord(:); bord(:)];
    if [sum(bord>0)./length(bord)>.5]
        b2=ones(size(b2));
    end
end
b2(v.ins_ud, v.ins_lr,:)=b1;
% end
% ------flipdim
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    b2=flipdim(b2,1);
end
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    b2=permute(b2,[2 1 3]);
end

if u.usedim~=3
        b2=   permute(b2,[setdiff([1:3],u.usedim) u.usedim]);
end


% ------------ update mask
ix=find(b2(:)==1);
up=u.b(:);
up(ix)=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
up2=reshape(up,size(b2));

u.b=up2;
set(hf1,'userdata',u);
figure(hf1);
setslice();




return

%
% o=ot3 ;%u.otsu;
% a=u.a;
% TX=repmat(permute([1:size(a,3) ]',[3 2 1]),[size(a,1)  size(a,2)  1]); %for slicewise-reversing
% o =permute( o,[setdiff([1:3],u.usedim) u.usedim]);
% a =permute( a,[setdiff([1:3],u.usedim) u.usedim]);
% TX=permute(TX,[setdiff([1:3],u.usedim) u.usedim]);
% if get(findobj(hf1,'tag','rd_transpose'),'value')==1
%     o=permute(o,[2 1 3]);
%     a=permute(a,[2 1 3]);
%     TX=permute(TX,[2 1 3]);
% end
% if get(findobj(hf1,'tag','rd_flipud'),'value')==1
%     o=flipdim(o,1);
%     a=flipdim(a,1);
%     TX=flipdim(TX,1);
% end


% ==============================================
%%    otsu3Dmontage_post
% ===============================================
function otsu3Dmontage_post(e,e2)
% 'post3d'
hf3=findobj(0,'tag','otsu3d');
v=get(hf3,'userdata');

% if strcmp(get(e,'tag'),'otsu3D_alpha')
alpha      =str2num(get(findobj(hf3,'tag','otsu3D_alpha'),'string'));
docontour  =       (get(findobj(hf3,'tag','otsu3Dmontage_contour'),'value'));

hfuse=findobj(hf3,'tag','otsu3_bgfgfuse');
hbgfg=findobj(hf3,'tag','otsu3_bgfg');
dofuse     =       get(hfuse,'value');
showbgfg   =       get(hbgfg,'value');

if strcmp(get(e,'tag'),'otsu3_bgfg')
    if showbgfg==0  %BG-image
        dx=v.bg;
    else             %FG-image
        dx=v.ma;
    end
    set(hfuse,'value',0);
else %FUSE
    if dofuse==1
        set(hbgfg,'value',0)
        v.fus3=(v.bg.*(1-alpha)+v.ma.*(alpha)  );
        dx=v.fus3;
    else
        set(hbgfg,'value',0);
        set(hfuse,'value',0);
        otsu3Dmontage_post(hbgfg,[]);
        return
    end
end
if dofuse==0
    set(hfuse,'value',0);
    if showbgfg==0  %BG-image
        dx=v.bg;
    else             %FG-image
        dx=v.ma;
        
    end
end %fuse

v.him=findobj(gca,'type','image');
if ~isempty(v.him);    set(v.him,'cdata',dx);
else;                  v.him=image(dx);
end;
xlim([.5 size(dx,2)+.5]);       ylim([.5 size(dx,1)+.5]);

set(gcf,'userdata',v);


if docontour==1
    hold on;contour(v.o2,size(v.numcols,1));
    colormap(v.colmat);
else
    delete(findobj(gca,'type','contour'));
end






%�����������������������������������������������
%%   otsu-2d !!!
%�����������������������������������������������


function pb_otsucut(e,e2,par)
hf=findobj(0,'tag','otsu');
him2=findobj(hf,'Type','image');
if get(findobj(hf,'tag','pb_otsucut'),'value')==1  % CUT-OTSU
    
    set(him2,'ButtonDownFcn',[]);
    set(hf,'WindowButtonDownFcn',{@selcut,1});
    set(hf,'WindowButtonUpFcn' ,{@selcut,0});
    set(hf,'WindowButtonMotionFcn',@otsumotion);
    
    o=get(hf,'userdata');
    o.docut=0;
    set(hf,'userdata',o);
    xl=xlim; yl=ylim; xlim(xl);ylim(yl);
    
    % disp(get(gcf,'selectiontype'))
    
else % transfer cluser
    set(him2,'ButtonDownFcn',{@pb_otsouse,1});
    set(hf,'WindowButtonDownFcn',[]);
    set(hf,'WindowButtonUpFcn' ,[]);
    set(hf,'WindowButtonMotionFcn',[]);
end



function selcut(e,e2,isBttnDown)
% arg
hf=findobj(0,'tag','otsu');
o=get(hf,'userdata');
o.docut=isBttnDown;

o.lastpoint=[];



if o.docut==1
    
    %     disp(get(gcf,'selectiontype'));
    selectionType=get(gcf,'selectiontype');
    if strcmp(selectionType,'alt')
        pb_otsouse([],[],1)
    end
end
set(hf,'userdata',o);
% disp(o);

if get(findobj(hf,'tag','pb_otsucut'),'value')==1 && isBttnDown==0 %% cutting=on, but BTTN relased
    %     isBttnDown
    %     him2=findobj(hf,'Type','image');
    %     dx=get(him2,'cdata');
    %     d=dx==0;
    o.lastpoint=[];
    set(hf,'userdata',o);
end

function otsumotion(e,e2)
hf=findobj(0,'tag','otsu');
o=get(hf,'userdata');
him2=findobj(hf,'Type','image');


try
    if o.docut==1
        co=round(get(gca,'CurrentPoint'));
        
        
        dx=get(him2,'cdata');
        if co(1,2)<=size(dx,1) && co(1,1)<=size(dx,2) && co(1,2)>0 && co(1,1)>0
            dx(co(1,2),co(1,1))=0;
            
            
            if 1 %interpolate
                if isempty(o.lastpoint)==0
                    
                    cola=o.lastpoint;
                    %                     if max(abs(cola(1,1:2)-co(1,1:2)))>1
                    % disp('flass');
                    x=[cola(1,1) co(1,1)];
                    y=[cola(1,2) co(1,2)];
                    stp=15*max(abs(x-y));
                    x1=round(linspace(x(1),x(2),stp));
                    y1=round(linspace(y(1),y(2),stp));
                    ix=sub2ind([size(dx)], y1, x1);
                    dx(ix)=0;
                    %                     end
                    %                     xx=sort([o.lastpoint(1,1) co(1,1)]);
                    %                     yy=sort([o.lastpoint(1,2) co(1,2)]);
                    %                     disp([o.lastpoint(1,1:2)  co(1,1:2)]);
                    
                    %                     lin=[[xx(1):xx(2)]' [yy(1):yy(2)]'];
                    
                end
                o.lastpoint=co;
                set(hf,'userdata',o);
            end
            
            
            set(him2,'cdata',dx);
        end
        %         rand(1)
        %         drawnow;
    end
end



function pb_otsouse(e,e2,par)
if exist('par')==0; par=2; end

hf1=findobj(0,'tag','xpainter');
hf2=findobj(0,'tag','otsu');
u=get(hf1,'userdata');

figure(hf2);

% selectionType=get(gcf,'selectiontype')
% if strcmp(selectionType,'alt')
%    hb= findobj(hf2,'tag','pb_otsucut')
%    set(hb,'value',1)
%
%     him2=findobj(hf2,'Type','image');
%     set(him2,'ButtonDownFcn',[]);
%     set(hf2,'WindowButtonDownFcn',{@selcut,1});
%     set(hf2,'WindowButtonUpFcn' ,{@selcut,0});
%     set(hf2,'WindowButtonMotionFcn',@otsumotion);
%
%
% %     otsumotion()
%
%     o=get(hf2,'userdata');
%     o.docut=0;
%     set(hf2,'userdata',o);
%     xl=xlim; yl=ylim; xlim(xl);ylim(yl);
%
%
%     return
% end

if par==2 || par==3
    [x y]=ginput(1);
    set(gcf,'Pointer','arrow');
    %     disp('x-y');
    %     [x y]
    %     disp('cp');
    cor=get(gca,'CurrentPoint');
else
    
    
    
    
    set(gcf,'Pointer','arrow');
    cor=get(gca,'CurrentPoint');
    x=cor(1,1);  y=cor(1,2);
end
% return
xb=x;
yb=y;

figure(hf1);
dx=get(findobj(hf2,'type','image'),'cdata');
val=dx(round(y),round(x));

valotsu=val;
dx2=bwlabel(dx==val,4);
m=double(dx2==dx2(round(y),round(x)));


dims=u.dim(setdiff(1:3,u.usedim));
bw = m;
%         if u.usedim==3
r1=getslice2d(u.a);
r2=getslice2d(u.b);
r1=adjustIntensity(r1);


if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    %x=permute(r2, [2 1 3]);
    r1=r1';
    r2=r2';
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r1=flipud(r1);
    r2=flipud(r2);
end

%             r1=u.a(:,:,u.useslice);
%             r2=u.b(:,:,u.useslice);
si=size(r2);
r2=r2(:);
% if type==1
r2(bw==1)  =  str2num(get(findobj(hf1,'tag','edvalue'),'string'))  ;
% elseif type==2
%     r2(bw==1)  =  0;
% end

r2=reshape(r2,si);

%===== update history
% r2=getslice2d(u.b);


r2n=r2;
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r2n=flipud(r2n);
end
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    r2n=r2n';
end

if sum(any(u.hist(:,:,u.histpointer)-r2n))==0; return; end

u.histpointer=u.histpointer+1;
u.hist(:,:,u.histpointer)=r2n;



% disp(u);
% set(gcf,'userdata',u);




alp=u.alpha;% .8
% val=unique(u.b); val(val==0)=[];
r2v=r2(:);
r1=mat2gray(r1);
ra=repmat(r1,[1 1 3]);

rb=reshape(zeros(size(ra)), [ size(ra,1)*size(ra,2) 3 ]);
val=unique(r2); val(val==0)=[];
for i=1:length(val)
    ix=find(r2v==val(i));
    rb( ix ,:)  = repmat(u.colmat(val(i),:), [length(ix) 1] );
end
% rb=reshape(rb,size(ra));
s1=reshape(ra,[ size(ra,1)*size(ra,2) 3 ]);
rm=sum(rb,2);
im=find(rm~=0);
% s1(im,:)= (s1(im,:)*alp)+(rb(im,:)*(1-alp)) ;
s1(im,:)= (s1(im,:)*(1-alp))+(rb(im,:)*(alp)) ;
x=reshape(s1,size(ra));


set(u.him,'cdata',   x  );


% u=putsliceinto3d(u,r2,'b');
r2n=r2;
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r2n=flipud(r2n);
end
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    r2n=r2n';
end
u=putsliceinto3d(u,r2n,'b');
set(gcf,'userdata',u);
undo_redolabel_update();


him=findobj(gcf,'tag','image');


if par==3 %replace
    %%     f = msgbox('this will overwrite the entire mask')
    answer = questdlg('this will replace the entire mask over all slices..proceed?', ...
        '', 	'yes','no','dd');
    if strcmp(answer,'no'),'return'; end
    
    ot3=u.otsu;
    ot3=double(ot3==valotsu);
    sm=strel('disk',2);
    ot3=imdilate( imerode( ot3  ,sm)  ,sm);
    ot4=bwlabeln(ot3,6);
    
    u.ot4=ot4;
    bv=getslice2d(u.ot4);
    clustnum=bv(round(yb),round(xb));
    ot5=zeros(size(ot4));
    ot5(ot4==clustnum)=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
    %     ot3(ot3==1)=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
    
    % montage2(ot5)
    
    u.b=ot5;
    set(hf1,'userdata',u);
end


hb=findobj(gcf,'tag','pb_nextstep');
hgfeval(get( hb ,'callback'),[], 1);

drawnow;
% figure(hf1);
% %----------------
% hf1=findobj(0,'tag','xpainter');
% figure(hf1);


figure(hf2);


function mask2struct(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
hax=findobj(hf1,'type','axes');
% co=get(hax,'CurrentPoint')
global currpo


global SLICE
r1=SLICE.r1;
r2=SLICE.r2;
% ----------------------------------------------------
%% transpose
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    %x=permute(r2, [2 1 3]);
    r1=r1';
    r2=r2';
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r1=flipud(r1);
    r2=flipud(r2);
end
try
bw=bwlabeln(r2==r2(currpo.co(2),currpo.co(1)));
catch
   msgbox('ERROR: click onto ROI/mask first.. than hit this buttton!');
   return
end
bw=r2(currpo.co(2),currpo.co(1))*double(bw==bw(currpo.co(2),currpo.co(1)));
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    bw=flipud(bw);
end
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    bw=bw';
end

u.copymask=bw;
set(hf1,'userdata',u);

function mask2slice(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
hax=findobj(hf1,'type','axes');
global SLICE
r1=SLICE.r1;
r2=SLICE.r2;
if isfield(u,'copymask')==0
       msgbox('ERROR: Copy a ROI/mask first.. than hit this buttton!');
       return
end
bw=u.copymask;
% ----------------------------------------------------
%% transpose
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    %x=permute(r2, [2 1 3]);
    bw=bw';
    r2=r2';
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    bw=flipud(bw);
    r2=flipud(r2);
end

r2n=bw+r2;

% % =========BACK=====================================
aa_setslice(r2n);
%update IDlist
hb=findobj(hf1,'tag','edvalue');
% set(hb,'string', num2str(newID))
edvalue();
setslice([],1);




function pb_undoredo(e,e2,direction)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');

% if ~histpointer
if direction==-1
    if u.histpointer>1
        u.histpointer=u.histpointer+direction;
    else
        return;
    end
elseif direction==+1
    if u.histpointer<size(u.hist,3)
        u.histpointer=u.histpointer+direction;
    else
        return;
    end
end

r2=u.hist(:,:,u.histpointer);
u=putsliceinto3d(u,r2,'b');
set(gcf,'userdata',u);


setslice([],'noupdate');
edvalue();


function rd_flipud(e,e2)
keepHistory=1;
setslice([],keepHistory);

function rd_transpose(e,e2)
keepHistory=1;
setslice([],keepHistory);


function setslice(par,useoldHistory)
hf1=findobj(0,'tag','xpainter');
% borderDel();
u=get(hf1,'userdata');
alp=u.alpha;% .8
if exist('par')==1
    if par==1
        alp=0;
    end
    
end

% r1=getslice2d(u.a);
% r2=getslice2d(u.b);
%
getImage();
global SLICE
r1=SLICE.r1;
r2=SLICE.r2;


if 0
    i=mat2gray(r1);
    i1=imadd(i,100);
    i2=imsubtract(i,50);
    i3=immultiply(i,0.5);
    i4=imdivide(i,0.5);
    i5=imcomplement(i);
    %     fg;imagesc(i5); colormap gray
    r1=i5;
end


if exist('useoldHistory')~=1
    u.hist       =r2;
    u.histpointer=size(u.hist,3);
    set(hf1,'userdata',u);
    %     disp(u);
end
% if exist('useoldHistory') && strcmp(useoldHistory,'noupdate')
    
% else
%     if exist('useoldHistory')==0
%     else
%         borderDel();
%     end
% end
if 0
    if exist('par')
        disp('par:');
        disp(par);
    else
        disp('par: undefined');
    end
    if exist('useoldHistory')
        disp('useoldHistory');
        disp(useoldHistory);
    else
        disp('useoldHistory: undefined');
    end
end

% if exist('useoldHistory')==0 &&  exist('par')==0
%     borderDel();
% end

% else
% borderDel();
% end

% if u.usedim==3
%     r1=u.a(:,:,u.useslice);
%     r2=u.b(:,:,u.useslice);
% end

r1=mat2gray(r1);
r1=adjustIntensity(r1);


% if 0
%     'flt'
%     r1=imgaussfilt(r1,.75);
% end

ra=repmat(r1,[1 1 3]);

% if 0
%     rx=r2./max(r2(:));
%     rb=cat(3,rx,rx.*0,rx.*0);
% end

val=unique(u.b); val(val==0)=[];
if length(val)>size(u.colmat,1)
    u.colmat=distinguishable_colors(length(val),[1 1 1; 0 0 0]);
    set(hf1,'userdata',u);
end

r2v=r2(:);
rb=reshape(zeros(size(ra)), [ size(ra,1)*size(ra,2) 3 ]);
for i=1:length(val)
    ix=find(r2v==val(i));
    rb( ix ,:)  = repmat(u.colmat(val(i),:), [length(ix) 1] );
end
% rb=reshape(rb,size(ra));
s1=reshape(ra,[ size(ra,1)*size(ra,2) 3 ]); %GBimage
rm=sum(rb,2);
im=find(rm~=0);
% s1(im,:)= (s1(im,:)*alp)+(rb(im,:)*(1-alp)) ;
s1(im,:)= (s1(im,:)*(1-alp))+(rb(im,:)*(alp)) ;
x=reshape(s1,size(ra));

%------------
bg2d=r1;

% ----------------------------------------------------
%% transpose
htran=findobj(hf1,'tag','rd_transpose');
doTrans=get(htran,'value');
if doTrans==1
    x   =permute(x, [2 1 3]);
    bg2d=permute(bg2d, [2 1 3]);
end
%% flipud
hflip=findobj(hf1,'tag','rd_flipud');
if get(hflip,'value')==1
    x=flipud(x);
    bg2d=flipud(bg2d);
end
% ----------------------------------------------------
if isempty(u.him)
    u.him=image(  x );
    %u.him=image(  (ra*alp)+(rb*(1-alp))   );
else
    set(u.him,'cdata',  x );
    %set(u.him,'cdata',   (ra*alp)+(rb*(1-alp))    );
end
set(findobj(gcf,'tag'  ,'edslice'),'string',u.useslice);
set(findobj(gcf,'tag'  ,'edalpha'),'string',u.alpha);
axis off;

if get(findobj(gcf,'tag'  ,'rd_axisnormal'),'value')==1  %/ axis image
    axis image;
else                                                    %/ axis normal
    axis normal;
end
set(gca,'position',[0 0 .8 .9]);

if 0
    if size(x,2)>250
        axis square; axis manual;
    end
end


adjustAxesPosition()
% xl=xlim;
xlim([.5 size(x,2)+.5]);
% yl=ylim;
ylim([.5 size(x,1)+.5]);


definedot();
set(u.him,'ButtonDownFcn', @sel);
% set(hf1,'WindowButtonUpFcn', @selup);
% set(h  ,'ButtonDownFcn', @sel)
set(gca  ,'ButtonDownFcn', @sel);
set(gcf,'ButtonDownFcn', @sel);  % #critical


u.bg2d=bg2d;

[u.slice_ax]=aa_getslice_spec(u.ax);
[u.slice_ay]=aa_getslice_spec(u.ay);
[u.slice_az]=aa_getslice_spec(u.az);

set(gcf,'userdata',u);




%
% xlim([0.5 size(ra,2)+.5]);
% ylim([0.5 size(ra,1)+.5]);
undo_redolabel_update();
updateContour();         %CONTOURUPDATE




% % ---- contour
% if u.contour==1
%     delete(findobj(gca,'type','contour'));
%     %g=rgb2gray(x);
%     hold on
%     [h hc]=contour(bg2d,u.contourlines);
%    set(hc,'hittest','off');
% else
%    delete(findobj(gca,'type','contour'));
% end

%-----otsu update
hf1=findobj(0,'tag','xpainter');
if get(findobj(hf1,'tag','rd_otsu'),'value')==1
    if exist('histupdate')~=1
        pb_otsu([],[]);
    end;
    figure(hf1);
end
% pb_measureDistance_off(); %remove measuring tool
% pb_measureDistance_off();
% axes(findobj(gcf,'type','hf1'));

function undo_redolabel_update()
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
% ----- histlabel
hl=findobj(hf1,'tag','pb_undoredo_label');
try
    histlabel=['hist: ' num2str(u.histpointer) '/' num2str(size(u.hist,3))];
catch
    histlabel=['hist: ' '1/1'];
end
set(hl,'string',histlabel);

function rd_sliceBelowPan1(e,e2)

adjustAxesPosition();

function adjustAxesPosition()
hf1=findobj(0,'tag','xpainter');

hp=findobj(hf1,'tag','panel1');
set(hp,'units','norm');
norpos1=get(hp,'position');
set(hp,'units','pixels');

hp2=findobj(hf1,'tag','panel2');
set(hp2,'units','norm');
norpos2=get(hp2,'position');
set(hp2,'units','pixels');

% --adjust axes
hax=findobj(hf1,'type','axes');
axpos=get(hax,'position');
%axpos=[0 0  norpos2(1)  norpos1(2)];
if get(findobj(hf1,'tag','rd_sliceBelowPan1'),'value') ==1
    axpos=[0 0 1 1];
else
    axpos=[0 0  1  norpos1(2)];
end
set(hax,'position',axpos);


function pan2_CB(e,e2)

% je = findjobj(h33); % hTable is the handle to the uitable object
% set(je,'MouseDraggedCallback',@pan2_dragCB  );
%
% hf1=findobj(0,'tag','xpainter');
% hp2=findobj(hf1,'tag','panel2')
% hb=findobj(hp2,'tag','thresh_drag');
% je = findjobj(hb); % hTable is the handle to the uitable object
% set(je,'MouseDraggedCallback',@pan2_dragCB  );

%===================================================================================================
function resizefig(e,e2)
hf1=findobj(0,'tag','xpainter');
hp=findobj(hf1,'tag','panel1');
% pixpos=get(hp,'position');
set(get(hp,'children'),'units','pixels');
set(hp,'units','norm');
norpos1=get(hp,'position');
norpos1=[0 1-norpos1(4) norpos1(3:4)];
pospan1=norpos1;
set(hp,'position',norpos1);
set(hp,'units','pixels');

% %% pan2 ----------
% hp2=findobj(hf1,'tag','panel2');
% % pixpos=get(hp,'position');
% set(get(hp2,'children'),'units','pixels');
% set(hp2,'units','norm');
% norpos2=get(hp2,'position');
% norpos2=[1-norpos2(3)   0  norpos2(3:4)];
% set(hp2,'position',norpos2);
% set(hp2,'units','pixels');

%% pan2 ------------------------------------------------------------
hp2=findobj(hf1,'tag','panel2');
v=get(hp2,'userdata');

set(hp2,'units','pixels');
pospx3=get(hp2,'position');
set(hp2,'position',[ pospx3(1:2) v.unp(3:4) ]);
%set(hp2,'position',[ pospx3(1) 1-pospx3(2)  v.unp(3:4) ]);


set(hp2,'units','norm');
pos=get(hp2,'position');
% set(hp2,'position',[ pos ]);
% if pos(1)>1; pos(1)=.9; end
% if pos(2)>1; pos(2)=.7; end

posbk=v.unn;
posn =[posbk(1) 1-(posbk(2)+posbk(4)) pos(3:4) ];
%posn =[posbk(1) posbk(2) pos(3:4) ];

% posn
if  posn(2)+posn(4)>pospan1(2);
    posn(2)=pospan1(2)-posn(4);
end

% % % % % if posn(2)<0; posn(2)=0; end
% % % % % posn
if posn(1)+posn(3)>1;
    posn(1)=1-posn(3);
end
set(hp2,'position',posn);
% drawnow;
% posn

v.unn=posn; %update Normal position
set(hp2,'userdata',v);

hb=findobj(hp2,'tag','pan2_dragCB');
je = findjobj(hb); % hTable is the handle to the uitable object
set(je,'MouseDraggedCallback',@pan2_dragCB  );


%% pan3 ------------------------------------------------------------
hp3=findobj(hf1,'tag','panel3');
v=get(hp3,'userdata');

set(hp3,'units','pixels');
pospx3=get(hp3,'position');
set(hp3,'position',[ pospx3(1:2) v.unp(3:4) ]);
set(hp3,'units','norm');

pos=get(hp3,'position');
if pos(1)>1; pos(1)=.9; end
if pos(2)>1; pos(2)=.7; end
set(hp3,'position',[ pos ]);

% uistack(hp3,'top');

hb=findobj(hp3,'tag','thresh_drag');
% set(h33,'string','','tooltipstring','drag panel to another position ','tag','thresh_drag');
je = findjobj(hb); % hTable is the handle to the uitable object
set(je,'MouseDraggedCallback',@thresh_dragCB  );

% ----------------
% --adjust axes
adjustAxesPosition();




return
%
% hf1=findobj(0,'tag','xpainter');
% u=get(hf1,'userdata');
% if isfield(u,'controls')==0
%     u.controls=findobj(gcf,'Type','uicontrol');
%     set(u.controls,'units','pixels');
%     u.controls_pospix=get(u.controls,'position');
%     set(u.controls,'units','norm');
%     u.controls_posnorm=get(u.controls,'position');
%     set(hf1,'userdata',u);
% end
%
% set(u.controls,'units','pixels');
% for i=1:length(u.controls)
%     pos=get(u.controls(i),'position');
%     pos(3:4)=u.controls_pospix{i}(3:4);
%     set(u.controls(i),'position',pos);
% end
% set(u.controls,'units','norm');




% ==============================================
%%
% ===============================================

function updateContour();
hf1=findobj(0,'tag','xpainter');
u=get(gcf,'userdata');
hp=findobj(hf1,'tag','panel3');

hp3 =findobj(gcf,'tag','panel3'); %panel3
hvis=findobj(hp3,'tag','thresh_visible'); %visible

if get(hvis,'value')==1
    u.contour=0;
    set(hf1,'userdata',u);
    hb=findobj(hp,'tag','slid_thresh'); %slider
    delete(findobj(gca,'type','contour'))
    slid_thresh([], []);
elseif u.contour==1;
    delete(findobj(gca,'type','contour'));
    %g=rgb2gray(x);
    hold on
    [h hc]=contour(u.bg2d,u.contourlines);
    set(hc,'hittest','off');
else
    delete(findobj(gca,'type','contour'));
end
% % ---- contour
% if u.contour==1
%     delete(findobj(gca,'type','contour'));
%     %g=rgb2gray(x);
%     hold on
%     [h hc]=contour(bg2d,u.contourlines);
%    set(hc,'hittest','off');
% else
%    delete(findobj(gca,'type','contour'));
% end

% function (thresh_visible)

% ==============================================
%%  main:getSpecific Slice
% exmpl: [s]=aa_getslice_spec(u.az)
% ===============================================
function [s]=aa_getslice_spec(s)
hf1=findobj(0,'tag','xpainter');
s=getslice2d(s);
% ----------------------------------------------------
%% transpose
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    s=s';
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    s=flipud(s);
end
% ----------------------------------------------------





% ==============================================
%%  main:get slices
% ===============================================
function [r1 r2]=aa_getslice()
hf1=findobj(0,'tag','xpainter');
getImage();
global SLICE
r1=SLICE.r1;
r2=SLICE.r2;
% ----------------------------------------------------
%% transpose
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    %x=permute(r2, [2 1 3]);
    r1=r1';
    r2=r2';
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r1=flipud(r1);
    r2=flipud(r2);
end
% ----------------------------------------------------

% ==============================================
%%  main:push back slices
% ===============================================
function aa_setslice(r2)


r2n=r2;
hf1=findobj(0,'tag','xpainter');
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r2n=flipud(r2n);
end
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    r2n=r2n';
end
% ===============================================
%u.r2=r2n;
global SLICE
SLICE.r2=r2n;


putImage(); %######
u=get(gcf,'userdata');
%---make history
r2=getslice2d(u.b);
if sum(any(u.hist(:,:,u.histpointer)-r2))~=0
    u.histpointer=u.histpointer+1;
    u.hist(:,:,u.histpointer)=r2;
    u.hist(:,:,u.histpointer+1:end)=[]; %remove older stuff
    set(gcf,'userdata',u);
end
undo_redolabel_update();
% col=u.colmat(str2num(get(findobj(hf1,'tag','edvalue'),'string')),:);
% hd=findobj(gcf,'tag','dot');
% set(hd,'FaceColor',col,'edgecolor','k');
% set(hd,'userdata',0);

function blanko(e,e2)
%==================get================================================
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
[r1 r2]=aa_getslice();
%======================DO============================================
[x y]=ginput(1);
co=round([x y]);



aa_setslice(r2);
%==================update ================================================
hb=findobj(hf1,'tag','edvalue');
edvalue();
setslice([],1);





function patch_remove(e,e2)
hp=findobj(gcf,'tag','ROI');
v=get(hp,'userdata');
delete(v.hall);
try;          setfocus(gca);   end         % deFocus edit-fields

function patch_drag(e,e2)
hf1=findobj(0,'tag','xpainter');
hp=findobj(hf1,'tag','ROI');
hh=findobj(hf1,'tag','ROI_drag');
coFig=get(gcf,'CurrentPoint');
v=get(hp,'userdata');
% drag icon
pos=get(hh,'position');
posdrag=[ coFig(1:2)  pos(3:4) ];
set(hh,'position', posdrag);
posdiff=posdrag-pos;
posrot  =get(v.hs,'position');  set(v.hs  ,'position',posrot+posdiff );
posclear=get(v.hcl,'position'); set(v.hcl ,'position',posclear+posdiff );
% -------drag patch
co=get(gca,'CurrentPoint');
co=round(co(1,1:2));
% disp(co);
x=get(hp,'xdata');
y=get(hp,'ydata');
xm=mean(x);
ym=mean(y);
set(hp,'xdata',x-xm+co(1));
set(hp,'ydata',y-ym+co(2));
v.rotcent=[xm ym];
set(hp,'userdata',v);

function patch_fun(e,e2,task)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
hp=findobj(gcf,'tag','ROI');
v=get(hp,'userdata');
if strcmp(task,'cancel');
    delete(hp);
    delete(findobj(gcf,'tag','ROI_drag'));
elseif strcmp(task,'replicateROI') || strcmp(task,'replicateROI_allslices') || ...
        strcmp(task,'replaceROI')
    
    newID=1;
    if strcmp(task,'replicateROI')==1
        prompt = {[...
            'Assign ID (value) for ROI-child:                             ' char(10)  ...
            '   nan: use ID of "ROI-mother"' char(10) ...
            '   or enter a new numeric ID']};
        dlg_title = 'ROI-child ID';
        num_lines = 1;
        defaultans = {'nan'};
        answer = inputdlg2(prompt,dlg_title,num_lines,defaultans);
        if isempty(answer); return; end
        newID=str2num(answer{1});
        if isnan(newID);
            newID=v.id;%str2num(get(findobj(hf1,'tag','edvalue'),'string')) ;
        end
    elseif strcmp(task,'replaceROI')==1
      % newID =v.id;
    else
        % ==============================================
        %% input: distribute over slices
        % ===============================================
        prompt = {[...
            '\color{blue} Assign ID (value) for ROI-child:                \color{black}                                ' char(10)  ...
            '   nan: use ID of "ROI-mother"' char(10) ...
            '   or enter a new numeric ID']...
            ...
            [...
            '\color{blue}' ...
            'COPY ROI TO OTHER SLICES  '                   '\color[rgb]{0,0.5,0}' char(10)   ...
            ['      current Dim: ['  num2str(u.usedim)              ']']    ...
            ['      number of SLICES: ['  num2str(size(u.b,u.usedim))    ']']   ...
            ['      current SLICE: ['  num2str(u.useslice)            ']'] char(10)  ...
            ['\color{black}' ...
            'Enter slice number here: ' char(10)  ...
            'Examples:  [16], [1:3], [1 2 3 10:12]  ...without brackets' char(10)  ...
            'Examples:  [all], [1:2:end]  [end-3:end],   ...without brackets' char(10)  ...
            ' --> [all] refers to all slices: ' char(10)  ...
            ]
            ]
            };
        dlg_title = 'COPY ROI to other SLICES';
        num_lines = 1;
        defaultans = {'nan' 'all'};
        opts.Interpreter = 'tex';
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans,opts);
        if isempty(answer); return; end
        
        newID=str2num(answer{1});
        if isnan(newID);            newID=v.id; end   %str2num(get(findobj(hf1,'tag','edvalue'),'string')) ;
    
        nslices=size(u.b,u.usedim);
        allslices=1:nslices;
        if strcmp(answer{2},'all') ||strcmp(answer{2},'[all]')
            slices=1:nslices;
        else
            try
            eval(['slices=allslices([' answer{2} ']);']);
            catch
               return 
            end
        end
       
        % ==============================================
        %%
        % ===============================================
    end
    
    % % ==============================================
    %%   patch to mask
    % ===============================================
    
    x= (get(hp,'xdata'));
    y= (get(hp,'ydata'));
    xm=round(mean(x)); ym=round(mean(y));
    
    m=round(double(poly2mask(x,y,size(v.m,1),size(v.m,2))));
    %      fg,imagesc(m)
    
    if 0
        fg,imagesc(m*3+v.m*2)
        disp([sum(m(:)~=0)  sum(v.m(:)~=0)])
    end
    % ==============================================
    %%  solution for minimal accuracy in patch conversion    
    % ===============================================
    
% 
%     [r1 mr]=dftregistration(fft2(double(m)),fft2(double(v.m)));
%     mr= round(abs(ifft2(mr)));
% 
%     if 1
%         fg,
%         subplot(2,2,1); imagesc(m); title('fix')
%         subplot(2,2,2); imagesc(v.m); title('moving')
%         subplot(2,2,3); imagesc(mr); title('registered')
%         subplot(2,2,4); imagesc(mr-v.m); title('diff: registered-moving')
%      disp([sum(m(:)~=0)  sum(v.m(:)~=0)   sum(mr(:)~=0) ])
%     end
% 
% % ==============================================
% %%   
% % ===============================================
% 
%     %back
%     m=mr;
    
    % ==============================================
    %%
    % ===============================================

    if 0
        % ===============================================
        m=zeros(numel(v.m),1);
        x=round(get(hp,'xdata')); y=round(get(hp,'ydata'));
        idel=find(x<=0) ;       x(idel)=1;
        idel=find(y<=0) ;       y(idel)=1;
        idel=find(y>size(v.m,1)) ;       y(idel)=size(v.m,1);
        idel=find(x>size(v.m,2)) ;       x(idel)=size(v.m,2);
        ix=sub2ind(size(v.m),y,x);
        
        m(ix)=1;
        m=reshape(m,size(v.m));
        m=bwmorph(m,'bridge');
    end
    
    %      m0=padarray(m,[1 1],1,'both');
    %      %test=edge(I,'canny');
    %      m0 = imfill(m0,'holes');
    %      m0([1 end],:)=[]; m0(:,[1 end])=[];
    %       m=m0;
    
%     m=imfill(m,'holes');
    
    [r1 r2]=aa_getslice();
    if strcmp(task,'replaceROI')==1
        newID =v.id;
        r2(v.m==1)=0;
        r2(m==1)=newID;
        
    else
        
        r2(m==1)=newID;
        
    end
    
    
    
    %==================update ======
    aa_setslice(r2);
    hb=findobj(gcf,'tag','edvalue');
    edvalue();
    setslice([],1);
    delete(v.hall) ;  %delete(v.hp); delete(v.hdrag);
    
    % ==============================================
    %%   distribute patch over all/selected slices
    % ===============================================
    if strcmp(task,'replicateROI_allslices') || ...
            strcmp(task,'replicateROI_slicesviaInput')
        hb_edslice=findobj(gcf,'tag','edslice');
        thisSlice  =str2num(get(hb_edslice,'string'));
        
        hwait=findobj(gcf,'tag','waitnow');
        set(hwait,'visible','on','string','..wait..'); drawnow;
        
        
        for i=1:length(slices)
            sliceno=slices(i);
            
            u=get(gcf,'userdata');
            u.useslice=sliceno;
            set(gcf,'userdata',u);
            set(hb_edslice,'string',num2str(sliceno));
            [r1 r2]=aa_getslice();
            r2(m==1)=newID;
            
            
            r2n=r2;
            hf1=findobj(0,'tag','xpainter');
            if get(findobj(hf1,'tag','rd_flipud'),'value')==1
                r2n=flipud(r2n);
            end
            if get(findobj(hf1,'tag','rd_transpose'),'value')==1
                r2n=r2n';
            end
            % ===============================================
            %u.r2=r2n;
            global SLICE
            SLICE.r2=r2n;
            
            
            putImage(); %######
            
            %BACK
            [r1 r2]=aa_getslice();
            set(hb_edslice,'string',num2str(thisSlice));
            u=get(gcf,'userdata');
            
            u.bg2d =r1;
            u.useslice=thisSlice;
            set(gcf,'userdata',u);
            
        end
        set(hwait,'visible','off'); drawnow;
        
        return
        
        
        r2n=m;
        hf1=findobj(0,'tag','xpainter');
        if get(findobj(hf1,'tag','rd_flipud'),'value')==1
            r2n=flipud(r2n);
        end
        if get(findobj(hf1,'tag','rd_transpose'),'value')==1
            r2n=r2n';
        end
        
        u=get(hf1,'userdata');
        
        dum=u.hb;
        for i=1:length(slices)
            if u.usedim==1
               ds= dum(slices(i),:,:); ds(m==1)=newID;    dum(slices(i),:,:) =ds;
            elseif u.usedim==2
               ds= dum(:,slices(i),:);  ds(m==1)=newID;    dum(:,slices(i),:) =ds;
            elseif u.usedim==3
               ds= dum(:,:,slices(i)); ds=squeeze(ds);  ds(m==1)=newID;   dum(:,:,slices(i))  =ds;
            end
        end
        u.b=dum;
        set(hf1,'userdata',u);
        
        return
        
        
        ord=[setdiff([1:3],u.usedim)  u.usedim];
        d=permute(u.b, ord);
        
        
        for i=1:length(slices)
            ds=d(:,:,slices(i));
            ds(m==1)=newID;
            d(:,:,slices(i))=ds;
        end
        d2=permute(d, ord);
        u.b=d2;
        set(hf1,'userdata',u);
        
          
    end    
        
        
        
        
        
        
        
        
        
        
        
  
    
    return
elseif strcmp(task,'delete');
    [r1 r2]=aa_getslice();
    m=~v.m;
    r2=m.*r2;
    
    
    %==================update ======
    aa_setslice(r2);
    hb=findobj(gcf,'tag','edvalue');
    edvalue();
    setslice([],1);
    delete(v.hall) ;%delete(v.hp); delete(v.hdrag);
else
    
    
    
    keyboard
end


% ==============================================
%%   test
% ===============================================
function pb_patch(e,e2)
%==================get========
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');


%----clean up
delete(findobj(hf1,'tag','ROI'));
delete(findobj(hf1,'tag','ROI_drag'));
delete(findobj(hf1,'tag','ROI_rotate'));
delete(findobj(gcf,'tag','patch_remove'));
delete(findobj(gcf,'tag','ROI_rotateslider'));
% ------


[r1 r2]=aa_getslice();
%======================DO=======
% [x y]=ginput(1);
[x,y] = myginput(1,'crosshair');
mouseposfig=get(gcf,'CurrentPoint');
co=round([x y]);

id =r2(co(2),co(1));
if id==0
    msgbox('no ROI found at this position');
    return
end


idmask=r2==id;
cl =bwlabeln(idmask);
clid=cl(co(2),co(1));
m  =cl==clid;

m2 =bwperim(m);
% x=bwtraceboundary(m,[],'W',8,Inf,'counterclockwise')
[X,L] = bwboundaries(m2,'noholes');
% dum=X{1};
% xy=fliplr(dum);


if 1
    dum=[];
    for i=1:length(X)
        dum=[dum;X{i}];
    end
    xy=fliplr(dum);
    
end


% fg,imagesc(m2); hold on; plot(xy(:,1),xy(:,2),'m.'); zoom on;
% ==============================================
%%
% fg,imagesc(m2); hold on;
% h2=patch([20 50  50 20 ],[10 10 40 40],'g','facealpha',.8)
% h = impoly(gca,xy)

delete(findobj(gcf,'tag','ROI'));
hp=patch(xy(:,1),xy(:,2),'g','facealpha',.8,'tag','ROI');

%% dragg
handicon=[...
    129	129	129	129	129	129	129	0	0	129	129	129	129	129	129	129
    129	129	129	0	0	129	0	215	215	0	0	0	129	129	129	129
    129	129	0	215	215	0	0	215	215	0	215	215	0	129	129	129
    129	129	0	215	215	0	0	215	215	0	215	215	0	129	0	129
    129	129	129	0	215	215	0	215	215	0	215	215	0	0	215	0
    129	129	129	0	215	215	0	215	215	0	215	215	0	215	215	0
    129	0	0	129	0	215	215	215	215	215	215	215	0	215	215	0
    0	215	215	0	0	215	215	215	215	215	215	215	215	215	215	0
    0	215	215	215	0	215	215	215	215	215	215	215	215	215	0	129
    129	0	215	215	215	215	215	215	215	215	215	215	215	215	0	129
    129	129	0	215	215	215	215	215	215	215	215	215	215	215	0	129
    129	129	0	215	215	215	215	215	215	215	215	215	215	0	129	129
    129	129	129	0	215	215	215	215	215	215	215	215	215	0	129	129
    129	129	129	129	0	215	215	215	215	215	215	215	0	129	129	129
    129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129
    129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129];

handicon(handicon==handicon(1,1))=255;
if size(handicon,3)==1; handicon=repmat(handicon,[1 1 3]); end
handicon=double(handicon)/255;

delete(findobj(gcf,'tag','ROI_drag'));
h33=uicontrol('style','pushbutton','cdata',handicon,'backgroundcolor','w');
set(h33,'backgroundcolor','w');%,'callback',@slid_thresh)
set(h33,'units','pixels','position',[100 100 16 16]);
set(h33,'units','norm')
poshand=get(h33,'position');
poshand=[mouseposfig(1) mouseposfig(2) poshand(3:4)];
set(h33,'position',[mouseposfig(1) mouseposfig(2) poshand(3:4)]);
set(h33,'string','','tooltipstring','drag to move ROI ','tag','ROI_drag');
je = findjobj(h33); % hTable is the handle to the uitable object
set(je,'MouseDraggedCallback',@patch_drag  );

delete(findobj(gcf,'tag','patch_remove'));
hcl=uicontrol('style','pushbutton','backgroundcolor','w','string','x','callback',@patch_remove);
set(hcl,'units','norm');
posclear=[poshand(1) poshand(2)+poshand(4) poshand(3) poshand(4)];
set(hcl,'position',posclear);
set(hcl,'tooltipstring','cancel ..remove patch ','tag','patch_remove');

delete(findobj(gcf,'tag','ROI_rotateslider'));
hs=uicontrol('style','slider','backgroundcolor','w');%,'callback',@patch_rotate);
set(hs,'units','norm','value',0);
posslider=[poshand(1)+poshand(3) poshand(2) poshand(3)*3 poshand(4)];
set(hs,'position',posslider);
set(hs,'string','rr','tooltipstring','rotate ','tag','ROI_rotate');
addlistener(hs,'ContinuousValueChange',@patch_rotate);


c = uicontextmenu;
hs.UIContextMenu = c;

rotangles=[45:45:180  -45:-45:-180];
for i=1:length(rotangles)
    m1 = uimenu(c,'Label',['rotate ' num2str(rotangles(i)) '�'],...
        'Callback',{@patch_rotate_fixangle, num2str(rotangles(i))});
end
m1 = uimenu(c,'Label','rotate angle input','Callback',{@patch_rotate_fixangle,'input'});
m1 = uimenu(c,'Label','rotate to origin','Callback',{@patch_rotate_fixangle,'origin'},'separator','on');
m1 = uimenu(c,'Label','flip horizontally','Callback',{@patch_rotate_fixangle,'fliph'},'separator','on');
m1 = uimenu(c,'Label','flip vertically','Callback',{@patch_rotate_fixangle,'flipv'});

v.inf1='--handles----';
v.hp   =hp;
v.hdrag=h33;
v.hs   =hs;
v.hcl  =hcl;
v.hall=[v.hp v.hdrag v.hs v.hcl];
v.inf2='------';
v.m  =m;
v.xy =xy;
v.id =id;
v.mouseposfig=mouseposfig;

x=get(hp,'xdata');
y=get(hp,'ydata');
xm=mean(x);
ym=mean(y);
v.rotcent=[xm ym];
set(hp,'userdata',v);
% ==============================================
c = uicontextmenu;
hp.UIContextMenu = c;
% m1 = uimenu(c,'Label','cancel & close patch','Callback',{@patch_fun,'cancel'});
m1 = uimenu(c,'Label','copy ROI (move ROI first..)','Callback',{@patch_fun,'replicateROI'});
m1 = uimenu(c,'Label','replace ROI (move ROI first..)','Callback',{@patch_fun,'replaceROI'});
m1 = uimenu(c,'Label','delete ROI-mother from slice','Callback',{@patch_fun,'delete'});
m1 = uimenu(c,'Label','copy ROI to other slices','Callback',{@patch_fun,'replicateROI_allslices'},'separator','on');
% m1 = uimenu(c,'Label','copy to all slices','Callback',{@patch_fun,'replicateROI_slicesviaInput'},'separator','off');

v.hdrag.UIContextMenu = c;


function patch_rotate_fixangle(e,e2,task )
hp=findobj(gcf,'tag','ROI');
v=get(hp,'userdata');
slidval=get(v.hs,'value');

ang=str2num(task);
if isempty(ang)
    if strcmp(task,'input')
        prompt = {[...
            'Enter single rotation angle.                            ' char(10)  ...
            ' Example: 90, -90, 270 etc' char(10) '']};
        dlg_title = 'rotation angle';
        num_lines = 1;
        defaultans = {'180'};
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
        ang=str2num(answer{1});
        if isnan(ang);
            return
        end
    elseif strcmp(task,'fliph')
        x = get(hp, 'XData');
        x2 = max(x) - x + min(x);
        set(hp, 'XData', x2);
        return
    elseif strcmp(task,'flipv')
        y = get(hp, 'YData');
        y2 = max(y) - y + min(y);
        set(hp, 'YData', y2);
        return
    end
end

stp=ang/360;
newslidval=slidval+stp;
if newslidval>1;       newslidval=mod(newslidval,1);   end
if newslidval<0;       newslidval=mod(newslidval,1);   end

if  strcmp(task,'origin') ==1
    set(v.hs,'value',0);
else
    set(v.hs,'value',newslidval);
end
patch_rotate([],[]);


function patch_rotate(e,e2)                              %'ROTATION'
hf1=findobj(0,'tag','xpainter');
hp=findobj(hf1,'tag','ROI');
v=get(hp,'userdata');
hs=findobj(gcf,'tag','ROI_rotate');
val=get(hs,'value');
rotangle=val*360;
set(hs,'sliderstep',[0.00500 0.05000] ); %[0.0100 0.1000]
x=round(get(hp,'xdata')); y=round(get(hp,'ydata'));
xm=round(mean(x)); ym=round(mean(y));
w=get(hs,'userdata');
if isempty(w)
    w.xm=[xm];  w.ym=[ym];
    w.newrot=0;
    w.lastrot=0;
    w.xdata=get(hp,'xdata');
    w.ydata=get(hp,'ydata');
    w.zdata=get(hp,'zdata');
    w.Vertices=get(hp,'Vertices');
    set(hs,'userdata',w);
    drawnow;
end
if w.lastrot==w.newrot
    w.newrot=rotangle;
end
rot=w.newrot-w.lastrot;
w.lastrot=w.newrot;
w.newrot =rotangle;
set(hs,'userdata',w);
rotate(hp,[0 0 1],rot,[v.rotcent 0]);
drawnow;





% ==============================================
%%   keepclusterinSlice: remove cluster by table
% ===============================================
function keepclusterinSlice(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
[r1 r2]=aa_getslice();
% r2(1:4,1:4)=1;


ids=unique(r2(:)); ids(ids==0)=[];
if isempty(ids)
   msgbox('no ROIs found in this slice');
    return
end
tb=[];
for i=1:(length(ids))
    rm=r2==ids(i);
    cl=bwlabel(rm);
    uni=unique(cl(:)); uni(uni==0)=[];
    tbid=flipud(sortrows([ones(length(uni),1)*ids(i)   histc(cl(:),uni)],2));
    tb=[tb; tbid];
end

% ==============================================
%%   selection via table
% ===============================================

msg='Select ROI(s) to keep. Non-selected will be removed from slice.';
idtab=idlistTable(tb,msg,0,2);
if isempty(idtab)==1; return; end

idtab(idtab(:,1)==0,:)=[];
m2=zeros(size(r2));
selid=unique(idtab(:,2));
for i=1:length(selid) 
    thisID=selid(i);
    rm=r2==thisID;
    cl=bwlabel(rm);
    uni=unique(cl(:)); uni(uni==0)=[];
    tbid=flipud(sortrows([uni   histc(cl(:),uni)],2));
    
    tz=idtab(idtab(:,2)==selid(i),2:3);
    for j=1:size(tz,1)
        cnum=tbid((tbid(:,2)==tz(j,2)),1);
        for k=1:length(cnum)
            m2(cl==cnum(k))=thisID;
        end
    end
end

if 0
    fg;
    subplot(2,2,1); imagesc(r2); title('in');
    subplot(2,2,2); imagesc(m2);    title('selected');
    subplot(2,2,3); imagesc(r2-m2); title('diff');
end
% ==============================================
%%   update IDlist 
% ===============================================
% ------------- -------------

r2=m2;
aa_setslice(r2);

hb=findobj(hf1,'tag','edvalue');
% set(hb,'string', num2str(newID));
edvalue();
setslice([],1);

% ==============================================
%%   test
% ===============================================
function rb_changeID(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
[r1 r2]=aa_getslice();
% r2(1:4,1:4)=1;

%===================================================================================================
[x y]=ginput(1);
co=round([x y]);

prompt = {[...
    'Here you can assign a new ID (value) for the selected region:' char(10)  ...
    '   nan: use current selected ID (from listbox)' char(10) ...
    '   or enter a new numeric ID']};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'nan'};
answer = inputdlg2(prompt,dlg_title,num_lines,defaultans);
if isempty(answer); return; end
newID=str2num(answer{1});
if isnan(newID);
    newID=str2num(get(findobj(hf1,'tag','edvalue'),'string')) ;
end

oldID=r2(co(2),co(1));
m1=r2==oldID;
cl=bwlabel(m1);
clustnum=cl(round(co(2)),round(co(1))  );
cl2=cl==clustnum;
m2=cl2;
m3=r2;
m3(m2)=newID;
r2=m3;
aa_setslice(r2);
%===================================================================================================
% ------------- update IDlist -------------
hb=findobj(hf1,'tag','edvalue');
set(hb,'string', num2str(newID));
edvalue();
setslice([],1);

% fg,imagesc(r2);
return
% ==============================================
%%   close and fill
% ===============================================
function rb_closeAndFill(e,e2)


hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
[r1 r2]=aa_getslice();
if sum(r2(:))==0
    disp(['r2 is empty']);
end
% fg,imagesc(r2);
%===================================================================================================
[x y]=ginput(1);
xy0=fliplr(round([x y]));
xy=(xy0);

val=r2(xy(1),xy(2));
if val==0 % get nearest value
    [x1 y1]=find(  r2~=0);
    cp=[x1 y1];
    cp2=[round(xy(1)),round(xy(2))];
    dist=sqrt(sum((cp-repmat(cp2,[size(cp,1) 1])).^2,2));
    imin=min(find(dist==min(dist)));
    xy=cp(imin,:);
    val=r2(xy(1),xy(2));
end
newID=  val;

% -----1
% u1=r2>0;
% u2=imclose(u1,strel('disk',5));
% % u3=u2-u1;
% u3=imfill(u1+u2,'holes');
%
% % % -----2
% u1=r2==val;
% u2=imclose(r2,strel('disk',10));
% u3=u1+u2;
% u3=imfill(u3);

hdot=findobj(gca,'tag','dot');
xd=get(hdot,'xdata');
yd=get(hdot,'ydata');
dotsi=max([max(xd)-min(xd) max(yd)-min(yd)]);


% ==============================================
%%   
% ===============================================
doRun=1;
maxi=20;
i=0;
while doRun==1 && i<maxi
    
    i=i+1;
%     disp(i);
    u1=r2==val;
    npad=20;
    uc=padarray(r2,[npad npad]);
    uc=imclose(uc,strel('disk',i));
    u2=uc(npad+1:end-npad,npad+1:end-npad);
    %fg;imagesc(u2); title(i)
    
    % u4=u3==num;
    % cl=bwlabeln(u2,4);
    cl=u2;
    clustnum=cl(xy0(1),xy0(2)  );
    cl2=cl==clustnum;
    m2=cl2;
     %fg;imagesc(m2); title(i)
     
     
    
    cl=bwlabeln(m2,4);
    clustnum=cl(xy0(1),xy0(2)  );
    cl2=cl==clustnum;
    m3=cl2;
     
    val_inROI=m3(xy0(1),xy0(2));
    val_edge =[m3(1,1) m3(1,end)  m3(end,1) m3(end,end)];
    %disp( [ i nan val_inROI val_edge] );
    
    
    if mode(val_edge)~=val_inROI
       doRun=0; 
    end

%     fg;imagesc(m3); title(i);
%    'a'
    
    
end
if 0
    fg;imagesc(m3); title(i);
    fg;imagesc(w1); title(i);
end

w1=r2>0;

m4=imclose(m3-w1,strel('disk',2));
% cl=bwlabeln(m4,4);
cl=m4;
clustnum=cl(xy0(1),xy0(2)  );
m5=cl==clustnum;

val_edge =[m5(1,1) m5(1,end)  m5(end,1) m5(end,end)];
if mode(val_edge) ==1
%    'return'
   return
end

% ==============================================
%%   
% ===============================================
 mout=r2;
 mout(m5==1)=newID;
% fg;imagesc(mout); 

% % =========BACK=====================================
aa_setslice(mout);
%update IDlist
hb=findobj(hf1,'tag','edvalue');
set(hb,'string', num2str(newID))
edvalue();
setslice([],1);


% % % % % ==============================================
% % % % %%   old
% % % % % ===============================================
% % % % 
% % % % % ------
% % % % % u2=imclose(r2,strel('disk',5));
% % % % v1=bwmorph(u2,'skel',Inf); %#####
% % % % v1=u2;
% % % % % v2=imdilate(v1, strel('disk',1));
% % % % v2=v1;
% % % % v3=(v2+r2)>0;
% % % % 
% % % % % v1=(bwmorph(u2,'skel',Inf)+r2)>0;
% % % % u3=~v3;
% % % % 
% % % % 
% % % % 
% % % % num=u3(xy0(1),xy0(2)  );
% % % % u4=u3==num;
% % % % cl=bwlabeln(u4,4);
% % % % clustnum=cl(xy0(1),xy0(2)  );
% % % % cl2=cl==clustnum;
% % % % m2=cl2;
% % % % m2=imclose(cl2,strel('disk',1)); %remove antiskel
% % % % m2=imfill(m2,'holes');
% % % % %  fg,imagesc(m2)
% % % % 
% % % % newID=  val;
% % % % m3=r2;
% % % % m3(m2)=newID;
% % % % 
% % % % % fg,imagesc(m3);
% % % % 
% % % % % fg,imagesc(r2)
% % % % 
% % % % % 's'
% % % % % other option: bo=boundarymask(r2);
% % % % 
% % % % % return
% % % % aa_setslice(mout);
% % % % %update IDlist
% % % % hb=findobj(hf1,'tag','edvalue');
% % % % set(hb,'string', num2str(newID))
% % % % edvalue();
% % % % setslice([],1);
% % % % 
% % % % 
% % % % 
% % % % 
% % % % % ==============================================
% % % % %%
% % % % % ===============================================






function slid_thresh_flt(e,e2)
% set(e2,'enable','off');
% drawnow;
% pause(.3);
% set(e2,'enable','on');
% drawnow
% pause(.3);
% figure(gcf);
slid_thresh();
try;          setfocus(gca);   end         % deFocus edit-fields

% set(e,'enable','off');
% drawnow;
% pause(.3);
% set(e,'enable','on');
% drawnow
% pause(.3);

% 
% jPeer = get(handle(gcf), 'JavaFrame');
% jPeer.getAxisComponent.requestFocus

function slid_thresh_ed(e,e2)

he=findobj(gcf,'tag','slid_thresh_ed');
val    =str2num(get(he,'string'));
hs=findobj(gcf,'tag','slid_thresh'); 
set(hs,'value',val);
slid_thresh([],[]);

function slid_thresh(e,e2)
warning off
u=get(gcf,'userdata');
hs=findobj(gcf,'tag','slid_thresh');              val    =get(hs,'value');
hm=findobj(gcf,'tag','thresh_medfilt');           doflt  =get(hm,'value');
hml=findobj(gcf,'tag','thresh_medfiltlength');    fltLen =str2num(get(hml,'string'));

str=get(hs,'tooltipstring');
str=[regexprep(str,[ char(10)  '#.*$' ],'') char(10) '# value: ' num2str(val) ];
set(hs,'tooltipstring',str);

he=findobj(gcf,'tag','slid_thresh_ed');   set(he,'string', num2str(val)) ;


hv=findobj(gcf,'tag','thresh_visible');           visible  =get(hv,'value');

if visible==1
    set(findobj(gcf,'tag','rd_contourdraw'),'value',0);
    x0=u.bg2d;
    if doflt==1
        x0=medfilt2(x0,[fltLen fltLen ],'symmetric');
    end
    x=x0>(1-val);%reversed
    % x=x0>val; older 
    x([1 end],:)=0; x(:,[1 end])=0; %border
    c=contourc(double(x),1);
    set(hs,'userdata',c);
    
    hold on
    delete(findobj(gca,'type','contour'));
    try
        [hc ]=contour(x,1,'r','hittest','off','color',u.threshcolor,'linewidth',u.threshLineWidth,...
            'SelectionHighlight','off');
    end
else
    delete(findobj(gca,'type','contour'));
end

set(hs, 'Enable', 'off');
drawnow;
set(hs, 'Enable', 'on');

% 2446
function pan2_dragCB(e,e2)
hf1=findobj(0,'tag','xpainter');
hp=findobj(hf1,'tag','panel2');
co=get(gcf,'CurrentPoint');
% disp(co);
set(hp,'units','normalized');
pos=get(hp,'position');

v=get(hp,'userdata');
v.unn=pos;
set(hp,'userdata',v);

set(hp,'position', [ co(1) co(2)-pos(4)  pos(3:4) ]);
set(hp,'units','pixels');

function thresh_dragCB(e,e2)

hf1=findobj(0,'tag','xpainter');
hp=findobj(hf1,'tag','panel3');
co=get(gcf,'CurrentPoint');
% disp(co);
set(hp,'units','normalized');
pos=get(hp,'position');
set(hp,'position', [ co(1:2)  pos(3:4) ]);
set(hp,'units','pixels');


function thresh_context(e,e2,task)

if strcmp(task,'color')
    u=get(gcf,'userdata');
    u.threshcolor=uisetcolor(u.threshcolor,'contour color (threshold)');
    set(gcf,'userdata',u);
    slid_thresh([],[]);
elseif strcmp(task,'linewidth')
    %% ===============================================
    u=get(gcf,'userdata');
    prompt={'enter linewidth:'};
    name='linewidht';
    numlines=1;
    defaultanswer={'1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if ~isempty(str2num(answer{1}))
        u.threshLineWidth=str2num(answer{1});
    end
    set(gcf,'userdata',u);
    slid_thresh([],[]);
   %% ===============================================
   
end


% ==============================================
%% make fig
% ===============================================

function makegui
u=get(gcf,'userdata');
u.ax=axes('units','norm','position',[0 0 .8 .8]);



% infobox
hb=uicontrol('style','text','units','norm', 'tag'  ,'infobox');             %CHANGE-DIM
set(hb,'position',[ .01 0.01 .2 .06],'string','',...{'infobox' 'dd'},...
    'backgroundcolor','k','foregroundcolor',[0.9294    0.6941    0.1255],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold');
set(hb,'visible','on');

if 1
    jPanel =findjobj(hb);% hb.JavaFrame.getPrintableComponent;  % hPanel is the Matlab handle to the uipanel
    jPanel.setOpaque(false)
    jPanel.getParent.setOpaque(false)
    jPanel.repaint
end

% ==============================================
%%    PANEL-3 (contour)
% ===============================================

pan3 = uipanel('Title','contour','FontSize',7,'units','norm', 'BackgroundColor','white',  'Position',[0 0 .5 .3]);
set(pan3,'Position',[.2 0 .55 .05],'Title','','tag','panel3','visible','on','backgroundcolor','w');
set(pan3,'units','pixels','visible','on');
set(pan3,'BorderType','etchedout','shadowColor',[1 0 0]);
set(pan3,'BorderType','etchedout','BackgroundColor',[1 1 1]);
% jPanel = pan3.JavaFrame.getPrintableComponent;  % hPanel is the Matlab handle to the uipanel
% jPanel.setOpaque(false)
% jPanel.getParent.setOpaque(false)
% jPanel.getComponent(0).setOpaque(false)
% jPanel.repaint

%==========================================================================================
%% dragg
handicon=[...
    129	129	129	129	129	129	129	0	0	129	129	129	129	129	129	129
    129	129	129	0	0	129	0	215	215	0	0	0	129	129	129	129
    129	129	0	215	215	0	0	215	215	0	215	215	0	129	129	129
    129	129	0	215	215	0	0	215	215	0	215	215	0	129	0	129
    129	129	129	0	215	215	0	215	215	0	215	215	0	0	215	0
    129	129	129	0	215	215	0	215	215	0	215	215	0	215	215	0
    129	0	0	129	0	215	215	215	215	215	215	215	0	215	215	0
    0	215	215	0	0	215	215	215	215	215	215	215	215	215	215	0
    0	215	215	215	0	215	215	215	215	215	215	215	215	215	0	129
    129	0	215	215	215	215	215	215	215	215	215	215	215	215	0	129
    129	129	0	215	215	215	215	215	215	215	215	215	215	215	0	129
    129	129	0	215	215	215	215	215	215	215	215	215	215	0	129	129
    129	129	129	0	215	215	215	215	215	215	215	215	215	0	129	129
    129	129	129	129	0	215	215	215	215	215	215	215	0	129	129	129
    129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129
    129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129];

handicon(handicon==handicon(1,1))=255;
if size(handicon,3)==1; handicon=repmat(handicon,[1 1 3]); end
handicon=double(handicon)/255;

h33=uicontrol('style','pushbutton','cdata',handicon);
set(h33,'parent',pan3,'backgroundcolor','w');%,'callback',@slid_thresh)
set(h33,'units','norm','position',[-.01 -.01 .1 .98]);
set(h33,'string','','tooltipstring','drag panel to another position ','tag','thresh_drag');
je = findjobj(h33); % hTable is the handle to the uitable object
set(je,'MouseDraggedCallback',@thresh_dragCB  );
set(hb,'units','pixels'); set(hb,'position',[  -1     1    22    17]);

%% visible
hb=uicontrol('style','checkbox','units','norm', 'tag' ,'thresh_visible','fontsize',7);             %CHANGE-DIM
set(hb,'position',[ .25  .9 .05 .041],'string','vis','backgroundcolor','w');
set(hb,'tooltipstring',['show/hide contour' char(10) ' ..use context menu to change color']);
set(hb,'parent',pan3,'callback',@slid_thresh);
set(hb,'position',[ .1  .0 .13 1],'value',1);
set(hb,'units','pixels'); set(hb,'position',[ 23 1 28.6 17]);

c = uicontextmenu;
hb.UIContextMenu = c;
% Create menu items for the uicontextmenu
m1 = uimenu(c,'Label','change color'    ,'Callback',{@thresh_context,'color'});
m1 = uimenu(c,'Label','change linewidht','Callback',{@thresh_context,'linewidth'});
% m1 = uimenu(c,'Label','assign another ID','Callback',{@idlist_contextmenu,'reassignID'});



%% - slider thresh
hb=uicontrol('style','slider','units','norm', 'tag'  ,'slid_thresh','fontsize',8);             %CHANGE-DIM
set(hb,'position',[ .25  .9 .05 .041],'string','rw','value',0.5,'backgroundcolor','w');
set(hb,'tooltipstring',['change contour threshold intensity' char(10) ' shortcut [shift+left/right arrow]']);
set(hb,'parent',pan3);
set(hb,'position',[ .385  .0 .43 1]);
addlistener(hb,'ContinuousValueChange',@slid_thresh);
set(hb,'units','pixels'); set(hb,'position',[ 86     1    95    17]);

%% - slid_thresh_ed
hb=uicontrol('style','edit','units','norm', 'tag'  ,'slid_thresh_ed','fontsize',6);             %CHANGE-DIM
set(hb,'position',[ .25  .9 .05 .041],'string','0.5','backgroundcolor','w');
set(hb,'tooltipstring',['enter value {range: 0-1} to change contour threshold intensity' char(10) ' shortcut [shift+left/right arrow]']);
set(hb,'parent',pan3);
set(hb,'position',[ .235  .0 .15 1]);
set(hb,'callback',@slid_thresh_ed);
set(hb,'visible','off');
set(hb,'units','pixels'); set(hb,'position',[ 53     1    33    17]);

%% ADDborder
hb=uicontrol('style','pushbutton');
set(hb,'parent',pan3,'backgroundcolor','w');%,'callback',@slid_thresh)
set(hb,'units','norm','position',[0.223 -0.0394 0.07 0.7]);
set(hb,'string','aB','tag','addBorder');
set(hb,'fontsize',6,'fontweight','bold');
set(hb,'tooltipstring',['add Borders' char(10) 'click to draw borders for contour-line function ']);
set(hb,'callback',@borderAdd);
set(hb,'units','pixels'); set(hb,'position',[ 50     0    15    12]);

%% DELborder
hb=uicontrol('style','pushbutton');
set(hb,'parent',pan3,'backgroundcolor','w');%,'callback',@slid_thresh)
set(hb,'units','norm','position',[0.3035 -0.0324 0.07 0.7]);
set(hb,'string','dB','tag','delBorder');
set(hb,'fontsize',6,'fontweight','bold');
set(hb,'tooltipstring',['add Borders' char(10) 'click to remove all borders of contour-line function '])
set(hb,'callback',@borderDel);
set(hb,'units','pixels'); set(hb,'position',[ 68     0    15    12]);


%% thresh_medfilt
hb=uicontrol('style','radio','units','norm', 'tag' ,'thresh_medfilt','fontsize',7);             %CHANGE-DIM
set(hb,'position',[ .25  .9 .05 .041],'string','F','backgroundcolor','w');
set(hb,'tooltipstring',['median filter' char(10) ''],'value',1);
set(hb,'parent',pan3,'callback',@slid_thresh);
set(hb,'position',[ .82  .0 .15 1]);
set(hb,'units','pixels'); set(hb,'position',[ 181     1    33    17  ]);

%% thresh_medfilt-value
hb=uicontrol('style','edit','units','norm', 'tag' ,'thresh_medfiltlength','fontsize',7);             %CHANGE-DIM
set(hb,'position',[ .25  .9 .05 .041],'string','3','backgroundcolor','w');
set(hb,'tooltipstring',['median filter length' char(10) '']);
set(hb,'parent',pan3,'callback',@slid_thresh_flt);
% set(hb,'position',[ .25  .45 .05 .041]); %PAN1
set(hb,'position',[ .93  .0 .07 1]);
set(hb,'units','pixels'); set(hb,'position',[ 206     1    15    17]);


%% fill interior contours
hb=uicontrol('style','radio');
set(hb,'parent',pan3,'backgroundcolor','w');%,'callback',@slid_thresh)
% set(hb,'units','norm','position',[0.223 -0.0394 0.08 0.8]);
set(hb,'string','fill','tag','fillcontourlines');
set(hb,'fontsize',6,'backgroundcolor','w');
set(hb,'tooltipstring',[ 'fill interour contourlines'],'value',1);
% set(hb,'callback',@contourhelp);
set(hb,'units','pixels'); set(hb,'position',[266.65 1.8 30 15]);

%% help
hb=uicontrol('style','pushbutton');
set(hb,'parent',pan3,'backgroundcolor','w');%,'callback',@slid_thresh)
% set(hb,'units','norm','position',[0.223 -0.0394 0.08 0.8]);
set(hb,'string','?','tag','contourhelp');
set(hb,'fontsize',8,'fontweight','bold','backgroundcolor',[1 .84 0]);
set(hb,'tooltipstring',['get help ' char(10) 'how to use contourlines to draw mask/roi']);
set(hb,'callback',@contourhelp);
set(hb,'units','pixels'); set(hb,'position',[290.15 1.35 15 15]);


% ==============================================
%%   PANEL-1
% ===============================================
pan1 = uipanel('Title','Main Panel','FontSize',7,'units','norm', 'BackgroundColor','white',  'Position',[0 0 .5 .3]);
set(pan1,'Position',[0 .9 1 .1],'Title','','tag','panel1','visible','on','backgroundcolor','w');
set(pan1,'units','pixels','visible','on');

%==========================================================================================
%-----CHANGE DIM
str={'1' ,'2' '3'};
hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'rd_changedim');             %CHANGE-DIM
set(hb,'position',[ .25  .9 .05 .041],'string',str,'value',3,'backgroundcolor','w');
set(hb,'callback',{@pop_changedim});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['change viewing dimension' ]);
set(hb,'parent',pan1);
set(hb,'position',[ .25  .45 .05 .041]); %PAN1
%=============WHICH SLICE=============================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'prev');           %SETL-prev-SLICE
set(hb,'position',[ .35 .9 .05 .04],'string',char(8592), 'callback',{@cb_setslice,'-1'});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['view previous slice' char(10) '[left-arrow] shortcut' ]);
set(hb,'parent',pan1);
set(hb,'position',[ .35  .05 .05 .41]); %PAN1

hb=uicontrol('style','edit','units','norm', 'tag'  ,'edslice');           %EDIT-SLICE
set(hb,'position',[ .4 .9 .05 .04],'string','##','callback',{@cb_setslice,'ed'});
set(hb,'fontsize',8);
set(hb,'tooltipstring','select slice number to view');
set(hb,'parent',pan1);
set(hb,'position',[ .35+.05*1  .05 .05 .41]); %PAN1

set(hb,'parent',pan1);
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'next');           %SET-next-SLICE
set(hb,'position',[ .45 .9 .05 .04],'string',char(8594),'callback',{@cb_setslice,'+1'});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['view next slice' char(10) '[right-arrow] shortcut' ]);
set(hb,'parent',pan1);
set(hb,'position',[ .35+.05*2  .05 .05 .41]); %PAN1


%==========================================================================================

%transpose image
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_transpose','value',0);
set(hb,'position',[ .12 .95 .08 .04],'string','transpose','callback',{@rd_transpose});
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','normal');
set(hb,'tooltipstring',['transpose image']);
set(hb,'position',[ .5 .9 .8 .04]);
set(hb,'parent',pan1);
set(hb,'position',[ .35+.05*3  .05 .05*2 .41]); %PAN1

%flipud image
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_flipud','value',0);
set(hb,'position',[ .12 .95 .08 .04],'string','flipud','callback',{@rd_flipud});
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','normal');
set(hb,'tooltipstring',['flip up-down image']);
set(hb,'position',[ .58 .9 .08 .04]);
set(hb,'parent',pan1);
set(hb,'position',[ .35+.05*5  .05 .05*2 .41]); %PAN1
%==========================================================================================

%axis normal/image
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_axisnormal','value',1);
set(hb,'position',[ .12 .95 .08 .04],'string','ax normal','callback',{@rd_axisnormal});
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','normal');
set(hb,'tooltipstring',['axis layout: [0] normal, [1] image']);
% set(hb,'position',[ .58 .9 .08 .04]);
set(hb,'parent',pan1);
set(hb,'position',[0.5 0.501 0.1 0.41]); %PAN1

%==========================================================================================
% panel on top
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_sliceBelowPan1','value',0);
set(hb,'position',[ .12 .95 .08 .04],'string','on top','callback',{@rd_sliceBelowPan1});
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','normal','value',1);
set(hb,'tooltipstring',[...
    'layout: slice & upper panel ' char(10) ...
    '[1]upper panel on top of slice' char(10) ...
    '[1]upper panel and slice side by side' char(10) ...
    ]);
% set(hb,'position',[ .58 .9 .08 .04]);
set(hb,'parent',pan1);
set(hb,'position',[0.928 -0.0074 0.1 0.41]); %PAN1
%==========================================================================================
%-----dotType
str={'dot' ,'square' 'hline' 'vline'};
hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'rd_dottype');
set(hb,'position',[ .001  .9 .12 .04],'string',str,'value',1,'backgroundcolor','w');
set(hb,'callback',{@rd_dottype});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['paint brush type' char(10) '[p] shortcut to alternate between brush types']);
set(hb,'parent',pan1);
set(hb,'position',[ 0 .08 .12 .41]); %PAN1

% DOT-SIZE
hb=uicontrol('style','popupmenu','string',{'dotsize'},'value',1,'units','norm','tag','dotsize');
set(hb,'position',[.1  .9 .075 .04],'backgroundcolor','w','tooltipstring','disksize (diameter)');
set(hb,'callback',@definedot);
set(hb,'fontsize',8);
set(hb,'tooltipstring',['brush size' char(10) '[up/down arrow] to change brush size' ]);
set(hb,'parent',pan1);
set(hb,'position',[ 0.12 .08 .1 .41]); %PAN1
%==========================================================================================

% % % % % 
% % % % % % unpaint
% % % % % hb=uicontrol('style','togglebutton','string','unpaint','units','norm','value',0);
% % % % % set(hb,'position',[.32  .95 .15 .06],'backgroundcolor','w');
% % % % % set(hb,'callback',@undo,'tag','undo');
% % % % % set(hb,'fontsize',8);
% % % % % set(hb,'tooltipstring',['un-paint location' char(10) '[u] shortcut' ]);
% % % % % set(hb,'parent',pan1);
% % % % % set(hb,'position',[ 0.36 .5 .05*3 .6]); %PAN1

%==========================================================================================
% 
% % previois/last step
% %==========================================================================================
% % LAST-STEP
% hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_prevstep');
% set(hb,'position',[ .52 .95 .05 .04],'string',' ', 'callback',{@pb_undoredo,-1});
% set(hb,'fontsize',7,'backgroundcolor','w');
% set(hb,'tooltipstring',['UNDO last step' char(10) '..for this slice only' char(10) 'shortcut [ctrl+x] ' ]);
% e = which('undo.gif');
% %    if ~isempty(regexpi(e,'.gif$'))
% [e map]=imread(e);e=ind2rgb(e,map);
% set(hb,'cdata', e);
% set(hb,'parent',pan1);
% set(hb,'position',[ 0.52 .48 .05 .5]); %PAN1
% 
% % NEXT-STEP
% hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_nextstep');
% set(hb,'position',[ .56 .95 .05 .04],'string',' ', 'callback',{@pb_undoredo,+1});
% set(hb,'fontsize',7,'backgroundcolor','w');
% set(hb,'tooltipstring',['REDO last step' char(10) '..for this slice only' char(10) 'shortcut [ctrl+y] ']);
% set(hb,'cdata', flipdim(e,2));
% set(hb,'parent',pan1);
% set(hb,'position',[ 0.57 .48 .05 .5]); %PAN1
% 
% 
% % do/redo-label
% hb=uicontrol('style','text','units','norm', 'tag'  ,'pb_undoredo_label');
% set(hb,'position',[ .6 .95 .1 .035],'string','Hist: 1/10','horizontalalignment','left');
% set(hb,'fontsize',7,'backgroundcolor','w');
% set(hb,'tooltipstring',['undo/redo step']);
% set(hb,'parent',pan1);
% set(hb,'position',[ 0.62 .48 .1 .4]); %PAN1

%==========================================================================================
%TRANSPARENCY
hb=uicontrol('style','edit','units','norm', 'tag'  ,'edalpha');
set(hb,'position',[ .65 .9 .05 .04],'string','##','callback',{@edalpha});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['set transparency {value between 0 and 1}' ]);
set(hb,'parent',pan1);
set(hb,'position',[ .701  .05 .05*1 .41]); %PAN1
%==========================================================================================
% % % % %HIDE
% % % % hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'preview');
% % % % set(hb,'position',[ .7 .9 .1 .04],'string','hide mask', 'callback',{@cb_preview});
% % % % set(hb,'fontsize',8);
% % % % set(hb,'tooltipstring',['shortly hide mask' char(10) '[h] shortcut']);
% % % % set(hb,'parent',pan1);
% % % % set(hb,'position',[ 0.85 .05 .05*3 .41]); %PAN1


%==========================================================================================
%legend
hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'pb_legend','value',0);
set(hb,'position',[ .7 .95 .1 .04],'string','legend', 'callback',{@pb_legend});
set(hb,'fontsize',7,'backgroundcolor','w');
set(hb,'tooltipstring',['show legend' char(10) '[l] shortcut']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.7 .48 .05*1.8 .5]); %PAN1

%slicewise info
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_slicewiseInfo');
set(hb,'position',[ .8 .95 .03 .04],'string','i', 'callback',{@pb_slicewiseInfo});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['show  volume/mask info and slice-wise info' char(10) 'shortcut [i]']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.79 .48 .035 .5]); %PAN1

%overlay-mask all slices
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_show_allslices');
set(hb,'position',[ .83 .95 .03 .04],'string','M', 'callback',{@show_allslices});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['montage: show all slices of bg-image and mask' char(10) 'shortcut [m]']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.825 .48 .035 .5]); %PAN1


%=========OTSU=================================================================================

%otsu -button
hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'pb_otsu','value',0);
set(hb,'position',[ .0 .95 .08 .04],'string','otsu', 'callback',{@pb_otsu,1});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['otsu thresholding ' char(10) '[o] shortcut']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.0 .52 .07 .45]); %PAN1

%otsu-3d -button
hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'pb_otsu3D','value',0);
set(hb,'position',[ .08 .95 .08 .04],'string','otsu3D', 'callback',@pb_otsu3D);
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['otsu-3D thresholding ' char(10) '--']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.07 .52 .07 .45]); %PAN1


%threshtool
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_Treshtool','value',0);
set(hb,'position',[ .08 .95 .08 .04],'string','TreshT.', 'callback',@pb_Treshtool);
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['Threshhold Tool ' char(10) '[#] shortcurt']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.14 .52 .07 .45]); %PAN1


%3d-otsu
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_otsu3d','value',0);
set(hb,'position',[ .18 .95 .08 .04],'string','3dotsu','callback',{@pb_otsu,1});
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['[]2d vs [x]3d otsu' char(10) '']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.14 .52 .08 .45],'visible','off'); %PAN1

%link otsu
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_otsu');
set(hb,'position',[ .2 .95 .08 .04],'string','link');
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['link otsu : always perform otsu when changing the slice number' char(10) '']);
set(hb,'position',[0.2000    0.9700    0.0800    0.0400]);
set(hb,'visible','off','value',1);

%=========contour=================================================================================
hb=uicontrol('style','radio','units','norm');
set(hb,'position',[ .15 .95 .08 .04],'string','contour','tag'  ,'rd_contourdraw');
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','bold','callback',@rd_contourdraw);
set(hb,'tooltipstring',['draw contour' char(10) '']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.22 .52 .09 .45]); %PAN1

%num contourlines
hb=uicontrol('style','edit','units','norm');
set(hb,'position',[ .2 .95 .08 .04],'string','10','tag' ,'rd_contournumlines','callback', @rd_contournumlines);
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['number of contour lines' char(10) '']);
set(hb,'parent',pan1);
set(hb,'position',[ 0.31 .52 .04 .45]); %PAN1


%�����������������������������������������������
%%   PANEL-2
%�����������������������������������������������
pan2 = uipanel('Title','','FontSize',7,'units','norm', 'BackgroundColor','white',  'Position',[0 0 .5 .3]);
set(pan2,'Position',[0.8 -.01 .21 .915],'tag','panel2','visible','on','backgroundcolor','w');
% set(pan2,'Position',[0.8 0-.01 .205 .9]);
set(pan2,'units','pixels','visible','on');


h33=uicontrol('style','pushbutton','cdata',handicon);
set(h33,'parent',pan2,'backgroundcolor','w');%,'callback',@slid_thresh)
set(h33,'units','norm','position',[ .0 .945 .2 .06]);
set(h33,'string','','tooltipstring','drag panel to another position ','tag','pan2_dragCB');
je = findjobj(h33); % hTable is the handle to the uitable object
set(je,'MouseDraggedCallback',@pan2_dragCB  );
set(h33,'cALLback',@pan2_CB)


%=========config=================================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'config');           %SET-next-SLICE
set(hb,'position',[ .84 .14 .05 .05],'string','','callback',{@cb_configuration});
set(hb,'fontsize',8,'backgroundcolor','w');
set(hb,'tooltipstring',['configuration' char(10) '' ]);
icon=strrep(which('ant.m'),'ant.m','settings.png');
[e map]=imread(icon)  ;
e=ind2rgb(e,map);
% e(e<=0.01)=nan;
set(hb,'cdata',e);

set(hb,'parent',pan2);
set(hb,'position',[ .2 .945 .2 .06]); %PAN2
%=========HELP=================================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_help');
set(hb,'position',[ .9 .15 .1 .04],'string','help', 'callback',{@pb_help});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['more help' char(10) '']);
set(hb,'parent',pan2);
set(hb,'position',[ .45 .96 .5 .04]); %PAN2


% CONTRAST adjust slice intensity
hb=uicontrol('style','radio','units','norm', 'tag'  ,'cb_adjustIntensity');
set(hb,'position',[ .8 .8 .1 .035],'string','contrast', 'callback',{@cb_adjustIntensity});
set(hb,'fontsize',7,'backgroundcolor','w','value',0);
set(hb,'tooltipstring',['Saturate contrast, i.e. auto adjust intensity of slice' char(10) '[s] shortcut']);
set(hb,'parent',pan2);
set(hb,'position',[ 0.01 .9 .45 .04]); %PAN2

vec=0:.1:1;
alc=allcomb(vec,vec);
alc=round(alc*10)./10;
alc(alc(:,1)>=(alc(:,2)),:)=[];
% alc(:,3)=[alc(:,2)-alc(:,1)]; % add distance between lims
% alc(:,4)=[abs(alc(:,3)-0.5)];      % distance to 0.5

alc=(sortrows([alc alc(:,2)-alc(:,1)],[1 ]));
alc2=[0 1; .1 .9;.2 .8;.3 .7;.4 .6 ];
% alc=[alc2; alc(:,1:2)];
alc=unique([alc2; alc(:,1:2)],'rows','stable');
% alc= flipud(sortrows([alc alc(:,2)-alc(:,1)],[3 ]));
str=cellfun(@(a,b){[ sprintf('%2.1f',a) ' '  sprintf('%2.1f',b) ]} , num2cell(alc(:,1)),num2cell(alc(:,2)) );
str=['auto';str];
position = [10,100,90,20];  % pixels
hContainer = gcf;  % can be any uipanel or figure handle
% str = {'a','b','c'};
model = javax.swing.DefaultComboBoxModel(str);
[jCombo hb2] = javacomponent('javax.swing.JComboBox', position, hContainer);
set(hb2,'units','norm','position',[[ .9 .805 .1 .035]]);
jCombo.setModel(model);
jCombo.setEditable(true);
% jCombo.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, 14))
javaLangString=jCombo.getFont;
FSsize=get(javaLangString,'Size');
jCombo.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, FSsize-5));
set(jCombo,'ActionPerformedCallback',@cb_adjustIntensity_value);
set(hb2,'tag', 'cb_adjustIntensity_value');
set(hb2,'userdata', jCombo);
set(hb2,'parent',pan2);
set(hb2,'position',[ 0.5 .9 .45 .04]); %PAN2

% idxset=find(alc(:,1)==.3 & alc(:,2)==.7)-1;
try
    jCombo.setSelectedIndex(0); %turn it on!!!
end
jCombo.setToolTipText('contrast limits for image saturation');

%==========================================================================================
%=========copymask=================================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'cb_mask2struct');           %SET-next-SLICE
set(hb,'position',[ .85 .7 .15 .04],'string','cp mask','callback',@mask2struct);
set(hb,'fontsize',6,'backgroundcolor',[0.8706    0.9216    0.9804]);
set(hb,'tooltipstring',['copy selected mask to struct' char(10) ...
    ' can be used for other slices...first click onto a mask before hitting this button'  ]);
set(hb,'parent',pan2);
set(hb,'position',[0.0178 0.859 0.4 0.03]); %PAN2

%=========insert mask=================================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'cb_mask2struct');           %SET-next-SLICE
set(hb,'position',[ .85 .7 .15 .04],'string','insert mask','callback',@mask2slice);
set(hb,'fontsize',6,'backgroundcolor',[0.8706    0.9216    0.9804]);
set(hb,'tooltipstring',['insert mask into another slice' char(10) ...
    ' '  ]);
set(hb,'parent',pan2);
set(hb,'position',[0.43 0.859 0.4 0.03]); %PAN2


%==========================================================================================
% EDIT-VALUE (value to be set)
hb=uicontrol('style','edit','units','norm', 'tag'  ,'edvalue');
set(hb,'position',[ .85 .9 .05 .04],'string','1');
set(hb,'fontsize',8,'callback',@edvalue,'HorizontalAlignment','left');
set(hb,'tooltipstring',['value/ID to be set ...this numeric value will appear in the mask..and later saved']);
set(hb,'position',[ .95 .6 .08 .04]);
set(hb,'parent',pan2);
set(hb,'position',[0.62 .7 .35 .04]); %PAN2
%==========================================================================================
%ID-LIST
hb=uicontrol('style','listbox','units','norm', 'tag'  ,'pb_idlist','value',1);
set(hb,'position',[ .7 .95 .1 .04],'string','', 'callback',{@pb_idlist});
set(hb,'fontsize',7,'backgroundcolor','w');
set(hb,'tooltipstring',['id list']);
set(hb,'position',[.95 .25 .07 .35]);
set(hb,'parent',pan2);
set(hb,'position',[.62 .35 .4 .35]); %PAN2




c = uicontextmenu;
hb.UIContextMenu = c;
% Create menu items for the uicontextmenu
m1 = uimenu(c,'Label','assign another ID','Callback',{@idlist_contextmenu,'reassignID'});
m1 = uimenu(c,'Label','remove this ID from slice','Callback',{@idlist_contextmenu,'removeID'});
m1 = uimenu(c,'Label','keep following IDs in slice','Callback',{@idlist_contextmenu,'keepFollowingIDs'},'separator','on');
m1 = uimenu(c,'Label','keep following IDs in all slices','Callback',{@idlist_contextmenu,'keepFollowingIDs_allSlices'},'separator','on');
% m1 = uimenu(c,'Label','remove following IDs from slice','Callback',{@idlist_contextmenu,'removeFollowingIDs'},'separator','on');
% m1 = uimenu(c,'Label','remove following IDs from all slices','Callback',{@idlist_contextmenu,'removeFollowingIDs_allSlices'},'separator','on');
% 


%==========================================================================================
% %load file
% hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_load','value',0);
% set(hb,'position',[ .0 .95 .1 .04],'string','load file', 'callback',{@pb_load,1});
% set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
% set(hb,'tooltipstring',['load file' char(10) '']);
% %load mask
% hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_loadmask','value',0);
% set(hb,'position',[ .1 .95 .1 .04],'string','load mask', 'callback',{@pb_load,2});
% set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
% set(hb,'tooltipstring',['(optional) load additional maskfile' char(10) 'mask file will be overlayed']);
%==========================================================================================
%save file
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_save');
set(hb,'position',[ .9 .02 .1 .04],'string','save mask', 'callback',{@pb_save});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['save new mask as niftifile' char(10) '']);
set(hb,'parent',pan2);
set(hb,'position',[-0.005 0.0568 0.5 0.04]); %PAN2

%save file-2

hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'pb_saveoptions');
set(hb,'position',[ .86 .052 .14 .04],'string','r');%, 'callback',{@pb_save2});
set(hb,'fontsize',8,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['saving options' char(10) '']);
list={'save: mask [sm]' %'save: masked image [smi]'
    'Advanced saving options [maskman.m]'
    '---older-----'
    'save background-image: mask-value 0 is filled with 0-values)    [smi00]'
    'save background-image: mask-value 0 is filled with mean-values) [smi0m] '
    'save background-image: mask-value 0 is filled with neighbouring values) [smi0nv]'
    'save background-image: mask-value 1 is filled with 0-values)    [smi10]'
    'save background-image: mask-value 1 is filled with mean-values) [smi1m]'
    'save background-image: mask-value 1 is filled with neighbouring values) [smi1nv]'
    };
set(hb,'string',list);
set(hb,'parent',pan2);
set(hb,'position',[0.013 0.104 0.7 0.04]); %PAN2


%exit figure
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_closefig');
set(hb,'position',[ .9 .02 .1 .04],'string','exit', 'callback',{@pb_closefig});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['close window' char(10) '...do not forget to save the mask before closing the window!']);
set(hb,'parent',pan2);
set(hb,'position',[0.725 0.0044 0.25 0.04]); %PAN2


%show in MRicron
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_mricron');
set(hb,'position',[ .9 .02 .1 .04],'string','show Mricron', 'callback',{@pb_mricron});
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['show mask via MRicron' char(10) '']);
set(hb,'parent',pan2);
set(hb,'position',[0.01 0.0136 0.5 0.04]); %PAN2

%=========clear mask=================================================================================
hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'clear mask');           %SET-next-SLICE
set(hb,'position',[ .85 .7 .15 .04],'string',{'clear slice'; 'clear all slices'},'callback',{@cb_clear});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['clear current slice/clear all slices' char(10) ...
    'clear slice: shortcut [c]' char(10) ...
    'clear all slices: shortcut ctrl+[c]' ...
    ]);
set(hb,'parent',pan2);
set(hb,'position',[ .15 .8 .7 .04]); %PAN2

%=========show coordinates =================================================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rb_showcoordinates');           %SET-next-SLICE
set(hb,'position',[ .85 .7 .15 .04],'string','XYZ','value',0, 'callback',@rb_showcoordinates);
set(hb,'fontsize',6,'backgroundcolor','w');
set(hb,'tooltipstring',['shows mm-coordinates ' char(10) ' ..deselect when drawing manually for smoother performance'  ]);
set(hb,'parent',pan2);
set(hb,'position',[0 0.7455 0.4 0.035]); %PAN2



%=========filltype=================================================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rb_filltype');           %SET-next-SLICE
set(hb,'position',[ .85 .7 .15 .04],'string','fillNB');
set(hb,'fontsize',6,'backgroundcolor','w');
set(hb,'tooltipstring',...
    ['ID filling option' char(10) '[0] fill by selected ID; ' char(10) '[1] fill by next neighbouring ID'  ]);
set(hb,'parent',pan2);
set(hb,'position',[0 .7 .4 .035]); %PAN2

%=========change ID=================================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'rb_changeID');           %SET-next-SLICE
set(hb,'position',[ .85 .7 .15 .04],'string','newID','callback',@rb_changeID);
set(hb,'fontsize',6,'backgroundcolor',[0.8706    0.9216    0.9804]);
set(hb,'tooltipstring',['change ID( recolor color) of selected ROI' char(10) ...
    ' via Graphical input from mouse or cursor'  ]);
set(hb,'parent',pan2);
set(hb,'position',[0.35 .7 .22 .03]); %PAN2


%=========filltype=================================================================================
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rb_filllocal');           %SET-next-SLICE
set(hb,'position',[ .85 .66 .15 .04],'string','fill_loc');
set(hb,'fontsize',6,'backgroundcolor','w');
set(hb,'tooltipstring',...
    ['fill selected/all holes in ROI ' char(10) '[0] fill all holes; ' char(10) '[1] fill selected hole only'  ]);
set(hb,'parent',pan2);
set(hb,'position',[0.008 0.65835 0.4 0.035]); %PAN2

%=========close points and fill =================================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'rb_closeAndFill');           %SET-next-SLICE
set(hb,'position',[ .85 .7 .15 .04],'string','cloFi','callback',@rb_closeAndFill);
set(hb,'fontsize',6,'backgroundcolor',[0.8706    0.9216    0.9804]);
set(hb,'tooltipstring',['close disconnected points and fill with next neighbouring ID ' char(10) ...
    ' via Graphical input from mouse or cursor'  ]);
set(hb,'parent',pan2);
set(hb,'position',[0.354 0.6587 0.22 0.035]); %PAN2





%=========fill something=================================================================================
% hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'fill');           %SET-next-SLICE
% set(hb,'position',[ .9 .2 .05 .04],'string','fill','callback',{@cb_fill});
% set(hb,'fontsize',8);
% set(hb,'tooltipstring',['fill something' char(10) '' ]);



% ==============================================
%%   imtools
% ===============================================
picon=fullfile(matlabroot,'toolbox','images','icons');
picon2=fullfile(matlabroot,'toolbox','matlab','icons');
chkicon=which('imrect.m');
if ~isempty(chkicon);
    hf1=findobj(0,'tag','xpainter');
    pbsiz=0.05;
    %pbx=0.01%.81;
    pbx=.81;
    pby=.55;
    colpb=[1.0000    0.9490    0.8667];
    
    x=0.01;
    y=.55;
    xs=.22;
    ys=.07;
    
    
    
    delete(findobj(hf1,'userdata','imtoolsbutton'));
    delete(findobj(hf1,'tag','imtoolinfolabel'));
    
    %info
    hb=uicontrol('style','text','units','norm', 'tag'  ,'imtoolinfolabel');           %
    set(hb,'fontsize',7,'backgroundcolor','w','value',0,'string','drawing tools');
    set(hb,'position',[ pbx pby+1.1*pbsiz .12 pbsiz/2],'horizontalalignment','left');
    set(hb,'parent',pan2);
    set(hb,'position',[ x y+ys .5 .035]); %PAN2
    
    % free-hand drawing
    hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'imdraw');           %SET-next-SLICE
    set(hb,'fontsize',8,'backgroundcolor',colpb,'value',0,'string','','userdata','imtoolsbutton');
    % ---
    set(hb,'callback',{@imdrawtool_prep,   1     });
    setappdata(hb,'toolnr',1);
    set(hb,'tooltipstring',['free-hand drawing' char(10) 'shortcut [1]'  '; [esc] to quit' ]);
    set(hb,'parent',pan2);
    set(hb,'position',[ x+xs y xs ys]);
    [e map]=imread(fullfile(picon,'Freehand_24px.png'),'BackGroundColor',colpb);
    % ---
    e=double(imresize(e,[16 16],'cubic'));
    if max(e(:))>1; e=e./255; end
    set(hb,'cdata',e);
    
     %% SIMPLE free-hand drawing-II
%     hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'imdrawSimple');           %SET-next-SLICE
%     set(hb,'fontsize',8,'backgroundcolor',colpb,'value',0,'string','','userdata','imtoolsbutton');
%     % ---
%     set(hb,'callback',{@imdrawtool_prep,   6     });
%     setappdata(hb,'toolnr',1);
%     set(hb,'tooltipstring',['SIMPLE free-hand drawing' char(10) 'shortcut [6]'  '; [esc] to quit' ]);
%     set(hb,'parent',pan2);
%     set(hb,'position',[ x y xs ys]);
%     [e map]=imread(fullfile(picon,'Freehand_24px.png'),'BackGroundColor',[0.7569    0.8667    0.7765]);
%    set(hb,'backgroundcolor',[[0.7569    0.8667    0.7765]]);
%     e=double(imresize(e,[16 16],'cubic'));
%     if max(e(:))>1; e=e./255; end
%     set(hb,'cdata',e); 
    
    
   
    
    % imrect
    hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'imdraw');           %SET-next-SLICE
    set(hb,'fontsize',8,'backgroundcolor',colpb,'value',0,'string','','userdata','imtoolsbutton');
    % ---
    set(hb,'callback',{@imdrawtool_prep,  2   });
    setappdata(hb,'toolnr',2);
    set(hb,'tooltipstring',['draw rectangle' char(10) 'shortcut [2]'  '; [esc] to quit' ]);
    set(hb,'position',[ pbx pby-1*pbsiz pbsiz pbsiz]);
    set(hb,'parent',pan2);
    set(hb,'position',[ x+0*xs y-1*ys xs ys]);
    
    [e map]=imread(fullfile(picon,'Rectangle_24.png'),'BackGroundColor',colpb);
    % ---
    e=double(imresize(e,[16 16],'cubic'));
    if max(e(:))>1; e=e./255; end
    set(hb,'cdata',e);
    
    % imellipse
    hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'imdraw');           %SET-next-SLICE
    set(hb,'fontsize',8,'backgroundcolor',colpb,'value',0,'string','','userdata','imtoolsbutton');
    % ---
    set(hb,'callback',{@imdrawtool_prep,  3   });
    setappdata(hb,'toolnr',3);
    set(hb,'tooltipstring',['draw ellipse/cirlce' char(10) 'shortcut [3]' '; [esc] to quit' ]);
    set(hb,'position',[ pbx+1*pbsiz pby-1*pbsiz pbsiz pbsiz]);
    set(hb,'parent',pan2);
    set(hb,'position',[ x+1*xs y-1*ys xs ys]);
    [e map]=imread(fullfile(picon,'Ellipse_24.png'),'BackGroundColor',colpb);
    % ---
    e=double(imresize(e,[16 16],'cubic'));
    if max(e(:))>1; e=e./255; end
    set(hb,'cdata',e);
    
    % impoly
    hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'imdraw');           %SET-next-SLICE
    set(hb,'fontsize',8,'backgroundcolor',colpb,'value',0,'string','','userdata','imtoolsbutton');
    % ---
    set(hb,'callback',{@imdrawtool_prep,  4   });
    setappdata(hb,'toolnr',4);
    set(hb,'tooltipstring',['draw polygon' char(10) 'shortcut [4]'  '; [esc] to quit' ]);
    set(hb,'position',[ pbx+0*pbsiz pby-2*pbsiz pbsiz pbsiz]);
    set(hb,'parent',pan2);
    set(hb,'position',[ x+0*xs y-2*ys xs ys]);
    [e map]=imread(fullfile(picon,'Polygon_24px.png'),'BackGroundColor',colpb);
    % ---
    e=double(imresize(e,[16 16],'cubic'));
    if max(e(:))>1; e=e./255; end
    set(hb,'cdata',e);
    
    % imline
    hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'imdraw');           %SET-next-SLICE
    set(hb,'fontsize',8,'backgroundcolor',colpb,'value',0,'string','','userdata','imtoolsbutton');
    % ---
    set(hb,'callback',{@imdrawtool_prep,  5   });
    setappdata(hb,'toolnr',5);
    set(hb,'tooltipstring',['draw line' char(10) 'shortcut [5]' char(10)  '; [esc] to quit' ]);
    set(hb,'position',[ pbx+1*pbsiz pby-2*pbsiz pbsiz pbsiz]);
    set(hb,'parent',pan2);
    set(hb,'position',[ x+1*xs y-2*ys xs ys]);
    [e map]=imread(fullfile(picon2,'tool_line.png'),'BackGroundColor',colpb);
    % ---
    e=double(imresize(e,[16 16],'nearest'));
    e=mat2gray(e);
    if max(e(:))>1; e=e./255; end
    set(hb,'cdata',e);
    
    % h =imfreehand;
    % h=imrect;
    % h=imellipse;
    % h=impoly;
    % h=imline;
    %
    
    % Ellipse_16.png
    % Rectangle_24.png
    % Polygon_24px.png
    % STRELLINE_24.png
end

% ==============================================
%%  distance measure
% ===============================================
chkicon=which('imdistline.m');
if ~isempty(chkicon);
    hf1=findobj(0,'tag','xpainter');
    pbsiz=0.05;
    pbx=.8;
    pby=.38;
    colpb=[0.8392    0.9098    0.8510];
    picon=fullfile(matlabroot,'toolbox','images','icons');
    picon2=fullfile(matlabroot,'toolbox','matlab','icons');
    
    
    % measure distance
    hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'pb_measureDistance');           %SET-next-SLICE
    set(hb,'fontsize',8,'backgroundcolor',colpb,'value',0,'string','');
    % ---
    set(hb,'callback',@pb_measureDistance);
    set(hb,'tooltipstring',['measure distance' char(10) '[ctrl+m] to open/close tool; [esc] to close tool' ]);
    %set(hb,'position',[ pbx pby pbsiz pbsiz]);
    set(hb,'parent',pan2);
    set(hb,'position',[ 0.2696 0.326  xs ys]);
    [e map]=imread(fullfile(picon,'distance_tool.gif'));
    e=mat2gray(e);
    e(e==1)=nan;
    % ---
    %e=double(imresize(e,[16 16],'cubic'));
    if max(e(:))>1; e=e./255; end
    e2=repmat(e,[1 1 3]);
    set(hb,'cdata',e2);
end


%% ========= patch =================================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_patch');           %SET-next-SLICE
set(hb,'position',[ .85 .2 .15 .04],'string','','callback',@pb_patch);
set(hb,'fontsize',6,'backgroundcolor',[0.8706    0.9216    0.9804]);
set(hb,'tooltipstring',['ROI operation' char(10) ...
    'move,rotate/mirror, replicate ROI' char(10) ...
    ' shortcut [r]']);
set(hb,'parent',pan2);
set(hb,'position',[0.0064 0.3259 xs ys]); %PAN2
% picon2=fullfile(matlabroot,'toolbox','matlab','icons');
[e map]=imread(fullfile(picon2,'help_block.png'),'BackGroundColor',[0.8706    0.9216    0.9804]);
e=double(imresize(e,[16 16],'cubic'));
if max(e(:))>1; e=e./255; end
set(hb,'cdata',e);
   

% panlin1 = uipanel('parent',pan2,'Title','','FontSize',7,'units','norm', 'BackgroundColor','r', ...
%     'Position',[0 0 .5 .3]);
% set(panlin1,'Position',[0  .31 1 .01],'tag','panlin1','visible','on','ShadowColor','r');
%% ========= separatorline =================================================================================
colsep=[ 0.4667    0.6745    0.1882];

hb = uicontrol('parent',pan2,'style','pushbutton','string','','FontSize',7,'units','norm', ...
    'Position',[0 0 .5 .3]);
set(hb,'Position',[0  .31 1 .007],'tag','panlin1','visible','on','BackgroundColor',colsep,'tag','pan2sep1');

%% previois/last step
%==========================================================================================
% LAST-STEP
butsi=[.16 0.05];
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_prevstep');
set(hb,'position',[ .52 .95 .05 .04],'string',' ', 'callback',{@pb_undoredo,-1});
set(hb,'fontsize',7,'backgroundcolor','w');
% set(hb,'tooltipstring',['UNDO last step' char(10) '..for this slice only' char(10) 'shortcut [x] or [ctrl+x] ' ]);
set(hb,'tooltipstring',['UNDO last step' char(10) '..for this slice only' char(10) 'shortcut [<] ' ]);

e = which('undo.gif'); 
%    if ~isempty(regexpi(e,'.gif$'))
[e map]=imread(e);e=ind2rgb(e,map);
set(hb,'cdata', e);
set(hb,'parent',pan2);
set(hb,'position',[ 0.0064 .25 butsi   ]);  

% NEXT-STEP
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_nextstep');
set(hb,'position',[ .56 .95 .05 .04],'string',' ', 'callback',{@pb_undoredo,+1});
set(hb,'fontsize',7,'backgroundcolor','w');
% set(hb,'tooltipstring',['REDO last step' char(10) '..for this slice only' char(10) 'shortcut  [y] or  [ctrl+y] ']);
set(hb,'tooltipstring',['REDO last step' char(10) '..for this slice only' char(10) 'shortcut  [>] ']);

set(hb,'cdata', flipdim(e,2));
set(hb,'parent',pan2);
set(hb,'position',[ 0.0064+(butsi(1)) .25 butsi]);  


% do/redo-label
hb=uicontrol('style','text','units','norm', 'tag'  ,'pb_undoredo_label');
set(hb,'position',[ .6 .95 .1 .035],'string','Hist: 1/10','horizontalalignment','left');
set(hb,'fontsize',7,'backgroundcolor','w','foregroundcolor','b');
set(hb,'tooltipstring',['undo/redo step number of available undo/redo steps']);
set(hb,'parent',pan2);
set(hb,'position',[ 0.0064+(butsi(1))*2 .25 butsi(1)*4  butsi(2)]);



%% =========paint/unpaint =================================================================================
hb=uicontrol('style','togglebutton','string','unpaint','units','norm','value',0);
set(hb,'position',[.32  .95 .15 .06],'backgroundcolor','w');
set(hb,'callback',@undo,'tag','undo');
set(hb,'fontsize',8);
set(hb,'tooltipstring',['un-paint location' char(10) '[u] shortcut' ]);
set(hb,'parent',pan2);
set(hb,'position',[ 0.0064 .2 .45 .04]); 

%% ========= hide mask =================================================================================
hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'preview');
set(hb,'position',[ .7 .9 .1 .04],'string','hide mask', 'callback',{@cb_preview});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['show/hide masks:  [0]show mask, [1] hide mask' char(10) '[h] shortcut']);
set(hb,'parent',pan2);
set(hb,'position',[ .51 .2 .45 .04]); 



%% ========= separatorline =================================================================================
hb = uicontrol('parent',pan2,'style','pushbutton','string','','FontSize',7,'units','norm', ...
    'Position',[0 0 .5 .3]);
set(hb,'Position',[0  .19 1 .007],'tag','panlin1','visible','on','BackgroundColor',colsep,'tag','pan2sep2');


%% =========test =================================================================================
if 0
    hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'rb_test');           %SET-next-SLICE
    set(hb,'position',[0 0 .15 .04],'string','test','callback',@pb_test);
    set(hb,'fontsize',6,'backgroundcolor',[0.8706    0.9216    0.9804]);
    set(hb,'tooltipstring',['test ' char(10) ...
        ' '  ]);
    set(hb,'parent',pan2);
    set(hb,'position',[0.354 0.2587 0.22 0.035]); %PAN2
end


% ==============================================
%%  windows-auto focus
% ===============================================
if 1%~isempty(chkicon);
    hf1=findobj(0,'tag','xpainter');
    hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_autofocus');           %SET-next-SLICE
    set(hb,'fontsize',7,'backgroundcolor','w','value',0,'string','WinFocus');
    set(hb,'callback',@rd_autofocus);
    set(hb,'tooltipstring',['autofocus window' char(10) 'window becoms focused (active) when mouse hovers over it' char(10) '[a] shortcut']);
    %set(hb,'position',[ .84 .2 .11 .035]);
    set(hb,'parent',pan2);
    set(hb,'position',[-0.01 0.1503 0.6 0.035]);
end




%% --------------- end panel2


% wait
hb=uicontrol('style','text','units','norm', 'tag'  ,'waitnow');             %CHANGE-DIM
set(hb,'position',[ .93 .97 .07 .03],'string','..wait..','backgroundcolor','k','foregroundcolor',[1.0000 0.8431 0]);
set(hb,'visible','on');

v.unp=get(pan1,'position');
set(pan1,'units','norm');
v.unn=get(pan1,'position');
set(pan1,'userdata',v);

v.unp=get(pan2,'position');
set(pan2,'units','norm');
v.unn=get(pan2,'position');
set(pan2,'userdata',v);

v.unp=get(pan3,'position');
set(pan3,'units','norm');
v.unn=get(pan3,'position');
set(pan3,'userdata',v);

%
% pos2=get(pan2,'position');
% set(pan2,'userdata',pos2);
% set(pan2,'units','norm');
%
% pos3=get(pan3,'position');
% set(pan3,'userdata',pos3);
% set(pan3,'units','norm');

function pb_mricron(e,e2)
%% ===============================================

hf1=findobj(0,'tag','xpainter');
u=get(gcf,'userdata');
f1=u.f1;
[pa name ext]=fileparts(f1);
if isempty(pa); pa=pwd; end
f1=fullfile(pa,[name ext]);

[fi pa]=uigetfile(fullfile(pa,'*.nii'),'select maskfile');
if isnumeric(fi)
    disp('...no mask was selected...');
     rmricron([],f1,[],1);
else
    f2=fullfile(pa,fi);
    rmricron([],f1,f2,1);
end


%% ===============================================

function pb_closefig(e,e2)
delete(findobj(0,'tag','xpainter'));

function idlist_contextmenu(e,e2,task)
hf1=findobj(0,'tag','xpainter');
hed=findobj(hf1,'tag','edvalue');
ID=str2num(get(hed,'string'));



%% =========================================================================================
u=get(hf1,'userdata');
[r1 r2]=aa_getslice();
% r2(1:4,1:4)=1;

if strcmp(task,'removeID')
    %'removeID'
    newID=0;
elseif strcmp(task,'reassignID')
    %'reassignID'
    %% =========================================================================================
    prompt = {[...
        ['Assign a new ID for all ROIs with ID=[' num2str(ID) '] found in THIS slice:'] char(10)  ...
        '   0: will remove all ROIs with this ID from THIS slice' char(10) ...
        '   ..enter a new numeric ID']};
    dlg_title = 'Reassign ID';
    num_lines = 1;
    defaultans = {num2str(ID)};
    answer = inputdlg2(prompt,dlg_title,num_lines,defaultans);
    %% =========================================================================================
    if isempty(answer); return; end
    newID=str2num(answer{1});
    if isnan(newID);
        newID=str2num(get(findobj(hf1,'tag','edvalue'),'string')) ;
    end
elseif strcmp(task,'keepFollowingIDs') 
    allID=unique(r2); allID(allID==0)=[];
    
    msg='Keep selected IDs in slice; optional: rename selected IDs in 3rd. column';
    selection=1;
    idkeeptab=idlistTable(allID,msg,selection);
    if isempty(idkeeptab); return; end
    
    tb=idkeeptab(idkeeptab(:,1)==1,:);
     si=size(r2);
    x=r2(:);
    y=x.*0;
    for i=1:size(tb,1)  % fill slice with IDs
        ix=find(x==tb(i,2));
        if    tb(i,3)~=0;   y(ix)=tb(i,3);
        else;               y(ix)=tb(i,2);
        end
    end
    y2=reshape(y,si);
    IDleft=unique(y2); IDleft(IDleft==0)=[];
    if isempty(IDleft)  ; newID=1;
    else                ; newID=min(IDleft);
    end
    
    aa_setslice(y2);
    hb=findobj(hf1,'tag','edvalue');
    set(hb,'string', num2str(newID));
    edvalue();
    setslice([],1);
    
    return
elseif strcmp(task,'keepFollowingIDs_allSlices')

    r2=u.b;
    allID=unique(r2); allID(allID==0)=[];
    
    msg='Keep selected IDs in ALL slices; optional: rename selected IDs in 3rd. column';
    selection=1;
    idkeeptab=idlistTable(allID,msg,selection);
    if isempty(idkeeptab); return; end
    
    tb=idkeeptab(idkeeptab(:,1)==1,:);
    si=size(r2);
    x=r2(:);
    y=x.*0;
    for i=1:size(tb,1)  % fill slice with IDs
        ix=find(x==tb(i,2));
        if    tb(i,3)~=0;   y(ix)=tb(i,3);
        else;               y(ix)=tb(i,2);
        end
    end
    y2=reshape(y,si);
    IDleft=unique(y2); IDleft(IDleft==0)=[];
    if isempty(IDleft)  ; newID=1;
    else                ; newID=min(IDleft);
    end
    u.b=y2;
    set(hf1,'userdata',u);
    setslice();
    %aa_setslice(y2);
    hb=findobj(hf1,'tag','edvalue');
    set(hb,'string', num2str(newID));
    edvalue();
    %setslice([],1);
    
    return






end
%% =========================================================================================
m2=r2==ID;
% m2=m1*newID;
% cl=bwlabel(m1);
% clustnum=cl(round(co(2)),round(co(1))  );
% cl2=cl==clustnum;
% m2=cl2;
m3=r2;
m3(m2)=newID;
ro=m3;
aa_setslice(ro);
%===================================================================================================
% ------------- update IDlist -------------
hb=findobj(hf1,'tag','edvalue');
set(hb,'string', num2str(newID));
edvalue();
setslice([],1);
% fg,imagesc(r2);


% function delID=idlistTable(allID)
% % delID=[]
% % 
% % idtab=snip_idlistTable(ids,msg,selection)



function idtab=idlistTable(ids,msg,selection,tabtype)
% ==============================================
%%   id table
% tabtype1: [x] ID IDNEW
% tabtype2: [x] ID Number of pixel
% ===============================================
idtab=[];
if exist('tabtype')==0; tabtype=1; end

if 0
    msg='Selected IDs will be remove from this Slice, rename IDs in 3rd. column';
    ids
    selection=0;
    snip_idlistTable(ids,msg,selection);
end

hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');

if tabtype==1
    tbh      = {'use' 'ID' 'newID'};
    editable = [1    0  1  ]; %EDITABLE
    colfmt   ={'logical' 'string'  'numeric'} ;
    ids=unique(ids(:)); ids(ids==0)=[];
    
    dx={};
    for i=1:length(ids)
        tmp= { logical(selection) num2str(ids(i))   ''};
        dx=[dx; tmp];
    end
    
elseif tabtype==2
    d0=ids; %rewrite
    
    tbh      = {'use' 'ID' '#Pixels'};
    editable = [1    0  0  ]; %EDITABLE
    colfmt   ={'logical' 'string'  'numeric'} ;
    
    ids=d0(:,1);
    npixel=d0(:,2);
    
    dx={};
    for i=1:length(ids)
        tmp= { logical(selection) num2str(ids(i))   num2str(npixel(i))};
        dx=[dx; tmp];
    end
end


% dx=[ logical(ones(size(ids)))  ids  ones(size(ids))  ];


tb       =dx;
% for i=1:size(tbh,2)
%     addspace=size(char(tb(:,i)),2)-size(tbh{i},2)+3;
%     tbh(i)=  { [' ' tbh{i} repmat(' ',[1 addspace] )  ' '  ]};
% end

delete(findobj(0,'tag'  ,'IDlist'));
fg;
set(gcf,'numbertitle','off','tag','IDlist','name','IDlist','menubar','none');
hf5=gcf;
pos=get(hf5,'position');
pos=set(hf5,'position',[pos(1:2) pos(3)./3  pos(4)]);

t = uitable('Parent', gcf,'units','norm', 'Position', [0 0.05 .89 .95], ...
    'Data', tb,'tag','table',...
    'ColumnWidth','auto');
t.ColumnName =tbh;
% h(end+1,:)={get(t,'tag') get(t,'type')  '' };

t.ColumnEditable =logical(editable ) ;% [false true  ];
try
    colmat=u.colmat;
catch
    u.colmat = distinguishable_colors(max(ids),[1 1 1; 0 0 0]);
    if size(u.colmat ,1)>2
        u.colmat=u.colmat([2 1 3:end ],:);
    end
end
if max(ids)>size(u.colmat,1)
     u.colmat = distinguishable_colors(max(ids),[1 1 1; 0 0 0]);
    if size(u.colmat ,1)>2
        u.colmat=u.colmat([2 1 3:end ],:);
    end 
end




% colmat=repmat(colmat,[5 1]);
col=u.colmat(ids,:);
t.BackgroundColor =col;% [0 0 1; 0.9451    0.9686    0.9490];

% set(t,'ColumnWidth',{51});
set(t,'units','norm','position',[0 0.05 .89 .9]);
set(t,'tooltipstring','IDs ...select/deselect IDs ..see task above');

% select all
hb=uicontrol('style','checkbox','units','norm', 'tag'  ,'IDlist_selectall');
set(hb,'position',[0.021429 0.0035714 0.4 0.04],'string','select all',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',[0.9294    0.6941    0.1255],'value',selection,...
    'horizontalalignment','left','fontsize',7,'fontweight','bold');
set(hb,'callback',@IDlist_selectall);
set(hb,'tooltipstring','select/deselect IDs');

%OK
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'IDlist_OK');
set(hb,'position',[0.74464 0.0035714 0.25 0.04],'string','OK',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor','k','value',0,...
    'horizontalalignment','left','fontsize',7,'fontweight','bold');
set(hb,'callback',@IDlist_OK);
set(hb,'tooltipstring','OK..accept');

%cancel
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'IDlist_cancel');
set(hb,'position',[0.49286 0.0035714 0.25 0.04],'string','Cancel',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor','k','value',0,...
    'horizontalalignment','left','fontsize',7,'fontweight','bold');
set(hb,'callback',@IDlist_cancel);
set(hb,'tooltipstring','cancel');


%MSG
col=[0.7569    0.8667    0.7765];
% col=repmat([1],[1 3]);
hb=uicontrol('style','text','units','norm', 'tag'  ,'IDlist_msg');
set(hb,'position',[0 .94 1 0.06],'string',msg,...{'infobox' 'dd'},...
    'backgroundcolor',col,'foregroundcolor','k','value',0,...
    'horizontalalignment','left','fontsize',7,'fontweight','bold');
set(hb,'tooltipstring','message');

v=[];
set(hf5,'userdata',v);

 uiwait(hf5);  %WAIT

try
    v=get(hf5,'userdata');
    if v.isOK==1
        ht=findobj(hf5,'tag'  ,'table');
        d=get(ht,'Data');

        iempty= cellfun('isempty',d);
        d(iempty)={0};
        d2=cell2mat(cellfun(@(a){[str2num(num2str(a)) ]} , d ));
%         if sum(d2(:,3))==0
%            d2=d2(:,1:2) ; %remove renaming col
%         end
        idtab=d2;
    end
end
close(hf5);


% ==============================================
%%   IDlist subs
% ===============================================

function IDlist_selectall(e,e2)
hb=findobj(gcf,'tag','table');
if get(findobj(gcf,'tag','IDlist_selectall'),'value')==0
    hb.Data(:,1)={logical(0)} ;% d(:,1)={logical(0)};
else
    hb.Data(:,1)={logical(1)} ;d(:,1)={logical(1)} ;
end

function IDlist_OK(e,e2)
v=get(gcf,'userdata');
v.isOK=1;
set(gcf,'userdata',v);
uiresume(gcf);
 

function IDlist_cancel(e,e2)
v=get(gcf,'userdata');
v.isOK=0;
set(gcf,'userdata',v);
uiresume(gcf);


































function rb_showcoordinates(e,e2)
hf1=findobj(0,'tag','xpainter');
set(findobj(hf1,'tag','infobox'),'string','');

function montage_reload(e,e2)
show_allslices();




function show_allslices(e,e2,px)
% ==============================================
%%
% ===============================================
% fprintf('..wait...');
hf1=findobj(0,'tag','xpainter');
hw=findobj(hf1,'tag','waitnow');
% drawnow
% uistack(findobj(hf1,'tag','panel1'),'top');
% drawnow
set(hw,'visible','on','string','..wait..'); drawnow;
u=get(hf1,'userdata');
hb=findobj(hf1,'tag','rd_changedim');
dimval=get(hb,'value');
dimlist=get(hb,'string');
dim=str2num(dimlist{dimval});
% dim=

do_transp=get(findobj(hf1,'tag','rd_transpose'),'value');
do_flipud=get(findobj(hf1,'tag','rd_flipud'),'value');



b=u.b(:);
uni=unique(b); uni(uni==0)=[];
c=zeros(size(b,1),3);
for i=1:length(uni)
    %fprintf('%d ',i);
    pdisp(i,20);
    %disp(i)
    ix=find(b==uni(i));
    c(ix,:)=repmat( u.colmat(uni(i),:) ,[ length(ix) 1]);
end
% fprintf('..');

% ==============================================
%%   
% ===============================================

c1=reshape(c(:,1),[u.hb.dim]);
c2=reshape(c(:,2),[u.hb.dim]);
c3=reshape(c(:,3),[u.hb.dim]);

dimother=setdiff(1:3,dim);
c1=permute(c1, [dimother dim]);
c2=permute(c2, [dimother dim]);
c3=permute(c3, [dimother dim]);



% d=[];
% d(:,:,1)=montageout(permute(c1,[1 2 4 3]));
% d(:,:,2)=montageout(permute(c2,[1 2 4 3]));
% d(:,:,3)=montageout(permute(c3,[1 2 4 3]));

bg  =permute(u.a, [dimother dim]);
mask=permute(u.b, [dimother dim]);


% crop   ------------------------------------------------------------
hf4=findobj(0,'tag','montage');
hc=findobj(hf4,'tag','montage_crop');
if isempty(hc)
    docrop=0;
else
    docrop=get(hc,'value');
end

if docrop==1        %------------------------- CROP
    o=reshape(   otsu(bg(:),3)  ,[size(c2)])  ;
    cm=mean(o,3)==1 ;%crop
    
    cm=imerode(cm,strel('square',[2]));
    v.ins_lr=find(mean(cm,1)~=1);
    v.ins_ud=find(mean(cm,2)~=1);
    
    bg     =bg(   v.ins_ud, v.ins_lr,:);
    mask   =mask( v.ins_ud, v.ins_lr,:);
    c1     =c1(   v.ins_ud, v.ins_lr,:);
    c2     =c2(   v.ins_ud, v.ins_lr,:);
    c3     =c3(   v.ins_ud, v.ins_lr,:);
%     d      =d(    v.ins_ud, v.ins_lr,:)  ;
    
end
% montage2(bg)
d=[];
d(:,:,1)=montageout(permute(c1,[1 2 4 3]));
d(:,:,2)=montageout(permute(c2,[1 2 4 3]));
d(:,:,3)=montageout(permute(c3,[1 2 4 3]));
% ==============================================
%%   
% ===============================================


% r1=adjustIntensity(r1)
% -----
for i=1:size(bg,3)
    %bg(:,:,i)=imadjust(mat2gray(bg(:,:,i)));
    bg(:,:,i)=adjustIntensity(mat2gray(bg(:,:,i)));
end
bg  =montageout(permute(bg,[1 2 4 3]));
mask=montageout(permute(mask,[1 2 4 3]));

% bg=imadjust(mat2gray(montageout(permute(bg,[1 2 4 3]))));
%-----
bg=repmat(bg,[1 1 3]);
% TX=repmat(permute([1:size(c1,3) ]',[3 2 1]),[size(c1,1)  size(c1,2)  1]); %for txtlabel
TX=zeros(size(c1));
for i=1:size(c1,3)
    TX(1,1,i)=i;
end

TX=montageout(permute(TX,[1 2 4 3]));
if do_transp==1
    bg=permute(bg     ,[2 1 3]);
    d =permute( d     ,[2 1 3]);
    TX=permute( TX    ,[2 1 3]);
    mask=permute( mask,[2 1 3]);
end
if do_flipud==1
    bg    =flipdim(bg,1);
    d     =flipdim(d,1);
    mask  =flipdim(mask,1);
end

%%label-cords
laco=zeros(size(c1,3),2);
for i=1:size(c1,3)
    [laco(i,1) laco(i,2)]=find(TX==i);
end



%%
% h=image(imfuse(bg,d,'blend'));
if sum(d(:))==0
    fus=bg;
else
    fus=bg.*.5+d.*.5;
end

% brightness=1.5;
% fus=fus*brightness;


% us.brightness=brightness;
us.fus=fus;
us.bg =bg;
us.ma =d;
us.mask=mask;


% %% crop
% docrop=1;
% if docrop==1        %------------------------- CROP
% 
%     o=otsu(bg(:,:,1),3);
%     cm=mean(o,3)==1 ;%crop
%     cm=imdilate(cm,strel('square',[7]));
%     v.ins_lr=find(mean(cm,1)~=1);
%     v.ins_ud=find(mean(cm,2)~=1);
% 
%     us.fus   =us.fus(v.ins_ud, v.ins_lr,:);
%     us.bg    =us.bg(v.ins_ud, v.ins_lr,:);
%     us.ma    =us.ma(v.ins_ud, v.ins_lr,:);
%     us.mask  =us.mask(v.ins_ud, v.ins_lr,:);
% 
% 
% %    TX =TX(v.ins_ud, v.ins_lr,:);
% 
% 
%    
% else
%     v.ins_lr=[1:size(o,2)];
%     v.ins_ud=[1:size(o,1)];
% end
us.docrop=docrop;

% ==============================================
%%
% ===============================================
hf4=findobj(0,'tag','montage');
if isempty(hf4);
    makenewFig=1;
else
    makenewFig=0;
end

if makenewFig==1
    fg;
    hf4=gcf;
    set(hf4,'NumberTitle','off','name', 'montage');
    image(fus);
    axis image; axis off;
    title('bg-image & mask');
    
    
    set(gca,'position',[0.05 0 1 1]); %axis normal;
    hb=uicontrol('style','text','units','norm','string','bg-image & mask');
    set(hb,'position',[0 0 1 .04],'foregroundcolor','b');
else
    figure(hf4);
    him=findobj(hf4,'type','image');
    set(him,'cdata',us.fus);
end

set(hf4,'userdata',us,'tag','montage');
delete(findobj(hf4,'tag','slicenum'));


if docrop==1
    shiftTX=0;
else
    shiftTX=0.4;
end
for i=1:size(c1,3)
    te(i)=text( laco(i,2)+size(c1,2)*shiftTX ,laco(i,1), num2str(i));
    set(te(i),'color',[1.0000    0.8431         0],'tag','slicenum');
    set(te,'VerticalAlignment','top','fontsize',8,'fontweight','bold');
    set(te,'ButtonDownFcn', @showclises_gotoThisSlice);
end




% ==============================================
%%
% ===============================================
if makenewFig==1;
    
    zoom on;
    % fprintf('done\n');
    
    
    hb=uicontrol('style','text','units','norm','string','Show');
    set(hb,'position',[0 .9+1*.03 .1 .03],'fontsize',7,'backgroundcolor','w','HorizontalAlignment','left','fontweight','bold');
    
    hb=uicontrol('style','radio','units','norm','string','both','value',1,'callback',@montage_post);
    set(hb,'position',[0 .9 .15 .03],'fontsize',7,'backgroundcolor','w','userdata',1,'tag','rd_montage_ovl');
    set(hb,'tooltipstring','show background image [BG] and mask');
    
    hb=uicontrol('style','radio','units','norm','string','[0]BG,[1]Mask','value',0,'callback',@montage_post);
    set(hb,'position',[0 .9-1*.03  .15 .03],'fontsize',7,'backgroundcolor','w','userdata',2,'tag','rd_montage_ovl');
    set(hb,'tooltipstring','show background image [BG] or mask');
    
    
    %slider-TXT
    hb=uicontrol('style','text','units','norm','string','contrast');
    set(hb,'position',[0 .8-0*.03  .15 .03],'fontsize',7,'backgroundcolor','w');
    %slider-ui
    hb=uicontrol('style','slider','units','norm','string','rb','value',0.5,'callback',@montage_slid_contrast);
    set(hb,'position',[0 .8-1*.03  .15 .03],'fontsize',7,'backgroundcolor','w','userdata',[],'tag','montage_slid_contrast');
    set(hb,'tooltipstring','change contrast');
    
    % =========contour======================================================
    hb=uicontrol('style','radio','units','norm', 'tag'  ,'montage_contour','value',0);
    set(hb,'position',[0 .7 .12 .04],'string','contour', 'callback',@montage_post);
    set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
    set(hb,'tooltipstring',['show contour' char(10) '-']);
    
   % =========crop======================================================
    hb=uicontrol('style','radio','units','norm', 'tag'  ,'montage_crop','value',0);
    set(hb,'position',[0.0017857 0.61786 0.12 0.04],'string','crop slices', 'callback',@montage_reload);
    set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
    set(hb,'tooltipstring',['crop slices for better montage' char(10) '-']);
   % =========axis normal/image======================================================
    hb=uicontrol('style','radio','units','norm', 'tag'  ,'montage_axisnormal','value',0);
    set(hb,'position',[0.0017857 0.57976 0.12 0.04],'string','axis normal', 'callback',@montage_axisnormal);
    set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
    set(hb,'tooltipstring',['axis normal/image' char(10) '-']);

    % =========reload======================================================
    hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'montage_reload');
    set(hb,'position',[0.0017857 0.96071 0.12 0.04] ,'string','reload', 'callback',@montage_reload);
    set(hb,'fontsize',7,'backgroundcolor',[0.8392    0.9098    0.8510],'fontweight','normal');
    set(hb,'tooltipstring',['reload data']);
    
    
%     set(findobj(hf4,'type','uicontrol'),'units',  'pixels');
 
else
    set(findobj(gcf,'tag','rd_montage_ovl','-and','userdata',1),'value',1);
    set(findobj(gcf,'tag','rd_montage_ovl','-and','userdata',2),'value',0);
end



 montage_slid_contrast();
set(hw,'visible','off');




function showclises_gotoThisSlice(e,e2)
hf1=findobj(0,'tag','xpainter');
str=get(e,'string');
hb=findobj(hf1,'tag','edslice');
set(hb,'string',str);
figure(hf1);
cb_setslice([],[],'ed');

hd=findobj(hf1,'tag','dot');
set(hd,'userdata',0);


% hb=uicontrol('style','radio','units','norm','string','Mask','value',0,'callback',@montage_post);
% set(hb,'position',[0 .9-2*.03  .12 .03],'fontsize',7,'backgroundcolor','w','userdata',3,'tag','rd_montage_ovl');
function montage_slid_contrast(e,e2)
% uv=get(gcf,'userdata')
% hb=findobj(gcf,'tag','montage_slid_contrast');
% val=get(hb,'value');
% him=findobj(gca,'type','image');
% d=get(him,'cdata');
% set(him,'cdata',d.*(val*3));
hf4=findobj(0,'tag','montage');
hd=findobj(hf4,'tag','rd_montage_ovl');
hf=hd(find(cell2mat(get(hd,'value'))));
montage_post(hf,[]);

function montage_axisnormal(e,e2,px)
montage_post();

function montage_post(e,e2)
hf4=findobj(0,'tag','montage');
hd=findobj(hf4,'tag','rd_montage_ovl');
us=get(gcf,'userdata');
% get(e,'userdata')

hs=[findobj(hd,'userdata',1) findobj(hd,'userdata',2)];
rd=cell2mat(get(hs,'value'));
if  rd(1)==1 && rd(2)==0
    im=us.fus;%
elseif rd(1)==0 && rd(2)==1
    im=us.ma;
elseif rd(1)==0 && rd(2)==0
    im=us.bg;
elseif rd(1)==1 && rd(2)==1
    
    im=us.ma;
end

him=findobj(gca,'type','image');
hb=findobj(gcf,'tag','montage_slid_contrast');
val=get(hb,'value');
% if get(e,'userdata')==1
%     im2=im*val*2;
% else
%     im2=im*val*2;
% end
im2=im*val*2;
set(him,'cdata',im2);

% ----contour
hold on;
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
uni=unique(us.mask); uni(uni==0)=[];



docontour=get(findobj(gcf,'tag','montage_contour'),'value');
delete(findobj(gca,'type','contour'));
delete(findobj(gca,'tag','mycontour'));
if docontour==1
    %�����������������������������������������������
    %%
    %�����������������������������������������������
    delete(findobj(gca,'type','contour'));
    delete(findobj(gca,'tag','mycontour'));
    hold on;
    %     delete(findobj(gca,'type','contour'));
    %     contour(us.mask,length(uni),'linewidth',1);
    %     colormap(u.colmat(uni,:));
    %     %colorbar
    %     %caxis([0 size(u.colmat,1)]);
    %     try; caxis([1 max(uni)]); end
    %
    
    c=contourc(us.mask,length(uni));
    if isempty(c); return; end
    
    c2=contourdata(c);
    msk2=us.mask(:);
    uni=[unique(msk2)]; uni(uni==0)=[];
    %uni=[1 4 5]
    for i=1:length(c2)
        cx=[c2(i).xdata, c2(i).ydata];
        ind = sub2ind(size(us.mask), round(cx(:,2)),  round(cx(:,1)));
        tb=flipud(sortrows([uni histc(msk2(ind),uni) ],2))  ;
        val=tb(1,1);
        if tb(1,2)/length(ind)>30
            val=0;
        end
        %disp([(val)]);
        if val~=0
            hp=plot(c2(i).xdata, c2(i).ydata, 'color',u.colmat(val,:),'tag','mycontour','linewidth',1);
        end
        % disp(i) ;drawnow; pause
    end
    %
    
    
    % ==============================================
    %%
    % ===============================================
end


hd=findobj(hf4,'tag','montage_axisnormal');
figure(hf4);
if get(hd,'value')==1
    axis normal;
    set(gca,'position',[ 0.151         0  .848    1.0000]);
else
    axis image;
    set(gca,'position',[ 0.0500         0    1.0000    1.0000]);
end


function set_idlist()
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
ids=unique(u.b(:)); ids(isnan(ids))=[]; ids(ids==0)=[];
val=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
ids=unique([ids; val]);
sel=find(ids==val);
idlist=cellfun(@(a){[num2str(a)]} ,num2cell(ids) );
hlist=findobj(gcf,'tag','pb_idlist');
% set(hlist,'string',{'<HTML><FONT color=#0000FF><b>Red</FONT></HTML>'},'value',sel);
% '<HTML><FONT color="red">Red</FONT></HTML>'

% 
% function def_colors()
% hf1=findobj(0,'tag','xpainter');
% u=get(hf1,'userdata');
% colmat = distinguishable_colors(u.set.numColors,[1 1 1; 0 0 0]);
% 
if max(ids)>size(u.colmat,1)
    u.set.numColors=max(ids);
    set(hf1,'userdata',u);
def_colors();
    u=get(hf1,'userdata');
end

list={};
for i=1:length(ids)
    colrgb=u.colmat(ids(i),:);
    col=reshape(dec2hex(round(colrgb*255), 2)',1, 6);
    list(end+1,1)={['<HTML><FONT color=#' col  '><b>' num2str(ids(i)) '</FONT></HTML>']};
end
set(hlist,'string',list,'value',sel);
set(hlist,'backgroundcolor',[.8 .8 .8]);
set(hlist,'userdata',ids);


function pb_idlist(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
hb=findobj(hf1,'tag','edvalue');
hlist=findobj(hf1,'tag','pb_idlist');
ids=get(hlist,'userdata');
%  list=get(hlist,'string');
va=get(hlist,'value');
%  id=str2num(list{va});
id=ids(va);

set(hb,'string',num2str(id));
%  reshape(dec2hex([1 1 1]*255, 2)',1, 6)
axes(findobj(gcf,'Type','axes'));
edvalue();

set(gco,'enable','off'); % to allow keyboard outside listbox
drawnow; pause(.1);
set(gco,'enable','on');
axes(findobj(gcf,'Type','axes'));

function edvalue(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
hb=findobj(hf1,'tag','edvalue');
num=str2num(get(hb,'string'));




if num>size(u.colmat,1); %increase number of colors
    u.set.numColors=num;
    set(hf1,'userdata',u);
    def_colors();
    u=get(hf1,'userdata');
end


try
    set(hb,'BackgroundColor',u.colmat(num,:));
catch
    if num>size(u.colmat,1)
        warndlg([...
            ['You want to use ID=' num2str(num) ' which refers to the ' num2str(num) 'th. color.' char(10)]...
            ['BUT: Currently only ' num2str(size(u.colmat,1)) ' colors defined.' char(10)] ...
            ['Solution: Increase number of colors ("numColors") via configuration ' char(10)],...
            ],'INCREASE number of colors');
        uiwait(gcf);

    end
    set(hb,'string','1'); drawnow;
    edvalue([],[]);
    u=get(hf1,'userdata');
end

hdot=findobj(hf1,'tag','dot');
if num==0; return; end
set(hdot,'FaceColor',u.colmat(num,:));
set_idlist();
axes(findobj(gcf,'Type','axes'));


function  x=transpoflip(x,dirs)
% transpose and flipud check
hf1=findobj(0,'tag','xpainter');

if strcmp(dirs,'f') %forward
    %% transpose
    htran=findobj(hf1,'tag','rd_transpose');
    doTrans=get(htran,'value');
    if doTrans==1
        x=permute(x, [2 1 3]);
    end
    %% flipud
    hflip=findobj(hf1,'tag','rd_flipud');
    if get(hflip,'value')==1
        x=flipud(x);
    end
elseif strcmp(dirs,'b'); %back
    %% flipud
    hflip=findobj(hf1,'tag','rd_flipud');
    if get(hflip,'value')==1
        x=flipud(x);
    end
    %% transpose
    htran=findobj(hf1,'tag','rd_transpose');
    doTrans=get(htran,'value');
    if doTrans==1
        x=permute(x, [2 1 3]);
    end
    
end






function cb_fill(e,e2)
set(gcf,'WindowButtonMotionFcn', []);
hl=findobj(gcf,'tag','undo'); %set togglebut to painting
if get(hl,'value')==1; set(hl,'value',0); end

% va=get(e,'value');
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');


r1=getslice2d(u.b);

r1=transpoflip(r1,'f');

bk=r1;

[x y]=ginput(1);

selstop([],[]);
selstop([],[]);
selstop([],[]);

hed=findobj(hf1,'tag','edvalue');
id=str2num(get(hed,'string'))
r1=r1==id;

sm=strel('disk',1);
%  r2=imerode( imdilate( r1  ,sm)  ,sm);
r2=imclose( r1  ,sm) ;
warning off;
r3=imfill(im2bw(r2),[round(y) round(x) ],8);
r4=bwlabel(r3);
clustnum=r4(round(y), round(x));
val=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
r5=bk;
r5(r4==clustnum)=val;

r5=transpoflip(r5,'b');
u=putsliceinto3d(u,r5,'b');
set(gcf,'userdata',u);
set(gcf,'WindowButtonMotionFcn', {@motion,1});
setslice([],'moox');



function cb_clear(e,e2)
hf1=findobj(0,'tag','xpainter');
hb=findobj(hf1,'tag','clear mask');
va=get(hb,'value');
% va=get(e,'value');
u=get(hf1,'userdata');
% him=findobj(hf1,'type','image');
r2=getslice2d(u.b)*0;
% set(him,'cdata',   r2  );
u=putsliceinto3d(u,r2,'b');
set(gcf,'userdata',u);


if va==2
    u.b=u.b.*0;
    set(gcf,'userdata',u);
end

setslice();

function pb_help(e,e2)
uhelp(mfilename);

% ==============================================
%%   save
% ===============================================

function pb_save(e,e2)
hf=findobj(0,'tag','xpainter');


so=findobj(hf,'tag','pb_saveoptions');
li=get(so,'string'); va=get(so,'value');
saveop=li{va};
% ==============================================
%%   maskman
% ===============================================

if ~isempty(strfind(saveop,'Advanced saving options'))
    
    hf1=findobj(0,'tag','xpainter');
    u=get(hf1,'userdata');
    v.f1    =  u.f1;
    v.f2    =  u.f2;
    
    v.ha     = u.ha;
    v.a      = u.a;
    v.hb     = u.hb;
    v.b      = u.b;
    
    v.colmat = u.colmat;
    
    maskman(v); %opens mask-saving window
    return
end

if ~isempty(strfind(saveop,'older')); return; end



u=get(hf,'userdata');
[fi pa]=uiputfile(fullfile(fileparts(u.f1),'*.nii'),'save new mask as..');
if isnumeric(fi);
    return;
end

if max(unique(u.b))<=255
    dt=[2 0];
else
    dt=[16 0];
end

% ==============================================
%%   other options
% ===============================================
 if  ~isempty(regexpi(saveop,'\[sm\]'))
    %     11
    c=u.b;
elseif ~isempty(regexpi(saveop,'\[smi00\]'))
    %     22
    m=u.b>0;
    c=u.a.*m;
    dt=u.ha.dt;
elseif ~isempty(regexpi(saveop,'\[smi0m\]'))
    %     33
    m=u.b>0;
    c=u.a.*m+(m==0).*mean(u.a(:));
    dt=u.ha.dt;
elseif ~isempty(regexpi(saveop,'\[smi10\]'))
    %     44
    m=~(u.b>0);
    c=u.a.*m;
    dt=u.ha.dt;
elseif ~isempty(regexpi(saveop,'\[smi1m\]'))
    % 55
    m=~(u.b>0);
    val=mean(u.a(m==1));
    
    if isnan(val);
        warndlg({'no mask found' '..saving step aborted..'});
        return
    end
    c=u.a.*m+(m==0).*val;
    dt=u.ha.dt;
elseif ~isempty(regexpi(saveop,'\[smi1nv\]')) || ~isempty(regexpi(saveop,'\[smi0nv\]'))
    m=double(~(u.b>0));
    if ~isempty(regexpi(saveop,'\[smi0nv\]'))
        m=~m;
    else
        for i=1:size(m,3)
            m(:,:,i)=imfill(m(:,:,i),'holes');
            m(:,:,i)=imerode(m(:,:,i),strel('disk',2));
        end
    end
    m(m==0)=nan;
    as=u.a.*m;
    af=snip_inpaintn(as,10);
    %montage2(af); title('fil')
    
    c=af;
    dt=u.ha.dt;
else
    fileout=fullfile(pa,fi);
    save_specific(fileout);
    return
    
    
end

% montage2(c);

% [smi00]
% [smi0m]
%  [smi10]
% [smi1m]

% ==============================================
% save
% ===============================================
newmask=fullfile(pa,fi);
% rsavenii(newmask,u.hb,c,dt);
rsavenii(newmask,u.ha,c);

try
    showinfo2('new mask',u.f1,newmask,13);
end



function save_specific(fileout)

fg
set(gcf,'menubar','none','tag','savespec')












function pb_legend(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(gcf,'userdata');
uni=unique(u.b(:)); uni(uni==0)=[];
nvox=histc(u.b(:),uni);
vol=abs(det(u.ha.mat(1:3,1:3)) *(nvox));
hold on;
if isempty(uni)
    pl(1) = plot(nan,nan,'ko','markerfacecolor',[1 0 1]);
    lgstr={'there is nothing drawn in mask'};
else
    lgstr={};
    for i=1:length(uni)
        pl(i) = plot(nan,nan,'ko','markerfacecolor',u.colmat(uni(i),:));
        lgstr{end+1} = sprintf('%d] \t#%d voxel,\t %5.3f qmm\t', uni(i),nvox(i),vol(i));
    end
    %     lgstr=cellstr([num2str(uni) ]);
end

le=legend(pl,lgstr,'fontsize',5);
set(le,'Location','northeast','tag','xlegend');
pos=get(le,'position');
set(le,'position',[pos(1)-.05 pos(2)-.1 pos(3:4)])
% pos=get(le,'position');
% pos(3)=pos(3)/5;
% set(le,'position',pos);
% set(le,'Color','none','TextColor',[ 0.9294    0.6941    0.1255],'fontweight','bold');
set(le,'Color','k','TextColor',[ 0.9294    0.6941    0.1255],'fontweight','bold');
if get(findobj(gcf,'tag','pb_legend'),'value')==0
    try; delete(findobj(gcf,'tag','xlegend')); end
end

% ==============================================
%%
% ===============================================
function pb_slicewiseInfo(e,e2)
% ==============================================
%%
% ===============================================

hf1=findobj(0,'tag','xpainter');
u=get(gcf,'userdata');
uni=unique(u.b(:)); uni(uni==0)=[];
nvox=histc(u.b(:),uni);
vol=abs(det(u.ha.mat(1:3,1:3)) *(nvox));
hold on;
if isempty(uni)
    lgstr={'there is nothing drawn in mask'};
else
    lgstr={};
    for i=1:length(uni)
        lgstr{end+1,1} = sprintf('ID: %3d] \t#%5d voxel,\t %5.3f qmm\t', uni(i),nvox(i),vol(i));
    end
    %     lgstr=cellstr([num2str(uni) ]);
end
hb=findobj(hf1,'tag','rd_changedim');
dimlist=get(hb,'string');
dimval=get(hb,'value');
dim=str2num(dimlist{dimval});


c=u.b;
c=permute(c,[setdiff([1:3],dim)  dim]);
c=reshape(c,[ size(c,1)*size(c,2) size(c,3)]);
siv=abs(det(u.ha.mat(1:3,1:3)));
% ==============================================
%
% ===============================================

g1={};

sortid=[];
for j=1:size(c,2)
    nvox2 =histc(c(:,j),uni);
    vol2  =siv*nvox2;
    
    for i=1:length(uni)
        if nvox2(i)>0
            g1{end+1,1} = sprintf('slice-%2d  ID-%3d] \t#%5d voxel   \t\t\t %5.3f qmm\t',j, uni(i),nvox2(i),vol2(i));
            sortid(end+1,1)=uni(i);
        end
    end
end
% disp(g1)


z={};
z{end+1,1}=[' #ok *** global info ***'];
z{end+1,1}=       [' #b File      : '  u.f1];
z{end+1,1}=sprintf('        DIM: %dx%dx%d', u.ha.dim(1),u.ha.dim(2),u.ha.dim(3));
voxmm=abs(diag(u.ha.mat(1:3,1:3)));
z{end+1,1}=sprintf('VoxSize[mm]: %2.3f   %2.3f   %2.3f   ', voxmm(1),voxmm(2),voxmm(3));
z{end+1,1}=sprintf('   DataType: %d %d    ', u.ha.dt);

z1=plog([],u.ha.mat,0,'mat (header)'); %MAT

z=[z; z1];
z{end+1,1}='';

z{end+1,1}=[' #ld *** IDs within entire volume (MASK) ***'];
z=[z; lgstr ];
z{end+1,1}='';

if ~isempty(g1)
    g2= sortrows([num2cell(sortid) g1],1) ;%sorted by ID
    g2=g2(:,2);
    z{end+1,1}=[' #ld *** IDs slice-wise info (MASK) ***'];
    z{end+1,1}=[' #b used DIM   : '  num2str(dim)];
    z=[z; g2 ];
end
uhelp(z);

% ==============================================
%%
% ===============================================



% ==============================================
%%
% ===============================================
function cb_setslice(e,e2,par)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
if strcmp(par,'-1')
    
    if u.useslice>1
        u.useslice=u.useslice-1;
    end
elseif strcmp(par,'+1')
    if u.useslice<u.dim(u.usedim)
        u.useslice=u.useslice+1;
    end
elseif strcmp(par,'ed')
    sl=str2num(get(findobj(hf1,'tag'  ,'edslice'),'string'));
    if sl>0 && sl<=u.dim(u.usedim)
        u.useslice=sl;
    end
end
borderDel();
u.lastslices(u.usedim)=u.useslice;
u.boundary=[];
u.isboundarySet=0;

set(gcf,'userdata',u);
setslice();
% try;          setfocus(gca);   end         % deFocus edit-fields



function rd_axisnormal(e,e2)
setslice([],1);

function pop_changedim(e,e2)
e=findobj(gcf,'tag','rd_changedim');
li=get(e,'string');
va=get(e,'value');
newdim=str2num(li{va});
u=get(gcf,'userdata');
u.usedim=newdim;
u.useslice=u.lastslices(u.usedim) ;% round(u.dim(u.usedim)/2);
set(gcf,'userdata',u);
set(findobj(gcf,'tag','edslice'),'string',num2str(u.useslice));
setslice();

function rd_dottype(e,e2)
definedot([],[]);

function edalpha(e,e2,par)

%  set(e,'enable','off'); drawnow;pause(.1); set(e,'enable','on'); drawnow;
% try;          setfocus(findobj(gcf,'tag','waitnow'));   end         % deFocus edit-fields

u=get(gcf,'userdata');
u.alpha=str2num(get(e,'string'));
set(gcf,'userdata',u);
set(e,'string',num2str(u.alpha));
% set(e,'enable','off'); drawnow;pause(.1); set(e,'enable','on'); drawnow;
setslice([],1);

% % set(findobj(gcf,'tag','dot'),'visible','on')
% set(findobj(gcf,'tag','dot'),'visible','off','userdata',0);
% setfocus(gca); drawnow
% set(findobj(gcf,'tag','dot'),'visible','on','userdata',0);


% try;          setfocus(findobj(gcf,'tag','waitnow'));   end         % deFocus edit-fields
% sel();
% selstop();
% set(findobj(gcf,'tag','dot'),'visible','on');
% selstop();
% set(e,'KeyPressFcn',@keys);











function selup(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
set(hd,'edgecolor','k');
'w'

function selectarea(e,e2)
set(gcf,'WindowButtonMotionFcn', {@motion,1})
% set( findobj(gcf,'tag','selectarea') ,'backgroundcolor',[ 1.0000    0.8431         0]);
% set( findobj(gcf,'tag','undo') ,'backgroundcolor',[ 1 1 1]);

function undo(e,e2)
e=findobj(gcf,'tag','undo');
if get(e,'value')==1 % UNPAINT
    set(gcf,'WindowButtonMotionFcn', {@motion,2});
    set(e,'backgroundcolor',[1.0000    0.8431         0]);
    % set( findobj(gcf,'tag','undo') ,'backgroundcolor',[ 1.0000    0.8431         0]);
    % set( findobj(gcf,'tag','selectarea') ,'backgroundcolor',[ 1 1 1]);
else           %DRAW
    set(gcf,'WindowButtonMotionFcn', {@motion,1});
    set(e,'backgroundcolor',[.94 .94 .94]);
end
% ==============================================
%%
% ===============================================

function definedot(e,e2)
hf1=findobj(0,'tag','xpainter');
hc=findobj(hf1,'tag','dotsize');
va=get(hc,'value');
li=get(hc,'string');
dia=str2num(li{va});

hdot=findobj(hf1,'tag','dot');
if isempty(hdot)
    colix=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
    u=get(gcf,'userdata');
    col=u.colmat(colix,:);
else
    try
        col=get(hdot,'facecolor');
    catch
        col=get(hdot(1),'facecolor');
    end
end


try; delete(findobj(hf1,'tag','dot')); end
r=dia/2;
th = 0:pi/50:2*pi;
x = r * cos(th) ;
y = r * sin(th) ;
z = x*0;

if get(findobj(hf1,'tag','rd_dottype'),'value')==2;
    x=[-r r r -r];     y=[-r -r r r];
    z=x*0;
elseif get(findobj(hf1,'tag','rd_dottype'),'value')==3;
    x=[-r r r -r];    y=[1 1 2 2];
    z=x*0;
elseif get(findobj(hf1,'tag','rd_dottype'),'value')==4;
    x=[1 2 2 1];  y=[ -r -r r r];
    z=x*0;
end
co=get(gca,'CurrentPoint');
co=co(1,[1 2]);
x=x+co(1);
y=y+co(2);

hd = patch(x,y,z,'g','tag','dot');
set(hd,'facecolor',col);
set(hd  ,'ButtonDownFcn', @sel);
set(hd,'userdata',0);
set(hd,'hittest','off');


u=get(hf1,'userdata');
u.dotsize=dia;
set(hf1,'userdata',u);


% function isDoubleclick=DoubleClick_check()
% isDoubleclick=0;
% persistent chk
% if isempty(chk)
%       chk = 1;
%       pause(.3); %Add a delay to distinguish single click from a double click
%       if chk == 1
%           fprintf(1,'\nI am doing a single-click.\n\n');
%           isDoubleclick=0;
%           chk = [];
%            set(findobj(gcf,'tag','dot'),'userdata',0);
%       end
%       %selstop([])
%
% else
%       chk = [];
%       fprintf(1,'\nI am doing a double-click.\n\n');
%       isDoubleclick=1;
%       selstop([])
% end

function isDoubleclick=DoubleClick_check()
isDoubleclick=0;
persistent chk
if isempty(chk)
    chk = 1;
    pause(.3); %Add a delay to distinguish single click from a double click
    if chk == 1
        fprintf(1,'\nI am doing a single-click.\n\n');
        isDoubleclick=0;
        chk = [];
        set(findobj(gcf,'tag','dot'),'userdata',0);
    end
    %selstop([])
    
else
    chk = [];
    fprintf(1,'\nI am doing a double-click.\n\n');
    isDoubleclick=1;
    selstop([])
end





function buttondown(e,e2,par)
% '##'
global currpo
hf1=findobj(0,'tag','xpainter');
hax=findobj(hf1,'type','axes');
co=get(hax,'CurrentPoint');
currpo.co=round(co(1,[1 2]));
% disp(currpo.co);


% ==============================================
%% Button down
% ===============================================
function sel(e,e2)

% isDoubleclick=DoubleClick_check();

% global lastclicktime
% lastclicktime(end+1,1)=toc(lastclicktime(end))


% global lastclicktime
% lastclicktime.obj=tic
% lastclicktime.time=toc(lastclicktime.obj);
% lastclicktime
% ==============================================
%%
% ===============================================
global lastclicktime
lastclicktime.time(end+1,1)=toc(lastclicktime.obj);%-lastclicktime.time(end)   ;%-lastclicktime.time(end,1)

% disp(lastclicktime.time);

% ==============================================
%%
% ===============================================


% return

hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
col=u.colmat(str2num(get(findobj(hf1,'tag','edvalue'),'string')),:);
hd=findobj(hf1,'tag','dot');
set(hd,'FaceColor',col,'edgecolor','k');
set(hd,'userdata',1);
if get(findobj(gcf,'tag','undo'),'value')==0   %PAINT -BTN-DOWN
    % '#1start'
    getImage();  %######
    set(hd,'FaceColor',col,'edgecolor','w');
    motion([],[], 1);
    % '#1end'
else                                          %UNPAINT-BTN-DOWN
    % '#2start'
    getImage();   %######
    set(hd,'FaceColor',col,'edgecolor','g');
    motion([],[], 2);
    
    % '#2end'
end
% ==============================================
%% Button up
% ===============================================
function selstop(e,e2)
%  'b'
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');

% if u.isboundarySet==1
%     global SLICE
%     
%     v1=SLICE.r2;
%     v2=SLICE.r2BK;
%     v1(v2~=0)=0;
%     if ~isempty(u.boundary)
%         u.boundary=u.boundary+v1;
%     else
%         u.boundary=v1;
%     end
%     %aggregate lines
%     p=(findobj(hf1,'tag','border'));
%     xy=[p.XData; p.YData]';
%     g=plot(xy(:,1),xy(:,2),'-r.','tag','border2','hittest','off','color',u.boundarycolor);
%     delete(p);
%     set(findobj(gcf,'tag','addBorder'),'BackgroundColor',[1 1 1]);
%     
%     u.isboundarySet=0;
%     set(hf1,'userdata',u);
% end

ismeasure=get(findobj(hf1,'tag','pb_measureDistance'),'value');
% if ismeasure==1; return; end

putImage(); %######

col=u.colmat(str2num(get(findobj(hf1,'tag','edvalue'),'string')),:);
hd=findobj(gcf,'tag','dot');
set(hd,'FaceColor',col,'edgecolor','k');
set(hd,'userdata',0);

u=get(gcf,'userdata');
set(gcf,'userdata',u);

% global lastmovecords
% lastmovecords=[];



xylim=[xlim ylim];
co=get(gca,'currentpoint');
if co(1,1)<xylim(2) && co(1,2)>0
    %disp('inIMAGE')
    %---make history
    r2=getslice2d(u.b);
    if sum(any(u.hist(:,:,u.histpointer)-r2))~=0
        u.histpointer=u.histpointer+1;
        u.hist(:,:,u.histpointer)=r2;
        u.hist(:,:,u.histpointer+1:end)=[]; %remove older stuff
        set(gcf,'userdata',u);
    end
end
undo_redolabel_update();
% ==============================================
%%  button-DOWN: put current image to u-struct for drawing
% ===============================================
function getImage()
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');

r1=getslice2d(u.a);
r2=getslice2d(u.b);
r1=adjustIntensity(r1);

% ax=getslice2d(u.ax);
% ay=getslice2d(u.ay);
% az=getslice2d(u.az);

global SLICE
SLICE.r1=r1;
SLICE.r2=r2;

% SLICE.ax=ax;
% SLICE.ay=ay;
% SLICE.az=az;
%
% 'now'

% ==============================================
%%  button-UP: put current image to 3d-mask
% ===============================================
function putImage();
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
% r2n=u.r2;
% u=putsliceinto3d(u,r2n,'b');
% set(hf1,'userdata',u);

global SLICE
try
    if isempty(SLICE.r2)
        keyboard
    end
    r2n=SLICE.r2;
    u=putsliceinto3d(u,r2n,'b');
    set(hf1,'userdata',u);
catch
    return
end

% ==============================================
%% MOTION
% ===============================================
function motion(e,e2, type)

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if 0 %OLD FUN
    if any(cell2mat(regexp({'uipanel','uicontrol'},get(hunderpointer,'type'))))==1 ...
            || strcmp(get(hunderpointer,'type'),'patch')
        %     && strcmp(get(hunderpointer,'tag'),'dot')~=1 ...
        %         && strcmp(get(hunderpointer,'type'),'figure')~=1
        % disp(get(hunderpointer,'style'));
        % disp(get(hunderpointer,'type'));
        showDot=0;
        set(hf1,'Pointer','hand');
        
        set(hdot,'visible','off');
    end
end

hf1=findobj(0,'tag','xpainter');
hunderpointer=hittest(hf1);
% disp([get(hunderpointer,'tag') ' - ' get(hunderpointer,'type') ]);

if strcmp(get(hunderpointer,'type'),'figure') || strcmp(get(hunderpointer,'type'),'image')
    % IN IMAGE to draw
else
    % SOMETHING ELSE
    showDot=0;
    set(hf1,'Pointer','hand');
    hdot=findobj(hf1,'tag','dot');
    set(hdot,'visible','off');
    return
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

hf1=findobj(0,'tag','xpainter');


ismeasure=get(findobj(hf1,'tag','pb_measureDistance'),'value');
% if ismeasure==1; return; end


u=get(hf1,'userdata');
hax=findobj(hf1,'type','axes');
co=get(hax,'CurrentPoint');
try
    co=co(1,[1 2]);
catch
    return
end
axlim=[get(hax,'xlim') get(hax,'ylim')];
showDot=0;
% set(gcf,'pointer','arrow');
if co(1)<1 || co(2)<1 || co(1)>axlim(2)  %1 | co(2)<1
    set(hf1,'Pointer','arrow');
    %'yes'
else
    %vp=nan(16,16);
    showDot=1;
    set(hf1, 'Pointer', 'custom', 'PointerShapeCData', NaN(16,16));
    %'no'
end

hdot=findobj(hf1,'tag','dot');
set(hdot,'visible','on');
% --------over object
% hAxes = overobj('axes');
% disp(hAxes);


% % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% if 0 %OLD FUN
%     if any(cell2mat(regexp({'uipanel','uicontrol'},get(hunderpointer,'type'))))==1 ...
%             || strcmp(get(hunderpointer,'type'),'patch')
%         %     && strcmp(get(hunderpointer,'tag'),'dot')~=1 ...
%         %         && strcmp(get(hunderpointer,'type'),'figure')~=1
%         % disp(get(hunderpointer,'style'));
%         % disp(get(hunderpointer,'type'));
%         showDot=0;
%         set(hf1,'Pointer','hand');
%
%         set(hdot,'visible','off');
%     end
% end
%
% hunderpointer=hittest(hf1);
% % disp([get(hunderpointer,'tag') ' - ' get(hunderpointer,'type') ]);
%
% if strcmp(get(hunderpointer,'type'),'figure') || strcmp(get(hunderpointer,'type'),'image')
%     % IN IMAGE to draw
% else
%     % SOMETHING ELSE
%     showDot=0;
%     set(hf1,'Pointer','hand');
%     set(hdot,'visible','off');
%     return
% end










% % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

global SLICE
r1=SLICE.r1;
r2=SLICE.r2;
%         r1=u.r1;
%         r2=u.r2;
if 0 % OUTSOURCED
    r1=getslice2d(u.a);
    r2=getslice2d(u.b);
end
% ----------------------------------------------------
%% transpose
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    %x=permute(r2, [2 1 3]);
    r1=r1';
    r2=r2';
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r1=flipud(r1);
    r2=flipud(r2);
end


% % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% -----mm info
if  get(findobj(hf1,'tag','rb_showcoordinates'),'value')==1
    hw=findobj(hf1,'tag','infobox');
    %     set(hw,'visible','on');
    %     uistack(hw,'top');
    try
        ip=round(co);
        mm=[u.slice_ax(ip(2),ip(1)) u.slice_ay(ip(2),ip(1)) u.slice_az(ip(2),ip(1))];
        mm=['mm: ' sprintf('%2.2f ',mm) ];

%         global SLICE
        set(hw,'string',{...
        mm; ...
       [' val: ' num2str(r1(ip(2),ip(1)) )  '; ' num2str(r2(ip(2),ip(1)) )   ] ...
      });

    end
    
end


hf1=findobj(0,'tag','xpainter');
hd=findobj(hf1,'tag','dot');
% if u.isboundarySet==1;
%     hd.FaceColor=u.boundarycolor;
% end

xx=get(hd,'XData');
yy=get(hd,'yData');
xs=(xx-mean(xx))+2;
ys=(yy-mean(yy))+2;
x=xs+co(1);
y=ys+co(2);

set(hd,'xdata',x,'ydata',y);

if get(hd,'userdata')==1  %PAINT NOW ---button down
    u=get(hf1,'userdata');
    x2=get(hd,'XData'); % get POINTS of coursor/dot
    y2=get(hd,'yData');
    dims = u.dim(setdiff(1:3,u.usedim));
    if get(findobj(hf1,'tag','rd_transpose'),'value')==1
        bw   = double(poly2mask(x2,y2,dims(2),dims(1)));
    else
        bw   = double(poly2mask(x2,y2,dims(1),dims(2)));
    end
    
%     [click]    (normal)     : paint/unpaint brush-form region
%     [double+click] (open)   : fill ROI
%     [alt+click] (alt) : remove ROI
%     [cmd+click] (extend)    : fill ROI via contour
    
    seltype=get(gcf,'SelectionType');
%     disp(seltype);
%     disp(get(gcf,'CurrentCharacter'));
    if strcmp(seltype,'open') || strcmp(seltype,'alt')
        bw=bw.*0;
    end
    
    %% type: drfines whether to paint/unpaint
    if type~=0 %PAINT
        
% % % % % %         global SLICE
% % % % % %         r1=SLICE.r1;
% % % % % %         r2=SLICE.r2;
% % % % % %         %         r1=u.r1;
% % % % % %         %         r2=u.r2;
% % % % % %         if 0 % OUTSOURCED
% % % % % %             r1=getslice2d(u.a);
% % % % % %             r2=getslice2d(u.b);
% % % % % %         end
% % % % % %         % ----------------------------------------------------
% % % % % %         %% transpose
% % % % % %         if get(findobj(hf1,'tag','rd_transpose'),'value')==1
% % % % % %             %x=permute(r2, [2 1 3]);
% % % % % %             r1=r1';
% % % % % %             r2=r2';
% % % % % %         end
% % % % % %         if get(findobj(hf1,'tag','rd_flipud'),'value')==1
% % % % % %             r1=flipud(r1);
% % % % % %             r2=flipud(r2);
% % % % % %         end
        % ----------------------------------------------------
        seltype=get(gcf,'SelectionType');
        
        si=size(r2);
        
        if strcmp(seltype,'extend')==0 % do ..if not shift+left m-button is pressed
            r2=r2(:);
            if type==1
                %             if filltype==0
                r2(bw==1)  =  str2num(get(findobj(hf1,'tag','edvalue'),'string'))  ;
                %             else
                
                %             end
                
            elseif type==2
                r2(bw==1)  =  0;
            end
            %---------------
            r2=reshape(r2,si);
        end
        %% ==============================================
        %%  double click --> fill
        % ===============================================
        
        if strcmp(seltype,'open') || strcmp(seltype,'alt')
            if strcmp(seltype,'open')
                
                filltype=get(findobj(hf1,'tag','rb_filltype'),'value');
                
                
                dims = u.dim(setdiff(1:3,u.usedim));
                if get(findobj(hf1,'tag','rd_transpose'),'value')==1
                    bw   = double(poly2mask(x2,y2,dims(2),dims(1)));
                else
                    bw   = double(poly2mask(x2,y2,dims(1),dims(2)));
                end
                errmsk=imdilate(bw, strel('disk',3))  ~=0; %from single click
                
                
                w1=r2;
                %                 w1=w1.*~errmsk;
                
                [x1 y1]=find(  w1~=0);
                cp=[x1 y1];
                cp2=[round(co(2)),round(co(1))];
                dist=sqrt(sum((cp-repmat(cp2,[size(cp,1) 1])).^2,2));
                imin=min(find(dist==min(dist)));
                
                inearest=cp(imin,:);
                if isempty(inearest); return; end
                
                w1(inearest(1),inearest(2));
                id=w1(inearest(1),inearest(2));
                
                idmask=w1>0;%==id;
                
                other=w1.*~idmask;
                fus=idmask+other;
                fill=imfill(fus,'holes');
                v1=imclose(fill,strel('disk',3));
                v2=imfill(v1);
                in=v2-idmask;
                
                isfill_local=get(findobj(hf1,'tag','rb_filllocal'),'value');
                if isfill_local==0 % fill entire ROI
                    u1=w1==id;
                    %w1=u1+in;
                    u2=(in+2*u1+fill*3)>3;
                    in=u2;
                    
                end
                %                 keyboard
                %                 other=w1.*~idmask;
                %                 fus=idmask+other;
                %                 fill=imfill(fus,'holes');
                %                 in=(fill-idmask);
                in=imfill(in,'holes');
                
                cl=bwlabeln(in,4);
                clustnum=cl(round(co(2)),round(co(1))  );
             
                if isfill_local==1
                    if clustnum==0
                        return
                        %[bk(1,1) bk(1,end)  bk(end,1) bk(end,end)]
                    end
                end

                cl2=cl==clustnum;
                
                bk=w1;
                if filltype==0
                    bk(cl2==1)=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
                else
                    bk(cl2==1)=id;
                end 
                r2=bk;     
            elseif strcmp(seltype,'alt')
                % ==============================================
                %%  remove object via right click
                % ===============================================
                
                %disp(['now-' num2str(rand(1))]);
                value=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
%                 try
%                     value=r2(round(co(2)),round(co(1))  );
%                 catch
%                     return
%                     
%                 end
                m1=r2==value;
                r2(m1==1)=0;
                
                
                m4=bwlabeln(m1);
                xcl=[];
                [xcl(:,1)  xcl(:,2)]=find(m4>0);
                cc=round(co);
                dis=sqrt( (xcl(:,1)-cc(2)).^2+(xcl(:,2)-cc(1)).^2  );%distance
                ix=min(find(dis==min(dis)));
                
                %min(dis)
                if isempty(ix); return; end %nothing to delete
                if min(dis)>12 ; return; end %distance to next object is to large
                
                clustnum=m4(xcl(ix,1),xcl(ix,2));
                m5=m1;
                
                
                 
                m5(m4==clustnum)=0;
                r2(m5==1)=value;
                
                if 0
                    x2=mean(x); y2=mean(y);
                    sm=strel('disk',1);
                    %  r2=imerode( imdilate( r1  ,sm)  ,sm);
                    m2=m1;%imclose( m1  ,sm) ;
                    warning off;
                    m3=imfill(m2,'holes');
                    m4=bwlabel(m3);
                    try
                        clustnum=m4(round(y2), round(x2));
                    catch
                        return
                    end
                    m5=m1;
                    
                    
                    if 0
                        [xcl(:,1)  xcl(:,2)]=find(cm>0);
                        dis=( (xcl(:,1)-cc(2)).^2+(xcl(:,2)-cc(1)).^2  );%distance
                        ix=min(find(dis==min(dis)));
                        thisclust=cm(xcl(ix,1),xcl(ix,2));
                    end
                
                
                
                m5(m4==clustnum)=0;
                r2(m5==1)=value;
                end
            end
        elseif strcmp(seltype,'extend')              % ### 
            % ==============================================
            %%   FILL CONTOURLINE
            % ===============================================
            value=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
            
            hp3 =findobj(gcf,'tag','panel3'); %panel3
            hvis=findobj(hp3,'tag','thresh_visible');
            if get(hvis,'value')==1  ; %PNAEL 3
                hs=findobj(gcf,'tag','slid_thresh');
                %               thresh=get(hs,'value')
                %               c=contourc(double(u.bg2d>thresh),1);
                c=get(hs,'userdata');% get thresholded contourData  
            else
                bg=u.bg2d;
                bg([1 end],:)=0; bg(:,[1 end])=0;
                c=contourc(bg,u.contourlines);
            end
            
            c2=contourdata(c);
            cc=round(co);
%             cc
            %levx=u.bg2d(cc(1),cc(2));
            
            cm=zeros(size(u.bg2d));
            ml=cm;
            for i=1:length(c2)
                %[c2(i).xdata c2(i).ydata]-repmat(cc,[length(c2(i).xdata) 1]);
                ml   = double(poly2mask(c2(i).xdata,c2(i).ydata,size(cm,1),size(cm,2)));
                cm(ml==1)=i;
            end
            
            
%             m1=cm==cm(cc(2),cc(1));
%             if m1(1,1)==1 && m1(1,end)==1 &&  m1(end,1)==1 && m1(end,end)==1 %target not hitted
%                 
                [xcl(:,1)  xcl(:,2)]=find(cm>0);
                dis=( (xcl(:,1)-cc(2)).^2+(xcl(:,2)-cc(1)).^2  );%distance
                ix=min(find(dis==min(dis)));
                thisclust=cm(xcl(ix,1),xcl(ix,2));
                m1=cm==thisclust;
            %end
            if 1%u.isboundarySet==1
                m2=m1;
                
                hl=(findobj(hf1,'tag','border2'));
                mx=zeros(size(cm));
                if ~isempty(hl)
                    for j=1:length(hl)
                        xy=[hl(j).XData; hl(j).YData]';
                        %xy=unique(round(xy),'rows');
                        mm=xy;
                        mm=interpCC(mm,1);
                        mm=round(mm);
                        linx = sub2ind(size(cm), mm(:,1), mm(:,2));
                        mx(linx)=1;
                    end
                end
                
                mx=mx';
                
                
%                 %mx=u.boundary;
%                 if get(findobj(hf1,'tag','rd_flipud'),'value')==1
%                     mx=flipud(mx);
%                 end
%                 if get(findobj(hf1,'tag','rd_transpose'),'value')==1
%                     mx=mx';
%                 end
        
                m2(mx~=0)=0;
                m3=bwlabeln(m2,4);
                m4=m3==m3(round(co(2)),round(co(1)));
                m1=m4;
                
                %r2(mx~=0)=0;
                
                %u.histpointer=u.histpointer-1;
                u.hist(:,:,u.histpointer)=0;
                %pb_undoredo([],[],-1); drawnow;
                u.isboundarySet=0;
                u.boundary=[];
            end
            %m1=cm==cm(cc(1),cc(2));
            if get(findobj(gcf,'tag','fillcontourlines'),'value')==1 %fill interour of contour
                m1=imfill(m1,'holes');
            end
            %m1=imdilate(m1,strel('disk',1));

            if get(findobj(hf1,'tag','thresh_visible'),'value')==1
                
            else
%                 m1=imdilate(m1,strel('disk',1));
%                 m1=imfill(m1,'holes');
%                 m1=imerode(m1,strel('disk',1));
            end
            
            status_cont1 =get(findobj(hf1,'tag','thresh_visible'),'value');
            status_cont2 =get(findobj(hf1,'tag','rd_contourdraw'),'value');
            
            if sum([status_cont1 status_cont2])==0
                return
            end
            
            r2(m1==1)=value;
            
            %[h1 h2 h3]=contourf2(u.bg2d,10);
            %
            %              hc=findobj(gca,'type','contour');
            %             set(hc,'fill','on')
        end
        
        % ==============================================
        %% set value
        % ===============================================
        alp=u.alpha;% .8
        %val=unique(u.b); val(val==0)=[];
        val=get(findobj(hf1,'tag','pb_idlist'),'userdata');
        
        
        r2v=r2(:);
        r1=mat2gray(r1);
        ra=repmat(r1,[1 1 3]);
        rb=reshape(zeros(size(ra)), [ size(ra,1)*size(ra,2) 3 ]);
        for i=1:length(val)
            ix=find(r2v==val(i));
            rb( ix ,:)  = repmat(u.colmat(val(i),:), [length(ix) 1] );
        end
        if u.isboundarySet==1
%             if ~isempty(u.boundary)
%                 mx=u.boundary;
%                 if get(findobj(hf1,'tag','rd_flipud'),'value')==1
%                     mx=flipud(mx);
%                 end
%                 if get(findobj(hf1,'tag','rd_transpose'),'value')==1
%                     mx=mx';
%                 end
%                 
                %ix=find(mx~=0);
                %length(ix)
                
                %length(x2)
%                 Mx2=mean(x2);
%                 My2=mean(y2);
%                 fs=5;
%                 xs=((x2-Mx2)/fs)+Mx2;
%                 ys=((y2-My2)/fs)+My2;
%                 plot(xs,ys,'-r.','tag','border','hittest','off','color',[ u.boundarycolor]);
%                 plot(x2,y2,'-r.','tag','border','hittest','off','color',[ u.boundarycolor]);
                
%             end
            return
        end
        
        
        
        s1=reshape(ra,[ size(ra,1)*size(ra,2) 3 ]);
        rm=sum(rb,2);
        im=find(rm~=0);
        %s1(im,:)= (s1(im,:)*alp)+(rb(im,:)*(1-alp)) ;
        s1(im,:)= (s1(im,:)*(1-alp))+(rb(im,:)*(alp)) ;
        x=reshape(s1,size(ra));
        set(u.him,'cdata',   x  );
        
        r2n=r2;
        if get(findobj(hf1,'tag','rd_flipud'),'value')==1
            r2n=flipud(r2n);
        end
        if get(findobj(hf1,'tag','rd_transpose'),'value')==1
            r2n=r2n';
        end
        % ==============================================
        %%   %% outsource
        % ===============================================
        %u.r2=r2n;
        global SLICE
        SLICE.r2=r2n;
        if strcmp(seltype,'extend')
                    u=putsliceinto3d(u,r2n,'b');
                    set(hf1,'userdata',u);
        end
    end  %type
    
    %     global lastmovecords
    %     lastmovecords=co;
end

function borderAdd(e,e2)
boundary_set();

function borderDel(e,e2)
hf1=findobj(0,'tag','xpainter');
delete(findobj(hf1,'tag','border'));
delete(findobj(hf1,'tag','border2'));

function u=putsliceinto3d(u,d2,varnarname)
% u=putsliceinto3d(u,r2,'b');
dum=getfield(u,varnarname);
% try
if u.usedim==1
    dum(u.useslice,:,:)=d2;
elseif u.usedim==2
    dum(:,u.useslice,:)=d2;
elseif u.usedim==3
    dum(:,:,u.useslice)=d2;
end
u=setfield(u,varnarname,dum);
% end

function imtoolbreak
hf1=findobj(0,'tag','xpainter');
allbut=findobj(hf1,'userdata','imtoolsbutton');
set(allbut,'value',0);

import java.awt.*;
import java.awt.event.*;
rob = java.awt.Robot;
rob.keyPress(KeyEvent.VK_ESCAPE)
pause(.1);
rob.keyRelease(KeyEvent.VK_ESCAPE)

set(gcf,'WindowButtonMotionFcn', {@motion,1});
delete(findobj(hf1,'userdata','imtool'));
disp('imtool break');
delete(findobj(hf1,'userdata','imtool'));

% ==============================================
%%   
% ===============================================
function  imdrawtool_prep(e,e2,type)

hf1=findobj(0,'tag','xpainter');
allbut=findobj(hf1,'userdata','imtoolsbutton');
otherbut=setdiff(allbut,e);
set(otherbut,'value',0); % all other icons set 'OFF'
%  imtoolbreak();

if get(e,'value')==0
    imtoolbreak();
    set(allbut,'enable','on');
else
    set(otherbut,'enable','off');
    set(gcf,'WindowButtonMotionFcn',[]);
    imdrawtool(e,e2, type);
end
set(allbut,'value',0); % all other icons set 'OFF'
set(allbut,'enable','on');
% set(gcf,'WindowButtonMotionFcn', {@motion,1});

hb=findobj(hf1,'tag','undo');
hgfeval(get( hb ,'callback'));

axes(findobj(gcf,'Type','axes'));
uicontrol(findobj(hf1,'tag','preview')); %set focus to allow brush-resize

return
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
if isfield(u,'activetool')==0
    u.activetool=type;
    set(hf1,'userdata',u);
end

if u.activetool==type
    try
        imdrawtool(e,e2, type);
    end
else
    'no'
    allbut=findobj(hf1,'userdata','imtoolsbutton');
    iactive=find(cell2mat(get(allbut,'value')));
    nother=setdiff(allbut,e);
    for i=1:length(iactive)
        typeold=getappdata(allbut(iactive(i)),'toolnr');
        set(allbut(iactive(i)),'value',0);
        imdrawtool(e,e2, typeold);
        %          return
        %hgfeval(get( allbut(iactive(i)) ,'callback'),[],[],typeold);
    end
    if length(nother)==0
        '## no acitve butos'
    else
        '## some active found'
    end
    set(allbut,'value',0);
    
    import java.awt.*;
    import java.awt.event.*;
    rob = java.awt.Robot;
    rob.keyPress(KeyEvent.VK_ESCAPE)
    pause(.1);
    rob.keyRelease(KeyEvent.VK_ESCAPE)
    
    set(gcf,'WindowButtonMotionFcn', {@motion,1});
    delete(findobj(hf1,'userdata','imtool'));
    disp('imtool-off');
    %------------------
    set(e,'value',1);
    u.activetool=type;
    set(hf1,'userdata',u);
    
    %     imdrawtool(e,e2, type);
    
    if length(nother)==0
        '## no acitve butos'
    else
        '## some active found'
        try;
            
            set(e,'value',0)
            %              hgfeval(get( e ,'callback'),e);
            imdrawtool(e,e2, type);
        end
    end
end

% ==============================================
%%
% ===============================================
function imdrawtool(e,e2, type)
if get(e,'value')==0
    return
end
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
% hb=findobj(hf1,'tag','imdraw');
hb=e;
allbut=findobj(hf1,'userdata','imtoolsbutton');
set(setdiff(allbut,e),'value',0); % all other icons set 'OFF'
activeButton=get(hb,'value');
if activeButton==0 %get(hb,'value')==0
    try
        uiresume(hf1);
    end
    import java.awt.*;
    import java.awt.event.*;
    %Create a Robot-object to do the key-pressing
    %    rob=Robot;
    rob = java.awt.Robot;
    %Commands for pressing keys:
    
    rob.keyPress(KeyEvent.VK_ESCAPE)
    pause(.1);
    rob.keyRelease(KeyEvent.VK_ESCAPE)
    
    set(gcf,'WindowButtonMotionFcn', {@motion,1});
    delete(findobj(hf1,'userdata','imtool'));
    %     disp('imtool-off');
    return
    % break
end

do_unpaint=get(findobj(hf1,'tag','undo'),'value');
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
hax=findobj(gcf,'type','axes');

% findobj(hf1,'userdata','imtoolsbutton')
% imellipse | imfreehand | imline | impoint | impoly | imroi | makeConstrainToRectFcn

set(gcf,'WindowButtonUpFcn'     ,[]);
set(findobj(gca,'tag','dot'),'visible','off');
set(gcf,'name','xdraw: drawtool - move mouse');

%  type=6
if type==1
    try; h = imfreehand;
        %     catch; imdrawtool(e,e2, type);
    end
elseif type==2
    try; h=imrect;
        %     catch; imdrawtool(e,e2, type);
    end
elseif type==3
    try; h=imellipse;
        %     catch; imdrawtool(e,e2, type);
    end
elseif type==4
    try; h=impoly;
        %     catch; imdrawtool(e,e2, type);
    end
elseif type==5
    try; h=imline;
        %     catch; imdrawtool(e,e2, type);
    end
elseif type==6
    
        %set(gcf,'WindowButtonDownFcn', []);
        %set(gcf,'WindowButtonUpFcn'     ,[]);
        set(gcf,'WindowButtonMotionFcn', [])
        %set(gcf,'WindowKeyPressFcn', []);
        %set(gcf,'ButtonDownFcn', []);
    
        [hg,x,y] = freehanddraw(gca,'pointer','hand','color',u.boundarycolor,'linewidth',1);
        delete(hg);
        pos=[y x];
        %     pos=[];
        if isempty(pos);
            set(gcf,'WindowButtonDownFcn',  {@buttondown,[]});
            set(gcf,'WindowButtonUpFcn'     ,@selstop);
            set(gcf,'WindowButtonMotionFcn', {@motion,1})
            set(gcf,'WindowKeyPressFcn', {@keys});
            %         uicontrol(findobj(hf1,'tag','preview')); %set focus to allow brush-resize
            %         undo_redolabel_update()
        
        return
    end
    
    dimp= u.dim(setdiff(1:3,u.usedim));
    bo=  double(poly2mask(pos(:,1),pos(:,2),dimp(1),dimp(2)));
    mx=zeros(dimp);
    mm=pos;
    mm=interpCC(mm,1);
    mm=round(mm);
    linx = sub2ind(dimp, mm(:,1), mm(:,2));
    mx(linx)=1;
    bw=mx;
end
set(findobj(gca,'tag','dot'),'visible','on');
set(gcf,'name','xdraw');

set(gcf,'WindowButtonUpFcn'     ,@selstop);
% uiwait(hf1);
% setappdata(h,'imrecttools',1);
try
    set(h,'userdata','imtool');
    try
        u.handleroi=h;
        set(hf1,'userdata',u);
    end
catch
    set(gcf,'WindowButtonMotionFcn', {@motion,1});
    try; delete(h); end
    delete(findobj(hf1,'userdata','imtool'));
    if type~=6
        return
    end
end
if type~=6
    pos = h.getPosition();
    
    y2=pos(:,2);
    x2=pos(:,1);
    
    dims = u.dim(setdiff(1:3,u.usedim));
    bw=createMask(h);
    xm=round(mean(x2));
    ym=round(mean(y2));
    activeIcons_show();
    
    
    uiwait(hf1); %wait for activeIcons.selection
    u=get(hf1,'userdata');
    try; delete(h); end
    if u.activeIcons_do==5 %cancel
        %     imdrawtool(e,e2, type);
        return
    elseif u.activeIcons_do==3 % threshtool
        %'threshtool'
        u.tempmask=bw;
        set(gcf,'userdata',u);
        threshtoolprep();
        return
    elseif u.activeIcons_do==2 %boundary/ege
        % bw=boundarymask(bw);
        bw=bwperim(bw);
    end
end



r1=getslice2d(u.a);
r2=getslice2d(u.b);
r1=adjustIntensity(r1);

% global SLICE
%         r1=SLICE.r1;
%         r2=SLICE.r2;

% ----------------------------------------------------
%% transpose
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    %x=permute(r2, [2 1 3]);
    r1=r1';
    r2=r2';
end
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r1=flipud(r1);
    r2=flipud(r2);
end
% ----------------------------------------------------
si=size(r2);
r2=r2(:);
% if type==1
%     r2(bw==1)  =  str2num(get(findobj(hf1,'tag','edvalue'),'string'))  ;
% elseif type==2
%     r2(bw==1)  =  0;
% end
r2(bw==1)  =  str2num(get(findobj(hf1,'tag','edvalue'),'string'))  ;
r2=reshape(r2,si);

% ==============================================
%%
% ===============================================
value=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
if type~=6
    if u.activeIcons_do==4 %UNPAINT
        r2=r2.*~bw; %UNPAINT
    end
end
alp=u.alpha;% .8
% alp =u.create_distanceMeas;% .8
val=unique(u.b);
val=[val(:) ;value];
val(val==0)=[];
val=unique(val);
r2v=r2(:);
r1=mat2gray(r1);
ra=repmat(r1,[1 1 3]);

rb=reshape(zeros(size(ra)), [ size(ra,1)*size(ra,2) 3 ]);
for i=1:length(val)
    ix=find(r2v==val(i));
    rb( ix ,:)  = repmat(u.colmat(val(i),:), [length(ix) 1] );
end
% rb=reshape(rb,size(ra));
s1=reshape(ra,[ size(ra,1)*size(ra,2) 3 ]);
rm=sum(rb,2);
im=find(rm~=0);
% s1(im,:)= (s1(im,:)*alp)+(rb(im,:)*(1-alp)) ;
s1(im,:)= (s1(im,:)*(1-alp))+(rb(im,:)*(alp)) ;
x=reshape(s1,size(ra));
set(u.him,'cdata',   x  );
r2n=r2;
if get(findobj(hf1,'tag','rd_flipud'),'value')==1
    r2n=flipud(r2n);
end
if get(findobj(hf1,'tag','rd_transpose'),'value')==1
    r2n=r2n';
end
% ==============================================
%%   %% outsource
% ===============================================
%u.r2=r2n;
global SLICE
SLICE.r2=r2n;
u=putsliceinto3d(u,r2n,'b');
% ----history
u.histpointer=u.histpointer+1;
u.hist(:,:,u.histpointer)=r2n;
u.hist(:,:,u.histpointer+1:end)=[]; %remove older stuff
% ------------
set(hf1,'userdata',u);
undo_redolabel_update();
%----------------
try; delete(h); end
% if get(e,'value')==1
% %     imdrawtool_prep(e,e2, type);
% end


function activeIcons_hover(e,e2,par)
hf1=findobj(0,'tag','xpainter');
tag=get(e,'Name');
hc=findobj(hf1,'tag',tag);
hc=hc(1);
if par==1
    set(hc,'backgroundcolor',[1 1 0]);
    set(gcf,'WindowButtonMotionFcn', []);
    set(gcf,'pointer','arrow');
    drawnow;
    lineColor = java.awt.Color(0,.5,0);  % =red
    thickness = 3;  % pixels
    roundedCorners = false;
    newBorder = javax.swing.border.LineBorder(lineColor,thickness,roundedCorners);
    e.setBorder(newBorder);
    drawnow;
else
    set(hc,'backgroundcolor',[1 1 1]);
    set(gcf,'WindowButtonMotionFcn', {@motion,1});
    drawnow;
    lineColor = java.awt.Color(1,0,1);  % =red
    thickness = 3;  % pixels
    roundedCorners = false;
    newBorder = javax.swing.border.LineBorder(lineColor,thickness,roundedCorners);
    e.setBorder(newBorder);
    drawnow;
end


function activeIcons_show();
hf1=findobj(0,'tag','xpainter');
po=get(gcf,'CurrentPoint');
delete(findobj(hf1,'userdata','activeIcons'));
boxsi=0.04;

hc2=[];
po=get(gcf,'CurrentPoint');
hc=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_im_fill');           %SET-next-SLICE
set(hc,'position',[po(1) po(2)+.01 repmat(boxsi,[1 2]) ],'string','f');
set(hc,'tooltipstring','fill region');
hc2(end+1)=hc;

hc=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_im_edge');           %SET-next-SLICE
set(hc,'position',[po(1)+boxsi po(2)+.01 repmat(boxsi,[1 2]) ],'string','e');
set(hc,'tooltipstring','edge rigion/draw boundary only ...do not fill');
hc2(end+1)=hc;

hc=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_im_thresh');           %SET-next-SLICE
set(hc,'position',[po(1)+boxsi*2 po(2)+.01 repmat(boxsi,[1 2]) ],'string','t');
set(hc,'tooltipstring','threshold selected area');
hc2(end+1)=hc;

hc=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_im_del');           %SET-next-SLICE
% set(hc,'position',[po(1)+boxsi*3 po(2)+.01 repmat(boxsi,[1 2]) ],'string','u');
set(hc,'position',  [po(1)         po(2)-boxsi+.01 repmat(boxsi,[1 2]) ],'string','u');
set(hc,'tooltipstring','unpaint rigion');
hc2(end+1)=hc;

hc=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_im_break');           %SET-next-SLICE
% set(hc,'position',[po(1)+boxsi*4 po(2)+.01 repmat(boxsi,[1 2]) ],'string','x');
set(hc,'position',  [po(1)+boxsi*1 po(2)-boxsi+.01 repmat(boxsi,[1 2]) ],'string','x');
set(hc,'tooltipstring','abort...do nothing');
hc2(end+1)=hc;

for i=1:length(hc2)
    hc=hc2(i);
    g=java(findjobj(hc));
    set(g,'MouseEnteredCallback',{@activeIcons_hover,1});
    set(g,'MouseExitedCallback',{@activeIcons_hover,2});
    set(hc,'userdata','activeIcons');
    set(hc,'callback',{@activeIcons_cb,i});
    
    lineColor = java.awt.Color(1,0,1);  % =red
    thickness = 3;  % pixels
    roundedCorners = false;
    newBorder = javax.swing.border.LineBorder(lineColor,thickness,roundedCorners);
    g.setBorder(newBorder);
    
end

function activeIcons_cb(e,e2,par)
% par
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
u.activeIcons_do=par;
set(hf1,'userdata',u);
delete(findobj(hf1,'userdata','activeIcons'));
uiresume(hf1);

%�����������������������������������������������
%%   DISTANCE-TOOL
%�����������������������������������������������
function create_distanceMeas
%create_distanceMeas - Show use of FINDOBJ and TAG property to identify active handle
%during addNewPositionCallback
% Created for R2007b

% close all
% clear all
if 0
    cf
    fg
    I = imread('pout.tif');
    
    imshow(I);
end
% [ha a]=rgetnii('AVGT.nii');
%
% fg
% dim=2
% a2=dqueeze
% imagesc()




h1 = imdistline;
set(h1,'Tag','distline1');
api1 = iptgetapi(h1);


u=get(gcf,'userdata');
u.meas.h1=h1;
u.meas.api=api1;
set(gcf,'userdata',u);

% h2 = imdistline;
% set(h2,'Tag','distline2');
% api2 = iptgetapi(h2);

id1 = api1.addNewPositionCallback(@(x) cb_distanceMeas(h1,x,1));
% id2 = api2.addNewPositionCallback(@(x) cb_distanceMeas(x,2));
h1.setColor([1 0 0]);
u=get(gcf,'userdata');

hb=uicontrol('style','pushbutton','units','norm','string','x','tag','pb_deldistfun',...
    'callback',{@pb_deldistfun,api1},'tooltipstring','close distance measuring tool');

cb_distanceMeas(h1,[],1);
updateDeldistBtn(1);

function updateDeldistBtn(par)
hd=findobj(gcf,'tag','end point 1');
hb=findobj(gcf,'tag','pb_deldistfun');

x=get(hd,'xdata');
y=get(hd,'ydata');
if par==1 %start
    ax = gca;
    AxesPos = get(ax, 'position');
    xscale = get(ax, 'xlim' );
    yscale = get(ax, 'ylim');
    x2=(x-xscale(1))/(xscale(2)-xscale(1))*AxesPos(3)+AxesPos(1);
    y2=1-(y-yscale(1))/(yscale(2)-yscale(1))*AxesPos(4)+AxesPos(2);
    set(hb,'position',[x2 y2 .1 .1]);
else
    co=get(gcf,'CurrentPoint');
    set(hb,'position',[co(1)-0.01 co(2) .1 .1]);
end


% hb=uicontrol('style','pushbutton','units','norm','string','x');

% hd=findobj(h1,'tag','end point 1')
%

set(hb,'units','pixels');
pos=get(hb,'position');
si=14;
set(hb,'position',[pos(1)-si*1.5 pos(2)+0 si si]);
set(hb,'units','norm');


%   Text    (distance label)
%   Line    (end point 2)
%   Line    (end point 1)
%   Line    (top line)
%   Line    (bottom line)

function cb_distanceMeas(h1,pos,id)

updateDeldistBtn(0);
% disp(id);
h = findobj(gcf,'Tag',['distline' num2str(id)]) ;
% disp(get(h,'Tag'));
% disp(pos);

dis=h1.getDistance();
ang=h1.getAngleFromHorizontal();

hl=findobj(h,'tag','distance label');
% set(hl,'string',{['s: '  sprintf('%2.3f',dis) 'mm']
%     ['s: '  sprintf('%2.3f',dis) 'pix']
%     ['{\theta}: '  sprintf('%2.3f',ang) '�']},'fontsize',8);

% 'a'
tpos=get(hl,'position');
% disp(ang);
% if ang>90 && ang<=170
%     set(hl,'position',[tpos(1)+16 tpos(2)-16 tpos(3)])
% elseif  ang>170 && ang<=180
%     set(hl,'position',[tpos(1)+16 tpos(2)-16*2 tpos(3)])
% elseif  ang>=0 && ang<=90
%     set(hl,'position',[tpos(1)+16 tpos(2)-16*2 tpos(3)])
% end

tmtag=get(gco,'tag');
if isempty(tmtag)
    tmtag='end point 1';
end
if sum(strcmp(tmtag,{'end point 1', 'end point 2'}))==0
    tmtag='end point 1';
end


tm=findobj(h1,'tag',tmtag);

if strcmp(tmtag,'end point 1')
    tf=findobj(h1,'tag','end point 2');
else
    tf=findobj(h1,'tag','end point 1');
end
fp=cell2mat(get(tf,{'xdata' 'ydata'}));%fix xy
mp=cell2mat(get(tm,{'xdata' 'ydata'}));%moving xy


%____________________mm-distance____________________________
hdim=findobj(gcf,'tag','rd_changedim');
transpose=get(findobj(gcf,'tag','rd_transpose'),'value');
or=get(hdim,{'string' 'value'});
dimused=str2num(or{1}{or{2}});
u=get(gcf,'userdata');
dim=u.ha.dim;
mat=u.ha.mat;

dim(dimused)=[];
voxsi=diag(mat(1:3,1:3))';
voxsi(dimused)=[];

if transpose==1
    voxsi=fliplr(voxsi);
    dim  =fliplr(dim);
end

dfdo=abs(fp(2)-mp(2));
dfri=abs(fp(1)-mp(1));

mmri=dfri*voxsi(2);
mmdo=dfdo*voxsi(1);
mm=sqrt(mmri.^2+mmdo.^2);

% dum1=get(findobj(gcf,'type','image'),'xdata');
% dum2=get(findobj(gcf,'type','image'),'ydata');
% imgdim=[dum1(2) dum2(2)];

set(hl,'string',{['s: '  sprintf('%2.3f',mm) 'mm']
    ['s: '  sprintf('%2.3f',dis) 'pix']
    ['{\theta}: '  sprintf('%2.3f',ang) '�']},'fontsize',8);


%________________________________________________
set(tm,'MarkerSize',20);
set(tf,'MarkerSize',20);

if 0
    df=fp-mp;
    set(hl,'position',[fp(1)+sign(df(1))*14 fp(2)+sign(df(2))*14 0]);
    if mp(2)<=fp(2) %virtually mp is above fp
        disp(rand(1))
        set(hl,'position',[fp(1)+sign(df(1))*14 fp(2)+sign(df(2))*14*2 0]);
        if ang==0
            set(hl,'position',[fp(1)+sign(df(1))*14*2 fp(2)+14*2 0]);
        end
    else
        se
        t(hl,'position',[fp(1)+sign(df(1))*14 fp(2)+sign(df(2))*14*2 0]);
    end
end
set(hl,'backgroundcolor','k','color',[1.0000 0.8431  0],'fontsize',7,'fontweight','bold');
xl=xlim;
yl=ylim;
% ce=round((fp+mp)/2);
% if ce(1)<mean(xl)
%     set(hl,'position',[xl(2)-xl(2)*.25  yl(2)-yl(2)*.05]);
% else
set(hl,'position',[xl(1)+xl(2)*.05  yl(2)-yl(2)*.05]);
% end
lpos=get(hl,'Extent');

b(1)=fp(1)>lpos(1) &&  fp(1)<lpos(2) && fp(2)>lpos(2)-lpos(4) &&  fp(2)<lpos(2);
b(2)=mp(1)>lpos(1) &&  mp(1)<lpos(2) && mp(2)>lpos(2)-lpos(4) &&  mp(2)<lpos(2);
b(3)=fp(2)>lpos(2)-lpos(4) &&  fp(2)<lpos(2) && mp(2)>lpos(2)-lpos(4) &&  mp(2)<lpos(2);
% disp(b);
if b(3)==1
    set(hl,'position',[xl(1)+xl(2)*.05  yl(1)+yl(2)*.075]);
else
    if any(b)==1
        set(hl,'position',[xl(2)-xl(2)*.25  yl(2)-yl(2)*.05]);
    end
end

% disp(get(hl,'position'));
% set(hl,'fontweight','bold');


function pb_deldistfun(e,e2,api1)
delete(api1);
delete(findobj(gcf,'tag','pb_deldistfun'));
hb=findobj(gcf,'tag','pb_measureDistance');
set(hb,'value',0);
hgfeval(get( hb ,'callback'));




function pb_measureDistance(e,e2)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
val=get(findobj(gcf,'tag','pb_measureDistance'),'value');

if val==0 %off
    try; delete(u.meas.api); end
    try; delete(u.meas.h1); end
    %     try; delete(get(findobj(hf1,'tag','end point 1'),'parent')); end
    try;  delete(findobj(hf1,'tag','pb_deldistfun'));end
    
    %     hb=findobj(gcf,'tag','undo');
    %     hgfeval(get( hb ,'callback'));
    
else
    %set(hf1,'Pointer','arrow');
    %     hb=findobj(gcf,'tag','undo');
    %     hgfeval(get( hb ,'callback'));
    
    set(gcf,'WindowButtonDownFcn',[]);
    set(gca,'ButtonDownFcn',[]);
    set(findobj(gcf,'type','image'),'ButtonDownFcn',[]);
    create_distanceMeas();
    
end

function pb_measureDistance_off()
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
set(findobj(gcf,'tag','pb_measureDistance'),'value',0);

try; delete(u.meas.api); end
try; delete(u.meas.h1); end
try; delete(get(findobj(hf1,'tag','end point 1'),'parent'));end
try; delete(findobj(hf1,'tag','pb_deldistfun')); end

%     hb=findobj(gcf,'tag','undo');
%     hgfeval(get( hb ,'callback'));

function r1=adjustIntensity(r1);
hf1=findobj(0,'tag','xpainter');
hb=findobj(hf1,'tag','cb_adjustIntensity');
if get(hb,'value')==1
    uv=get(hb,'userdata');
    if isfield(uv,'lims') && ~isempty(uv.lims)
        %r1=imadjust(mat2gray(r1),[0.3 0.7],[1 0]);
        if uv.lims(2)>uv.lims(1)
            r1=imadjust(mat2gray(r1),sort(uv.lims));
        else
            r1=imadjust(mat2gray(r1),sort(uv.lims),[1 0]);
        end
    else
        r1=imadjust(mat2gray(r1));
    end
    
end


function cb_adjustIntensity(e,e2)
hf1=findobj(0,'tag','xpainter');
hb=findobj(hf1,'tag','cb_adjustIntensity');
% set(hb,'value');
useoldHistory=1;
setslice([],useoldHistory);

function cb_adjustIntensity_value(e,e2)
hf1=findobj(0,'tag','xpainter');
hb=findobj(hf1,'tag','cb_adjustIntensity_value');
hj=get(hb,'userdata');
lims=str2num(char(hj.getSelectedItem));
if length(lims)==1
    hj.setSelectedIndex(0);
    cb_adjustIntensity_value()
    return;
end
hr=findobj(hf1,'tag','cb_adjustIntensity');
uv.lims=lims;
set(hr,'userdata',uv);
useoldHistory=1;
setslice([],useoldHistory);



function m=interpCC(xy,mindist)
% ==============================================
%%
% ===============================================

if exist('mindist')~=1 || isempty(mindist)
    mindist=1;
end

m=sub(xy,mindist);
m=fliplr(sub(fliplr(m),mindist));

% fg, hold on
% plot(m(:,1),m(:,2),'ro')
% plot(xy(:,1),xy(:,2),'b.')


% ==============================================
%%
% ===============================================
function m=sub(xy,mindist)

m=xy;

% dist=1

while true
    d=diff(m(:,2));
    ix=min(find(abs(d)>mindist));
    s=m(ix:ix+1,:);
    
    if isempty(s)
        break
    end
    
    if s(1,2)>s(2,2)
        v2=s(1,2):-mindist:s(2,2);
        %     vx=interp1([0 1],s(:,2)', v2);
        v1=interp1([0 1],s(:,1)', linspace(0,1,length(v2)));
        s2=[v1(:) v2(:)];
    else
        %keyboard
        v2=s(1,2):mindist:s(2,2);
        v1=interp1([0 1],s(:,1)', linspace(0,1,length(v2)));
        s2=[v1(:) v2(:)];
    end
    
    
    
    
    m=[m(1:ix-1,:); s2; m(ix+2:end,:) ];
    %     [size(m,1) size(s2,1) ]
end

% d=diff(m(:,2));
% max(abs(d))



% fg, hold on
% plot(m(:,1),m(:,2),'ro')
% plot(xy(:,1),xy(:,2),'b.')

% ==============================================
%%
% ===============================================

function contourhelp(e,e2)

msg=getanchortext(which('xdraw.m'),'##anker1##');
msg=regexprep(msg,'^%','');
uhelp(msg,0,'name','contourline usage');

% ##anker1##
% #ok Change contourlines & fill contourline
% Use #b slider or [shift]+left/right arrow-keys #n to adjust the contour lines.
% Use #b [shift]+left mouse click #n within a contour to fill the area within a contour line.
% 
% #ok Bordering contour lines 
% The filling of a contour line can be spatially limited by setting borders.
% Filling a contour line will stop at the border(s) but only if the border(s) intersect with the courline(s).
% To set a border click #b [aB]-button or use [b]-shortcut #n and draw a border. 
% Multiple borders are allowed.
% Hit #b [dB]-button or [shift]+[b]-shortcut #n to delete all borders. 
% 
% #ok Median Filter
% A median filter (order 3) is used for smoother contour lines.
% -select the #b [F]-radiobutton #n to enable/disable the filter
% -for smoother lines increase the filter order in the edit field 
% 
% #ok Misc
% #b [hand icon] #n : To move the panel click and drag the #b [hand icon] 
% #b [vis]-radio #n : click #b [vis]-radio #n to show/hide contour lines 
% ##anker1##
% -












