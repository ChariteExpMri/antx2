% #lk mask/maskimage manupulator 
% * save mask or a masked image
% * combine mask with another mask ...apply on another image
% #g see tooltips for more information
% 
% #lk HOW TO
% If not specified in the upper gray edit field, please load a mask [load mask]
% #g        Mask and the background image are already loaded 
% #g        when using the drawing tool [xdraw]
%  
% #k Left ID-listbox
%  Select the IDS from the left listbox (via checbox). The IDs refer to numeric values
%  found in the mask.
%     - if necessary IDs recode IDS in the 3rd. column
%     - Example row in listbox:  "[x] 2 5"  stands for: use ID-2 & recode it to ID-5
% 
% #k Decide whether to combine the mask [mask1] with another mask [mask2].
% hit #b [get other mask] #n to select another mask file. This file will be displayed in the
% edit field. Select a mask threshold for [mask2] and the math operation #b [fuse OP.] #n
% defines how [mask1] and [mask2] will be combined.
%    #g for more info see "Mask specs": [Fuse OP] & [mask thesh]).
%  
% #g ___________ ORDER OF COMBINATION _____________________________________________
% #g if available [mask2] is first combined with [mask1] and than, if available,
% #g applied to an image ([image1] or [image2])    
% #g if [mask2] is not specified, [mask1] is combined with the image 
% #g if no image specified the output is [mask1]
% #g _______________________________________________________________________________
% 
% #k Decide what you want to obtain (yellow 3 radios): 
%   [1] [save Mask]          ...save a mask
%   [2] [save Masked Image]  ...saves a masked version of the [image1]  
%                                (if image is specified)
%   [3] [mask another Image] ...saves a masked version of another image [image2] 
%                               (if another image is specified)
%
% #k if you want to user another image use #b [mask another Image]
%  please specify the filename via [get other image].
%
% #k  MASK/ MASK-IMAGE SPECIFICATIONS
% #b [mask thesh] #n -is used to threshold the "FINAL-MASK".
%  * The "FINAL-MASK" is either the drawn mask (1st mask) or the mask created by fusing 
%    the mask with another mask ([mask2])
%  #g * you can select or select&edit or edit the field
%  #g * The character "a" is used as placeholder for the final mask
%   examples:
%     'none'   - no changes in IDs
%     'a>0'    - all IDs>0  will be recoded to ID-1
%     'a==1'   - all IDs=1  will be recoded to ID-1
%     'a==2'     ..
%     'a~=0'   - all IDs not 0  will be recoded to ID-1
%     'a>=1'   - all IDs larger or eqal =1 will be recoded to ID-1
%     'a>1'      ..
%     'm>5 & m<10' - all IDs avode ID-5 and below ID-10 will be recoded to ID-1
% 
% #b [Fuse OP] #n  Specify how to combine "FINAL-MASK with the "USED-IMAGE"    
%     "FINAL-MASK" is either the drawn mask/[mask1] or the FUSED MASK of [mask1] and [mask2]
%     "USED-IMAGE" is either the input image or another image
%     voxelwise multiplication (.*) is standard
% 
% #b [output value ==0] [output value ~=0] : RECODE THE "FINAL OUTPUT"
%  For the final output nonzero and zerovalues can be recoded, respectively.
%  #g Depending on the previous selection the "FINAL OUTPUT" can be:
%           *  [mask1]   (and its variations: recoded mask/thrsholded mask)
%           *  the combined output from [mask1] and [mask2] (and the variations of [mask2])
%           *  combination [mask1]         with   input image [image1] 
%           *  combination [mask1 & mask2] with   input image [image1] 
%           *  combination [mask1]         with another image [image2] 
%           *  combination [mask1 & mask2] with another image [image2] 
%  #g * you can select or select&edit or edit the field
%  #g * The string "img" is used as placeholder for the "FINAL OUTPUT" image
%     'none'         - no changes in IDs or intensity values
%     '1'            - change ID/intensity 1
%     '2'            - change ID/intensity 2
%     'mean(img)'    - change replaced by mean ID/intensity in image
%     'mean(img>0)'  - change replaced by mean over vales above zero
%     'std(img)'     - change replaced by std ID/intensity in image
% 
% % #lk COMMANDLINE
% current version is strongly gui-dependent
% maskman()   ; % #g % open GUI, you can load load images and mask2 via buttons
% maskman(struct('f1','AVGT.nii',  'f2','ANO.nii')) ; % #g % load image ('f1') and mask ('f2')
% The input argument is a struct with following OPTIONAL fields
%  f1        :   the image [image1]
%  f2        :   the mask [mask1]
%  fi_mask2  :   another mask [mask2]
%  fi_img2   :   another image [image2] 
%  fi_save   :   filename to save the output
%  colmat    :  [nx3]-colortable; n must be >= number of IDs in [mask1]
%     
% 

function maskman(v)
% ==============================================
%%
% ===============================================
% clc;
% cf

% ==============================================
%%   parse info
% ===============================================

v.info='--savepop--';

if isfield(v,'f1')==0;  v.f1      =[]; end
if isfield(v,'f2')==0;  v.f2      =[]; end



if isfield(v,'colmat')==0;  v.colmat = distinguishable_colors(40,[1 1 1; 0 0 0]);   end

if isfield(v,'fi_mask2')==0;  v.fi_mask2=[]; end
if isfield(v,'fi_img2')==0;   v.fi_img2 =[]; end
if isfield(v,'fi_save')==0;   v.fi_save =[]; end


if isfield(v,'outputvalAssignList')==0; 
    v.outputvalAssignList={'none' '1' '2' 'mean(img)' 'mean(img>0)' 'std(img)'};
end
if isfield(v,'threshlist')==0; 
    v.threshlist={'none' 'a>0' 'a==1' 'a==2' 'a~=0'  'a>=1' 'a>1'  'm>5 & m<10'  };
end
 
if isfield(v,'ha')==0;  v.ha      =[]; end
if isfield(v,'a')==0;   v.a       =[]; end
if isfield(v,'hb')==0;  v.hb      =[]; end
if isfield(v,'b')==0;   v.b       =[]; end

if isempty(v.a) &&  ~isempty(v.f1)
     [v.ha v.a]=rgetnii(v.f1);
end
if isempty(v.b) &&  ~isempty(v.f2)
     [v.hb v.b]=rgetnii(v.f2);
end


