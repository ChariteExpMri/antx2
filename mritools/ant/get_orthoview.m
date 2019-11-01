
%  o=get_orthoview(f1,vec,plotter,slicemode, nslice)
% f1        : nifit file
% vec       : transformation parameters see 'spm_matrix'
% plotter   : [0,1] show result
% slicemode : 'origin' or 'max' (max projection over nslices (nslic)
% nslice    : number of slices to use (only for 'max'), default 5
% get_orthoview(f1,[0 0 0],1,'origin')
% get_orthoview(f1,[0 0 0],1,'max',7)
function o=get_orthoview(f1,vec,plotter,slicemode, nslice)


if exist('slicemode')==0;     slicemode='origin' ;end
if exist('nslice')==0;        nslice   =5        ;end

% nslice

 
% arg1='V:\Graham\mpm_pilot_19\antanalysis2\dat\_testM1\t2.nii'
% f1='V:\Graham\mpm_pilot_19\antanalysis2\dat\_testM1\b10.nii'
% f1='I:\AG_Wu\studyLo\analysis_2jul19\dat\m05_3\t2.nii'

if exist('plotter')==0
    plotter=0;
end

V = spm_vol(f1);
V=V(1);

if exist('vec')==0
    V.premul    = eye(4);
else
    if length(vec)<12
        B=[zeros(1,6) 1 1 1 0 0 0];
        B(1:length(vec))=vec;
    end
    
    
    %     B=[zeros(1,6) 1 1 1 0 0 0]
    %     B(4)=-pi/2
    %     B(5)=pi
    %     B(6)=pi/2
    
    
    V.premul = spm_matrix(B);
    
    
end

V.window    = 'auto';
V.mapping   = 'linear';

H=1;
rr.vols{H} =V;
rr.vols{H}.area =[0    0.4500    1.0000    0.5500];

%%
rr.Space=eye(4);
%% BOUBNDING BOX
mn = [Inf Inf Inf];
mx = -mn;
for i=length(rr.vols);%valid_handles(1:24)
    premul = rr.Space \ rr.vols{i}.premul;
    bb = spm_get_bbox(rr.vols{i}, 'fv', premul);
    mx = max([bb ; mx]);
    mn = min([bb ; mn]);
end;
bb = [mn ; mx];
rr.bb=bb;



%% resolution
% global st
% if nargin == 0
res = 1; % Default minimum resolution 1mm
% else
%     res = arg1;
% end
for i=length(rr.vols)
    % adapt resolution to smallest voxel size of displayed images
    res = min([res,sqrt(sum((rr.vols{i}.mat(1:3,1:3)).^2))]);
end
res      = res/mean(svd(rr.Space(1:3,1:3)));
Mat      = diag([res res res 1]);
rr.Space = rr.Space*Mat;
rr.bb    = rr.bb/res;

if strcmp(slicemode,'origin')
    o=origin(rr);
elseif strcmp(slicemode,'max')
    o=maxproj(rr,nslice);
end


%% bla
if plotter==1
    fg;
    subplot(2,2,1);imagesc(o.imgc);
    set(gca,'ydir','normal')
    vline(o.cent(2)-o.bb(1,2)+1,'color','r');
    hline(o.cent(3)-o.bb(1,3)+1,'color','r');
    
    subplot(2,2,2);imagesc(o.imgs);
    set(gca,'ydir','normal')
    vline(o.cent(2)-o.bb(1,2)+1,'color','r');
    hline(o.cent(3)-o.bb(1,3)+1,'color','r');
    
    subplot(2,2,3);imagesc(o.imgt);
    set(gca,'ydir','normal')
    vline(o.cent(2)-o.bb(1,2)+1,'color','r');
    hline(o.cent(2)-o.bb(1,2)+1,'color','r');
end









function o=origin(rr)


mmcentre     = mean(rr.Space*[rr.bb';1 1],2)';
rr.centre    = mmcentre(1:3);


%=== redraw

bb   = rr.bb;
Dims = round(diff(bb)'+1);
is   = inv(rr.Space);
cent = is(1:3,1:3)*rr.centre(:) + is(1:3,4);


rr.mode=1;
i=1;
M = rr.Space\rr.vols{i}.premul*rr.vols{i}.mat;
TM0 = [ 1 0 0 -bb(1,1)+1
    0 1 0 -bb(1,2)+1
    0 0 1 -cent(3)
    0 0 0 1];
TM = inv(TM0*M);
TD = Dims([1 2]);

CM0 = [ 1 0 0 -bb(1,1)+1
    0 0 1 -bb(1,3)+1
    0 1 0 -cent(2)
    0 0 0 1];
CM = inv(CM0*M);
CD = Dims([1 3]);

if rr.mode ==0,
    SM0 = [ 0 0 1 -bb(1,3)+1
        0 1 0 -bb(1,2)+1
        1 0 0 -cent(1)
        0 0 0 1];
    SM = inv(SM0*M);
    SD = Dims([3 2]);
else
    SM0 = [ 0 -1 0 +bb(2,2)+1
        0  0 1 -bb(1,3)+1
        1  0 0 -cent(1)
        0  0 0 1];
    SM = inv(SM0*M);
    SD = Dims([2 3]);
end;

rr.hld=1;
imgt  = spm_slice_vol(rr.vols{i},TM,TD,rr.hld)';
imgc  = spm_slice_vol(rr.vols{i},CM,CD,rr.hld)';
imgs  = spm_slice_vol(rr.vols{i},SM,SD,rr.hld)';



o.imgc=imgc;
o.imgs=imgs;
o.imgt=imgt;
o.cent=cent;
o.bb  =bb;


function o=maxproj(rr,nslic)

if isinf(nslic)
%     nslic=round(mean(rr.vols{1}.dim)/3);
    nslic=round(min(rr.vols{1}.dim)/3);
end

%% MIP over nslic slices
bbox=rr.Space*[rr.bb';1 1];
% nslic=5;

slic=[];
mmcentre     = mean(rr.Space*[rr.bb';1 1],2)';
for i=1:3
    slic(i,:) = linspace(bbox(i,1),bbox(i,2),nslic+2);
end
slic(:,[1 end])=[];
slic(:,end+1)=mmcentre(1:3)';

% disp(slic);

%% bla
rr.mode=1;
i=1;

for j=1:size(slic,2)
    
    %mmcentre     = mean(rr.Space*[rr.bb';1 1],2)';
    %rr.centre    = mmcentre(1:3);
    slicmm=slic(:,j)';
    
    %=== redraw
    
    bb   = rr.bb;
    Dims = round(diff(bb)'+1);
    is   = inv(rr.Space);
    cent = is(1:3,1:3)*slicmm(:) + is(1:3,4);
    
    
    
    M = rr.Space\rr.vols{i}.premul*rr.vols{i}.mat;
    TM0 = [ 1 0 0 -bb(1,1)+1
        0 1 0 -bb(1,2)+1
        0 0 1 -cent(3)
        0 0 0 1];
    TM = inv(TM0*M);
    TD = Dims([1 2]);
    
    CM0 = [ 1 0 0 -bb(1,1)+1
        0 0 1 -bb(1,3)+1
        0 1 0 -cent(2)
        0 0 0 1];
    CM = inv(CM0*M);
    CD = Dims([1 3]);
    
    if rr.mode ==0,
        SM0 = [ 0 0 1 -bb(1,3)+1
            0 1 0 -bb(1,2)+1
            1 0 0 -cent(1)
            0 0 0 1];
        SM = inv(SM0*M);
        SD = Dims([3 2]);
    else
        SM0 = [ 0 -1 0 +bb(2,2)+1
            0  0 1 -bb(1,3)+1
            1  0 0 -cent(1)
            0  0 0 1];
        SM = inv(SM0*M);
        SD = Dims([2 3]);
    end;
    
    rr.hld=1;
    imgt  = spm_slice_vol(rr.vols{i},TM,TD,rr.hld)';
    imgc  = spm_slice_vol(rr.vols{i},CM,CD,rr.hld)';
    imgs  = spm_slice_vol(rr.vols{i},SM,SD,rr.hld)';
    
    if j==1
        imgt2=zeros([size(imgt) nslic]);
        imgc2=zeros([size(imgc) nslic]);
        imgs2=zeros([size(imgs) nslic]);
    end
    imgt2(:,:,j)=imgt;
    imgc2(:,:,j)=imgc;
    imgs2(:,:,j)=imgs;
    
    %     if plotter==1
    %         fg,
    %         subplot(2,2,1);imagesc(imgc);
    %         set(gca,'ydir','normal')
    %         vline(cent(2)-bb(1,2)+1,'color','r');
    %         hline(cent(3)-bb(1,3)+1,'color','r');
    %
    %         subplot(2,2,2);imagesc(imgs);
    %         set(gca,'ydir','normal')
    %         vline(cent(2)-bb(1,2)+1,'color','r');
    %         hline(cent(3)-bb(1,3)+1,'color','r');
    %
    %         subplot(2,2,3);imagesc(imgt);
    %         set(gca,'ydir','normal')
    %         vline(cent(2)-bb(1,2)+1,'color','r');
    %         hline(cent(2)-bb(1,2)+1,'color','r');
    %     end
    
end%slic

imgt=max(imgt2,[],3);
imgc=max(imgc2,[],3);
imgs=max(imgs2,[],3);

% imgt=mean(imgt2,3);
% imgc=mean(imgc2,3);
% imgs=mean(imgs2,3);

o.imgc=imgc;
o.imgs=imgs;
o.imgt=imgt;
o.cent=cent;
o.bb  =bb;
o.nslic=nslic;

% if plotter==1   fg,
%     subplot(2,2,1);imagesc(imgc);
%     set(gca,'ydir','normal')
%     vline(cent(2)-bb(1,2)+1,'color','r');
%     hline(cent(3)-bb(1,3)+1,'color','r');
%
%     subplot(2,2,2);imagesc(imgs);
%     set(gca,'ydir','normal')
%     vline(cent(2)-bb(1,2)+1,'color','r');
%     hline(cent(3)-bb(1,3)+1,'color','r');
%
%     subplot(2,2,3);imagesc(imgt);
%     set(gca,'ydir','normal')
%     vline(cent(2)-bb(1,2)+1,'color','r');
%     hline(cent(2)-bb(1,2)+1,'color','r');
%
% end



