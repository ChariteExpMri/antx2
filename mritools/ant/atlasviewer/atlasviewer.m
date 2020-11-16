% #ok atlasviewer (atlasviewer.m)
% display atlas (AVGT.nii + ANO.nii/ANO.xlsx)
% #b background volume: #n atlas template  (NIFTI), ..."AVGT.nii"
%       IF background volume is not defined (empty), BG-Image is defined using the ANO.nii
%       (voxels with IDs (ANO>0) in ANO become '1' in BG-Image)
% #b foreground volume: #n This is the anotation volume (NIFTI), ..."ANO.nii"
% 
% #b excel-file #n This anotation excel table contains the labels ,colors,IDs & children
%      -The filename should match with the anotation volume 
%      - EXAMPLE: for "ANO.nii" it is expected that the excelfile is "ANO.xlsx" and exists in the same
%        folder as "ANO.nii"
%     #r - If the "ANO.xlsx" is not found (does not exist) a pseudo-list with pseudo colors is created
% #b for more information see coltrol's tooltips
% ________________________________________________________________________________
% #lk *** UI controls ***
% [show montage] ICON: Shows montage of slices in another figure. if no region selected the montage
%               depicts all slices, otherwise only slices with selected regions are displayed
%               -click onto slice in montage to bring slice to main gui
% [dimension] pulldown {1,2,3}. The orientation/dimension to display.
% [flip]  flip up/down slice (radio)
% [trans] transpose slice  (radio)
% [hemi]  depicts selected region only in one hemisphere  (radio)
% [bulb]  ICON: Get some additional help.
% [x]     ICON: -deselect all regions. All regions become deselected--> no colorcoded regions
% [all]   select all regions --> all regions of the current slice will be colorized 
% [bnd]   Show region boundaries (radio)
%        -Context menu: -change boundary color
%                       -set boundary type: [1] show boundaries of selected regions only
%                                           [2] show  boundaries of all regions
%        #r displaying the boundaries is a little bit slow, so be patient...
% [transparendy] Set transparency of selection regions onto background image. {0-1}, (radio)
% [fReg]         follow region. If true (radio). Slice mit max volume of selected/clicked region is shown
%               -This changes/updates the current slice
% [magnifying glass] : open search panel to search for specific region in the left rgion listbox
% 
% 
% [slice number]   set/type slice number to display (EDIT)
% [<][>]           show prev./next slice
% [slider]         change slice  number via slider
% ________________________________________________________________________________
% #lk *** listbox ***
% hit checkbox or label of a region to show/hide this region
% hit ID of a region to shortly display the region. This works only if the region is found
%     in the current slice
% ________________________________________________________________________________
% [Separator] move listbox-image separator to chnage  listbox/axis size ratio
% ________________________________________________________________________________
% #lk *** Slice ***
% Label and ID is depicted for colored region below mouse pointer.
% Single click to highlight the region below mouse pointer in the left listbox
% Double click to select/deselect (colorize/uncolorize) the region below mouse pointer
%
%
% #lk *** command line ***
% atlasviewer()    % % no inputs... background & foregroundIMages will be selected via GUI
% atlasviewer(backgroundImage, foregroundIMage); where backgroundImage and foregroundIMage are the
% fullpath filenames of 'AVGT.nii' and 'ANO.nii', respectively.
% g EXAMPLES
% atlasviewer('F:\data3\atlasviewer_ratAtlas_test\AVGT.nii','F:\data3\atlasviewer_ratAtlas_test\ANO.nii')
% atlasviewer([],'F:\data3\atlasviewer_ratAtlas_test\ANO.nii') % % no BG-image, here BG-image is generated via anotation file ('ANO.nii')
% 
% 
% 
% 
% -----------------------
%subfunctions: 
% montage_slices.m
% fun_search.m 

% https://documented69.rssing.com/chan-25347318/all_p1.html




function atlasviewer(f1,f2)



% ==============================================
%%   file
% ===============================================
if exist('f1')~=1
    msg='select Atlas''s template file (AVGT.nii) >>>as background image';
    disp(msg);
    %[t pa]=uigetfile(fullfile(pwd,'*.nii'),msg);
    [t,sts] = spm_select(1,'any',msg,[],pwd,'.*.nii',1);
    if  isempty(t)
        t='';
    end
    f1=char(t);
end
if exist('f2')~=1
    msg='select Atlas''s Anotation file (ANO.nii) >>>as foreground image';
    disp(msg);
    %[t pa]=uigetfile(fullfile(pwd,'*.nii'),msg);
    [t,sts] = spm_select(1,'any',msg,[],pwd,'.*.nii');
    if  isempty(t);
        return;
    end
    f2=char(t);
end

[px name ext]=fileparts(f2);
f3=fullfile(px,[name '.xlsx']);




% ==============================================
%%   
% ===============================================







% ==============================================
%%
% ===============================================
atic=tic;
% 
% addpath('C:\Users\skoch\Desktop\struct2tree\getExactBounds')
% 
% f1=fullfile(pwd,'AVGT.nii') ;
% f2=fullfile(pwd,'ANO.nii') ;
% f3=fullfile(pwd,'ANO.xlsx') ;
if 0
    px='F:\data3\atlasviewer_ratAtlas_test';
    f1=fullfile(px,'AVGT.nii') ;
    f2=fullfile(px,'ANO.nii') ;
    f3=fullfile(px,'ANO.xlsx')
end

% ==============================================
%%   prepare figure
% ===============================================

delete(findobj(0,'tag','atlasviewer'));
hf=fg;
set(gcf,'pointer','watch','tag','atlasviewer','units','norm');
set(gcf,'menubar','none','NumberTitle','off','name','atlasviewer');
% disp(['time-2:' num2str(toc(atic))]);
waitspin(1,'wait...');
drawnow;
% disp(['time-1:' num2str(toc(atic))]);


% ==============================================
%%   parameter
% ===============================================

us=get(gcf,'userdata');
us.boundary_color = [1 1 1];
us.boundary_type  =1;

% ==============================================
%%   load niftis
% ===============================================
waitspin(2,['reading NIFTIs..' ]);
if isempty(f1)
    %[us.ha us.a         ]=rgetnii(f1);
    [us.hb us.b   mm    ]=rgetnii(f2); 
    
    us.ha =us.hb;
    us.a  =(us.b>0);
    
    
else
    [us.ha us.a   mm  ]=rgetnii(f1);
    [us.hb us.b       ]=rgetnii(f2);
end
us.a=mat2gray(us.a);
us.slice=round(size(us.a,2)/2);
% ==============================================
%%   mm-xyz
% ===============================================
% tic
% mm2=single(mm);
us.mm=permute(reshape(single(mm), [3 size(us.a)]),  [ 2 3 4 1] );
% toc
% tic
% mm=mm';
% us.mm=single(cat(4,reshape(mm(:,1),[size(us.a)]), reshape(mm(:,2),[size(us.a)]), reshape(mm(:,3),[size(us.a)]) ));
% toc
% ==============================================
%%   excelfile
% ===============================================

% disp(['time0:' num2str(toc(atic))]);


if exist(f3)==2
    waitspin(2,'reading xls...');
    [~,~,c]=xlsread(f3);
    c=c(:,find(~strcmp(cellfun(@(a){[ num2str(a)  ]} , c(1,:) ),'NaN')),:);
    c=c(find(~strcmp(cellfun(@(a){[ num2str(a)  ]} , c(:,1) ),'NaN')),:);
    hc=c(1,:);
    c=c(2:end,:);
    
    c(:,4)=cellfun(@(a){[ str2num(num2str(a))  ]} , c(:,4) );
    c(:,5)=cellfun(@(a){[ (num2str(a))  ]} , c(:,5) );
    c(:,5)=regexprep(c(:,5),'NaN','');
    c(:,5)=cellfun(@(a){[ (str2num(a))  ]} , c(:,5) );
    
    us.c    =c;
    us.hc   =hc;
else
    waitspin(2,'make pseudo list..');
    % ==============================================
    %%   no XLS-file
    % ===============================================
    
    hc={ 'Region'    'colHex'    'colRGB'    'ID'    'Children'};
    ID=unique(us.b(:)); ID(ID==0)=[];
    clear c2
    c2(:,4)=num2cell(ID);
    c2(:,5)={[]};
    c2(:,1)=cellfun(@(a){[ 'ID_' num2str(a)  ]} , c2(:,4) );
    col =round( distinguishable_colors(length(ID),[1 1 1; 0 0 0]).*255);
    c2(:,3)=regexprep(cellstr(num2str(col)),'\s+',' ');
    
    c=c2;
    us.c    =c;
    us.hc   =hc;
end




% disp(['time1:' num2str(toc(atic))]);

% ==============================================
%%   calc volume
% ===============================================
% tic
% ids=cell2mat(c(:,4));
% a2=us.b(:);
% a2(a2==0)=[];
% numbers=unique(a2);       %list of elements
% cnt=histc(a2,numbers); %histc is faster than hist  (produce: same results) toc
% nvox=zeros(length(ids),1);
% for i=1:length(ids)
% %     disp(i)
%     iv= cnt(numbers==ids(i));
%     if ~isempty(iv)
%         nvox(i,1) =iv;
%     end
% %     try
% %         nvox(i,1) =  cnt(numbers==ids(i));
% %     end
% end
% vol=abs(det(us.ha.mat(1:3,1:3)) *(nvox));
% us.volume=vol;
% toc

