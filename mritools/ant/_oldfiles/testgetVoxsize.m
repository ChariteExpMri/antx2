

function testgetVoxsize

% idxLUT = BrAt_ComputeAreaSize(idxLUT,ANO2,FIBT2);
load myLabels_line178

a=idxLUT
fn=fieldnames(a(1))
t={}
for i=1:length(a)
   r=a(i);
   t(i,:)= struct2cell(r)';
    
end

an=ANO2;
s=single(ANO2==70);

for i=10:size(t,1)
    
    c=a(i).children
    
end