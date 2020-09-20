
% function to segment brains
%previous script:  paul_watershed_test2.m
% fi=file
% imextmin: scalar for Extended-minima transform, use e.g. 4
%  expectclass num of expected class
% sortmode: resort in order (0,1)
% showit: show : 0,1,2,3

% v=fsegbrains2(fi, imextmin,expectclass,sortmode, showit)

function v=fsegtube(fi,volnum, imextmin,expectclass,sortmode, showit)

% clc
%
% if 0
%     px='\\tsclient\I\AG_Wu\studyLo\dat'
%
%     [files,dirs] = spm_select('FPListRec',px,'Network.*.nii');
%     files=cellstr(files)
%
%
% end
% if 0
%     % clear
%     cf
%     fi=files{2}
% end
%===================================================
%% USE FILE
% fi=dx;
%===================================================
v=[];

hh=spm_vol(fi);
dim4=size(hh,1);
% if dim4==1;disp('3d-vol');return; end

% tic
% [ha a]=rgetnii('Network-DTI_SE_3D_30dir_5_1.nii');
% [ha a]=rgetnii(fi);
a=spm_read_vols(hh(volnum));
% toc



a2=a(:,:,:,volnum);
si=size(a2);
% o=reshape(otsu(a2(:),2),[si]);

% ==============================================
%%   estimate classes
% ===============================================

if strcmp(expectclass,'auto')
    
    warning off;
    r=reshape(otsu(a2(:),2),[si]);
    % r(r==1)=nan;
    % montage2(r)
    
    
    
    downscalingfactor   =0.1;
    findnumclassesplot  =0;
    
    dimr=[1 2; 1 3 ; 2 3];
    numclassesall=[];
    
    if findnumclassesplot==1
        fg;
    end
    for i=1:3
        dime=dimr(i,:);
        
        
        r2=squeeze(nanmean(nanmean(r,dime(1)),dime(2)));
        vlen=length(r2);
        sc=round(vlen.*downscalingfactor);
        r22=imresize(r2,[1 sc]);
        treshy=mean(r2);
        [ip it]=findpeaks(r22,'minpeakheight', treshy);
        xvec=1:length(r22);
        rp=zeros(size(r22)); rp(it)=1;
        
        rp2=zeros(size(r2));
        it2=round(it*(vlen./sc));
        
        r33=imresize(r22,[1 vlen]);
        if findnumclassesplot==1
            subplot(2,2,i);
            plot(r2); hold on;
            plot(r33,'k','linewidth',2); hold on;
            hline([treshy treshy],'r');
            plot(it2, r2(it2),'om','markerfacecolor','m' );
            ti=title([ 'dim' num2str(setdiff([1:3],dime))   '; nvox: ' num2str(vlen)  '; nclasses: ' num2str(length(it2)) ]);
            set(ti,'fontsize',8);
        end
        numclassesall(1,i)=length(it2);
        
    end
    numclasses=max(numclassesall);
    disp(['number of classes: ' num2str(numclasses)]);
    expectclass=numclasses;
end

% fg,plot(squeeze(nanmean(nanmean(r,1),3)))

% ==============================================
%%
% ===============================================


expectclass_orig=expectclass;

o=reshape(otsu(a2(:),10),[si]);


% 3d
bw=double(squeeze(o(:,:,:))>1);
% montage2(bw);

% bw2 = ~bwareaopen(~bw, 10);
% ;montage2(bw2)

D = -bwdist(~bw);
% montage2(D)


Ld = watershed(D);
% montage2(Ld)

bw2 = bw;
bw2(Ld == 0) = 0;
% montage2(bw2)

%%====================================================
%% RUN
do=1;
irun=1;
pstep=1;
% pstart=2;
imextmin2=imextmin;
alt_max   =1  ;% max number of alterations between two "imextmin"-states
alt_count =0  ;%counter for alterations
alt_list0=[inf inf inf];
alt_list=alt_list0;
alt_listlast=[];
addmember='';
allowOversegmentation =1; % increaseSegments to potentially find the correct animals
supervised            =1; %supervised [0,1]: user checks segmentation visllay

