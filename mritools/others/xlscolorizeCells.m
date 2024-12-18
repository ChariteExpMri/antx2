

%% colorize cell(s) in excelfile-sheet
%%   xlscolorizeCells(file,sheetname, idx, col)
% file      : xls-filename
% sheetname : xls-sheetname (string)
% idx       : -indices of cells to colorize [ matlab stlye   ncells x [rows x columns] ]
%             -as string (''), "in-round-bracket"-Matrix-INDEXING-STYLE such as: 
%                 '[2:end],[1:2:end]'    : 2nd row to last row, here every 2nd column is colorized
%                 '[2:3:end],[2 5]'      : every 3rd row, starting with 2nd row, here column 2-5 are colorized
%                 '[:],[2 5]'            : all rows from column 2 and 5 are colorized
%                 ':,[2 5]'              : same as before    
%                 '[2 5],2'              : row 2 and 5, colorize 2nd column
%                 '[1:2:end],[1:5:end]'  : every 2nd row, here every 5th column is colorized
%                 '2:end,[4:5]'          : all rows starting from 2nd row, here column 4 and 5 are colorized
%                 '2,5'                  : cell: row-2--colum-5 is colorized
%            --> USE ONE COLOR if 'idx' is of type string
%   
% col       : matrix of rgb values  (0-1 range) [ ncells x 3RGB-elements ]
%            --> USE ONE COLOR if 'idx' is of type string
%% example:
% idx= [10 1; 11 2 ]; %colorize row10xcol1 in red and row11xcol2 in blue
% col=[1 0 0; 0 0 1 ]; %red & blue
%% example:
% xlscolorizeCells(excelFilename,'sheetname','2:2:end,[5]',[ 0.9843    0.9686    0.9686] )


function xlscolorizeCells(file,sheetname, idx, col)