% ==============================================
%%   simulat
% ===============================================
if 0
    v=[]
    v.f1='F:\data2\drawing_tool\etruscianShrewR2_test\AVGT.nii' ;
    v.f2='F:\data2\drawing_tool\etruscianShrewR2_test\roimask1.nii';
    %  v.f2='F:\data2\drawing_tool\etruscianShrewR2_test\AVGThemi.nii';
    [v.ha v.a]=rgetnii(v.f1);
    [v.hb v.b]=rgetnii(v.f2);
    
    %   v.b(1:25,1,1)=1:25;
    
    v.colmat = distinguishable_colors(40,[1 1 1; 0 0 0]);
    v.colmat=v.colmat([2 1 3:end ],:);
    
    v.fi_mask2='F:\data2\drawing_tool\etruscianShrewR2_test\AVGThemi.nii';
    v.fi_img2 ='F:\data2\drawing_tool\etruscianShrewR2_test\sample.nii';
    v.fi_save ='F:\data2\drawing_tool\etruscianShrewR2_test\_test.nii';
    maskman(v);
    
    %    's_saveotherIMGfilename_ed' v.fi_mask2
    %    's_othermaskfilename_ed'   v.fi_img2
    %    's_setfilename_save_ed'    v.fi_save
end

% ==============================================
%%   get data from xdraw
% ===============================================
if 0
    if isempty(v.f1)==1 || isempty(v.f2)==1
        
        try
            
            if isfield(v,'ha')==0 || isfield(v,'a')==0;
                [v.ha v.a]=rgetnii(v.f1);
            end
            
            if isfield(v,'hb')==0 || isfield(v,'b')==0;
                [v.hb v.b]=rgetnii(v.f2);
            end
            %         hf1=findobj(0,'tag','xpainter');
            %         u=get(hf1,'userdata');
            %         v.f1    =  u.f1;
            %         v.f2    =  u.f2;
            %
            %         v.ha     = u.ha;
            %         v.a      = u.a;
            %         v.hb     = u.hb;
            %         v.b      = u.b;
            %
            %         v.colmat = u.colmat;
        catch
            disp(['"' mfilename '" is a subfunction of xdraw.m']);
            disp('see help of [xdraw.m]');
            return;
            
        end
    end
end



makefig(v);
% ==============================================
%%
% ===============================================
% v=get(gcf,'userdata');
% % v.f1=u.f1;
% set(gcf,'userdata',v);
% ==============================================
%%
% ===============================================

function proc(e,e2, task)
v   =get(gcf,'userdata');
%++ savetype
htyp=findobj(gcf,'userdata','savetype');
savetypeTag=get(htyp(find(cell2mat(get(htyp,'value')))),'tag');
savetype_all={'s_saveMSK_rb' 's_saveIMG_rb' 's_saveotherIMG_rb'};
savetype=find(strcmp(savetype_all,savetypeTag));

% ==============================================
%%   get MASK with IDS
% ===============================================
%++get IDs
ht=findobj(gcf,'tag','table');
d=ht.Data;
d(cellfun('isempty',d))={'NaN'};
d=cell2mat(cellfun(@(a){[str2num(num2str(a)) ]} , d ));

if isempty(d)
    % ==============================================
    %%   input-dlg
    % ===============================================
    prompt = {
        ['\bf\color{blue} DRAWN MASK IS \color{red}\bf ' 'EMPTY!'  '\rm' '\color{blue}' char(10) ...
        'No IDs (values) found in mask. \color{black} ' char(10) ...
        ' ' char 10 ...
        '\bf HOW TO PROCEED?'  '\rm' char(10)  ...
        '  [0] Cancel/abort this ' char(10) ...
        '  [1] Proceed and try it ' char(10) ...
        ],...
        '\bf IF "PROCEED" IS [1]: Enter a ID (numeric value) to fill mask with this value '};
    dlg_title = ['MASKfile: issue' repmat(' ',[1 150])];
    num_lines = 1;
    defaultans = {'1','1'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans,struct('Interpreter','tex'));
    if isempty(answer);return; end
    if strcmp(answer{1},'0')
        %disp('cancelled..')
        return
    elseif strcmp(answer{1},'1')
        IDuser=str2num(answer{2});
        v.b=ones(size(v.b)).*IDuser;
        d=[1 IDuser nan];
        
        BTN = questdlg('ask again the next time?', '', 'Yes', 'No', 'Yes');
          if strcmp(BTN,'No'); %store in struct
              set(gcf,'userdata',v);
              drawnow;
              v   =get(gcf,'userdata');
              setIDtable();
              proc(e,e2, task);
              return
          end
          
        
    else
        return
    end
    
    
    % ==============================================
    %%
    % ===============================================

    
     
     
end
% d(d(:,1)==0,:)=[]; % remove non-used ID
if sum(d(:,1))==0; msgbox('no ID(s) selected'); return; end

allselected =  size(d,1)==sum(d(:,1));
isrenamed   =  sum(~isnan(d(:,3)));

if allselected==1 && isrenamed==0
    %'JUST COPY'
    m=v.b;
    
else
    d2=d;
    d2(d2(:,1)==0,:)=[]; % remove non-used ID
    inan=isnan(d2(:,3));
    d2(inan,3)=d2(inan,2);
    
    m=zeros(numel(v.b),1);
    b=v.b(:);
    for i=1:size(d2,1)
        ix=find(b==d2(i,2));
        m(ix,1)=d2(i,3);
    end
    m=reshape(m,size(v.b));
    %montage2(m)
end


% ==============================================
%%   THRESHmask(OP)
% ===============================================
hb=findobj(gcf,'tag','s_MaskOP_jpop');
op=char(hb.UserData.getSelectedItem);
if strcmp(op,'none')
    %'do nothing'
else
    expr=['m=' regexprep(op,'a','m') ';'];
    eval(expr);
end

% montage2(permute(m,[1 3 2]));

% ==============================================
%%  [2] other mask
% ===============================================
rd=findobj(gcf,'tag','s_othermask_rd') ;
if get(rd,'value')==1
    % ==============================================
    %%  [2.1] other mask, get file
    % ===============================================
    ed=findobj(gcf,'tag','s_othermaskfilename_ed') ;
    mask2=get(ed,'string');
    if exist(mask2)~=2;   msgbox('please specify another mask'); return; end
    [hm2 mask2]=rgetnii(mask2);
    m2=mask2;
    
    % ==============================================
    %%  [2.2] other mask, THRESH mask2 (OP)
    % ===============================================
    hb=findobj(gcf,'tag','s_MaskOP_applyothermask_jpop');
    op=char(hb.UserData.getSelectedItem);
    if strcmp(op,'none')
        % 'do nothing'
    else
        eval(['m2=' regexprep(op,'a','m2') ';']);
    end
    % montage2(permute(m2,[1 3 2]));
    
    % ==============================================
    %%  [2.3] other mask, FUSE with mask (OP)
    % ===============================================
    pu=findobj(gcf,'tag','s_fuseOP_applyothermask_pop');
    li=get(pu,'string');
    va=get(pu,'value');
    
    fuseop=li{va};
    eval(['m4= m' fuseop 'm2;']);
    %montage2(permute(m4,[1 3 2]));
    
    m=m4; %overwrite
end

% montage2(permute(m,[1 3 2]));

% ==============================================
%%  [3] mask image
% ===============================================
% ==============================================
%%   [3.1] which image
% ===============================================
rd1=findobj(gcf,'tag','s_saveIMG_rb') ;
rd2=findobj(gcf,'tag','s_saveotherIMG_rb') ;

