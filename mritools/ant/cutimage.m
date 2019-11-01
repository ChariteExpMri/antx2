
function cutimage(pa,varargin)

warning off

if 0
     
end


if 0
    pa='O:\data4\phagozytose\dat\200_Exp1'
    cutimage(pa,'meth',1,'show',1)
    
    
    
end


%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————
 
pp=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
pp.pa=pa;

% if pp.meth==1
    meth(pp)
% end



function meth(pp)  %using mask

pa=pp.pa;

if pp.meth==1
    f1=fullfile(pa,'_msk.nii');
    [ha a c ci]=rgetnii(f1);
    [bb vox]=world_bb(f1);    vox=abs(vox);
    
    a2=reshape(otsu(a(:),20),[ha.dim])>1;
    
elseif pp.meth==2
    t2=fullfile(pa,'t2.nii');
    [ha a ]=rreslice2target(fullfile(pa,'_b1grey.nii'), t2, [], 1);
    [hb b ]=rreslice2target(fullfile(pa,'_b2white.nii'), t2, [], 1);
    [hc c ]=rreslice2target(fullfile(pa,'_b3csf.nii'), t2, [], 1);
    a2=(a+b+c)>0;
    
    [ha a c ci]=rgetnii(t2);
    [bb vox]=world_bb(t2);    vox=abs(vox);
    
end


% a3=smooth3(a2,'box',11)>0;
%a3=imerode(a2,strel('disk',2));
 a3=imdilate(a2,strel('disk',10));
for i=1:size(a3,3)
    a3(:,:,i)=imfill(a3(:,:,i),'holes');
end
a4=a3(:);
ix=find(a4>0);
mm=c(:,ix);
bb2=[min(mm,[],2)' ; max(mm,[],2)'] ;
bb2(:,3)=bb(:,3);


t2cut=fullfile(pa,'t2cut@.nii');
try; delete(t2cut);end
t2=fullfile(pa,'t2.nii');
resize_img6(t2,t2cut,vox, [],bb2, [], 1);

[ha a]=rgetnii(t2cut);
try; delete(t2cut);end
%      ha=rmfield(ha,'pinfo');
%      ha=rmfield(ha,'private');
%      rsavenii(t2cut,ha,a);

h.fname        =t2cut;
h.dim(1:3)   = ha.dim(1:3);
h.mat        = ha.mat;
h.dt         =ha.dt;
h.descrip    ='cuttedT2';
h=spm_create_vol(h);
h=spm_write_vol(h,  a);


if isfield(pp,'show');
    if pp.show>0
        if pp.show==1
            rmricron([],t2cut);
        elseif pp.show==2
            rmricron([],t2,t2cut,1);
          elseif pp.show==3
             showinfo2('cutted',t2cut,-1); 
             return
        end
        hx=spm_vol(t2cut);
        disp(['dim: [' num2str(hx.dim)  ']' ]);
        
    end
    
    
end


























































