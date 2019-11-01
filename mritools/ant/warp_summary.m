
% imswap==1: than rfile is on top

function warp_summary(s)

if 0
    s.file='w_t2.nii';
    s.slice=75;
    warp_summary(s);
    warp_summary(struct('sfile','x_t2.nii','slice',100))

end

jet=[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 0.9375;0.125 1 0.875;0.1875 1 0.8125;0.25 1 0.75;0.3125 1 0.6875;0.375 1 0.625;0.4375 1 0.5625;0.5 1 0.5;0.5625 1 0.4375;0.625 1 0.375;0.6875 1 0.3125;0.75 1 0.25;0.8125 1 0.1875;0.875 1 0.125;0.9375 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0;0.5 0 0];
jet(1,:)=[0 0 0];

if isfield(s,'file');                   file=s.file ;                       else s.file='x_t2.nii' ;            file=s.file ;       end
if isfield(s,'doresize');        doresize=s.doresize ;       else s.doresize=1 ;              doresize=s.doresize ;   end
if isfield(s,'slice');               slice=s.slice ;                      else s.slice=100 ;                slice=s.slice ;   end
if isfield(s,'cmap');              cmap=s.cmap ;                      else s.cmap=jet ;                cmap=s.cmap ;   ;   end



fil=antcb('getsubjects');
fis=stradd(fil,[filesep file],2);
temppa=fullfile(fileparts(fileparts(fil{1})),'templates');

if isfield(s,'ref');              ref=[] ;
    if isempty(ref)
       ref= fis{1};
       V=spm_vol(ref);
    end
else  ;              
    ref=fullfile(temppa,'AVGT.nii');
    V=spm_vol(ref);
    
end
 
% ref=fullfile(temppa,'ANOpcol.nii'); 
% [ha a]=rgetnii(ref);
% [hb b]=rgetnii(fis{1});

% doresize=1;
% sliznum=100;
 
% V=spm_vol(ref);
C=[1 0 0 0; 0 0 1 0; 0 1 1 0; 0 0 0 1];
C(2,4) = slice;
DIM = V(1).dim([1 3]);
rf=rot90(spm_slice_vol(V, C, DIM, 0));
if doresize==1
    newsize=repmat(min(size(rf)),[1 2]);
   rf= imresize(rf, newsize);
end
rf=single(repmat(rf,[1 1 size(fis,1)]));



ri=single(zeros(size(rf)));
for i=1:size(fis,1)
    hb=spm_vol(fis{i});
    dd=rot90(spm_slice_vol(hb, C, DIM, 0));
    if doresize==1
        dd= imresize(dd, newsize);
    end
    dd=dd-min(dd(:)); dd=dd./max(dd(:)); 
    ri(:,:,i)=dd;
end

add.title=replacefilepath(fil,'');
imoverlay2(rf,ri,[],[],cmap,[.5],'',add);; 
% grid minor; set(gca,'xcolor','r','ycolor','r'); axis image;


us=get(gcf,'userdata');
us.add=s;
set(gcf,'userdata',us);

try;
    set(gcf,'name',[  'slice' num2str(s.slice) '  type<h>for shortcuts']);
end

% 
% V=ha
% C = [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1]
% C=[1 0 0 0; 0 0 1 0; 0 1 1 0; 0 0 0 1]
% %C=[0 -1 0 0 ; 0 0 1 0 ; 1 0 0 0; 0 0 0 1]
% 
%     DIM = V(1).dim([1 3]);
%     C(2,4) = 75
%     %C(3,4)=-p;
% 
%     % img = rot90(spm_slice_vol(V,C,DIM,0));
%     % img = spm_slice_vol(V,inv(C),DIM,0);
%     w=[]
%     for i=1:length(V)
%         w(:,:,i) = spm_slice_vol(V(i), C, DIM, 0);
%         'a'
%     end
% w = squeeze(w);
% figure(10)
% imagesc(w)