if any([rd1.Value rd2.Value])
    % w=zeros(size)
    if rd1.Value==1
        % ==============================================
        %%  [2.1] same image, get file
        % ===============================================
        hx =v.ha;
        x  =v.a;
    elseif rd2.Value==1
        % ==============================================
        %%  [2.1] other image, get file
        % ===============================================
        ed=findobj(gcf,'tag','s_saveotherIMGfilename_ed') ;
        file2=get(ed,'string');
        if exist(file2)~=2;   msgbox('please specify another image (..image not specified)'); return; end
        [hx x]=rgetnii(file2);
        
    end
    % montage2(permute(x,[1 3 2]));
    if isempty(x)
        msgbox('no image file loaded');
        return
    end
    
    % ==============================================
    %%   [2.2] IMAGE(1/2), FUSE with mask (OP)
    % ===============================================
    pu=findobj(gcf,'tag','s_IMGfuseOP_pop');
    li=get(pu,'string');
    va=get(pu,'value');
    
    fuseop=li{va};
    eval(['z= x' fuseop 'm;']);
    % montage2(permute(z,[1 3 2]));
    
    m=z;
end


% ==============================================
%%   [3.1/3.2] IMAGE(1/2), OUTPUTVALUE '~=0'
%%             IMAGE(1/2), OUTPUTVALUE '==0'
% ===============================================
hb1=findobj(gcf,'tag','s_IMGoutputValueNot0_jpop');
op1=char(hb1.UserData.getSelectedItem);

hb2=findobj(gcf,'tag','s_IMGoutputValue0_jpop');
op2=char(hb2.UserData.getSelectedItem);

[g1 g2]=deal(m(:));
ix1=find(g1~=0);
ix2=find(g1==0);
% % % % %    g1=g(ix1);
% % % % %    g2=g(ix2);

[v1 v2]=deal([nan]);
if strcmp(op1,'none')==0
    eval(['v1= ' strrep(op1,'img','g1') ';']);
    g2(ix1)=v1;
end
if strcmp(op2,'none')==0
    eval(['v2= ' strrep(op2,'img','g1')  ';']);
    g2(ix2)=v2;
end
g3=reshape(g2,size(m));
if 0   %debug
    disp(['op1: ' op1    '  --   op2: ' op2   ]);
    disp(v1);         disp(v2);
    %montage2(g3);
end


% ==============================================
%%   [3.3] back to matrix
% ===============================================

m=g3;



% ==============================================
%%  TEST PLOT
% ===============================================
if strcmp(task,'test')
    
    maxIDs=20;
    mur=v.b;
    if exist('mask2')~=1;       mask2=[]; end
    if exist('x')~=1;               x=[]; end
    
    hf=findobj(0,'tag','testplot1');
    if isempty(hf)==0
        hr=findobj(0,'tag','dim');
        usedim=get(hr,'value');
    else
        usedim=3;
    end
    mmake_testplot(mur,mask2,x,m, usedim);
elseif strcmp(task,'save')
    % ==============================================
    %%   save
    % ===============================================
    hed=findobj(gcf,'tag','s_setfilename_save_ed');
    fileout=get(hed,'string');
    [pa fi ext]=fileparts(fileout);
    if exist(pa)~=7;   
        msgbox('no filename specified to save file');
        return; 
    end
    fileout=fullfile(pa, [  fi '.nii'   ]);
    
    if ~isempty(v.ha)
        he=v.ha;
    else
        he=v.hb;
    end
        
    
    rsavenii(fileout,he,m);
    if isempty(v.f1)
        showinfo2('new file',fileout);
    else
        showinfo2('new file',v.f1,fileout,13);
    end
end

% ==============================================
%%
% ===============================================

function changedim(e,e2)

hf=findobj(0,'tag','testplot1');
figure(hf);
hr=findobj(0,'tag','dim');
w=get(hf,'userdata');
usedim=get(hr,'value');


mmake_testplot(w.mur,w.mask2,w.x,w.m, usedim);

function close_testplot1(e,e2)
try
    hfig=findobj(0,'tag','testplot1');
    global testplot1
    testplot1.pos=get(hfig,'position');
close(hfig);
catch
    close(gcf);
end


function mmake_testplot(mur,mask2,x,m, usedim);
maxIDs=20;

% delete(findobj(0,'tag','testplot1'));
hfig=findobj(0,'tag','testplot1');
if isempty(hfig);
    fg;
    set(gcf,'tag','testplot1');
    hb=uicontrol('style','popupmenu','units','norm','string',{'dim1' 'dim2' 'dim3'},'value',usedim);
    set(hb,'position',[0.47143 -0.027381 0.1 0.07],'tag','dim','callback', @changedim);
    set(hb,'tooltipstring','change viewing dimension');
   
    hfig=gcf;
    set(hfig,'name',['testplot1'], 'numbertitle','off');
    global testplot1
    if ~isempty(testplot1)
        set(hfig,'position',testplot1.pos);
    end
end

figure(hfig);

w.mur=mur;
w.mask2=mask2;
w.x=x;
w.m=m;
set(gcf,'userdata',w);
set(gcf,'CloseRequestFcn',@close_testplot1);




% ==============================================
%%  1. input mask
% ===============================================

dimord=[setdiff([1:3],usedim) 4 usedim ];

subplot(2,2,1);
v4=montageout(permute(mur,dimord));
imagesc(v4);
% axis image;
axis off;  % ti=title('mask');

hold on;
cm = get(gcf,'Colormap');
cax=caxis;
uni=unique(v4); uni(uni==0)=[];
if length(uni)<maxIDs && length(uni)>0
    col=cm( (round(((([uni; cax(:); ])-cax(1))./cax(2))*(size(cm,1)-1)))+1   ,:);
    pl=[];
    for i=1:length(uni) 
        pl(i)=plot(-10,-10,'ro','markerfacecolor', col(i,: ),'visible','on');
    end
    hl=legend(pl,cellstr(num2str(uni)),'box off');
    set(hl,'Location','northeast','Orientation','vertical','fontsize',7);
end
te=text(0,0,'[1] mask');
yl=ylim;
set(te,'position',[0,yl(1)],'VerticalAlignment','top','color','w');
set(gca,'position',[.001 0.51 .499 .5]);


% ==============================================
%%  2.  other mask  "mask2"
% ===============================================
subplot(2,2,2);
if isempty(mask2)==0
    
    
    v4=montageout(permute(mask2,dimord));
    imagesc(v4); axis
    %image;
    axis off;  % ti=title('mask');
    
    hold on;
    cm = get(gcf,'Colormap');
    cax=caxis;
    uni=unique(v4); uni(uni==0)=[];
    if length(uni)<maxIDs && length(uni)>0
        col=cm( (round(((([uni; cax(:); ])-cax(1))./cax(2))*(size(cm,1)-1)))+1   ,:);
        pl=[];
        for i=1:length(uni);
            pl(i)=plot(-10,-10,'ro','markerfacecolor', col(i,: ),'visible','on');
        end
        hl=legend(pl,cellstr(num2str(uni)),'box off');
        set(hl,'Location','northeast','Orientation','vertical','fontsize',7);
    end
    te=text(0,0,'[2] other mask');
    yl=ylim;
    set(te,'position',[0,yl(1)],'VerticalAlignment','top','color','w');
  
