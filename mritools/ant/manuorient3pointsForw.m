% manual reorient an image using 3-point method
%    reference (Ref in GUI): static image
%    source (Source in GUI): image that should be reoriented
% #r ____________________________________
% #r SPECIAL CASE: 
% #r To obtain the reorientation for "t2.nii" (native space) to "AVGT.nii" (standard space)
% #r "t2.nii" must be the REFERENCE and and "AVGT.nii" must be the SOURCE.
% #r ____________________________________
%
%
% #ok GUI HELP
% The gui shows dimension-dependend slices for the reference (left) and the source (right) image.
% Please examine tooltips to obtain f.. 
% #k STEPS TO reorient the source image 
% [1] Select the coronal view  by selection one the dim1,dim2 or
%     dim3 buttons for both, the reference and source image.
% [2] If necessary change the number of displayed sliced in the respective edit-box below
%     the dim1/dim2/dim3 button
% [3] point/landmark selection in both images
% [3a] Select [OB]-radio (in the middle between images), or hit [1] keyboard-key
%      Now click the image position where the olfactory bulbus is located in both images
%      (i.e. for reference and source image).
%      -> At the clicked position (OB) you should see a #r red dot #n in both images
%      -> click onto another image position to change the position of the point
% [3b] Select [SUB]-radio (in the middle between images), or hit [2] keyboard-key
%      Now click a point with following matching criteria:
%        -find a middle slice in anterior-to-posterior direction
%        -find interhemispheric position in left-right direction
%        -find superior position in inferior-superior direction
%      Do this for both, the reference and source image.
%      -> At the clicked position (SUB) you should see a #g green dot #n in both images
%      -> click onto another image position to change the position of the point
% [3c] Select [INF]-radio (in the middle between images), or hit [3] keyboard-key
%      Now click a point with following matching criteria:
%        -find a middle slice in anterior-to-posterior direction (same slice as in [3b])
%        -find interhemispheric position in left-right direction (same as in [3b])
%        -find inferor position in inferior-superior direction
%      Do this for both, the reference and source image.
%      -> At the clicked position (INF) you should see a #b blue dot #n in both images
%      -> click onto another image position to change the position of the point
% [4] optional: click dim1/dim2 or dim3 buttons to visualize the three point from different 
%     directions 
% [5] optional, in the pulldown menu above [Check] button select the way to visualize the reorientation
%      either "matching image" (panel window), "MRICRON" (overlay) or both
% [6] If the three points are set for ref and source image click #k [Check]  button
%      to visualize the reoriented result (this depends on [5])
%    #k for the "matching image" (panel window) inspect the max-projection of row-1 only
%    - here you may change - the number of slices (default: 5) used for max projection
%                          - the colormap (pulldown menu) or use [c] or [shift+c] to cycle through
%                            colormaps
%   #k The ROTATIONS and TRANSLATIONS are displayed in Matlabs command window
% #r NOTE ____________________________________________________________
% #r In case you are only interested in obtaining the appropriate rotations to get
% #r "t2.nii" (native space) properly reoriented to match the orientation of "AVGT.nii"
% #r (standard space).. you can stop here and click the [Close button]!!! 
% #r .. Next, copy the ROTATIONS depicted in Matlabs command window and paste it as 
% #r in your project file (proj*.m) in the field "x.wa.orientType" 
% #r (example: x.wa.orientType='0 -1.5708 -3.1416';)
% #r _________________________________________________________________
% [7] optional: if reorientation is not sufficient..relocated landmarks
% [8] optional: click [transform] button to reorient the source image (and if selected the apply images)
%    -in this case the reoriented images will be saved as with prefix (default "O") in the same
%     directory where the source image (or apply images) is located
% [9] click [Close] to close this GUI  
% 
% 
% #ok FUNCTION HELP
% #g FUNCTION INPUT
% -manuorient3points uses a struct as input with following fields:
% f1:   REFERENCE image --fullpath filename of the reference image, <string>
% f2:   SOURCE image    --fullpath filename of the source image, <string>
% 
% *** OPTIONAL INPUTS ***
% f3:   APPLY IMAGES    --fullpath filenames of images that should be reoriented <cell>, ..optional
% info: info displayed as windowtitle <string>,  ..optional
% wait: window is in busy mode (1) or not (0),  ..optional, default is 1
% usetranslation: use also translation parameter for APPLY IMAGES [0/1]
%                 if [0]: only rotation paramter applied for APPLY IMAGES
%                 if [1]: translation and rotation paramter applied for APPLY IMAGES    
% prefix:       prefix for output file name of APPLY IMAGES, default is 'O' (oriented)
% savetrafo:    [0,1], if [1] the transformation is also stored as matfile
% showmatch:     [0,1] if [1] result is shown in separate panel window
% showMricron:  [0,1] if [1] result is shown in MRICRON
% showlabels:  [0,1] show/hide labels "ref"/"source" in title ;  dwfault:[1]
%     
% #g command line execution
% manuorient3points(struct)
%
% % #g example
% p.f1=fullfile(pwd,'t2.nii');   % REFIMAGE
% p.f2=fullfile(pwd,'AVGT.nii'); % SOURCE
% p.f3='';{fullfile(pwd,'applyimg1_firstEPI2.nii'); fullfile(pwd,'applyimg1_firstEPI2.nii')}; % APPLYIMGs
% p.info='3/23 dataset'; % info
% p.wait=1;              % busy mode
% manuorient3points(p);  % execute function
% 
% 
% 

function manuorient3points2(p)
% clc
if 0
    manuorient3points()
end

if 0
    p.f1=fullfile(pwd,'t2.nii');        %REFIMAGE
    p.f2=fullfile(pwd,'firstEPI2.nii'); %SOURCE
    p.f3='';{fullfile(pwd,'applyimg1_firstEPI2.nii'); fullfile(pwd,'applyimg1_firstEPI2.nii')}; %APPLYIMG
    p.info='3/23';
    p.wait=1
    manuorient3points(p)
    
end

if 0
    ps='O:\data5\AG_waicies\dat\vers1'
    p.f1=fullfile(ps,'t2.nii');        %REFIMAGE
    p.f2=fullfile(ps,'AVGT.nii'); %SOURCE
    p.f3='';{fullfile(ps,'applyimg1_firstEPI2.nii'); fullfile(ps,'applyimg1_firstEPI2.nii')}; %APPLYIMG
    p.info='3/23';
    p.wait=1
    manuorient3points(p)
end


if exist('p')==0
    p.f1='';
    p.f2='';
    p.f3='';
end

if isempty(p.f1)
    [t,sts] = spm_select(1,'image',' [1 of 2] select REFERENCE IMAGE','',pwd,'^.*.nii',1);
    p.f1=strtok(t,',');
end
if isempty(p.f2)
    [t,sts] = spm_select(inf,'image',' [2 of 2] select SOURCE IMAGE and optional additional apply images)','',pwd,'^.*.nii',1);
    t=regexprep(cellstr(t),',.*','');
    p.f2=t{1};
    if length(t)>1
        p.f3=t(2:end);
    end
    
    
end



