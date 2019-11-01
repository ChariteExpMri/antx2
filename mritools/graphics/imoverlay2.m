function [hF,hB] = imoverlay(B,F,climF,climB,cmap,alpha,flips, add)

if 0
    [ha a]=rgetnii('O:\harms1\harms2\dat\s20150505SM04_1_x_x\AVGT.nii');
    [hb b]=rgetnii('O:\harms1\harms2\dat\s20150505SM04_1_x_x\x_t2.nii');
imoverlay2(a(:,40:10:170,:),b(:,40:10:170,:),[],[],jet,[.5],'af');; grid minor; set(gca,'xcolor','r','ycolor','r'); axis image;

end

v.isFempty=0;
if isempty(F); F=B; end
if isempty(B); B=F; end

% IMOVERLAY(B,F) displays the image F transparently over the image B.
%    If the image sizes are unequal, image F will be scaled to the aspect
%    ratio of B.
%
%    [hF,hB] = imoverlay(B,F,[low,high]) limits the displayed range of data
%    values in F. These values map to the full range of values in the
%    current colormap.
%
%    [hF,hB] = imoverlay(B,F,[],[low,high]) limits the displayed range of
%    data values in B.
%
%    [hF,hB] = imoverlay(B,F,[],[],map) applies the colormap to the figure.
%    This can be an array of color values or a preset MATLAB colormaps
%    (e.g. 'jet' or 'hot').
%
%    [hF,hB] = imoverlay(B,F,[],[],[],alpha) sets the transparency level to
%    alpha with the range 0.0 <= alpha <= 1.0, where 0.0 is fully
%    transparent and 1.0 is fully opaque.
%
%    [hF,hB] = imoverlay(B,F,[],[],[],[],ha) displays the overlay in the
%    axes with handle ha.
%
%    [hF,hB] = imoverlay(...) returns the handles to the front and back
%    images.
%
%
% Author: Matthew Smith / University of Wisconsin / Department of Radiology
% Date created:  February 6, 2013
% Last modified: Jan 2, 2015
%
%
%  Examples:
%
%     % Overlay one image transparently onto another
%     imB = phantom(256);                       % Background image
%     imF = rgb2gray(imread('ngc6543a.jpg'));   % Foreground image
%     [hf,hb] = imoverlay(imB,imF,[40,180],[0,0.6],'jet',0.6);
%     colormap('parula'); % figure colormap still applies
%
%
%     % Use the interface for flexibility
%     imoverlay_tool;
%
%
% See also IMOVERLAY_TOOL, IMAGESC, HOLD, CAXIS.


if exist('add')==0 ; add=struct([])  ; end

if ndims(B)==2
  ftx=zeros(size(F)); %TEXT
         ftx(1,1,:,:)=1:size(F,4);
end

if ndims(B)==3
    if exist('flips')
        if ~isempty(flips)
            if strfind(flips,'a')
                B=permute(B,[3 1 4 2]);
                F=permute(F,[3 1 4 2]);
            end
        else
            B=permute(B,[1 2 4 3]);
            F=permute(F,[1 2 4 3]);
        end
        if strfind(flips,'f')
            B=flipdim(B,1); 
            F=flipdim(F,1);
        end
        screen=get(0,'screensize');
        fc=screen(3)/screen(4);
        nrc=round([ sqrt(size(B,4)/fc) sqrt(size(B,4)/fc)*fc  ]);
        nslices=size(B,4);
        if prod(nrc)<nslices; nrc(2)=nrc(2)+1; end
       if prod(nrc)<nslices; nrc(1)=nrc(1)+1; end 
       if sqrt(nslices)==round(sqrt(nslices))  ; nrc=[sqrt(nslices)  sqrt(nslices)  ]; end %quadratic
       
       if exist('add') %%define number of pannels
           if isfield(add,'nsb');
               if ~isempty(add.nsb)
                   nrc=add.nsb;
                   if length(nrc==2)
                       if isnan(nrc(1));  nrc(1)=ceil(size(B,4)/nrc(2)); end
                        if isnan(nrc(2)); nrc(2)=ceil(size(B,4)/nrc(1)); end
      
                       
                   end
               end
           end
       end
       
        B = montageout(B,'Size', nrc);
        ftx=zeros(size(F)); %TEXT
         ftx(1,1,:,:)=1:size(F,4);
        F = montageout(F,'Size', nrc);
         ftx = montageout(ftx,'Size', nrc);
    end