else
    plot(1,1,'r');
    text(.5,.5,'2. no other mask applied');
    axis off;
end
  set(gca,'position',[.501 0.51 .499 .5]);

% ==============================================
%%   3. image
% ===============================================
subplot(2,2,3);
if isempty(x)==0
    
    v4=montageout(permute(x,dimord));
    imagesc(v4);
    %     axis image;
    axis off;                    % title('image');
    hold on;
    cm = get(gcf,'Colormap');
    cax=caxis;
    uni=unique(v4); uni(uni==0)=[];
    if length(uni)<maxIDs && length(uni)>0
        col=cm( (round(((([uni; cax(:); ])-cax(1))./cax(2))*(size(cm,1)-1)))+1   ,:);
        pl=[];
        for i=1:length(uni);
            pl(i)=plot(-10,-10,'ro','markerfacecolor', col(i,: ),'visible','on');
        end
        hl=legend(pl,cellstr(num2str(uni)),'box off');
        set(hl,'Location','northeast','Orientation','vertical','fontsize',7);
    end
    te=text(0,0,'[3] image');
    yl=ylim;
    set(te,'position',[0,yl(1)],'VerticalAlignment','top','color','w');
else
    plot(1,1,'r');
    text(.5,.5,'3. no image applied');
    axis off;
   
end
 set(gca,'position',[.001 0.001 .499 .505]);

% ==============================================
%   4.  output
% ===============================================
subplot(2,2,4);
v4=montageout(permute(m,dimord));
imagesc(v4);
% axis image;
axis off;
ti=title('output');
set(ti,'VerticalAlignment','top');
hold on;
cm = get(gcf,'Colormap');
cax=caxis;
uni=unique(v4); uni(uni==0)=[];
if length(uni)<maxIDs && length(uni)>0
    col=cm( (round(((([uni; cax(:); ])-cax(1))./cax(2))*(size(cm,1)-1)))+1   ,:);
    pl=[];
    for i=1:length(uni);
        pl(i)=plot(-10,-10,'ro','markerfacecolor', col(i,: ),'visible','on');
    end
    hl=legend(pl,cellstr(num2str(uni)),'box off');
    set(hl,'Location','northeast','Orientation','vertical','fontsize',7);
    yl=ylim;
end
te=text(0,0,'[4] output');
yl=ylim;
set(te,'position',[0,yl(1)],'VerticalAlignment','top','color','w');
set(gca,'position',[.501 0.001 .499 .505]);

drawnow;
set(gcf,'WindowButtonMotionFcn',@montage_motion_getvalue);
% ==============================================
%%
% ===============================================


% end













% ==============================================
%%
% ===============================================


function montage_motion_getvalue(e,e2)
hf=findobj(0,'tag','testplot1');
figure(hf);
errmsg='testplot:  move mouse pointer to inspect value';
% set(hf,'name',['testplot1']);
hax=hittest();
% return
if strcmp(get(hax,'type'),'legend');
    set(gcf,'name',errmsg);
    return; 
end
% if strcmp(get(hax,'style'),'uicontrol'); return; end

% if strcmp(get(hax,'type'),'image')~=0;
%        '2'
%     return
% end
axthis=get(hax,'parent');

if strcmp(get(axthis,'type'),'axes')~=1; 
     %  '3'
    return;
end
try
    axes(axthis);
end
%  return

co=get(gca,'CurrentPoint'); co=round(co(1,1:2));
if any(co<1); 
      % '4'
    return; 
end

him=findobj(gca,'type','image');
d=get(him,'cdata');

try
    set(gcf,'name', ['TYPE: '  get(findobj(gca,'type','text'),'string')  '   '  ...
        '   value: '  num2str( d(co(2),co(1))  )]);
catch
    set(gcf,'name',errmsg);
end


function s_savefile(e,e2,task)
% disp('saving..');
proc(e,e2,task);


function s_close(e,e2)
close(gcf);

function s_help(e,e2)
uhelp([mfilename '.m'])



function s_selectall_chk(e,e2)
v=get(gcf,'userdata');
% disp(v.h);
% disp(v.h(:,1));
hb=findobj(gcf,'tag','table');
% d=get(hb,'data');
if get(findobj(gcf,'tag','s_selectall_chk'),'value')==0
    hb.Data(:,1)={logical(0)} ;% d(:,1)={logical(0)};
else
    hb.Data(:,1)={logical(1)} ;d(:,1)={logical(1)} ;
end



function savetype(e,e2,type)
set(findobj(gcf,'userdata','savetype'),'value',0);
set(e,'value',1);

function getfile(e,e2,type)
isget=1;
if strcmp(type, 'otherimage')
    msg='select another image file';
    A=1;
elseif strcmp(type, 'othermask');
    A=2;
    msg='select another maskfile file';
elseif strcmp(type,'savename')
    A=3;
    isget=0;
    msg='select file/filename to save new file';
end
v=get(gcf,'userdata');

% ==============================================
%%   
% ===============================================
try  pa1=fileparts(v.f1); catch pa1='dummydummydummy'; end
try  pa2=fileparts(v.f2); catch pa2='dummydummydummy'; end
pas={pa1; pa2};
pas(regexpi2(pas,'dummydummydummy'))=[];

if length(pas)==1
    pa=pas{1};
else
    pa=pwd;
end
    
    

% 
% if isempty(v.f2)
%     pa=pwd;
% else
%     try ;
%         [pa]=fileparts(v.f1);
%     end
%     if isempty(pa); pa=pwd; end
% end
% 




% ---------------------------------------------------
if isget==1
    [fi pa]=uigetfile(fullfile(pa,'.nii'),msg);
elseif isget==0
    [fi pa]= uiputfile(fullfile(pa,'*.nii'),msg);
end
if isnumeric(pa); return; end
filename=fullfile(pa,fi);
% ---------------------------------------------------
if A==1
    hb=findobj(gcf,'tag','s_saveotherIMGfilename_ed') ;
elseif A==2
    hb=findobj(gcf,'tag','s_othermaskfilename_ed') ;
elseif A==3
    hb=findobj(gcf,'tag','s_setfilename_save_ed') ;
end
set( hb   , 'string',filename);
hj=findjobj(hb);
hj.setCaretPosition(length(filename)-1); %move to right filename end

function filename_ed(e,e2)
hb=e;
try
    filename=get( hb   , 'string');
    hj=findjobj(hb);
    hj.setCaretPosition(length(filename)-1); %move to right filename end
end


