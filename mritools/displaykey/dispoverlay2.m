
function dispoverlay2(paths,img2)

% FOR MULTIPLE PATHS
% dispoverlay2(paths,img2 )
% paths: cell of paths
% img2 : referenceImage

global ovl     ;
ovl.paths=paths;
ovl.img2 =img2 ;
ovl.n        =1    ;
ovl.doloop   =1;
%====================================




while ovl.doloop==1
% for i=6:size(paths,1)
   i=ovl.n ;
    [t] = spm_select('FPList',[paths{i}  ],'^s.*nii$')
    [pa fi fmt]=fileparts(t);
    cd(pa)
    img1=char(t);
    ovl.img1=[fi fmt];
    %     img2= 'V:\mritools\tpm\pgreyr62.nii'


    namestr= [num2str(i) '/'  num2str(size(paths,1)) ' - ' fi];
    overlay(img1,img2,namestr)


 end



function overlay(img1,img2,namestr)



displaykey2(img1,img2);
delete(findobj(gcf,'tag','pb'))


% [pa fi]=fileparts(t);

pb= uicontrol('Style', 'text', 'String',...
    namestr,...
    'Position', [350 600 200 20],'backgroundcolor',[0 1 1],'tag','pb','fontsize',9);



if 1
    bgcol=[ 0.9412    0.9412    0.9412];
    
    
    %% 'reorientIMAGE'
    pb= uicontrol('Style', 'pushbutton', 'String', 'reorientIMAGE',...
        'Position', [440 540 80 40],'backgroundcolor',bgcol,'tag','pb','fontsize',9);
    iptaddcallback(pb, 'callback', 'spm_image(''reorient'')') ;
    iptaddcallback(pb, 'callback', 'uiresume(gcf)') ;
    iptaddcallback(pb, 'callback', 'drawnow;overlay(img1,img2,namestr)') ;
    %    iptaddcallback(pb, 'callback', 'uiresume(gcbf)') ;

    %% 'sliceview'
      pb= uicontrol('Style', 'pushbutton', 'String', 'sView',...
        'Position', [520 540 80 40],'backgroundcolor',bgcol,'tag','pb','fontsize',9,...
        'callback', {@task,4}) ;
    set(pb,'keypressfcn','eval(get(gcbf,''keypressfcn''))');
    
    %% 'go to NUM'
    pb= uicontrol('Style', 'text', 'String', 'go to NUM',...
        'Position', [300 530 50 25],'backgroundcolor',[1 1 1],'tag','pb','fontsize',9)
    %    set(pb,'keypressfcn','eval(get(gcbf,''keypressfcn''))');

    pb= uicontrol('Style', 'edit', 'String', '',...
        'Position', [300 500 50 40],'backgroundcolor',bgcol,'tag','pb','fontsize',9,...
        'callback', {@task,3}) ;
    %   set(pb,'keypressfcn','eval(get(gcbf,''keypressfcn''))');

 %% previous
    pb= uicontrol('Style', 'pushbutton', 'String', 'previous',...
        'Position', [350 500 50 40],'backgroundcolor',bgcol,'tag','pb','fontsize',9,...
        'callback', {@task,-1}) ;
    set(pb,'keypressfcn','eval(get(gcbf,''keypressfcn''))');

    %% next
    pb= uicontrol('Style', 'pushbutton', 'String', 'next',...
        'Position', [400 500 50 40],'backgroundcolor',bgcol,'tag','pb','fontsize',9,...
        'callback', {@task,1}) ;
    set(pb,'keypressfcn','eval(get(gcbf,''keypressfcn''))');

    %% cancel
    pb= uicontrol('Style', 'pushbutton', 'String', 'cancel',...
        'Position', [450 500 50 40],'backgroundcolor',bgcol,'tag','pb','fontsize',9,...
        'callback', {@task,nan}) ;
    set(pb,'keypressfcn','eval(get(gcbf,''keypressfcn''))');

    %% openDIR
    pb= uicontrol('Style', 'pushbutton', 'String', 'openDIR',...
        'Position', [500 500 50 40],'backgroundcolor',bgcol,'tag','pb','fontsize',9,...
        'callback', {@task,2}) ;
    set(pb,'keypressfcn','eval(get(gcbf,''keypressfcn''))');
end


hfig=findobj(0,'tag','Graphics');
ca=findobj(hfig,'string','Reorient images...');
iptaddcallback(ca, 'callback', 'uiresume(gcf)') ;
displaykey(2)

drawnow
pos=spm_orthviews2('Pos');
spm_orthviews2('Reposition',pos);
drawnow

  ax=findobj(gcf,'type','axes');
  set(gcf,'CurrentObject',1);
%     set(ax,'keypressfcn','eval(get(gcbf,''keypressfcn''))');
% set(0,'')
uiwait(gcf);

function task(ho,cbd,    code)

global ovl

if code==1%next
    if ovl.n+1<=length(ovl.paths)
        ovl.n=ovl.n+1;
    end
    uiresume(gcf)
elseif code==-1%previous
    if ovl.n-1>=1
        ovl.n=ovl.n-1;
    end
    uiresume(gcf)
elseif isnan(code); %cancel
    ovl.doloop=0;
    uiresume(gcf)
elseif code==2%openDIR
%     uiresume(gcf)
    str=['!explorer ' ovl.paths{ovl.n} ];
    eval(str);
elseif code==3%openDIR
    num=get(ho,'string');
    try
        num=str2num(num)
        
        if num<=length(ovl.paths) && num>=1
            ovl.n= num;
        end
        set(ho,'string','');
        uiresume(gcf)
    end
elseif code==4%pslices
    
    f2=fullfile( ovl.paths{ovl.n}, ovl.img1);
    f1=ovl.img2;
    
    c1=gray;
    c2=autumn;
    % cmap=[c1(33:end,:); c2(1:32,:)  ]
    % cmap=[c1(33:end,:); flipud(c2(1:2:end,:))  ]
    cmap=[c1(33:end,:); repmat([1 0 0],32,1)  ];
    
    
    add=[];
    add.transparency=.6  %overlay transparency
    add.anatomicalImg=f2
    pslices(f1,[],[-8:1:8],'cmap','axial',add) ;
    
end
set(gcf,'CurrentObject',1);




