function p_displaySlices(x)%(imgs, dispf)

%  if isempty(x.cmap)
% 
%      eval(['x.cmap=' x.cmap ';']);
%      if ~isnumeric(x.cmap)
%         error('x.cmap: false colormap ') ;
%      end
%      
%  end

if 0
%OVERLAY PARAMETER
x.views             =0 ;  %multiple view: [1] x.orient only  [2] 2views fixed with 'sagittal' and 'axial' views
x.slices            =[-30:15:30];  %slices to display
x.orient            ='sagittal'  ;%'axial','coronal','sagittal'
x.cmap              =[];%colormap;  [] if empty use defaults colormap otherwise use x.cmap=jet,or cmap=copper etc
x.crange            =[];  %colorRange :  [] if empty use subject's colorRange, otherwise 2numbers, e.g. [0 1000]
x.itype0            ={ 'Structural' 'Truecolour' } ;%colorSystem %'Structural' 'Truecolour' 'Negative blobs' 'Blobs'
x.intensity         =[.5 .5];

end


if x.views==1
    p_displaySlices2(x);
    set(gcf,'color','k');
else


    x.orient      ='sagittal';
    p_displaySlices2(x);
    fig=findobj(0,'Tag','Graphics');
    ax=sort(findobj(fig,'type','axes'));
    set(ax,'units','normalized');
    set(fig,'units','normalized');
    try; delete(findobj(0,'tag','fig2'));end
    fig2=figure(1000);set(fig2,'color','k','tag','fig2');
    mxpos=[];
    for u=1:length(ax)
        ax2= copyobj(ax(u),fig2);
        pos=get(ax2,'position');
        pos(1)=pos(1)/2;
        pos(3)=pos(3)/2;
        set(ax2,'position',pos);
        mxpos(u)=[pos(1)+pos(3)];
    end

    x.orient='axial';
    p_displaySlices2(x);
    fig=findobj(0,'Tag','Graphics');
    ax=sort(findobj(fig,'type','axes'));
    set(ax,'units','normalized');
    set(fig,'units','normalized');
    % fig2=figure(1000);set(fig2,'color',get(fig,'color'))

    for u=1:length(ax)
        ax2= copyobj(ax(u),fig2);
        pos=get(ax2,'position');
        pos(1)=pos(1)/2+max(mxpos);
        pos(3)=pos(3)/2;
        set(ax2,'position',pos);
    end

    hlb   =findobj(fig,'tag','editbox');
    set(0,'currentfigure',fig2);
    axn=axes('position',[0 0 1 1]);
    te=text( 0.05,.95, get(hlb,'string'),'fontsize',8,'color','w'); axis off;
    % figure(fig2)
    close(fig);


end
set(gcf,'InvertHardcopy','off');


function p_displaySlices2(x)
    
%STRUCT FOR OVERLAY
itype0   =  x.itype0 ;   % ={ 'Structural' 'Truecolour' } ;...%'Structural' 'Truecolour' 'Negative blobs' 'Blobs'
cmap     =  x.cmap   ;   %  =[];%cm.actc;
orient   =  x.orient  ;  %  ='sagittal'  ;%'axial','coronal','sagittal'
crange   =  x.crange  ;  %  =[];  %[0 1000]
slices   =  x.slices  ;  %  =[-30:15:30];
intensity=  x.intensity; %  =[.7 .3];
subjectname=x.subjectname;%='XXXXX';
imgs       =x.imgs;%={...
    %'X:\ataxie\nifti\KIMSCA_K02\mpr\sKIMSCA_K_2-0003-00001-000176-01.nii,1'
    %'X:\ataxie\nifti\KIMSCA_K02\epi\fKIMSCA_K_2-0008-00001-000001-01.nii,1'
    %};    


if 0
    %STRUCT FOR OVERLAY
    x.itype0       ={ 'Structural' 'Truecolour' } ;...%'Structural' 'Truecolour' 'Negative blobs' 'Blobs'
        x.cmap        =[];%cm.actc;
    x.orient      ='sagittal'  ;%'axial','coronal','sagittal'
    x.crange      =[];  %[0 1000]
    x.slices      =[-30:15:30];
    x.intensity   =[.7 .3];


    x.subjectname='XXXXX';
    x.imgs={...
        'X:\ataxie\nifti\KIMSCA_K02\mpr\sKIMSCA_K_2-0003-00001-000176-01.nii,1'
        'X:\ataxie\nifti\KIMSCA_K02\epi\fKIMSCA_K_2-0008-00001-000001-01.nii,1'
        };

end
% ########################################################################
dispf = 1;
warning off;
clear global SO
global SO

spm_input('!SetNextPos', 1);

% load images
nimgs = size(imgs);

% process names
nchars = 20;
imgns = spm_str_manip(imgs, ['rck' num2str(nchars)]);