function setIDtable()
hf=findobj(0,'tag','savespec');
v=get(hf,'userdata');
x=v.b;
ids=unique(x(:)); ids(ids==0)=[];
dx=[ logical(ones(size(ids)))  ids  ones(size(ids))  ];
dx={};
for i=1:length(ids)
    tmp= { logical(1) num2str(ids(i))   ''};
    dx=[dx; tmp];
end
t=findobj(hf,'tag','table');
set(t,'data',dx);
try
col=v.colmat(1:length(ids),:);
catch
  v.colmat = distinguishable_colors(max(length(ids)),[1 1 1; 0 0 0]); 
  if size(v.colmat,1)>1
      v.colmat =[v.colmat(2,:); v.colmat([1 3:end],:)  ];
  end
    col=v.colmat(1:length(ids),:);
end
t.BackgroundColor =col;% [0 0 1; 0.9451    0.9686    0.9490];

set(hf,'userdata',v);

% ==============================================
%%   replace IMAGE
% ===============================================
function replaceImage(e,e2)
hf=findobj(0,'tag','savespec');
v=get(hf,'userdata');
if isfield(v,'a') && ~isempty(v.a)
    BTN = questdlg('replace current Image? Confirm:', '', 'Yes', 'No', 'Yes');
    if strcmp(BTN,'No'); %store in struct
        return
    end
end
msg='select another Image (NIFTI)';
[fi pa]=uigetfile(fullfile(pwd,'.nii'),msg);
if isnumeric(pa); return; end
filename=fullfile(pa,fi);
if exist(filename)~=2; return; end
try
    [ha a]=rgetnii(filename);
catch
    msgbox('error loading') ;
    return
end
v.f1 =filename;
v.ha =ha;
v.a  =a;
set(hf,'userdata',v);
% setIDtable(); drawnow;
set(findobj(hf,'tag','s_infile_ed'),'string',[  'file: '   v.f1]);

% ==============================================
%%   replace Mask
% ===============================================
function replaceMask(e,e2)
hf=findobj(0,'tag','savespec');
v=get(hf,'userdata');
if isfield(v,'b') && ~isempty(v.b)
    BTN = questdlg('replace current mask? Confirm:', '', 'Yes', 'No', 'Yes');
    if strcmp(BTN,'No'); %store in struct
        return
    end
end
msg='select another mask (NIFTI)';
[fi pa]=uigetfile(fullfile(pwd,'.nii'),msg);
if isnumeric(pa); return; end
filename=fullfile(pa,fi);
if exist(filename)~=2; return; end
try
    [hb b]=rgetnii(filename);
catch
    msgbox('error loading') ;
    return
end
v.f2 =filename;
v.hb =hb;
v.b  =b;
set(hf,'userdata',v);
setIDtable(); drawnow;
set(findobj(hf,'tag','s_inmask_ed'),'string',[ 'mask: '     v.f2 ]);

hc=findobj(hf,'tag','txt_message');
t=findobj(hf,'tag','table');
set(t,'enable','on');
set(hc,'visible','off');
uistack(hc,'bottom');



% ==============================================
%%   maketable
% ===============================================
function maketable()
hf=findobj(0,'tag','savespec');
v=get(hf,'userdata'); 
if isfield(v,'b') && ~isempty(v.b)
    x=v.b;
    isok=1;
else
    x=[1];
    isok=0;
end
ids=unique(x(:)); ids(ids==0)=[];
% hb=gcf;
% h(end+1,:)={get(hb,'tag') get(hb,'type')  get(hb,'name') };
% ids=repmat(ids,[8 1])

dx=[ logical(ones(size(ids)))  ids  ones(size(ids))  ];
dx={};
for i=1:length(ids)
    tmp= { logical(1) num2str(ids(i))   ''};
    dx=[dx; tmp];
end

tbh      = {'use' 'ID' 'newID'};
tb       =dx;
editable = [1    0 1  ]; %EDITABLE
colfmt   ={'logical' 'string'  'numeric'} ;

% for i=1:size(tbh,2)
%     addspace=size(char(tb(:,i)),2)-size(tbh{i},2)+3;
%     tbh(i)=  { [' ' tbh{i} repmat(' ',[1 addspace] )  ' '  ]};
% end

t = uitable('Parent', gcf,'units','norm', 'Position', [0 0.05 1 .93], ...
    'Data', tb,'tag','table',...
    'ColumnWidth','auto');
t.ColumnName =tbh;
% h(end+1,:)={get(t,'tag') get(t,'type')  '' };

t.ColumnEditable =logical(editable ) ;% [false true  ];
try
    colmat=v.colmat;
catch
    v.colmat = distinguishable_colors(length(ids),[1 1 1; 0 0 0]);
    if size(v.colmat ,1)>2
        v.colmat=v.colmat([2 1 3:end ],:);
    end
end
if length(ids)>size(v.colmat,1)
     v.colmat = distinguishable_colors(length(ids),[1 1 1; 0 0 0]);
    if size(v.colmat ,1)>2
        v.colmat=v.colmat([2 1 3:end ],:);
    end 
end



% colmat=repmat(colmat,[5 1]);
col=v.colmat(1:length(ids),:);
t.BackgroundColor =col;% [0 0 1; 0.9451    0.9686    0.9490];

set(t,'units','norm','position',[0 .1 0.35 .9]);
set(t,'ColumnWidth',{51});
set(t,'units','norm','position',[0 .2 0.35 .8]);
set(t,'tooltipstring','found IDs in mask ..select IDs/rename IDs to save');
set(hf,'userdata',v);
 

hc=findobj(hf,'tag','txt_message');
if isok==0
    set(t,'enable','off');
   
    set(hc,'visible','on');
    set(hc,'string',['Please load image & mask first !']);
    uistack(hc,'top');
else
    set(t,'enable','on');
    set(hc,'visible','off');
     uistack(hc,'bottom');
end

function makefig(v)
% ==============================================
%%
% ===============================================
delete(findobj(0,'tag','savespec'));
figure; set(gcf,'units','norm','color','w');
set(gcf,'menubar','none','tag','savespec','NumberTitle','off','name','save mask/maskedFile');
h={}; %handlelist

%% msg-box
hc=uicontrol('style','text','units','norm', ...
    'string', ['load image & mask first'],'tag','txt_message');
set(hc,'position',[0.01 .5 .3 .3],'fontsize',20,'foregroundcolor','r','backgroundcolor','w');
set(gcf,'userdata',v);

%% make table
maketable();
v=get(gcf,'userdata');