while do==1
    
    mask = imextendedmin(D,imextmin2);
    
    % montage2(mask)
    % fg;imshowpair(bw,mask,'blend')
    
    D2 = imimposemin(D,mask);
    Ld2 = watershed(D2);
    bw3 = bw;
    bw3(Ld2 == 0) = 0;
    % montage2(bw3)
    % montage2(Ld2)
    %     fg,imshowpair( montageout(permute(Ld2,[1 2 4 3])) ,montageout(permute(a2,[1 2 4 3]))  )
    
    m=double(Ld2);
    uni=unique(m);
    uni(uni==0)=[];
    nn=histc(m(:),[uni]);
    tb=[uni nn round(nn./max(nn)*100)];
    disp([ 'it-' num2str(irun) '; Expected ' num2str(expectclass_orig) '+'   num2str(expectclass-expectclass_orig)...
        '; observec ' num2str(size(tb,1))  ...
        '; imextmin' num2str(imextmin2) '; altCount' num2str(alt_count)]);
    %     disp(alt_list);
    
    
    
    
    
    
    if size(tb,1)~=expectclass
        if size(tb,1)>expectclass           % MORE segments found than assumed
         
              if allowOversegmentation ==1
                  
              else
                   imextmin2=imextmin2+pstep;  
              end

        else                                % LESS segments found than assumed
            if allowOversegmentation ==1
                 
            else
                imextmin2=imextmin2-pstep;
                if imextmin2<0;
                    do=0;
                end
            end
        end
    else % classes met
        do=0;
    end
    
    if allowOversegmentation ==1
        if expectclass_orig==size(tb,1)
            showui
        end
    end
    
    %     if min(tb(:,3))>80
    %        do=0 ;
    %     end
    irun=irun+1;
    %pstart=pstart+pstep;
    
%     if supervised==1 && do==0
     if 1%showui==1;
        % ==============================================
        %%
        % ===============================================
        
        delete(findobj(gcf,'tag','checkSegment'));
        try
        imoverlay(montageout(permute(a2,[1 2 4 3])),montageout(permute(m,[1 2 4 3])));
        catch
        imoverlay(montageout(permute(a2,[1 2 4 3]) ),  montageout(permute(a2,[1 2 4 3]) ) )
            
        end
        axis off; set(gcf,'units','norm');
        set(gcf,'tag','checkSegment');
        hb=uicontrol('style','pushbutton','units','norm','position',[ 0.2 0.01 .1 .05],'string','ok');
        set(hb,'position',[ 0.2 0.01 .1 .05])
        set(hb,'tooltipstring','This animal-segmentation is ok, I can work with that.');
        set(hb,'callback', 'set(gcf,''userdata'',''ok''); uiresume(gcf);' );
        
        hb=uicontrol('style','pushbutton','units','norm','string','oversegment');
        set(hb,'position',[ 0.3 0.01 .2 .05])
        set(hb,'tooltipstring','This animal-segmentation is not ok.');
        set(hb,'callback', 'set(gcf,''userdata'',''1''); uiresume(gcf);' );
       
        
         hb=uicontrol('style','pushbutton','units','norm','string','decrease imextmin2');
        set(hb,'position',[ 0.5 0.01 .2 .05])
        set(hb,'tooltipstring','This animal-segmentation is not ok.');
        set(hb,'callback', 'set(gcf,''userdata'',''2''); uiresume(gcf);' );
         
        
        hb=uicontrol('style','pushbutton','units','norm','string','increase imextmin2');
        set(hb,'position',[ 0.7 0.01 .2 .05])
        set(hb,'tooltipstring','This animal-segmentation is not ok.');
        set(hb,'callback', 'set(gcf,''userdata'',''3''); uiresume(gcf);' );
        
        title(['Check Segmentation nsegments=' num2str(length(tb))]);
        
        
        uiwait(gcf);
        msg=get(gcf,'userdata');
        close(gcf);
        
        if strcmp(msg,'ok')
            do=0;
            
        elseif strcmp(msg,'1')
            do=1;
            expectclass=expectclass+1;
        elseif strcmp(msg,'2')
            do=1;
            imextmin2=2;
        elseif strcmp(msg,'3')
            do=1;
            imextmin2=imextmin2+1;
        end
            
    end
        
        % ==============================================
        %%
        % ===============================================
        %% forward-backwards ALTERATIONS ---------------
%         if allowOversegmentation==1 && do==1
%             alt_list=[alt_list(2:end) imextmin2]; %update alt_list
%             if alt_list(1)==alt_list(3)
%                 alt_count=alt_count+1;
%             end
%             
%             if alt_count>alt_max % If number of forward-backwards ALTERATIONS reached...
%                 expectclass = expectclass+1; %add a new classcount
%                 alt_listlast =alt_list;
%                 alt_list    = alt_list0;
%                 imextmin2   = imextmin;
%             end
%         end
        %%  ---------------
    
    
    
end

classes=unique(Ld2); classes(classes==0)=[];

% ==============================================
%%   oversegmentation...now get the right segments
% ===============================================
if allowOversegmentation==1
    
    'a'
    
end



%% out========================================================

v.classes  =classes(:)';
v.nclasses =length(classes);
v.file     =fi;
v.mask     =Ld2;
v.dat      =a2;

v.mask2d  = montageout(permute(Ld2,[1 2 4 3])) ;
v.dat2d   = montageout(permute(a2,[1 2 4 3]))  ;


