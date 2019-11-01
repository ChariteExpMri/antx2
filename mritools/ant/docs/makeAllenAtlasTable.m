


%———————————————————————————————————————————————
%%   make allenAtlas TABLE (xlsfile)
% saves regions, ids, children as excelfile
%———————————————————————————————————————————————

if 1
    
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    xx = load('gematlabt_labels.mat');
    [table idxLUT] = buildtable(xx.matlab_results{1}.msg{1});
    
    t=idxLUT;
    
    %———————————————————————————————————————————————
    %%   mk tabel
    %———————————————————————————————————————————————
    tb={};
    for i=1:length(t)
        disp(i);
        name=t(i).name;
        id=t(i).id;
        childs=t(i).children;
        colhex=t(i).color_hex_triplet;
        parent=t(i).parent_structure_id;
        
        if isempty(childs)
            childs='';
        else
            childs=regexprep(num2str(childs'),'\D+',',');
        end
        tb(i,:)=...
            {name colhex id childs};% colhex parent} ;
    end
    
    %% RGB color
    col=zeros([size(tb,1) ,3]);
    for i=1:size(tb,1);
        hexString=tb{i,2};
        r = double(hex2dec(hexString(1:2)))/255;
        g = double(hex2dec(hexString(3:4)))/255;
        b = double(hex2dec(hexString(5:6)))/255;
        rgb = [r, g, b];
        col(i,:)=rgb;
    end
    
    %%
    
    %
    % t2=struct2cell(t');
%     xlswrite('test.xls',tb,'test1');
    %
    
    tbh={'region' 'HexColor', 'ID' 'children'};
    
    
    outfile    = fullfile(pwd,'AllenAtlas.xls');
    sheetname  = 'AllenAtlas';
    pwrite2excel(outfile,{1 sheetname},tbh,[],tb);
    
    
    
    sheet2='info'
    
    info={'ALLEN-ATLAS'};
    info(end+1,:)={'# The IDs refer to the number in the Atlas' };
    info(end+1,:)={'# Compare IDs with online-Atlas:'};
    info(end+1,:)={'   see: http://atlas.brain-map.org/atlas#atlas=1&plate=100960365&structure=672&x=5279.75&y=3743.75&zoom=-3&resolution=16.75&z=6'};
    info(end+1,:)={'   the webpage link contains the "ID" after the "structure="-tag ... see above link'  };
    info(end+1,:)={'example: ID of caudoputamen is 672 --> online link is "..structure=672.." '};
    info(end+1,:)={' ' };
    info(end+1,:)={'ALTERNATIVE WAY: USE THE MATLAB STRUCTURE: ' };
    info(end+1,:)={'   xx = load(''gematlabt_labels.mat'');' };
    info(end+1,:)={'  [table idxLUT] = buildtable(xx.matlab_results{1}.msg{1});' };
    info(end+1,:)={' --> were: idxLUT contains the information for each region  ' };
    
     pwrite2excel(outfile,{2 sheet2},{'INFO'},[],info);
    
   
end

rgb      =[[1 1 1]; col]; %add header
filename=outfile;
sheetname=sheetname;
%%
%———————————————————————————————————————————————
%%   colorize excelsheet
%———————————————————————————————————————————————

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




% tpl=fullfile(pwd,'test.xls')
Excel = actxserver('excel.application');
WB = Excel.Workbooks.Open(filename,0,false);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
sheets = WB.Sheets;
numsheets = sheets.Count;
names = cell(1, numsheets);
%del SHEETS
for i = 1:numsheets
    names{i} = sheets.Item(i).Name;
end
ix=find(strcmp(names,'Tabelle3'));
if ~isempty(ix)
    sheets.Item('Tabelle3').Delete;
end
ix=find(strcmp(names,'Tabelle2'));
if ~isempty(ix)
    sheets.Item('Tabelle2').Delete;
end
ix=find(strcmp(names,'Tabelle1'));
if ~isempty(ix)
    sheets.Item('Tabelle1').Delete;
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
sheets = WB.Sheets;

targetsheet=(get(sheets,'item',sheetname))
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
    
    for j=1:length(xcol)
        Range = thissheet.Range(co{j});
        Range.Interior.Color=xcol(j);
    end
    
    
    %% delete ending rows
    sdelstart=num2str([length(rgb)+5]);
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





