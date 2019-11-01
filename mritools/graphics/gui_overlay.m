
function overlay_gui

hp=figure;
set(gcf,'color','w','units','normalized','tag','plot','menubar','none','toolbar','none');
ha=findobj(0,'tag','ant');
si=get(ha,'position');

siz=.15
set(hp,'position',[ si(1)-siz si(2) siz-.001 si(4)]);

h = uicontrol('style','pushbutton','units','norm', 'string','plot',...
    'position',[0.1 0.9 .2 .05],'tag','tab1','callback', @plots);
% return
global an
pars={...
'file'   'x_t2.nii'                                                                                             's'
% 'rfile' 'O:\harms1\harms3_lesionfill\templates\ANOpcol.nii'                 's'
'rfile'  fullfile(fileparts(an.datpath),'templates','ANOpcol.nii')       's'
'imswap'   '1'                                                                                               'd'
'doresize'  '1'                                                                                               'd'
'slice'   '100'                                                                                                'd'
'cmap'  ''                                                                                                   's'
'alpha' '.5'                                                                                                   'd'
'nsb'  ''                                                                                                       'd'
'cut' ['0 0 0 0']                                                                                           'd'
};
% F:\TOMsampleData\study4\templates
us.fs=9;
us.hp=hp;
us.pars=pars;
us.editable=[0 1];
us.position=[0 0 1 .9];
set(gcf,'userdata',us);



% t = uitable('Parent',hp,'Data',pars(:,1:2),'units','norm',      'position',[0 0 .9 .9],'ColumnEditable',logical([0 1]),'columnname','','rowname','');
% set(t,'ColumnWidth',{70 180});
% set(t,'fontsize',9);
% us.hp=hp;
% us.t=t;
% us.pars=pars;
% 
% set(hp,'userdata',us);

set(gcf,'resizefcn',@maketable)
maketable

function maketable(he,ho)
us=get(gcf,'userdata');
if isfield(us ,'t')
    data=us.t.Data;
    t=us.t;
else
    data=us.pars(:,1:2)
end
try; 
    delete(t); 
end

    
% t=us.t
% pars=get(us.t.data)
% pars=us.t.Data;
% delete(us.t)
% t = uitable('Parent',us.hp,'Data',us.pars(:,1:2),'units','norm',    ...
%     'position',[0 0 .9 .9],'ColumnEditable',logical([0 1]),'columnname','','rowname','',...
%     'columnwidth',{'auto','auto'});
% 
% t = uitable('Parent',us.hp,'Data',us.pars(:,1:2),'units','norm')
% 
% 
% data=us.pars
dataSize = size(data);
% Create an array to store the max length of data for each column
maxLen = zeros(1,dataSize(2));
% Find out the max length of data for each column
% Iterate over each column
for i=1:dataSize(2)
      for j=1:dataSize(1)% Iterate over each row
          len = length(data{j,i});
          if(len > maxLen(1,i))% Store in maxLen only if its the data is of max length
              maxLen(1,i) = len;
          end
      end
end

% Some calibration needed as ColumnWidth is in pixels

cellMaxLen = num2cell(maxLen*7);

t = uitable('Parent',us.hp,'units','norm',      'position',us.position,...
    'ColumnEditable', logical(us.editable),'columnname','','rowname','');
set(t,'fontsize',us.fs);
set(t, 'Data', data);
set(t,'units','pixels');
set(t, 'ColumnWidth', cellMaxLen(1:2));% Set ColumnWidth of UITABLE
set(t,'units','normalized');


us.t=t;
set(gcf,'userdata',us);

drawnow;
% pause(.5);
try
table = findjobj(us.t); %findjobj is in the file exchange
table1 = get(table,'Viewport');
jtable = get(table1,'View');
renderer = jtable.getCellRenderer(0,0);
renderer.setHorizontalTextPosition(javax.swing.SwingConstants.LEFT);
renderer.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
% set(table,'HorizontalScrollBarPolicy',31)
end


%disable scrolling
try
    jScrollPane = table.getComponent(0);
    % catch
    %     us=get(gcf,'userdata');
    %     jTable = findjobj(us.t); % hTable is the handle to the uitable object
    %     jScrollPane = jTable.getComponent(0);
    %     javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
    %     currentViewPos = jScrollPane.getViewPosition; % save current position
    %     drawnow; % without this drawnow the following line appeared to do nothing
    %
    % end
    javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
    currentViewPos = jScrollPane.getViewPosition; % save current position
    set(us.t,'CellSelectionCallback',{@mCellSelectionCallback,jScrollPane,currentViewPos});
end



function mCellSelectionCallback(e,r,jScrollPane,currentViewPos)
jScrollPane.setViewPosition(currentViewPos);

% us=get(gcf,'userdata');
% jTable = findjobj(us.t); % hTable is the handle to the uitable object
% jScrollPane = jTable.getComponent(0);
% javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
% currentViewPos = jScrollPane.getViewPosition; % save current position
% set(hTable,'data',newData); % resets the vertical scroll to the top of the table
% drawnow; % without this drawnow the following line appeared to do nothing
% jScrollPane.setViewPosition(currentViewPos);



% return
%% calback
function plots(hx,hy)
pl=(findobj(0,'tag','plot'));
if length(pl)>1
    pl=pl(1);
end
    
us=get(pl,'userdata');
d=get(us.t,'data');
fmt=us.pars(:,3);

s=cell2struct(d(:,2)',d(:,1)',2);
if strcmp(s.nsb,'line')==0;   s.nsb=str2num(s.nsb); end
s.imswap=str2num(s.imswap);
s.alpha=str2num(s.alpha);
s.cut=str2num(s.cut);
if isempty(strfind(s.slice,''''))   ;       s.slice=str2num(s.slice);  end
warp_summary2(s);












