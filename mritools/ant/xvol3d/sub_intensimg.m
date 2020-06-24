function varargout=sub_intensimg(task,v)


 

if strcmp(task,'applychangecolor')
    applychangecolor([],[],v{1},v{2})
    return
elseif strcmp(task,'getalpha')
    
     varargout{1}=getalpha(); %getALPHA
    return
end





if 0
    if 0
        
        sub_intensimg('applychangecolor',{4,'hot'})
        
        rr=sub_intensimg('getalpha');
        %        applychangecolor(e,e2,num,cmap)
        
        sub_intensimg('setcolorrange',[0 100])
        
    end
    
    
    
    v.num=1
    v.cmap =jet;
    % tresh =[50 90]
    % tresh=[80 nan]
    v.tresh=[nan nan];
    v.thresh2=90
    v.nclass=7
    v.meth=1
    v.file=fullfile(pwd,'INCMAP_HR_n6.nii');
    sub_intensimg('show',v)
    
    
    v.cmap=cool;
    sub_intensimg('setcmpa',v)
    
    v.alpha=.2
     sub_intensimg('setalpha',v)
     
     sub_intensimg('setalpha',struct('num',1,'alpha',.1))
    
     sub_intensimg('setalpha',struct('num',1,'alpha','rampup'))
     
     sub_intensimg('delete',struct('num',1))
     
     
    v.num=2
    v.cmap =summer;
    % tresh =[50 90]
    % tresh=[80 nan]
    v.tresh=[nan nan];
    v.thresh2=90
    v.nclass=7
    v.meth=1
    v.file=fullfile(pwd,'incmap_right.nii');
    sub_intensimg('show',v)
    
    sub_intensimg('delete',2)
    
    % ==============================================
    %%   2 images
    % ===============================================
    
    v.num=1
    v.cmap =jet;
    % tresh =[50 90]
    % tresh=[80 nan]
    v.tresh=[nan nan];
    v.thresh2=90
    v.nclass=7
    v.meth=1
    v.file=fullfile(pwd,'INCMAP_HR_n6.nii');
    sub_intensimg('show',v)
    
    v2.num=2
    v2.cmap =summer;
    % tresh =[50 90]
    % tresh=[80 nan]
    v2.tresh=[nan nan];
    v2.thresh2=90
    v2.nclass=7
    v2.meth=1
    v2.file=fullfile(pwd,'incmap_right.nii');
    sub_intensimg('show',v2)
    
    v4.num=4
    v4.cmap ='summer';
    % tresh =[50 90]
    % tresh=[80 nan]
    v4.tresh=[nan nan];
    v4.thresh2=90
    v4.nclass=7
    v4.meth=1
    v4.file=fullfile(pwd,'INCMAP_HR_n6.nii');
    sub_intensimg('show',v4)
    
    
    
    v.num=3;
    v.cmap =cool;
    % tresh =[50 90]
    % tresh=[80 nan];
    v.tresh=[nan nan];
    v.thresh2=1 ;
    v.nclass=7  ;
    v.meth=2    ;
    v.file=fullfile(pwd,'x_masklesion.nii');
    sub_intensimg('show',v);
   
    if 0
    sub_intensimg('delete',3);
    sub_intensimg('delete',2);
    sub_intensimg('delete',4);
    end
    
    % ==============================================
    %%  
    % =============================================== 
    
     sub_intensimg('delete',1)
      sub_intensimg('delete',2)
       sub_intensimg('delete',3)
     
end


if     strcmp(task,'show');           show(v)
elseif strcmp(task,'setcmpa');     setcmap(v)
elseif strcmp(task,'setalpha');     setalpha(v)
elseif strcmp(task,'delete');      deletex(v)
    
elseif strcmp(task,'getcmap');             varargout{1}=getCmaplist();   
elseif strcmp(task,'setcolorrange');      setcolorrange(v)

    
    
end



function show(v)

fn=fieldnames(v);
for i=1:length(fn)
    evalc([fn{i} '= getfield(v,fn{i});']);
