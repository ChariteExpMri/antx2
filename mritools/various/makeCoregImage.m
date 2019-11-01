
% varargout=makeCoregImage(pa,varargin)
% pa: path to data   ; example 'O:\data4\err\dat\20190121GC_MPM_01'
% addit. pairwise parameter
% f1     BG-image; file in pa; deafult 't2.nii'      
% f2     FG-image; file in pa; default '_refIMG.nii' 
% show   show image; (0,1); default 1
% useReorientMat   use reorient matrix; (0,1); only necessary when checking coregistration; of different spaces; default 1
% alpha    image transparency; (0..1); default 0.3
% cleanup  clean temporary images; (0,1);  default 1  ; 
% cmap1    BG image colormap; string or cmap-array; default gray;
% cmap2    FG image colormap; string or cmap-array; default  ='def1';
% save     save image as JPG; (0,1); default 0;
% savename image-name to save; string; default 'coreg2.jpg';
% center   definition of the center to display; (1,2)
%                 where [1] center of mass (default)
%                   or  [2] origin, or, [3] middle of the image, 
%                   or  [xyzmm] such as [-2 2 3] 
%===============
% addit. parameter can be used via struct or pairwise parameter inputs
% makeCoregImage(pa)
%% STRUCT INPUTS
% makeCoregImage(pa,struct('f1','x_t2.nii','f2','AVGT.nii','useReorientMat',0));
% makeCoregImage(pa,struct('f1','x_t2.nii','f2','AVGT.nii','useReorientMat',0,'alpha',.4,'cmap1','gray','cmap2','hot'));
% makeCoregImage(pa,struct('alpha',.4,'cmap1','gray','save',1,'savename','tester.jpg'));
% makeCoregImage(pa,struct('f1','t2.nii','f2','_refIMG.nii','useReorientMat',1,'save',0,'center',[3 3 3])); %
% 
%% PAIRWISE INPUTS
% makeCoregImage(pa,'show',0,'save',0,'alpha',.7)
% makeCoregImage(pa,'f1','t2.nii','f2','AVGT.nii','useReorientMat',1);
% makeCoregImage(pa,'f1','c1c2mask.nii','f2','AVGTmask.nii','useReorientMat',1);
% makeCoregImage(pa,'f1','t2.nii','f2','_refIMG.nii','useReorientMat',1,'save',1,'savename','coreg2.jpg'); % STANDARD REGISTRATION
%% OUTPUT:
%  bb=makeCoregImage(pa,'show',0,'save',0,'alpha',.7);
%  fg;image(bb)

function varargout=makeCoregImage(pa,varargin)


if 0
    clc
    pa=pwd;
    makeCoregImage(pa);
    
end

warning off;

%�����������������������������������������������
%%   defaults
%�����������������������������������������������
px.f1     ='t2.nii'      ;
px.f2     ='_refIMG.nii' ;
px.show   = 1;
px.useReorientMat = 1;
px.alpha     =0.3  ; %alphamap
px.cleanup   =1  ; %clean temp images
px.cmap1     =gray;
px.cmap2     ='def1';
px.save      = 0;
px.savename  = 'coreg2.jpg';
px.center    = 1;  % center of mass [1]; or [2] origin

if nargin==0
    disp(' path not specified');
    disp(' addit. parameter see help');
    
   varargout{1}=px;
   return
end

%�����������������������������������������������
%%   inputs
%�����������������������������������������������
if nargin>1
    if length(varargin)==1
        pp=varargin{1};
    else
        pp=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    end
    
    fields=fieldnames(pp);
    for i=1:length(fields)
          px=setfield(px,fields{i},   getfield(pp,fields{i}) );
    end
end

% disp(px); return




f10 =fullfile(pa,px.f1);           %fullfile(pa,'t2.nii');
f20 =fullfile(pa,px.f2); %f20=fullfile(pa,'_refIMG.nii');