% -----PARAMETER
if 0
    p.f1=fullfile(pwd,'t2.nii');        %REFIMAGE
    p.f2=fullfile(pwd,'firstEPI2.nii'); %SOURCE
    p.f3={fullfile(pwd,'applyimg1_firstEPI2.nii'); fullfile(pwd,'applyimg1_firstEPI2.nii')}; %APPLYIMG
    p.info='3/23';
end
if 0
    p.dummy=1;
    p.usetranslation=1;
    p.prefix      ='O';
    p.savetrafo   =1;
    p.showmatch   =1;
    p.showMricron =0;
    % p.verbose     =1;
end
u.p=p;

% u.dotidxA=[    2764215     3609405     1540400];
% u.dotidxB=[      316707      251186      254605];

% SANITY CHECK
if isfield(u.p,'f1')==0;        u.p.f1  = ''; else u.p.f1  = char(u.p.f1);     end
if isfield(u.p,'f2')==0;        u.p.f2  = ''; else u.p.f2  = char(u.p.f2);     end
if isfield(u.p,'f3')==0;        u.p.f3  = {}; else u.p.f3  = cellstr(u.p.f3);  end
if isfield(u.p,'usetranslation')==0;            u.p.usetranslation  = 1;       end
if isfield(u.p,'prefix')==0;                    u.p.prefix          = 'O';     end
if isfield(u.p,'savetrafo')==0;                 u.p.savetrafo       = 1;       end
if isfield(u.p,'showmatch')==0;                 u.p.showmatch       = 1;       end
if isfield(u.p,'showMricron')==0;               u.p.showMricron     = 0;       end
if isfield(u.p,'info')       ==0;               u.p.info            = '';      end
if isfield(u.p,'wait')       ==0;               u.p.wait            = 1 ;      end

if isfield(u.p,'showlabels') ==0;               u.p.showlabels      = 1 ;      end

u.colcross=...
    [  1.0000    0.6000    0.7843
    0.4667    0.6745    0.1882
    0 1 1
     ];
u.fs=7;
% ----------------------------------

makegui(u);
readfiles();
redraw();
setdot([],[],1);
redraw();
if u.p.wait==1
    uiwait(gcf);
end


function keys(e,e2)
% e2
if strcmp(e2.Character,'1');
    set(findobj(gcf,'tag','setdot1'),'value',1);
    set(findobj(gcf,'tag','setdot2'),'value',0);
    set(findobj(gcf,'tag','setdot3'),'value',0);
    setdot([],[],1); 
end
if strcmp(e2.Character,'2');
    set(findobj(gcf,'tag','setdot1'),'value',0);
    set(findobj(gcf,'tag','setdot2'),'value',1);
    set(findobj(gcf,'tag','setdot3'),'value',0);
    setdot([],[],2); 
end
if strcmp(e2.Character,'3');
    set(findobj(gcf,'tag','setdot1'),'value',0);
    set(findobj(gcf,'tag','setdot2'),'value',0);
    set(findobj(gcf,'tag','setdot3'),'value',1);
    setdot([],[],3); 
end



function pbhelp(e,e2)
%  uhelp('snip_manuorient.m');
uhelp(mfilename);
 
function readfiles
u=get(gcf,'userdata');
f1=u.p.f1;
f2=u.p.f2;

% f1='I:\AG_Budinger\RS_test_Aug19\dat\PW_HighRes_Anatomy_BL6_250uLMn2\t2.nii'
% f2='I:\AG_Budinger\RS_test_Aug19\dat\PW_HighRes_Anatomy_BL6_250uLMn2\firstEPI2.nii'

% f1=fullfile(pwd,'t2other.nii')
if 0
    %     f1=fullfile(pwd,'t2_m7_1.nii');
    %     f2=fullfile(pwd,'AVGT.nii');
    
    w1=fullfile(pwd,'t2_m7_1.nii');
    w2=fullfile(pwd,'AVGT.nii');
    
    w1=fullfile(pwd,'t2.nii');
    w2=fullfile(pwd,'AVGT.nii');
    
    u.w1=w1;
    u.w2=w2;
    
    f1=stradd(w1,'_tmp',2)
    f2=stradd(w2,'_tmp',2)
    
    [bb vv]=world_bb(w1);
    resize_img5(w1,f1, vv, bb, [], 1);
    [bb vv]=world_bb(w2)
    resize_img5(w2,f2, vv, bb, [], 1);
    
end

%% magdeburg
if 0
    f1=fullfile(pwd,'t2.nii');
    f2=fullfile(pwd,'firstEPI2.nii');
end

if 0
    f1=fullfile(pwd,'t2.nii');
    f2=fullfile(pwd,'AVGT.nii');
end

if 0
    
    f1=fullfile(pwd,'AVGT.nii');
    f2=fullfile(pwd,'firstEPI2.nii');
end

if 0
    f1=fullfile(pwd,'t2other.nii');
    f2=fullfile(pwd,'AVGT.nii');
end


if 0 %WORKS
    f1='O:\data5\fun_getorientation\dat\m16_1\t2.nii'
    f2='O:\data5\fun_getorientation\dat\m16_1\AVGT.nii'
end

if 0 %WORKS
    f1='O:\data5\fun_getorientation\dat\m32_1\t2.nii'
    f2='O:\data5\fun_getorientation\dat\m16_1\t2.nii'
end

if 0 %works
    f1=fullfile(pwd,'t2_m7_1.nii');
    f2=fullfile(pwd,'AVGT.nii');
end
if 0 %works
    f1=fullfile(pwd,'t2.nii');
    f2=fullfile(pwd,'AVGT.nii');
end

if 0% works NEW
    f1=fullfile(pwd,'t2_m7_1.nii');
    f2=fullfile(pwd,'t2.nii');
end



[~,f1name,ext] =fileparts(f1); u.f1name=[f1name ext];
[~,f2name,ext] =fileparts(f2); u.f2name=[f2name ext];

if 0
    ha=spm_vol(f1);
    a=spm_read_vols(ha(1));
    
    hb=spm_vol(f2);
    b=spm_read_vols(hb(1));
end

[ha a am ai]=rgetnii(f1);
[hb b bm bi]=rgetnii(f2);

if 0%%reslice
    [hb b ]=rreslice2target(f2, f1, [], 1);
    bm=am;
    bi=ai;
end
if 0
    [ha a ]=rreslice2target(f1, f2, [], 1);
    am=bm;
    ai=bi;
end


u.f1=f1;
u.f2=f2;
u.ha=ha(1);
u.hb=hb(1);
u.a=a;
u.b=b;

u.am=am;
u.bm=bm;
u.ai=ai;
u.bi=bi;

u.dima=3;
u.dimb=3;