% ==============================================
%%   calc volume
% ===============================================
% clc
% tic
ids=cell2mat(c(:,4));
a2=us.b(:);
a2(a2==0)=[];
nvoxall2=single(zeros(length(ids),1));
nvox2   =nvoxall2;
for i=1:length(ids)
    %allnode=[c{i,4}];
    is=ismember(a2,c{i,4});
    try
        nvox2(i,1) =   sum(is); ; %ID volume
    end
    %allnode=[c{i,5}(:)];
    is=ismember(a2,c{i,5}(:));
    try
        nvoxall2(i,1) =   sum(is) ;%total volume +nvox2(i,1);
    end
end
nvoxall2=nvoxall2+nvox2; % adding voxel-ID to voxel-children
us.volume   =abs(det(us.ha.mat(1:3,1:3)) *(nvox2));
us.volumetot=abs(det(us.ha.mat(1:3,1:3)) *(nvoxall2));

% disp(['time2:' num2str(toc(atic))]);



% ==============================================
%%     tABLE
% ===============================================
waitspin(2,['make table..' ]);

silab=size(char(c(:,1)),2);
import com.mathworks.mwswing.checkboxtree.*
jRoot = DefaultCheckBoxNode('Root');
for i=2:size(c,1)
    l1a = DefaultCheckBoxNode([ '<html><body bgcolor="'  reshape(sprintf('%02X',str2num(c{i,3})), 6 ,[]).' ...
        '">' '<FONT color="FFFFFF">' c{i,1}  '  (Id-'  num2str(c{i,4}) ')' ...
        repmat( '&nbsp;'  ,[1 (silab+10)-length(c{i,1})])      ]);
    jRoot.add(l1a);
end
jTree = com.mathworks.mwswing.MJTree(jRoot);
jCheckBoxTree = CheckBoxTree(jTree.getModel);
jScrollPane = com.mathworks.mwswing.MJScrollPane(jCheckBoxTree);

tbh      = {'c' 'Label' 'ID'};
editable = [1    0  0  ]; %EDITABLE
colfmt   ={'logical' 'string'  'numeric'} ;
tb=[repmat({logical(0)},[size(c,1) 1]) [c(:,1) c(:,4)] ];
silab=size(char(c(:,1)),2);

%decolorize non-existing nodes
if 1
    for i=1:size(c,1)
        lab=c{i,1};
        if isempty(c{i,5})
            lab=['&#9549; '  lab];%CILD
        else
            lab=['&#9547;' lab];%MOTHER
        end
        if us.volumetot(i)==0
            dum=[ '<html><FONT color="CCBEE8">'  lab   ];
        else
            dum=[ '<html><FONT color="000000">'  lab   ];
        end
        tb{i,2}=dum;
    end
end
% disp(['time4:' num2str(toc(atic))]);

% ==============================================
%%   
% ===============================================

% colorize regCOLOR
% tic
for i=1:size(c,1)
    tb{i,3}=...
        [ '<html><body bgcolor="'  reshape(sprintf('%02X',str2num(c{i,3})), 6 ,[]).' ...
        '">' '<FONT color="000000">' num2str(c{i,4})  ...
        repmat( '&nbsp;'  ,[1 20-length(num2str(c{i,4}))     ]  )  ];
end
% toc



% [ '<html><body bgcolor="'  reshape(sprintf('%02X',str2num(c{i,3})), 6 ,[]).' ...
%         '">' '<FONT color="000000">' num2str(c{i,4})  ...
%         repmat( '&nbsp;'  ,[1 20-length(num2str(c{i,4}))     ]  )  ]
%     
%     
%     ['<html><body bgcolor="'  reshape(sprintf('%02X',str2num(a)),6,[]).' ...
%         '">' '<FONT color="000000">' num2str(b)  ...
%         repmat( '&nbsp;'  ,[1 20-length(num2str(b))     ]  )  ]
    
%  tic   
%    cv= cellfun(@(a,b){    ['<html><body bgcolor="'  reshape(sprintf('%02X',str2num(a)),6,[]).' ...
%         '">' '<FONT color="000000">' num2str(b)  ...
%         repmat( '&nbsp;'  ,[1 20-length(num2str(b))     ]  )  ] } , c(:,3),c(:,4) );
%  toc 
% ==============================================
%%   
% ===============================================

% disp(['time5:' num2str(toc(atic))]);

tb(1,:)=[]; %remove root
t = uitable('Parent', gcf,'units','norm', 'Position', [0 0 .5 .9], ...
    'Data', tb,'tag','table','fontsize',3,...
    'ColumnWidth','auto');
t.ColumnName =tbh;
t.ColumnEditable =logical(editable ) ;% [false true  ];
t.RowName=[];
% t.ColumnName=[]
set(t,'fontsize',7);
t.ColumnWidth={15 200 40};

% disp(['time5:' num2str(toc(atic))]);



us.t=t;
% set(gcf,'userdata',us);

% disp(['time6:' num2str(toc(atic))]);

%set(t,'CellSelectionCallback',@selID);
%  set(t,'CellEditCallback',@selID);
% set(t,'ButtonDownFcn',@selID);
% hj=findjobj(t);
% set(hj,'MouseClickedCallback',@selID);

ht=findobj(gcf,'tag','table');
jscrollpane = javaObjectEDT(findjobj(ht));
viewport    = javaObjectEDT(jscrollpane.getViewport);
jtable      = javaObjectEDT( viewport.getView );
set(jtable,'MouseClickedCallback',@selID)
set(jtable,'MousemovedCallback',@mousemovedTable);
% set(hj, 'StateChangedCallback', @selID);


% % % if 0
% % %
% % %     fo=uisetfont
% % %     us=get(gcf,'userdata')
% % %     font = java.awt.Font(fo.FontName,java.awt.Font.PLAIN, fo.FontSize);
% % %     us.jCheckBoxTree.setFont(font)
% % %     % us.jCheckBoxTree.repaint
% % %     %    -----
% % %
% % %     fo= get(us.jComp,'Font')
% % %
% % %     font = java.awt.Font('Tahoma',java.awt.Font.PLAIN, 11);
% % %     jFontPanel = com.mathworks.widgets.DesktopFontPicker(true, font);
% % %     [jhPanel,hContainer] = javacomponent(jFontPanel, [10,10,250,170], gcf);
% % %     jFont = jFontPanel.getSelectedFont();  % returns a java.awt.Font object
% % %     flag = jFontPanel.getUseDesktopFont();  % true if top radio-button is selected; false if custom font is selected
% % %     us.jComp.setFont(jFont)
% % % end

% import com.mathworks.widgets.fonts.FontPicker
% jFontPicker = FontPicker(font, sampleFlag, layout);
% [hjFontPicker, hContainer] = javacomponent(jFontPicker, position, gcf);

% hb=uicontrol('style','pushbutton','units','norm','position',[ .5 .5 .1 .1]);
% set(hb,'position',[ .5 .5 .1 .1],'string','<>','tag','shiftlist','callback',@shiftlist);

ha=axes('position',[.5 0 .5 1 ]);
set(gca,'tag','ax1'); axis off;


% ==============================================
%%   make controls PART-1
% ===============================================
waitspin(2,['make controls..' ]);

h33=uicontrol('style','pushbutton','string','..');
% set(h33,'cdata',handicon);
set(h33,'parent',gcf,'backgroundcolor','w');%,'callback',@slid_thresh)
set(h33,'units','norm','position',[.49 .0 .01 .9]);
set(h33,'string','','tooltipstring','drag panel ','tag','thresh_drag');
je = findjobj(h33); % hTable is the handle to the uitable object
set(je,'MouseDraggedCallback',@thresh_dragCB  );
set(h33,'string',['<html>   &#9664;<br>'],'fontsize',12);

set(gcf,'WindowButtonMotionFcn',@motion);
set(gcf,'WindowbuttonDownFcn',@clickcallback);

%% MSGBOX
ht=uicontrol('style','text','units','norm' ,'string','..');
set(ht,'position',[.51 .9 .5 .1],'backgroundcolor','k','foregroundcolor',[ 1.0000    0.8431         0]);
set(ht,'fontsize',8,'tag','msgbox');

%% enter slice number
ht=uicontrol('style','edit','units','norm' ,'string',num2str(us.slice));
set(ht,'position',[0.7 0 .05 .04]);
set(ht,'fontsize',8,'tag','ed_slice','callback',@ed_slice);
set(ht,'tooltipstring','enter slice index');

%% previous slice
ht=uicontrol('style','pushbutton','units','norm' ,'string','<');
set(ht,'position',[0.75 0 .03 .04]);
set(ht,'fontsize',8,'tag','pb_slice1','callback',{@pb_slice,-1});
set(ht,'tooltipstring','previous slice');
%% next slice
ht=uicontrol('style','pushbutton','units','norm' ,'string','>');
set(ht,'position',[0.78 0 .03 .04]);
set(ht,'fontsize',8,'tag','pb_slice2','callback',{@pb_slice,+1});
set(ht,'tooltipstring','next slice');

%% - slider thresh
hb=uicontrol('style','slider','units','norm', 'tag'  ,'sl_slice','fontsize',8);             %CHANGE-DIM
set(hb,'position',[ 0.81  0 .18 .04],'string','rw','value',0.5,'backgroundcolor','w');
set(hb,'tooltipstring',['chan' char(10) ' ']);