f1  =stradd(f10,'_TPMcheckreg',2);  %fullfile(pa,'t2Aligned.nii');
f2 =stradd(f20,'_TPMcheckreg',2);  %f2=fullfile(pa,'_refimgAligned.nii');

[name,im,ext]=fileparts(f10);
copyfile(f20,f2,'f');

%% APPLY REORITEN MAT
%      %GM from ALLENSAPCE to mouseSPACE
%         w1=fullfile(pa,'_test_refIMG_inMOUSEPACE.nii')
%         copyfile(fullfile(pa, '_refIMG.nii' ),w1,'f');
%         v=  spm_vol(w1);
%         spm_get_space(w1,     (M) * v.mat);
if px.useReorientMat ==1
%     defs=load(fullfile(pa,'defs.mat'));
%     M=defs.defs.reorientmats{end,1}; %take the last REORIENT-MAT
%    
    
    r=load(fullfile(pa,'reorient.mat'));
    M=r.M;
    
    v=  spm_vol(f2);
    spm_get_space(f2,     (M) * v.mat);
    
    
end




[box1 vv1]=world_bb(f10);
[box2 vv2]=world_bb(f2);

boxn=[min([box1;box2]); max([box1;box2])];
resize_img5(f10,f1, vv1, boxn,[], 1);


%% load images
[ha a xyz xyzind]=rgetnii(f1);
[hb b ]=rreslice2target(f2, f1, [], 1);

% dimh=round(size(a)./2);
% 


if 0
    xs=sum(xyz.^2,1);
    or=find(xs==min(xs))
    orix=xyzind(:,or); % ORIGIN..problematic
end

%center MASK
if length(px.center)==1
    if px.center==1
        l=[];
        mx=max(sum(b,3),[],1); l(2,1)=max(find(mx==max(mx)));
        mx=max(sum(b,3),[],2); l(1,1)=max(find(mx==max(mx)));
        mx=max(squeeze(sum(b,2)),[],1); l(3,1)=max(find(mx==max(mx)));
        orix=l(:);
    elseif px.center==2
        xs=sum(xyz.^2,1);
        or=find(xs==min(xs));
        orix=xyzind(:,or); % ORIGIN..problematic
   elseif px.center==3
       dimh=round(size(a)./2);
       orix=dimh(:);
    end
elseif length(px.center)==3   
    df=repmat([px.center(:)], [1 size(xyz,2)]);
    xs=sum((xyz-df).^2,1);
    or=find(xs==min(xs));
        orix=xyzind(:,or);
       % xyz(:,or)   ,%check
end

% orix


% fg,imagesc(fliplr(squeeze(a(orix(1),:,:)))); colormap gray
% fg,imagesc(rot90(squeeze(a(:,orix(2),:)))); colormap gray
% fg,imagesc(  (rot90(squeeze(a(:,:,orix(3)))))); colormap gray

sim=[200 200];
r1=imresize(fliplr(squeeze(a(orix(1),:,:))),sim);
o1=imresize(fliplr(squeeze(b(orix(1),:,:))),sim);

r2=imresize(rot90(squeeze(a(:,orix(2),:))),sim);
o2=imresize(rot90(squeeze(b(:,orix(2),:))),sim);

r3=imresize(flipud(rot90(squeeze(a(:,:,orix(3))))),sim);
o3=imresize(flipud(rot90(squeeze(b(:,:,orix(3))))),sim);



[name,im1,ext1]=fileparts(f10); [~,name]=fileparts(name);
[~   ,im2,ext2]=fileparts(f20);

k=dir(f10); date1=k.date;
k=dir(f20); date2=k.date;

% 
% mes=[];
% e=zeros(1,800);
% i1=text2im(['DIR: ' name]);   k=[~i1     zeros(size(i1,1),   size(e,2)-size(i1,2) ) ]; mes=[mes;k];
% i1=text2im(['Bg : ' im1 ext1 '  ' date1]);   k=[~i1 zeros(size(i1,1),   size(e,2)-size(i1,2) ) ]; mes=[mes;k];
% i1=text2im(['Fg : ' im2 ext2 '  ' date2]);   k=[~i1 zeros(size(i1,1),   size(e,2)-size(i1,2) ) ]; mes=[mes;k];
% % mes=imresize(mes,[size(mes,1) sim(2)*2],'nearest');
% % fg,imagesc(mes)