if 0
    %=======  INPUT ================
    % idx=[i_head repmat(1,[length(i_head) 1])]
    % col=[];
    
    
    %% example2
    idx0=[i_head repmat(1,[length(i_head) 1])]
    col=[];
    
    lut2=[...
        1.0000         0         0
        1.0000    0.8431         0
        0    1.0000         0
        0    1.0000    1.0000
        1.0000    1.0000         0
        1.0000         0    1.0000
        0.6000    0.2000         0
        0.9255    0.8392    0.8392
        0.7569    0.8667    0.7765
        0.9529    0.8706    0.7333
        1.0000    0.6000    0.6000]
    
    col0=lut2(1:size(idx0,1),:)
    
    col=repmat(col0,[size(d2,2) 1])
    
    idx=[repmat(idx0(:,1),[size(d2,2) 1])     sort( repmat([1:size(d2,2)]',[size(idx0,1) 1])) ]
    
    
    dum=[i_head [i_head(2:end)-2; size(d2,1)]]
    dum2=[];
    dumc=[];
    for i=1:size(dum,1)
        ivec=[dum(i,1):dum(i,2)]'
        dum2=[dum2;  [       ivec        repmat(idx0(i,2),[ [length(ivec)]  1])  ]];
        dumc=[dumc ; repmat( col0(i,:), [length(ivec)   1])] ;
        
    end
    
    idx=[idx; dum2];
    col=[col; dumc];
    
    %======================================================
    
    
    file  = expout
    sheetname='A vs B'
    %=======================
end
%����������������������������������������������������������������������������������������������������


if 0
    lut=[...
        1.0000         0         0
        1.0000    0.8431         0
        0    1.0000         0
        0    1.0000    1.0000
        1.0000    1.0000         0
        1.0000         0    1.0000
        0.6000    0.2000         0
        0.9255    0.8392    0.8392
        0.7569    0.8667    0.7765
        0.9529    0.8706    0.7333
        1.0000    0.6000    0.6000];
    %=======================
    if isempty(col)
        rgb=lut(1:size(idx,1),:) ;
    else
        rgb=col;
    end
    
    
    
    %% convert to xls-color-style
    xcol=[];
    for i=1:size(rgb,1)
        rgb2=round(rgb(i,:).*255);
        rgb2(rgb2<0)=0;
        rgb2(rgb2>255)=255;
        binar=[dec2bin(rgb2(3),8)   dec2bin(rgb2(2),8) dec2bin(rgb2(1),8)];
        xcol(i,:)=bin2dec(binar);
        % Range.Interior.Color=xlscol
    end
    
    
    %% xls-cell-locations
    ab={};
    for i=65:90
        ab(end+1,1)={char(i)};
    end
    for i=1:6
        ab(:,end+1)=cellfun(@(a){[ ab{i,1} a  ]} , ab(:,1)  );
    end
    head=ab(:);
    xpos =cellfun(@(a,b){[ a num2str(b)  ]} , head(idx(:,2)), num2cell(idx(:,1))  );
    
    
end

%����������������������������������������������������������������������������������������������������
%%  open excelsheet




Excel = actxserver('excel.application');
WB = Excel.Workbooks.Open(file,0,false);


sheets = WB.Sheets;
numsheets = sheets.Count;
names = cell(1, numsheets);

%% delete SHEETS
for i = 1:numsheets
    names{i} = sheets.Item(i).Name;
end
try
    ix=find(strcmp(names,'Tabelle3'));
    if ~isempty(ix)
        sheets.Item('Tabelle3').Delete
    end
end
try
    ix=find(strcmp(names,'Tabelle2'));
    if ~isempty(ix)
        sheets.Item('Tabelle2').Delete
    end
end
try
    ix=find(strcmp(names,'Tabelle1'));
    if ~isempty(ix)
        sheets.Item('Tabelle1').Delete
    end
end

% ==============================================
%%
% ===============================================

sheets = WB.Sheets;
numsheets = sheets.Count;
names = cell(1, numsheets);
for i = 1:numsheets
    names{i} = sheets.Item(i).Name;
end
% numsheets = sheets.Count;
% if isnumeric(sheetname)==1
thissheet = get(sheets, 'Item', sheetname);
% else
%
% end

thissheet.Activate;



% ==============================================
%%   color and position
% ===============================================

ncol=thissheet.UsedRange.Columns.Count;
nrow=thissheet.UsedRange.Rows.Count;
% ==============================================
% char-elelment assignment: examples
% '[2:end],[1:2:end]'
% idx='[2:3:end],[2 5]'
% idx='[:],[2 5]'
% idx=':,[2 5]'
% idx='[2 5],2'
% idx='[1:2:end],[1:5:end]'
% idx='2:end,[4:5]';
% idx='2,5'
% ===============================================
str=idx;
if ischar(str)==1
    
    
%     idx='[2:end],[1:2:end]'
    %   idx='[2:3:end],[2 5]'
%     idx='[:],[2 5]'
    cv=zeros(nrow,ncol);
    rrow=str2num(strrep(str(1:strfind(str,',')),'end', num2str(nrow)));
    rcol=str2num(strrep(str(strfind(str,','):length(str)),'end', num2str(nrow)));
    if isempty(rrow); rrow=1:max(j); end
    if isempty(rcol); rcol=1:max(i); end
    
    dum=cv(rrow,:);
    dum(:,rcol)=1;
    cv(rrow,:)=dum;
    
    cv2=cv(:);
    [ic ir]=ind2sub(size(cv),find(cv2)) ;
    idx=[ic ir];
    
    %fg,imagesc(cv)
end

% ==============================================
%%  EXCEL-location-style
% ===============================================
%% xls-cell-locations
ab={};
for i=65:90
    ab(end+1,1)={char(i)};
end
for i=1:6
    ab(:,end+1)=cellfun(@(a){[ ab{i,1} a  ]} , ab(:,1)  );
end
head=ab(:);
xpos =cellfun(@(a,b){[ a num2str(b)  ]} , head(idx(:,2)), num2cell(idx(:,1))  );


% ==============================================
%%   color
% ===============================================
lut=[...
    1.0000         0         0
    1.0000    0.8431         0
    0    1.0000         0
    0    1.0000    1.0000
    1.0000    1.0000         0
    1.0000         0    1.0000
    0.6000    0.2000         0
    0.9255    0.8392    0.8392
    0.7569    0.8667    0.7765
    0.9529    0.8706    0.7333
    1.0000    0.6000    0.6000];


%=======================
if isempty(col)
    rgb=lut(1:size(idx,1),:) ;
else
    rgb=col;
end
%% convert to xls-color-style
if iscell(rgb);
    rgb=  cell2mat(rgb)
end
% if max(rgb(:))>1
%     error('color value-range must be between 0 and 1 !');
% end

xcol=[];
for i=1:size(rgb,1)
    rgb(find(rgb>1))=1;
    rgb2=round(rgb(i,:).*255);
    rgb2(rgb2<0)=0;
    rgb2(rgb2>255)=255;
    binar=[dec2bin(rgb2(3),8)   dec2bin(rgb2(2),8) dec2bin(rgb2(1),8)];
    xcol(i,:)=bin2dec(binar);
    % Range.Interior.Color=xlscol
end

% ==============================================
%%
% ===============================================





set(Excel.Selection.Font,'Size',8);
set(Excel.Selection.Font,'Name','Calibri');

% myCell = 'A3';
% Range = thissheet.Range(myCell)
% cellColor = Range.Interior.Color

% thissheet.Range(['A1:'  'X2']).Cell.Font.Bold=2;
% thissheet.Range(['A1:'  'A2000']).Cell.Font.Bold=2;
% % Set the color of cell "A1" of Sheet 1 to RED
% WB.Worksheets.Item(1).Range('A1').Interior.ColorIndex = 3;  %%  make 1st A1-cell red

% range=invoke(thissheet,'Range',['A1:X2' ]);
% borders=get(range,'Borders');
% borderspec=get(borders,'Item',4);
% set(borderspec,'ColorIndex',1);
% set(borderspec,'Linestyle',1);

invoke(thissheet.Columns,'AutoFit');

%%colorize cells
% myCell = 'A3';

if size(xcol,1)<size(xpos,1)
    xcol=repmat(xcol,[size(xpos,1) 1]);
end

for i=1:length(xcol)
    Range = thissheet.Range(xpos{i});
    Range.Interior.Color=xcol(i);
    Range.Cell.Font.Bold=2;
end

WB.Save();% Save Workbook
WB.Close();% Close Workbook
Excel.Quit();% Quit Excel