jSlider = javax.swing.JSlider;
[jv hv]=javacomponent(jSlider,[10,70,200,45]);
set(hv,'units','norm','position',[ 0.81  0 .18 .04])
set(jSlider, 'Minimum',1,'Maximum',size(us.a,2) ,'Value',us.slice, 'PaintLabels',false, 'PaintTicks',true);  % with ticks, no labels
% set(jSlider, 'Value',84, 'MajorTickSpacing',20, 'PaintLabels',true);  % with labels, no ticks

hjSlider = handle(jSlider, 'CallbackProperties');
% hjSlider =
% 	javahandle_withcallbacks.javax.swing.JSlider
% >> hjSlider.StateChangedCallback = @(hjSlider,eventData) disp(get(hjSlider,'Value'));
% set(hjSlider, 'StateChangedCallback', @sl_slice);
set(hjSlider, 'MouseReleasedCallback',@sl_slice);
set(hjSlider, 'KeyReleasedCallback',@sl_slice);
jSlider.setToolTipText('change slice index');
set(hv,'ButtonDownFcn',@sliderBTN);
% addlistener(hjSlider,'ContinuousValueChange',@sl_slice);
us.hslid=jSlider;

set(gcf,'WindowKeyPressFcn',@keys);
set(gcf,'userdata',us);

% ==============================================
%%   make controls PART-2
% ===============================================
%———————————————————————————————————————————————
%%   PANEL
%———————————————————————————————————————————————
pan1 = uipanel('Title','contour','FontSize',7,'units','norm', 'BackgroundColor','white',  'Position',[0 0 .5 .3]);
set(pan1,'Position',[0 .9 .5 .1],'Title','','tag','panel1','visible','on','backgroundcolor','w');
% set(pan1,'units','pixels','visible','on');
set(pan1,'BorderType','etchedout','shadowColor',[1 0 0]);
set(pan1,'BorderType','etchedout','BackgroundColor',[1 1 1]);
set(pan1,'units','pixels','visible','on');

%% clear
hb=uicontrol('style','pushbutton','string','','units','norm');
set(hb,'position',[0 .96,.03 .04],'callback',@cb_clear);
ic=getIcon('clear'); ic=ic./255;
set(hb,'cdata',ic);
set(hb,'tooltipstring','clear selection');
set(hb,'parent',pan1,'units','pixels','position',[0 0 16 16]);

%% select all
hb=uicontrol('style','radio','string','all','units','norm');
set(hb,'backgroundcolor','w');
set(hb,'position',[0.4 0.90833 0.06 0.04],'callback',@showallregs,'value',0,'tag','showallregs');
set(hb,'tooltipstring','show all regions');
set(hb,'parent',pan1,'units','pixels','position',[24 0 48 16]);

%% help
hb=uicontrol('style','pushbutton','string','','units','norm');
set(hb,'position',[0.2 .96,.03 .04],'callback',@cb_help);
ic=getIcon('bulb');
set(hb,'cdata',ic);
set(hb,'tooltipstring','get some help');
set(hb,'parent',pan1,'units','pixels','position', [262.16 21.92 16 16]);

%% find
hb=uicontrol('style','pushbutton','string','','units','norm');
set(hb,'position',[0 .9,.03 .04],'callback',@showfinder);
ic=getIcon('search');
set(hb,'cdata',ic);
set(hb,'tooltipstring','open finder panel to find region');
set(hb,'parent',pan1,'units','pixels','position', [262.16 0 16 16]);

%% showboundaries
hb=uicontrol('style','radio','string','bnd','units','norm');
set(hb,'backgroundcolor','w');
set(hb,'position',[0.4 0.90833 0.06 0.04],'callback',@showboundaries,'value',0,'tag','showboundaries');
set(hb,'tooltipstring',['show boundary' char(10) ' ..see contextmenu to change color/boundary type']);
set(hb,'parent',pan1,'units','pixels','position',[64 0 48 16]);

c = uicontextmenu;
hb.UIContextMenu = c;
m1 = uimenu(c,'Label','change boundary color','Callback',{@boundary_color,'color'});
m2 = uimenu(c,'Label','boundary type','Callback',{@boundary_color,'type'});

%% alpha
hb=uicontrol('style','edit','string',num2str(0.5),'units','norm');
set(hb,'backgroundcolor','w','tag','cb_alpha');
set(hb,'position',[0.33036 0.90833 0.04 0.04],'callback',@cb_alpha);
set(hb,'tooltipstring','overlay transparency {value: 0-1}');
set(hb,'parent',pan1,'units','pixels','position',[100 0 30 16]);

%% followRegion
hb=uicontrol('style','radio','string','fReg','units','norm');
set(hb,'backgroundcolor','w');
set(hb,'position',[0.16429 0.90357 0.08 0.04],...
    'callback',@followRegion,'value',0,'tag','followRegion');
set(hb,'tooltipstring','follow Rgion...update slice containing the selected region')
set(hb,'parent',pan1,'units','pixels','position',[135 0 48 16]);

%% Montage
hb=uicontrol('style','pushbutton','string','','units','norm');
set(hb,'backgroundcolor','w','tag','show_montage','value',2);
set(hb,'position',[0.25 0.96 0.06 0.04],  'callback',@show_montage);
set(hb,'tooltipstring','show montage');
set(hb,'parent',pan1,'units','pixels','position',[60 22 16 16]);
ic=getIcon('montage');
set(hb,'cdata',ic);

%% DIM
hb=uicontrol('style','popupmenu','string',{'1' '2' '3'},'units','norm');
set(hb,'backgroundcolor','w','tag','dim','value',2);
set(hb,'position',[0.25 0.96 0.06 0.04],  'callback',@changedim);
set(hb,'tooltipstring','displayed dimension');
set(hb,'parent',pan1,'units','pixels','position',[100 22 30 16]);

%% flipud
hb=uicontrol('style','radio','string','flip','units','norm','fontsize',7);
set(hb,'backgroundcolor','w','tag','flipud','value',1);
set(hb,'position',[0.32 0.96 0.06 0.04],  'callback',@changedim);
set(hb,'tooltipstring','flip up/down slice');
set(hb,'parent',pan1,'units','pixels','position',[135 22 30 16]);

%% transpose
hb=uicontrol('style','radio','string','trans','units','norm','fontsize',7);
set(hb,'backgroundcolor','w','tag','transpose','value',1);
set(hb,'position',[0.37 0.96 0.07 0.04],  'callback',@changedim);
set(hb,'tooltipstring','transpose slice');
set(hb,'parent',pan1,'units','pixels','position',[165 22 40 16]);

%% hemisphere
hb=uicontrol('style','radio','string','hemi','units','norm','fontsize',7);
set(hb,'backgroundcolor','w','tag','hemisphere','value',0);
set(hb,'position',[0.37 0.96 0.07 0.04],  'callback',@hemisphere);
set(hb,'tooltipstring','show hemisphere only');
set(hb,'parent',pan1,'units','pixels','position',[204 22 40 16]);

set(gcf,'pointer','arrow');
set(gcf,'SizeChangedFcn', @resizefig);

% toc(atic)
% ==============================================
%%   show slice and finalize
% ===============================================

showslice();
waitspin(0,'done!');
% toc(atic)


return






% ==============================================
%%   subs
% ===============================================

function show_montage (e,e2)

  hf1=findobj(0,'tag','atlasviewer');
    u=get(hf1,'userdata');
    % us.ha   =u.ha;
    % us.hb   =u.hb;
    us.a    =u.a;
    us.b    =u.b;
    us.c    =u.c;
    
    us.dim       = get(findobj(hf1,'tag','dim'),'value');
    us.do_transp = get(findobj(hf1,'tag','transpose'),'value');
    us.do_flipud = get(findobj(hf1,'tag','flipud'),'value');
    ht=findobj(hf1,'tag','table');
    us.iuse      = find(cell2mat(ht.Data(:,1)))+1;
    
    montage_slices(us,{@show_montage_callback});

    
    function show_montage_callback(sliceno,e)
        
%         'rr'
%         e,
%         sliceno
drawnow
try

%         return
hf1=findobj(0,'tag','atlasviewer');
figure(hf1);

hb=findobj(hf1,'tag','ed_slice');
set(hb,'string',sliceno);
hgfeval(get(hb,'callback'),[],[]);
end


function boundary_color(e,e2,task)
us=get(gcf,'userdata');
if strcmp(task, 'color')
    col=uisetcolor('choose boundary color');
    if length(col)~=3; return ;end
    us.boundary_color=col;
    set(gcf,'userdata',us);
    showslice();
    return
elseif strcmp(task, 'type')
    q = questdlg({''...
        '[1] show boundaries of selected regions only'...
        '[2] show boundaries of all (also hidden) regions'}, ...
        'Boundary type', ...
        '[1]','[2]','[1]');
    if ~isempty(strfind(q,'1'))
        us.boundary_type=1;
    else
        us.boundary_type=2;
    end
    set(gcf,'userdata',us);
    showslice();
    return
    
end

function hemisphere(e,e2)
showslice();