u.ar=reshape([1:numel(u.a)]',size(a));
u.br=reshape([1:numel(u.b)]',size(b));

if ~isfield(u,'adot');    u.adot   =zeros(size(u.a)); end
if ~isfield(u,'bdot');    u.bdot   =zeros(size(u.b)); end

if isfield(u,'dotidxA'); r=u.adot(:);  r(u.dotidxA)=[1:3]; u.adot=reshape(r, size(u.a)); end
if isfield(u,'dotidxB'); r=u.bdot(:);  r(u.dotidxB)=[1:3]; u.bdot=reshape(r, size(u.b)); end



% u.adot=zeros(size(a));
% u.bdot=zeros(size(b));

r={'0' 'pi/2' '-pi/2' 'pi' '-pi'};
cs=allcomb(r,r,r);
rotall=cellfun(@(a,b,c){[a ' ' b ' ' c ]}, cs(:,1),cs(:,2),cs(:,3) );
[arg,rot]=evalc(['' 'findrotation2' '']);
u.rot=[rot;rotall];

set(gcf,'userdata',u);

% set dimensionSTRING
set(findobj(gcf,'tag','txdima'),'string',[ regexprep(num2str(size(u.a)),'\s+',' ')]);
set(findobj(gcf,'tag','txdimb'),'string',[ regexprep(num2str(size(u.b)),'\s+',' ')]);

%set edit dimension
% slicesBdim
maxslice=20;
sizA=size(u.a);
sizB=size(u.b);
sizA(sizA>maxslice)=maxslice;
sizB(sizB>maxslice)=maxslice;

set(findobj(gcf,'tag','slicesAdim1'),'string', num2str(sizA(1)) );
set(findobj(gcf,'tag','slicesAdim2'),'string', num2str(sizA(2)) );
set(findobj(gcf,'tag','slicesAdim3'),'string', num2str(sizA(3)) );

set(findobj(gcf,'tag','slicesBdim1'),'string', num2str(sizB(1)) );
set(findobj(gcf,'tag','slicesBdim2'),'string', num2str(sizB(2)) );
set(findobj(gcf,'tag','slicesBdim3'),'string', num2str(sizB(3)) );

% set(findobj(gcf,'tag','slicesAdim1'),'string', num2str(size(u.a,1)) );
% set(findobj(gcf,'tag','slicesAdim2'),'string', num2str(size(u.a,2)) );
% set(findobj(gcf,'tag','slicesAdim3'),'string', num2str(size(u.a,3)) );
% 
% set(findobj(gcf,'tag','slicesBdim1'),'string', num2str(size(u.b,1)) );
% set(findobj(gcf,'tag','slicesBdim2'),'string', num2str(size(u.b,2)) );
% set(findobj(gcf,'tag','slicesBdim3'),'string', num2str(size(u.b,3)) );



function redraw()
u=get(gcf,'userdata');

dimmat=[...
    2 3 4 1
    1 3 4 2
    1 2 4 3
    ];

dimveca=dimmat(u.dima ,:);
dimvecb=dimmat(u.dimb ,:);



if 1
    slic2dispA(1)=   str2num(get(findobj(gcf,'tag','slicesAdim1'),'string'));
    slic2dispA(2)=   str2num(get(findobj(gcf,'tag','slicesAdim2'),'string'));
    slic2dispA(3)=   str2num(get(findobj(gcf,'tag','slicesAdim3'),'string'));
    
    slic2dispB(1)= str2num(get(findobj(gcf,'tag','slicesBdim1'),'string'));
    slic2dispB(2)= str2num(get(findobj(gcf,'tag','slicesBdim2'),'string'));
    slic2dispB(3)= str2num(get(findobj(gcf,'tag','slicesBdim3'),'string'));
    
    sizA=size(u.a); sizB=size(u.b);
    minslic(1,1)=slic2dispA(dimveca(end)) ;
    minslic(1,2)=slic2dispB(dimvecb(end));
    minslic(minslic<1)=10000; %check
    
    if minslic(1,1)>sizA(dimveca(end));  minslic(1,1)=sizA(dimveca(end)); end
    if minslic(1,2)>sizB(dimvecb(end));  minslic(1,2)=sizA(dimvecb(end)); end
    
    
    
    
%     minslic=([sizA(dimveca(end)) sizB(dimvecb(end))]);
%     noslice=20;
%     if minslic(1)>noslice; minslic(1)=noslice; end
%     if minslic(2)>noslice; minslic(2)=noslice; end
    
   sliceA= round(linspace(1,sizA(dimveca(end)),minslic(1) )) ;
   sliceB= round(linspace(1,sizB(dimvecb(end)),minslic(2) )) ;
  
    
    %find slices with dots
    adiff=setdiff([1:3], dimveca(end));
    slicedotsA=find( sum(sum(u.adot,adiff(1)),adiff(2))~=0);
    
    bdiff=setdiff([1:3], dimvecb(end));
    slicedotsB=find( sum(sum(u.bdot,bdiff(1)),bdiff(2))~=0);
    
    sliceA=    unique([sliceA slicedotsA(:)']);
    sliceB=    unique([sliceB slicedotsB(:)']);
    
    
    [nsubA]=numSubplots(length(sliceA)) ; 
    [nsubB]=numSubplots(length(sliceB)) ; 
    [a2 sia]=montageout(permute(u.a,dimveca),'Indices', sliceA,'Size',nsubA );%[1 2 4 3]));
    [b2 sib]=montageout(permute(u.b,dimvecb),'Indices', sliceB,'Size',nsubB);%[1 2 4 3]));
    
    ar2=montageout(permute(u.ar,dimveca),'Indices', sliceA,'Size',nsubA );%,[1 2 4 3]));
    br2=montageout(permute(u.br,dimvecb),'Indices', sliceB,'Size',nsubB );%,[1 2 4 3]));
    
end

% asprat=size(a2).*sia;
% disp(asprat);
% disp(size(a2).*sia);
%---------------
% u.sa=sa;
% u.sb=sb;
% u.ar=ar;
% u.br=br;
u.ar2=ar2;
u.br2=br2;

u.ar2dot =zeros(size(u.ar2)); 
u.br2dot =zeros(size(u.br2)); 

% if ~isfield(u,'ar2dot');  u.ar2dot =zeros(size(u.ar2)); end
% if ~isfield(u,'br2dot');  u.br2dot =zeros(size(u.br2)); end
% if ~isfield(u,'adot');    u.adot   =zeros(size(u.a)); end
% if ~isfield(u,'bdot');    u.bdot   =zeros(size(u.b)); end


set(gcf,'userdata',u);

try;delete(get(u.axa,'children'));end
try;delete(get(u.axb,'children'));end

%---------------
colvec=['r' 'g' 'b'];


try;delete(findobj(gcf,'tag','axa'));end
axa=axes('position',[0.001    0.1    0.47    0.85],'tag','axa');
%  axa=subplot(1,2,1);
 %  set(axa,'tag','axa'); 
 
%  set(gca,'position',[0.001 .1 .48 .85]);
% axa=axes('position',[0.1300    0.1100    0.3347    0.8150]);
him1=imagesc(imadjust(mat2gray(a2)));


prelabel='Ref: ';
if u.p.showlabels==0
    prelabel='';
end
title({[prelabel u.f1name ]; ['  ' fileparts(u.f1) ] },'fontsize',u.fs-1); axis off;
set(gca,'tag','axa');
hold on;
set(him1,'ButtonDownFcn', {@imcallback,1} );


