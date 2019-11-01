
function [w3 bord]=parcelate(w,nbox, plotter)

warning off;
if 0
    load('mandrill')
    w=imresize(X,[402 410]);
    % w=rand(402,410);
    nbox=4;
end

si=size(w);


% l1=round (linspace(1,si(1), nbox+1))
% l2=round (linspace(1,si(2), nbox+1))
r1=mod(si(1),4);
r2=mod(si(2),4);

si2=si-[r1 r2];
w2=imresize(w,si2);

si3=si2/nbox;

% w3=reshape(w2,[si3 numel(w2)/(prod(si3))   ]);

l1=[1:si3(1):si2(1) si2(1)+1];
l2=[1:si3(2):si2(2) si2(2)+1];

n=1;
bord=[];
for i=1:length(l1)-1
    for j=1:length(l2)-1
        s1=l1(i):l1(i+1)-1;
        s2=l2(j):l2(j+1)-1;
        
%           w3(:,:,n)=w2(s1,s2);
          bord(n,:)=round([s1([1 end]) s2([1 end])]); %borders
          
        w3(:,:,n)=w2(l1(i):l1(i+1)-1,  l2(j):l2(j+1)-1);
        n=n+1;
    end
end

if plotter==1
    fg; montage_p(w3)
end
