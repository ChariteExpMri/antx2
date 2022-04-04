% CREATE MIP_structure
%
% function mipstruct=makeMIP(file,varargin)
% par.show=0;  %show output: [0]no; [1] yes
% par.save=[]; %save MIP:  empty or fullpath filename to save MIP

%source: C:\MATLAB\antx\mritools\ant\templateBerlin_hres
% a=load('AllenMip.mat')
%         DXYZ: [164 212 158]
%         CXYZ: [82 127 122]
%     mask_all: [376x322 logical]
%     grid_all: [376x322 logical]
%        scale: [14.2857 14.2857 14.2857]
% [164+158  212+164] %height: AntPostDim+LeftRightDim  ;width:LeftRightDim+InfSupDim

function mipstruct=makeMIP(file,varargin)

if 0
    file='F:\data3\eranet_VBM_test\templates\AVGT.nii'
    makeMIP(file);
end
% ==============================================
%%   out
% ===============================================
mipstruct=struct();
% ==============================================
%%   addit paramter
% ===============================================
par.show=0;  %show output: [0]no; [1] yes
par.save=[]; %save MIP:  empty or fullpath filename to save MIP
par.setorigin=0; % set origin (lines): 0,1

if nargin>1
    parIN=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    f = fieldnames(parIN);
    for i = 1:length(f)
        par.(f{i}) = parIN.(f{i});
    end
end

% disp(par)

% return

% ==============================================
%%
% ===============================================


%source: C:\MATLAB\antx\mritools\ant\templateBerlin_hres
% a=load('AllenMip.mat')
%         DXYZ: [164 212 158]
%         CXYZ: [82 127 122]
%     mask_all: [376x322 logical]
%     grid_all: [376x322 logical]
%        scale: [14.2857 14.2857 14.2857]
% [164+158  212+164] %height: AntPostDim+LeftRightDim  ;width:LeftRightDim+InfSupDim

% fg;imagesc(a.mask_all)
% m=full(a.mask_all); 376x322
% ==============================================
%%  load AVGT
% ===============================================
[hc c  ]=rgetnii(file);
vec=spm_imatrix(hc.mat);

DXYZ  =hc.dim;
[CXYZ]=convertcoord([0 0 0],hc, 'idx');


scale=1./vec(7:9);

% f1=file'sAVGT.nii';
% ==============================================
%%   find largest slice
% ===============================================
nvals  =length(unique(c));
do_otsu=1;
nclust =5;

if nvals==2
    do_otsu=0;
end

if do_otsu==0;
    ot=c;
else
    if nvals<nclust
        nclust=nvals;
    end
    ot=reshape(otsu(c(:),nclust),hc.dim)>1;
end


mxvec1=squeeze(sum(sum(ot,2),3));
mxvec2=squeeze(sum(sum(ot,1),3));
mxvec3=squeeze(sum(sum(ot,1),2));

mxslice=[min(find(mxvec1==max(mxvec1)))
    min(find(mxvec2==max(mxvec2)))
    min(find(mxvec3==max(mxvec3)))];

takeEveryNslice=(round(size(c)/(10*2))); %
takeEveryNslice=cellfun(@(a){[ num2str(a)]} ,num2cell(takeEveryNslice));

% ==============================================
%%
% ===============================================
tic
[d ds]=getslices(file,1,[takeEveryNslice{1}],[],0 );
% [d ds]=getslices(file,1,[mxslice(1)],[],0 );
d=sum(d,3);
if do_otsu==0;
    d2=d;
else
    d2=otsu(d,5)>1;
end
d2=imfill(d2,'holes');
% d3  =imdilate(d2,ones(5,5))-d2;
d3=imdilate(d2,strel('disk',2))-d2;
if par.setorigin==1
    d3(CXYZ(2),1:2:end)=1; d3(1:2:end,CXYZ(1))=1;
end
da=d3;
% fg,imagesc(da);
if par.setorigin==1
    d(CXYZ(2),1:2:end)=1; d(1:2:end,CXYZ(1))=0;
end
sa=d;

% ========================================================

[d ds]=getslices(file,2,[takeEveryNslice{2}],[],0 );
% [d ds]=getslices(file,2,[mxslice(2)],[],0 );
d=sum(d,3);
if do_otsu==0;
    d2=d;
else
    d2=otsu(d,5)>1;
end
d2=imfill(d2,'holes');
% d3  =imdilate(d2,ones(5,5))-d2;
d3=imdilate(d2,strel('disk',2))-d2;
if par.setorigin==1
    d3(CXYZ(3),1:2:end)=1; d3(1:2:end,CXYZ(1))=1;
end
db=d3;
% fg,imagesc(db);
if par.setorigin==1
    d(CXYZ(3),1:2:end)=1; d(1:2:end,CXYZ(1))=1;
end
sb=d;
% ========================================================
%  [d ds]=getslices(file,3,['15'],[],0 );
[d ds]=getslices(file,3,[takeEveryNslice{3}],[],0 );
%[d ds]=getslices(file,3,[mxslice(3) ],[],0 );
d=sum(d,3);
if do_otsu==0;
    d2=d;
else
    d2=otsu(d,5)>1;
end
d2=imfill(d2,'holes');
% d3  =imdilate(d2,ones(5,5))-d2;ds
d3=imdilate(d2,strel('disk',2))-d2;
if par.setorigin==1
    d3(CXYZ(3),1:2:end)=1; d3(1:2:end,CXYZ(2))=1;
end
dc=d3;
% fg,imagesc(dc);
if par.setorigin==1
    d(CXYZ(3),1:2:end)=1; d(1:2:end,CXYZ(2))=1;
end
sc=d;


toc
% ==============================================
%%   join
% ===============================================
s1=[da   dc'];
s2=[  zeros([size(db',1) size(da,2)])   db'];
s=[s1;s2];
if par.show==1
    fg;imagesc(s); title('MIP');
end

mask_all=sparse(s);
grid_all=sparse(zeros(size(s)));

t1=[sa   sc']; %original
t2=[  zeros([size(sb',1) size(sa,2)])   sb'];
t=[t1;t2];
if par.show==1
    fg;imagesc(t); title('input-image');
end

% ==============================================
%% output
% ===============================================

mipstruct.DXYZ     =DXYZ;
mipstruct.CXYZ     =CXYZ;
mipstruct.mask_all =mask_all;
mipstruct.grid_all =grid_all;
mipstruct.scale    =scale;

%         DXYZ: [164 212 158]
%         CXYZ: [82 127 122]
%     mask_all: [376x322 logical]
%     grid_all: [376x322 logical]
%        scale: [14.2857 14.2857 14.2857]
% [164+158  212+164] %height: AntPostDim+LeftRightDim  ;width:LeftRightDim+InfSupDim
% ==============================================
%%   save MIP
% ===============================================
if ~isempty(par.save)
    mipfile=par.save ;%'F:\data3\eranet_VBM_test\testmip.mat'
    cprintf([0 .5 0],['..saving MIP: ' strrep(mipfile,filesep,[filesep filesep]) '\n' ]);
    save(mipfile,'CXYZ', 'DXYZ' ,'mask_all', 'grid_all', 'scale'); 
end