if isfield(u,'adot') && isfield(u,'axa');
    ax=findobj(gcf,'tag','axa');%u.axa;
    r=u.adot;
    dimvec=dimveca;
    
    r2=montageout(permute(r,dimvec),'Indices', sliceA,'Size',nsubA );%,[1 2 4 3]));
    dots=unique(r2); dots(dots==0)=[];
    if ~isempty(dots)
        for i=1:length(dots)
            dotnum=dots(i);
            col=colvec(dotnum);
            [x y]=find(r2==dotnum);
            delete(findobj(ax,'tag',['dot' num2str(dotnum) ]));
            set(gcf,'CurrentAxes',ax);
            p= plot(y,x, [col 'o']);
            set(p,'markerfacecolor', col,'tag', ['dot' num2str(dotnum) ],'userdata','dot','hittest','on');;
            set(p,'ButtonDownFcn', {@imcallback,1} );
        end
    end
end

try;delete(findobj(gcf,'tag','axb'));end
axb=axes('position',[0.53 .1 .47 .85],'tag','axb');

% axb=subplot(1,2,2);
%  set(axb,'tag','axb');
him2=imagesc(imadjust(mat2gray(b2)));
set(gca,'tag','axb');

prelabel='Source: ';
if u.p.showlabels==0
    prelabel='';
end
title({[prelabel u.f2name ]; ['  ' fileparts(u.f2) ] },'fontsize',u.fs-1); axis off;

hold on;
set(him2,'ButtonDownFcn', {@imcallback,2} );
set(gca,'position',[0.53 .1 .469 .85]);


if isfield(u,'bdot') && isfield(u,'axb');
    ax=findobj(gcf,'tag','axb');%u.axa;
    %ax=u.axb;
    r=u.bdot;
    dimvec=dimvecb;
    
    r2=montageout(permute(r,dimvec),'Indices', sliceB,'Size',nsubB);%,[1 2 4 3]));
    dots=unique(r2); dots(dots==0)=[];
    if ~isempty(dots)
        for i=1:length(dots)
            dotnum=dots(i);
            col=colvec(dotnum);
            [x y]=find(r2==dotnum);
            delete(findobj(ax,'tag',['dot' num2str(dotnum) ]));
            set(gcf,'CurrentAxes',ax);
            p= plot( y,x, [col 'o']);
            set(p,'markerfacecolor', col,'tag', ['dot' num2str(dotnum) ],'userdata','dot','hittest','on');
            set(p,'ButtonDownFcn', {@imcallback,2} );
        end
    end
end





colormap gray


u.axa=axa;
u.axb=axb;
set(gcf,'userdata',u);

% if 0
%     axes(u.axa);
%     apratA=size(a2).*sia;
%     daspect([apratA(1)/apratA(2) 1 1]);
%     
%     axes(u.axb);
%     apratB=size(b2).*sib;
%     daspect([apratB(1)/apratB(2) 1 1]);
% end

function imcallback(e,e2, imnum)
radiovec=[...
    get(findobj(gcf,'tag','setdot1'),'value')
    get(findobj(gcf,'tag','setdot2'),'value')
    get(findobj(gcf,'tag','setdot3'),'value')];
if sum(radiovec)==0; return; end

dotnum=find(radiovec==1);
colvec=['r' 'g' 'b'];
col=colvec(dotnum);

ax=get(e,'parent');
co=round(get(ax,'CurrentPoint'));

delete(findobj(ax,'tag',['dot' num2str(dotnum) ]));
p=plot(co(1,1),co(1,2),[col 'o']);
set(p,'markerfacecolor', col,'tag', ['dot' num2str(dotnum) ],'userdata','dot','hittest','on');
set(p,'ButtonDownFcn', {@imcallback,imnum} );
u=get(gcf,'userdata');

% if get(e,'parent')==u.axa; axno=1; else, axno=2;end

if imnum==1
    u.adot(u.adot==dotnum)=0;
    ix=u.ar2(co(1,2),co(1,1));
    u.adot(u.ar==ix )=dotnum;
    %size(u.adot)
    %unique(u.adot)
else
    u.bdot(u.bdot==dotnum)=0;
    ix=u.br2(co(1,2),co(1,1));
    u.bdot(u.br==ix )=dotnum;
    %size(u.bdot)
    %unique(u.bdot)
end
set(gcf,'userdata',u);





%% disp
function makegui(u)

hf=findobj(0,'tag','manuorient3points');
if ~isempty(hf)
   figpos=get(hf(1),'position') ;
   delete(hf);
end

[pa file ext]=fileparts(u.p.f1);
[~,mdir]=fileparts(pa);

fg;
set(gcf,'userdata',u,'tag','manuorient3points','NumberTitle','off','menubar','none', 'name', [mfilename ' ' u.p.info ' [DIR: ' mdir ']'] );
 if exist('figpos'); set(gcf,   'position',figpos);end
set(gcf,'KeyPressFcn',@keys);


%% controls
fs=u.fs;
hb=uicontrol('style','radio','units','normalized','BackgroundColor','w');
set(hb,'tag','setdot1','string','OB','position',[.472 .6 .058 .05],'callback', {@setdot,1},'fontsize',fs-2);
set(hb,'tooltipstring','select olfactory bulbus-center(LR)-center(superior-anterior) point' );
set(hb,'value',1);

hb=uicontrol('style','radio','units','normalized','BackgroundColor','w');
set(hb,'tag','setdot2','string','SUP','position',[.472 .55 .058 .05],'callback', {@setdot,2},'fontsize',fs-2);
set(hb,'tooltipstring','select superior-center(LR)-center(ant-post) point' );

hb=uicontrol('style','radio','units','normalized','BackgroundColor','w');
set(hb,'tag','setdot3','string','INF','position',[.472 .5 .058 .05],'callback', {@setdot,3},'fontsize',fs-2);
set(hb,'tooltipstring','select inferior-center(LR)-center(ant-post) point' );


% view DIM refIMG
hb=uicontrol('style','toggle','units','normalized','BackgroundColor','w');
set(hb,'tag','dima1','string','dim1','position',[.2 .05 .05 .05],'callback', {@viewAdim,1},'fontsize',fs);
set(hb,'tooltipstring','show slices in dim-1','value',0 );
hb=uicontrol('style','toggle','units','normalized','BackgroundColor','w');
set(hb,'tag','dima2','string','dim2','position',[.25 .05 .05 .05],'callback', {@viewAdim,2},'fontsize',fs);
set(hb,'tooltipstring','show slices in dim-2','value',0  );
hb=uicontrol('style','toggle','units','normalized','BackgroundColor','w');
set(hb,'tag','dima3','string','dim3','position',[.3 .05 .05 .05],'callback', {@viewAdim,3},'fontsize',fs);
set(hb,'tooltipstring','show slices in dim-3','value',1  );

tooltipnslices=['max number of slices to show' char(10) 'or leave empty to show all slices'];