% % % % % % % % if 0
% % % % % % % % x=v.b;
% % % % % % % % ids=unique(x(:)); ids(ids==0)=[];
% % % % % % % % 
% % % % % % % % hb=gcf;
% % % % % % % % h(end+1,:)={get(hb,'tag') get(hb,'type')  get(hb,'name') };
% % % % % % % % % ids=repmat(ids,[8 1])
% % % % % % % % 
% % % % % % % % dx=[ logical(ones(size(ids)))  ids  ones(size(ids))  ];
% % % % % % % % dx={};
% % % % % % % % for i=1:length(ids)
% % % % % % % %     tmp= { logical(1) num2str(ids(i))   ''};
% % % % % % % %     dx=[dx; tmp];
% % % % % % % % end
% % % % % % % % % ==============================================
% % % % % % % % %
% % % % % % % % % ===============================================
% % % % % % % % 
% % % % % % % % tbh      = {'use' 'ID' 'newID'};
% % % % % % % % tb       =dx;
% % % % % % % % editable = [1    0 1  ]; %EDITABLE
% % % % % % % % colfmt   ={'logical' 'string'  'numeric'} ;
% % % % % % % % 
% % % % % % % % % for i=1:size(tbh,2)
% % % % % % % % %     addspace=size(char(tb(:,i)),2)-size(tbh{i},2)+3;
% % % % % % % % %     tbh(i)=  { [' ' tbh{i} repmat(' ',[1 addspace] )  ' '  ]};
% % % % % % % % % end
% % % % % % % % 
% % % % % % % % t = uitable('Parent', gcf,'units','norm', 'Position', [0 0.05 1 .93], ...
% % % % % % % %     'Data', tb,'tag','table',...
% % % % % % % %     'ColumnWidth','auto');
% % % % % % % % t.ColumnName =tbh;
% % % % % % % % h(end+1,:)={get(t,'tag') get(t,'type')  '' };
% % % % % % % % 
% % % % % % % % t.ColumnEditable =logical(editable ) ;% [false true  ];
% % % % % % % % colmat=v.colmat;
% % % % % % % % colmat=repmat(colmat,[5 1]);
% % % % % % % % col=colmat(1:length(ids),:);
% % % % % % % % t.BackgroundColor =col;% [0 0 1; 0.9451    0.9686    0.9490];
% % % % % % % % 
% % % % % % % % set(t,'units','norm','position',[0 .1 0.35 .9]);
% % % % % % % % set(t,'ColumnWidth',{51});
% % % % % % % % set(t,'units','norm','position',[0 .2 0.35 .8]);
% % % % % % % % set(t,'tooltipstring','found IDs in mask ..select IDs/rename IDs to save');
% % % % % % % % 
% % % % % % % % end

% ==============================================
%%
% ===============================================

% ==============================================
%%   inputs
% ===============================================

% select all
hb=uicontrol('style','checkbox','units','norm', 'tag'  ,'s_selectall_chk');
set(hb,'position',[0.0017857 0.15833 0.13 0.04],'string','select all',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',[0.9294    0.6941    0.1255],'value',1,...
    'horizontalalignment','left','fontsize',7,'fontweight','bold');
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',str2func( get(hb,'tag')));
set(hb,'tooltipstring','select/deselect IDs');

%% replace image 
hb=uicontrol('style','pushbutton','units','norm', 'tag'  , 'replaceImage');
set(hb,'position',[0.9 0.96071 0.1 0.04] ,'string','load Image',...{'infobox' 'dd'},...
    'foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback', @replaceImage);
set(hb,'backgroundcolor', [repmat(.9,[1 3])]);

set(hb,'tooltipstring',[...
    'REPLACE CURRENT IMAGE  ' char(10) ...
    'here you can select another IMAGE' char(10) ...
    '!!!WARNING !!! this will replace the input IMAGE' char(10) ...
    ]);

%% replace mask 
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'replaceMask');
set(hb,'position',[0.9 0.92024 0.1 0.04] ,'string','load Mask',...{'infobox' 'dd'},...
    'foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback', @replaceMask);

set(hb,'tooltipstring',[...
    'REPLACE CURRENT MASK  ' char(10) ...
    'here you can select another mask' char(10) ...
    '!!!WARNING !!! this will replace the input/drawn mask' char(10) ...
    ]);
set(hb,'backgroundcolor', [repmat(.9,[1 3])]);

%% EDIT INPUT file
if isempty(v.f1)
    imagestr=['image: not specified' ];
else
    imagestr=['image: ' v.f1];
end
hb=uicontrol('style','edit','units','norm', 'tag'  ,'s_infile_ed');
set(hb,'position',[0.35357 0.95833 0.54 0.04],'string',[ imagestr],...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',repmat(.7,[1 3]),...
    'horizontalalignment','left','fontsize',7,'fontweight','bold');
set(hb,'tooltipstring','input file (background file)');
hb=uicontrol('style','edit','units','norm', 'tag'  ,'s_inmask_ed');

%% EDIT MASKfile
if isempty(v.f2)
    maskstr=[' mask: not specified' ];
else
    maskstr=[' mask: ' v.f2];
end
set(hb,'position',[0.35357 0.92024 0.54 0.04],'string',[maskstr],...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',repmat(.7,[1 3]),...
    'horizontalalignment','left','fontsize',7,'fontweight','bold');
set(hb,'tooltipstring','mask file');







% ==============================================
%%   SAVETYPE: alternative radios what to save
% ===============================================
% save mask
hb=uicontrol('style','radio','units','norm', 'tag'  ,'s_saveMSK_rb');
set(hb,'position',[0.375 0.87262 0.2 0.04],'string','save Mask',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',[0.9294    0.6941    0.1255],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',{@savetype,'msk'},'userdata','savetype');
set(hb,'tooltipstring','select this to save the mask');


% save masked IMage
hb=uicontrol('style','radio','units','norm', 'tag'  ,'s_saveIMG_rb');
set(hb,'position',[0.37679 0.81548 0.2 0.04],'string','save Masked Image',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',[0.9294    0.6941    0.1255],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',0);
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',{@savetype,'img'},'userdata','savetype');
set(hb,'tooltipstring','select this to save a masked version of the input image');


% masked other IMage [OI]
hb=uicontrol('style','radio','units','norm', 'tag'  ,'s_saveotherIMG_rb');
set(hb,'position',[0.37679 0.76071 0.2 0.04],'string','mask another Image',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',[0.9294    0.6941    0.1255],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',0);
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',{@savetype,'img2'},'userdata','savetype');
set(hb,'tooltipstring','select this to save a masked version of another image');


%===========other image =======================================================

% getfile-apply with mask
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'s_saveotherIMGgetfile_btn');
set(hb,'position',[0.41964 0.72262 0.2 0.04],'string','get other image..',...{'infobox' 'dd'},...
    'foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',{@getfile,'otherimage' });
set(hb,'tooltipstring','set another image via GUI');



% editfile-apply with mask
hb=uicontrol('style','edit','units','norm', 'tag'  ,'s_saveotherIMGfilename_ed');
set(hb,'position',[0.41964 0.68452 0.2 0.04],'string','..filename..',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',[0    0.4980         0],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',@filename_ed);
if ~isempty(v.fi_img2)
    set(hb,'string',v.fi_img2);
end
hgfeval(get( hb ,'callback'),hb);
set(hb,'tooltipstring','filename of the other image ');


