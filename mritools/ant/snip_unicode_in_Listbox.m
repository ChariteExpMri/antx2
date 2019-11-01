


%% function bla

fg; 

hf = uicontrol('style','list','units','normalized','position',[.4 0 .6 .9],'tag','lb1',...
	  'string','','fontsize',15,'max',10,'min',1, 'userdat', '');
  
  s={}
s{1}='<html> <ol>  <li>One</li>  <li>Two</li>  <li>Three</li></ol>  </html>'  
  s{1}=['<html>' '<p>I will display &#9658;</p>'   '</html>'  ]
   s{1}=['<html>'  'I will display <font color =#ADFF2F>&#9733<font color ="Aqua">&#9733<font color ="grey">&#9734'   '</html>'  ]
  set(hf,'string',s)
  
%   9733
%   9673	25C9