end

B=imadjust(B./max(B(:)));
try
    if length(unique(F))>20
        F=imadjust(F./max(F(:)));
    else
        F=(F./max(F(:)));
    end
end




ALPHADEFAULT = 0.4; % Default transparency value
CMAPDEFAULT = 'parula';

if nargin == 0,
    try
        imoverlay_tool;
        return;
    catch
        errordlg('Cannot find imoverlay_tool.', 'Error');
    end
end


% Check image sizes
if size(B,3) > 1
    error('Back image has %d dimensions!\n',length(size(B)));
end
if size(F,3) > 1
    error('Front image has %d dimensions!\n',length(size(F)));
end
if ~isequal(size(B),size(F))
    fprintf('Warning! Image sizes unequal. Undesired scaling may occur.\n');
end

% Check arguments
haxes = [];


if nargin < 6 || isempty(alpha)
    alpha = ALPHADEFAULT;
end

if nargin < 5 || isempty(cmap)
    cmap = CMAPDEFAULT;
end

if nargin < 4 || isempty(climB)
    climB = [min(B(:)), max(B(:))];
end

if nargin < 3 || isempty(climF)
    try
    climF = [min(F(:)), max(F(:))];
    end
end

if abs(alpha) > 1
    error('Alpha must be between 0.0 and 1.0!');
end


% Create a figure unless axes is provided
if isempty(haxes) || ~ishandle(haxes)
    f=figure('Visible','off',...
        'Units','pixels','Renderer','opengl');
    pos = get(f,'Position');
    set(f,'Position',[pos(1),pos(2),size(B,2),size(B,1)]);
    haxes = axes;
    set(haxes,'Position',[0,0,1,1]);
    movegui(f,'center');
    
    % Create colormap
    cmapSize = 100; % default size of 60 shows visible discretization
    if ischar(cmap)
        
        try
            cmap = eval([cmap '(' num2str(cmapSize) ');']);
        catch
            fprintf('Colormap ''%s'' is not supported. Using ''jet''.\n',cmapName);
            cmap = jet(cmapSize);
        end
    end
    colormap(cmap);
end

% To have a grayscale background, replicate image to 3-channels
B = repmat(mat2gray(double(B),double(climB)),[1,1,3]);

if 0
    % Display the back image
    axes(haxes);
    hB = imagesc(B);axis image off;
    % set(gca,'Position',[0,0,1,1]);
    
    % Add the front image on top of the back image
    hold on;
    hF = imagesc(F,climF);
end

if nargin < 4 || isempty(climB)
    climB = [min(B(:)), max(B(:))];
end

% if nargin < 3 || isempty(climF)
%     try
%     climF = [min(F(:)), max(F(:))];
%     end
% end
%     climF = [min(F(:)), max(F(:))];
%  climF = [-.01 max(F(:))];


%%%% MERKE
%  if climF(1)==0; climF(1)=-.000001; end
% climF



fg;
hB = imagesc(B);
hold on
if v.isFempty==0
    hF = imagesc(F,climF);
end
if isfield(add,'fontsize')
    fs=add.fontsize;
else
    fs=8;
end


%% paneltitle
if 1
    if isfield(add,'title')
        if exist('ftx')==0; return; end
        uni=unique(ftx);uni(uni==0)=[];
        for i=1:length(uni)
            [q(i,1) q(i,2)]= find(ftx==uni(i));
        end
        for i=1:size(q,1)
            ht(i)=text(q(i,2) ,q(i,1), add.title{i},'tag','tx1' );
        end
        set(ht,'color','w','interpreter','none');
        set(ht,'verticalalignment','top','fontsize',fs);
    end
end
down=15;

if 1
    if isfield(add,'title2')
        if exist('ftx')==0; return; end
        uni=unique(ftx);uni(uni==0)=[];
        for i=1:length(uni)
            [q(i,1) q(i,2)]= find(ftx==uni(i));
        end
        for i=1:size(q,1)
            ht(i)=text(q(i,2) ,q(i,1)+down, add.title2{i},'tag','tx11' );
        end
        set(ht,'color','w','interpreter','none');
        set(ht,'verticalalignment','top','fontsize',fs);
        down=down+15;
    else
        down=15;
    end
    
