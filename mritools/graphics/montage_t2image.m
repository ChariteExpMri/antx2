function montage_t2image

file='t2.nii';
fil=antcb('getsubjects');
fis=stradd(fil,[filesep file],2);

d=[];
checked=0;
for i=1:size(fis,1)
    try
        [ha a]=rgetnii(fis{i});
        
        if 0
            %     [xyz xyzmm]=getcenter(ha);
            xyzmm=[0 0 0];
            [xyz u]=voxcalc(xyzmm,ha,'mm2idx');
            d0=double(rot90(squeeze(a(:,:,xyz(3)))));
        end
        d0=fliplr( rot90(a(:,:,round(size(a,3)/2))  ,-1) );
        
        if checked==0;
            sir=size(d0);
            checked=1;
        end
        d0=d0-min(d0(:));
        d0=(d0./max(d0(:)));
        
        si=size(d0);
        if all([si==sir])==0
            d0= imresize(d0,si);
        end
        d(:,:,i)=d0;
    end
end

if isempty(d)
 cprintf([1 0 1],[ 'a montage view of "t2.nii" of selected mouse-folders failed: reason no files found '  '\n']); 
 return
end

f=montageout(permute(d,[1 2 4 3]));
% fg,imagesc((f)); colormap gray

sif=size(f);
nb=size(f)./sir;

do=fliplr(round(linspace(1,sif(1)-sir(1),nb(1))))+10;%round(sir(1)/10);
re=round(linspace(1,sif(2)-sir(2),nb(2)));

co=[repmat(re(:),[nb(1) 1])   sort(repmat(do(:),[nb(2) 1]),'ascend')];
fg;imagesc((f)); colormap(gray);

pas=replacefilepath(fil,'');
for i=1:size(fis,1)
    if rem(i,2)==0; adj=20; else; adj=0;end
    hp=text(co(i,1),co(i,2)+adj,pas{i},'tag','txt','fontsize',4,'color','w','interpreter','none'    ,...
        'ButtonDownFcn',['explorer(' '''' fil{i} '''' ')'] );
end


% delete(findobj(gcf,'tag','txt'))


us.sif=sif;
us.nb =nb;
us.sir=sir;
us.pas=pas;
us.fil=fil;
us.fis=fis;

set(gcf,'userdata',us);
set(findobj(gcf,'type','image'),'ButtonDownFcn',@showinfo);


set(gcf,'name',['click <mouse name> to open folder; click on image to view mouse-specific headerInformation']);
axis off

hlin=sir(1):sir(1):sif(1)-sir(1);
for i=1:length(hlin);     hline(hlin(i),'color',[.1 .1 .1]); end

vlin=sir(2):sir(2):sif(2)-sir(2);
for i=1:length(vlin);     vline(vlin(i),'color',[.1 .1 .1]); end

set(gcf,'color','k')

%% calback
function showinfo(he,ho)
us=get(gcf,'userdata');
cp=round(get(gca,'CurrentPoint')); 
cp=cp(1,1:2);ns=[floor(cp(2)/us.sir(1)+1) floor(cp(1)/us.sir(2)+1)];
id=ns(1)*us.nb(2)-us.nb(2)+ns(2);

hb=spm_vol(us.fis(id)); hb=hb{1};
li=struct2list(hb);
disp('______________________________________________________________________')
disp(char(li));

% title(li,'fontsize',4,'HorizontalAlignment','left');


