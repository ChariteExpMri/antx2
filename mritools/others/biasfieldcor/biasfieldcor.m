function [ha,ac,a]=biasfieldcor(file)
% v2.0

if iscell(file)
    ha=file{1};
    a =file{2};
else
    
    [ha,a] = rgetnii(file);
end

c = zeros(size(a),'like',a);

% -------------------------------------------------------
% constants (compute once)
% -------------------------------------------------------

A          = 255;
sigma      = 4;
nu         = 0.001*A^2;

iter_outer = 10;%20;   % was 50
iter_inner = 3;%5;    % was 10

timestep   = .1;
mu         = 1;
c0         = 1;
epsilon    = 1;

% -------------------------------------------------------
% geometry (compute once)
% -------------------------------------------------------

imsz = size(a(:,:,1));

K = fspecial('gaussian',round(2*sigma)*2+1,sigma);

KONE = conv2(ones(imsz),K,'same');

initialLSF = c0*ones(imsz);

box = round(imsz/4);

ctr = round(imsz/2);

r1 = max(1,ctr(1)-box(1));
r2 = min(imsz(1),ctr(1)+box(1));

c1 = max(1,ctr(2)-box(2));
c2 = min(imsz(2),ctr(2)+box(2));

initialLSF(r1:r2,c1:c2) = -c0;

% -------------------------------------------------------
% slice loop
% -------------------------------------------------------

for i=1:size(a,3)

%     S = sprintf('BiasFieldCorrection slice-%d\n',i);
%     fprintf(S);

    bb = double(a(:,:,i));

    Img = A*normalize01(bb);

    u = initialLSF;

    b = ones(imsz);

    for n=1:iter_outer
        [u,b] = lse_bfe( ...
            u,...
            Img,...
            b,...
            K,...
            KONE,...
            nu,...
            timestep,...
            mu,...
            epsilon,...
            iter_inner);
    end

    bci = denormalize01( ...
        (Img./(b+(b==0)))./255 , ...
        bb);

    c(:,:,i) = bci;

%     fprintf(repmat('\b',1,numel(S)));

end

% -------------------------------------------------------
% slice-wise adjustment
% -------------------------------------------------------

mid = round(size(c,3)/2);

li = [ ...
    flipud([[2:mid]' [1:mid-1]']); ...
    [[mid:size(c,3)-1]' [mid+1:size(c,3)]'] ...
    ];

e = c;

e(:,:,mid) = mat2gray(e(:,:,mid));

for i=1:size(li,1)

    a1 = mat2gray(e(:,:,li(i,2)));
    a2 = mat2gray(e(:,:,li(i,1)));

    e(:,:,li(i,2)) = imhistmatch(a1,a2);

end

ac = denormalize01(e,a);

% fprintf('BFC..done.\n');

end