
% BIAS field correction
% [ha ac a]=biasfieldcor(file)
% file: input nifti file
% ha: header
% ac: BF-corrected volume
% a : original volume
% EXAMPLE
% f1=fullfile('O:\data4\Graham_Problem\dat\d5','t20.nii');
%     [ha ac a]=biasfieldcor(f1);
    
function [ha ac a]=biasfieldcor(file)


if 0
    tic
    f1=fullfile('O:\data4\Graham_Problem\dat\d5','t20.nii');
    [ha ac a]=biasfieldcor(f1);
    toc
    %  fg,montage_p(ac);
end




% tic
% for i=1:100
%     S = sprintf('BFC slice- %d\n',i); 
%     fprintf(S); 
%     pause(0.02); 
%     fprintf(repmat('\b',1,numel(S))); 
% end
% 
% 
% 
% 
% 
% [ha ac a]=deal([]);
% return



[ha a]    = rgetnii(file);
c=zeros(size(a));
for i=1:size(a,3)
    S = sprintf('BiasFieldCorrection slice-%d\n',i); 
    fprintf(S); 
    
    
    bb=squeeze(a(:,:,i));
    Img=double(bb);
    
    A=255;
    Img=A*normalize01(Img); % rescale the image intensities
    f=denormalize01(Img,bb);
    
    nu=0.001*A^2; % coefficient of arc length term
    sigma = 4; % scale parameter that specifies the size of the neighborhood
    iter_outer=50;
    iter_inner=10;   % inner iteration for level set evolution
    
    timestep=.1;
    mu=1;  % coefficient for distance regularization term (regularize the level set function)
    c0=1;
    % initialize level set function
    initialLSF = c0*ones(size(Img));
    % initialLSF(30:90,50:90) = -c0;
    
    box= (size(Img)/4);
    box=round([size(Img)/2-box; size(Img)/2+box]);
    initialLSF(box(1,1):box(2,1), box(1,2):box(2,2)) =-c0;
    u=initialLSF;
    
    %     if 0
    %         figure(1);
    %         imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal
    %         hold on;
    %         contour(u,[0 0],'r');
    %         title('Initial contour');
    %
    %         figure(2);
    %         imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal
    %         hold on;
    %         contour(u,[0 0],'r');
    %         title('Initial contour');
    %     end
    
    epsilon=1;
    b=ones(size(Img));  %%% initialize bias field
    
    K=fspecial('gaussian',round(2*sigma)*2+1,sigma); % Gaussian kernel
    KI=conv2(Img,K,'same');
    KONE=conv2(ones(size(Img)),K,'same');
    [row,col]=size(Img);
    N=row*col;
    
    for n=1:iter_outer
        [u, b, C]= lse_bfe(u,Img, b, K,KONE, nu,timestep,mu,epsilon, iter_inner);
        %     if mod(n,2)==0
        %         pause(0.001);
        %         imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal;
        %         hold on;
        %         contour(u,[0 0],'r');
        %         iterNum=[num2str(n), ' iterations'];
        %         title(iterNum);
        %         hold off;
        %     end
    end
    % Mask =(Img>10);
    % Img_corrected=normalize01(Mask.*Img./(b+(b==0)))*255;
    %     bci=normalize01(Img./(b+(b==0)))*255;
    bci=denormalize01((Img./(b+(b==0)))/255,bb);
    if 0
        figure(3); imagesc(b);  colormap(gray); axis off; axis equal;
        title('Bias field');
        
        figure(4);
        imagesc(bci); colormap(gray); axis off; axis equal;
        title('Bias corrected image');
    end
    %     if 0
    %         fg;
    %         subplot(2,2,1); imagesc(bb);
    %         subplot(2,2,2); imagesc(bci); title(i);
    %     end
    
    c(:,:,i)=bci;
    
    fprintf(repmat('\b',1,numel(S))); 
end

%———————————————————————————————————————————————
%%   slice-wise adjustment
%———————————————————————————————————————————————
mid=round(size(c,3)/2);
li=[flipud([ [2:mid]' [1:mid-1]'])  ; ...
    [ [mid:size(c,3)-1]'  [mid+1:size(c,3)]']];
e=c;
e(:,:,mid)=mat2gray(e(:,:,mid));
for i=1:size(li,1)
    a1=mat2gray(e(:,:,li(i,2)));
    a2=mat2gray(e(:,:,li(i,1)));
    bs = imhistmatch(  a1 ,a2);
    e(:,:,li(i,2))=bs;
end
ac=denormalize01(e,a);


% fg,montage_p(a); title('before'); colorbar
% fg,montage_p(f); title('after'); colorbar

% rsavenii(fout,ha(1),c);

fprintf('BFC..done. \n');

