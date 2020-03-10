
% make hidden overlay of 2d or 3d data
% ro=ovlhidden(r1,r2,alpha,doplot)
% r1: 1st 2d/3d image
% r2:  2nd 2d/3d image   (r1 & r2 must match in size )
% alpha: <optional> transparency: 0-1
% doplot <optional> plot image [0,1]
function ro=ovlhidden(r1,r2,alpha,doplot)

if exist('alpha') ~=1  || isempty(alpha);      alpha=0.5; end
if exist('doplot')~=1  || isempty(doplot);     doplot=0; end



% ==============================================
%%   test
% ===============================================
if 0
    r1=v.dat(:,:,10);
    r2=v.mask(:,:,10);
    
    r1=v.dat;
    r2=v.mask;
    alpha=0.5
end

r1=montageout(permute(double(r1),[1 2 4 3]));
r2=montageout(permute(double(r2),[1 2 4 3]));
% r1=v.dat2d;
% r2=double(v.mask2d);


C = gray;  % Get the figure's colormap.
L = size(C,1);
% Scale the matrix to the range of the map.
Gs = round(interp1(linspace(min(r1(:)),max(r1(:)),L),1:L,r1));
H1 = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.


C = jet;  % Get the figure's colormap.
L = size(C,1);
% Scale the matrix to the range of the map.
if length(unique(r2(:)))>1
    Gs = round(interp1(linspace(min(r2(:)),max(r2(:)),L),1:L,r2));
    H2 = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.
else
   H2=repmat(permute([0 .5 0],[ 3 1 2]), [size(H1,1) size(H1,2)  1]); 
end


ro=H1.*(1-alpha)+H2.*(alpha);
% ==============================================
%  test
% ===============================================

if doplot==1
    fg,image(ro)
end