% identify image types
cscale = [];
deftype = 1;
SO.cbar = [];
for i = 1:nimgs
    SO.img(i).vol = spm_vol(imgs{i});
    options = {'Structural','Truecolour', ...
        'Blobs','Negative blobs'};
    % if there are SPM results in the workspace, add this option
    %   if evalin('base','exist(''SPM'', ''var'')')
    %     options = {'Structural with SPM blobs', options{:}};
    %   end
    itype=itype0(i);
    %   itype = spm_input(sprintf('Img %d: %s - image type?', i, imgns{i}), '+1', ...
    % 		    'm', char(options),options, deftype);
    imgns(i) = {sprintf('Img %d (%s)',i,itype{1})};
    [mx mn] = slice_overlay('volmaxmin', SO.img(i).vol);
    if ~isempty(strmatch('Structural', itype))
        figure;
        SO.img(i).cmap = gray;
        close(gcf) ;
        SO.img(i).range = [mn mx];
        deftype = 2;
        cscale = [cscale i];
        if strcmp(itype,'Structural with SPM blobs')
            slice_overlay('addspm',[],0);
        end
    else
        SO.cbar = [SO.cbar i];
        cprompt = ['Colormap: ' imgns{i}];
        switch itype{1}
            case 'Truecolour'
                dcmap = 'actc';
                drange = [mn mx];
                cscale = [cscale i];
            case 'Blobs'
                dcmap = 'hot';
                drange = [0 mx];
                SO.img(i).prop = Inf;
            case 'Negative blobs'
                dcmap = 'winter';
                drange = [0 mn];
                SO.img(i).prop = Inf;
        end
        %     SO.img(i).cmap = return_cmap(cprompt, dcmap);
        %    cm= load('actc.mat')
        %    cmap=cm.actc;
 
        if isempty(cmap)
            cmap=defaultcmap;
        end
        SO.img(i).cmap=cmap;
        %     try
        %         load(dcmap)

        %     SO.img(i).range = spm_input('Img val range for colormap','+1', 'e', drange, 2);
        if isempty(crange)
            SO.img(i).range=drange(:);
        else
            SO.img(i).range=crange(:);
        end

    end
end

ncmaps=length(cscale);
if ncmaps == 1
    SO.img(cscale).prop = 1;
else
    remcol=1;
    for i = 1:ncmaps
        ino = cscale(i);

        %     SO.img(ino).prop = spm_input(sprintf('%s intensity',imgns{ino}),...
        % 				 '+1', 'e', ...
        % 				 remcol/(ncmaps-i+1),1);
        if isempty(intensity)
            SO.img(ino).prop=remcol/(ncmaps-i+1);
        else
            SO.img(ino).prop=intensity(i);
        end
        remcol = remcol - SO.img(ino).prop;
    end
end

% SO.transform = deblank(spm_input('Image orientation', '+1', ['Axial|' ...
% 		    ' Coronal|Sagittal'], strvcat('axial','coronal','sagittal'), ...
% 		    1));
SO.transform=orient;%'axial';
% SO.transform='axial'

% use SPM figure window
SO.figure = spm_figure('GetWin', 'Graphics');

% slices for display
slice_overlay('checkso');
% SO.slices = spm_input('Slices to display (mm)', '+1', 'e', ...
% 		      sprintf('%0.0f:%0.0f:%0.0f',...
% 			      SO.slices(1),...
% 			      mean(diff(SO.slices)),...
% 			      SO.slices(end))...
% 		      );
% SO.slices=[  -108   -88   -68   -48   -28    -8    12    32 ]

if isempty(slices)
    SO.slices=SO.slices(1):20:SO.slices(end) 
else %if length(slice)>1
    SO.slices=slices(:)'; 
end

% and do the display
if dispf
    slice_overlay
end

unit=get(gcf,'units');
set(gcf,'units','normalized');

 
    
h2 = uicontrol('Style', 'edit', 'String', char([{subjectname};x.imgs]),...
    'units','normalized','Position', [.0 .92  .94 .07],'tag','editbox', ...
    'backgroundcolor','w','horizontalalignment','center','fontsize',10,'fontweight','bold');
set(gcf,'units',unit);
set(h2,'max',3);
% set(h2,'Enable','off');





return

% function cmap = return_cmap(prompt,defmapn)
% cmap = [];
% while isempty(cmap)
%     cmap = slice_overlay('getcmap', spm_input(prompt,'+1','s', defmapn));
%     %  cmap=jet
% end
% return

