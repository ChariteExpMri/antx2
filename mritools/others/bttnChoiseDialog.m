function choise=bttnChoiseDialog(dlgOptions, dlgTitle, defOption, qStr, bttnsOredring)
%% bttnChoiseDialog
% Create and open a button dialog box with many buttons.
%
%% Syntax
%  bttnChoiseDialog(dlgOptions); 
%  bttnChoiseDialog(dlgOptions, dlgTitle);
%  bttnChoiseDialog(dlgOptions, dlgTitle, defOption); 
%  bttnChoiseDialog(dlgOptions,dlgTitle, defOption, qStr); 
%  bttnChoiseDialog(dlgOptions, dlgTitle, defOption, qStr, bttnsOredring);
%
%% Description
% Create and open a push button dialog box, which is a generalized version of a question
%  dialog box (called by questdlg). User can enter any number of input options (buttons)
%  for one to choose from, as opposed to questdlg, where only 2 or 3 options are
%  supported. User can also set the buttons ordering (columns, rows). Dialog will attempt
%  to set parameters to optimally present button text.
%
%% Input arguments (defaults exist):
% dlgOptions- a cell array of strings, each of which is an option proposed to user as a
%     push button, for selection from.
% dlgTitle- a 'title' displayed in the figure's title bar. Expected to be a string. A
%     space by default.
% defOption- a default preset option, used if user makes no choise, and closes dilaog. Can
%     be either a string- one of the dlgOptions cell array elements, or an integer- the
%     dlgOptions elements index.
% qStr- a string of the dialog question, instructing the user to choose among his options.
%     Expected to be a sting. Empty by default.
% bttnsOredring- an 2X1 array of integers, describing the number of button rows and
%     columns. Default value exist. Similar to format used in subplot.
%
%% Output arguments
%	choise- index ot the user chosen (clicked) button.
%
%% Issues & Comments 
% Choosing the deafult button is achived by clicking it (naturally) or closing figure. If
%  functione wasn't exited properly, figure should be closed via inline delete(figH)
%  command. Clicking figure "X" mark on top left corner will fail, as it's overriden.
%
%% Example
% inputOptions={'MATLAB', '(matrix laboratory)', 'is a numerical', 'computing',...
%  'environment and 4G PL'}; 
%  defSelection=inputOptions{3};
% iSel=bttnChoiseDialog(inputOptions, 'Demonstarte bttnChoiseDialog', defSelection,...
%  'What is your preferred option?'); 
% fprintf( 'User selection "%s"\n', inputOptions{iSel});
% 
%% See also
%  - questdlg
%
%% Revision history
% First version: Nikolay S. 2012-06-06. 
% Last update:   Nikolay S. 2013-01-02.
%
% *List of Changes:*
% -2013-01-02- An ossue reported by Dan K and Louis Vallance was fixed,
%   using Dan K proposal.
% -2012-06-21- changed elements 'Units' to 'characters' instead of 'normalized' to
%  quarantee proper font size, cross platform. Changes root units back and foprth during
%  run time.
%% Default params
if nargout>1
  error('MATLAB:bttnChoiseDialog:WrongNumberOutputs',...
     'Wrong number of output arguments for QUESTDLG');
end
if nargin<1
  error('MATLAB:bttnChoiseDialog:WrongNumberInputs',...
     'Wrong number of input arguments for bttnChoiseDialog');
end
if nargin==1
   dlgTitle=' ';
end
if nargin<=2
   defOption=dlgOptions{1};
end
if nargin<=3
   qStr=[];
   titleSps=0;
end
if nargin<=4
   bttnsOredring=[];
end
if nargin>5
  error('MATLAB:bttnChoiseDialog:TooManyInputs', 'Too many input arguments');
end
% internal params
bttnFontSize=0.7;
btntxtH=2; 
%% Buttons ordering definition
nButtons=length(dlgOptions);
nLongestOption=max( cellfun(@length, dlgOptions) );
% Set buttons ordering- N Columns and N Rows
if isempty (bttnsOredring)
   bttnsOredring=zeros(1, 2);
   bttnsOredring(1)=ceil( sqrt(nButtons) );
   bttnsOredring(2)=ceil( nButtons/bttnsOredring(1) );   
end
if bttnsOredring(1)>1 && bttnsOredring(1)<=nButtons
   bttnRows=bttnsOredring(1);
   bttnCols=ceil( nButtons/bttnRows );
