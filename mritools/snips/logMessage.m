
function logMessage(jEditbox,text,severity)


if 0
    
    fg
hEditbox=uicontrol('style','edit','units','normalized','position',[0 0 1 1])
jEditbox=findjobj(hEditbox)
e=hEditbox
% jEditbox.setEditorKit(javax.swing.text.html.HTMLEditorKit);
% % alternative: jEditbox.setContentType('text/html');
htmlStr = ['<b><div style="font-family:impact;color:green">'...
           'Matlab</div></b> GUI is <i>' ...
           '<font color="red">highly</font></i> customizable'];
% jEditbox.setText(htmlStr)


    logMessage(jEditbox, 'a regular info message...');
logMessage(jEditbox, 'a warning message...', 'warn');
logMessage(jEditbox, 'an error message!!!', 'error');
logMessage(jEditbox, 'a regular message again...', 'info');
    
end






   % Ensure we have an HTML-ready editbox
   HTMLclassname = 'javax.swing.text.html.HTMLEditorKit';
   if ~isa(jEditbox.getEditorKit,HTMLclassname)
      jEditbox.setContentType('text/html');
   end
 
   % Parse the severity and prepare the HTML message segment
   if nargin<3,  severity='info';  end
   switch lower(severity(1))
      case 'i',  icon = 'greenarrowicon.gif'; color='gray';
      case 'w',  icon = 'demoicon.gif';       color='black';
      otherwise, icon = 'warning.gif';        color='red';
   end
   icon = fullfile(matlabroot,'toolbox/matlab/icons',icon);
   iconTxt =['<img src="file:///',icon,'" height=16 width=16>'];
   msgTxt = ['&nbsp;<font color=',color,'>',text,'</font>'];
   newText = [iconTxt,msgTxt];
   endPosition = jEditbox.getDocument.getLength;
   if endPosition>0, newText=['<br/>' newText];  end
 
   % Place the HTML message segment at the bottom of the editbox
   currentHTML = char(jEditbox.getText);
   jEditbox.setText(strrep(currentHTML,'</body>',newText));
   endPosition = jEditbox.getDocument.getLength;
   jEditbox.setCaretPosition(endPosition); % end of content
end