function cmap=defaultcmap
           cmap=[...
                         0         0    0.0157
                 0         0    0.0353
                 0         0    0.0510
                 0         0    0.0706
                 0         0    0.0863
                 0         0    0.1059
                 0         0    0.1216
                 0         0    0.1412
                 0         0    0.1569
                 0         0    0.1765
                 0         0    0.1922
                 0         0    0.2118
                 0         0    0.2275
                 0         0    0.2471
                 0         0    0.2667
                 0         0    0.2824
                 0         0    0.3020
                 0         0    0.3176
                 0         0    0.3373
                 0         0    0.3529
                 0         0    0.3725
                 0         0    0.3882
                 0         0    0.4078
                 0         0    0.4235
                 0         0    0.4431
                 0         0    0.4588
                 0         0    0.4784
                 0         0    0.4941
                 0         0    0.5137
                 0         0    0.5333
                 0         0    0.5333
                 0    0.0196    0.5098
                 0    0.0431    0.4902
                 0    0.0667    0.4706
                 0    0.0863    0.4510
                 0    0.1098    0.4314
                 0    0.1333    0.4118
                 0    0.1529    0.3922
                 0    0.1765    0.3725
                 0    0.2000    0.3529
                 0    0.2196    0.3333
                 0    0.2431    0.3137
                 0    0.2667    0.2941
                 0    0.2863    0.2745
                 0    0.3098    0.2549
                 0    0.3333    0.2353
                 0    0.3529    0.2157
                 0    0.3765    0.1961
                 0    0.3961    0.1765
                 0    0.4196    0.1569
                 0    0.4431    0.1373
                 0    0.4627    0.1176
                 0    0.4863    0.0980
                 0    0.5098    0.0784
                 0    0.5294    0.0588
                 0    0.5529    0.0392
                 0    0.5765    0.0196
                 0    0.6000         0
                 0    0.6000         0
            0.0706    0.6275         0
            0.1412    0.6549         0
            0.2118    0.6824         0
            0.2824    0.7137         0
            0.3529    0.7412         0
            0.4235    0.7686         0
            0.4941    0.8000         0
            0.5647    0.8275         0
            0.6353    0.8549         0
            0.7059    0.8824         0
            0.7765    0.9137         0
            0.8471    0.9412         0
            0.9176    0.9686         0
            0.9882    1.0000         0
            1.0000    1.0000         0
            1.0000    0.9765         0
            1.0000    0.9569         0
            1.0000    0.9333         0
            1.0000    0.9137         0
            1.0000    0.8902         0
            1.0000    0.8706         0
            1.0000    0.8510         0
            1.0000    0.8275         0
            1.0000    0.8078         0
            1.0000    0.7843         0
            1.0000    0.7647         0
            1.0000    0.7412         0
            1.0000    0.7216         0
            1.0000    0.7020         0
            1.0000    0.6784         0
            1.0000    0.6588         0
            1.0000    0.6353         0
            1.0000    0.6157         0
            1.0000    0.5922         0
            1.0000    0.5725         0
            1.0000    0.5529         0
            1.0000    0.5294         0
            1.0000    0.5098         0
            1.0000    0.4863         0
            1.0000    0.4667         0
            1.0000    0.4431         0
            1.0000    0.4235         0
            1.0000    0.4039         0
            1.0000    0.3804         0
            1.0000    0.3608         0
            1.0000    0.3373         0
            1.0000    0.3176         0
            1.0000    0.2941         0
            1.0000    0.2745         0
            1.0000    0.2549         0
            1.0000    0.2314         0
            1.0000    0.2118         0
            1.0000    0.1882         0
            1.0000    0.1686         0
            1.0000    0.1451         0
            1.0000    0.1255         0
            1.0000    0.1059         0
            1.0000    0.0824         0
            1.0000    0.0627         0
            1.0000    0.0392         0
            1.0000    0.0196         0
            1.0000         0         0
            ];