% ==============================================
%% OTHER MASK
% ===============================================
% rb-apply with mask
hb=uicontrol('style','radio','units','norm', 'tag'  ,'s_othermask_rd');
set(hb,'position',[0.72 0.87738 0.25 0.04],'string','apply with other mask..',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',0);
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'tooltipstring',...
    [...
    'USE ALSO ANOTHER MASK [MASK2]' char(10)  ...
    'if true, this mask [MASK2] will be combined with the drawn mask' char(10) ...
    ]);


% getfile-apply with mask
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'s_othermaskgetfile_btn');
set(hb,'position',[0.75 0.84167 0.2 0.04],'string','get other mask..',...{'infobox' 'dd'},...
    'foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',{@getfile,'othermask' })
set(hb,'tooltipstring',['select another mask [mask2] via GUI ']);



% editfile-apply with mask
hb=uicontrol('style','edit','units','norm', 'tag'  ,'s_othermaskfilename_ed');
set(hb,'position',[0.75071 0.80119 0.2 0.04],'string','..filename..',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',['b'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',@filename_ed);
if ~isempty(v.fi_mask2)
    set(hb,'string',v.fi_mask2);
end
hgfeval(get( hb ,'callback'),hb);
set(hb,'tooltipstring',['filename of the other mask [mask2] ']);



% txt MASK operation-apply with mask
hb=uicontrol('style','text','units','norm', 'tag'  ,'s_MaskOP_applyothermask_txt');
set(hb,'position',[0.72857 0.75119 0.12 0.04],'string','Mask TRESH. ',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
set(hb,'HorizontalAlignment','right');
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'tooltipstring',...
    [ ...
    'THRESHOLD MASK2: defines how to threshold the other mask [mask2] ' char(10) ...
    'select or edit this field' char(10) ...
    '- "a" is a placeholder for mask2' ...
    ]);



% edit MASK operation-apply with mask
% hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'s_editMaskOP_applyothermask');
% set(hb,'position',[0.79643 0.76071 0.1 0.04],'string',{'a' 'b'},...{'infobox' 'dd'},...
%     'backgroundcolor','w','foregroundcolor',['b'],...
%     'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);

% str={'none' 'a>0' 'a==1' 'a==2' 'a~=0'  'a>=1' 'a>1'};
hContainer = gcf;  % can be any uipanel or figure handle
model = javax.swing.DefaultComboBoxModel(v.threshlist);
[jCombo hb] = javacomponent('javax.swing.JComboBox', [0 0 100 100], gcf);
set(hb,'units','norm');
jCombo.setModel(model);
jCombo.setEditable(true);
% jCombo.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, 14))
javaLangString=jCombo.getFont;
FSsize=get(javaLangString,'Size');
jCombo.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, FSsize-5));
% set(jCombo,'ActionPerformedCallback',@cb_adjustIntensity_value);
% set(hb2,'tag', 'cb_adjustIntensity_value');
% set(hb2,'userdata', jCombo);
set(hb,'position',[[0.85 0.76071 0.12 0.04]]);
set(hb,'tag','s_MaskOP_applyothermask_jpop');
set(hb,'userdata', jCombo);
h(end+1,:)={get(hb,'tag') 'java'  '' };


% ----fuse OP other MASK-----------
% txt fuse operation-apply with mask
hb=uicontrol('style','text','units','norm', 'tag'  ,'s_fuseOP_applyothermask_txt');
set(hb,'position',[0.75 0.72024 0.1 0.04],'string','Fuse OP. ',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
set(hb,'HorizontalAlignment','right');
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'tooltipstring',[...
    'COMBINE MASK and MASK2' char(10) ...
    'defines how to combine drawn mask with the other mask [mask2] ' char(10)...
    'voxelwise multiplication (.*) is standard' ...
    ]);


% edit fuse operation-apply with mask
hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'s_fuseOP_applyothermask_pop');
set(hb,'position',[0.85 0.72024 0.1 0.04],'string',{'.*' '+' '-' './'},...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',['b'],...
    'horizontalalignment','right','fontsize',7,'fontweight','bold','value',1);
set(hb,'visible','on');
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };


% ==============================================
%%   MASK
% ===============================================

% txt fuse operation-apply with mask
hb=uicontrol('style','text','units','norm', 'tag'  ,'s_MASK_head_txt');
set(hb,'position',[0.37679 0.5869 0.4 0.04] ,'string','Mask Specs & Mask-Image Specs ',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };


%% MASK-OP  txt MASK operation-apply with mask
hb=uicontrol('style','text','units','norm', 'tag'  ,'s_MaskOP_txt');
set(hb,'position',[0.35179 0.53929 0.12 0.04],'string','Mask TRESH. ',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
set(hb,'HorizontalAlignment','right');
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'tooltipstring',[...
    'TRESHOLD "FINAL-MASK" ' char(10) ...
    'the "FINAL-MASK" is either the drawn mask or the mask created by fusing [mask] and [mask2]' char(10) ...
    'select or edit this field' char(10) ...
    '- "a" is a placeholder for the final mask' ...
    ]);



if 0
    % edit MASK operation-apply with mask
    hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'s_MaskOP_jpop');
    set(hb,'position',[0.79643 0.36071 0.1 0.04],'string',{'a' 'b'},...{'infobox' 'dd'},...
        'backgroundcolor','w','foregroundcolor',['b'],...
        'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
end
% str={'none' 'a>0' 'a==1' 'a==2' 'a~=0'};
model = javax.swing.DefaultComboBoxModel(v.threshlist);
[jCombo hb] = javacomponent('javax.swing.JComboBox', [0 0 100 100], gcf);
set(hb,'units','norm');
jCombo.setModel(model);
jCombo.setEditable(true);
% jCombo.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, 14))
javaLangString=jCombo.getFont;
FSsize=get(javaLangString,'Size');
jCombo.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, FSsize-5));
% set(jCombo,'ActionPerformedCallback',@cb_adjustIntensity_value);
% set(hb2,'tag', 'cb_adjustIntensity_value');
set(hb,'userdata', jCombo);
set(hb,'position',[0.46964 0.54881 0.12 0.04]);
set(hb,'tag','s_MaskOP_jpop');
h(end+1,:)={get(hb,'tag') 'java'  '' };


%% ----fuse OP final MASK with IMAGE-----------
% txt fuse operation-apply with mask
hb=uicontrol('style','text','units','norm', 'tag'  ,'s_IMGfuseOP_txt');
set(hb,'position',[0.35536 0.49643 0.1 0.04],'string','Fuse OP. ',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
set(hb,'HorizontalAlignment','right');
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };

set(hb,'tooltipstring',[...
    'COMBINE "FINAL-MASK" and "USED-IMAGE"' char(10) ...
    'defines how to combine "FINAL-MASK with the "USED-IMAGE" ' char(10)...
    '"FINAL-MASK" is either the drawn mask or the FUSED MASK of drawn mask and mask2' char(10) ...
    '"USED-IMAGE" is either the input image or another image' char(10) ...
    'voxelwise multiplication (.*) is standard' ...
    ]);

