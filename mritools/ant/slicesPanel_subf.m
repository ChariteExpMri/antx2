



% subfunction of checkRegist
function slicesPanel_subf(fi,orient,slices,flip, varargin)


% % if 0
% %     
% %     fi= { ...
% %         fullfile('O:\data4\recode2Rat_WHS2\dat\t_fastsegm','x_t2.nii');
% %         fullfile('O:\data4\recode2Rat_WHS2\dat\t_fastsegm','AVGT.nii')};
% %     test11(fi,2,'n20', 1);
% % 
% %     
% % end

fi=cellstr(fi);
us.f1=fi{1};
if length(fi)==2
   us.f2=fi{2};
end
us.dim    =orient;
us.slices =slices;
us.flip   =flip;

delete(findobj(gcf,'tag','imo'))
us.col1nr=1;
us.col2nr=2;
us.cols={'gray' 'parula' 'jet' 'hot' 'gray' 'summer',};
us.fusetype=2;


% 
% clc
% %
% % f1=fullfile(pwd,'t2.nii')
% % f2=fullfile(pwd,'c1t2.nii');
% % [d ds]=getslices(f1,1,['n20'],[],0 );
% % [o os]=getslices({f1 f2},1,['n20'],[],0 );
% % flip=0
% 
% 
% % us.f1=fullfile(pwd,'x_t2.nii');
% % us.f2=fullfile(pwd,'x_c1t2.nii');
% % us.dim=2;
% % us.flip=1;
% % showit(us)
% 
% % us.f1=fullfile(pwd,'t2.nii');
% % us.f2=fullfile(pwd,'ix_AVGT.nii');
% us.f1=fullfile(pwd,'x_t2.nii');
% % us.f2=fullfile(pwd,'AVGT.nii');
% us.dim=2;
% us.flip=1;
% us.slices=['n20'];


if 1
    global checkrr
    try;  us.slices =checkrr.slices ;end
    try;  us.flip   =checkrr.flip   ;end
    try;  us.dim    =checkrr.dim    ;end
    try;  us.col1nr =checkrr.col1nr ;end
    try;  us.col2nr   =checkrr.col2nr ;end
    try;  us.fusetype =checkrr.fusetype ;end
    
end

% disp(['us.dim: ' num2str(us.dim)]);
showit(us);





function us=showit(us)

if ~isempty(findobj(gcf,'tag','imo'))
    him=findobj(gcf,'tag','imo');
    us=get(him,'userdata');
end

[d ds]=getslices(us.f1,     us.dim,us.slices,[],0 );
us.nimg=1;
try
    [o os]=getslices({us.f1 us.f2},us.dim,us.slices,[],0 );
    us.nimg=2;
end


s1={d,ds};
try
s2={o os} ;
catch
    s2=[];
end


% % if 0
% %     pa='O:\data4\phagozytose\dat\20190219CH_Exp1_M8'
% %     f1=fullfile(pa,'t2.nii');
% %     f2=fullfile(pa,'_msk.nii');
% %     [d ds]=getslices(f1     ,1,['5'],[],0 );
% %     [o os]=getslices({f1 f2},1,['5'],[],0 );
% %     
% %     outpath=fullfile(pa,'summary')
% %     saveslices_gif({d,ds},{o os}, 1,outpath);
% % end


% checks
d=s1{1}; ds=s1{2};
if ~isempty(s2)
    o=s2{1}; os=s2{2};
end

%=============================================
sliceadjust=0;
%=============================================

if sliceadjust==1
    for i=1:size(d,3)
        d(:,:,i)=imadjust(mat2gray(d(:,:,i)));
    end
    if exist('o')==1
        for i=1:size(d,3)
            o(:,:,i)=imadjust(mat2gray(o(:,:,i)));
        end
    end
end

%=============================================
if us.flip==1;     flipup = @(x) flipdim(x,1);
else;              flipup = @(x) (x);
end


d=flipup(d);
if exist('o')==1
    o     =flipup(o);
    mxval2=max(o(:));
end

mxval1=max(d(:));
percdown=.05;

for i=1:size(d,3)
    tx=text2im(sprintf('%2.2f',ds.smm(i)));
    %    if (size(tx,1)<size(d,1)) && (size(tx,2)<size(d,2))
    %    tx=imresize(tx,[round(size(tx)*1.5)],'nearest');
    %    end
    fs=round(size(d,1)*percdown);
    if fs<10
        fs=10;
    end
    
    tx=imresize(tx,[fs nan],'nearest');
    tx1=(~tx).*mxval1;
    
    d(2:size(tx,1)+1,1:size(tx,2),i)=tx1;
    if exist('o')==1
        tx2=(~tx).*mxval2;
        o(2:size(tx,1)+1,1:size(tx,2),i)=tx2;
    end
