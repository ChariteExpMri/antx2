function test_table(tb)


if 1
    % colortag='<html><div style="background:yellow;">Panel 1'
    colortag='<html><div style="color:red;"> '
    % % colortag='<html><TD BGCOLOR=#40FF68>'
    tbsel=cellfun(@(tb) [ colortag tb],tb,'UniformOutput',0)
end

if 0
    colergen = @(color,text) ['<html><table border=0 width=1000 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
    % % colergen = @(color,text) ['<html><table border=0 width=1400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
    for i=1:size(tb,1)
        for j=1:size(tb,2)
            tbsel{i,j}=colergen('#00FF00',tb{i,j});
        end
    end
end

% data = {  2.7183        , colergen('#FF0000','Red')
%          'dummy text'   , colergen('#00FF00','Green')
%          3.1416         , colergen('#0000FF','Blue')
%          }
% uitable('data',data)





us.tb=tb;
us.tb0=tb;
us.tbsel=tbsel;
us.sel=zeros(size(tb,1),1);



%  tb=us.tbsel;




cf
fg; set(gcf,'units','norm','position', [0.3212    0.0561    0.4271    0.8644]);
set(gcf,'userdata',us);


headers = {['Filename ' repmat(' ' ,[1 size(char(tb(:,1)),2)])], ...
    '<html><center>Sizw<br />MB</center></html>', ...
    '<html><center>Date recorded       <br />recordkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk</center></html>', ...
    '<html><center>Seqeunce<br />---</center></html>'};
t = uitable('Data',tb, 'ColumnEditable',false, ...
    'ColumnName',headers, 'RowName',[], ...
    'ColumnFormat',[repmat({'char'},1,size(tb,2))], ...
    'ColumnWidth','auto')%, ...
%            'Units','norm', 'Position',[0,.75,1,.25]);
set(t,'Units','norm');
set(t,'Position',[0.0,0,1,1]);
set(t,'fontsize',15)

% jScroll = findjobj(t);
% jTable = jScroll.getViewport.getView;
% jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS)

% tableextent = get(t,'Extent');
% oldposition = get(t,'Position');
% newposition = [oldposition(1) oldposition(2) tableextent(3) tableextent(4)];
% set(t, 'Position', newposition);

lb=uicontrol('Style','pushbutton','units','normalized',         'Position',[.7 .5 .1 .1])

set(t,'CellSelectionCallback',@dothis)

% uu=findjobj(t)
% rows=uu.getComponent(0).getComponent(0).getSelectedRows+1
% cols=uu.getComponent(0).getComponent(0).getSelectedColumns+1

function dothis(t,id)

 methodjava(t,id)  %function to use java updata
%convent(t,id) ;%conventional method

function methodjava(t,id)
us=get(gcf,'userdata');



jscroll = findjobj(t);
try
    % ---------remember scrolling-I--------------------
    % http://www.mathworks.com/matlabcentral/newsreader/view_thread/307912
    % jTable = findjobj(t); % hTable is the handle to the uitable object
    jScrollPane = jscroll.getComponent(0);
    javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
    currentViewPos = jScrollPane.getViewPosition; % save current position
end



jtable = jscroll.getViewport.getComponent(0);
% jtable.setValueAt(java.lang.String('This value will be inserted'),0,0); % to insert this value in cell (1,1)




idx=id.Indices;
for i=1:size(idx)
    this=idx(i);
    
    if us.sel(this)==0  %selected for process NOW
        us.sel(this)=1;
        %us.tb(this,:)=us.tbsel(this,:);
        for j=1:size(us.tb,2)
            jtable.setValueAt(java.lang.String(us.tbsel{this,j}),this-1,j-1);
        end
    else%deSelect
        us.sel(this)=0;
        for j=1:size(us.tb,2)
            jtable.setValueAt(java.lang.String(us.tb0{this,j}),this-1,j-1);
        end
    end
end

% ---------remember scrolling-II--------------------
try
    drawnow; % without this drawnow the following line appeared to do nothing
    jScrollPane.setViewPosition(currentViewPos);% reset the scroll bar to original position
end



set(gcf,'userdata',us);

return




function convent(t,id)
%% slow way
us=get(gcf,'userdata');
idx=id.Indices;
for i=1:size(idx)
    this=idx(i);
    
    if us.sel(this)==0  %selected for process NOW
        us.sel(this)=1;
        us.tb(this,:)=us.tbsel(this,:);
        
    else%deSelect
        us.sel(this)=0;
        us.tb(this,:)=us.tb0(this,:);
    end
    
    
end



if 1
    % ---------remember scrolling-I--------------------
    % http://www.mathworks.com/matlabcentral/newsreader/view_thread/307912
    try
        hTable=t;
        jTable = findjobj(hTable); % hTable is the handle to the uitable object
        jScrollPane = jTable.getComponent(0);
        javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
        currentViewPos = jScrollPane.getViewPosition; % save current position
    end
    
    set(gcf,'userdata',us);
    set(t,'data',us.tb);
    
    
    % ---------remember scrolling-II--------------------
    try
        drawnow; % without this drawnow the following line appeared to do nothing
        jScrollPane.setViewPosition(currentViewPos);% reset the scroll bar to original position
    end
    
    % -----------------------------
    
    %     jScrollpane = findjobj(t);                % get the handle of the table
    % scrollMax = jScrollpane.getVerticalScrollBar.getMaximum;  % get the end position of the scroll
    % AddNRows(handles,1);                                     % appending 1 new row
    % jScrollpane.getVerticalScrollBar.setValue(scrollMax);
    
end


if 0
    t = uitable;
    set(t,'Data',data);
    jscroll = findjobj(t);
    jtable = jscroll.getViewport.getComponent(0);
    jtable.setValueAt(java.lang.String('This value will be inserted'),0,0); % to insert this value in cell (1,1)
    
    
end






