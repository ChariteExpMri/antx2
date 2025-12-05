




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
nimg=2;
d=s1{1}; ds=s1{2};
if isempty(s2{1})==1
     nimg=1;
else
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
    if nimg==2
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
if nimg==2
    o=flipup(o);
    mxval2=max(o(:));
end

mxval1=max(d(:));
percdown=.1;

for i=1:size(d,3)
    tx=text2im(sprintf('%2.2f',ds.smm(i)));
    tx=imresize(tx,[round(size(d,1)*percdown) nan],'nearest');
    tx1=(~tx).*mxval1;
    
    d(2:size(tx,1)+1,1:size(tx,2),i)=tx1;
    if nimg==2
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

if nimg==2
    o2=montageout(permute(o,[1 2 4 3]));
    [o3 cmap2]=gray2ind(imadjust(mat2gray( (o2))));    
end

%% ===============================================
isColor=0;
if ~isempty(par.cmapB) && ~isempty(par.cmapF)
    isColor=1;
end
if isColor==1;   % test color
    cmapB=getCMAP(par.cmapB);
    if size(cmapB,1)>52
        cmapB= cmapB(round(linspace(1,size(cmapB,1),52)), :) ;
    end
    cmapF=getCMAP(par.cmapF);
    if size(cmapF,1)>52
        cmapF= cmapF(round(linspace(1,size(cmapF,1),52)), :) ;
    end
  
    CB=ind2rgb(d3, cmapB);  [c1,cmap1] = rgb2ind(CB,cmapB);
    d3=c1;
    %imshow(c1,cmapB);
    
    if nimg==2
        CF=ind2rgb(o3, cmapF);  [c2,cmap2] = rgb2ind(CF,cmapF);
        %fg,imshow(c2,cmapF);
        if length(unique(o3))<=2 && size(unique(cmap2,'rows'),1)==1  % mask and isocolorMap
            o4=(o3./max(o3(:))).*size(cmap2,1);
            othercol=[1 1 1];
            CF=ind2rgb(o4, [othercol; cmapF]);
            [c2,cmap2] = rgb2ind(CF,cmapF);
            [c2,cmap2] = rgb2ind(CF,[othercol; cmapF]);
            %      fg,imagesc(c2)
        end
        o3=c2;
    end    
end
%% ===============================================
%% animated giv
%% ===============================================
if nimg==2
    [~,name]=fileparts(os.V.fname);
    name3=[tagstr name '_animated.gif'];
    gifname=fullfile(outpath,[name3]);
    imwrite(d3,cmap1,gifname,'gif', 'Loopcount',inf,'DelayTime',.5);
    imwrite(o3,cmap2,gifname,'gif','WriteMode','append','DelayTime',.5);
else
    name3='';
end
% ==============================================
%%   single images
% ===============================================
[~,name1]=fileparts(ds.V.fname);
name1=[tagstr name1 '.gif'];
gifname1=fullfile(outpath,[name1]);
imwrite(d3,cmap1,gifname1,'gif');
% showinfo2('',gifname1);


if nimg==2
    [~,name2]=fileparts(os.V.fname);
    name2=[tagstr name2 '.gif'];
    gifname2=fullfile(outpath,[name2]);
    imwrite(o3,cmap2,gifname2,'gif');
else
    name2='';
end

% ==============================================
%%   fuse image
% ===============================================

% par.showFusedIMG=1;
% 'change flag!!'
namefus='';
if par.showFusedIMG==1 && nimg==2
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
            
            %% ===============================================
            
            
            % Read two RGB images
            A =CB; %im2double(imread('image1.png'));   % RGB
            B =CF; % im2double(imread('image2.png'));   % RGB
            if 0
            % Create transparency mask (example: circular region)
            [H,W,~] = size(A);
            [X,Y] = meshgrid(1:W, 1:H);
            cx = W/2; cy = H/2; r = min([W,H])/4;
            alpha = double((X-cx).^2 + (Y-cy).^2 < r^2);  % 1 inside circle, 0 outside
            
            %% ===============================================
            
                alpha=ones(size(o3)).*0.5;
                %if length(unique(o3))==2
                %            if mode([[o3([1],:)] [o3([end],:)] [o3(:,[1])'] [o3(:,[end])'] ])==0
                %                alpha=ones(size(o3));
                %                alpha(o3==0)=0.5;
                %                alpha(o3~=0)=0.2;
                %            end
                
                
                % Smooth edges (optional)
                %alpha = imgaussfilt(alpha, 10);
                alpha3 = repmat(alpha, [1 1 3]);%Expand alpha to 3 channels
                F = alpha3 .* A + (1 - alpha3) .* B; % Fuse
                % figure;  imshow(F);        % Show result
                [fus, cmap1] = rgb2ind(F, 256);
                
                %                      namefus   =stradd(name1,'_fus',2);
                %                      gifnamefus=fullfile(outpath,[namefus]);
                %                      imwrite(fus,cmap1,gifnamefus,'gif');
                %                      showinfo2('',gifnamefus);
                %
            end
            %% ===============================================
            alpha=0.5;
            mask3=(o2~=0);
            mask3 = repmat(mask3, [1 1 3]);
            F = A;                                           % start with background
            F(mask3 > 0) =alpha * B(mask3 > 0) + (1-alpha) * A(mask3 > 0);
            [fus, cmap1] = rgb2ind(F, 256);
            
            
            %                      namefus   =stradd(name1,'_fus',2);
            %                      gifnamefus=fullfile(outpath,[namefus]);
            %                      imwrite(fus,cmap1,gifnamefus,'gif');
            %                      showinfo2('',gifnamefus);
            %% ===============================================
            
            
            
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
if nimg==1
    name2=''; name3='';
end

out={name1;name2;name3; namefus};



