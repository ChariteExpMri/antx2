
%nsb: number of slices : [],=[nan nan] [nan x] [x nan] [line]..each subject in one line

function warp_summary2(s)

if 0
    study='O:\harms1\harms3_lesionfill\proj_Harms3_lesionfill.m'
    ant,antcb('load',study);
    
    s.file='w_t2.nii';
    s.slice=75;
    warp_summary(s);
    
    cmap2=jet;
    cmap2(1,:)=[0 0 0]
    warp_summary2(struct('sfile','x_t2.nii','slice',100,'cmap',cm,'rfile', 'O:\harms1\harms3_lesionfill\templates\ANOpcol.nii','imswap',0))

    
    warp_summary2(struct('sfile','x_t2.nii','slice',[80 100 140 ],'rfile', 'O:\harms1\harms3_lesionfill\templates\ANOpcol.nii','imswap',1,'nsb',[nan 3],'cut',[0.2 0  0.2 0]))

end

jet2=[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 0.9375;0.125 1 0.875;0.1875 1 0.8125;0.25 1 0.75;0.3125 1 0.6875;0.375 1 0.625;0.4375 1 0.5625;0.5 1 0.5;0.5625 1 0.4375;0.625 1 0.375;0.6875 1 0.3125;0.75 1 0.25;0.8125 1 0.1875;0.875 1 0.125;0.9375 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0;0.5 0 0];
jet2(1,:)=[0 0 0];

if isfield(s,'file');                   file=s.file ;                       else s.file='x_t2.nii' ;            file=s.file ;       end
if isfield(s,'doresize');        doresize=s.doresize ;       else s.doresize=1 ;              doresize=s.doresize ;   end
if isfield(s,'slice');               slice=s.slice ;                      else s.slice=100 ;                slice=s.slice ;   end
if isfield(s,'cmap');              cmap=s.cmap ;                  else s.cmap=jet2 ;                cmap=s.cmap ;   end

if isempty(cmap); s.cmap=jet2;end


fil=antcb('getsubjects');
fis=stradd(fil,[filesep file],2);
temppa=fullfile(fileparts(fileparts(fil{1})),'templates');
% ref=fullfile(temppa,'AVGT.nii'); 
% ref=fullfile(temppa,'ANOpcol.nii'); 

% if isfield(s,'rfile');              ref=s.rfile ;                      else s.rfile=fullfile(temppa,'AVGT.nii');                 ref=s.rfile ;   ;   end
% if isfield(s,'rfile');              ref=s.rfile ;                      else s.rfile=[];                 ref=s.rfile ;   ;   end
if isfield(s,'rfile');              ref=s.rfile ;                      else s.rfile=s.file;                 ref=s.rfile ;   ;   end


if ~isfield(s,'imswap');           s.imswap=0 ;   end %background and overlay image swapped
if ~isfield(s,'nsb');           s.nsb=[] ;   end ;%number of subplots
if ~isfield(s,'cut');           s.cut=[] ;   end ;%number of subplots
if ~isfield(s,'alpha');           s.alpha=0.5 ;   end ;%alphaValue



% [ha a]=rgetnii(ref);
% [hb b]=rgetnii(fis{1});

% doresize=1;
% sliznum=100;
 
% V=spm_vol(ref);
% C=[1 0 0 0; 0 0 1 0; 0 1 1 0; 0 0 0 1];
% C(2,4) = slice;
% DIM = V(1).dim([1 3]);
% rf=rot90(spm_slice_vol(V, C, DIM, 0));
% if doresize==1
%     newsize=repmat(min(size(rf)),[1 2]);
%    rf= imresize(rf, newsize);
% end
% rf=single(repmat(rf,[1 1 size(fis,1)]));