end




%% coordinates+sliceID
if 1
    if isfield(add,'cord')
        if exist('ftx')==0; return; end
        uni=unique(ftx);uni(uni==0)=[];
        for i=1:length(uni)
            [q(i,1) q(i,2)]= find(ftx==uni(i));
        end
        mx=(max(diff(sort(q))));
        if iscell(add.cord)
            for i=1:size(q,1)
                ht(i)=text(q(i,2) ,q(i,1)+down,   add.cord{i},'tag','tx2' );
            end
        else
            for i=1:size(q,1)
                ht(i)=text(q(i,2) ,q(i,1)+down,   sprintf('%i    %2.2f',add.cord(i,:)),'tag','tx2' );
            end
        end
        set(ht,'color','w','interpreter','none');
        set(ht,'verticalalignment','top','fontsize',fs,'fontweight','bold');
    end
end


% If images are different sizes, map the front image to back coordinates
if v.isFempty==0
    set(hF,'XData',get(hB,'XData'),...
        'YData',get(hB,'YData'))
    % Make the foreground image transparent
    % alphadata = alpha.*(F >= climF(1));
    alphadata = alpha.*(F > climF(1));
    set(hF,'AlphaData',alphadata);
else
    
end

set(gca,'units','norm','pos',[0.01 0.01 .98 .98]);
set(gcf,'units','normalized');

grid minor; set(gca,'xcolor','r','ycolor','r'); axis image;



cmaps=    { colormap 'parula'    'vga'       'jet'                'hsv'         'hot'       'gray'        'bone'         'copper'         'pink'         'white'       'flag' ...
    'lines'        'colorcube'         'cool'        'prism'    'autumn'     'spring' ...
    'winter'       'summer'             };

 colormap(cmap);
 grid off
 axis off;



% fg,imagesc(F.*check)

% if exist('f')
%     set(f,'Visible','on');
% end
us.B=B;
us.F=F;
us.alphadata=alphadata;
us.hB=hB;
us.hF =hF;
us.climF=climF;
us.alphadata=alphadata;
us.alpha=alpha;
us.toggle=1;
us.cmap=1;
us.cmaps=cmaps;
set(gcf,'userdata',us);

set(gcf,'KeyPressFcn',@keypress1)
set(findobj(gcf,'type','image'),'HitTest','off')
set(gcf,'name','TYPE [H] for SHORTCUTS-HELP');

function keypress1(a,b)
us=get(gcf,'userdata');
%         if strcmp(b.Key, 'rightarrow')
%             set(us.hF,'AlphaData',ones(size(us.alphadata)));%'R'
%         elseif strcmp(b.Key, 'leftarrow')
%             set(us.hF,'AlphaData',us.alphadata.*0);%'L'
if strcmp(b.Key, 'leftarrow')
    if isfield(us,'toggleMIXBG')==0
      us.toggleMIXBG=0;
    end
    us.toggleMIXBG=us.toggleMIXBG+1;
    if mod(us.toggleMIXBG,2)==1
         set(us.hF,'AlphaData',us.alphadata);%'O'
    else
        set(us.hF,'AlphaData',us.alphadata.*0);%'O'
    end
 set(gcf,'userdata',us);    
 
 
 %% UP-down-keys
 elseif strcmp(b.Key, 'uparrow')  %CORDs ON /OFF
    stp=0.1;
    if us.alpha+stp > 1 ; return;     end
 
    us.alpha     = us.alpha + stp;
    us.alphadata = us.alpha.*(us.F > us.climF(1));
    set(us.hF,'AlphaData',us.alphadata);
    set(gcf,'userdata',us);
 elseif strcmp(b.Key, 'downarrow')  %CORDs ON /OFF
    stp=0.1;
    if us.alpha-stp < 0  ; return;     end
 
    us.alpha     = us.alpha -stp;
    us.alphadata = us.alpha.*(us.F > us.climF(1));
    set(us.hF,'AlphaData',us.alphadata);
    set(gcf,'userdata',us);
 
 
 
