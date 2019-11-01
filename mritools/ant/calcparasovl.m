function param=calcparasovl(fi1,fi2)

%input: filepath or 3d volume

if ischar(fi1)
[ha a]=rgetnii(fi1);
else
    a=fi1;
end

if ischar(fi2)
[hb b]=rgetnii(fi2);
else
    b=fi2;
end

%% no nan
a(isnan(a))=0;
b(isnan(b))=0;



imask=b<.001;
%  a(imask)=0;
b(imask)=0;
 b=single(b>0);
 
 imask2=b>0;
%  a=imask2.*a;
s=a/max(a(:));

n=0;
[t1 t2]=deal([]);
for i=2:2:size(b,3)-2
    
    w1= im2bw( s(:,:,i)  ,graythresh(s(:,:,i))  );
    w2= im2bw( b(:,:,i)  ,graythresh(b(:,:,i))  );
    
    
    try
        [B,L,N] = bwboundaries(w1,'noholes');
        mx=cell2mat(cellfun(@(f){size(f,1)},B));
        imax=find(mx==max(mx));
        x1=single(L==imax);
        
        [B,L,N] = bwboundaries(w2,'noholes');
        mx=cell2mat(cellfun(@(f){size(f,1)},B));
        imax=find(mx==max(mx));
        x2=single(L==imax);
        
        p1=regionprops(x1,'extent','area','MajorAxisLength','MinorAxisLength','centroid','perimeter');
        p2=regionprops(x2,'extent','area','MajorAxisLength','MinorAxisLength','centroid','perimeter');
        %     cell2mat(struct2cell(p1))-cell2mat(struct2cell(p2))
        
        dum=abs([p1.Area-p2.Area
            p1.MajorAxisLength-p2.MajorAxisLength
            p1.MinorAxisLength-p2.MinorAxisLength
            p1.Centroid(1)-p2.Centroid(1)
            p1.Centroid(2)-p2.Centroid(2)
            p1.Perimeter-p2.Perimeter]);
        
        if isempty(t1); t1=dum;
        else
              t1(:,end+1)=dum; 
        end
     
        n=n+1;
    end
end


% disp(median(t1,2)');

val=median(t1,2)';
param=norm(val(2:end-1));%val(1);
disp(val);

% 
% imshow(label2rgb(L, @jet, [.5 .5 .5]))
% hold on
% for k = 1:length(B)
%    boundary = B{k};
%    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
% end