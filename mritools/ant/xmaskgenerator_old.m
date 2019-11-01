%% #ko MASK-GENERATOR (create masks based on anatomical regions)
%
%% #wb STRUCT PARAMETERS
% labelID   : one/more Ids from Atlas (numeric array)
%          -example: The id of Caudoputamen is 672 (compare webside "http://atlas.brain-map.org/atlas?atlas=1", ..
%          - if a region is selected on the webside, the link contains the ID after "structure.." )
% hemisphere: specifies hemispheric information
%             (1): use left Hemisphere only
%             (2): use right Hemisphere only
%             (3): use both Hemispheres united
%             (4): use both Hemispheres separated
% merge     : merge regions (0|1)    (only if several regions were selected)
% saveas    : name of the output image (saved in the template's folder), (string)
% =============================================================================================
% xmaskgenerator(1,z)    ;%%run this function in (0)silent or (1) GUI -mode
%
%__________________________________________________________________________________________________________
%% #wb EXAMPLE BATCH
% z={};
% z.labelID=[672 56];                     %% Regions: CAUDOPUTAMEN AND N. Accumbens
% z.hemisphere=3;                         %% combine both hemispheres
% z.merge=[0];                            %% do not merge regions
% z.saveas='PUTAM_NAccumb.nii';           %% name of the image to save (image and info.txt is saved in the template's folder)
% xmaskgenerator(1,z)                     %% run function with OPEN GUI
%__________________________________________________________________________________________________________
%% #wb History: type anth in comand window

function xmaskgenerator(showgui,x,pa)

%———————————————————————————————————————————————
%%   get database
%———————————————————————————————————————————————



global an
[ta tah filename  ] =readatlastable;
templatepath  =  fullfile(fileparts(an.datpath),'templates');

avg0=fullfile(templatepath,'AVGT.nii');
ano0=fullfile(templatepath,'ANO.nii');
fib0=fullfile(templatepath,'FIBT.nii');
% disp(' ......use MOUSE''s local templates');


avg = nifti(avg0);
avg = double(avg.dat);

anostruct = nifti(ano0);
ano       = double(anostruct.dat);

fib = nifti(fib0);
fib       = double(fib.dat);


AVGT=avg;
ANO=ano;
ANOstruct=anostruct;
FIBT =fib;


hano=spm_vol(ano0);

[COL] = buildColLabeling2(ANO,ta);
COL2 = buildColLabeling2(FIBT,ta);
[idvol idlabel] = makeIDvolume2(ANO,ta);

ANO2 = ANO; z.hemisphere = 'Both';
FIBT2 = FIBT;
ANO2(isnan(ANO))=0;
FIBT2(isnan(ANO))=0;

ta=computeAreasSize2(ta,ANO2,FIBT2); %CHECK WITH IDXLUT:voxsz
[v]=prep4mask2(ta,ANO,FIBT);

ID = ta(:,4);
ID = cellfun(@(a){num2str(a)},ID);
vx = ta(:,6);% voxsize
vx( cellfun(@isempty, vx) ) = {0};
vx=cellfun(@(a){sprintf('%7d',a)} ,vx);

colhex=ta(:,2);
nam = {};
stag=repmat('&clubs;',[1 5]);
for i=1:size(ta,1)
    col=colhex{i};
    nam{i,1}=['<font color="#' col  '">'  stag '<font color="000000">' ];
end
nam2=ta(:,1);

tb=[ID vx nam  nam2];
tbh={'ID' 'Nvox' 'Color'  'Label'};

clear global mxm
global mxm
clear xmx
mxm.v       = v;
mxm.ano     = ANO2;
mxm.avgt    = AVGT;
mxm.col     = COL;
mxm.col2    = COL2;
mxm.tb      = tb;
mxm.ta      = ta;
mxm.idvol   = idvol;
mxm.idlabel = idlabel;

fun={@showlist,tb,tbh};

%———————————————————————————————————————————————
%%   GUI
%———————————————————————————————————————————————
if exist('showgui')~=1;    showgui=1; end
if exist('x')      ~=1;    x=[];      end
if isempty(x);             showgui=1; end

p={...
    'inf1'      '*** MASK-GENERATOR                '         '' ''
    'inf2'      ['[' mfilename ']']                         '' ''
    'inf3'     '==================================='        '' ''
    'labelID'     ''      'SELECT ANATOMICAL LABELS HERE'     fun
    'hemisphere'   '(3) both united'    'HEMISPHERE: define mask & relation to hemisphere' {'(1) left','(2) right','(3) both united' '(4) both separated '}
    'merge'        1                    'MERGE VALUES: in case of fevaseveral anatom. labels: (1) all labels get the same code (..BINARYMask/DualMask), (0) keep label-specific codes (MultiColorMask)'                       'b'
    'saveas'     'dummy.nii'            'DEFINE FILENAME to save the mask (default: file is stored in the "templates folder", but the name mus tbe specified)'                       'f'
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.5 .5 .4 .2 ],'title','MASK-GENERATOR');
    if isempty(m);return; end
else
    z=param2struct(p);
end

%———————————————————————————————————————————————
%%  run showx again
%———————————————————————————————————————————————
if isempty(z.labelID);
    error('NO ANATOMICAL LABELS SELECTED...PROCESS TERMINATED') ;
end


global mxm

if ischar(z.labelID)
    atlasID    = str2num(char(z.labelID))';
else
    atlasID=z.labelID;
end
atlasID    = atlasID(:); %selected IDS
atlasIDall = cell2mat((ta(:,4)));                  %all ATLAS IDs

index=[];%get TableINdex
for i=1:length(atlasID)
    index=[index; find(atlasIDall==atlasID(i))];
end

showx(index); %plot selected areas




%———————————————————————————————————————————————
%%   get parameters
%———————————————————————————————————————————————
if ~isnumeric(z.hemisphere)
    z.hemisphere=str2num(z.hemisphere(regexpi(z.hemisphere,'\d')));
end
[pax fix ext]=fileparts(z.saveas);
if isempty(pax); pax=fullfile(fileparts(an.datpath),'templates') ; end

msk = mxm.mask;
lab = mxm.masklabels;

%% make labelinfo
lax=[ num2cell(1:length(atlasID))'  lab num2cell(atlasID(:))  ];

[paav fiav extav]=fileparts(avg0);
avghemi=fullfile(paav,[ fiav 'hemi.nii']);

img=   permute(rot90(msk,3),[1 3 2 ]);
if z.merge==1
    img(img>0)=1;
    lax(:,1)={1};
    mergestr='m1';
else
    mergestr='m0';
end
if z.hemisphere==1;
    [hma ma] =rgetnii(avghemi);
    img=(img.*(ma==1));
    hemistr='hL'; %left HEMISPHERE
elseif z.hemisphere==2;
    [hma ma] =rgetnii(avghemi);
    img=(img.*(ma==2));
    hemistr='hR'; %right HEMISPHERE
elseif z.hemisphere==3
    hemistr='hB'; %botj Hemispheres
elseif z.hemisphere==4;   %both HEMISPHERES SEPARATED
    [hma ma] =rgetnii(avghemi);
    dum1 = (img.*(ma==1));
    mx=max(dum1(:))
    dum2 = (img.*(ma==2))+mx;
    dum2(dum2==mx)=0;
    img=dum1+dum2;
    
    laxLe=lax;
    laxLe(:,2)=cellfun(@(a){[ 'L ' a]}, laxLe(:,2));
    
    laxRi=lax;
    laxRi(:,2)=cellfun(@(a){[ 'R ' a]}, laxRi(:,2));
    lax=[laxLe;laxRi];
    lax(:,1)=num2cell(1:size(lax,1));
    
    hemistr='hBS';
end

%% write this file
templatepath  =  fullfile(fileparts(an.datpath),'templates');

hd=spm_vol(fullfile(templatepath,'AVGT.nii'));
fiout=fullfile(pax,[fix ['_' mergestr '_' hemistr ] '.nii']);
rsavenii(fiout,hd,img,[2 0]);

showinfo2( 'new mask'  ,fiout); drawnow;

%% write info;
fioutinfo=fullfile(pax,[fix  ['_' mergestr '_' hemistr ] '.txt']);
for i=1:size(lax,1)
    labx{i,1}=[ sprintf('%4d\t',lax{i,1})   lax{i,2}  sprintf('\t%4d\t',lax{i,3})  ];
end
pwrite2file2(fioutinfo,labx,[]);


makebatch(z);



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%•••••••••••••••••••••••••••••••	subs        •••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

%% ________________________________________________________________________________________________
function makebatch(z)
try
    hlp=help(mfilename);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end
hh={};
hh{end+1,1}=('% ======================================================');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=[ '% descr:' hlp];
hh{end+1,1}=('% ======================================================');
hh=[hh; struct2list(z)];
hh(end+1,1)={[mfilename '(' '1',  ',z' ')' ]};
% uhelp(hh,1);
try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '}];
assignin('base','anth',v);
disp(['batch <a href="matlab:' 'uhelp(anth)' '">' 'show batch code' '</a>'  ]);

%% ________________________________________________________________________________________________
function id=showlist(tb, tbh)
id=selector2(tb,tbh,'selfun',{@showx},'iswait',1,'position',[0.0778  0.0772  0.3510  0.8644]);
id=id(:)';
id=str2num(char(tb(id,1)));
id=id(:)';
try; close(11); end

%% ________________________________________________________________________________________________
%———————————————————————————————————————————————
%%   show volume
%———————————————————————————————————————————————

function showx(id)
global mxm
if exist('id')~=1
    us=get(gcf,'userdata');
    id0=find(us.sel);
    id=str2num(char(us.raw(id0,1)));
    lab=us.raw(id0,4);
else
    lab=mxm.idlabel(id+1); %% THIS MUST BE INDEX+1 !!!
end

newplot=1;
if newplot==1
    is=id;
    val=ones(length(is),1);
end

%% get MASK
v     =mxm.v;
mm    =v.msk; %fill
md    =v.msk; %delete
uni =[v.uni;v.uni2];
iv  =[v.iv ;v.iv2];
n = 1;
nm=-1;
for i=1:length(is)
    idx=is(i);
    ivox=find(ismember(uni, [v.lab{idx,1} ;v.lab{idx,2} ]));
    
    if sign(val(i))>0
        if ~isempty(ivox)
            vx=iv(ivox);
            k=cell2mat(vx);
            mm(k ,1 )  =n;
            n=n+1;
        end
    else
        if ~isempty(ivox)
            vx=iv(ivox);
            k=cell2mat(vx);
            md(k ,1 )  =nm;
            nm=nm-1;
        end
    end
end
mk2   =reshape(mm,[v.si]);
mkdel =reshape(md,[v.si]);

if isempty(mk2) ;      mk2=zeros(size(mxm.avgt));      end
if isempty(mkdel) ;    mkdel=zeros(size(mxm.avgt));      end

if ~isfield(mxm,'bg'); %backgroundvector
    G=mxm.avgt;
    C = colormap(gray);  % Get the figure's colormap.
    L = size(C,1);
    Gs = round(interp1(linspace(min(G(:)),max(G(:)),L),1:L,G));
    H = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.
    
    si=size(mxm.avgt);
    h2=reshape(H,[prod(si(1:3)) 3]);
    c2=reshape(mxm.col,[prod(si(1:3)) 3]);
    
    mxm.h2=h2;  %hinterground gray-RGB
    mxm.c2=c2; %%colorlabel forground-RGB  orig gray-RGB vals -ALLlabels
    mxm.f2=h2; %%colorlabel forground-RGB  orig gray-RGB vals - zusammengestellte labels
    
    % movingpoint
    si=size(mxm.avgt);
    pp=rot90(permute(mxm.idvol,[1 3 2 4]));
    pp=pp(22:end-22+1 , 10:end-10 , 10:end-10,:); %cut vol
    pp = montageout(permute(pp,[1 2 4 3]));
    mxm.idvol2=single(pp);
    
end
si=size(mxm.avgt);
m2   =reshape(mk2,    [prod(si(1:3)) 1]);
m2del=reshape(mkdel,    [prod(si(1:3)) 1]);

% get current fusion-vector
f2      = mxm.f2;
if newplot==1
    f2      = mxm.h2;
end
% remove labels
iv      =find(m2del<0);
f2(iv,:)=mxm.h2(iv,:);
% add labels
iv      =find(m2>0);
f2(iv,:)=mxm.c2(iv,:);

% make mask
mxm.mask      =rot90(permute(mk2,[1 3 2 4]));
mxm.masklabels=lab;

%% update mxm.f2
mxm.f2=f2;
f3=reshape(f2,[si 3 ]);
f4=rot90(permute(f3,[1 3 2 4]));
f4=f4(22:end-22+1 , 10:end-10 , 10:end-10,:);%cut this
f5=[];
f5(:,:,1) = montageout(permute(f4(:,:,:,1),[1 2 4 3]));
f5(:,:,2) = montageout(permute(f4(:,:,:,2),[1 2 4 3]));
f5(:,:,3) = montageout(permute(f4(:,:,:,3),[1 2 4 3]));

if isempty(findobj(0,'tag','maskimg'))
    figure(11);set(gcf,'tag','maskimg','color','k','units','norm','position',[ 0.4309    0.3994    0.3889    0.4667]);
    im=image(f5);
    set(im,'tag','mask');
    axis image
    set(gcf,'WindowButtonMotionFcn',@figmotion);
    set(gcf,'units','normalized'); set(gca,'position',[0 0 1 1]);
    set(gcf,'menubar','none');
    set(gcf,'toolbar','figure');
    axis off;
    
    %% courcour
    cr=[...
        NaN    1       1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        1     2       2     1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        1     2       2     1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   1       1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN];
    set(gcf,'Pointer','custom');
    set(gcf,'PointerShapeCData',cr);
    
else
    im=findobj(0,'tag','mask');
    set(im,'cdata',single(f5));
end

msg2=sprintf('# InMask-Voxel=%i ',(length(find(mxm.mask(:)>0))));
plotfig=findobj(0,'tag','maskimg');
set(plotfig,'name',[ '[' msg2   '] move mouse to label underlying region' ]);
set(plotfig,'name',[ '[' msg2   '] move mouse to label underlying region' ]);
% drawnow;

%% ________________________________________________________________________________________________
function figmotion(h,e)
try
    pos=get(gca,'CurrentPoint');
    pos=round(pos(1,1:2));
    pos=fliplr(pos);
    d= (get(findobj(gcf, 'type','image'),'cdata'));;
    if (pos(1)>0 && pos(1)<=size(d,1)) &&  (pos(2)>0 && pos(2)<=size(d,2))
        global mxm
        msg=['   '  mxm.idlabel{mxm.idvol2(pos(1),pos(2))}];
        msg2=sprintf('#VoxMsk=%i ',(length(find(mxm.mask(:)>0))));
        
        mn=[pos(2) pos(1)];
        te=findobj(gcf,'tag','posmagn');
        if isempty(te)
            te=text(mn(1), mn(2),msg ,'tag','posmagn' ,'color','w');
            set(te,'fontsize',6,'color','w','fontname','courier','fontweight','bold',...
                'verticalalignment','center','horizontalalignment','left');
        else
            set(te,'position',[mn(1), mn(2) .1 ]);
        end
        set(te,'string',msg);
        set(gcf,'name',[ '[' msg2   ']' msg(3:end)]); drawnow
    end
end
%% ________________________________________________________________________________________________
function msk=getmask(luts,v, idx)
%% INTERSECTION UNIQUE LABEL IN ANO AND LUTS+ITS CHILDREN
[com a1 a2]=intersect(v.uni, [v.lab{idx,1} ;v.lab{idx,2} ]); %
vx=v.iv(a1);
vz=cell2mat(vx); %get indices for label ( Nx2 array)
v.msk(vz)=1;
msk=reshape(v.msk,[v.si]);
if 1 %use also FIB
    [com a1 a2]=intersect(v.uni2, [v.lab{idx,1} ;v.lab{idx,2} ]); %
    vx=v.iv2(a1);
    vz=cell2mat(vx); %get indices for label ( Nx2 array)
    v.msk(vz)=1;
    msk2=reshape(v.msk,[v.si]);
    msk=msk+msk2;
end
%% ________________________________________________________________________________________________
function COL = buildColLabeling2(ANO,tb)
ANO(isnan(ANO)) = 0;
id=cell2mat(tb(:,4))
I = sparse([id]+1,ones(size(tb,1),1),1:size(tb,1));
cmap=str2num(char(tb(:,3)));
cmap = [0 0 0 ; cmap]/255;
w = full(I(ANO+1));
COL = reshape(cmap(w+1,:),[size(ANO) 3]);
%% ________________________________________________________________________________________________
function [idvol idname] = makeIDvolume2(ANO,tb)
ANO(isnan(ANO)) = 0;
id=cell2mat(tb(:,4))
I = sparse([id]+1,ones(size(tb,1),1),1:size(tb,1));
cmap=str2num(char(tb(:,3)));
cmap = [0 0 0 ; cmap]/255;
nmap=[1:size(tb,1)]';
w = full(I(ANO+1));
% COL = reshape(cmap(w+1,:),[size(ANO) 3]);
idvol  = single(reshape(nmap(w+1,:),[size(ANO) 1]));
idname =[{'outside'};tb(:,1)];
%% ________________________________________________________________________________________________
function tb=computeAreasSize2(tb,ANO,FIBT)
ano2=ANO(:);
%% SLOW VERSION
% if 0
%     tic
%     cc=zeros(size(tb,1),1)
%     for i=1:size(tb,1)
%         is=[tb{i,4}; tb{i,5}];
%         is(isnan(is))=[];
%
%         cc(i,1)=sum(histc(ano2,sort(is)));
%     end
%     toc
% end
%%--------------------------------------------

iio = find(ANO>0);
F = sparse(ANO(iio),ones(length(iio),1),ones(length(iio),1));
idx = find(F>0);
sz = full(F(idx));

id=cell2mat(tb(:,4));
c2=zeros(size(tb,1),1);
for k = 1:length(idx),
    %idxLUT(idx(k) == [idxLUT.id]).voxsz = sz(k);
    c2(idx(k) == [id]) = sz(k);
end
if ~isempty(FIBT)
    iio = find(FIBT>0);
    F = sparse(FIBT(iio),ones(length(iio),1),ones(length(iio),1));
    idx = find(F>0);
    sz = full(F(idx));
    for k = 1:length(idx),
        %idxLUT(idx(k) == [idxLUT.id]).voxsz = sz(k);
        c2(idx(k) == [id]) = sz(k);
    end
end
voxz = zeros(1,size(tb,1));
for k = 1:size(tb,1)
    if (c2(k))==0
        [common, ia, ib] = intersect([id],tb{k,5});
        if not(isempty(ia))
            voxsz = sum([c2(ia)]);
            c2(k) = voxsz;
        end
    end
end
tb(:,6)=num2cell(c2);
%% ________________________________________________________________________________________________
function [v]=prep4mask2(tb,ANO,FIBT)
an=(ANO(:));
msk=zeros(size(an));
uni=unique(an);
uni(1)=[];
si=size(ANO);
iv={};
for i=1:length(uni)
    ix= find(an==uni(i));
    iv{i,1}=ix;
end

fi=(FIBT(:));
uni2=unique(fi);
uni2(1)=[];
iv2={};
for i=1:length(uni2)
    ix= find(fi==uni2(i));
    iv2{i,1}=ix;
end

%% get label and ots children from LUTS
lab=[tb(:,4:5)]
v.lab = lab ;  %ALL-LABEL-IDX
v.msk = msk ; %used for later filling [zeroMtrx]
v.si  = si  ; %SIZE
% -ANO------------
v.uni = uni ;  %numeric labels
v.iv  = iv  ;  %indices in vol
%-FIBT------
v.uni2 =uni2  ;
v.iv2  =iv2  ;