function varargout = slice_overlay(action, varargin);
% Function to display + manage slice display 
% Slice display works on a global structure SO
% with fields 
%  - img - array of images to display
%        - img structs contain fields
%             vol - vol struct info (see spm_vol)
%                   can also be vol containing image as 3d matrix
%                   set with slice_overlay('AddBlobs'...) call
%             cmap - colormap for this image
%             nancol - color for NaN. If scalar, this is an index into
%                    the image cmap.  If 1x3 vector, it's a colour
%             prop - proportion of intensity for this cmap/img 
%                    if = Inf, gives split cmap effect where values of 
%                    this cmap override previous image cmap values
%             func - function to apply to image before scaling to cmap
%                    (and therefore before min/max thresholding. E.g. a func of
%                    'i1(i1==0)=NaN' would convert zeros to NaNs
%             range - 2x1 vector of values for image to distribute colormap across
%                    the first row of the colormap applies to the first
%                    value in 'range', and the last value to the second
%                    value in 'range'
%             outofrange - behavior for image values to the left and
%                    right of image limits in 'range'.  Left means
%                    colormap values < 1, i.e for image values <
%                    range(1), if (range(1)<range(2)), and image values >
%                    range(1) where (range(1)>range(2)). If missing,
%                    display min (for Left) and max (for Right) value from colormap. 
%                    Otherwise should be a 2 element cell array, where
%                    the first element is the colour value for image values
%                    left of 'range', and the second is for image values
%                    right of 'range'.  Scalar values for
%                    colour index the colormap, 3x1 vectors are colour
%                    values.  An empty array attracts default settings
%                    appropriate to the mode - i.e. transparent colour (where 
%                    SO.prop ~= Inf), or split colour.  Empty cells
%                    default to 0. 0 specifies that voxels with this
%                    colour do not influence the image (split =
%                    background, true = black)
%            hold  - resampling order for image (see spm_sample_vol) -
%                    default 1
%            background - value when resampling outside image - default
%                    NaN
%            
% - transform - either - 4x4 transformation to apply to image slice position,
%             relative to mm given by slicedef, before display
%               or     - text string, one of axial, coronal, sagittal
%                        These orientations assume the image is currently
%                        (after its mat file has been applied) axially
%                        oriented
% - slicedef - 2x3 array specifying dimensions for slice images in mm
%             where rows are x,and y of slice image, and cols are neg max dim,
%             slice separation and pos max dim
% - slices   - vector of slice positions in mm in z (of transformed image)
% - figure    - figure handle for slice display figure
% - refreshf  - flag - if set or empty, refresh axis info for figure
%             else assume this is OK
% - clf       - flag, non zero -> clear figure before display.  Redundant
%               if refreshf == 0
% - area      struct with fields
%                  position - bottom left, x size y size 1x4 vector of
%                      area in which to display slices
%                  units    - one of
%                    inches,centimeters,normalized,points,{pixels}
%                  halign - one of left,{center},right
%                  valign - one of top,{middle},bottom
% - xslices  - no of slices to display across figure (defaults to an optimum)
% - cbar      - if empty, missing, no colourbar.  If an array of integers, then 
%             indexes img array, and makes colourbar for each cmap for
%             that img.  Cbars specified in order of appearance L->R
% - labels - struct can be absent (-> default numerical labels)
%                  empty (SO.labels = []) (no labels) or contain fields 
%                  colour - colour for label text 
%                  size - font size in units normalized to slice axes 
%                  format - if = cell array of strings =
%                  labels for each slice in Z.  If is string, specifies
%                  sprintf format string for labelling in distance of the
%                  origin (Xmm=0, Ymm=0) of each slice from plane containing
%                  the AC, in mm, in the space of the transformed image
% - callback - callback string for button down on image panels.  E.g.
%              setting SO.callback to 'slice_overlay(''getpos'')' prints to
%              the matlab window the equivalent position in mm of the
%              position of a mouse click on one of the image slices
% - printstr - string for printing slice overlay figure window, e.g.
%              'print -dpsc -painters -noui' (the default)
% - printfile - name of file to print output to; default 'slices.ps'
%
% FORMAT slice_overlay
% Checks, fills SO struct (slice_overlay('checkso')), and 
% displays slice overlay (slice_overlay('display'))
%
% FORMAT slice_overlay('checkso')
% Checks SO structure and sets defaults
%
% FORMAT cmap = slice_overlay('getcmap',cmapname)
% Gets colormap named in cmapname string
%
% FORMAT [mx mn] = slice_overlay('volmaxmin', vol)
% Returns maximum and minimum finite values from vol struct 'vol'
%
% FORMAT slice_overlay('addspm',SPM,dispf)
% Adds SPM blobs as new img to SO struct, split effect, 'hot' colormap, 
% SPM structure is generated by calls to SPM results
% if not passed, it is fetched from the workspace
% If dispf is not passed, or nonzero, displays resulting SO figure also
%
% FORMAT slice_overlay('addblobs', imgno, XYZ, vals, mat)
% adds SPM blobs to img no 'imgno', as specified in 
% XYZ  - 3xN voxel coordinates of N blob values
% vals - N blob intensity values
% mat  - 4x4 matrix specifying voxels -> mm
%
% FORMAT vol = slice_overlay('blobs2vol', XYZ, vals, mat)
% returns (pseudo) vol struct for 3d blob volume specified
% in matrices as above
%
% FORMAT slice_overlay('addmatrix', imgno, mat3d, mat)
% adds 3d matrix image vol to img imgno.  Optionally
% mat  - 4x4 matrix specifying voxels -> mm
%
% FORMAT vol = slice_overlay('matrix2vol', mat3d, mat)
% returns (pseudo) vol struct for 3d matrix 
% input matrices as above
%
% FORMAT mmpos = slice_overlay('getpos')
% returns equivalent position in mm of last click on current axes (gca)
% if the axes contain an image slice (empty otherwise)
%
% FORMAT vals = slice_overlay('pointvals', XYZmm, holdlist)
% returns IxN matrix with values of each image 1..I, at each
% point 1..N specified in 3xN mm coordinate matrix XYZmm
% If specified, 'holdlist' contains I values giving hold
% values for resampling for each image (see spm_sample_vol)
%
% FORMAT slice_overlay('display')
% Displays slice overlay from SO struct
% 
% FORMAT slice_overlay('print', filename, printstr) 
% Prints slice overlay figure, usually to file.  If filename is not
% passed/empty gets filename from SO.printfile.  If printstr is not
% passed/empty gets printstr from SO.printstr
% 
% V 0.8 2/8/00  
% More or less  beta - take care.  Please report problems to  
% Matthew Brett matthew@mrc-cbu.cam.ac.uk

global SO

if nargin < 1
  checkso;
  action = 'display';
else
  action = lower(action);
end

switch action
 case 'checkso'
  checkso;
 case 'getcmap'
  varargout = {getcmap(varargin{1})};
 case 'volmaxmin'
  [mx mn] = volmaxmin(varargin{1});
  varargout = {mx, mn};
 case 'addspm'
  if nargin < 2
    varargin{1} = [];
  end
  if nargin < 3
    varargin{2} = 1;
  end
  if isempty(varargin{1})
    % Fetch from workspace
    errstr = sprintf(['Cannot find SPM variables in the workspace\n'...
		      'Please run SPM results GUI']);
    V = spm('ver')
    switch V(4:end)
     case '99'
      xSPM = evalin('base', 'SPM', ['error(' errstr ')']);
      xSPM.M = evalin('base', 'VOL.M', ['error(' errstr ')']);
     case '2'
      xSPM = evalin('base', 'xSPM', ['error(' errstr ')']);
     otherwise
      error(['Strange SPM version ' V]);
    end
  else
    xSPM = varargin{1};
  end
  newimg = length(SO.img)+1;
  SO.img(newimg).vol = blobs2vol(xSPM.XYZ,xSPM.Z, xSPM.M);
  SO.img(newimg).prop = Inf;
  SO.img(newimg).cmap = hot;
  SO.img(newimg).range = [0 max(xSPM.Z)];
  SO.cbar = [SO.cbar newimg];
  if varargin{2}
    checkso;
    slice_overlay('display');
  end
  
 case 'addblobs'
  addblobs(varargin{1},varargin{2},varargin{3},varargin{4});
 case 'blobs2vol'
  varargout = {blobs2vol(varargin{1},varargin{2},varargin{3})};
 case 'addmatrix'
  if nargin<3,varargin{2}='';end
  if nargin<4,varargin{3}='';end
  addmatrix(varargin{1},varargin{2},varargin{3});
 case 'matrix2vol'
  if nargin<3,varargin{2}=[];end
  varargout = {matrix2vol(varargin{1},varargin{2})};
 case 'getpos'
  varargout = {getpos};
 case 'pointvals'
  varargout = {pointvals(varargin{1})};
 case 'print'
  if nargin<2,varargin{1}='';end
  if nargin<3,varargin{2}='';end
  printfig(varargin{1}, varargin{2});
 case 'display'

% get coordinates for plane
X=1;Y=2;Z=3;
dims = SO.slicedef;
xmm = dims(X,1):dims(X,2):dims(X,3);
ymm = dims(Y,1):dims(Y,2):dims(Y,3);
zmm = SO.slices;
[y x] = meshgrid(ymm,xmm');
vdims = [length(xmm),length(ymm),length(zmm)];

% no of slices, and panels (an extra for colorbars)
nslices = vdims(Z);
minnpanels = nslices;
cbars = 0;
if is_there(SO,'cbar')
  cbars = length(SO.cbar);
  minnpanels = minnpanels+cbars;
end

% get figure data
% if written to, the axes may be specified already
figno = figure(SO.figure);

% (re)initialize axes and stuff

% check if the figure is set up correctly
if ~SO.refreshf
  axisd = flipud(findobj(SO.figure, 'Type','axes','Tag', 'slice overlay panel'));
  npanels = length(axisd);
  if npanels < vdims(Z)+cbars;
    SO.refreshf = 1;
  end
end
if SO.refreshf
  % clear figure, axis store
  if SO.clf, clf; end
  axisd = [];

  % prevent print inversion problems
  set(figno,'InvertHardCopy','off');
  
  % calculate area of display in pixels
  parea = SO.area.position;
  if ~strcmp(SO.area.units, 'pixels')
    ubu = get(SO.figure, 'units');
    set(SO.figure, 'units','pixels');
    tmp = get(SO.figure, 'Position');
    ascf = tmp(3:4);
    if ~strcmp(SO.area.units, 'normalized')
      set(SO.figure, 'units',SO.area.units);
      tmp = get(SO.figure, 'Position');
      ascf = ascf ./ tmp(3:4);
    end
    set(figno, 'Units', ubu);
    parea = parea .* repmat(ascf, 1, 2);
  end
  asz = parea(3:4);
  
  % by default, make most parsimonious fit to figure
  yxratio = length(ymm)*dims(Y,2)/(length(xmm)*dims(X,2));
  if ~is_there(SO, 'xslices')
    % iteration needed to optimize, surprisingly.  Thanks to Ian NS
    axlen(X,:)=asz(1):-1:1;
    axlen(Y,:)=yxratio*axlen(X,:);
    panels = floor(asz'*ones(1,size(axlen,2))./axlen);
    estnpanels = prod(panels);
    tmp = find(estnpanels >= minnpanels);
    if isempty(tmp)
      error('Whoops, cannot fit panels onto figure');
    end
    b = tmp(1); % best fitting scaling
    panels = panels(:,b);
    axlen = axlen(:, b);
  else
    % if xslices is specified, assume X is flush with X figure dimensions
    panels([X:Y],1) = [SO.xslices; 0];
    axlen([X:Y],1) = [asz(X)/panels(X); 0];
  end
  
  % Axis dimensions are in pixels.  This prevents aspect ratio rescaling
  panels(Y) = ceil(minnpanels/panels(X));
  axlen(Y) = axlen(X)*yxratio;
  
  % centre (etc) panels in display area as required
  divs = [Inf 2 1];the_ds = [0;0];
  the_ds(X) = divs(strcmp(SO.area.halign, {'left','center','right'}));
  the_ds(Y) = divs(strcmp(SO.area.valign, {'bottom','middle','top'}));
  startc = parea(1:2)' + (asz'-(axlen.*panels))./the_ds;
  
  % make axes for panels
  r=0;c=1;
  npanels = prod(panels);
  lastempty = npanels-cbars;
  for i = 1:npanels
    % panel userdata
    if i<=nslices
      u.type = 'slice';
      u.no   = zmm(i);
    elseif i > lastempty
      u.type = 'cbar';
      u.no   = i - lastempty;
    else
      u.type = 'empty';
      u.no   = i - nslices;
    end
    axpos = [r*axlen(X)+startc(X) (panels(Y)-c)*axlen(Y)+startc(Y) axlen'];
    axisd(i) = axes(...
	'Parent',figno,...
	'XTick',[],...
	'XTickLabel',[],...
	'YTick',[],...
	'YTickLabel',[],...
	'Box','on',...
	'XLim',[1 vdims(X)],...
	'YLim',[1 vdims(Y)],...
	'Units', 'pixels',...
	'Position',axpos,...
	'Tag','slice overlay panel',...
	'UserData',u);
    r = r+1;
    if r >= panels(X)
      r = 0;
      c = c+1;
    end
  end
end

% sort out labels
if is_there(SO,'labels')
  labels = SO.labels;
  if iscell(labels.format)
    if length(labels.format)~=vdims(Z)
      error(...
	  sprintf('Oh dear, expecting %d labels, but found %d',...
		  vdims(Z), length(labels.contents)));
    end
  else
    % format string for mm from AC labelling
    fstr = labels.format;
    labels.format = cell(vdims(Z),1);
    acpt = SO.transform * [0 0 0 1]';
    for i = 1:vdims(Z)
      labels.format(i) = {sprintf(fstr,zmm(i)-acpt(Z))};
    end
  end
end

% modify colormaps with any new colours
nimgs = length(SO.img);
lrn = zeros(nimgs,3);
cmaps = cell(nimgs);
for i = 1:nimgs
  cmaps(i)={SO.img(i).cmap};
  lrnv = {SO.img(i).outofrange{:}, SO.img(i).nancol};
  for j = 1:length(lrnv)
    if prod(size(lrnv{j}))==1
      lrn(i,j) = lrnv{j};
    else
      cmaps(i) = {[cmaps{i}; lrnv{j}(1:3)]};
      lrn(i,j) = size(cmaps{i},1);
    end
  end
end

% cycle through slices displaying images
nvox = prod(vdims(1:2));
pandims = [vdims([2 1]) 3]; % NB XY transpose for display

zimg = zeros(pandims);
for i = 1:nslices
  ixyzmm = [x(:)';y(:)';ones(1,nvox)*zmm(i);ones(1,nvox)];
  img = zimg;
  for j = 1:nimgs
    thisimg = SO.img(j);
    % to voxel space of image
    vixyz = inv(SO.transform*thisimg.vol.mat)*ixyzmm;
    % raw data 
    if is_there(thisimg.vol, 'imgdata')
      V = thisimg.vol.imgdata;
    else
      V = thisimg.vol;
    end
    i1 = spm_sample_vol(V,vixyz(X,:),vixyz(Y,:),vixyz(Z,:), ...
			 [thisimg.hold thisimg.background]);
    if is_there(thisimg, 'func')
      eval(thisimg.func);
    end
    % transpose to reverse X and Y for figure
    i1 = reshape(i1, vdims(1:2))';
    % rescale to colormap
    [csdata badvals]= scaletocmap(...
	i1,...
	thisimg.range(1),...
	thisimg.range(2),...
	cmaps{j},...
	lrn(j,:));
    % take indices from colormap to make true colour image
    iimg = reshape(cmaps{j}(csdata(:),:),pandims);
    tmp = repmat(logical(~badvals),[1 1 3]);
    if thisimg.prop ~= Inf % truecolor overlay
      img(tmp) = img(tmp) + iimg(tmp)*thisimg.prop;
    else % split colormap effect
      img(tmp) = iimg(tmp);
    end
  end
  % threshold out of range values
  img(img>1) = 1;
  
  image('Parent', axisd(i),...
	'ButtonDownFcn', SO.callback,...
	'CData',img);
  if is_there(SO,'labels')
    text('Parent',axisd(i),...
	 'Color', labels.colour,...
	 'FontUnits', 'normalized',...
	 'VerticalAlignment','bottom',...
	 'HorizontalAlignment','left',...
	 'Position', [1 1],...
	 'FontSize',labels.size,...
	 'ButtonDownFcn', SO.callback,...
	 'String', labels.format{i});
  end
end
for i = (nslices+1):npanels
   set(axisd(i),'Color',[0 0 0]);
end
% add colorbar(s) 
for i = 1:cbars
  axno = axisd(end-cbars+i);
  cbari = SO.img(SO.cbar(i));
  cml = size(cbari.cmap,1);
  p = get(axno, 'Position');; % position of last axis
  cw = p(3)*0.2;
  ch = p(4)*0.75;
  pc = p(3:4)/2;
  [axlims idxs] = sort(cbari.range);
  a=axes(...
      'Parent',figno,...
      'XTick',[],...
      'XTickLabel',[],...
      'Units', 'pixels',...
      'YLim', axlims,...   
      'FontUnits', 'normalized',...
      'FontSize', 0.075,...
      'YColor',[1 1 1],...
      'Tag', 'cbar',...
      'Box', 'off',...
      'Position',[p(1)+pc(1)-cw/2,p(2)+pc(2)-ch/2,cw,ch]...
      );
  ih = image('Parent', a,...
	'YData', axlims(idxs),...     
	'CData', reshape(cbari.cmap,[cml,1,3]));

end

 otherwise
  error(sprintf('Unrecognized action string %s', action));

% end switch action
end

return

function checkso
% checks and fills SO structure
global SO

% figure
if is_there(SO, 'figure')
  try
    if ~strcmp(get(SO.figure,'Type'),'figure')
      error('Figure handle is not a figure')
    end
  catch
    error('Figure handle is not a valid figure')
  end
else
  % no figure handle. Try spm figure, then gcf
  SO.figure = spm_figure('FindWin', 'Graphics'); 
  if isempty(SO.figure)
    SO.figure = gcf;
  end
end
% set defaults for SPM figure 
if strcmp(get(SO.figure, 'Tag'),'Graphics')
  % position figure nicely for SPM
  defstruct = struct('position', [0 0 1 0.92], 'units', 'normalized', ...
		     'valign', 'top');
  SO = set_def(SO, 'area', defstruct);
  SO.area = set_def(SO.area, 'position', defstruct.position); 
  SO.area = set_def(SO.area, 'units', defstruct.units); 
  SO.area = set_def(SO.area, 'valign', defstruct.valign); 
end
SO = set_def(SO, 'clf', 1);

% orientation; string or 4x4 matrix
orientn = [];
SO = set_def(SO, 'transform', 'axial');
if ischar(SO.transform)
  orientn = find(strcmpi(SO.transform, {'axial','coronal','sagittal'}));
  if isempty(orientn)
    error(sprintf('Unexpected orientation %s', SO.transform));
  end
  ts = [0 0 0 0 0 0 1 1 1;...
      0 0 0 pi/2 0 0 1 -1 1;...
      0 0 0 pi/2 0 -pi/2 -1 1 1];
  SO.transform = spm_matrix(ts(orientn,:));
end
% default slice size, slice matrix depends on orientation
if ~is_there(SO,'slicedef' | ~is_there(SO, 'slices'))
  % take image sizes from first image
  V = SO.img(1).vol;
  D = V.dim(1:3);
  T = SO.transform * V.mat;
  vcorners = [1 1 1; D(1) 1 1; 1 D(2) 1; D(1:2) 1; ...
	     1 1 D(3); D(1) 1 D(3); 1 D(2:3) ; D(1:3)]';
  corners = T * [vcorners; ones(1,8)];
  SC = sort(corners');
  vxsz = sqrt(sum(T(1:3,1:3).^2));
  
  SO = set_def(SO, 'slicedef',...
    [SC(1,1) vxsz(1) SC(8,1);SC(1,2) vxsz(2) SC(8,2)]);
  SO = set_def(SO, 'slices',[SC(1,3):vxsz(3):SC(8,3)]);
end

% no colourbars by default
SO = set_def(SO, 'cbars', []);

% always refresh figure window, by default
SO = set_def(SO, 'refreshf', 1);  

% labels
defstruct = struct('colour',[1 1 1],'size',0.075,'format', '%+3.0f');
if ~isfield(SO, 'labels') % no field, -> default
  SO.labels = defstruct;
elseif ~isempty(SO.labels) % empty -> no labels
  % colour for slice labels
  SO.labels = set_def(SO.labels, 'colour', defstruct.colour); 
  % font size normalized to image axis
  SO.labels = set_def(SO.labels, 'size', defstruct.size); 
  % format string for slice labels
  SO.labels = set_def(SO.labels, 'format', defstruct.format); 
end

% callback
SO = set_def(SO, 'callback', ';');

% figure area stuff
defarea = struct('position',[0 0 1 1],'units','normalized');
SO = set_def(SO, 'area', defarea);
if ~is_there(SO.area, 'position')
  SO.area = defarea;
end
if ~is_there(SO.area,'units')
  if (all(SO.area.position>=0 & SO.area.position<=1))
    SO.area.units = 'normalized';
  else
    SO.area.units = 'pixels';
  end
end
SO.area = set_def(SO.area,'halign', 'center');
SO.area = set_def(SO.area,'valign', 'middle');

% printing
SO = set_def(SO, 'printstr', 'print -dpsc -painters -noui');
SO = set_def(SO, 'printfile', 'slices.ps');

% fill various img arguments
% would be nice to use set_def, but we can't

% set colour intensities as we go
remcol = 1;
for i = 1:length(SO.img)
  if ~is_there(SO.img(i),'hold')
    if ~is_there(SO.img(i).vol,'imgdata')
      % normal file vol struct
      SO.img(i).hold = 1;
    else
      % 3d matrix vol struct
      SO.img(i).hold = 0;
    end
  end
  if ~is_there(SO.img(i),'background')
    SO.img(i).background = NaN;
  end
  if ~is_there(SO.img(i),'prop')
    % default is true colour
    SO.img(i).prop = remcol/(length(SO.img)-i+1);
    remcol = remcol - SO.img(i).prop;
  end
  if ~is_there(SO.img(i),'range')
    [mx mn] = volmaxmin(SO.img(i).vol);
    SO.img(i).range = [mn mx];
  end
  if ~is_there(SO.img(i),'cmap')
    if SO.img(i).prop == Inf; % split map
      if SO.range(1)<SO.range(2)
	SO.img(i).cmap = getcmap('hot');
      else
	SO.img(i).cmap = getcmap('winter');
      end
    else                  % true colour
      SO.img(i).cmap = getcmap('actc');
    end
  end  
  if ~is_there(SO.img(i),'outofrange')
    % this can be complex, and depends on split/true colour
    if SO.img(i).prop == Inf % split colour
      if xor(SO.img(i).range(1) < SO.img(i).range(2), ...
	     SO.img(i).range(2) < 0)
	SO.img(i).outofrange = {[0],size(SO.img(i).cmap,1)};
      else
	SO.img(imgno).outofrange={[1], [0]};
      end
    else            % true colour
      SO.img(i).outofrange = {1,size(SO.img(i).cmap,1)};
    end
  end
  for j=1:2
    if isempty(SO.img(i).outofrange{j})
      SO.img(i).outofrange(j) = {0};
    end
  end
  if ~is_there(SO.img(i),'nancol')
    SO.img(i).nancol = 0;
  end
end  
return

function tf = is_there(a, fname)
% returns true if field fname is present in struct a, and not empty
tf = isfield(a, fname);
if tf
  tf = ~isempty(getfield(a, fname));
end
return

function [img, badvals]=scaletocmap(inpimg,mn,mx,cmap,lrn)
img = (inpimg-mn)/(mx-mn);  % img normalized to mn=0,mx=1
cml = size(cmap,1);
if cml==1 % values between 0 and 1 -> 1
  img(img>=0 & img<=1)=1;
else
  img = img*(cml-1)+1;
end
outvals = {img<1, img>cml, isnan(img)};
img= round(img);
badvals = zeros(size(img));
for i = 1:length(lrn)
  if lrn(i)
    img(outvals{i}) = lrn(i);
  else
    badvals = badvals | outvals{i};
    img(outvals{i}) = 1;
  end    
end
return

function st = set_def(st, fld, def)
if ~is_there(st, fld)
  st = setfield(st, fld, def);
end
return

function addblobs(imgno, xyz,vals,mat)
global SO
if isempty(imgno)
  imgno = length(SO.img);
end
if ~isempty(xyz)
  SO.img(imgno).vol = blobs2vol(xyz,vals,mat);
end

function vol = blobs2vol(xyz,vals,mat)
vol = [];
if ~isempty(xyz),
  rcp      = round(xyz);
  vol.dim  = max(rcp,[],2)';
  off      = rcp(1,:) + vol.dim(1)*(rcp(2,:)-1+vol.dim(2)*(rcp(3,:)-1));
  vol.imgdata = zeros(vol.dim)+NaN;
  vol.imgdata(off) = vals;
  vol.imgdata      = reshape(vol.imgdata,vol.dim);
  vol.mat = mat;
end
return

function addmatrix(imgno,mat3d,mat)
global SO
if isempty(imgno)
  imgno = length(SO.img);
end
if nargin<3
  mat = [];
end
if ~isempty(mat3d)
  SO.img(imgno).vol = matrix2vol(mat3d,mat);
end

function vol = matrix2vol(mat3d,mat)
if nargin < 2
  mat = spm_matrix([]);
end
if isempty(mat)
  mat = spm_matrix([]);
end
vol = [];
if ~isempty(mat3d)
  vol.imgdata = mat3d;
  vol.mat = mat;
  vol.dim = size(mat3d);
end
return

function [mx,mn] = volmaxmin(vol)
if is_there(vol, 'imgdata')
    try
        tmp = vol.imgdata(finite(vol.imgdata));
    catch
        tmp = vol.imgdata(isfinite(vol.imgdata));
    end
  mx = max(tmp);
  mn = min(tmp);
else
    mx = -Inf;mn=Inf;
    for i=1:vol.dim(3),
      tmp = spm_slice_vol(vol,spm_matrix([0 0 i]),vol.dim(1:2),[0 NaN]);
      try
      tmp = tmp(find(finite(tmp(:))));
      catch
        tmp = tmp(find(isfinite(tmp(:))));
      end
      
      if ~isempty(tmp)
	mx = max([mx; tmp]);
	mn = min([mn; tmp]);
      end
    end
end
return

function cmap = getcmap(acmapname)
% get colormap of name acmapname
if ~isempty(acmapname)
  cmap = evalin('base',acmapname,'[]');
  if isempty(cmap) % not a matrix, is it...
    % a colour name?
    tmp = strcmp(acmapname, {'red','green','blue'});
    if any(tmp)
      cmap = zeros(64,3);
      cmap(:,tmp) = ((0:63)/63)';
    else
      % a .mat file?
      [p f e] = fileparts(acmapname);
      acmat = fullfile(p, [f '.mat']);
      if exist(acmat, 'file')
	s = struct2cell(load(acmat));
	cmap = s{1};
      end
    end
  end
end
if size(cmap, 2)~=3
  warning('Colormap was not an N by 3 matrix')
  cmap = [];
end
return

function mmpos = getpos
% returns point location from last click, in mm
global SO
mmpos=[];
pos = get(gca, 'CurrentPoint');
u = get(gca, 'UserData');
if is_there(u, 'type')
  if strcmp(u.type, 'slice') % is slice panel
    mmpos = (pos(1,1:2)'-1).*SO.slicedef(:,2)+SO.slicedef(:,1);
    mmpos = inv(SO.transform) * [mmpos; u.no; 1];
    mmpos = mmpos(1:3,1);
  end
end
return

function vals = pointvals(XYZmm, holdlist)
% returns values from all the images at points given in XYZmm
global SO
if nargin < 2
  holdlist = [SO.img(:).hold];
end
X=1;Y=2;Z=3;
nimgs = length(SO.img);
nvals = size(XYZmm,2);
vals = zeros(nimgs,nvals)+NaN;
if size(XYZmm,1)~=4
  XYZmm = [XYZmm(X:Z,:); ones(1,nvals)];
end
for i = 1:nimgs
  I = SO.img(i);
  XYZ = I.vol.mat\XYZmm;
  if ~is_there(I.vol, 'imgdata')
    vol = I.vol;
  else
    vol = I.vol.imgdata;
  end
  vals(i,:) = spm_sample_vol(vol, XYZ(X,:), XYZ(Y,:),XYZ(Z,:),[holdlist(i) ...
		    I.background]);
end  
return

function printfig(filename,printstr)
% print slice overlay figure
% based on spm_figure print, and including fix from thence for ps printing
global SO;
if nargin < 1
  filename = [];
end
if isempty(filename)
  filename = SO.printfile;
end
if nargin < 2
  printstr = '';
end
if isempty(printstr)
  printstr = SO.printstr;
end

%-Note current figure, & switch to figure to print
cF = get(0,'CurrentFigure');
set(0,'CurrentFigure',SO.figure)

%-Temporarily change all units to normalized prior to printing
% (Fixes bizarre problem with stuff jumping around!)
%-----------------------------------------------------------------------
H  = findobj(get(SO.figure,'Children'),'flat','Type','axes');
un = cellstr(get(H,'Units'));
set(H,'Units','normalized')

%-Print
%-----------------------------------------------------------------------
err = 0;
try, eval([printstr ' ' filename]), catch, err=1; end
if err
	errstr = lasterr;
	tmp = [find(abs(errstr)==10),length(errstr)+1];
	str = {errstr(1:tmp(1)-1)};
	for i = 1:length(tmp)-1
		if tmp(i)+1 < tmp(i+1) 
			str = [str, {errstr(tmp(i)+1:tmp(i+1)-1)}];
		end
	end
	str = {str{:},	'','- print command is:',['    ',printstr ' ' filename],...
			'','- current directory is:',['    ',pwd],...
			'','            * nothing has been printed *'};
	for i=1:length(str)
	  disp(str{i});end
end

set(H,{'Units'},un)
set(0,'CurrentFigure',cF)

return


