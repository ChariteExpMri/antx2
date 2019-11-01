function [v vh]=makeBrainMask(thispath,thresh, outname)
%% maekbrainMask
% if outname: empty -->does not write mask to disk
% outputs;
% [v vh]: volume+header



% thispath=paths{i}
% thresh=.2
% outname='tpl_ms.nii'
outname2=fullfile(thispath,outname);


%% 1: make brainmask
% [fi0] = spm_select('FPList',[thispath ],'^ms.*nii$');
[fi1] = spm_select('FPList',[thispath  ],'^c1.*nii$');
[fi2] = spm_select('FPList',[thispath  ],'^c2.*nii$');



% h0=spm_vol(fi0);
h1=spm_vol(fi1);
h2=spm_vol(fi2);
% v=single(spm_read_vols(h0));
[d1 XYZmm1]= (spm_read_vols(h1));d1=single(d1);
[d2 XYZmm ]= (spm_read_vols(h2));d2=single(d2);

d1(d1>thresh)=1;
d2(d2>thresh)=1;

d4=d1+d2;

%% with CSF
if 0 
    [fi3] = spm_select('FPList',[thispath  ],'^c3.*nii$');
    h3=spm_vol(fi3);
    d3=single(spm_read_vols(h3));
    d3(d3>thresh)=1;
    d4=d1+d2+d3;
end




d4(d4>0)=1;


%% fill holes  (over 3d volume does not work accurately -->slieceWise)
df=d4;
for i=1:size(df,3)
  df(:,:,i)= imfill(df(:,:,i),'holes') ;
end



% df=imfill(df(:,:,:));
% 
% %% cluster
% [x y z] = ind2sub(size(d2),1:length(d2(:)));
% XYZ=single([x;y;z]);; clear x y z;
% 
% df2 =df(:);
% is=find(df2==1);
% xyz2=XYZ(:,is);
% 
% [A] = spm_clusters(xyz2)
% r=single(zeros(size(df2)));
% r(is)=A;
% 
% r2=reshape(r,size(df));
% 
% 
% [s]=pclustermaxima(Z,xyz,hdr)
% pclustermaxima



% 

df2=df.*0;
for i=1:size(df,3)
    BW=df(:,:,i);
    [B,L] = bwboundaries(BW,4,'noholes');
    %     [L,num] = bwlabel(BW,4)


    num=cell2mat(cellfun(@(x) {size(x,1)} ,B));
    delthresh=.25;
    pnum=num.*100./(sum(num));
    isurv=find(pnum>(delthresh*100));

    L2=L.*0;
    for k=1:length(isurv)
        L2( L==isurv(k) )=1;
    end
    df2(:,:,i)=L2;


    %      fg(14);cla
    %     imagesc(label2rgb(L, @jet, [.5 .5 .5]));
    %     hold on
    % for k = 1:length(isurv)
    %     boundary = B{isurv(k)};
    %     plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
    % end
    %     title(i);
    %     drawnow
    %     pause
end



% d4=df2;









%% mask out
% v(d4==0)=0;
v=df2;

vh=h1;
vh.fname='';

if ~isempty(outname)
    vh.fname=outname;
    vh=spm_create_vol(vh);
    vh=spm_write_vol(vh,  v);
end





