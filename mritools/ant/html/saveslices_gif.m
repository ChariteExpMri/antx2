




function out=saveslices_gif(s1,s2, flip,outpath,outputstr,par)
tagstr='';
if exist('outputstr')==1
    tagstr=char(outputstr);
end
%% ======== additional parameter =======================================
if exist('par')~=1; par=struct(); end
if isfield(par,'cmapB')==0;       par.cmapB=''  ; end
if isfield(par,'cmapF')==0;       par.cmapF=''  ; end

if ~isempty(par.cmapB) && isempty(par.cmapF);    par.cmapF='parula'; end
if  isempty(par.cmapB) && ~isempty(par.cmapF);   par.cmapB='gray'; end

if isfield(par,'showFusedIMG')==0;       par.showFusedIMG=0  ; end
if isfield(par,'sliceadjust') ==0;       par.sliceadjust=0   ; end
%% ===============================================

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

% ==============================================
%%   atlas-many IDs (Allen)
% ===============================================
if exist('o')==1
    if (max(o(:))-min(o(:)))>1e4  & all(round(unique(o(:)))==(unique(o(:))))==1 %reduze dynamic range (Allen-Atlas)
        
        x=o(:); x2=x;
        uni=unique(x); uni(uni==0)=[];
        for i=1:length(uni)
            x2(  (x==uni(i)))  =i;
        end
        x2=reshape(x2,size(o));
        %montage2(x2);
        o=mat2gray(x2);
    end
end


%=============================================
% sliceadjust=0;
%=============================================

if par.sliceadjust==1
    for i=1:size(d,3)
        d(:,:,i)=imadjust(mat2gray(d(:,:,i)));
    end
    %     if exist('o')==1
    %         if (max(o(:))-min(o(:)))>1e4  & all(round(unique(o(:)))==(unique(o(:))))==1 %reduze dynamic range (Allen-Atlas)
    %
    %             x=o(:); x2=x;
    %             uni=unique(x); uni(uni==0)=[];
    %             for i=1:length(uni)
    %                 x2(  (x==uni(i)))  =i;
    %             end
    %             x2=reshape(x2,size(o));
    %             %montage2(x2);
    %             o=mat2gray(x2);
    %         else
    for i=1:size(d,3)
        o(:,:,i)=imadjust(mat2gray(o(:,:,i)));
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
% if par.sliceadjust==1
%     [d3 cmap1]=gray2ind(d2);
% else
    [d3 cmap1]=gray2ind(imadjust(mat2gray( (d2))));
% end

if exist('o')==1
    o2=montageout(permute(o,[1 2 4 3]));
%     if par.sliceadjust==1
%         [o3 cmap2]=gray2ind(o2);
%     else
        [o3 cmap2]=gray2ind(imadjust(mat2gray( (o2))));
%     end
 end






%    imwrite(d3,cmap1,'test.gif','gif');
%   imwrite(o3,cmap2,'test2.gif','gif');
%
%
%% ===============================================
if 0  %test
    par.cmapB ='bone';
    par.cmapF ='summer';
    
end

%% ===============================================
isColor=0;
if ~isempty(par.cmapB) && ~isempty(par.cmapF)
   isColor=1; 
end
if isColor==1;   % test color
%    d3=repmat(d3,[1 1 3]);
% %    o3=repmat(o3,[1 1 3]);
%    [d3,cmap1] = rgb2ind(d3,gray);
%    B=o3;
cmapB=getCMAP(par.cmapB);
if size(cmapB,1)>52
    cmapB= cmapB(round(linspace(1,size(cmapB,1),52)), :) ;
end
cmapF=getCMAP(par.cmapF);
if size(cmapF,1)>52
    cmapF= cmapF(round(linspace(1,size(cmapF,1),52)), :) ;
end

%     try;      cmapB=lutmap(par.cmapB);
%         if size(cmapB,1)>52
%            cmapB= cmapB(round(linspace(1,size(cmapB,1),52)), :) ;
%         end
%     catch;    cmapB=eval(par.cmapB);
%     end
% 
%     try;      cmapF=lutmap(par.cmapF);
%          if size(cmapF,1)>52
%            cmapF= cmapF(round(linspace(1,size(cmapF,1),52)), :) ;
%         end
%     catch;    
%         cmapF=eval(par.cmapF);
%     end

 
%     if size(cmapB,1)>52
%         cmapB= cmapB(round(linspace(1,size(cmapB,1),52)), :) ;
%     end
%     if size(cmapF,1)>52
%         cmapF= cmapF(round(linspace(1,size(cmapF,1),52)), :) ;
%     end
%     

%    cmapB=eval(par.cmapB);
%    cmapF=eval(par.cmapF);
   
   CB=ind2rgb(d3, cmapB);  [c1,cmap1] = rgb2ind(CB,cmapB);
   %fg,imshow(c1,cmapB);
   
   CF=ind2rgb(o3, cmapF);  [c2,cmap2] = rgb2ind(CF,cmapF);
   %fg,imshow(c2,cmapF);
   
   d3=c1;
   o3=c2;
   
   %fg,imshow(imfuse(d3,o3,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]))

   
  
end
%% ===============================================

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


% par.showFusedIMG=1;
% 'change flag!!'
namefus='';
if par.showFusedIMG==1
    try
        %fg,imshow(imfuse(d3,o3,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]))
        %fus=imfuse(d3,o3,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
        %fus=imfuse(d3,o3);
        fus=imfuse(d3,o3,'blend');
        
        if size(fus,3)==3
            [fus,cmap1] = rgb2ind(fus,255);
        end
        
         if exist('CB') && exist('CF')
            fus=imfuse(CB,CF,'blend');
            if size(fus,3)==3
                [fus,cmap1] = rgb2ind(fus,255);
            end
        else
           fus=imfuse(d3,o3,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]); 
           %fus=imfuse(d3,o3,'blend');
            if size(fus,3)==3
                [fus,cmap1] = rgb2ind(fus,255);
            else
                cmap1=hot;
            end
            
         end
        
        
        %fg,imshow(fus,cmap1);
        namefus   =stradd(name1,'_fus',2);
        gifnamefus=fullfile(outpath,[namefus]);
        imwrite(fus,cmap1,gifnamefus,'gif');
        %showinfo2('',gifnamefus);
     catch   
        namefus='';
    end
    
end
    

out={name1;name2;name3; namefus};



