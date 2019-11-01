



% 
% 
% fg
% icon=strrep(which('labs.m'),'labs.m','monkey.png');
% imshow(icon)
% iptsetpref('ImshowBorder','tight');
% set(gcf,'FigureMenu','none');
% 
%  jf = get(gcf,'JavaFrame');
% 
% 
% 
% Its glorious… Now the picture scales to fill the whole window! (note this only works with the ‘imshow’ command, not ‘imagesc’).
% 
% BUT! That’s not all. I also learned about some other cute little tricks that should be included in your startup.m (if you’re me at least).
% 
% %removes menu and toolbar from all new figures
% 
% %makes disp() calls show things without empty lines
% >>format compact; 

function anima

 img2=strrep(which('labs.m'),'labs.m','monkey.png');
  img=imread(img2);

% img = imread('peppers.png');  %# A sample image to display
jimg = im2java(img);
frame = javax.swing.JFrame;
frame.setUndecorated(true);
icon = javax.swing.ImageIcon(jimg);
label = javax.swing.JLabel(icon);
frame.getContentPane.add(label);
frame.pack;
screenSize = get(0,'ScreenSize');  %# Get the screen size from the root object
% frame.setSize(screenSize(3),screenSize(4));
% frame.setLocation(0,0);
frame.setSize(16,16);
frame.setLocation(100,100);
frame.show;
% frame.hide;
frame.setLocation(screenSize(3)/2,screenSize(4)/2  );
frame.setAlwaysOnTop(1);
t = timer('TimerFcn',{@move,frame,screenSize}, 'ExecutionMode', 'fixedDelay',...
    'Period',.04,'TasksToExecute',20,'StopFcn', {@stop,frame,screenSize});
start(t);

function stop(tim,ru,frame,screenSize)
delete(tim);
frame.hide;
%%
% *BOLD TEXT*
function move(tim,ru,frame,screenSize)
%  t = linspace(4*pi,12*pi,3000);
%  x = t.*cos(t);
%  y = t.*sin(t);
%  x=x-min(x); x=x./max(x); 
%  y=y-min(y); y=y./max(y); 
%  x=x*50+screenSize(3)/2;
%  y=y*50+screenSize(4)/2;
%  x=fliplr(x);
% fg; plot(x,y)
% x=linspace(screenSize(3)/2,screenSize(3)/2+50  , 300)
% y=linspace(screenSize(4)/2,screenSize(4)/2+30   , 300)
ra=get(frame.getLocation);

n=1;

for i=1%:1:50;%length(x)
    frame.setLocation(ra.X+n, ra.Y+0   );
   frame.show;
%     drawnow;drawnow;
%     pause(.01)
end
% delete(tim);

% frame.setAlwaysOnTop=1

% for i=1:5
%     frame.show;drawnow
%     pause(.2)
%     frame.hide;
% end
% frame.hide;


