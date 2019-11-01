
function bla


% aa='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\_Atpl_mouseatlasNew_left.nii'
% bb='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\elx_T2_left-0.nii'
bb='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\_Atpl_mouseatlasNew.nii'
% bb='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\hx_T2.nii'
%  aa='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\elx_T2-0.nii'
aa='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\hx_T2.nii'

[haa a]=rgetnii(aa);
[hbb b]=rgetnii(bb);
[pas f1 ext]=fileparts(aa);
[pas f2 ext]=fileparts(bb);

a=a-min(a(:));   a=a./max(a(:));
b=b-min(b(:));   b=b./max(b(:));


siz=size(a);

% fg,imagesc(nanmean(cat(3,a1.*c1,b1.*c2),3))
% fg,imagesc(nanmean(cat(3,imadjust(a1).*c1,imadjust(b1).*c2),3))

dim=2
 slices=[ 60 100 120 150]
 slices=[50:5:200]
  slices=[ 40:5:80]
  slices=('5')
   slices=('12 10'); %first is stepsize ,2nd is start/stop 
 ncontours=4;
  rot=1;
 flipd=1;
 crop=[0 0 0 0]  ;%unten oben links rechts
%  crop=[ 0.3 0 0.1 0.1  ]  ;%unten oben links rechts
 crop=[  0.15 0  0.05 0.05  ]  ;%unten oben links rechts
 crop=[  0 0   0.05 0.3  ]
 %MNI
%  slices=1:siz(dim)

 
 
 if dim==1
     a=permute(a,[2 3 1]);
     b=permute(b,[2 3 1]);
 elseif dim==2
      a=permute(a,[1 3 2]);
     b=permute(b,[1 3 2]);
 end
 if ischar(slices)
     if length(str2num(slices))==1
     slices=1:str2num(slices):size(a,3)
     slices(find(slices==1))=[];
     else
        dum=str2num(slices)
         slices=dum(2):dum(1):size(a,3)-dum(2)
     end
 end
 
  co=zeros(length(slices),3); co(:,dim)=slices;
 mm=mni2idx( co' , haa, 'idx2mni' );
 mm=mm(:,dim);
 
 
 nb=length(slices);
[p,n]=numSubplots(nb);
 
figure;
 set(gcf,'color','k','units','normalized');
 ha = tight_subplot(p(1),p(2),[0 0],[0 .025],[.01 .01]);
  set(ha,'color','k'); 
for i=1:length(slices)
     axes(ha(i));
     
     nn=slices(i);
    a1=(squeeze(a(:,:,nn)));
    b1=(squeeze(b(:,:,nn)));
    a1=a1-min(a1(:));   a1=a1./max(a1(:));
    b1=b1-min(b1(:));   b1=b1./max(b1(:));
    
    if rot==1;          a1=a1'; b1=b1';     end
    if flipd==1;    a1=flipud(a1); b1=flipud(b1);end
    
%     if ~isempty(crop)

        si=size(a1);
        bord1=[ round(si(1)*crop(2))+1    si(1)-round(si(1)*crop(1)) ];
        bord2=[           round(si(2)*crop(3))+1   si(2)-round(si(2)*crop(4))         ];
            bord=[bord1;bord2];
            a1=a1(bord(1,1):bord(1,2),bord(2,1):bord(2,2));
            b1=b1(bord(1,1):bord(1,2),bord(2,1):bord(2,2));
%      dd=   a1(bord(1,1):bord(1,2),bord(2,1):bord(2,2))
%      fg,subplot(2,2,1);imagesc(a1);subplot(2,2,2);imagesc(dd)
     
%     end
   a1=imadjust(a1);
   b1=imadjust(b1); 
   image(cat(3,a1,a1,a1)); hold on;
   contour(b1,ncontours,'linewidth',1.5,'linestyle',':');
   

   
   te=text(0,1,['' num2str(slices(i))  '\color[rgb]{0.7569    0.8667    0.7765}'   sprintf(' [%2.2f]',mm(i))],...
       'tag','txt','color','r','units','normalized',...
       'fontunits','normalized','fontsize',.05,'fontweight','bold','verticalalignment','top');

   
   
axis off;
end

ptitle([f1 ' - ' f2]);

set(gcf,'color','k','InvertHardcopy','off');
if 0
print(gcf,'-djpeg','-r300',fullfile(pwd,'test3.jpg'));
end



function [p,n]=numSubplots(n)    
while isprime(n) & n>4, 
    n=n+1;
end

p=factor(n);

if length(p)==1
    p=[1,p];
    return
end


while length(p)>2
    if length(p)>=4
        p(1)=p(1)*p(end-1);
        p(2)=p(2)*p(end);
        p(end-1:end)=[];
    else
        p(1)=p(1)*p(2);
        p(2)=[];
    end    
    p=sort(p);
end


%Reformat if the column/row ratio is too large: we want a roughly
%square design 
while p(2)/p(1)>2.5
    N=n+1;
    [p,n]=numSubplots(N); %Recursive!
end


function ptitle(tex,varargin)

% tex='abssdffdde'
ha=axes('position',[0 0 1 1],'color','none',...
      'visible','off','HitTest','off','tag','subtitle');  
  te=text(0,1,tex,...
      'tag','txt2','color','w','units','normalized',...
      'fontunits','normalized','fontsize',.02,'fontweight','bold','verticalalignment','top',...
      'horizontalalignment','left');
  set(te,'interpreter','none');

   
% h=text(.5,.97,tex,'horizontalalignment','center','fontsize',20,'tag','txt2');
% uistack(ha,'bottom');
%  set(ha,'visible','off','HitTest','off','tag','subtitle') 
if ~isempty(varargin)
    set(h,varargin{:})  ;
end