end



%———————————————————————————————————————————————
%%
%———————————————————————————————————————————————



d2=montageout(permute(d,[1 2 4 3]));
if sliceadjust==1
    [d3 cmap1]=gray2ind(d2);
else
    [d3 cmap1]=gray2ind(imadjust(mat2gray( (d2))));
end

if exist('o')==1
    o2=montageout(permute(o,[1 2 4 3]));
    if sliceadjust==1
        [o3 cmap2]=gray2ind(o2);
    else
        [o3 cmap2]=gray2ind(imadjust(mat2gray( (o2))));
    end
end

% ==============================================
%%
% ===============================================






G  = single(d3);
eval(['C=' us.cols{us.col1nr} ';']);% C = gray;  % Get the figure's colormap.
L  = size(C,1);
Gs = round(interp1(linspace(min(G(:)),max(G(:)),L),1:L,G));% Scale the matrix to the range of the map.
H  = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.

him=findobj(gcf,'tag','imo');
if isempty(him)
    him=image(H);
    set(him,'ButtonDownFcn',@flipimg,'tag','imo');
%     key1=get(gcf,'windowKeyPressFcn')
%     set(gcf,'windowKeyPressFcn',{key1;@KeyPressFcn2});
     %    iptaddcallback(gcf, 'windowKeyPressFcn', @KeyPressFcn2);
    set(gcf,'windowKeyPressFcn',@KeyPressFcn2);
    axis off;
else
    if us.toggle==1
        set(him,'cdata',H);
    end
end
ylim([1 size(H,1)]);
xlim([1 size(H,2)]);

