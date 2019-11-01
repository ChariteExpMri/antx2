
%%  calculate volume similarity using structural similarity index (ss1) and  corr2
% output: ss1 & R
% example
% calcsimilarity('V:\projects\atlasRegEdemaCorr\nii32\s20150910_FK_C3M13_1_3_1_1\_Atpl_mouseatlasNew.nii','V:\projects\atlasRegEdemaCorr\nii32\s20150910_FK_C3M13_1_3_1_1\hx_T2.nii')


function param=similarity(fi1,fi2)

%input: filepath or 3d volume

if ischar(fi1)
[ha a]=rgetnii(fi1);
else
    a=fi1;
end

if ischar(fi2)
[hb b]=rreslice2target(fi2, fi1, [], 1);;%rgetnii(fi2);
else
    b=fi2;
end


% [ha a]=rgetnii('_Atpl_mouseatlasNew.nii');
% fi='V:\projects\atlasRegEdemaCorr\nii32\s20150910_FK_C3M13_1_3_1_1\hx_T2.nii'
% [hb b]=rgetnii(fi);

%% ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
K = [0.05 0.05];
window = ones(5);
L = 255;
id=[];
for i=1:size(a,2)
    sl=i;
    im1=(squeeze(a(:,sl,:)));
    im2=(squeeze(b(:,sl,:)));
    im1(isnan(im1))=0;
    im2(isnan(im2))=0;
    
    im1=im1-min(im1(:)); im1=im1./max(im1(:)); im1=im1.*255;
    im2=im2-min(im2(:)); im2=im2./max(im2(:));im2=im2.*255;
    [ids ] = ssim_index2(im1, im2, K, window, L);
    
    id(i)=ids;
    id2(i)=corr2(im1, im2);
    
%     id3(i)=nanmean((im1(:)-im2(:)).^2);
    
end

param(1,1)=nanmedian(id);

f=@(r).5.*log((1+r)./(1-r));
f2=@(z)(exp(2*z)-1)./(exp(2*z)+1);
param(1,2)=f2(nanmean(f(id2)));

% param(1,3)=nanmean(id3);





% 
% 
% cf;clear
% [ha a]=rgetnii('_Atpl_mouseatlasNew.nii');
% fi='V:\projects\atlasRegEdemaCorr\nii32\s20150910_FK_C3M13_1_3_1_1\hx_T2.nii'
% [hb b]=rgetnii(fi);
% 
% sl=50
% im1=(squeeze(a(:,sl,:)));
% im2=(squeeze(b(:,sl,:)));
%  
%   K = [0.05 0.05];
%   window = ones(5);
%   L = 255;
%   im1=im1-min(im1(:)); im1=im1./max(im1(:)); im1=im1.*255;
%   im2=im2-min(im2(:)); im2=im2./max(im2(:));im2=im2.*255;
% [ids smap] = ssim_index(im1, im2, K, window, L);
% ids
% 
% [ids smap] = ssim_index(im1, im2);
% ids




