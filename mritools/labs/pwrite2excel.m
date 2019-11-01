function pwrite2excel(filename,sheet,header,subheader,data)
% % function psubwrite2excel(filename,header,subheader,data)
% pwrite2excel(filename,sheet,header,subheader,data)
% write data to styled excelfile 
% example 1:
% pwrite2excel('_text',{1 'RT'},{'time1' 'time2'},{'ms' 's'},rand(5,2))
% example 2:
% filename='C:\florian\Valentin Task\muell3.xls';
% header={'TrialNo' 'Condition' 'IMG_HighProb' 'IMG_LowProb' 'POS_HighProb'...
%       'POS_LowProb' 'OUT_HighProb' 'OUT_LowProb'...
%       'Key' 'Time' 'selecedPOS' 'selectedIMG' 'Outcome' };
% 
% subheader={'' ['[1]condition1' char(10) '[2]condition2' char(10) '[3]condition3 (neutral)'] ...
%      ['image-name: HIGH probability outcome' char(10)],[ 'image-name: LOW probability outcome' char(10)]...
%      ['image-position: HIGH probability condition' char(10) '[1]topleft, [2]topright,'  char(10) '[3]bottomleft, [4]bottomright' ],...
%      ['image-position: LOW probability condition'  char(10) '[1]topleft, [2]topright,'  char(10) '[3]bottomleft, [4]bottomright' ],...
%      ['potential outcome: HIGH probability condition:' char(10) '[1]condition1' char(10) '[2]condition2' char(10) '[3]condition3' char(10) '[4]neutral']...
%      ['potential outcome: LOW probability condition:'  char(10) '[1]condition1' char(10) '[2]condition2' char(10) '[3]condition3' char(10) '[4]neutral']...
%      ['keyboard Number & ID' char(10) 'Nr:' ...] '[ms]'...
%      ['selected screen position:' char(10) '[1]topleft, [2]topright' char(10) '[3]bottomleft, [4]bottomright' ],...
%      ['..which image was selected' char(10) '[1] HIGH probability outcome' char(10) '[2] LOW probability outcome'],...
%      ['realized outcome:'   char(10) '[0]nothing' char(10) '[1]condition1' char(10) '[2]condition2' char(10) '[3]condition3' char(10) '[4]neutral'  char(10) '[-33]nothing BLANK position selected']...
%      };
% data=[...
%   1     1    14     4     4     3     1     0     6   915     4     1     1
%  2     1    14     4     4     3     4     4     4  1066     3     2     4
%  3     1    14     4     4     3     1     0     4   948     3     2     0
%  4     2    13     8     3     1     0     0     4   764     3     1     0
%  5     1    14     4     4     3     1     0     4  1005     3     2     0
%  6     2    13     8     3     1     0     0     4   631     3     1     0
%  7     3    15     9     3     2     3     3     4  1045     3     1     3
%  8     1    14     4     4     3     0     0     4   786     3     2     0
%  9     2    13     8     3     1     2     0     4   772     3     1     2
% 10     1    14     4     4     3     1     0     4   615     3     2     0
% 11     3    15     9     3     2     0     0     4   676     3     1     0
% 12     1    14     4     4     3     4     4     5   516     1   -33   -33
% 13     1    14     4     4     3     4     4     5   956     1   -33   -33
% 14     1    14     4     4     3     4     4     6   827     4     1     4
% 15     2    13     8     3     1     4     4    18   657     2   -33   -33
% 16     1    14     4     4     3     1     0   NaN   NaN   NaN   NaN   NaN
% 17     3    15     9     3     2     3     0     5   774     1   -33   -33
% 18     3    15     9     3     2     0     0   NaN   NaN   NaN   NaN   NaN
% 19     3    15     9     3     2     0     0   NaN   NaN   NaN   NaN   NaN
% 20     2    13     8     3     1     0     0     5   883     1     2     0];
% pwrite2excel(filename,header,subheader,data);

if iscell(sheet)
    sheetname_old=sheet{1};
    sheetname_new=sheet{2};
    sheet=sheetname_old;
end

s = xlswrite(filename, header   , sheet, 'A1');
if ~isempty(subheader)
    s = xlswrite(filename, subheader, sheet, 'A2');
    s = xlswrite(filename, data,   sheet, 'A3');
else %no subheader
    s = xlswrite(filename, data,   sheet, 'A2');
end


exc=actxserver('excel.application');
[PATHSTR,NAME,EXT,VERSN] = fileparts(filename);
if isempty(PATHSTR)
    try
   wb=exc.Workbooks.Open([pwd '\' filename]);
    catch
    wb=exc.Workbooks.Open( filename);     
    end
else 
wb=exc.Workbooks.Open(filename);
end

% get(wb.Activesheet)
beg=strfind(char(1:100),'A')-1;
col=[beg+1:beg+26]';

col2=cellstr(char(col));
for i=1:10
    col2=[col2;  cellstr( char([ repmat(col(i),[size(col,1) 1])  col ]) ) ];
end

for i=1:2:length(header)
    wb.Worksheets.Item(sheet).Range([col2{i} ...
        num2str(1) ':' col2{i}  num2str(2)   ]).Interior.ColorIndex=6;
    if i+1<=length(header)
        wb.Worksheets.Item(sheet).Range([col2{i+1}  num2str(1) ':' ...
            col2{i+1}   num2str(2)   ]).Interior.ColorIndex=15;
    end
end

% for i=1:2:length(header)
%     wb.Worksheets.Item(sheet).Range([char(beg+i) ...
%         num2str(1) ':' char(beg+i)  num2str(2)   ]).Interior.ColorIndex=6;
%     if i+1<=length(header)
%         wb.Worksheets.Item(sheet).Range([char(beg+i+1)  num2str(1) ':' char(beg+i+1)  num2str(2)   ]).Interior.ColorIndex=15;
%     end
% end
es=wb.Activesheet;
% es.Range('A:V').EntireColumn.AutoFit;
% es.Range('A1:V1').Cell.Font.Bold=1;
% es.Range('A1:V300').Cell.Font.Size=8;
% es.Range('A2:V2').Cell.Font.Size=8;

es.Range(['A1:' col2{length(header)}  '1']).Cell.Font.Bold=1;
es.Range(['A1:' col2{length(header)}  '1000']).Cell.Font.Size=8;

% range=invoke(es,'Range',['A1:' char(beg+i) num2str(2) ]);
range=invoke(es,'Range',['A1:' col2{length(header)}  num2str(2) ]);
borders=get(range,'Borders');
borderspec=get(borders,'Item',4);
set(borderspec,'ColorIndex',1);
set(borderspec,'Linestyle',1);

invoke(es.Columns,'AutoFit');

if exist('sheetname_new')
    wb.Worksheets.Item(sheetname_old).Name= sheetname_new;
 
    
end

wb.Save();
wb.Close();
exc.Quit();




