% x.hemisphere='both';	% calculation on [left|right|both] hemisphere
% x.resolution=[0.4  0.4  0.1];	% voxelsize [1x3]mm
% 
% 
% 
% 
%  p=uicontrol('style','pushbutton','units','normalized' ,'position',[0 .98 .02 .02])
% 
%  if 0
%  p=uicontrol('style','pushbutton','units','normalized' ,'position',[0 .98 .02 .02],'tag','del')
% end
% 
% if 0
% [r.getX() r.getY()]
% end
% set(p,'string',b3)
% pl=findjobj(p)
% % pl.setContentType(codeType)

% us.jCodePane.getLineFromPos(us.jCodePane.getCaretPosition())
% [us.jCodePane.getX() us.jCodePane.getY()]
% us.jCodePane.getLineHeight()
% us.jCodePane.getVisibleRect()
% us.jCodePane.getHeight()
% us.jCodePane.getNumLines()
% us.jCodePane.getPointFromPos(22)

height=us.jCodePane.getHeight()
xw=us.jCodePane.getLineHeight()

numli=us.jCodePane.getNumLines()
tb=[]
n=0;
for i=1:(numli)
    
   %pos=us.jCodePane.getLineFromPos(n)
   nsign=us.jCodePane.getLineStart(n)
   pnt= us.jCodePane.getPointFromPos(nsign)
   xy=[pnt.x pnt.y]
   tb(i,:)=[i nsign xy]
   n=n+1
end

delete(findobj(gcf,'tag','del'))
ps=[]
for i=0:10%numli-1
   p=uicontrol('style','pushbutton','units','pixels' ,'position',[0 402+(29/4)-(i*29/2)-(xw/2)/3 xw/2 xw/2 ],'tag','del')
   ps(i+1)=p;
   myIcon = fullfile(matlabroot,'/toolbox/matlab/icons/file_open.png');
 %  myIcon = fullfile(matlabroot,'/toolbox/matlab/icons/warning.gif');
 jp = findjobj(p);
jp.setIcon(javax.swing.ImageIcon(myIcon));
set(p,'backgroundcolor','w')

end




% 
% 
% 
% 
% 
% 
% 
% 
% tb
% 
% li=1
% 
% set(gcf,'units','pixels')
%  p=uicontrol('style','pushbutton','units','pixels' ,'position',[0 200 xw xw ],'tag','del')
%  set(p, 'CData', double(imread('C:\Program Files\MATLAB\R2016a\toolbox\matlab\icons\file_open.png'))/255);
%  
%  p=uicontrol('style','pushbutton','units','pixels' ,'position',[0 402+5 xw/2 xw/2 ],'tag','del')
%   
%  e = fullfile(matlabroot,'/toolbox/matlab/icons/file_open.png');
%   e=double(imread(e))
%   e=e/max(e(:));
%   e(e==0)==1
%   set(p,'cdata',e)
%   
  
  
  
 myIcon = fullfile(matlabroot,'/toolbox/matlab/icons/warning.gif');
 jp = findjobj(p);
jp.setIcon(javax.swing.ImageIcon(myIcon));
 
 
 
 
 
 
 
 
 
 
 
