 
function busy(varargin)

% fg
% text(.5,.5,'dddd')
% set(gcf,'menubar','none')
%  frame = get(handle(gcf), 'JavaFrame');
%  
%  
% clear
if nargin==1
    if varargin{1}==1
        busyRemove;
        return
    end
end


busyRemove;


img2=strrep(which('labs.m'),'labs.m','monkey.png');
img=imread(img2);
jimg = im2java(img);
frame = javax.swing.JFrame;
frame.setUndecorated(true);

icon = javax.swing.ImageIcon(jimg);
label = javax.swing.JLabel(icon);


set(label,'Text','BUSY')
% frame.setBackground(javaObject('java.awt.Color', 1, 1, 0,0))
F = java.awt.Font('Arial', java.awt.Font.BOLD, 16);
label.setFont(F);
frame.show;
 
set(label,'Foreground',[1 0 0])
frame.setBackground(java.awt.Color(0,0,0));
frame.getContentPane.add(label);
frame.getContentPane().setBackground(java.awt.Color(0,1,0,1));
 
frame.pack;
screenSize = get(0,'ScreenSize');  %# Get the screen size from the root object
frame.setSize(80,16);
frame.setLocation(screenSize(3)/2,screenSize(4)/2);
frame.show;
set(frame,'Tag','busy');

 us=getappdata(0,'busy');
% s=get(0,'userdata');
us=[us;{frame}];
% set(0,'userdata',s);
    setappdata(0,'busy',us);
% try
%     us=getappdata(0,'busy');
% catch
%     us=[];
%     setappdata(0,'busy',us);
%     us=getappdata(0,'busy');
% end



function busyRemove
if 1
    try
       us=getappdata(0,'busy'); 
    catch
        us=[];
        setappdata(0,'busy',us);
       us=getappdata(0,'busy'); 
    end
%     us=get(0,'userdata');   
    
    ni=[];
    for i=1:length(us)
        frame=us{i};
        if ~isempty(strfind(class(frame),'JFrame'));
            frame.dispose;
            ni=[ni (i)];
        end
    end
    if ~isempty(ni)
        
    us{ni}=[];
    setappdata(0,'busy',us);
    end
    
end

% frame.dispose
% rmappdata(0,'busy')