% view slices-num refIMG
hb=uicontrol('style','edit','units','normalized','BackgroundColor','w');
set(hb,'tag','slicesAdim1','string','10','position',[.2 .01 .05 .04],'callback', {@slicesAdim,1},'fontsize',fs);
set(hb,'tooltipstring',tooltipnslices,'foregroundcolor','b' );
hb=uicontrol('style','edit','units','normalized','BackgroundColor','w');
set(hb,'tag','slicesAdim2','string','11','position',[.25 .01 .05 .04],'callback', {@slicesAdim,2},'fontsize',fs);
set(hb,'tooltipstring',tooltipnslices,'foregroundcolor','b' );
hb=uicontrol('style','edit','units','normalized','BackgroundColor','w');
set(hb,'tag','slicesAdim3','string','12','position',[.3 .01 .05 .04],'callback', {@slicesAdim,3},'fontsize',fs);
set(hb,'tooltipstring',tooltipnslices,'foregroundcolor','b' );



% disp DIMsize-ref
hb=uicontrol('style','text','units','normalized','BackgroundColor','w');
set(hb,'tag','txdima','string','dimens','position',[.35 .05 .1 .05],'fontsize',fs-1);
set(hb,'tooltipstring','volume dimension','value',0,'foregroundcolor','b' );

% view DIM sourceIMG
hb=uicontrol('style','toggle','units','normalized','BackgroundColor','w');
set(hb,'tag','dimb1','string','dim1','position',[.6 .05 .05 .05],'callback', {@viewBdim,1},'fontsize',fs);
set(hb,'tooltipstring','show slices in dim-1','value',0 );
hb=uicontrol('style','toggle','units','normalized','BackgroundColor','w');
set(hb,'tag','dimb2','string','dim2','position',[.65 .05 .05 .05],'callback', {@viewBdim,2},'fontsize',fs);
set(hb,'tooltipstring','show slices in dim-2','value',0  );
hb=uicontrol('style','toggle','units','normalized','BackgroundColor','w');
set(hb,'tag','dimb3','string','dim3','position',[.7 .05 .05 .05],'callback', {@viewBdim,3},'fontsize',fs);
set(hb,'tooltipstring','show slices in dim-1','value',1  );

% view slices-num refIMG
hb=uicontrol('style','edit','units','normalized','BackgroundColor','w');
set(hb,'tag','slicesBdim1','string','10','position',[.6 .01 .05 .04],'callback', {@slicesBdim,1},'fontsize',fs);
set(hb,'tooltipstring',tooltipnslices,'foregroundcolor','b' );
hb=uicontrol('style','edit','units','normalized','BackgroundColor','w');
set(hb,'tag','slicesBdim2','string','11','position',[.65 .01 .05 .04],'callback', {@slicesBdim,2},'fontsize',fs);
set(hb,'tooltipstring',tooltipnslices,'foregroundcolor','b' );
hb=uicontrol('style','edit','units','normalized','BackgroundColor','w');
set(hb,'tag','slicesBdim3','string','12','position',[.7 .01 .05 .04],'callback', {@slicesBdim,3},'fontsize',fs);
set(hb,'tooltipstring',tooltipnslices,'foregroundcolor','b' );



% disp DIMsize-source
hb=uicontrol('style','text','units','normalized','BackgroundColor','w');
set(hb,'tag','txdimb','string','dimens','position',[.75 .05 .1 .05],'fontsize',fs-1);
set(hb,'tooltipstring','volume dimension','value',0,'foregroundcolor','b' );


%HELP
hb=uicontrol('style','pushbutton','units','normalized','BackgroundColor','w');
set(hb,'tag','pbhelp','string','Help','position',[.8 .01 .05 .05],'callback', {@pbhelp},'fontsize',fs-2,'fontweight','bold');
set(hb,'tooltipstring',' help..get information' );
%check
hb=uicontrol('style','pushbutton','units','normalized','BackgroundColor','w');
set(hb,'tag','pbcheck','string','Check','position',[.85 .01 .05 .05],'callback', {@pbcheck},'fontsize',fs-2,'fontweight','bold');
set(hb,'tooltipstring','check orientation' );
%donce
hb=uicontrol('style','pushbutton','units','normalized','BackgroundColor','w');
set(hb,'tag','pbtransform','string','Transform','position',[.9 .01 .05 .05],'callback', {@pbtransform},'fontsize',fs-2,'fontweight','bold');
set(hb,'tooltipstring','transform image(s) and close window' );

%donce
hb=uicontrol('style','pushbutton','units','normalized','BackgroundColor','w');
set(hb,'tag','pbclose','string','Close','position',[.95 .01 .05 .05],'callback', {@pbclose},'fontsize',fs-2,'fontweight','bold');
set(hb,'tooltipstring','close window' );

% pulldown, image match type
str={'matching Image' 'Mricron' 'both'};
hb=uicontrol('style','popupmenu','units','normalized','BackgroundColor','w');
set(hb,'tag','popcheck','string',str,'position',[.85 .04 .1 .05],'fontsize',fs-2,'fontweight','bold');
set(hb,'tooltipstring','check type','value',3 );

if u.p.showmatch==1 && u.p.showMricron==1 
    set(hb,'value',3 );
elseif u.p.showmatch==1 && u.p.showMricron==0 
    set(hb,'value',1 );
else
   set(hb,'value',2 ); 
end

hx=findobj(gcf,'style','pushbutton');set(hx,'KeyPressFcn',@keys);
hx=findobj(gcf,'style','togglebutton');set(hx,'KeyPressFcn',@keys);
hx=findobj(gcf,'style','popupmenu');set(hx,'KeyPressFcn',@keys);
hx=findobj(gcf,'style','radio');set(hx,'KeyPressFcn',@keys);


function setdot(e,e2,dotno)
u=get(gcf,'userdata');
% if get(e,'value')==1
tag='setdot';
nodotno=setdiff([1:3],dotno);
for i=1:length(nodotno)
    ho=findobj(gcf,'tag',[tag num2str(nodotno(i))]) ;
    set(ho,'value',0);
end
% set(gcf,'WindowButtonMotionFcn',@movecross);
if get(findobj(gcf,'tag',[tag num2str(dotno)]),'value')==1
    set (gcf, 'WindowButtonMotionFcn', @mouseMove);
   axes(u.axa);
%    hl=hline(0,'color','r','tag','hlineA');
   
else
    set (gcf, 'WindowButtonMotionFcn', []);
    set(findobj(gcf,'userdata','fixcrossA'),'visible','off');
    set(findobj(gcf,'userdata','fixcrossB'),'visible','off');
    
end

% cross-color update

dotv=[get(findobj(gcf,'tag','setdot1'),'value')
      get(findobj(gcf,'tag','setdot2'),'value')
      get(findobj(gcf,'tag','setdot3'),'value')];
colcross=u.colcross(find(dotv),:);
if ~isempty(colcross)
    set(findobj(gcf,'userdata','fixcrossA'),'color',colcross);
    set(findobj(gcf,'userdata','fixcrossB'),'color',colcross);
end

function mouseMove (object, eventdata)
  try;
      mousemovefun;
  end

function mousemovefun
ax=[findobj(gcf,'tag','axa'); findobj(gcf,'tag','axb')];

 u=get(gcf,'userdata'); % ax=[u.axa;u.axb];


