function montage_t2image

file='t2.nii';
fil=antcb('getsubjects');
fis=stradd(fil,[filesep file],2);
%% ===============================================
si=[250 250];
d=[];
checked=0;
isok=ones(size(fis,1));
for i=1:size(fis,1)
    if 1
        if exist(fis{i})==0
           d0=zeros(si); 
           isok(i,1)=0;
        else
            [ha a]=rgetnii(fis{i});
            
            if 0
                %     [xyz xyzmm]=getcenter(ha);
                xyzmm=[0 0 0];
                [xyz u]=voxcalc(xyzmm,ha,'mm2idx');
                d0=double(rot90(squeeze(a(:,:,xyz(3)))));
            end
            d0=fliplr( rot90(a(:,:,round(size(a,3)/2))  ,-1) );
            
            %if checked==0;
%                 sir=si;
%                 checked=1;
            %end
            d0=d0-min(d0(:));
            d0=(d0./max(d0(:)));
            
%             si=size(d0);
%             if all([si==sir])==0
%                 d0= imresize(d0,si);
%             end
            %             if isempty(d)
            %                 d(:,:,i)=d0;
            %             else
        end
        d(:,:,i)=imresize(d0,[si ]);
        %             end
        
    end
end
 sir=si;
 checked=1;
%% ===============================================
us.fs=4; %fontsize
if isempty(d)
 cprintf([1 0 1],[ 'a montage view of "t2.nii" of selected mouse-folders failed: reason no files found '  '\n']); 
 return
end

[f ns]=montageout(permute(d,[1 2 4 3]));
% fg,imagesc((f)); colormap gray

sif=size(f);
nb=size(f)./sir;

do=fliplr(round(linspace(1,sif(1)-sir(1),nb(1))))+10;%round(sir(1)/10);
re=round(linspace(1,sif(2)-sir(2),nb(2)));

co=[repmat(re(:),[nb(1) 1])   sort(repmat(do(:),[nb(2) 1]),'ascend')];
fg;
h=gcf;
set(h,'tag','montagex');
imagesc((f)); colormap(gray);

set(gcf,'WindowKeyPressFcn', @keys);

pas=replacefilepath(fil,'');
for i=1:size(fis,1)
    if rem(i,2)==0; adj=20; else; adj=0;end
    if isok(i)==0
       msg='not found';
    else
        msg=''; 
    end
    pastr=strrep(pas{i},'_', '\_');
    msg2=[ pastr '\color{magenta}' msg  ];
    hp=text(co(i,1),co(i,2)+adj,msg2,'tag','txt','fontsize',us.fs,'color','w','interpreter','tex'    ,...
        'ButtonDownFcn',['explorer(' '''' fil{i} '''' ')'] );
end

hl=1:si(1):si(1)*(ns(1)+1);
vl=1:si(2):si(2)*(ns(2)+1);
hline(hl,'color','w');
vline(vl,'color','w');
% delete(findobj(gcf,'tag','txt'))


us.sif=sif;
us.nb =nb;
us.sir=sir;
us.pas=pas;
us.fil=fil;
us.fis=fis;

set(gcf,'userdata',us);
set(findobj(gcf,'type','image'),'ButtonDownFcn',@showinfo);


set(gcf,'name',['montage [' file ']'],'numbertitle','off');
axis off

% hlin=sir(1):sir(1):sif(1)-sir(1);
% for i=1:length(hlin);     hline(hlin(i),'color',[.1 .1 .1]); end
% 
% vlin=sir(2):sir(2):sif(2)-sir(2);
% for i=1:length(vlin);     vline(vlin(i),'color',[.1 .1 .1]); end

set(gcf,'color','k');
xlim([vl(1) vl(end)]);
ylim([hl(1) hl(end)]);
set(gca,'position',[0 0 1 1]);

sinfo={...
    ['hit <font color="blue">animal name</font> to open folder']
    ['hit <font color="blue">slice</font> to obtain NIFTI-HDR']
    ['<font color="blue"> [+/-] </font>keys to change fontsize']
    };

 addNote([],'text',sinfo,...
      'state',1,'pos',[.7  0 .3 .2],'IS',12,'fs',17);


%% calback
function showinfo(he,ho)
us=get(gcf,'userdata');
cp=round(get(gca,'CurrentPoint'));
cp=cp(1,1:2);ns=[floor(cp(2)/us.sir(1)+1) floor(cp(1)/us.sir(2)+1)];
id=ns(1)*us.nb(2)-us.nb(2)+ns(2);
if exist(us.fis{id})==2
    hb=spm_vol(us.fis(id)); hb=hb{1};
    li=struct2list(hb);
    disp('______________________________________________________________________')
    disp(char(li));
else
    disp('______________________________________________________________________')
    cprintf([1 0 1],[ 'file not found: ' strrep(us.fis{id},filesep,[filesep filesep]) '\n']);
end

% title(li,'fontsize',4,'HorizontalAlignment','left');

function keys(e,e2)
u=get(gcf,'userdata');
h=gcf;

    
if strcmp(e2.Character,'+')
    u.fs=u.fs+1;
    set(gcf,'userdata',u);
    set(findobj(h,'tag','txt'),'fontsize',u.fs);
elseif strcmp(e2.Character,'-')
    if u.fs==1; return; end
    u.fs=u.fs-1;
    set(gcf,'userdata',u);
    set(findobj(h,'tag','txt'),'fontsize',u.fs);
end