function resizefig(e,e2)
hp=findobj(gcf,'tag','panel1');
set(hp,'units','pixels');
p1=get(hp,'position');
set(gcf,'units','pixels');
p2=get(gcf,'position');
% disp(p1);
% disp(p2);
p3=[ 0  p2(4)-p1(4)    p1(3:4)];
set(hp,'position',p3);
set(gcf,'units','norm');

function cb_help(e,e2)
uhelp([mfilename '.m']);

function changedim(e,e2)
us=get(gcf,'userdata');

hd=findobj(gcf,'tag','dim');
maxsizeDim=size(us.a,hd.Value);
us.slice=round(maxsizeDim/2);
set(gcf,'userdata',us);
set(us.hslid,'Maximum',maxsizeDim,'value',us.slice);

he=findobj(gcf,'tag','ed_slice');
set(he,'string',num2str(us.slice));

% 'Maximum',size(us.a,2) ,'Value',us.slice,
% return
showslice();


% function sliderBTN(e,e2)
% e2


function clickcallback(obj,evt)
switch get(obj,'SelectionType')
    case 'normal'
        return
        
    case 'open'
        hunderpointer=hittest(gcf);
        if strcmp(get(hunderpointer,'type'),'image')
            
            us=get(gcf,'userdata');
            po=get(gca,'CurrentPoint');
            po=round(po(1,1:2));
            
            s2     =getappdata(gcf,'s2');
            %mmslice=getappdata(gcf,'mmslice');
            
            id=s2(po(2),po(1));
            if id==0; return; end
            
            
            image_clicked();
  
            ht=findobj(gcf,'tag','table');
            jscrollpane = findjobj(ht);
            jtable = jscrollpane.getViewport.getView;
            us=get(gcf,'userdata');
            
            r=jtable.getSelectedRow;
            c=jtable.getSelectedColumn;
            
            val=jtable.getValueAt(r,c-1);
            jtable.setValueAt((~val),r,c-1);
            drawnow;
            %           jtable.setValueAt( logical(val)   , ix(i)-2 ,0);
            %
            %           selID(jtable,jtable)
            showslice();
            
        end
        % if strcmp( get(hunderpointer,'tag'),'thresh_drag')
        %         get(gco)
        % end
end
% ==============================================
%%
% ===============================================
function mousemovedTable(e,e2)
e2.getPoint;
jtable=e;
% index = jtable.convertColumnIndexToModel(e2.columnAtPoint(e2.getPoint())) + 1
idx=e.rowAtPoint(e2.getPoint())+1;

us=get(gcf,'userdata');
idc=idx+1;
try
    us.c{idc,1};

% ms=[us.c{idc,1} char(10) 'ID: '  num2str(us.c{idc,4}) char(10) ...
%     'children: '  num2str(length(us.c{idc,5}))];

    ms=['<html><font color="black"><b>' us.c{idc,1} '</font><br>'...
        '<font color="red">'       ' ID: ' num2str(us.c{idc,4})       '</font>' ...
        '</b><font color="blue">'     ' ; #children: ' num2str(length(us.c{idc,5})) '</font></b><br>' ...
        '</b><font color="grey">'     ' VOL (ID) : ' num2str(us.volume(idc)) ' qmm ' '</font></b><br>' ...
        '</b><font color="grey">'     ' VOL (tot): ' num2str(us.volumetot(idc)) ' qmm ' '</font></b><br>' ...
        ...
        '</html>'];
    
    jtable.setToolTipText(ms);
end



function showboundaries(e,e2)
showslice();

function showfinder(e,e2)
us=get(gcf,'userdata');
fun_search(gcf,us.hc([1 4]),us.c(:,[1 4]),1, [0.25 .5 .5 .3],@cb_finder );



function listscroll(value)

ht=findobj(gcf,'tag','table');
jscrollpane = findjobj(ht);
jtable = jscrollpane.getViewport.getView;

jtable.setCellSelectionEnabled(true)
drawnow;
% % jtable.changeSelection(row-1,col-1, false, false);
% jtable.changeSelection(row-1,col-1, false, false);
%  scroll = jscrollpane.getVerticalScrollBar.getValue;  % get the current position of the scroll
% jtable.scrollRowToVisible(row+10);
%
% % scroll to very left
drawnow;
valold= get(jscrollpane.VerticalScrollBar,'value');
valnew=valold+value
if valnew<0; return ;end
set(jscrollpane.VerticalScrollBar,'value',valnew);
drawnow;
jscrollpane.repaint
drawnow
% viewport=jscrollpane.getViewport;
% viewport.setViewPosition(java.awt.Point(0,valnew));

return


% viewport=jscrollpane.getViewport;
% P = viewport.getViewPosition();
% if (P.getY+value)<0;
%     return
% end
% viewport.setViewPosition(java.awt.Point(0,P.getY+value));


function keys(e,e2)
us=get(gcf,'userdata');
% e2

if strcmp(e2.Modifier,'control')
    if strcmp(e2.Key,'f')
        showfinder();
    end
    
    if strcmp(e2.Key,'leftarrow')
        pb_slice([],[],-5);
        'wi'
        return
    elseif strcmp(e2.Key,'rightarrow')
        pb_slice([],[],+5);
        return
    end
    
end

% listsscrolldownfactor=[90 ]

if strcmp(e2.Key,'leftarrow')
    pb_slice([],[],-1);
elseif strcmp(e2.Key,'rightarrow')
    pb_slice([],[],+1);
elseif strcmp(e2.Key,'downarrow')
    listscroll(+1000);
elseif strcmp(e2.Key,'uparrow')
    listscroll(-1000);
elseif strcmp(e2.Character,'-') ||  strcmp(e2.Character,'+')
    ht=findobj(gcf,'tag','table');
    fs=get(ht,'fontsize');
    if strcmp(e2.Character,'-')
        if (fs-1)<2; return; end
        set(ht,'fontsize',fs-1);
    else
        set(ht,'fontsize',fs+1);
    end
    
end

function cb_finder(idxall)
if isempty(idxall); return; end

idxall;
idx=idxall(1);
us=get(gcf,'userdata');

id=cell2mat(us.c(idx,4));

row = idx-1;
col = 2;
ht=findobj(gcf,'tag','table');
jscrollpane = findjobj(ht);
jtable = jscrollpane.getViewport.getView;
jtable.changeSelection(row-1,col-1, false, false);


scroll = jscrollpane.getVerticalScrollBar.getValue;  % get the current position of the scroll
% % set(handles.myuitable, 'Data', out);
%


% drawnow
% jScrollpane.getVerticalScrollBar.setValue(scroll);
% jscrollpane = javaObjectEDT(findjobj(ht));
% viewport    = javaObjectEDT(jscrollpane.getViewport);
% jtable      = javaObjectEDT( viewport.getView );
% jtable.scrollRowToVisible(scroll-1000);
jtable.scrollRowToVisible(row+10);



% ==============================================
%%
% ===============================================

function cb_clear(e,e2)

ht=findobj(gcf,'tag','table');
ht.Data(:,1)={logical(0)};
showslice();

function showallregs(e,e2)
value=get(findobj(gcf,'tag','showallregs'),'value');
ht=findobj(gcf,'tag','table');

ht.Data(:,1)={logical(value)};



showslice();


function sl_slice(e,e2)
us=get(gcf,'userdata');
us.hslid.setBackground(java.awt.Color(0,1,0));
hd =findobj(gcf,'tag','dim');
dim=hd.Value;

%  e2

add=0;
try
    if e2.isControlDown==1
        if e2.getKeyCode()==37 %left
            %         'l'
            add=-5;
        elseif e2.getKeyCode()==39 %right
            add=+5;
            %        'r'
            %    elseif e2.getKeyCode()==69 %right
            %
            %     elseif e2.getKeyCode()==83 %right
            
        end
    end
end

sliceno=us.hslid.getValue+add;

try
    if e2.isControlDown==0
        if e2.getKeyCode()==69 % [e]end
            sliceno=size(us.a,dim);
        elseif e2.getKeyCode()==83 %[s]start
            sliceno=1;
        elseif e2.getKeyCode()==77 % [m]middle slice
            sliceno=round(size(us.a,dim)/2);
        end
    end
end





if sliceno<=0;            return; end
if sliceno>size(us.a,dim); return; end

us.slice=sliceno;
set(gcf,'userdata',us);
he=findobj(gcf,'tag','ed_slice');
% set(he,'backgroundcolor')
set(he,'string',num2str(sliceno));
us.hslid.setValue(us.slice);
% ed_slice();
showslice();
drawnow;
us.hslid.setBackground(java.awt.Color(0.9412,    0.9412,    0.9412));

function ed_slice(e,e2)
he=findobj(gcf,'tag','ed_slice');
us=get(gcf,'userdata');

sliceno=str2num(get(he,'string'));

hd =findobj(gcf,'tag','dim');
dim=hd.Value;
if sliceno<=0;            return; end
if sliceno>=size(us.a,dim); return; end

us.slice=sliceno;
set(gcf,'userdata',us);
us.hslid.setValue(us.slice);
drawnow
showslice();
drawnow;

function pb_slice(e,e2,next)
he=findobj(gcf,'tag','ed_slice');
us=get(gcf,'userdata');
sliceno=str2num(get(he,'string'));