c2= get(ax(2), 'CurrentPoint');
if c2(1,1)<0
    % disp('axA');
    axes(ax(1));
    abc = axis;
    c= get(ax(1), 'CurrentPoint');
    tag='fixcrossA';
    %     set(findobj(gcf,'userdata','fixcrossA'),'visible','on');
    %     set(findobj(gcf,'userdata','fixcrossB'),'visible','off');
    %
    %     disp(round(c(1,1:2)));
    %     disp(round(abc));
    if c(1,1)>abc(2) | c(1,2)<1 | c(1,2)>abc(4)
%         disp('out');
        set(findobj(gcf,'userdata','fixcrossA'),'visible','off');
        set(findobj(gcf,'userdata','fixcrossB'),'visible','off');
    else
%         disp('in');
        set(findobj(gcf,'userdata','fixcrossA'),'visible','on');
        set(findobj(gcf,'userdata','fixcrossB'),'visible','off');
    end
    
    
else
    %disp('axB');
    axes(ax(2));
    abc = axis;
    c=c2;
    tag='fixcrossB';
    if c(1,1)>abc(2) | c(1,2)<1 | c(1,2)>abc(4)
%         disp('out');
        set(findobj(gcf,'userdata','fixcrossA'),'visible','off');
        set(findobj(gcf,'userdata','fixcrossB'),'visible','off');
    else
%         disp('in');
        set(findobj(gcf,'userdata','fixcrossA'),'visible','off');
        set(findobj(gcf,'userdata','fixcrossB'),'visible','on');
    end
end
% disp(round(c(1,1:2)));
% disp(round(abc));
% if c(1,1)>abc(2) | c(1,2)<1 | c(1,2)>abc(4) 
%     disp('out');
% else
%      disp('in');
% end

% disp(get(gca,'tag'));
% xl=get(gca,'xlim');
% disp(round([c(1,1) xl]));
% xl=get(gca,'xlim');
% set(gca, 'xlimmode','manual',...
%            'ylimmode','manual',...
%            'zlimmode','manual',...
%            'climmode','manual',...
%            'alimmode','manual');
% set(gcf,'doublebuffer','off');

dotv=[get(findobj(gcf,'tag','setdot1'),'value')
      get(findobj(gcf,'tag','setdot2'),'value')
      get(findobj(gcf,'tag','setdot3'),'value')];

% coldef=[...
%     0.9373    0.8667    0.8667
%     0.8392    0.9098    0.8510
%     0.8039    0.8784    0.9686];

% u.colcross=...
%     [  1.0000    0.6000    0.7843
%     0.4667    0.6745    0.1882
%     0 1 1
%      ];%0.9255    0.8392    0.8392

col=u.colcross(find(dotv),:);
% col

% space=50;
% abc = axis;
spac=round(abc([2 4]).*0.05);
% delete(findobj(gcf,'tag','fch1'));
hl=findobj(gca,'tag','fch1');
if isempty(hl);
    h = plot(single([0 0]), single([0 0]));
    set(h,'color','r','tag','fch1','hittest','off','userdata',tag);
else
    set(hl,'xdata',round([abc([1 ])  c(1,1)-spac(1)]) ,'ydata',round([c(1,2) c(1,2)]),'color',col);
end

hl=findobj(gca,'tag','fch2');
if isempty(hl);
    h = plot(single([0 0]), single([0 0]));
    set(h,'color','r','tag','fch2','hittest','off','userdata',tag);
else
    set(hl,'xdata',round([c(1,1)+spac(1)  abc([2 ])  ]) ,'ydata',round([c(1,2) c(1,2)]),'color',col);
end
% delete(findobj(gcf,'tag','fcv1'));
hl=findobj(gca,'tag','fcv1');
if isempty(hl);
    h = plot(single([0 0]), single([0 0]));
    set(h,'color','r','tag','fcv1','hittest','off','userdata',tag);
else
    set(hl,'xdata',round([c(1,1) c(1,1)]) ,'ydata',round([c(1,2)+spac(2) abc([4 ])  ]),'color',col);
end
% delete(findobj(gcf,'tag','fcv2'));
hl=findobj(gca,'tag','fcv2');
if isempty(hl);
    h = plot(single([0 0]), single([0 0]));
    set(h,'color','r','tag','fcv2','hittest','off','userdata',tag);
else
    set(hl,'xdata',round([c(1,1) c(1,1)]) ,'ydata',round([abc([3 ])  c(1,2)-spac(2)]),'color',col);
end







function slicesAdim(e,e2,dimno)
u=get(gcf,'userdata');
if isempty(get(e,'string'))
    set(e,'string',num2str(size(u.a,dimno)));
end
viewAdim([],[],dimno);
% redraw();


function slicesBdim(e,e2,dimno)
u=get(gcf,'userdata');
if isempty(get(e,'string'))
    set(e,'string',num2str(size(u.b,dimno)));
end
viewBdim([],[],dimno);
% redraw();


function viewAdim(e,e2,dimno)
tag='dima';
nodim=setdiff([1:3],dimno);
for i=1:length(nodim)
    ho=findobj(gcf,'tag',[tag num2str(nodim(i))]) ;
    set(ho,'value',0);
end
set(findobj(gcf,'tag',[tag num2str(dimno)]),'value',1);
uicontrol(findobj(gcf,'tag',[tag num2str(dimno)]));


u=get(gcf,'userdata');
u=setfield(u,tag,dimno );
set(gcf,'userdata',u);
redraw();

function viewBdim(e,e2,dimno)
tag='dimb';
nodim=setdiff([1:3],dimno);
for i=1:length(nodim)
    ho=findobj(gcf,'tag',[tag num2str(nodim(i))]) ;
    set(ho,'value',0);
end
set(findobj(gcf,'tag',[tag num2str(dimno)]),'value',1);
uicontrol(findobj(gcf,'tag',[tag num2str(dimno)]));

u=get(gcf,'userdata');
u=setfield(u,tag,dimno );
set(gcf,'userdata',u);
redraw();

% u=get(gcf,'userdata')



function bestrot2(e,e2)


% ==============================================
%%  might work ???
% ===============================================

u=get(gcf,'userdata');





% r={'0' 'pi/2' '-pi/2' 'pi' '-pi'}
% cs=allcomb(r,r,r);
% rotall=cellfun(@(a,b,c){[a ' ' b ' ' c ]}, cs(:,1),cs(:,2),cs(:,3) );
% [arg,rot]=evalc(['' 'findrotation2' '']);
% rot=[rot;rotall];


if 0
    v1=fullfile(pwd,'dot1.nii');
    v2=fullfile(pwd,'dot2.nii');
    %==========================================
    
    %
    % s1=fullfile(pwd,'dot2.nii')
    % s2=fullfile(pwd,'dot2_reorient.nii')
    
    g1=fullfile(pwd,'t2_m7_1.nii');
    g2=fullfile(pwd,'AVGT.nii');
    h2=fullfile(pwd,'AVGTrot.nii');
    
    copyfile(g2,h2,'f');
    %     m=u.hb.mat;
    %     m=spm_get_space(g2);
    
    
    % rotm   = str2num('pi 0 pi/2');%%MATCH 11
    % % rotm   =str2num(rot{j,1});
    % vecinv = spm_imatrix(inv(spm_matrix([0 0 0 rotm 1 1 1 0 0 0])));
    % rotinv = vecinv(4:6);
    % vec=[0 0 0 rotinv];
    % B=[zeros(1,6) 1 1 1 0 0 0];
    % B(1:length(vec))=vec;
    % m2=spm_matrix(B);
    
    
    [ha a am ai]=rgetnii(v1);
    a2=a(:);
    [hb b bm bi]=rgetnii(v2);
    b2=b(:);
