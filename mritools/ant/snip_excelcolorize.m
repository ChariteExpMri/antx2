


pathres='O:\harms1\harmsStaircaseTrial\results'
tpl=fullfile(pathres,'harms_targetregions.xls')

E = actxserver('Excel.Application');
sheet =tpl
E.Workbooks.Open(sheet);

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











      
      
      