hd =findobj(gcf,'tag','dim');
dim=hd.Value;
if sliceno+next<=0;            return; end
if sliceno+next>=size(us.a,dim); return; end
us.slice=sliceno+next;
set(he,'string', num2str(us.slice));
set(gcf,'userdata',us);
us.hslid.setValue(us.slice);
showslice();

function motion(e,e2)
hunderpointer=hittest(gcf);

%  hunderpointer
%  get(hunderpointer,'parent')
if strcmp( get(hunderpointer,'tag'),'thresh_drag')
    set(gcf,'pointer','left');
elseif strcmp( get(hunderpointer,'tag'),'table') || strcmp( get(hunderpointer,'type'),'uicontrol')
    set(gcf,'pointer','arrow');
else
    set(gcf,'pointer','cross');
end

% return
% disp([get(hunderpointer,'tag') ' - ' get(hunderpointer,'type') ]);
if strcmp(get(hunderpointer,'type'),'figure') || strcmp(get(hunderpointer,'type'),'image')
    po=get(gca,'CurrentPoint');
    po=round(po(1,1:2));
    %     disp(po)
    
    us=get(gcf,'userdata');
    hm=findobj(gcf,'tag','msgbox');
    try
        s2     =getappdata(gcf,'s2');
        mmslice=getappdata(gcf,'mmslice');
        
        
        id=s2(po(2),po(1));
        %         catch
        %           'a'
        %         end
        
        %     disp([ id ]);
        idall=cell2mat(us.c(:,4));
        ix=find(idall==id);
        volslice=abs(det(us.ha.mat(1:3,1:3)) *(sum(s2(:)==id)));
        xyz=squeeze(mmslice(po(2),po(1),:))';
        
        
        
        hd=findobj(gcf,'tag','dim');
        %         if get(hd,'value')==1
        %             xyz=xyz([1 3 2]);
        %         end
        ms1=['xyz: ' sprintf('%2.4f ', xyz)];
        if id==0
            set(hm,'string',ms1,'ForegroundColor',repmat([.94],[1 3]));
            hinfo=findobj(gcf,'tag','infomouse');
            try; set(hinfo,'visible','off'); end
            
            return
        end
        ht=findobj(gcf,'tag','table');
        ischecked=cell2mat(ht.Data(find(cell2mat(us.c(:,4))==id)-1,1)');
        
        
        if ischecked==1
            set(hm,'ForegroundColor', [1 0.8431 0]);
        else
            set(hm,'ForegroundColor', repmat([.94],[1 3]));
        end
        
        ht=findobj(gcf,'tag','table');
        
        ms2= {ms1};
        ms2{end+1,1}=[us.c{ix,1}    ' (' num2str(id) ')'];
        ms2{end+1,1}=[...
            'Volume:  Slice ' num2str(volslice) ' (of ' num2str(us.volume(ix)) ') qmm'   ];
        %ms2{end+1,1}=['\color[rgb]{1,0.5,0.5} text'];
        set(hm,'string',ms2,'fontsize',7);
        
        hinfo=findobj(gcf,'tag','infomouse');
        if isempty(hinfo)
            hinfo=text(1,1,'dummy','tag','infomouse');
        end
        %lab=us.c{ix,1}
        set(hinfo,'position',[po(1) po(2)-10 0],'color',[1 0.8431 0],'visible','on');
        set(hinfo,'hittest','off','string',us.c{ix,1},'fontsize',8,'fontweight','bold');
        if po(1)<size(s2,2)/2
            %disp('l');
            set(hinfo, 'HorizontalAlignment','left');
        else
            %disp('r')
            set(hinfo, 'HorizontalAlignment','right');
        end
        
        
        %         ms=['<html><font color="orange"><b>' us.c{ix,1} '</font><br>'...
        %     '<font color="red">'       ' ID: ' num2str(us.c{ix,4})       '</font>' ...
        %      '</b><font color="blue">'     ' ; #children: ' num2str(length(us.c{ix,5})) '</font></b><br>' ...
        %      '</b><font color="grey">'     ' VOL (ID) : ' num2str(us.volume(ix)) ' qmm ' '</font></b><br>' ...
        %      '</b><font color="grey">'     ' VOL (tot): ' num2str(us.volumetot(ix)) ' qmm ' '</font></b><br>' ...
        %     '</html>'];
        %    set(hm,'string',ms,'style','listbox','fontsize',8)
        %
        %    set(hm,'position',[.5 .9 .5 .1])
        %    ms2=
        %
        
        
        
        u.lab=us.c{ix,1};
        u.id =id;
        set(hm,'userdata',u);
        %     catch
        %         'i'
        %         set(hm,'userdata',[]);
    end
    
end

function image_clicked(e,e2)
us=get(gcf,'userdata');
him=findobj(gcf,'type','image');
ha=findobj(gcf,'tag','ax1');
axes(ha);
co=get(ha,'CurrentPoint'); co=round(co(1,1:2));
s2=getappdata(gcf,'s2');
if s2(co(2),co(1))==0
   return 
end



hm=findobj(gcf,'tag','msgbox');
u=get(hm,'userdata');
if isempty(u)
    disp('emptyset');
    return
end
idx=find(cell2mat(us.c(:,4))==u.id);

row = idx-1;
col = 2;
ht=findobj(gcf,'tag','table');
jscrollpane = findjobj(ht);
jtable = jscrollpane.getViewport.getView;
% jtable.changeSelection(row-1,col-1, false, false);
jtable.changeSelection(row-1,col-1, false, false);
scroll = jscrollpane.getVerticalScrollBar.getValue;  % get the current position of the scroll
jtable.scrollRowToVisible(row+10);

% scroll to very left
viewport=jscrollpane.getViewport;
P = viewport.getViewPosition();
viewport.setViewPosition(java.awt.Point(0,P.getY));



function highlightregion(row);
us=get(gcf,'userdata');
this=us.c(row+2,:)';
s2     =getappdata(gcf,'s2');
%         mmslice=getappdata(gcf,'mmslice');
m=s2==this{4};
if sum(m(:))==0; return; end


% m2 =bwperim(m);
% % x=bwtraceboundary(m,[],'W',8,Inf,'counterclockwise')
% [X,L] = bwboundaries(m2,'noholes');

X = getExactBounds( m );
% fg; hold on;
delete(findobj(gcf,'tag','ROI'));
hp=[];
for i=1:length(X)
    xy=[X{i}];
    hp(i)=patch(xy(:,1),xy(:,2),'r','facealpha',.8,'tag','ROI');
end
twait=.1;

try; set(hp,'facecolor','y'); drawnow; pause(twait); end
try; set(hp,'facecolor','r'); drawnow; pause(twait); end
try; set(hp,'facecolor','y'); drawnow; pause(twait); end



delete(findobj(gcf,'tag','ROI'));







function selID(e,e2)
ht=findobj(gcf,'tag','table');
set(ht,'CellEditCallback',[]);


try
    ind=[e.SelectedRow e.SelectedColumn ];
catch
    return
end
if isempty(ind); return; end

% return
% valcheck=e.getValueAt(e.SelectedRow, e.SelectedColumn);

us=get(gcf,'userdata');




% end
% % % % % % ht=findobj(gcf,'tag','table');
% % % % % % d=ht.Data;
% ht=findobj(gcf,'tag','table')
% jscrollpane = javaObjectEDT(findjobj(ht));
% viewport    = javaObjectEDT(jscrollpane.getViewport);
% jtable      = javaObjectEDT( viewport.getView );
% jtable.scrollRowToVisible(row_ - 1);

% ht=findobj(gcf,'tag','table')
% jScrollpane = findjobj(ht);                % get the handle of the table
% scroll = jScrollpane.getVerticalScrollBar.getValue;  % get the current position of the scroll
% % set(handles.myuitable, 'Data', out);
%


% drawnow
% jScrollpane.getVerticalScrollBar.setValue(scroll);
% jscrollpane = javaObjectEDT(findjobj(ht));
% viewport    = javaObjectEDT(jscrollpane.getViewport);
% jtable      = javaObjectEDT( viewport.getView );
% jtable.scrollRowToVisible(scroll);

% ==============================================
%%   scrollIssue-1
% ===============================================
ht=findobj(gcf,'tag','table');
% set(ht,'visible','off');
jscrollpane = javaObjectEDT(findjobj(ht));
viewport    = javaObjectEDT(jscrollpane.getViewport);
P = viewport.getViewPosition();
drawnow;
jtable =javaObjectEDT( viewport.getView );
us.selrowcol=[jtable.getSelectedRow jtable.getSelectedColumn];
set(gcf,'userdata',us);
% ==============================================
%%   % Do whatever you need
% ===============================================


% disp('#############################');
% ----------
% e.Data{ind(1),1}= ~e.Data{ind(1),1}; %MAIN
if ind(1,2)==0
    val=e.getValueAt(e.SelectedRow, e.SelectedColumn);
    %      jtable.setValueAt(   logical(val) ,   e.SelectedRow  ,0 );
elseif ind(1,2)==1
    val=~e.getValueAt(e.SelectedRow, 0 );
    %'v##################v'
    %      jtable.setValueAt(   logical(val) ,  e.SelectedRow ,0 );
else
    
    highlightregion(e.SelectedRow);
    return
end
% disp(val);
%  drawnow;


% for i=1:10;jtable.setValueAt(i-1,0,0); end
% disp(['selected: '  char(us.c( e.SelectedRow+2 , 1 )) ]);
% val=e.Data{ind(1),1};   %CHILDS
subid=cell2mat(us.c( e.SelectedRow+2 , 5 )) ;%cell2mat(us.c(ind(1)+1, 5 ));
id=[cell2mat(us.c( e.SelectedRow+2 , 4 )) ];
allids=[id; subid(:)];
ix=find(ismember([us.c{:,4}],allids));

if 0
    % ix
    % val
    % e.Data(ix-1,1)={val};
    for i=1:length(ix);
        jtable.setValueAt( logical(val)   , ix(i)-2 ,0);
        %       jtable.repaint();
        %   pause(.0001);
        %   disp(i);
    end
    drawnow;
    disp('done');
end
% ----------

ht.Data(ix-1,1)={logical(val)};





set(ht,'CellEditCallback',@selID);

%
% ==============================================
%%    scrollIssue-2
% ===============================================
drawnow(); %This is necessary to ensure the view position is set after matlab hijacks it

viewport.setViewPosition(P);
% drawnow
% set(ht,'visible','on');
% return
showslice(1);

function cb_alpha(e,e2)
showslice();

function followRegion(e,e2)
showslice(1);

% ==============================================
%%   get slice
% ===============================================
function out=getSlice(in,dim)
us=get(gcf,'userdata');
slice=us.slice;
dx=getfield(us,in);
dx=permute( dx, [setdiff([1:3],dim) dim 4] );

ht=findobj(gcf,'tag','transpose');
hf=findobj(gcf,'tag','flipud');
doflipud   =hf.Value;
dotranspose=ht.Value;

out=squeeze(dx(:,:,slice,:));
if dotranspose==1
    out=permute(out,[2 1  3]);
end
if doflipud==1
    out=flipud(out);
end

% ==============================================
%%   showlice
% ===============================================
function showslice(fromtable)
% tic
ht=findobj(gcf,'tag','table');
us=get(gcf,'userdata');

d=ht.Data;
idx=find(cell2mat(d(:,1)))+1;
% [idx label]=getselectedIDs ;
ids=[];
for i=1:length(idx)
    %     ids=[ids; [[us.c{idx(i),4}; us.c{idx(i),5}]]];
    ids=[ids; [[us.c{idx(i),4}]]];
end
ids=unique(ids);
idall=cell2mat(us.c(:,4));

% us.slice=100;
showregionSlice=get(findobj(gcf,'tag','followRegion'),'value');
if isfield(us,'selrowcol')==0
    showregionSlice=0;
end

if exist('fromtable') && fromtable==1
    if showregionSlice==1
        ht=findobj(gcf,'tag','table');
        jscrollpane = findjobj(ht);
        jtable = jscrollpane.getViewport.getView;
        
        
        
        jtable.getValueAt(us.selrowcol(1) ,1);
        ids2=cell2mat(us.c(us.selrowcol(1)+2,4));
        ch=   cell2mat(us.c(us.selrowcol(1)+2,5));
        allid=[ids2;ch(:)];
        hd=findobj(gcf,'tag','dim');
        if hd.Value==1
            af=reshape(permute(us.b,[2 3  1]), [ size(us.b,2)*size(us.b,3) size(us.b,1) ]) ;
        elseif hd.Value==2
            af=reshape(permute(us.b,[1 3  2]), [ size(us.b,1)*size(us.b,3) size(us.b,2) ]) ;
        elseif hd.Value==3
            af=reshape(permute(us.b,[1 2  3]), [ size(us.b,1)*size(us.b,2) size(us.b,3) ]) ;
        end
        
        ism=ismember(af,allid);
        sums=sum(ism,1);
        if max(sums)==0
            set(findobj(gcf,'tag','msgbox'),'string','ID does not exist');
            return
        else
            set(findobj(gcf,'tag','msgbox'),'string','...');
        end
        slicemax=max(find(sums==max(sums)));
        
        hb=findobj(gcf,'tag','ed_slice');
        currslice=str2num( get(hb,'string'));
        if currslice~=slicemax
            set(hb,'string',num2str(slicemax));
            
            us.slice=slicemax;
            drawnow;
            ed_slice();
            set(gcf,'userdata',us);
        end
    end
end

%dim
hd=findobj(gcf,'tag','dim');
dim=str2num(hd.String{hd.Value});

s1=mat2gray( getSlice('a',dim)  );
s1=imadjust(s1);
% s1=mat2gray(flipud(squeeze(us.a(:,us.slice,:))'));
% s1=imadjust(s1,[.3 .7]);
% s1=round(s1.*255);
% s2=flipud(squeeze(us.b(:,us.slice,:))');
s2=getSlice('b',dim) ;

mmslice=getSlice('mm',dim) ;
% us.mmslice=getSlice('mm',dim) ;


hh=findobj(gcf,'tag','hemisphere');
hemi=get(hh,'value');
if hemi==1
    s2=s2.*(mmslice(:,:,1)>0);
end


sa=s2(:);
s0=zeros(size(sa,1),3);
for i=1:length(ids)
    ix=find(sa==ids(i));
    if ~isempty(ix)
        it=find(idall==ids(i));
        col=str2num(us.c{it,3})/255;
        s0(ix,1)=col(1);
        s0(ix,2)=col(2);
        s0(ix,3)=col(3);
    end
end
c2=reshape(s0,[size(s2)  3 ]);

ha=findobj(gcf,'tag','ax1');
axes(ha);
c1=cat(3,s1,s1,s1);
alpha=str2num(get(findobj(gcf,'tag','cb_alpha'),'string')) ;%0.5;
c3=(c1.*(1-alpha))+(c2.*(alpha));
him=findobj(gcf,'type','image');
if isempty(him)
    him=image(c3);
else
    set(him,'cdata',c3);
end
xlim([0.5 size(c3,2)+.5]);
ylim([0.5 size(c3,1)+.5]);
set(get(him,'parent'),'tag','ax1');
set(him,'ButtonDownFcn',@image_clicked);
axis off
% us.s2=s2;
% set(gcf,'userdata',us);

setappdata(gcf,'s2',s2);
setappdata(gcf,'mmslice',mmslice);


% ==============================================
%%   region-boundaries
% ===============================================
tic
hb= findobj(gcf,'tag','showboundaries');
delete(findobj(gca,'tag'  ,'plotline'));
% waitspin(2,'wait'); drawnow

if get(hb,'value')==1
    %% boundaries
    if us.boundary_type==1
        uni=ids;
    else
        uni=unique(s2); uni(uni==0)=[];
    end
    x={};
    for i=1:length(uni)
        m=s2==uni(i);
        %    [X] = bwboundaries(m,'noholes');
        X = getExactBounds( m );
        x=[x; X];
    end
    tic
    
    hold on
    hw=[];
    for i=1:size(x,1)
        hw(i,1)= plot( x{i}(:,1),x{i}(:,2),'color',us.boundary_color,...
            'tag','plotline','hittest','off');
    end
    %set(hw,'tag','plotline','hittest','off','linewidth',2);
    %toc
end

% waitspin(0,'done');







if 0
    % ==============================================
    %%
    % ===============================================
    
    fg; image(c3.*0);
    hold on
    
    hp=[];
    for i=1:size(x,1)
        hp(i,1)= plot( x{i}(:,1),x{i}(:,2),'color',us.boundary_color);
    end
    set(hp,'tag','plotline','hittest','off','linewidth',2);
    %toc
    hold on;
    bo=(((s2-imtranslate(s2,[0 1]))+(s2-imtranslate(s2,[1 0])))~=0);
    contour(~bo,1,'r')
    
    % ==============================================
    %%
    % ===============================================
    fg; image(c3.*0);
    hold on
    hp=[];
    for i=1:size(x,1)
        hp(i,1)= plot( x{i}(:,1),x{i}(:,2),'color',us.boundary_color);
    end
    set(hp,'tag','plotline','hittest','off','linewidth',2);
    %toc
    hold on;
    
    bo=(((s2-imtranslate(s2,[0 1]))+(s2-imtranslate(s2,[1 0])))~=0);
    
    c=contourc(double(bo),10);
    c2=contourdata(c);
    hold on
    for i=1:length(c2)
        plot( c2(i).xdata-.5,c2(i).ydata-.5,'color','r');
    end
    
    
    % ==============================================
    %%
    % ===============================================
    
    
    if isempty(c); return; end
    
    
    
    
    
    
    %     [B] = bwboundaries(bo,'holes');
    B = getExactBounds( bo );
    hold on
    hp2=[];
    for i=1:size(B,1)
        hp2(i,1)= plot( B{i}(:,1),B{i}(:,2),'color',us.boundary_color);
    end
    set(hp2,'tag','plotline','hittest','off');
    %toc
    set(hp2,'color','r')
    
    % ==============================================
    %%
    % ===============================================
    
    
    g=bwlabel(s2);
    w=getExactBounds( s2 );
    
    fg; image(c3.*0);
    hold on
    hp=[];
    for i=1:size(w,1)
        hp(i,1)= plot( w{i}(:,1),w{i}(:,2),'color',us.boundary_color);
    end
    set(hp,'tag','plotline','hittest','off');
    %toc
    
    % ==============================================
    %%
    % ===============================================
    
    fg; image(c3.*0);
    hold on
    reg=regionprops(bo,'PixelList')
    CC = bwconncomp(bo)
    for i=1:length(reg)
        hp(i,1)= plot( reg(i).PixelList(:,1),reg(i).PixelList(:,2),'color',us.boundary_color);
    end
    
    
    % ==============================================
    %%
    % ===============================================
    
    
end
drawnow;
% toc

% ==============================================
%%
% ===============================================
% uni=unique(s2); uni(uni==0)=[];
% s3=s2(:);
% s4=s3;
%
% for i=1:length(uni)
%   s4(s3==uni(i))=i;
% end
% s4=reshape(s4,size(s2));
%
% % gmag = imgradient(I)
%
% hold on;
% hc=contour(s4,30,'w')


% ==============================================
%%
% ===============================================



function garbage(jtree, eventData) %,additionalVar)

% function mousePressedCallback(jtree, eventData) %,additionalVar)
% if eventData.isMetaDown % right-click is like a Meta-button
% if eventData.getClickCount==2 % how to detect double clicks

% showslice();

return

e=jtree;
e.getSelectionRows
e.getSelectionModel
e.getSelectionPath
e.getSelectionCount
e.Enabled
e.getSelectionCount
% e.getSelectionState

selpa=e.getSelectionPath
node=selpa.getLastPathComponent
node.getSelectionState
% ==============================================
%%   selection
% ===============================================
% % clcr;
nn=jtree.getRowCount;
sel=zeros(nn,1);
for i=1:nn-1
    ds=jtree.getPathForRow(i);
    states=ds.getLastPathComponent.getSelectionState;
    states
    if strcmp(states, 'selected')
        sel(i)=1;
        %         disp(ds);
    end
end

% ==============================================
%%
% ===============================================
function [idx label]=getselectedIDs
us=get(gcf,'userdata');
jtree=us.jCheckBoxTree;
nn=jtree.getRowCount;
sel=zeros(nn,1);
label={};
for i=1:15%nn-1
    ds=jtree.getPathForRow(i);
    states=ds.getLastPathComponent.getSelectionState;
    disp([char(states) ' - i:'  num2str(i)]);
    if strcmp(states, 'selected')
        sel(i)=1;
        label(end+1,1)={char(ds)};
        %         disp(ds);
    end
end
idx=find(sel==1);
return



function selectionclick_cb(e,e2)
% e.getSelectionRows
% e.getSelectionModel
% e.getSelectionPath
% e.getSelectionCount
% e.Enabled
% e.getSelectionCount


function thresh_dragCB(e,e2)
us=get(gcf,'userdata');
co=get(gcf,'CurrentPoint');

si=get(0,'ScreenSize');
fsi=get(gcf,'position');
p0=get(0,'PointerLocation');
np=p0./si(3:4);
% np(1)
p1=(np(1)-fsi(1))/fsi(3);

if p1<0; return; end
if p1>.95; return; end


hp=findobj(gcf,'tag','thresh_drag');
pos=get(hp,'position');
set(hp,'position', [ p1  pos(2:4) ]);

%% TABLE
ht=findobj(gcf,'tag','table');
pos2=get(ht,'position');
set(ht,'position', [ pos2(1:2)  p1 pos2(4) ]);
% (fsi(1)+fsi(3))
%% axes1
ha=findobj(gcf,'tag','ax1');
pos3=get(ha,'position');
set(ha,'position', [ p1 pos3(2)  1-p1  pos3(4)  ]);


return
% co=get (gca, 'CurrentPoint')
% disp(co);
% hp=findobj(gcf,'tag','thresh_drag');
% pos=get(hp,'position');
% drawnow
% % if
% % return
%
% set(hp,'position', [ co(1) co(2)  pos(3:4) ]);
% % set(hp,'units','norm');
% drawnow


function selectionChanged_cb(e,e2)
% % 'ww'
% e.getSelectionRows
% e.getSelectionModel
% e.getSelectionPath
% e.getSelectionCount
% e.Enabled
return

% ==============================================
%%   
% ===============================================

function waitspin(status,msg)
if status==1
     hv=findobj(gcf,'tag','waitspin');
     try; delete(hv); end
     
    try
        % R2010a and newer
        iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
        iconsSizeEnums = javaMethod('values',iconsClassName);
        SIZE_32x32 = iconsSizeEnums(2);  % (1) = 16x16,  (2) = 32x32
        jObj = com.mathworks.widgets.BusyAffordance(SIZE_32x32, msg);  % icon, label
    catch
        % R2009b and earlier
        redColor   = java.awt.Color(1,0,0);
        blackColor = java.awt.Color(0,0,0);
        jObj = com.mathworks.widgets.BusyAffordance(redColor, blackColor);
    end
    % jObj.getComponent.setFont(java.awt.Font('Monospaced',java.awt.Font.PLAIN,1))
    jObj.setPaintsWhenStopped(true);  % default = false
    jObj.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
    [hj hv]=javacomponent(jObj.getComponent, [10,10,80,80], gcf);
    set(hv,'units','norm');
    set(hv,'position',[.6 .2 .20 .20]);
    set(hv,'tag','waitspin')
    jObj.getComponent.setBackground(java.awt.Color(1.0, 0.78, 0.0));  % orange
    jObj.start;
    
    
    hv=findobj(gcf,'tag','waitspin');
%     us=get(gcf,'userdata');
%     us.hwaitspin =hv;
%     us.jwaitspin =jObj;
%     set(gcf,'userdata',us);
    setappdata(hv,'userdata',jObj);
    
elseif status==2
    hv=findobj(gcf,'tag','waitspin');
    hv=hv(1);
    jObj=getappdata(hv,'userdata');
%     us=get(gcf,'userdata');
%     jObj=us.jwaitspin;
    jObj.setBusyText(msg); %'All done!');
    jObj.getComponent.setBackground(java.awt.Color(1.0, 0.78, 0.0));  % orange
    set(hv,'visible','on');
    drawnow;
elseif status==0
     hv=findobj(gcf,'tag','waitspin');
     hv=hv(1);
    jObj=getappdata(hv,'userdata');
    %us=get(gcf,'userdata');
    %jObj=us.jwaitspin;
    jObj.stop;
    jObj.setBusyText(msg); %'All done!');
    jObj.getComponent.setBackground(java.awt.Color(.4667,    0.6745,    0.1882));  % green