end

rot=u.rot;
g1=u.f1;
g2=u.f2;
% m=spm_get_space(g2);
m=u.hb.mat;

ha=u.ha;
hb=u.hb;

am=u.am;
bm=u.bm;
ai=u.ai;
bi=u.bi;

if 1
    a =u.adot;
    b =u.bdot;
end
if 0
    v1=fullfile(pwd,'dot1.nii');
    v2=fullfile(pwd,'dot2.nii');
    [~, a ]=rgetnii(v1);
    [~, b ]=rgetnii(v2);
    
end
a2=a(:);
b2=b(:);



% ==========================================
%   test0
inda=[]; mma=[];
indb=[]; mmb=[];
for i=1:3
    ix=find(a2==i);
    inda(end+1,:)=ai(:,ix);
    mma(end+1,:) =am(:,ix);
    
    ix=find(b2==i);
    indb(end+1,:)=bi(:,ix);
    mmb(end+1,:) =bm(:,ix);
end




for j=1:size(rot,1)
    
    %     rotm   = str2num('pi 0 pi/2');%%MATCH 11
    rotm   =str2num(rot{j,1});
    vecinv = spm_imatrix(inv(spm_matrix([0 0 0 rotm 1 1 1 0 0 0])));
    rotinv = vecinv(4:6);
    vec=[0 0 0 rotinv];
    B=[zeros(1,6) 1 1 1 0 0 0];
    B(1:length(vec))=vec;
    m2=spm_matrix(B);
    
    
    %     disp(mma);
    %     disp('----')
    %     disp(mmb);
    
    % mmb=mmb([1 3 2],:)
    c1=mma;
    mx=inv(m2)*(m)*(u.ha.mat);
    %     mx=(m)*inv(u.ha.mat/m2)
    c2=mmb;
    c2=indb;
    
    mve=spm_imatrix(ha.mat);
    rog=mve(4:6);
    ma=spm_matrix([0 0 0 rog 1 1 1 0 0 0]);
    
    mve=spm_imatrix(hb.mat);
    rog=mve(4:6);
    mb=spm_matrix([0 0 0 rog 1 1 1 0 0 0]);
    
    ms=(ma)*inv(mb);
    mx=inv(m2)*(m)*(u.hb.mat)*ms;
    %  M  = v2.mat/v1.mat;
    mx=m2;
    % mx=inv(m2)*(m)*(ms) ;
    
    
    
    % mm2vox(mm,u.f2)
    % ans =
    %   156.6579  158.6411  -71.0835
    % TO VOXEL
    v2m=hb.mat;%=spm_get_space(V(1).fname);
    m2v=inv(v2m);
    r=mm*m2v(1:3,1:3) + m2v(1:3,4)';
    
    %to MILIMETER
    mili=(r-m2v(1:3,4)')*(v2m(1:3,1:3));
    
    mili=(r-m2v(1:3,4)')*(v2m(1:3,1:3));
    
    
    r=indb;
    c2=[];
    for i=1:3
        c2(i,:)= (r(i,:)-m2v(1:3,4)')*(v2m(1:3,1:3));
        
    end
    
    %%%
    
    
    for i=1:size(c2,2)
        % c2(i,:)= (  ms(1:3,1:3) * mx(1:3,1:3))*c2(i,:)'+mx(1:3,4);
        c2(i,:)= (  mx(1:3,1:3))*c2(i,:)'+mx(1:3,4);
    end
    
    c1=inda;
    for i=1:size(c1,2)
        c1(i,:)=(u.ha.mat(1:3,1:3))*c1(i,:)'+u.ha.mat(1:3,4);
    end
    
    anom=c1-repmat(mean(c1,1), [size(c1,1) 1]);
    bnom=c2-repmat(mean(c2,1), [size(c2,1) 1]);
    
    qr=sum(sum((anom-bnom).^2,2))  ;
    tb(j,:)=[j qr];
    %     disp(tb(j,:));
end

% clc;
% disp(tb);


% ==============================================
%   recheck
% ===============================================
ir=find(tb(:,2)==min(tb(:,2)));
ir=ir(1);
disp(['best match: (#' num2str(ir) ') '  '[' rot{ir}  ']']);
% [id rotstring]=myrottest('ref',g1,'img',g2,'rot',rot(ir) );
[id rotstring]=myrottest('ref',g1,'img',g2,'rot',rot(ir),'wait',0 );


if 0
    tbs=sortrows(tb,2)
    nshow=10
    ir=tbs(1:nshow,1);
    disp(tbs(1:nshow,:));
    [id rotstring]=myrottest('ref',g1,'img',g2,'rot',rot(ir),'wait',0 );
    
end


function pbtransform(e,e2)

isOK=bestrot('transform');
if isOK==0; 
    return; 
end
 disp('..transform');
hf=findobj(0,'tag','manuorient3points');
% close(hf);
% close(gcf);
function pbclose(e,e2);
disp('..close window');
close(gcf);

function pbcheck(e,e2)
u=get(gcf,'userdata');
% outdir=fileparts(u.f2);

if numel(unique(u.adot))-1 <3
    disp(['# markerref img    : '  num2str(numel(unique(u.adot))-1  ) ]);
end
if numel(unique(u.bdot))-1 <3
    disp(['# marker source img: '  num2str(numel(unique(u.bdot))-1  ) ]);
end

% rsavenii(fullfile(outdir,'dot1.nii'), u.ha,u.adot);
% rsavenii(fullfile(outdir,'dot2.nii'), u.hb,u.bdot);
bestrot('check');




function isOK=bestrot(arg);
% p.usetranslation=1;
% p.prefix      ='o';
% p.savetrafo   =0;
% p.showmatch   =0;
% p.showMricron =0;
% % p.verbose     =1;
isOK=1;

hf=findobj(0,'tag','manuorient3points');
u=get(hf,'userdata');
p=u.p; %retrieve parameter
rotall=u.rot   ;

g1=u.f1;%fullfile(pwd,'t2_m7_1.nii');
g2=u.f2;%fullfile(pwd,'AVGT.nii');

ha=u.ha;
hb=u.hb;

am=u.am;
bm=u.bm;
ai=u.ai;
bi=u.bi;

a =u.adot;
b =u.bdot;

va=[]; mma=[];
vb=[]; mmb=[];
for i=1:3
    ix=find(a(:)==i);
    if isempty(ix)
        disp('no landmarks set...set 3 landmarks to proceed');
        isOK=0;
        return
        
    end
    va(end+1,:) =ai(:,ix);    mma(end+1,:) =am(:,ix);
    
    ix=find(b(:)==i);
    vb(end+1,:)=bi(:,ix);     mmb(end+1,:) =bm(:,ix);
end

% ==============================================
%   calc loop
% ===============================================

m=spm_get_space(g2);
tb=[];
rota=rotall;
for j=1:length(rotall)
    %rota=r
    rotvec=str2num(rota{j});
    vecinv = spm_imatrix(inv(spm_matrix([0 0 0 rotvec 1 1 1 0 0 0])));
    rotinv = vecinv(4:6);
    vec=[0 0 0 rotinv];
    B=[zeros(1,6) 1 1 1 0 0 0];
    B(1:length(vec))=vec;
    m2=spm_matrix(B);

    ms=(m2*m);
    mmd=[];
    for i=1:3
        mmd(i,:)=[ms*[vb(i,:) 1]']';
    end
    mmd=mmd(:,1:3);
    
    tr=mean(mma-mmd,1);%old
    %tr=mean(mmd-mma,1);
    ss=mmd+repmat(tr,[3 1])-mma;
    qr=sqrt(sum(sum(ss.^2,2)));
    
    tb(j,:)=[j qr tr];
end



% disp('TRANSL:');
% % disp(tr);

% ==============================================
%   recheck
% ===============================================
ir=find(tb(:,2)==min(tb(:,2)));
ir=ir(1);
% disp(['best match: (#' num2str(ir) ') '  '[' rota{ir}  ']']);
% [id rotstring]=myrottest('ref',g1,'img',g2,'rot',rota(ir),'wait',0);
% keyboard
if strcmp(arg,'check')
    hp=findobj(hf,'tag','popcheck');
    if get(hp,'value')==1 || get(hp,'value')==3  %  p.showmatch==1
        [id rotstring]=getorientation('ref',g1,'img',g2,'info', 'best match','mode',1,...
            'wait',0,'rot',rota(ir),'disp',1);
    end
end

rot    =str2num(rota{ir});
trans  =(tb(ir,3:5));

% disp('ROT:');
% disp(rot);
% disp('TRANS');
% disp(trans);

if 0
    tbs=sortrows(tb,2)
    nshow=10
    ir=tbs(1:nshow,1);
    disp(tbs(1:nshow,:));
    [id rotstring]=myrottest('ref',g1,'img',g2,'rot',rota(ir),'wait',0 );
end
% ==============================================
%%   write nifti with trans,ONE STEP
% This order can be changed by calling spm_matrix with a string as a
% second argument. This string may contain any valid MATLAB expression
% that returns a 4x4 matrix after evaluation. The special characters 'S',
% 'Z', 'R', 'T' can be used to reference the transformations 1)-4)
% above. The default order is 'T*R*Z*S', as described above.
% ===============================================



if p.usetranslation==0
    trans=[0 0 0];
end

m=spm_get_space(g2);

vecinv = spm_imatrix(inv(spm_matrix([-trans rot 1 1 1 0 0 0],'R*Z*S*T')));
rotinv = vecinv(1:6);
vec=[rotinv];
B=[zeros(1,6) 1 1 1 0 0 0];
B(1:length(vec))=vec;
m2=spm_matrix(B);

mx=[m2*m];
% mx(1:3,4)=mx(1:3,4)+trans';

 g3=stradd(g2,[strrep(p.prefix,'','') ''],1); % landet im template-folder
%g3=stradd(g1,[strrep(p.prefix,'','') ''],1); % landet im g1-folder ("t2.nii"-dir)
copyfile(g2,g3,'f');
spm_get_space(g3,mx);
[pa,name, ext]=fileparts(g3);

if strcmp(arg,'transform')
    % rmricron([],g1,fi2,1);
    disp(['DIR: ' pa]);
    showinfo2(['..reoriented [' [name ext] ']' ],g1,g3,1,'');% shows t2.nii with c1t2.nii on top
end

if strcmp(arg,'check')
    hp=findobj(hf,'tag','popcheck');
    if get(hp,'value')==2 || get(hp,'value')==3  %  p.showmatch==1
    %if p.showMricron==1
       drawnow;
       if exist(g3)==2
        rmricron([],g1,g3,1);
       else
          disp('Cannot sisplay in MRICRON'); 
       end
    end
    pause(1);% for MAC-MRICRON
   try; delete(g3);end
   
   disp(['   ROTATIONS:  ' regexprep(num2str(B(4:6)),'\s+',' ') ]);
   disp(['TRANSLATIONS:  ' regexprep(num2str(B(1:3)),'\s+',' ') ]);
    return
end

%% --backtrafo  -----------------------------------------


%  clc;mz=(m2*m); m, mb=inv(m2)*mz, m-mb
mb=inv(m2)*mx;
if 0 % TEST
    g4=stradd(g3,'i',1);
    copyfile(g3,g4,'f');
    spm_get_space(g4,mb);
    rmricron([],g2,g4,1);
end

%% --save  -----------------------------------------

    s.forw     =mx;
    s.backw    =mb;
    s.refimg   =g1;
    s.sourceimg=g2;
    s.info= {'forward: spm_get_space("sourceimg",forw);'; 'backward: spm_get_space("reorientedSourceimg",backw);'};
    
    [paout filename ]=fileparts(g3);
    matfile=fullfile(paout,[ filename '_TRAFO.mat'  ]);
    
    u.s=s;
    hf=findobj(0,'tag','manuorient3points');
    set(hf,'userdata',u);
    
if p.savetrafo==1    
    save(matfile,'s');
end

%% --reorient other images  -----------------------------------------
if ~isempty(char(u.p.f3))
    for i=1:length(u.p.f3)
        fi1=u.p.f3{i};
        fi2=stradd(fi1,[strrep(p.prefix,'','') ''],1);
        copyfile(fi1,fi2,'f');
        spm_get_space(fi2,mx);
        [~,name, ext]=fileparts(fi2);
         % rmricron([],g1,fi2,1);
        showinfo2(['..reoriented [' [name ext] ']' ],g1,fi2,1,'');% shows t2.nii with c1t2.nii on top
    end
end




% disp('transform');

function [p,n]=numSubplots(n)
% function [p,n]=numSubplots(n)
%
% Purpose
% Calculate how many rows and columns of sub-plots are needed to
% neatly display n subplots. 
%
% Inputs
% n - the desired number of subplots.     
%  
% Outputs
% p - a vector length 2 defining the number of rows and number of
%     columns required to show n plots.     
% [ n - the current number of subplots. This output is used only by
%       this function for a recursive call.]
%
%
%
% Example: neatly lay out 13 sub-plots
% >> p=numSubplots(13)
% p = 
%     3   5
% for i=1:13; subplot(p(1),p(2),i), pcolor(rand(10)), end 
%
%
% Rob Campbell - January 2010
   
    
while isprime(n) & n>4, 
    n=n+1;
end
p=factor(n);
if length(p)==1
    p=[1,p];
    return
end
while length(p)>2
    if length(p)>=4
        p(1)=p(1)*p(end-1);
        p(2)=p(2)*p(end);
        p(end-1:end)=[];
    else
        p(1)=p(1)*p(2);
        p(2)=[];
    end    
    p=sort(p);
end
%Reformat if the column/row ratio is too large: we want a roughly
%square design 
while p(2)/p(1)>2.5
    N=n+1;
    [p,n]=numSubplots(N); %Recursive!
end
