

function check_coreg


pa=antcb('getsubjects');
img={};
for i=1:size(pa,1)

    pas=pa{i};
    [~, id]=fileparts(pas);
   
    
    % pas='O:\data\karina\dat\s20141009_01sr_1_x_x';%BAD (1st folder)
    % pas='O:\data\karina\dat\s20141217RosaHD52eml_1_x_x';
    % doelastix('transform'  , [],    {fullfile(pas,'c1t2.nii') } ,3,'local' )
    
    f1=fullfile(pas,'AVGT.nii');
   f2=fullfile(pas,'x_t2.nii');
%     f1=f2

    numbertag=['\color{black} [' num2str(i)   '] \color{blue}'];

if    exist(f1)~=2 | exist(f2)~=2
    ms={[numbertag  id]};
    m1=zeros(10,10);
    m2=m1;
else
    
    [co]=round(voxcalc([0 0 0],f2,'mm2idx'));
    
    m1=getslice(f2,co(2),2,0);
    m2=getslice(f1,co(2),2,0)/10;
    
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    s1= (m1(1:20,:));
    s2= (m1(end-19:end,:));
    r=s1-s2;
    st=[];
    for j=1:size(s1,2);
        [h p c s]=ttest(r(:,j));
        st(j,:)=[s.tstat h p];
    end
    
    isig=find(st(:,2)==1);
    
    percSig   =length(isig)/size(st,1)*100;
    dirPerc   =(sum(sign(st(isig,1)))./length(isig))*100;
    dirPercAbs=(sum(sign(st(isig,1)))./size(st,1))*100;
    if dirPerc>0
        tag=['\color{magenta} ' 'orientation-MISMACTH'   ' \color{black}'] ;
    else
        tag=['\color{green} ' 'orientation-is-correct'   ' \color{black}'] ;
    end
    
    %     [ '' tag ', prob=' num2str(dirPercAbs) '%): basis: from ' num2str(size(st,1)) ' test, ' num2str(percSig) ' showed sig. differences(100%), from this, ' num2str(abs(dirPerc)  ) '% of the tests support this assumption' ]
    
    ms={[numbertag  id]};
    ms{end+1,1}=[ tag ', prob=' num2str(dirPercAbs) '%'];
    ms{end+1,1}=['..from ' num2str(size(st,1)) ' test ' num2str(percSig) ' showed sig. diffs'];
    ms{end+1,1}=['..' num2str(abs(dirPercAbs)  ) '% of thest profe that'];
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
end
    
    v={ m1 m2 [ms]}';
    img=[img;v];
    
end


% create fan-shaped coordinates
% [R,PHI] = meshgrid(linspace(1,2,5), linspace(0,pi/2,10));
% [R,PHI] = meshgrid(linspace(1,2,5), linspace(1,2,5));

% X = R.*cos(PHI); Y = R.*sin(PHI);
% X=PHI;
% Y=PHI;
% X = X(:); Y = Y(:);
% num = numel(X);