try
    G  =single(o3);
    %C2 = parula;  % Get the figure's colormap.
    eval(['C2=' us.cols{us.col2nr} ';']);% C = gray;  % Get the figure's colormap.
    L  = size(C2,1);
    % Scale the matrix to the range of the map.
    Gs = round(interp1(linspace(min(G(:)),max(G(:)),L),1:L,G));
    H2 = reshape(C2(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.
catch
    o3=[];
    H2=[];
end

us.bg     =H;
us.fg     =H2;
us.bg0    =single(d3);
us.fg0    =single(o3);
us.toggle =1;
him       =findobj(gcf,'tag','imo');
set(him,'userdata',us,'tag','imo');

if us.fusetype==1
    fuse([],[]);
else
    fuse2([],[]);
end
drawnow

global checkrr
checkrr=us;


function flipimg(e,e2)

him=findobj(gcf,'tag','imo'); 
us=get(him,'userdata');
if us.nimg==2
    us=get(e,'userdata');
    if us.toggle==1
        us.toggle=2;
        set(e,'CData',us.fg);
    else
        us.toggle=1;
        set(e,'CData',us.bg);
    end
    set(e,'userdata',us);
end
% ==============================================
%%   keys
% ===============================================

function KeyPressFcn2(e,e2)
him=findobj(gcf,'tag','imo');

if isempty(e2.Modifier)
    if strcmp(e2.Key,'leftarrow')
        %     mouse([],[],-1);
        hb=findobj(gcf,'tag','prev');
        cb=get(hb,'callback');
        hgfeval(cb{1},[],[],cb{2});
        
    elseif strcmp(e2.Key,'rightarrow')
        %     mouse([],[],1);
        hb=findobj(gcf,'tag','next');
        cb=get(hb,'callback');
        hgfeval(cb{1},[],[],cb{2});
    end
end


if strcmp(e2.Character,'#')
   xslixe
    showit([]);
end
if strcmp(e2.Character,',')
   us=get(him,'userdata');
   
   try
       us.dim=us.dim+1;
       if us.dim>3
           us.dim=1;
       end
       set(him,'userdata',us);
       showit(us);
   end
   
   
% % %     r=findobj(gcf,'tag','imo');     flipimg(r,[]);
end
if strcmp(e2.Key,'n') 
    recolor_bg;
end
if strcmp(e2.Key,'m') 
    recolor_fg;
end


if strcmp(e2.Key,'f')
    flip;
end
% if  strcmp(e2.Character,'.')
%     fuse;
% end
if strcmp(e2.Character,'.')
    us=get(him,'userdata');
    if us.fusetype==1
    fuse2;
    else
     fuse;   
    end
    
end

if strcmp(e2.Key,'1')
    him=findobj(gcf,'tag','imo');
    us=get(him,'userdata');     us.dim=1;     set(him,'userdata',us);
    showit([]);
end
if strcmp(e2.Key,'2')
    him=findobj(gcf,'tag','imo');
    us=get(him,'userdata');     us.dim=2;     set(him,'userdata',us);
    showit([]);
end
if strcmp(e2.Key,'3')
    him=findobj(gcf,'tag','imo');
    us=get(him,'userdata');     us.dim=3;     set(him,'userdata',us);
    showit([]);
end

if isempty(e2.Modifier)
    if strcmp(e2.Character,'+') || strcmp(e2.Character,'-')
        us=get(gcf,'userdata');
        fontstep=1;
        if strcmp(e2.Character,'-');
            fontstep=-1;
        end
        ht=us.ax2;
        nFS=get(ht,'fontsize')+fontstep;
        if nFS>0
            set(ht,'fontsize',nFS);
        end
    end
elseif ~isempty(strfind(e2.Modifier,'control'))
    if strcmp(e2.Key,'rightarrow') || strcmp(e2.Key,'leftarrow')
        us=get(gcf,'userdata');
       
        rotstep=1;
        if strcmp(e2.Key,'leftarrow');
            rotstep=-1;
        end
        
        %ht=findobj(gcf,'type','text','-and','UserData','xtick');
        ht=us.ax2;
        nROT=get(ht,'XTickLabelRotation')+rotstep;
        % if nFS>0
        set(ht,'XTickLabelRotation',nROT);
        %end
    end   
end




%% —————————————————————————————————————————————————————————————————————————————————————————————————
%% COLORIZE
function recolor_bg(e,e2)
him=findobj(gcf,'tag','imo'); 
us=get(him,'userdata');
cols=us.cols;
% if isfield(us,'col1nr')==0;     us.col1nr=1;    set(him,'userdata',us);end
us.col1nr=us.col1nr+1;
if us.col1nr>length(cols);us.col1nr=1; end
eval(['map=' cols{us.col1nr} ';']);

G  = single(us.bg0);  % #BG-image
C2 = map;  % Get the figure's colormap.
L  = size(C2,1);
Gs = round(interp1(linspace(min(G(:)),max(G(:)),L),1:L,G));% Scale the matrix to the range of the map.
H2 = reshape(C2(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.

us.bg=H2;      % #BG-image
 us.toggle=1 ;% #BG-image
set(him,'userdata',us,'tag','imo');
global checkrr
checkrr.col1nr=us.col1nr;
set(him,'cdata',H2);  



function recolor_fg(e,e2)
him       = findobj(gcf,'tag','imo'); 
us        = get(him,'userdata');
cols      = us.cols;
if  us.nimg==1; return; end
us.col2nr = us.col2nr+1;

if us.col2nr>length(cols);us.col2nr=1; end
eval(['map=' cols{us.col2nr} ';']);

G  = single(us.fg0);  % #FG-image
C2 = map;  % Get the figure's colormap.
L  = size(C2,1);
Gs = round(interp1(linspace(min(G(:)),max(G(:)),L),1:L,G));% Scale the matrix to the range of the map.
H2 = reshape(C2(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.

us.fg=H2;      % #FG-image
us.toggle=2 ; % #FG-image
set(him,'userdata',us,'tag','imo');
global checkrr
checkrr.col2nr=us.col2nr;
  set(him,'cdata',H2);  

%% —————————————————————————————————————————————————————————————————————————————————————————————————


function fuse(e,e2)
him=findobj(gcf,'tag','imo'); 
us=get(him,'userdata');
if us.nimg==2
    if isempty(us.fg);return; end
    fu=imfuse(us.bg,us.fg);
    set(him,'cdata',fu);
end
us.fusetype=1;
set(him,'userdata',us);
global checkrr;
checkrr.fusetype=1;

function fuse2(e,e2)
him=findobj(gcf,'tag','imo'); 
us=get(him,'userdata');
if us.nimg==2
    fu = imfuse(us.bg,us.fg,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
    set(him,'cdata',fu);
end
us.fusetype=2;
set(him,'userdata',us);
global checkrr;
checkrr.fusetype=2;

function flip(e,e2)
him=findobj(gcf,'tag','imo');
us=get(him,'userdata');
if us.flip==1; us.flip=0;
else ;us.flip=1;
end
set(him,'userdata',us);
showit([]);



function xslixe(e,e2)
him=findobj(gcf,'tag','imo'); 
us=get(him,'userdata');
slic={'n8' 'n4' 'n20' '10' '5'  '2' };

if isfield(us,'slincNum')==0
    us.slincNum=1;
    set(him,'userdata',us);
end
us.slincNum=us.slincNum+1;
if us.slincNum>length(slic);us.slincNum=1; end


us.slices=slic{us.slincNum};
set(him,'userdata',us);