elseif strcmp(b.Key, 'z')  %CORDs ON /OFF
        if isfield(us,'toggleCORD')==0
            us.toggleCORD=0;
        end
        us.toggleCORD=us.toggleCORD+1;
        if mod(us.toggleCORD,2)==1
           set(findobj(gcf,'tag','tx2'),'visible','off')
        else
            set(findobj(gcf,'tag','tx2'),'visible','on')
        end
     set(gcf,'userdata',us);
    
   elseif strcmp(b.Key, 't')      %NAME ON/OFF
        if isfield(us,'toggleCORD')==0
            us.toggleCORD=0;
        end
        us.toggleCORD=us.toggleCORD+1;
        if mod(us.toggleCORD,2)==1
           set(findobj(gcf,'tag','tx1'),'visible','off');
           try; set(findobj(gcf,'tag','tx11'),'visible','off'); end
        else
            set(findobj(gcf,'tag','tx1'),'visible','on');
            try; set(findobj(gcf,'tag','tx11'),'visible','on'); end

        end
     set(gcf,'userdata',us);
     
     
    
elseif strcmp(b.Key, 'rightarrow')
    mod(us.toggle,2);
    if mod(us.toggle,2)==0
        set(us.hF,'AlphaData',ones(size(us.alphadata)));%'R'
    else
        set(us.hF,'AlphaData',us.alphadata.*0);%'L'
    end
    us.toggle=us.toggle+1;
    set(gcf,'userdata',us);
    us.toggle;
elseif strcmp(b.Key, 'c')
    if us.cmap==1; return; end
    us.cmap=us.cmap-1;
    set(gcf,'userdata',us);
    cmap=us.cmaps{   rem([us.cmap]-1,length(us.cmaps))+1   };
    colormap(cmap)
elseif strcmp(b.Key, 'v')
    if us.cmap==length(us.cmaps)
        return
    end
    us.cmap=us.cmap+1;
    set(gcf,'userdata',us);
    cmap=us.cmaps{   rem([us.cmap]-1,length(us.cmaps))+1   };
    colormap(cmap)
    %           rem([us.cmap]-1,length(us.cmaps))+1
   elseif strcmp(b.Key, 's') 
    slice=input('type slicenumber: ' );
    add=us.add;
    add.slice=slice;
    warp_summary(add);
   elseif strcmp(b.Key, 'h') 
       
       %% bka
       hh={};
       hh{end+1,1}=( ' #yk ***  IMAGE-SHORTCUTS  ***' );
       hh{end+1,1}=(' §b [left]    §k    toggle imageFusion/image1');
       hh{end+1,1}=(' §b [right]   §k    toggle image1/image2');
       hh{end+1,1}=(' §b [up/down] §k    increase/decrease alpha-blending');
       hh{end+1,1}=(' §b [c/v]     §k    change colormap (forward/backward)' );

       hh{end+1,1}=(' §b [z]       §k    show/hide coordinates  ');
       hh{end+1,1}=(' §b [t]       §k    show/hide labels  ');
       
       uhelp(hh,1,'position',[ 0.7378    0.7633    0.2601    0.130])  ; 
       drawnow;
 
       
       %% cdc
    
end


% Novel colormaps
figure(gcf)
%
% JET2 is the same as jet but with black base
function J = jet2(m)
if nargin < 1
    m = size(get(gcf,'colormap'),1);
end
J = jet(m); J(1,:) = [0,0,0];


% JET3 is the same as jet but with white base
function J = jet3(m)
if nargin < 1
    m = size(get(gcf,'colormap'),1);
end
J = jet(m); J(1,:) = [1,1,1];


% PARULA2 is the same as parula but with black base
function J = parula2(m)
if nargin < 1
    m = size(get(gcf,'colormap'),1);
end
J = parula(m); J(1,:) = [0,0,0];


% HSV2 is the same as HSV but with black base
function map = hsv2(m)
map =hsv;
map(1,:) = [0,0,0];


% HSV3 is the same as HSV but with white base
function map = hsv3(m)
map =hsv;
map(1,:) = [1,1,1];


% HSV4 a slight modification of hsv (Hue-saturation-value color map)
function map = hsv4(m)
if nargin < 1, m = size(get(gcf,'colormap'),1); end
h = (0:m-1)'/max(m,1);
if isempty(h)
    map = [];
else
    map = hsv2rgb([h h ones(m,1)]);
end



