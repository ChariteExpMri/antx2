function displaykey(hand,b)


% no inputs: -->link to spmMenuButton [Display]


if exist('hand')==0
    hmenu    =findobj(0,'tag','Menu')
    hdisplay =findobj(hmenu,'string','Display')
    iptaddcallback(hdisplay, 'Callback', @displaykey);
    return
end


% disp('=======================================');
% disp('SHORTCUTS: TYPE [h] IN GRAPHICS-WINDOW');
keyb;
% spm_image2('addoverlay2','V:\spmmouse\tpm\output.img,1')
% spm_image2('setparams','col',[1 0 1],'wt',1)
% spm_orthviews2('Redraw');


hfig =findobj(0,'tag', 'Graphics');

%% keyboard
set(hfig,'KeyPressFcn',@keyb);
% set(gcf,'WindowButtonDownFcn', [])

%% update axes
ax=findobj(hfig,'type','axes');
iptaddcallback(ax(1), 'ButtonDownFcn', 'spm_orthviews2(''Redraw'')') ;
iptaddcallback(ax(2), 'ButtonDownFcn', 'spm_orthviews2(''Redraw'')') ;
iptaddcallback(ax(3), 'ButtonDownFcn', 'spm_orthviews2(''Redraw'')') ;

%% params
box=[];
box.stpshift=1;
box.stpangle=pi/30;
% box.col=[1 0 0];
box.col=[0 1 0];
box.wt =.6;
box.isBackgroundOnly=0;
box.isOverlayOnly   =0;
setappdata(gcf,'box',box)

try
    % getappdata(gcf,'box')
    hinfo=findobj(gcf,'userdata','myinfo');
    set(hinfo,'string',['shiftstep[mm]: ' num2str(box.stpshift)] );
end









