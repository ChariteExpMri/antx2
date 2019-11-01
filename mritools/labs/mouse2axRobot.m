function m2R
warning off;

% if 1
%     
% try
%     import java.awt.Robot
%     import java.awt.event.*
% 
%     mouse=Robot;
%     sc=get(0,'screensize');
% 
%     fig=findobj('tag','fig1');
%     hobj_hittest=findobj(findobj('tag','ax1'),'hittest','on');
%     set(hobj_hittest,'hittest','off');
%     pause(0.1);
%     set(fig,'units','pixels');
%     figpos=get(fig,'position');
%     set(fig,'units','normalized');
%     axcenter=round([figpos(1)+figpos(3)/2   figpos(2)+figpos(4)/2 ]) ;
% 
%     posi=get(0,'PointerLocation');
%     WindowButtonDownfunction= get(fig,'WindowButtonDownFcn');%
%     try
%         set(fig,'WindowButtonDownFcn',[]);
%     end
%     % pause(1)
%     % mouse.keyPress(KeyEvent.VK_W)
%     mouse.mouseMove(axcenter(1), sc(4)-axcenter(2));
%     mouse.mousePress(InputEvent.BUTTON1_MASK)
%     mouse.mouseRelease(InputEvent.BUTTON1_MASK)
%     % mouse.keyRelease(KeyEvent.VK_W)
% 
% 
% 
%     mouse.mouseMove(posi(1)-1,sc(4)-posi(2));%set Mousepointer back
%     pause(0.1) ;%example critical view:   view(76,52)
%     set(fig,'WindowButtonDownFcn',WindowButtonDownfunction);%setFunction back
% 
%     set(hobj_hittest,'hittest','on');
%     set(fig,'hittest','off');
% 
% end
%    
%     
%     return
% end


try
    import java.awt.Robot
    import java.awt.event.*

    mouse=Robot;
    sc=get(0,'screensize');

    fig=findobj('tag','fig1');
    hobj_hittest=findobj(findobj('tag','ax1'),'hittest','on');
    set(hobj_hittest,'hittest','off');
    pause(0.1);
    set(fig,'units','pixels');
    figpos=get(fig,'position');
    set(fig,'units','normalized');
    axcenter=round([figpos(1)+figpos(3)/2   figpos(2)+figpos(4)/2 ]) ;

    posi=get(0,'PointerLocation');
    WindowButtonDownfunction= get(fig,'WindowButtonDownFcn');%
    try
        set(fig,'WindowButtonDownFcn',[]);
    end
    % pause(1)
    % mouse.keyPress(KeyEvent.VK_W)
    mouse.mouseMove(axcenter(1), sc(4)-axcenter(2));
    mouse.mousePress(InputEvent.BUTTON1_MASK)
    mouse.mouseRelease(InputEvent.BUTTON1_MASK)
    % mouse.keyRelease(KeyEvent.VK_W)



    mouse.mouseMove(posi(1)-1,sc(4)-posi(2));%set Mousepointer back
    pause(0.1) ;%example critical view:   view(76,52)
    set(fig,'WindowButtonDownFcn',WindowButtonDownfunction);%setFunction back

    set(hobj_hittest,'hittest','on');
    set(fig,'hittest','off');

end
