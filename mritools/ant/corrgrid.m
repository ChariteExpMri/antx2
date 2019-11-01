% function [xmed xsum]=corrgrid(q,z, nboxes,plotter)
% [xmed xsum]=corrgrid(q,z, 1:10,1);
%  [xmed xsum]=corrgrid(q,z(:,:,1), 1:10,1)
%q: 2d image
% z : 2d or 3d (stack of images)


function [xmed xsum xme]=corrgrid(q,z, nboxes,plotter)

q=double(q);
z=double(z);
%% corr2 loop

if 0
% z=d(:,:,v);
z=d(:,:,:);%
q=m2;
nboxes=[5:10]
plotter=1

end

% nbox=4;rr=[];
numx=0;
for nbox=nboxes
    numx=numx+1;
    u2=q;
    % u2=medfilt2(u2);
    p2=parcelate(u2,nbox,0);
    

    for j=1:size(z,3)
        u1=z(:,:,j);
        % u1=medfilt2(u1);
        p1=parcelate(u1,nbox,0);
        for i=1:size(p1,3)
            rr(i,j,numx)=corr2(p1(:,:,i),p2(:,:,i));
        end
    end
end

rr=abs(rr);
rr(rr==0)=nan;

rr2=permute(rr,[1 3 2]);
rr2=reshape(rr2,[ size(rr2,1)*size(rr2,2)  size(rr2,3)]);

xsum  =nansum(rr2,1);
xmed=nanmedian(rr2,1);
xme=nanmean(rr2,1);
xnum=median(sum(~isnan(rr2)));
% xnum
try
    if plotter==1
        
        ma1=find(xsum==max(xsum));
        ma2=find(xmed==max(xmed));
        ma3=find(xme==max(xme));
        
        fg;
        subplot(2,2,1); plot(xsum,'-r.'); title(['nansum : max ' num2str(ma1)]);          hold on; plot(ma1,xsum(ma1),'db');
        subplot(2,2,2); plot(xmed,'-r.'); title(['nanmdian : max ' num2str(ma2)]);     hold on; plot(ma2,xmed(ma2),'db');
        subplot(2,2,3); plot(xme,'-r.'); title(['nanmean : max ' num2str(ma3)]);       hold on; plot(ma3,xme(ma3),'db');
    end
end