% ndown=5
ndown=size(pa,1);
nright=3;
[x y]=meshgrid(1:nright,1:ndown);
x= (x');
y= (y');
x=x(:);y=y(:);



X=x;
Y=y;
num = numel(X);

% pas='O:\data\karina\dat\s20141217RosaHD52eml_1_x_x';
% f1=fullfile(pas,'AVGT.nii');
% f2=fullfile(pas,'x_t2.nii');
% f3=f1;
% 
% [co]=round(voxcalc([0 0 0],f2,'mm2idx'));
% 
% % m1=getslice(f2,co(2),2,0);
% m2=getslice(f3,co(2),2,0);
% img=m2;
% 
%     

% images at each point (they don't have to be the same)
% img = imread('coins.png');
% img = repmat({img}, [num 1]);

% plot scatter of images
SCALE = 1;             % image size along the biggest dimension

slidwid=.02;
figure('color','w','units','norm');
u=uicontrol('style','slider','units','normalized');
set(u,'position',[1-slidwid 0 slidwid 1]);
set(u,'value',get(u,'max'),'tag','slid');

for i=1:num
    if isnumeric(img{i})
        try
        [h w] = size(img{i});
        if h>w
            scaleY = SCALE;
            scaleX = SCALE * w/h;
        else
            scaleX = SCALE;
            scaleY = SCALE * h/w;
        end
        scaleX = SCALE;
        scaleY = SCALE;
        xx = linspace(-scaleX/2, scaleX/2, h) + X(i);
        yy = linspace(-scaleY/2, scaleY/2, w) - Y(i);
        
        % note: we are using the low-level syntax of the function
        im=img{i};
        im=im-min(im(:)); im=im./max(im(:));
        imagesc('XData',xx, 'YData',fliplr(yy), 'CData',im, 'CDataMapping','scaled');
        end
    end
    if i==4
%        'a' 
    end
    if ischar(img{i}) | iscell(img{i})
       h=10;w=10;
       scaleX = SCALE;
        scaleY = SCALE;
        xx = linspace(-scaleX/2, scaleX/2, h) + X(i);
        yy = linspace(-scaleY/2, scaleY/2, w) - Y(i);
        
        img{i}=strrep(img{i},'_','\_');
%         mode(i,nright)
        if mod(i,nright)==1
            try
                i
                tagtx=['\color{blue} ' num2str(((i-mod(i,nright))/nright)+1) '. \color{black}'];
                img{i}=[tagtx img{i}];
            end
            
        end
        
        text(xx(1),scaleX/2+yy(1),img{i},'fontsize',7);%'interpreter','latex'
%         text(.3,-1.5,'bla')
    end
    
end
% axis image, axis ij
 colormap gray, 
%colorbar
 set(gca, 'CLimMode','auto')
set(gca,'units','normalized')

% axis normal

pos=get(gca,'position');
set(gca,'position',[0 -1 .98 3]);
ndisp=2;
% ndisp=round(diff(ylim)./diff(xlim))



sb=[ndown nright];
npanels=(sb(1))/5;%/ndisp)
pos=get(gcf,'position');
% fc= 1/(pos(3))


p=[0.01 -(npanels-1)+.1 .98 npanels];
set(gca,'position',p)

 axis image


us=[];
us.ax=gca;
% us.stp=stp;
us.p=p;
% us.up=up;
set(u,'userdata',us);
set(u,'callback',{@slidupdate});
axis off;

set(gcf,'WindowScrollWheelFcn',@sliderupdate);
set(gcf,'WindowKeyPressFcn',@keybz);

p2=p;
p2(:,2)=p2(:,2)-.1;
set(gca,'position',p2);


if 1
    yl=ylim;
    xl=xlim;
%     yl=[ceil(yl(1)) floor(yl(2))];
    xl=[ceil(xl(1)) floor(xl(2))];
    yls=yl(1):.1:yl(2);
    for i=1:length(yls)
        hline(yls(i),'color','r');
    end
    xls=xl(1):.1:xl(2);
    xls=[.5:.1:2.5];
    for i=1:length(xls)
        vline(xls(i),'color','r');
    end
    
end


%% callback
function sliderupdate(hf,e)


sign(e.VerticalScrollCount);
u=findobj(gcf,'tag','slid');
% stp=get(u,'SliderStep');
stp=[.1 .025];
nval=get(u,'value')+stp(2).*-sign(e.VerticalScrollCount);
if nval>1; nval=1; end
if nval<0; nval=0; end
set(u,'value',nval);
slidupdate([],[])

function slidupdate(u,e)

u=findobj(gcf,'tag','slid');
us=get(u,'userdata');
ax=us.ax;
p=us.p;


% return

val=1-get(u,'value');
% yr=[min(p(:,2)) max(p(:,2))];
yr=p(:,2);

stp=abs(min(yr)*val);

if val==0
%     stp=stp-.05;
    stp=stp-.1;
elseif val==1
    stp=stp+.05;
end

p2=p;
p2(:,2)=p2(:,2)+stp;
set(ax,'position',p2);
 

function keybz(h,e)

if strcmp(e.Key,'g')
    li=findobj(gcf,'type','line');
    if strcmp(get(li(1),'visible'),'on')
       set(li,'visible','off'); 
    else
        set(li,'visible','on');
    end
end








