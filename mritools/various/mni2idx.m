
function res=mni2idx(cords, hdr, mode )
% convert cords from [idx to mni] or  [mni to idx]
% cords must be [3xX]
% ===========================
% convert idx2mni
% res=mni2idx( orig.x.XYZ(:,1:10000) , orig.x.hdr, 'idx2mni' );
% sum(sum(orig.x.XYZmm(:,1:10000)-res'))
% % convert mni2idx
% res=mni2idx( orig.x.XYZmm(:,1:10000) , orig.x.hdr, 'mni2idx' );
% test: sum(sum(orig.x.XYZ(:,1:10000)-res'))

% hdr   =orig.x.hdr;
% xyz   =orig.x.XYZ;
% xyzmm =orig.x.XYZmm;


hb=hdr.mat;

%% idx2mni
if strcmp(mode,'idx2mni')

    q=cords;
    %q=xyz(:,i);
    Q =[q ; ones(1,size(q,2))];
    Q2=Q'*hb';
    Q2=Q2(:,1:3);
    
    res=Q2;
%     n=xyzmm(:,i)'
%     Q2-n

elseif strcmp(mode,'mni2idx')

%% mni2idx
si=size(cords);
if si(1)==1
    cords=cords';
end
    Q2=cords';
    %Q2= xyzmm(:,i)';
    Q2=[Q2   ones(size(Q2,1),1)] ;
    Q =hb\Q2';
    Q=Q(1:3,:)';

%     f=xyz(:,i)'
%     Q-f
    res=Q;
else
    error('use idx2mni or mni2idx');
end


%
%
%
% orig.x.XYZ
% orig.x.XYZmm
% orig.x.hdr
%
%
% m=orig.x.hdr.mat
% hb=m
% s_x=hb(1,:);%hb.hdr.hist.srow_x;
% s_y=hb(2,:);%hb.hdr.hist.srow_y;
% s_z=hb(3,:);%hb.hdr.hist.srow_z;
%
% for j=1:10000
%     i=j
%     q=orig.x.XYZ(:,i);
%     n=orig.x.XYZmm(:,i);
%
%
%     % s_x(find(s_x(1:3)==0))=1;
%     % s_y(find(s_y(1:3)==0))=1;
%     % s_z(find(s_z(1:3)==0))=1;
%
%
%     ff=q';
%
%     nc(:,1) = s_x(1).* ff(:,1)  +   s_x(2).* ff(:,2)  +   s_x(3).* ff(:,3)  +   s_x(4);
%     nc(:,2) = s_y(1).* ff(:,1)  +   s_y(2).* ff(:,2)  +   s_y(3).* ff(:,3)  +   s_y(4);
%     nc(:,3) = s_z(1).* ff(:,1)  +   s_z(2).* ff(:,2)  +   s_z(3).* ff(:,3)  +   s_z(4);
%
%     q(:)'
%     n(:)'
%     nc(:)'
%
%     nn(j,:)=nc;
% end
%
% % sum(sum(abs(nn-Q2)))
%
% %% idx2mni
% i=1:5
%
% q=orig.x.XYZ(:,i)
% Q =[q ; ones(1,size(q,2))];
% Q2=Q'*hb';
% Q2=Q2(:,1:3)
% n=orig.x.XYZmm(:,i)'
%
% Q2-n
%
% %% mni2idx
% Q2= orig.x.XYZmm(:,i)';
% Q2=[Q2   ones(size(Q2,1),1)] ;
% Q =hb\Q2';
% Q=Q(1:3,:)'
%
% f=orig.x.XYZ(:,i)'
%
% Q-f
%