if ischar(s.slice)  %plot every x.th slice
    hd=spm_vol(ref);
    every=str2num(strrep(s.slice,'''',''));
 
   if length(every)==1
          s.slice=[1:every(1):hd.dim(2)]';
   elseif length(every)==2
       s.slice=[every(2):every:hd.dim(2)-every(2)]';
      elseif length(every)==3
       s.slice=[every(2):every:hd.dim(2)-every(3)]';    
   end
end


if exist(s.rfile)==0
    s.rfile=stradd(fil,[filesep s.rfile],2);
    s.refexplicit=0;
    
    exists=zeros(size(fis,1),1);
    for i=1: size(fis,1) %check existence
        if (exist(fis{i})==2)  &&  (exist(s.rfile{i})==2) % (exist(  fullfile(fileparts(fis{i}), s.rfile{i})  )==2)
            exists(i)=1;
        end
    end
  
    if sum(exists)==0
        disp('no files found');
        return
    else
        fis=      fis(exists==1);  
         s.rfile=s.rfile( exists==1);  
    end
        
    
else
      s.refexplicit=1;
end

if s.refexplicit==1
    idxcord=zeros(3,length(s.slice));
    idxcord(2,:)=[s.slice];
    if ischar(s.rfile)
    out=mni2idx(idxcord, spm_vol(s.rfile) , 'idx2mni' );
    else
     out=mni2idx(idxcord, spm_vol(s.rfile{1}) , 'idx2mni' );   
    end
    s.sliceMM=out(:,2);
else
    idxcord=zeros(3,length(s.slice));
    idxcord(2,:)=[s.slice];
    dum=[];
    for i=1:size(s.rfile,1)
       out=mni2idx(idxcord, spm_vol(s.rfile{i}) , 'idx2mni' );
       dum=[dum; out(:,2) ];
    end
    s.sliceMM=dum;
end

if s.refexplicit==1
    rf0=[];
    for islice=1:length(s.slice)
        V=spm_vol(ref);
        C=[1 0 0 0; 0 0 1 0; 0 1 1 0; 0 0 0 1];
        C(2,4) = s.slice(islice);
        DIM = V(1).dim([1 3]);
        rf=rot90(spm_slice_vol(V, C, DIM, 0));
        if doresize==1
            newsize=repmat(min(size(rf)),[1 2]);
            rf= imresize(rf, newsize);
        end
        rf0(:,:,islice)=rf;%single(repmat(rf,[1 1 size(fis,1)]));
        Cmat(:,:,islice)=C;
    end
    rf         =single(repmat(rf0,[1 1 size(fis,1)]));
    Cmat=single(repmat(Cmat,[1 1 size(fis,1)]));
    cord    =single(repmat(s.sliceMM(:),[size(fis,1) 1]));
    sliceID=single(repmat(s.slice(:),[size(fis,1) 1]));
    fis=repmat(fis,[1 length(s.slice)])';
    fis=fis(:);
else
    
    n=1;
    for j=1:size(s.rfile,1)
        V=spm_vol(s.rfile{j});
        for islice=1:length(s.slice)
            C=[1 0 0 0; 0 0 1 0; 0 1 1 0; 0 0 0 1];
            C(2,4) = s.slice(islice);
            DIM = V(1).dim([1 3]);
            rf=rot90(spm_slice_vol(V, C, DIM, 0));
            if doresize==1
                newsize=repmat(min(size(rf)),[1 2]);
                rf= imresize(rf, newsize);
            end
            rf0(:,:,n)=rf;%single(repmat(rf,[1 1 size(fis,1)]));
            Cmat(:,:,n)=C;
            % fis2{n,1}=fis{j};
            % disp(fis{j});
             sliceID(n,1)  =s.slice(islice);
             cord(n,1)     =s.sliceMM(n);
            n=n+1;
        end
        %         rf         =single(repmat(rf0,[1 1 size(fis,1)]));
        %         Cmat=single(repmat(Cmat,[1 1 size(fis,1)]));
        %         cord    =single(repmat(s.sliceMM(:),[size(fis,1) 1]));
        %         sliceID=single(repmat(s.slice(:),[size(fis,1) 1]));    
    end
    fis2=repmat(fis,[1 length(s.slice)])';
    fis=fis2(:);
    rf=rf0;
end


ri=single(zeros(size(rf)));
for i=1:size(fis,1)
    hb=spm_vol(fis{i});
    dd=rot90(spm_slice_vol(hb, double(squeeze(Cmat(:,:,i))), DIM, 0));
    if doresize==1
        dd= imresize(dd, newsize);
    end
    dd=dd-min(dd(:)); dd=dd./max(dd(:)); 
    ri(:,:,i)=dd;
end

%cut percent
if ~isempty(s.cut)
    if length(s.cut)==4
        si=size(ri);
        cut=[round(si(1)*s.cut(2))  round(si(1)*s.cut(1))       round(si(2)*s.cut(3))  round(si(2)*s.cut(4)) ];
        ri=ri(1+cut(1):end-cut(2),1+cut(3):end-cut(4),:);
        rf=rf(1+cut(1):end-cut(2),1+cut(3):end-cut(4),:);
    else
        
    end
end

titlex={};
for i=1:length(fis)
    [paw fiw extw]=fileparts(fis{i});
    [paw2 fiw2]=fileparts(paw);
    if s.refexplicit==1
        [paz fiz extz]=fileparts(s.rfile);
    else
        [paz fiz extz]=fileparts(ref);
    end
     
     ar='';
     if length(s.slice)==1
         ar=[[fiw2 filesep fiw extw '-' fiz extz]];
     else
         if mod(i,length(s.slice))==1;
             ar=[[fiw2 filesep fiw extw '-' fiz extz]];
         else
         end
     end
    titlex{i,1}=ar;
    
end


% rf(rf>0)=1;%just for now
% rf=ceil(rf);

% rf(rf<.1)=0;
% rf(rf>1.1)=2;
% rf(rf~=0 & rf~=2)=1;
%     

add=[];
if isstr(s.nsb)
  if strcmp(s.nsb,'line') %one subject in each line
    add.nsb=[nan length(s.slice)  ]  ;
  end
else
    add.nsb=s.nsb;
end

add.title=titlex;
add.cord=[sliceID cord ];
if s.imswap==0
    imoverlay2(rf,ri,[],[],s.cmap,s.alpha,'',add);; 
else
     imoverlay2(ri,rf,[],[],s.cmap,s.alpha,'',add);; 
end
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




function res=mni2idx(cords, hdr, mode )
% convert cords from [idx to mni] or  [mni to idx]
% cords must be [3xX]
% ===========================
% convert idx2mni
% res=mni2idx( orig.x.XYZ(:,1:10000) , orig.x.hdr, 'idx2mni' );
% sum(sum(orig.x.XYZmm(:,1:10000)-res'))
% % convert mni2idx
% res=mni2idx( orig.x.XYZmm(:,1:10000) , orig.x.hdr, 'mni2idx' );
% test: sum(sum(orig.x.XYZ(:,1:10000)-res'))

% hdr   =orig.x.hdr;
% xyz   =orig.x.XYZ;
% xyzmm =orig.x.XYZmm;


hb=hdr.mat;

%% idx2mni
if strcmp(mode,'idx2mni')

    q=cords;
    %q=xyz(:,i);
    Q =[q ; ones(1,size(q,2))];
    Q2=Q'*hb';
    Q2=Q2(:,1:3);
    
    res=Q2;
%     n=xyzmm(:,i)'
%     Q2-n

elseif strcmp(mode,'mni2idx')

%% mni2idx
si=size(cords);
if si(1)==1
    cords=cords';
end
    Q2=cords';
    %Q2= xyzmm(:,i)';
    Q2=[Q2   ones(size(Q2,1),1)] ;
    Q =hb\Q2';
    Q=Q(1:3,:)';

%     f=xyz(:,i)'
%     Q-f
    res=Q;
else
    error('use idx2mni or mni2idx');
end


%
%
%
% orig.x.XYZ
% orig.x.XYZmm
% orig.x.hdr
%
%
% m=orig.x.hdr.mat
% hb=m
% s_x=hb(1,:);%hb.hdr.hist.srow_x;
% s_y=hb(2,:);%hb.hdr.hist.srow_y;
% s_z=hb(3,:);%hb.hdr.hist.srow_z;
%
% for j=1:10000
%     i=j
%     q=orig.x.XYZ(:,i);
%     n=orig.x.XYZmm(:,i);
%
%
%     % s_x(find(s_x(1:3)==0))=1;
%     % s_y(find(s_y(1:3)==0))=1;
%     % s_z(find(s_z(1:3)==0))=1;
%
%
%     ff=q';
%
%     nc(:,1) = s_x(1).* ff(:,1)  +   s_x(2).* ff(:,2)  +   s_x(3).* ff(:,3)  +   s_x(4);
%     nc(:,2) = s_y(1).* ff(:,1)  +   s_y(2).* ff(:,2)  +   s_y(3).* ff(:,3)  +   s_y(4);
%     nc(:,3) = s_z(1).* ff(:,1)  +   s_z(2).* ff(:,2)  +   s_z(3).* ff(:,3)  +   s_z(4);
%
%     q(:)'
%     n(:)'
%     nc(:)'
%
%     nn(j,:)=nc;
% end
%
% % sum(sum(abs(nn-Q2)))
%
% %% idx2mni
% i=1:5
%
% q=orig.x.XYZ(:,i)
% Q =[q ; ones(1,size(q,2))];
% Q2=Q'*hb';
% Q2=Q2(:,1:3)
% n=orig.x.XYZmm(:,i)'
%
% Q2-n
%
% %% mni2idx
% Q2= orig.x.XYZmm(:,i)';
% Q2=[Q2   ones(size(Q2,1),1)] ;
% Q =hb\Q2';
% Q=Q(1:3,:)'
%
% f=orig.x.XYZ(:,i)'
%
% Q-f
%







