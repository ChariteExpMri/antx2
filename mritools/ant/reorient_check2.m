
%% SHOW REORIANTATION PANEL
%  [syntax chk]=reorient_check2( a,b, varargin)
%     a: 3d-vol
%     b: 3d vol
%     varargin: pairwise inputs
%       ovltype: either 'mask' or 'image'; 'image' uses the middle slice in each dimension
%                                        ; 'mask' uses the thresholded image and uses the slice with the maxNumber of voxels for each dimension
%———————————————————————————————————————————————
%%   reorient_check
%———————————————————————————————————————————————
%% allen space image & mask,  
%     [ha c]=rgetnii('x_t2.nii');
%     [hb d]=rgetnii('x_masklesion.nii');
%     d2=flipdim(permute(d,[3 1 2]),1);
%     [syn id]=reorient_check2( c,d2);
% 
%% native space image & mask, 2 equal dimensions in each image
%     [ha c]=rgetnii('t2.nii');
%     [hb d]=rgetnii('masklesion.nii');
%     d2=flipdim(flipdim(permute(d,[3 1 2]),1),3);
%     [syn id]=reorient_check2( c,d2);
% 
%% native space image & image, 2 equal dimensions in each image
%     [ha c]=rgetnii('t2.nii');
%     [hb d]=rgetnii('_bestrot.nii');
%     d2=flipdim(flipdim(permute(d,[3 1 2]),1),3);
%     [syn id]=reorient_check2( c,d2);
% 
%% ovrlay is image (not a mask)--> use middle slize ---------------
% [ha c]=rgetnii('AVGT.nii');
% [hb d]=rgetnii('x_t2.nii');
% d2=flipdim(flipdim(permute(d,[3 1 2]),1),3);
% [syn id]=reorient_check2( c,d2,'ovltype','image'); %using image instead of mask as overlay


function [syntax chk]=reorient_check2( a,b, varargin)

if 0
    
    
end

%———————————————————————————————————————————————
%%   inputs
%———————————————————————————————————————————————
par=struct();

if ~isempty(varargin)
    par=cell2struct(varargin(2:2:end),varargin(1:2:end),2)
end
if isfield(par,'ovltype')==0
    par.ovltype='mask';  %{mask or image}
end

if isfield(par,'fliplist')==0
    par.fliplist  =...
        { ['##;']%{list of manipulations}
        ['flipdim(##,1);']
        ['flipdim(##,2);']
        ['flipdim(##,3);']
        
        ['flipdim(flipdim(##,1),2);']
        ['flipdim(flipdim(##,1),3);']
        ['flipdim(flipdim(##,2),3);']
        ['flipdim(flipdim(flipdim(##,1),2),3);']
        };
end

%———————————————————————————————————————————————
%%   get possible dimension-permutations
%———————————————————————————————————————————————
si1=size(a);
si2=size(b);

nk=unique(allcomb([1 2 3],[1 2 3],[1 2 3]),'rows');
idel=find(nk(:,1)==nk(:,2) | nk(:,1)==nk(:,3) | nk(:,2)==nk(:,3));
nk(idel,:)=[];

ivalid=[];
for i=1:size(nk,1)
    if all(si1==si2(nk(i,:))) %% case: dimensions matches
        ivalid(end+1,1)=i;
    end
end
nk=nk(ivalid,:);


%———————————————————————————————————————————————
%%   get slice for each permututed dimension
%———————————————————————————————————————————————

ww={};
ff={};
for i=1:size(nk,1)
    st=[ 'permute(g,[' num2str(nk(i,:)) '])'];
    