else
   if bttnsOredring(2)>1 && bttnsOredring(2)<=nButtons
      bttnCols=bttnsOredring(2);
   else
      bttnCols=floor(sqrt(nButtons));
   end
   bttnRows=ceil( nButtons/bttnCols );
end
if exist('titleSps', 'var')~=1
   titleSps=1.25*btntxtH;  % Title gets more space then buttons.
end
spaceH=0.5;
spaceW=2;
%% Dialog Figure definition
% Open a figure about screen center
menuFigH=figure('Units', 'normalized', 'Position', [.5, .5, .1, .1], 'MenuBar', 'none',...
   'NumberTitle', 'off', 'Name', dlgTitle, 'CloseRequestFcn', 'uiresume(gcbf)'); 
% 'CloseRequestFcn' override figure closing
% make sure figure form allows good text representation Get screen resolution in
% characters
getRootUnits= get(0, 'Units');
set(0, 'Units', 'characters');
ScreenSize=get(0, 'ScreenSize'); % In characters
set(0, 'Units', getRootUnits);
set(menuFigH, 'Units', 'characters');
FigPos=get(menuFigH, 'Position');
figH=titleSps+(btntxtH+spaceH)*bttnRows+spaceH;
figW=max( spaceW+btntxtH*bttnCols*(nLongestOption+spaceW),...
   titleSps*length(qStr)+2*spaceW );
if figW > ScreenSize(3)
   figW=ScreenSize(3);
   % raise some flag, figure Width will be too small, use textwrap...
end
if figH > ScreenSize(4)
   figH=ScreenSize(4);
   % raise some flag, figure Height will be too small
end
FigL=FigPos(1)-figW/2;
FigB=FigPos(2)-figH/2;
FigPos=[FigL, FigB, figW, figH];  % [left bottom width height]
set(menuFigH, 'Position', FigPos);
%% Button group definition
iDefOption=1;
buttonGroup = uibuttongroup('Parent', menuFigH, 'Position', [0 0 1 1]);
if exist('defOption', 'var')==1 && ~isempty(defOption)
   if ischar(defOption)
      iDefOption=strcmpi(defOption, dlgOptions);
   elseif isnumeric(defOption) && defOption>1 && defOption<nButtons
      iDefOption=defOption; % defOption is an index of the default option
   end
end
%% Question definition
if titleSps>0
   titleH=uicontrol( buttonGroup, 'Style', 'text', 'String', qStr,...
      'FontUnits', 'normalized',  'FontSize', bttnFontSize,...
      'HorizontalAlignment', 'center', 'Units', 'characters',...
      'Position', [spaceW , figH-titleSps, figW-2*spaceW, titleSps] );
end
%% Radio buttons definition
bttnH=max(1, (figH-titleSps-spaceH)/bttnRows-spaceH);
interBttnStpH=bttnH+spaceH;
bttnW=nLongestOption*btntxtH;
interBttnStpW=max((figW-spaceW)/(bttnCols), bttnW+spaceW);
buttnHndl=zeros(nButtons, 1);
for iBttn=1:nButtons
   [iRow, iCol]=ind2sub([bttnRows, bttnCols],iBttn);
   currBttnHeigth=figH-titleSps-iRow*interBttnStpH;
   currBttnLeft=(iCol-1)*interBttnStpW+spaceW+(interBttnStpW-bttnW-spaceW)/2;
   buttnHndl(iBttn) = uicontrol( buttonGroup, 'Style', 'pushbutton',...
      'FontUnits', 'normalized', 'Units', 'characters', 'FontSize', bttnFontSize,...
      'String', dlgOptions{iBttn}, 'Callback', @my_bttnCallBack,...
      'Position', [currBttnLeft , currBttnHeigth, bttnW, bttnH] );
end
set(buttnHndl(iDefOption), 'Value', 1); % set default option
set(cat(1, buttnHndl, titleH, buttonGroup),'Units', 'normalized')
uiwait(menuFigH); % wait untill user makes his choise, or closes figure
% choise=find( cell2mat( get(buttnHndl, 'Value') ) );
delete(menuFigH);
function my_bttnCallBack(hObject, ~) 
choise=find(strcmp(dlgOptions,get(hObject,'String'))); 
uiresume(gcbf) 
end
end