end

try
    if exist( 'thresh2' )==0
        thresh2=tresh2;
    end
end


[hinc inc0]=rgetnii(file);
% ==============================================
%%   incidencemap-1
% ===============================================
% num   =1;
% incol =jet;
% % tresh =[50 90]
% % tresh=[80 nan]
% tresh=[nan nan];
% thresh2=90
% nclass=3
% 
% meth=2





addpath(fullfile(fileparts(which('xvol3d.m')),'smoothpatch_version1b'));
inc=inc0;
delete(findobj(findobj(0,'tag','xvol3d'),'tag',['img' num2str(num) ]));

if meth==2
    inc(inc<thresh2)=0;
    unis=thresh2;
    uni2=unique(inc0); uni2(uni2==0)=[];
     range=[ min(uni2)  thresh2];
%      ta=[ [1:2]'  range(:) ];
     ta=[ [nan 2]'  range(:) ];
end



if meth==1
    % if ~isnan(tresh(1))==1; inc(inc<tresh(1))=nan; end
    % if ~isnan(tresh(2))==1; inc(inc>tresh(2))=nan; end
    if ~isnan(tresh(1))==1; inc(inc<tresh(1))=tresh(1); end
    if ~isnan(tresh(2))==1; inc(inc>tresh(2))=tresh(2); end
    
    chkuni=unique(inc0); chkuni(chkuni==0)=[];
    if nclass>length(chkuni);
        nclass=length(chkuni);
    end
    
    if ~isempty(nclass)
    
    [ots sep]=otsu(inc(:),nclass+1);
    inc=reshape(ots,[hinc.dim]);
    inc(inc==1)=0;
    else
        
        disp(['EXAMPLE ranges as groups: ''30:40 41:50 51:60'' ']);
        disp(['  this groups values between 30 and 40 in grp-1']);
        disp(['  this groups values between 41 and 50 in grp-2']);
        disp(['  this groups values between 51 and 60 in grp-3']);
       sin= input('select ranges as groups : ', 's');
       % 40:50 51:60 61:70 71:80 81:90 91:100
        ranges=strsplit(regexprep(sin,{'\s+' ';+'}, {';'}),';');
        inc2=inc(:);
        ots=zeros(size(inc2));
        for i=1:length(ranges)
            ra=str2num(ranges{i});
            if length(ra>1)
               ots( (inc2>=ra(1) & inc2<=ra(end)) ) =i;
            else
                ots( inc2==ra(1) ) =i;
            end
        end
        ots=reshape(ots,[hinc.dim]);
        inc=ots;
        
    end
    
    unis=unique(inc) ;
    unis(unis==0)=[];
    
    % unis(unis==max(unis))=[];
    unis(isnan(unis))=[];
    
    tg=[ots(:) inc0(:)];
    ta=[]; %classtable
    for i=1:length(unis)
        %         iv=min(find(tg(:,1)>=unis(i)));
        %         ta(i,:)=[tg(iv,:)];
        
        
        valx     =max(inc0(find(ots==unis(i))));
        ta(i,:) = [unis(i) valx];
        
    end
    
end

unis=unis-.005;
disp(unis(:)');

cmap2=getcolor(cmap);
incol=cmap2;
ixcol=round(linspace(1,size(incol,1),length(unis)));


hf=findobj(0,'tag','xvol3d');
figure(hf);
axes(findobj(findobj(0,'tag','xvol3d'),'tag','ax0'));
hold on
try; 
    delete(hp2); 
end
hp2=[];
nc=1;
iuse=zeros(length(unis),1);
for i=1:length(unis)
    FV = isosurface(inc,unis(i));
    if ~isempty(FV.vertices)
        try
        FV2=smoothpatch(FV,1,10);  % Calculate the smoothed version
        disp([i nc]);
        catch
          FV2=FV;  
        end
        
        hp=patch(FV2,'FaceColor',incol(ixcol(i),:),'EdgeAlpha',0,...
            'facealpha',0.1,'tag',['img' num2str(num) ], 'userdata',i);
        if i==length(unis)
            set(hp, 'facealpha',.2);
        end
        hp2(nc)=hp;
        nc=nc+1;
        iuse(i,1)=1;
    end
end
% set color again  
ixcol=round(linspace(1,size(incol,1),length(hp2)));
for i=1:length(hp2)
    set(hp2(i),'FaceColor',incol(ixcol(i),:));
end

% view(3); camlight
axis vis3d
rotate3d on

% cbar
delete(findobj(findobj(0,'tag','xvol3d'),'tag',['ax' num2str(num)]));
ax=axes('position',[.5 .5 .2 .2],'tag',['ax' num2str(num)]);

% if num==1
%     set(ax,'position',[.01  .01 .015 .25]);
% else
xwid=.08;
set(ax,'position',[.01+num*xwid-xwid  .06 .015 .25]);

% end
% hold on;
% set(ax,'hittest','on');
im=image(permute(incol,[1 3 2]));        % set(im,'hittest','off');
set(get(im,'parent'),'tag',['ax' num2str(num)]);
set(ax,'ydir','normal','YAxisLocation','right');
if meth==1
    tcb=[ixcol(find(iuse))' ta(find(iuse),2)];
    cblab=cellfun(@(a){ [ sprintf('%05.2f',a) ]}, num2cell(tcb(:,2)) );
    ticks=tcb(:,1);
elseif meth==2
    cblab=cellfun(@(a){ [ sprintf('%05.2f',a) ]}, num2cell(ta(:,2)) );
    ticks=[1 ixcol];
end
set(ax,'ytick',ticks, 'yticklabel',cblab,'fontsize',5,'fontweight','bold'); 
set(ax,'hittest','on','ButtonDownFcn',@changecolor);
set(im,'hittest','off');
set(ax,'userdata',num);

%------ settng up 2nd userdata field
us.ta=ta;  %colorrange


%

setappdata(ax,'file',file);
setappdata(ax,'cmap',cmap);
setappdata(ax,'userdata2',us);


xvol3d('updateIMGparams',num);
axes(findobj(findobj(0,'tag','xvol3d'),'tag','ax0'));

%
if 0
delete(findobj(findobj(0,'tag','xvol3d'),'tag',['img' num2str(num) ]))
end

function numx=getIMGnum()
hs=findobj(0, 'tag','winselection');
hr=findobj(hs, 'tag','currentimg');
li=get(hr,'string');
va=get(hr,'value');
c=li{va};
if strcmp(c,'empty'); return; end
numx=str2num(regexprep(c,'].*',''));

function setcolorrange(crange)
% warning on;
% warning('rr');
if isempty(crange); crange=[nan nan]; end

num=getIMGnum();

hf=findobj(0,'tag','xvol3d');
ha=findobj(hf,'tag',['ax' num2str(num)]);
if isempty(ha); return; end

hi=findobj(ha,'type','image');
cmap=squeeze(get(hi,'CData'));

us=getappdata(ha,'userdata2');
hp=findobj(hf,'tag',['img' num2str(num)]);

if length(hp)>1
    [~,isort]=sort(cell2mat(get(hp,'userdata')));
    hp=hp(isort);
end

% % crange=[nan nan];
% crange=[0 nan ];
% crange=[5 90];
% crange=[nan nan];
ta=us.ta;
ta(:,3)=1; %indicate path
% if find(ta==crange(1)); crange(1)=nan; end %find douplettes
% if find(ta==crange(2)); crange(2)=nan; end  

% % add color-limits if specified
% if       ~isnan(crange(1)) &&  isnan(crange(2))
%     ta=[[nan crange(1) 0]; ta  ];
% elseif   isnan(crange(1)) &&  ~isnan(crange(2))
%     ta=[ ta ;[nan crange(2) 0]; ];
% elseif  ~isnan(crange(1)) &&  ~isnan(crange(2))
%     ta=[[nan crange(1) 0]; ta ;[nan crange(2) 0]; ];
% % else
% %     'd' %add no outer c-limits
% end
ta=[[nan crange(1) 0]; ta ;[nan crange(2) 0]; ] ;

% if outer limits are not min/max value
ta(ta(:,2)<ta(1  ,2),2)   =ta(1  ,2);
ta(ta(:,2)>ta(end,2),2)   =ta(end,2);


if isnan(ta(1,2))   ; ta(1,:)=[]; end   %remove NAN entry
if isnan(ta(end,2)) ; ta(end,:)=[]; end

aa=ta(:,2);
bb=aa./(max(aa)-min(aa));
icol=round((bb-min(bb))*63)+1;

% setting patch-color ---------------------------------------------
% ip=find(ta(:,3)==1);
ip=find(ta(:,3)==1 & ~isnan(ta(:,1))); 
for i=1:length(ip)
    try
        set(hp(i) ,'facecolor', cmap(icol(ip(i)),:)   );
    end
end

% setting cbar-ticks  ------------------------------------------------------
tc=[icol ta(:,2) ];  %prevent similar entries
[~,is]=unique(tc(:,1));
tc=tc(is,:);

hs=findobj(0, 'tag','winselection');
labmode=get(findobj(hs,'tag','cbarlabelmode'),'value');
if labmode==1
    tc=tc([1 end],:);
end

set(ha,'ytick',tc(:,1));
% cblab=cellfun(@(a){ [ sprintf('%05.2f',a) ]}, num2cell(tc(:,2)) ) ; 
cblab=cellfun(@(a){ [ sprintf('%5.2f',a) ]}, num2cell(tc(:,2)) )   ;
set(ha,'yticklabel',cblab);

% % % % ta=[[nan crange(1)]; ta ;[nan crange(2)]; ];
% % % 
% % % %% test
% % % 
% % % aa=[0 2 3  100]
% % % bb=aa./(max(aa)-min(aa))
% % % bb=round((bb-min(bb))*63)+1



% ==============================================
%%   new color
% ===============================================

function setcmap(v)
hp2=findobj(findobj(0,'tag','xvol3d'),'tag',['img' num2str(v.num) ]);
if length(hp2)>1
    [~,isort]=sort(cell2mat(get(hp2,'userdata')));
    hp2=hp2(isort);
end

% newcol=(v.cmap);
% newcol=(jet); newcol=newcol(round(size(newcol,1)/2):end,:)
newcol=v.cmap;
% newcol=repmat([1 0 0],[64 1])
icol=round(linspace(1,size(newcol,1),length(hp2)));

for i=1:length(hp2)   
    set(hp2(i),'facecolor',newcol(icol(i),:));
end
ax2=findobj(gcf,'tag',['ax' num2str(v.num)]);
im=get(ax2,'children');
set(im,'cdata',permute(newcol,[1 3 2]));






function changecolor(e,e2)
num=get(e,'userdata');
hl=uicontrol('style','listbox','units','norm','position',[.1 .9 .1 .8]);
set(hl,'position', [.85 0 .15 1],'tag','cmapselect');
% set(hl,'string',{...
%     'parula','jet' 'hot' 'cool' 'summer' 'autumn' 'winter' 'gray' 'copper' 'pink' ...
%     'parulaFLIP','jetFLIP' 'hotFLIP' 'coolFLIP' 'summerFLIP' 'autumnFLIP' 'winterFLIP' 'grayFLIP' 'copperFLIP' 'pinkFLIP' ...
%     '@yellow'  '@orange' '@red' '@green' '@blue'  'user'});
cmaplist=getCmaplist();
set(hl,'string',cmaplist);


set(hl,'callback',{@applychangecolor,num});
axes(findobj(findobj(0,'tag','xvol3d'),'tag','ax0'));



function cmaplist=getCmaplist()
cmaplist={...
    'parula','jet' 'hot' 'cool' 'summer' 'autumn' 'winter' 'gray' 'copper' 'pink' ...
    'parulaFLIP','jetFLIP' 'hotFLIP' 'coolFLIP' 'summerFLIP' 'autumnFLIP' 'winterFLIP' 'grayFLIP' 'copperFLIP' 'pinkFLIP' ...
    '@yellow'  '@orange' '@red' '@green' '@blue'  'user'};

cnames{1,:}={'BrBG', 'PiYG', 'PRGn', 'PuOr', 'RdBu', 'RdGy', 'RdYlBu', 'RdYlGn', 'Spectral'};
cnames{2,:}={'Blues','BuGn','BuPu','GnBu','Greens','Greys','Oranges','OrRd','PuBu','PuBuGn','PuRd',...
             'Purples','RdPu', 'Reds', 'YlGn', 'YlGnBu', 'YlOrBr', 'YlOrRd'};
% cnames{3,:}={'Accent', 'Dark2', 'Paired', 'Pastel1', 'Pastel2', 'Set1', 'Set2', 'Set3'};

cnames2=[cnames{1} cnames{2}];
cmaplist=[cmaplist cnames2];



function cmap2=getcolor(cmap)
cmaplist=getCmaplist();
if isnumeric(cmap)
   cmap2=cmap;
   return
end

if strfind(cmap,'user')==1
      cc=uisetcolor();
      cmap2=repmat(cc,[64 1]); 
elseif strfind(cmap,'@')==1
    tw={...
        '@red'  [1 0 0]
        '@yellow' [  1     1     0]
        '@blue' [ 0 0 1]
        '@green' [ 0.4667    0.6745    0.1882]
        '@orange' [1.0000    0.8431         0]
        };
    
    cmap2=repmat(cell2mat(tw(find(strcmp(tw(:,1),cmap)),2)),[64 1]);
    
elseif strfind(cmap,'FLIP')
    cmap2=eval(strrep(cmap,'FLIP',''));
    cmap2=flipud(cmap2);
    
elseif ~isempty(find(strcmp(cmaplist,cmap)))
    %iv=find(strcmp(cmaplist,cmap))
    
    %      F=cbrewer(ctypes{itype}, cnames{itype}{iname}, ncol);
    
    [~,F]=evalc(['cbrewer(''div'',''' cmap ''', 64);']);
    if isempty(F)
        %             F=cbrewer('seq', cmap, 64);
        [~,F]=evalc(['cbrewer(''seq'',''' cmap ''', 64);']);
    end
    cmap2=F;
    if isempty(F)
        cmap2=eval(cmap);
    end
    
else
    cmap2=eval(cmap);
end

function applychangecolor(e,e2,num,cmap)
if exist('cmap')==0
    hb=findobj(gcf,'tag','cmapselect');
    hb=hb(1);
    li=get(hb,'string');
    va=get(hb,'value');
    cmap=li{va};
    delete(hb);
end

cmap2=getcolor(cmap);
% if strfind(cmap,'user')==1
%       cc=uisetcolor();
%       cmap2=repmat(cc,[64 1]); 
% elseif strfind(cmap,'@')==1
%     tw={...
%         '@red'  [1 0 0]
%         '@yellow' [  1     1     0]
%         '@blue' [ 0 0 1]
%         '@green' [ 0.4667    0.6745    0.1882]
%         '@orange' [1.0000    0.8431         0]
%         };
%     
%     cmap2=repmat(cell2mat(tw(find(strcmp(tw(:,1),cmap)),2)),[64 1]);
%     
% elseif strfind(cmap,'FLIP')
%     cmap2=eval(strrep(cmap,'FLIP',''));
%     cmap2=flipud(cmap2);
% else
%     cmap2=eval(cmap);
% end

hp2=findobj(findobj(0,'tag','xvol3d'),'tag',['img' num2str(num) ]);
try
    [~,isort]=sort(cell2mat(get(hp2,'userdata')));
    hp2=hp2(isort);
end

 
newcol=cmap2;
icol=round(linspace(1,size(newcol,1),length(hp2)));

for i=1:length(hp2)   
    set(hp2(i),'facecolor',newcol(icol(i),:));
end
hf=findobj(0,'tag','xvol3d');
ax2=findobj(hf,'tag',['ax' num2str(num)]);
if isempty(ax2); return; end
im=get(ax2,'children');
set(im,'cdata',permute(newcol,[1 3 2]));

setappdata(ax2,'cmap',cmap);
xvol3d('updateIMGparams',num);

axes(findobj(findobj(0,'tag','xvol3d'),'tag','ax0'));

function alpha=getalpha()
tb={'a1'
    'a2'
    'a3'
    'a4'
    'a5'
    'a6'
    'rampup'
    'rampup1'
    '.01'
    '.1'
};
tb=[tb; cellfun(@(a){ [ sprintf('%.2f',a) ]}, num2cell([0.05:.05:1]) )'];
alpha=tb;


function calcalpha()

function  setalpha(v)


hp2=findobj(findobj(0,'tag','xvol3d'),'tag',['img' num2str(v.num) ]);
if length(hp2)==1
    isort=1;
else
[~,isort]=sort(cell2mat(get(hp2,'userdata')));
end
hp2=hp2(isort);
if isnumeric(v.alpha)
    if length(v.alpha)==1
    set(hp2,'facealpha',v.alpha);
    else
        if length(v.alpha)>=length(hp2)
            for i=1:length(hp2)
                set(hp2(i),'facealpha',v.alpha(i));
            end
        else
            disp(['number of transparency values must equal the number of patches (' num2str(length(hp2)) ') or use one common value  ']);
        end
    end
    
 elseif strcmp(v.alpha,'a1')   
     alpha=linspace(0.1,1,length(hp2)).^1;
    for i=1:length(hp2);         set(hp2(i),'facealpha',alpha(i));     end
   elseif strcmp(v.alpha,'a2')   
     alpha=ones(1,length(hp2)).*.2
    for i=1:length(hp2);         set(hp2(i),'facealpha',alpha(i));     end   
elseif strcmp(v.alpha,'a3')
    alpha=ones(1,length(hp2)).*.1; alpha(end)=1;
    for i=1:length(hp2);         set(hp2(i),'facealpha',alpha(i));     end
elseif strcmp(v.alpha,'a4')
    alpha=ones(1,length(hp2)).*.05; alpha(end)=.25;
    for i=1:length(hp2);         set(hp2(i),'facealpha',alpha(i));     end
elseif strcmp(v.alpha,'a5')
    alpha=ones(1,length(hp2)).*.035; alpha(end)=.15;
    for i=1:length(hp2);         set(hp2(i),'facealpha',alpha(i));     end 

elseif strcmp(v.alpha,'a6')
    alpha=ones(1,length(hp2)).*.025; alpha(end)=.15;
    for i=1:length(hp2);         set(hp2(i),'facealpha',alpha(i));     end 
    
    
elseif strcmp(v.alpha,'rampup')
    alpha=linspace(0.1,1,length(hp2)).^1;
    for i=1:length(hp2)
        set(hp2(i),'facealpha',alpha(i));
    end
elseif strcmp(v.alpha,'rampup1')
    alpha=ones(1,length(hp2)).*.2
    alpha(end)=1;
    for i=1:length(hp2)
        set(hp2(i),'facealpha',alpha(i));
    end  
    
    
    
else
    alf=str2num(v.alpha);
    
     if length(alf)==1
    set(hp2,'facealpha',alf);
    else
        if length(alf)>=length(hp2)
            for i=1:length(hp2)
                set(hp2(i),'facealpha',alf(i));
            end
        else
            disp(['number of transparency values must equal the number of patches (' num2str(length(hp2)) ') or use one common value  ']);
        end
    end
    
    
end
xvol3d('updateIMGparams',v.num);

function deletex(v)
if isnumeric(v) ; num=v;
else; num=     v.num;
end

hp2=findobj(findobj(0,'tag','xvol3d'),'tag',['img' num2str(num) ]);
delete(hp2);
ax=findobj(findobj(0,'tag','xvol3d'),'tag',['ax' num2str(num) ]);
delete(ax);