str4='image creation time: ';
mxname=max([length([im1 ext1]) length([im2 ext2])  length([str4])]);
i1=text2im([' DIR: ' name]); 
i2=text2im([' Bg : ' im1 ext1   repmat(' ',[1 mxname-length([im1 ext1])]) ' ' date1 '']); 
i3=text2im([' Fg : ' im2 ext2   repmat(' ',[1 mxname-length([im2 ext1])]) ' ' date2 '']); 
i4=text2im([ str4  repmat(' ',[1 mxname-length([str4])+6]) ' ' datestr(now)]); 

mx=max([size(i1,2) size(i2,2) size(i3,2) size(i4,2)]);
i1=[i1 ones(size(i1,1), [mx-size(i1,2)]) ];
i2=[i2 ones(size(i2,1), [mx-size(i2,2)]) ];
i3=[i3 ones(size(i3,1), [mx-size(i3,2)]) ];
i4=[i4 ones(size(i4,1), [mx-size(i4,2)]) ];

mes=~[i1;i2;i3;i4];
% fg,imagesc(mes);


rx=[r3 r1; r2 r2.*0];
ox=[o3 o1; o2 o2.*0];

% rx=[mes.*max(rx(:))          ;   rx];
% ox=[mes.*0                    ;   ox];

if px.cleanup==1
    try    delete(f1);end
    try    delete(f2);end
end
%�����������������������������������������������
%%   RGB
%�����������������������������������������������

B=rx;
O=ox;

% Now make an RGB image that matches display from IMAGESC:
if ischar(px.cmap1)
      eval(['C=' px.cmap1 ';'])  ;
else
  C = px.cmap1;  
end

% C = gray;  % Get the figure's colormap.
L = size(C,1);
% Scale the matrix to the range of the map.
% G=r1;
G=imadjust(mat2gray(B));
Gs = round(interp1(linspace(min(G(:)),max(G(:)),L),1:L,G));
H = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from sc


if ischar(px.cmap2)
    if strcmp(px.cmap2,'def1')
    C=[         0    0.6000    0.2000
        0    0.8000         0
        0.2000    1.0000    0.2000
        0.6000    1.0000    0.6000
        ];
    % fg,image(permute(C,[1 3 2]))
    C=flipud(C);
    else
      eval(['C=' px.cmap2 ';'])  ;
    end
else
  C = px.cmap2;  
end

L = size(C,1);
% Scale the matrix to the range of the map.
G=O;
Gs = round(interp1(linspace(min(G(:)),max(G(:)),L),1:L,G));
H2 = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from sc

H2mask=otsu(O,3);
H2mask=repmat(H2mask>1,[1 1 3]);

H3=H2.*H2mask;

alphaFactor=px.alpha;
bb = double(H);
f = double(H3);
fa = alphaFactor .* f;
ba = (1 - alphaFactor) .* bb;
fi = fa + ba;

fi2=imresize(fi,[1000 1000]);
fi2=([ repmat(   imresize(mes,[ round( 1000/size(mes,2)*size(mes,1)) 1000],'nearest') ,[1 1 3]) ; fi2]);
% fg;image(fi2);

%�����������������������������������������������
%%   show
%�����������������������������������������������
if px.show==1
    fg;image(fi2);
end


%�����������������������������������������������
%%  save
%�����������������������������������������������
if px.save==1
    px.savename=[strrep(px.savename,'.jpg','') '.jpg'];
    outfile=fullfile(pa,px.savename); %'coreg2.jpg');
    imwrite(uint8(round(fi2.*255)), outfile);
end
%�����������������������������������������������
%%   parse out
%�����������������������������������������������
if nargout>0
    varargout{1}=fi2;
end