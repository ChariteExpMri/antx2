
function dispoverlay(img1,img2, namestr)

% inside function used for s1_checkoverlay
% img1='V:\MRI_testdata\T2w_nifti\s20150909_FK_C2M09_1_3_1\\s20150909_FK_C2M09_1_3_1.nii'
% img2='V:\mritools\tpm\pgreyr62.nii'
% namestr ='7/28 - s20150909_FK_C2M09_1_3_1'




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

set(gcf,'units','normalized')
pb= uicontrol('Style', 'text', 'String', namestr,...
    'units','normalized',...
    'Position', [.1 .96  .8 .02],'backgroundcolor',[0 1 1],'tag','pb','fontsize',9);
% 350 600 200 20

sizbut=[.15 .03]
%% reorientIMAGE
if 0
    pb= uicontrol('Style', 'pushbutton', 'String', 'reorientIMAGE','units','normalized',...
        'Position', [.6 .55 sizbut],'backgroundcolor',[0 1 0],'tag','pb','fontsize',9);
    iptaddcallback(pb, 'callback', 'spm_image(''reorient'')') ;
    iptaddcallback(pb, 'callback', 'uiresume(gcf)') ;
    iptaddcallback(pb, 'callback', 'drawnow;dispoverlay(img1,img2,namestr)') ;
    %    iptaddcallback(pb, 'callback', 'uiresume(gcbf)') ;
end

%% weiter
pb= uicontrol('Style', 'pushbutton', 'String', 'weiter','units','normalized',...
    'Position', [.6+sizbut(1) .55 sizbut],'backgroundcolor',[0 1 0],'tag','pb','fontsize',9);
iptaddcallback(pb, 'callback', 'uiresume(gcf)') ;

%% info
pb= uicontrol('Style', 'text', 'String', 'blalbla','units','normalized',...
    'Position', [.6  .55-sizbut(2) 2*sizbut(1) sizbut(2)],...
    'backgroundcolor',[.8 .8 .8],'tag','pb','fontsize',7,'userdata','myinfo' );
% iptaddcallback(pb, 'callback', 'uiresume(gcf)') ;

try
    set(pb,'tooltip',[['bgrIMG: ' img1 ] (char(10)) ['ovlIMG: ' img2 ]]);
end


set(gcf,'units',units);

hfig=findobj(0,'tag','Graphics');
ca=findobj(hfig,'string','Reorient images...');
iptaddcallback(ca, 'callback', 'uiresume(gcf)') ;
displaykey(2)
drawnow
% ax=findobj(gcf,'type','axes');
% get(gcf,'CurrentObject',1);
% set(0,'')
uiwait(gcf);









