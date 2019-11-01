

function makebrainmask3(tpm, thresh, outfilename)
%% make brain mask from TPM
% tpm: cellaray with 2 or 3 or x compartiments
% tpm=  {    'wc1T2.nii'    'wc2T2.nii'    'wc3T2.nii'}'
% tpm=  {    'wc1T2.nii'    'wc2T2.nii'  }';
%  tpm=fullpath(pwd,tpm);
%  makebrainmask2(tpm, thresh, 'test1.nii')

%  thresh=.2;
for i=1:length(tpm);
    [h1 d1 xyz xyzind]=rgetnii(tpm{i});
    if i==1
        dm=d1.*0;
    end
    dm=dm+single((d1>=thresh));
end

dm=dm>.5;

%% cluster data-----

dm3=dm(:);
idx=find(dm3==1);
index=xyzind(:,idx);
[A ] = spm_clusters(index);

tab=tabulate(A);
clmax=find(tab(:,2)==max(tab(:,2)));
idx2=find(A==clmax);
%  idx2=find(A==1);

idx4=idx(idx2);

dm4=dm3.*0;
dm4(idx4)=1;

dm5=reshape(dm4,(h1.dim));


dm=dm5;

%% fill holes  (over 3d volume does not work accurately -->slieceWise)
df=dm;
for i=1:size(df,3)
    df(:,:,i)= imfill(df(:,:,i),'holes') ;
end

%
%
% %
%
% df2=df.*0;
% for i=1:size(df,3)
%     BW=df(:,:,i);
%     [B,L] = bwboundaries(BW,4,'noholes');
%     %     [L,num] = bwlabel(BW,4)
%
%
%     num=cell2mat(cellfun(@(x) {size(x,1)} ,B));
%     delthresh=.25;
%     pnum=num.*100./(sum(num));
%     isurv=find(pnum>(delthresh*100));
%
%     L2=L.*0;
%     for k=1:length(isurv)
%         L2( L==isurv(k) )=1;
%     end
%     df2(:,:,i)=L2;
%
%
%     %      fg(14);cla
%     %     imagesc(label2rgb(L, @jet, [.5 .5 .5]));
%     %     hold on
%     % for k = 1:length(isurv)
%     %     boundary = B{isurv(k)};
%     %     plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
%     % end
%     %     title(i);
%     %     drawnow
%     %     pause
% end


df2=df;

%----------

h2=h1;
h2.dt=[2 0];
rsavenii(outfilename,h2,df2 );