%% sortmode
if sortmode==1
    
    rs=(median((median(v.mask,1)),3));
    uni=unique(rs);
    tc=[];
    for i=1:length(uni)
        ix= find(rs==uni(i));
        tc(end+1,:)=[uni(i)  mean(ix) ];
    end
    % sort in reverse order  larger number first, smallest number latest
    tc2=  flipud(sortrows(tc,2));
    tc2=[tc2 [[1:size(tc2)]'+100 [1:size(tc2)]']]; %oldIDX meancenterImage tempIXD newIDX
    
    w=Ld2;
    for i=1:size(tc2,1)
        w(w==tc2(i,1))=tc2(i,3); %TEMPIDX
    end
    for i=1:size(tc2,1)
        w(w==tc2(i,3))=tc2(i,4); %NEWIDX
    end
    
    v.mask=w;
    v.mask2d  = montageout(permute(w,[1 2 4 3])) ;
    
end

%%


if showit==2
    [ps fis es]=fileparts(fi);
    [~ ,ps]=fileparts(ps);
    finame=[fis es];
    fg;
    subplot(2,2,1); imagesc(v.dat2d );  title({ ps; finame},'fontsize',7,'interpreter', 'none');
    subplot(2,2,2); imagesc(v.mask2d ); colorbar
    subplot(2,2,3); imshowpair(v.dat2d,v.mask2d );  title(['nclasses: '  num2str(v.nclasses )]);
elseif showit==3
    fg;
    imshowpair( montageout(permute(Ld2,[1 2 4 3])) ,montageout(permute(a2,[1 2 4 3]))  );
    title(['classes: ' num2str(length(classes))]);
end


if showit==1
    
    [ps fis es]=fileparts(fi);
    [~ ,ps]=fileparts(ps);
    finame=[fis es];
    fg;
    hold on
    subplot(1,1,1);
    imshowpair(v.dat2d,v.mask2d );  title(['nclasses: '  num2str(v.nclasses )]);
    lg={};
    lg(end+1,1)={[ps   '  #  ' finame  ['       #observed/expected objects : '   num2str(v.nclasses )  ' /' num2str(expectclass )  ]  ]};
    %  lg(end+1,1)={['classes found/expected: '   num2str(v.nclasses )  ' /' num2str(expectclass )  ]};
    ti=title(lg,'fontsize',8,'interpreter','none');
    hold on
    
    ha= axes('Position',[0.01 0.01 .2 .2]);
    imagesc(ha,v.mask2d ); colorbar
    title('mask')
    %  set(ha,'position',[0.01 0.01 .2 .2])
    axis off;
    
end






















if 0
    % https://blogs.mathworks.com/steve/2013/11/19/watershed-transform-question-from-tech-support/
    
    [ha a]=rgetnii('Network-DTI_SE_3D_30dir_5_1.nii');
    
    
    a2=a(:,:,:,1);
    
    si=size(a2)
    
    o=reshape(otsu(a2(:),2),[si]);
    
    
    bw=double(squeeze(o(:,:,40))>1)
    
    bw2 = ~bwareaopen(~bw, 10);
    fg;imagesc(bw2)
    
    D = -bwdist(~bw);
    fg,imshow(D,[])
    
    
    Ld = watershed(D);
    fg,imshow(label2rgb(Ld))
    
    bw2 = bw;
    bw2(Ld == 0) = 0;
    fg,imshow(bw2)
    
    
    mask = imextendedmin(D,10);
    fg;imshowpair(bw,mask,'blend')
    
    
    D2 = imimposemin(D,mask);
    Ld2 = watershed(D2);
    bw3 = bw;
    bw3(Ld2 == 0) = 0;
    fg,imshow(bw3)
    
    %%=====================================
    % 3d
    bw=double(squeeze(o(:,:,:))>1);
    montage2(bw);
    
    bw2 = ~bwareaopen(~bw, 10);
    ;montage2(bw2)
    
    D = -bwdist(~bw);
    montage2(D)
    
    
    Ld = watershed(D);
    montage2(Ld)
    
    bw2 = bw;
    bw2(Ld == 0) = 0;
    montage2(bw2)
    
    
    mask = imextendedmin(D,10);
    montage2(mask)
    % fg;imshowpair(bw,mask,'blend')
    
    
    D2 = imimposemin(D,mask);
    Ld2 = watershed(D2);
    bw3 = bw;
    bw3(Ld2 == 0) = 0;
    montage2(bw3)
    
    
    
    
    
    
    
    
    
    
    
    %%%  end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    D = bwdist(~bw);
    D = -D;
    D(~bw) = Inf;
    
    L = watershed(D);
    L(~bw) = 0;
    
    rgb = label2rgb(L,'jet',[.5 .5 .5]);
    figure
    imshow(rgb,'InitialMagnification','fit')
    title('Watershed transform of D')
    
    % =================================================
    %% bla
    
    d=mat2gray(a2(:,:,40));
    
    im=bw;
    
    imb=~bwdist(~im);
    
    sigma=3;
    kernel = fspecial('gaussian',4*sigma+1,sigma);
    im2=imfilter(imb,kernel,'symmetric');
    fg,imagesc(im2)
    
    L = watershed(max(im2(:))-im2);
    [x,y]=find(L==0);
    
    lblImg = bwlabel(L&~im);
    
    figure,imshow(label2rgb(lblImg,'jet','k','shuffle'));
    
end