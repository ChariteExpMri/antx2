
function out=saveslices_gif(s1,s2, flip,outpath,outputstr)
tagstr='';
if exist('outputstr')==1
    tagstr=char(outputstr);
end

if 0
    pa='O:\data4\phagozytose\dat\20190219CH_Exp1_M8'
    f1=fullfile(pa,'t2.nii');
    f2=fullfile(pa,'_msk.nii');
    [d ds]=getslices(f1     ,1,['2'],[],0 );
    [o os]=getslices({f1 f2},1,['2'],[],0 );
    
    outpath=fullfile(pa,'summary')
    saveslices_gif({d,ds},{o os}, 1,outpath);
    
end


% checks
d=s1{1}; ds=s1{2};
if ~isempty(s2)
 o=s2{1}; os=s2{2};   
end

%=============================================
sliceadjust=1;
%=============================================

if sliceadjust==1
    for i=1:size(d,3)
        d(:,:,i)=imadjust(mat2gray(d(:,:,i)));
    end
    if exist('o')==1
        for i=1:size(d,3)
            o(:,:,i)=imadjust(mat2gray(o(:,:,i)));
        end
    end
end

%=============================================
if flip==1;     flipup = @(x) flipdim(x,1);
else;     flipup = @(x) (x);
end


d=flipup(d);
if exist('o')==1
    o=flipup(o);
    mxval2=max(o(:));
end

mxval1=max(d(:));
percdown=.1;

for i=1:size(d,3)
    tx=text2im(sprintf('%2.2f',ds.smm(i)));
    %    if (size(tx,1)<size(d,1)) && (size(tx,2)<size(d,2))
    %    tx=imresize(tx,[round(size(tx)*1.5)],'nearest');
    %    end
    
    tx=imresize(tx,[round(size(d,1)*percdown) nan],'nearest');
    tx1=(~tx).*mxval1;
    
    d(2:size(tx,1)+1,1:size(tx,2),i)=tx1;
    if exist('o')==1
        tx2=(~tx).*mxval2;
        o(2:size(tx,1)+1,1:size(tx,2),i)=tx2;
    end
end



%———————————————————————————————————————————————
%%
%———————————————————————————————————————————————



d2=montageout(permute(d,[1 2 4 3]));
if sliceadjust==1
    [d3 cmap1]=gray2ind(d2);
else
    [d3 cmap1]=gray2ind(imadjust(mat2gray( (d2))));
end

if exist('o')==1
    o2=montageout(permute(o,[1 2 4 3]));
    if sliceadjust==1
        [o3 cmap2]=gray2ind(o2);
    else
        [o3 cmap2]=gray2ind(imadjust(mat2gray( (o2))));
    end
 end






%    imwrite(d3,cmap1,'test.gif','gif');
%   imwrite(o3,cmap2,'test2.gif','gif');
%
%

if exist('o')==1
    [~,name]=fileparts(os.V.fname);
    name3=[tagstr name '_animated.gif'];
    gifname=fullfile(outpath,[name3]);
    imwrite(d3,cmap1,gifname,'gif', 'Loopcount',inf,'DelayTime',.5);
    imwrite(o3,cmap2,gifname,'gif','WriteMode','append','DelayTime',.5);
else
    name3='';
end

[~,name1]=fileparts(ds.V.fname);
name1=[tagstr name1 '.gif'];
gifname1=fullfile(outpath,[name1]);
imwrite(d3,cmap1,gifname1,'gif');


if exist('o')==1
    [~,name2]=fileparts(os.V.fname);
    name2=[tagstr name2 '.gif'];
    gifname2=fullfile(outpath,[name2]);
    imwrite(o3,cmap2,gifname2,'gif');
else
    name2='';
end

out={name1;name2;name3};