%     f1={ ['g2=##;']
%         ['g2=flipdim(##,1);']
%         ['g2=flipdim(##,2);']
%         ['g2=flipdim(##,3);']
%         
%         ['g2=flipdim(flipdim(##,1),2);']
%         ['g2=flipdim(flipdim(##,1),3);']
%         ['g2=flipdim(flipdim(##,2),3);']
%         ['g2=flipdim(flipdim(flipdim(##,1),2),3);']
%         };
% 
%     f1={ ['##;']
%         ['flipdim(##,1);']
%         ['flipdim(##,2);']
%         ['flipdim(##,3);']
%         
%         ['flipdim(flipdim(##,1),2);']
%         ['flipdim(flipdim(##,1),3);']
%         ['flipdim(flipdim(##,2),3);']
%         ['flipdim(flipdim(flipdim(##,1),2),3);']
%         };

    f1=regexprep( par.fliplist,'##',st);
    
    g=b;
    w={};
    for j=1:size(f1)
        eval(['g2=' f1{j}]);
        %         fg;montage_p(g2(:,:,1:5:end))
        
        if  strcmp(par.ovltype, 'mask')
            bx=single(g2~=0);
            s1=squeeze(sum(sum(bx,2),3));  s1=max(find(s1==max(s1)));
            s2=squeeze(sum(sum(bx,1),3));  s2=max(find(s2==max(s2)));
            s3=squeeze(sum(sum(bx,1),2));  s3=max(find(s3==max(s3)));
            sli=[s1 s2 s3];
        else
            bx=single(g2);
            sli=round(size(bx)/2);
            
        end
        
        
        %         w{j,1,1}=squeeze(a(sli(1),:       ,: ));
        %         w{j,2,1}=squeeze(a(:       ,sli(2),: ));
        %         w{j,3,1}=squeeze(a(:       ,:       ,  sli(3) ));% TEMPLATE (header)
        %
        %         w{j,1,2}=squeeze(g2(sli(1),:       ,: ));            % OBJ-file
        %         w{j,2,2}=squeeze(g2(:       ,sli(2),: ));
        %         w{j,3,2}=squeeze(g2(:       ,:       ,  sli(3) ));
        
        resiz=[100 100];
        w{j,1,1}=imresize(squeeze(a(sli(1),:       ,: )),resiz);
        w{j,2,1}=imresize(squeeze(a(:       ,sli(2),: )),resiz);
        w{j,3,1}=imresize(squeeze(a(:       ,:       ,  sli(3) )),resiz);% TEMPLATE (header)
        
%         w{j,1,1}=imadjust(mat2gray(w{j,1,1}));
%         w{j,2,1}=imadjust(mat2gray(w{j,2,1}));
%         w{j,3,1}=imadjust(mat2gray(w{j,3,1}));

        
        w{j,1,2}=imresize(squeeze(g2(sli(1),:       ,: )),resiz,'nearest');            % OBJ-file
        w{j,2,2}=imresize(squeeze(g2(:       ,sli(2),: )),resiz,'nearest');
        w{j,3,2}=imresize(squeeze(g2(:       ,:       ,  sli(3) )),resiz,'nearest');
        
        
        
        
    end
    ww=[ww;w];
    ff=[ff;f1];
end


%———————————————————————————————————————————————
%%   setup panel
%———————————————————————————————————————————————


nrc=[size(ww,1) 3];
N=   prod(nrc);

%———————————————————————————————————————————————
%%   plot this
%———————————————————————————————————————————————
[hs rb] =axslider2([nrc], 'checkbox',3,'selection','single' );
set(gcf,'name',['select reorientation, pannel [' num2str(nrc(1)) 'x' num2str(nrc(2)) ']' ]);
nrcmat=reshape( [1:prod(nrc)],[fliplr(nrc) ])';


for i=1:N
    
    [i1 i2]=find(nrcmat==i);
    ca=ww{i1,i2,1};
    cb=ww{i1,i2,2};
    
    
    axes(hs(i));
    imagesc(ca); % colormap gray
    hold on;
    % contour(ca,'color','w')
    contour(cb,'color','r','linewidth',.1);
    axis off;
    
    yl=ylim;
    xl=xlim;
    yl=round(yl(2));
    sp=yl-yl*.85;
    xs=linspace(1,sp,3)+sp/5;
    if ~isempty( find(nrcmat(:,1)==i) )
        ftx=['   ' strrep(ff{i1},'g2=','')];
        t1=text(mean(xl), xs(1)+5,  [  ftx ],'color','w','fontsize',5,'tag','tx','interpreter','none','fontweight','bold',...
            'horizontalalignment','center');
    end
    
end

%———————————————————————————————————————————————
%%
%———————————————————————————————————————————————

set(hs,'XTickLabel','','YTickLabel','');
set(findobj(gcf,'tag','chk1'),'tooltipstring','..use this trafo');
hok=uicontrol('style','pushbutton','units','norm','position',[0 0 .05 .05],'string','ok',...
    'tooltipstring','OK select this trafo','callback','uiresume(gcbf)');
% ax1=findobj(gcf,'tag','chk1');
% set(ax1,'callback', 'set(setdiff(findobj(gcf,''tag'',''chk1''),gco),''value'',0)' );

uiwait(gcf);

%———————————————————————————————————————————————
%%   adding output
%———————————————————————————————————————————————

rb=findobj(gcf,'tag','chk1');
rbsel    =rb(find(cell2mat(get(rb,'value'))));        % id of radiobutton(s) selected
rbstring = str2num(char(get(rbsel,'string')))'        ;%get string of selected radiobutton
% disp(rbstring);

[syntax chk]=deal([]);
chk=rbstring;
if ~isempty(chk)
    syntax=ff{chk};
end

close(gcf);