%     pause(.2);
    %jObj.getComponent.setVisible(false);
    %set(us.hwaitspin,'visible','off');
    set(hv,'visible','off');
end




function ic=getIcon(str)

if strcmp(str, 'search')
    
    
    %     ic(:,:,1)=[[NaN NaN NaN NaN NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN 0 0 0 NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN]];
    %     ic(:,:,2)=[[NaN NaN NaN NaN NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN 0 0 0 NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN]];
    %     ic(:,:,3)=[[NaN NaN NaN NaN NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN 0 0 0 NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN]];
    %
    ic(:,:,1)=[255 255 255 255 240 217 215 241 255 255 255 255 255 255 255 255;255 255 239 179 146 153 172 174 191 217 255 255 255 255 255 255;255 232 149 144 183 197 205 212 203 191 189 252 255 255 255 255;248 146 135 190 211 246 234 222 221 223 195 198 255 255 255 255;191 120 173 210 226 189 180 180 183 189 202 183 249 255 255 255;135 122 196 206 180 180 181 185 190 195 200 199 220 255 255 255;101 149 183 180 180 182 186 191 196 202 207 205 212 255 255 255;91 159 179 180 183 188 193 198 204 209 214 206 221 255 255 255;109 155 181 184 189 194 200 205 210 215 221 189 250 255 255 255;168 134 187 191 196 201 207 212 217 222 224 188 255 255 255 255;246 122 190 198 203 208 213 218 224 229 173 118 232 255 255 255;255 241 165 199 210 215 220 225 228 182 82 113 130 214 255 255;255 255 253 195 181 202 206 189 184 239 201 91 111 128 194 255;255 255 255 255 250 221 220 247 255 255 255 229 108 103 127 175;255 255 255 255 255 255 255 255 255 255 255 255 248 138 95 146;255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 231];
    ic(:,:,2)=[255 255 255 255 240 217 215 241 255 255 255 255 255 255 255 255;255 255 239 179 146 153 174 178 193 217 255 255 255 255 255 255;255 232 149 144 188 212 221 225 219 206 191 252 255 255 255 255;248 146 135 198 225 249 240 232 231 232 211 199 255 255 255 255;191 120 177 224 235 210 204 204 206 211 219 191 249 255 255 255;135 123 211 221 204 204 204 207 211 215 219 212 220 255 255 255;101 151 205 204 204 205 209 212 216 220 224 218 212 255 255 255;91 164 203 204 206 210 213 217 221 225 229 217 221 255 255 255;109 160 204 207 211 215 218 222 226 230 234 196 250 255 255 255;168 136 208 212 216 220 223 227 231 235 236 189 255 255 255 255;246 122 202 217 221 225 228 232 237 240 178 118 232 255 255 255;255 241 166 212 226 230 234 238 239 186 82 113 130 214 255 255;255 255 253 195 187 211 215 195 185 239 201 91 111 128 194 255;255 255 255 255 250 221 220 247 255 255 255 229 108 103 127 175;255 255 255 255 255 255 255 255 255 255 255 255 248 138 95 146;255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 231];
    ic(:,:,3)=[255 255 255 255 240 217 215 241 255 255 255 255 255 255 255 255;255 255 239 179 146 154 177 185 195 217 255 255 255 255 255 255;255 232 149 144 198 246 254 254 253 237 194 252 255 255 255 255;248 146 135 213 253 254 254 253 253 252 243 200 255 255 255 255;191 120 185 253 254 254 255 255 255 254 253 205 249 255 255 255;135 123 241 254 254 255 255 255 255 255 255 235 220 255 255 255;101 153 253 254 255 255 255 255 255 255 255 240 213 255 255 255;91 173 255 255 255 255 255 255 255 255 255 233 221 255 255 255;109 169 255 255 255 255 255 255 255 255 255 204 250 255 255 255;168 137 252 255 255 255 255 255 255 255 250 191 255 255 255 255;246 123 225 255 255 255 255 255 255 254 183 118 232 255 255 255;255 241 167 236 254 255 255 255 251 191 82 113 130 214 255 255;255 255 253 195 195 224 226 202 186 239 201 91 111 128 194 255;255 255 255 255 250 221 220 247 255 255 255 229 108 103 127 175;255 255 255 255 255 255 255 255 255 255 255 255 248 138 95 146;255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 231];
    ic([1 end],:,:)=0;    ic(:,[1 end],:)=0;
    ic=ic./255;
