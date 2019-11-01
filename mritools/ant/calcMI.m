



function param=calcMI(fi1,fi2)

%input: filepath or 3d volume

if ischar(fi1)
[ha a]=rgetnii(fi1);
else
    a=fi1;
end

if ischar(fi2)
[hb b]=rreslice2target(fi2, fi1, [], 1);%rgetnii(fi2);rgetnii(fi2);
else
    b=fi2;
end

%% no nan
a(isnan(a))=0;
b(isnan(b))=0;

%%mask of graymatter
% imask=b<.01;
%  a(imask)=0;
% b(imask)=0;
%  imask2=b>0;
%  a=imask2.*a;
% b=imask2.*a;

% fg,
% subplot(2,2,1); imagesc(a(:,:,10));colorbar
% subplot(2,2,2); imagesc(b(:,:,10));colorbar


%% to integer
dynr=1024;%55;
a=a-min(a(:)); a=round((a./max(a(:))).*dynr);
b=b-min(b(:)); b=round((b./max(b(:))).*dynr);

miv=zeros(size(a,3),1);
for i=1:size(a,3)
  miv(i)= mi2(a(:,:,i),  b(:,:,i));
end

% miv=[;%]zeros(size(a,1),1);
% for i=1:size(a,1)
%   miv(i)= mi2( squeeze(a(i,:,:)),  squeeze(b(i,:,:))      );
% end

miv(miv==0)=[];
param=median(miv);

% disp([ mean(miv)  median(miv) sum(miv)  max(miv)    ]);

function M = mi2(X,Y)
% function M = MI_GG(X,Y)
% Compute the mutual information of two images: X and Y, having
% integer values.
% 
% INPUT:
% X --> first image 
% Y --> second image (same size of X)
%
% OUTPUT:
% M --> mutual information of X and Y
%
% Written by GIANGREGORIO Generoso. 
% DATE: 04/05/2012
% E-MAIL: ggiangre@unisannio.it
%__________________________________________________________________________

X = double(X);
Y = double(Y);

X_norm = X - min(X(:)) +1; 
Y_norm = Y - min(Y(:)) +1;

matAB(:,1) = X_norm(:);
matAB(:,2) = Y_norm(:);
h = accumarray(matAB+1, 1); % joint histogram

hn = h./sum(h(:)); % normalized joint histogram
y_marg=sum(hn,1); 
x_marg=sum(hn,2);

Hy = - sum(y_marg.*log2(y_marg + (y_marg == 0))); % Entropy of Y
Hx = - sum(x_marg.*log2(x_marg + (x_marg == 0))); % Entropy of X

arg_xy2 = hn.*(log2(hn+(hn==0)));
h_xy = sum(-arg_xy2(:)); % joint entropy
M = Hx + Hy - h_xy; % mutual information