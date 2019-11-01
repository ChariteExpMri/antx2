
function  lut= test_atlasreadout(tmpVOL, ANO2,idxLUT)

% luts,ANO2,tmpVOL

d=tmpVOL>.3;
w=ANO2.*d;

id=unique(w(:));
id(id==0)=[];

w2=w(:);
a=ANO2(:);
tb=zeros(length(id),3);
for i=1:length(id)
    tb(i,:)=    [ id(i)  length(find(w==id(i)))    length(find(a==id(i)))    ];
end

tb(:,4)=tb(:,2)./tb(:,3);


a1=[idxLUT(:).id]';

for i=1:length(idxLUT)
    idxLUT(i).tb=[0 0 0 0];
end

for i=1:size(tb,1)
   ix=find(a1==tb(i,1));
    idxLUT(ix).tb= [tb(i,:)];
end

lut=idxLUT;

% 
% a2=[[idxLUT(:).atlas_id]']
% 
% r=intersect(a1,tb(:,1))
% r2=intersect(a2,tb(:,1))