elseif strcmp(str, 'montage')
    ic(:,:,1)=[255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 84 255 84 255 84 255 84 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 74 255 74 255 74 255 74 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 62 255 62 255 62 255 62 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 238 33 255 33 255 33 255 33 235 255 255 255 255;255 255 255 238 229 229 229 229 229 229 229 235 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255];
    ic(:,:,2)=[255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 84 255 84 255 84 255 84 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 74 255 74 255 74 255 74 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 62 255 62 255 62 255 62 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 238 33 255 33 255 33 255 33 235 255 255 255 255;255 255 255 238 229 229 229 229 229 229 229 235 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255];
    ic(:,:,3)=[255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 84 255 84 255 84 255 84 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 74 255 74 255 74 255 74 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 62 255 62 255 62 255 62 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 238 33 255 33 255 33 255 33 235 255 255 255 255;255 255 255 238 229 229 229 229 229 229 229 235 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255];
    ic([1 end],:,:)=0;    ic(:,[1 end],:)=0;
    ic=ic./255;
elseif strcmp(str, 'clear')
    ic(:,:,1)=[0 1 5 5 5 5 5 5 5 5 5 5 5 5 1 0;1 164 220 219 219 218 218 217 217 216 216 215 214 215 161 1;6 203 209 209 209 209 209 209 209 209 209 209 209 209 198 6;7 194 202 190 193 192 202 202 202 202 192 193 190 202 189 8;8 187 194 226 240 216 190 194 194 189 215 240 226 194 184 9;10 181 187 198 235 233 215 190 189 213 231 234 198 187 179 10;11 176 180 180 195 230 226 214 213 222 226 195 180 180 178 11;12 167 170 177 186 203 225 219 217 221 206 188 174 161 146 13;12 154 142 158 175 178 202 216 212 199 175 171 156 142 143 13;12 153 148 165 174 204 221 222 217 207 199 176 165 148 142 13;12 153 153 169 213 230 229 237 236 219 220 215 172 153 143 13;12 152 154 221 239 236 231 244 244 231 233 239 224 154 143 13;12 152 153 193 239 214 221 233 233 221 214 239 194 153 145 13;11 152 148 164 180 196 209 217 217 209 196 180 164 148 146 12;3 124 148 152 157 161 164 166 166 163 159 155 149 144 116 3;0 3 11 12 12 12 12 12 12 12 12 12 12 11 3 0];
    ic(:,:,2)=[0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0;0 75 112 107 107 107 107 107 107 107 107 107 107 112 75 0;0 88 152 152 152 152 152 152 152 152 152 152 152 152 102 0;0 68 136 145 186 139 136 136 136 136 139 186 145 136 87 0;0 60 121 218 240 211 130 121 121 130 210 240 218 121 82 0;0 52 105 131 229 233 209 122 122 207 231 228 131 105 78 0;0 46 89 89 120 223 226 207 206 222 219 120 89 89 79 0;0 33 66 76 84 118 217 219 217 215 128 87 69 47 14 0;0 10 2 18 35 66 194 216 212 190 52 23 12 2 12 0;0 14 6 19 51 192 221 209 204 207 187 54 19 6 16 0;0 18 10 48 202 230 217 104 103 207 220 203 51 10 20 0;0 22 11 205 239 224 100 79 79 100 221 239 208 11 24 0;0 26 10 94 223 87 62 71 71 62 87 223 94 10 27 0;0 35 6 18 30 42 52 58 58 52 42 30 18 6 32 0;0 31 38 36 40 44 47 49 49 47 44 40 36 35 23 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    ic(:,:,3)=[0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0;0 75 112 107 107 107 107 107 107 107 107 107 107 112 75 0;0 88 152 152 152 152 152 152 152 152 152 152 152 152 102 0;0 68 136 145 186 139 136 136 136 136 139 186 145 136 87 0;0 60 121 218 240 211 130 121 121 130 210 240 218 121 82 0;0 52 105 131 229 233 209 120 120 207 231 228 131 105 78 0;0 46 89 89 117 222 226 206 205 222 219 117 89 89 79 0;0 32 66 73 74 105 215 219 217 213 116 77 66 47 13 0;0 9 0 5 13 42 192 216 212 187 26 0 0 0 10 0;0 11 0 0 27 189 221 205 199 207 184 29 0 0 12 0;0 13 0 30 199 230 211 45 44 201 220 201 33 0 14 0;0 15 0 203 239 220 45 0 0 45 216 239 206 0 15 0;0 16 0 79 219 46 0 0 0 0 46 219 79 0 16 0;0 22 0 0 0 0 0 0 0 0 0 0 0 0 20 0;0 26 22 17 17 17 17 17 17 17 17 17 17 19 17 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    %source: https://iconarchive.com/search?q=delete+16x16&res=16&page=1
elseif strcmp(str, 'bulb')
    a2=[0 1 0.0313725490196078 0.32156862745098 1 1 1 1 1 1 1 1 1 1 0.83921568627451 0.741176470588235 0.968627450980392 0.905882352941176 0.741176470588235 0.968627450980392 0.776470588235294 0.258823529411765 0.776470588235294 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0;0 1 0.0470588235294118 0.333333333333333 1 1 1 1 1 1 1 1 1 1 0.811764705882353 0.729411764705882 0.952941176470588 0.890196078431373 0.713725490196078 0.937254901960784 0.745098039215686 0.235294117647059 0.764705882352941 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0;0 1 0.0627450980392157 0.290196078431373 0 0.290196078431373 0.32156862745098 0.352941176470588 0.517647058823529 0.611764705882353 0.67843137254902 0.83921568627451 0.870588235294118 0.968627450980392 0 0.0941176470588235 0.223529411764706 0.258823529411765 0.0941176470588235 0.290196078431373 0.290196078431373 0.0627450980392157 0.741176470588235 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0]';
    aa2=[25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 21 25 25 25 25 25;25 25 21 25 25 21 21 21 21 25 25 25 25 25 25 25;25 25 25 25 21 20 16 19 17 21 21 25 25 25 25 25;25 25 25 21 15 11 13 8 5 14 14 21 21 24 24 25;25 25 25 21 18 12 1 10 5 5 4 4 21 1 1 2;21 21 25 21 18 12 1 4 7 21 21 4 21 22 22 2;25 25 25 21 18 9 7 5 5 5 4 4 21 3 3 2;25 25 25 21 18 6 4 4 4 18 18 21 21 2 23 25;25 25 25 25 21 18 18 18 18 21 21 25 25 25 25 25;25 25 21 25 25 21 21 21 21 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 21 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25]';
    ic= ind2rgb(uint8(aa2),a2);
    ic([1 end],:,:)=0;    ic(:,[1 end],:)=0;
elseif strcp(str,'hand')
    a2=[129 129 129 129 129 129 129 0 0 129 129 129 129 129 129 129;129 129 129 0 0 129 0 215 215 0 0 0 129 129 129 129;129 129 0 215 215 0 0 215 215 0 215 215 0 129 129 129;129 129 0 215 215 0 0 215 215 0 215 215 0 129 0 129;129 129 129 0 215 215 0 215 215 0 215 215 0 0 215 0;129 129 129 0 215 215 0 215 215 0 215 215 0 215 215 0;129 0 0 129 0 215 215 215 215 215 215 215 0 215 215 0;0 215 215 0 0 215 215 215 215 215 215 215 215 215 215 0;0 215 215 215 0 215 215 215 215 215 215 215 215 215 0 129;129 0 215 215 215 215 215 215 215 215 215 215 215 215 0 129;129 129 0 215 215 215 215 215 215 215 215 215 215 215 0 129;129 129 0 215 215 215 215 215 215 215 215 215 215 0 129 129;129 129 129 0 215 215 215 215 215 215 215 215 215 0 129 129;129 129 129 129 0 215 215 215 215 215 215 215 0 129 129 129;129 129 129 129 129 0 215 215 215 215 215 215 0 129 129 129;129 129 129 129 129 0 215 215 215 215 215 215 0 129 129 129];
    a2=cat(3,a2,a2,a2);
    ic=a2./255;
end




