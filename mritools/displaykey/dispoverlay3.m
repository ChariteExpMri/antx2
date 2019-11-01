
function dispoverlay3(img1all,img2,namestr)

% FOR MULTIPLE PATHS
% dispoverlay2(paths,img2 )
% paths: cell of paths
% img2 : referenceImage


if ~iscell(img1all);     img1all={img1all}; end
% if ~iscell(img1all);     img1all={img1all}; end

global ovl     ;
ovl.img1all=img1all;
ovl.img2 =img2 ;
ovl.n        =1    ;
ovl.doloop   =1;
%====================================




while ovl.doloop==1
% for i=6:size(paths,1)
   i=ovl.n ;
%     [t] = spm_select('FPList',[paths{i}  ],'^s.*nii$')
    img1=img1all{i};
    [pa fi fmt]=fileparts(img1);
    if ~isempty(pa);     cd(pa);end
%     img1=t;%char(t);
    ovl.img1={[fi fmt]};
    %     img2= 'V:\mritools\tpm\pgreyr62.nii'


    if ~exist('namestr') || isempty(namestr)
        namestr= [num2str(i) '/'  num2str(length(img1all)) ' - ' fi];
    end
    overlay(img1,img2,namestr)


 end



function overlay(img1,img2,namestr)



displaykey2(img1,img2);
delete(findobj(gcf,'tag','pb'))

%% colorize 'Reorient images...'-BUTTON
try
    hgr=findobj(0,'tag','Graphics');
    hRI=findobj(hgr,'string','Reorient images...');
    set(hRI,'BackgroundColor',[ 1.0000    0.6941    0.3922]);
end


% [pa fi]=fileparts(t);
units=get(gcf,'units');

% namestr
% message=[['bgrIMG: ' img1 ] (char(10)) ['ovlIMG: ' img2 ]]

set(gcf,'units','normalized');
pb= uicontrol('Style', 'push','units','normalized',...
    'String',''  ,...%namestr,...
    'Position', [.1 .95  .8 .05],'backgroundcolor',[1 1 1],'tag','pb','fontsize',9);
set(pb,'HorizontalAlignment','left');


r= ['<HTML>'...<b>
    '<FONT COLOR="black">dooftag1'  '<br>'... '<br style="margin: 2px">'...
    '<FONT COLOR="blue">dooftag2'  '<br>'...
    '<FONT COLOR="red">dooftag3' ...
    '</HTML>'
    ];
if ~exist('namestr') && isempty(namestr);
    namestr='';
end
r=strrep(r,'dooftag1', namestr);
r=strrep(r,'dooftag2', ['bgrIMG: ' img1 ]);
r=strrep(r,'dooftag3', ['ovlIMG: ' img2 ]);
set(pb,'string',r);


if 0 ;        delete(pb)   ; end

