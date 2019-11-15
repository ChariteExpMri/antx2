
%% MAKE xls-file if ATLAS.xls does not exist
% function filename=xls_atlas2xls(tb, filename )
%% —————————————————————————————————————————————————————————————————————————————————————————————————
%% INPUTS:
% tb:  cell arry with labels x 5 columns, the columns are:
%   'Region'    label of the region            (char)   ; exampple  'caudoputamen'
%   'colHex'    hexcolor such as 'FFFFFF'...   (char); otherwise leave empty
%   'colRGB'    RGB color (range 0-255)    (must be char!); example: ' 24 128 100' (as char); otherwise leave empty
%   'ID'        numeric ID in Atlas           (numeric);   exampke: 12
%   'Children'  children of a region,          (numeric),  leave empty if a region has no children; example:  [   12      153]
%
%   fragemntary example
%      tb={...%fragmentary example
%          'Gustatory areas, layer 6b'    '009C75'   '  0 156 117'    [ 662]    []
%          'Visceral area'                '11AD83'   ' 17 173 131'    [ 677]    [897	1106	1010	1058	857	849]}
%
% filename: -either FP-name of the corresponding NIFTI
%           - or name of the resulting XLSX-file
% niftifile: fullpath-filename of the corresponding atlas ( nifti file).. (only used to get the path and the name of the nifti)
%        -the excelfile is than stored in the same folder as the atlas
%              example: mypath/ANO.nii -->  excelfile of atlas os 'mypath/ANO.xls'
%% example
%     tb      =s.atlasTB;
%     xls_atlas2xls(tb,fullfile(s.patemp,'ANO.nii'))
%% example-2
%     tb      =s.atlasTB;
%     xls_atlas2xls(tb,fullfile(s.patemp,'ANO.xlsx'))
%% —————————————————————————————————————————————————————————————————————————————————————————————————



% tbh: (cell) header of tb with { 'Region'    'colHex'    'colRGB'    'ID'  'Children'}



function filename=xls_atlas2xls(tb, niftifile )


% ==============================================
%%   example
% ===============================================

if 0
    
    tic
    tb      =s.atlasTB;
    volAtlas=fullfile(s.patemp,'ANO.nii');
    filename=xls_atlas2xls(tb,volAtlas)
    toc
    
end

% ==============================================
%%   checks/ outputfile
% ===============================================

warning off;
filename=''; %outputfile

[pas fis ext]=fileparts(niftifile);
if strcmp(ext,'.nii')
    if exist(niftifile)~=2;
        error('no (atlas) nifti file found ');
    end
    [pa name ext] = fileparts(niftifile);
    filename      =fullfile(pa,[name '.xlsx']);         %filename   =fullfile(pwd,'ANO.xls')
    
else
     [pa name ext] = fileparts(niftifile);
     if isempty(pa); pa=pwd; end
    filename      =fullfile(pa,[name '.xlsx']);
end
% ==============================================
%%   write xls-table
% ===============================================

try; delete(filename); end
sheetname    ='atlas'   ;
% tb=s.atlasTB;

