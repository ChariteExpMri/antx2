

colorhex={idxLUT(:).color_hex_triplet}

rgb=[];
for i=1:length(colorhex)
hexString=colorhex{i};
r = double(hex2dec(hexString(1:2)))/255;
g = double(hex2dec(hexString(3:4)))/255;
b = double(hex2dec(hexString(5:6)))/255;
rgb(i,:) = [r, g, b];
end

rgb=[1 1 1; 1 1 1 ;rgb];

xcol=[];
for i=1:size(rgb,1)
rgb2=round(rgb(i,:).*255);
rgb2(rgb2<0)=0;
rgb2(rgb2>255)=255;
binar=[dec2bin(rgb2(3),8)   dec2bin(rgb2(2),8) dec2bin(rgb2(1),8)];
xcol(i,:)=bin2dec(binar);
% Range.Interior.Color=xlscol
end

co=num2cell(1:size(xcol,1));%index in excel to colorize
co=cellfun(@(a){['A' num2str(a)]},co);




tpl=fullfile(pwd,'test.xls')


Excel = actxserver('excel.application');
WB = Excel.Workbooks.Open(tpl,0,false);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
sheets = WB.Sheets;
numsheets = sheets.Count
names = cell(1, numsheets);
%del SHEETS
for i = 1:numsheets
    names{i} = sheets.Item(i).Name;
end
ix=find(strcmp(names,'Tabelle3'))
if ~isempty(ix)
    sheets.Item('Tabelle3').Delete
end
ix=find(strcmp(names,'Tabelle2'))
if ~isempty(ix)
    sheets.Item('Tabelle2').Delete
end
ix=find(strcmp(names,'Tabelle1'))
if ~isempty(ix)
    sheets.Item('Tabelle1').Delete
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
sheets = WB.Sheets;
numsheets = sheets.Count

for i=1:numsheets
    
    thissheet = get(sheets, 'Item', i)
    thissheet.Activate
    
    set(Excel.Selection.Font,'Size',8);
    set(Excel.Selection.Font,'Name','Calibri');
    
    % myCell = 'A3';
    % Range = thissheet.Range(myCell)
    % cellColor = Range.Interior.Color
    
    thissheet.Range(['A1:'  'X2']).Cell.Font.Bold=2;
    thissheet.Range(['A1:'  'A2000']).Cell.Font.Bold=2;
    % Set the color of cell "A1" of Sheet 1 to RED
    WB.Worksheets.Item(1).Range('A1').Interior.ColorIndex = 3;
    
    range=invoke(thissheet,'Range',['A1:X2' ]);
    borders=get(range,'Borders');
    borderspec=get(borders,'Item',4);
    set(borderspec,'ColorIndex',1);
    set(borderspec,'Linestyle',1);
    
    invoke(thissheet.Columns,'AutoFit');
    
    %%colorize
    % myCell = 'A3';
    if i>1
        for j=1:length(xcol)
            Range = thissheet.Range(co{j});
            Range.Interior.Color=xcol(j);
        end
    end

    
end




WB.Save();% Save Workbook
WB.Close();% Close Workbook
Excel.Quit();% Quit Excel



return
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


tpl=fullfile(pwd,'test.xls')

ax = actxserver('Excel.Application');
mywb = ax.Workbooks.Open(tpl);
mysheets = ax.sheets
numsheets = mysheets.Count

sheets = cell(1, numsheets);
for ii = 1:numsheets
    sheets{ii} = ax.Worksheets.Item(ii).Name;
end

w = ax.Worksheets.get_Item(1);


mywb.Close(false)
ax.Quit






pathres=pwd
tpl=fullfile(pwd,'test.xls')

E = actxserver('Excel.Application');
sheet =tpl
E.Workbooks.Open(sheet);





set(Excel.Selection.Font,'Size',13);
set(Excel.Selection.Font,'bold',1);

% Cell whose background color information is required

myCell = 'A3';
Range = E.Range(myCell)
cellColor = Range.Interior.Color;

cellColorBinary = dec2bin(cellColor, 24)
cb = bin2dec(cellColorBinary(1:8))
cg = bin2dec(cellColorBinary(9:16))
cr = bin2dec(cellColorBinary(17:24))
rgb=[cr cg cb]./255

%•••••inverse •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
rgb2=round(rgb.*255);
rgb2(rgb2<0)=0;
rgb2(rgb2>255)=255;
binar=[dec2bin(rgb2(3),8)   dec2bin(rgb2(2),8) dec2bin(rgb2(1),8)];
xlscol=bin2dec(binar)


%•••••inverse •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
rgb=[0 0 1]
rgb2=round(rgb.*255);
rgb2(rgb2<0)=0;
rgb2(rgb2>255)=255
binar=[dec2bin(rgb2(3),8)   dec2bin(rgb2(2),8) dec2bin(rgb2(1),8)];
xlscol=bin2dec(binar)

Range.Interior.Color=xlscol

  % save the file with the given file name, close Excel
%       wb.SaveAs(file); 
      E.Workbooks.Close;
      E.Quit;
      E.delete;



      
%       
%   Excel = actxserver('Excel.Application');
%  Excel.Visible = 1;
%  hWBS = Excel.Workbooks;
%  hWB = invoke(hWBS,'open','d:\temp\myfile.xls');
%  hWSs =hWB.Sheets;
%  hWS =get(hWSs,'item',1); %improve robustness by getting and searching name list
%  hC = hWS.Cells;
%  invoke(hC,'select');
%  invoke(hC,'copy');
%  hWSs2=invoke(hWSs,'Add');
%  invoke(hWSs2,'paste'); 
%       
      
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
pathres='O:\harms1\harmsStaircaseTrial\results'
tpl=fullfile(pathres,'harms_targetregions.xls')
xlsfile=fullfile(pathres,'labels_Both_10May2016_164041.xls')
      
[aaa aa a]=xlsread(xlsfile,'vol')
[bbb bb b]=xlsread(tpl,'Übersicht ausgewählte Regionen')

id=[]
for i=1:size(b,1)
   id(i,1)=  regexpi2(a(:,1), [ '^' b{i,1} '$' ],'match')
end

a2=a(id,:)











      
      
      