if 1  
   if 0
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
   end
    
   bgcol=[ 0.9412    0.9412    0.9412];
   xx=.7065;
   yy=.55;
   sizbut=[.13 .025];
   
   if 0
       %% 'reorientIMAGE'
       pb= uicontrol('Style', 'pushbutton', 'String', 'reorientIMAGE',...
           'Position', [xx yy sizbut],'units','normalized','backgroundcolor',[0 1 0],'tag','pb','fontsize',9);
       iptaddcallback(pb, 'callback', 'spm_image(''reorient'')') ;
       iptaddcallback(pb, 'callback', 'uiresume(gcf)') ;
       iptaddcallback(pb, 'callback', 'drawnow;overlay(img1,img2,namestr)') ;
       %    iptaddcallback(pb, 'callback', 'uiresume(gcbf)') ;
   end

    %% cancel/END
    pb= uicontrol('Style', 'pushbutton', 'String', 'END',...
        'Position',  [xx+sizbut(1) yy sizbut],'units','normalized',...%'Position', [450 500 50 40],...
        'backgroundcolor',[ 1 .4 .4],'tag','pb','fontsize',9,...
        'callback', {@task,nan},...
        'tooltip','end the "BUSY mode" (no other changes ..)"') ;
    set(pb,'keypressfcn','eval(get(gcbf,''keypressfcn''))');
    
      %% HELP
    pb= uicontrol('Style', 'pushbutton', 'String', '?',...
        'Position',  [xx+sizbut(1)*2 yy sizbut(1)/3 sizbut(2) ],'units','normalized',...%'Position', [450 500 50 40],...
        'backgroundcolor',[1.0000    0.9490    0.8667],'tag','pb','fontsize',12,...
        'callback', {@task,100},...
        'tooltip','show shortcuts') ;
    set(pb,'keypressfcn','eval(get(gcbf,''keypressfcn''))');
    
    %% 2nd LINE buttons
    %% 'sliceview'
    pb= uicontrol('Style', 'pushbutton', 'String', 'sView',...
        'Position',[xx  yy-sizbut(2) sizbut(1) sizbut(2)],'units','normalized',...
        'backgroundcolor',bgcol,'tag','pb','fontsize',9,...
        'callback', {@task,4},...
        'tooltip','show slices [labs] has to be installed') ;
    set(pb,'keypressfcn','eval(get(gcbf,''keypressfcn''))');
    


    %% openDIR
    pb= uicontrol('Style', 'pushbutton', 'String', 'openDIR',...
        'Position', [xx+sizbut(1)  yy-sizbut(2) sizbut(1) sizbut(2)],'units','normalized',...
        'backgroundcolor',bgcol,'tag','pb','fontsize',9,...
        'callback', {@task,2},...
        'tooltip','open folder') ;
    set(pb,'keypressfcn','eval(get(gcbf,''keypressfcn''))');
    
    
        %% info
pb= uicontrol('Style', 'text', 'String', 'blalbla','units','normalized',...
    'Position', [xx  yy-sizbut(2)*2 2*sizbut(1) sizbut(2)],...
    'backgroundcolor',[.8 .8 .8],'tag','pb','fontsize',7,'userdata','myinfo' );
% iptaddcallback(pb, 'callback', 'uiresume(gcf)') ;
try
    set(pb,'tooltip',[['bgrIMG: ' img1 ] (char(10)) ['ovlIMG: ' img2 ]]);
end

    
end

set(gcf,'units',units);
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

if code==100%help
    evnt.Character= 'h';
    evnt.Modifier={};
    evnt.Key= 'h';
    keyb(1,evnt);
    
elseif code==1%next
    if ovl.n+1<=length(ovl.img1)
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
    
    try
        hgr=findobj(0,'tag','Graphics');
         delete(findobj(hgr,'tag','pb')); 
    end
    
    uiresume(gcf)
elseif code==2%openDIR
%     uiresume(gcf)
thispath=fileparts(ovl.img1{ovl.n});
if isempty(thispath)
   thispath=pwd; 
end
    str=['!explorer ' thispath ];
    eval(str);
elseif code==3%openDIR
    num=get(ho,'string');
    try
        num=str2num(num)
        
        if num<=length(ovl.img1) && num>=1
            ovl.n= num;
        end
        set(ho,'string','');
        uiresume(gcf)
    end
elseif code==4%pslices
    
    f2=ovl.img1{ovl.n}; 
    f1=ovl.img2;
    
    c1=gray;
    c2=autumn;
    % cmap=[c1(33:end,:); c2(1:32,:)  ]
    % cmap=[c1(33:end,:); flipud(c2(1:2:end,:))  ]
    cmap=[c1(33:end,:); repmat([1 0 0],32,1)  ];
    
    
    add=[];
    add.transparency=.6  %overlay transparency
    add.anatomicalImg=f2
    pslices(f1,[],[-8:1:8],[],'axial',add) ;
    
end
set(gcf,'CurrentObject',1);