tb2=tb;
ch  =tb2(:,5);
ch2 =cellfun(@(a) { regexprep( num2str(a(:)'),'\s+',';') } ,ch);
tb2(:,5)=ch2;
tbh={ 'Region'    'colHex'    'colRGB'    'ID'  'Children'} ;

xlswrite(filename, [tbh;tb2 ] ,sheetname);
% fiout=filename;

%% CHECK EXCEL-STATUS
[~,sheets,infoXls]=xlsfinfo(filename);
if ~isempty(infoXls)
    isexcel=1;
else
    isexcel=0;
end

%% —————————————————————————————————————————————————————————————————————————————————————————————————

if isexcel==0; return; end
    

% RREMOVE DEFAULT SHEETS
xlsremovdefaultsheets(filename);





%% —————————————————————————————————————————————————————————————————————————————————————————————————
%% colorize and pimp up
%% —————————————————————————————————————————————————————————————————————————————————————————————————

% ==============================================
%% HEX/RGB or no color
% ===============================================

colmode=0;
if ~isempty(tb{1,2}); colmode=1; end
if ~isempty(tb{1,3}); colmode=2; end


% if colmode==0; return; end


if colmode~=0
    %HEX OR RGB color
    col=zeros([size(tb,1) ,3]);
    if colmode==1             %#HEX
        for i=1:size(tb,1);
            hexString=tb{i,2};
            r = double(hex2dec(hexString(1:2)))/255;
            g = double(hex2dec(hexString(3:4)))/255;
            b = double(hex2dec(hexString(5:6)))/255;
            rgb = [r, g, b];
            col(i,:)=rgb;
        end
    elseif colmode==2       %# RGB (0-255)
        if ischar(tb{1,3})
            col= str2num(char(tb(:,3)))./255;
        else
            col=cell2mat(tb(:,3))/255;
        end
    end
    
    rgb      =[[1 1 1]; col]; %add header
    
    
    
    
    
    
    
    % function colorizeExcelsheet(filename,  colorhex)
    % colorhex={idxLUT(:).color_hex_triplet}
    % rgb=[];
    % for i=1:length(colorhex)
    %     hexString=colorhex{i};
    %     r = double(hex2dec(hexString(1:2)))/255;
    %     g = double(hex2dec(hexString(3:4)))/255;
    %     b = double(hex2dec(hexString(5:6)))/255;
    %     rgb(i,:) = [r, g, b];
    % end
    % rgb=[1 1 1; 1 1 1 ;rgb];%add colored Header
    % rgb=[rgb];%add colored Header
    
    
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
    
    
end

% ==============================================
%%   open excep
% ===============================================


Excel = actxserver('excel.application');
WB    = Excel.Workbooks.Open(filename,0,false);


% ==============================================
%%   colorize
% ===============================================

sheets = WB.Sheets;

targetsheet=(get(sheets,'item',sheetname));
numsheets=1;
% numsheets = sheets.Count;


for i=1:numsheets
    
    thissheet = get(sheets, 'Item', i);
    thissheet.Activate;
    
    set(Excel.Selection.Font,'Size',8);
    set(Excel.Selection.Font,'Name','Calibri');
    
    % myCell = 'A3';
    % Range = thissheet.Range(myCell)
    % cellColor = Range.Interior.Color
    
    thissheet.Range(['A1:'  'X1']).Cell.Font.Bold=2;
    thissheet.Range(['A1:'  'A2000']).Cell.Font.Bold=2;
    % Set the color of cell "A1" of Sheet 1 to RED
    WB.Worksheets.Item(1).Range('A1').Interior.ColorIndex = 3;
    
    range=invoke(thissheet,'Range',['A1:X1' ]);
    borders=get(range,'Borders');
    borderspec=get(borders,'Item',4);
    set(borderspec,'ColorIndex',1);
    set(borderspec,'Linestyle',1);
    
    invoke(thissheet.Columns,'AutoFit');
    
    %%colorize
    % myCell = 'A3';
    
    if colmode~=0
        for j=1:length(xcol)
            Range = thissheet.Range(co{j});
            Range.Interior.Color=xcol(j);
        end
    end
    
    
    %% delete ending rows
    sdelstart=num2str([size(tb,1)+5]);
    %     range=invoke(thissheet,'Range',['A1500:A65536' ]);
    range=invoke(thissheet,'Range',['A' sdelstart ':A65536' ]);
    range.EntireRow.Delete;
    %     thissheet.Range('A1500:A65536').Select
    %     Excel.Selection.SpecialCells(xlCellTypeBlanks).EntireRow.Delete
    %     for j=2000:thissheet.rows.Count
    %
    % range=invoke(thissheet,'Range',['A1:A1206' ]);
    %  range.Copy
    % range2=invoke(thissheet,'Range',['B1:B1206' ]);
    % range2.Select
    %
    %
    
    if 1
        if 1 %FREEZE
            
            
            Excel.ActiveWindow.FreezePanes = 0;
            Excel.Range('2:2').Select;
            Excel.ActiveWindow.FreezePanes = 1;
        end
        
        
        %         thissheet.Range('2:2').Select;
        %         thissheet.ActiveWindow.FreezePanes = 1;
    end
    
    %     Excel.ActiveWindow.SplitRow     = 2;
    % Excel.ActiveWindow.SplitColumn  = 1;
    % Excel.ActiveWindow.FreezePanes  = 1;
    
    thissheet.Range('B3').Select;
    
    % thissheet.Range([  'A1:A12' ]).Copy
    % s=thissheet.Range(['B1:B12' ])
    % v=s.Select
    %
    % Sheets = Excel.ActiveWorkBook.Sheets;
    %  new_sheet = Sheets.Add;
    % thissheet.PasteSpecial(nan, nan, nan, true);
    %
    %  curr_sheet = get(Workbook,'ActiveSheet');
    %    rngObj = ('A1:C3')
    %    rngObj.Copy
    %    Sheets = Excel.ActiveWorkBook.Sheets;
    %    new_sheet = Sheets.Add;
    %    new_sheet.PasteSpecial; %This is where I am stuck!
    %
    %
    %
    % % .PasteSpecial.xlPasteAll
    % % set(s,'Pastespecial','xlPasteFormats')
    %
    % thissheet.PasteSpecial(true, true, true, true);
    %
    % invoke(Excel.Selection,'PasteSpecial','Paste:=xlPasteFormats, Operation:=xlNone, SkipBlanks:=False');
    %
    % set(s.PasteSpecial,'Operation','xlNone')
    % set(thissheet,'Paste','xlPasteFormats')
    %
    % Selection.PasteSpecial Paste:=xlPasteFormats, Operation:=xlNone, SkipBlanks:=False
    %
    % invoke(s.PasteSpecial,'xlPasteAll' )
    %
    % Sheets("AdminSettings").Range("4:5").Copy
    % Sheets(SheetName).Range("A1").PasteSpecial xlPasteAll
    % Sheets(SheetName).Range("A1").PasteSpecial xlPasteColumnWidth
    
end



WB.DoNotPromptForConvert = true;
WB.CheckCompatibility = false;
WB.Save();% Save Workbook
WB.Close();% Close Workbook
Excel.Quit();% Quit Excel

try
 showinfo2('EXCEL-file created',filename);
end
