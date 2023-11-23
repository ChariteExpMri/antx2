
% subfunction: Exvivo-data with high-contrast (PBS) solution --> remove exvivo-tube
% q=removeTube(fullfile(pa,'t2.nii'));
% 
function fileout=removeTube(file)
%% ===============================================

%% ===============================================
if 0
    
    pa='F:\data7\automaticCoreg\dat\m2_exvivoBrandt'
    file=fullfile(pa,'t2.nii');
    q=removeTube(file)
    showinfo2(['new file2:'],q);
    
end
%% ===============================================
fileout=[];
f1=file;
pa=fileparts(f1);
% f1=fullfile(pa,'t2.nii');
[ha a0]=rgetnii(f1);

% a=imgaussfilt(a0,2);
a=ordfilt3D(a0,14);


b=reshape(otsu(a(:),2),[ha.dim]);

edge1=b(:,[1 end],:);
edge2=b([1 end],:,:);
edgeval=mode([edge1(:) ; edge2(:)]) ;% b(1,1,1);
val=setdiff(unique(b(:)),edgeval);
b2=b==val;

d=reshape(otsu(a(:),3),[ha.dim]);

excen=[];
id=[];
for i=1:3
    c=squeeze(mean(b2,i))>0;
    c=imfill(c,'holes');
    c2=bwlabeln(c);
    uni=unique(c2); uni(uni==0)=[];
    t=zeros(length(uni), 2);
    for k=1:length(uni)
        t(k,:) = [ uni(k) length(find(c2==uni(k)))] ;
    end
    t=flipud(sortrows(t,2));
    c2=c2==t(1, 1);
    
    d2=squeeze(mode(d,i));
    
    
    c3=imerode(c2,ones(3));
    c4=imerode(c2,ones(5));
    ring=c3-c4;
    %tabulate(d2(ring==1));
    val2=mode(d2(ring==1));
    
    o= regionprops(c2,'eccentricity');
    excen(1,i)=o.Eccentricity;
    id(1,i)=val2;
end
% disp([excen]);
% ans =
%     Eccentricity: 0.1383

% ==============================================
%%   untube
% ===============================================


%% ===============================================
threshEcentr=0.3;
filename    ='_tmp_ExvivoTube.nii';
if ~isempty(find(excen<threshEcentr))
    
    
    
    is=find(excen<0.3);
    val=id(is);
    
    d=reshape(otsu(a(:),3),[ha.dim]);
    d2=squeeze(mode(d,2));
    
    d3=d==val;
    d3=imdilate(d3, ones(3));
    d4=bwlabeln(d3);
    
    uni=unique(d4); uni(uni==0)=[];
    t=zeros(length(uni), 2);
    for k=1:length(uni)
        t(k,:) = [ uni(k) length(find(d4==uni(k)))] ;
    end
    t=flipud(sortrows(t,2));
    d4=d4==t(1, 1);
    
    
    
    w=imcomplement(d4).*a;
    
    f2=fullfile(pa,filename);
    rsavenii(f2,ha,w,64);
    
    
else;
    f2=fullfile(pa,filename);
    copyfile(f1,f2,'f');
end

% showinfo2(['new file:'],f2);

fileout=f2;