% edit fuse operation-apply with mask
hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'s_IMGfuseOP_pop');
set(hb,'position',[0.46964 0.51071 0.1 0.04],'string',{'.*' '+' '-' './'},...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',['b'],...
    'horizontalalignment','right','fontsize',7,'fontweight','bold','value',1);
set(hb,'visible','on');
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };



%%  ============output value not zero ==================================
% img: outputvalue-txt
hb=uicontrol('style','text','units','norm', 'tag'  ,'s_IMGoutputValueNot0_txt');
set(hb,'position',[0.35536 0.46071 0.15 0.04],'string','output value ~=0',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
set(hb,'HorizontalAlignment','right');
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };


set(hb,'tooltipstring',[...
    'Final Output, REPLACE NONZERO VALUES WITH...' char(10) ...
    'default: none ... keep as is' ...
    ]);


% img: outputvalue-pull
outputvalList={'mean' 'mm'};
if 0
    hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'s_IMGoutputValueNot0_jpop');
    set(hb,'position',[0.515 0.47024 0.15 0.04],'string',outputvalList,...{'infobox' 'dd'},...
        'backgroundcolor','w','foregroundcolor',['b'],...
        'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
end

model = javax.swing.DefaultComboBoxModel(v.outputvalAssignList);
[jCombo hb] = javacomponent('javax.swing.JComboBox', [0 0 100 100], gcf);
set(hb,'units','norm');
jCombo.setModel(model);
jCombo.setEditable(true);
% jCombo.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, 14))
javaLangString=jCombo.getFont;
FSsize=get(javaLangString,'Size');
jCombo.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, FSsize-5));
% set(jCombo,'ActionPerformedCallback',@cb_adjustIntensity_value);
% set(hb2,'tag', 'cb_adjustIntensity_value');
set(hb,'userdata', jCombo);
set(hb,'position',[0.515 0.47024 0.15 0.04]);
set(hb,'tag','s_IMGoutputValueNot0_jpop');
h(end+1,:)={get(hb,'tag') 'java'  '' };

% ============output value is zero ==================================
% img: outputvalue-txt
hb=uicontrol('style','text','units','norm', 'tag'  ,'s_IMGoutputValue0_txt');
set(hb,'position',[0.35714 0.42024 0.15 0.04],'string','output value ==0',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
set(hb,'HorizontalAlignment','right');
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };

set(hb,'tooltipstring',[...
    'Final Output, REPLACE ZERO VALUES WITH...' char(10) ...
    'default: none ... keep as is' ...
    ]);


% img: outputvalue-pull
outputvalList={'mean' 'mm'};
if 0
    hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'s_IMGoutputValue0_jpop');
    set(hb,'position',[0.51429 0.42976 0.15 0.04],'string',outputvalList,...{'infobox' 'dd'},...
        'backgroundcolor','w','foregroundcolor',['b'],...
        'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
end

model = javax.swing.DefaultComboBoxModel(v.outputvalAssignList);
[jCombo hb2] = javacomponent('javax.swing.JComboBox', [0 0 100 100], gcf);
set(hb2,'units','norm');
jCombo.setModel(model);
jCombo.setEditable(true);
% jCombo.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, 14))
javaLangString=jCombo.getFont;
FSsize=get(javaLangString,'Size');
jCombo.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, FSsize-5));
% set(jCombo,'ActionPerformedCallback',@cb_adjustIntensity_value);
% set(hb2,'tag', 'cb_adjustIntensity_value');
set(hb2,'userdata', jCombo);
set(hb2,'position',[0.51429 0.42976 0.15 0.04]);
set(hb2,'tag','s_IMGoutputValue0_jpop');


% ==============================================
%%   save file .name + ui
% ===============================================
% pb setfilename
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'s_setfilename_save_btn');
set(hb,'position',[0.54464 0.10119 0.2 0.04],'string','save as..',...{'infobox' 'dd'},...
    'foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',{@getfile,'savename' });

set(hb,'tooltipstring',[...
    'SELECT/SPECIFY OUTPUT FILE NAME ' char(10) ...
    'Save output as ... select or type output filename via GUI' char(10) ...
   '.. NIFTI-format' char(10) ...
    ]);

% ed-setfilename
hb=uicontrol('style','edit','units','norm', 'tag'  ,'s_setfilename_save_ed');
set(hb,'position',[0.54464 0.063095 0.2 0.04],'string','..filename..',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',[0.7490         0    0.7490],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',@filename_ed);
if ~isempty(v.fi_save)
    set(hb,'string',v.fi_save);
end
hgfeval(get( hb ,'callback'),hb);
set(hb,'tooltipstring',[...
    'output filename ' char(10) ...
    '.. NIFTI-format' char(10) ...
    ]);

% ==============================================
%%   buttons
% ===============================================

% save
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'s_savefile');
set(hb,'position',[0.63929 0.017857 0.1 0.04],'string','save',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',[0.9294    0.6941    0.1255],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold');
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',{@s_savefile,'save'});
set(hb,'tooltipstring',[...
    'save output now' char(10) ...
    'filename has to be specified before' char(10) ...
    ]);

%% testplot1
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'s_testsavefile');
set(hb,'position',[0.50893 0.017857 0.13 0.04],'string','show output',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',[0.9294    0.6941    0.1255],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold');
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',{@s_savefile,'test'});
set(hb,'tooltipstring',[...
    'TESTPLOT' char(10) ...
    'makes a figure to examine the output ' char(10) ...
    '..can be helpful before hitting the [save] button ' char(10) ...
    ]);

%% close
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'s_close');
set(hb,'position',[0.83929 0.017857 0.1 0.04],'string','close',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',[0.9294    0.6941    0.1255],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold');
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',str2func( get(hb,'tag')));
set(hb,'tooltipstring',['close this figure']);
 
% help
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'s_help');
set(hb,'position',[0.33929 0.017857 0.1 0.04],'string','help',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',[0.9294    0.6941    0.1255],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold');
h(end+1,:)={get(hb,'tag') get(hb,'style')  get(hb,'string') };
set(hb,'callback',str2func( get(hb,'tag')));
set(hb,'tooltipstring',['get some help']);



v.h=h;
set(gcf,'userdata',v);

return




% ==============================================
%%   masking IMAGE [MI]
% ===============================================
% ---------------
% txt fuse operation-apply with mask
hb=uicontrol('style','text','units','norm', 'tag'  ,'s_txtMI_head');
set(hb,'position',[0.52321 0.28214 0.2 0.04],'string','Masking Image Specs ',...{'infobox' 'dd'},...
    'backgroundcolor','w','foregroundcolor',['k'],...
    'horizontalalignment','left','fontsize',7,'fontweight','bold','value',1);


% +++ access to javaComboBox ++++
% hb=findobj(gcf,'tag','s_editMaskOP')
% hj=get(hb,'userdata')
% char(hj.getSelectedItem)


